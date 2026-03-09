package com.game.modules.control
{
   import com.channel.ChannelEvent;
   import com.channel.ChannelPool;
   import com.channel.Message;
   import com.core.observer.MessageEvent;
   import com.core.view.ViewConLogic;
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.global.GlobalConfig;
   import com.game.locators.CacheData;
   import com.game.locators.GameData;
   import com.game.locators.MsgDoc;
   import com.game.manager.AlertManager;
   import com.game.modules.action.MouseEnableView;
   import com.game.modules.action.SwfAction;
   import com.game.modules.ai.AlphaArea;
   import com.game.modules.ai.SpecialAreaManager;
   import com.game.modules.control.battle.NewBattleControl;
   import com.game.modules.parse.ShowDataParse;
   import com.game.modules.view.FaceView;
   import com.game.modules.view.MapView;
   import com.game.modules.view.SelectServer;
   import com.game.modules.view.login.LoginView;
   import com.game.modules.vo.PlayerData;
   import com.game.util.AwardAlert;
   import com.game.util.CacheUtil;
   import com.game.util.ChractorFilter;
   import com.game.util.DateUtil;
   import com.game.util.GameDynamicUI;
   import com.game.util.LoginInterFace;
   import com.game.util.ReConnectStatus;
   import com.game.util.SceneSoundManager;
   import com.game.util.ShareLocalUtil;
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.alert.Alert;
   import com.publiccomponent.loading.GreenLoading;
   import com.publiccomponent.loading.Loading;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.external.ExternalInterface;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.utils.clearInterval;
   import flash.utils.clearTimeout;
   import flash.utils.setInterval;
   import flash.utils.setTimeout;
   import org.green.server.core.GreenSocket;
   import org.green.server.data.MsgPacket;
   import org.green.server.events.MsgEvent;
   import org.green.server.manager.SocketManager;
   import org.plat.monitor.PlatMonitorLog;
   import phpcon.PhpConnection;
   
   public class LoginViewControl extends ViewConLogic
   {
      
      public static const NAME:String = "loginViewControl";
      
      private var socket:GreenSocket;
      
      private var loading:Loading;
      
      private var serverId:int;
      
      private var isRepeatLogin:Boolean;
      
      private var userParams:Object;
      
      private var newHandClip:MovieClip;
      
      private var spriteId:int;
      
      private var loginInter:LoginInterFace;
      
      private var tid:int;
      
      private var logtid:int;
      
      private var isSeeDonghua:Boolean;
      
      private var isHandClose:Boolean;
      
      private var loginId:Boolean = false;
      
      private var loopcount:int = 0;
      
      private var noAnswerid:int;
      
      private var sdp:ShowDataParse = new ShowDataParse();
      
      private var loststr:Array = ["飞船受到寒流影响，刚才出现颠簸，你掉线了。","我成功袭击了叮叮的飞船，你好好享受掉线的滋味吧。——晓蛟教授","刚才冰龙神打了个喷嚏，你掉线了。"];
      
      private var flag:Boolean = false;
      
      public function LoginViewControl(viewComponent:Object = null)
      {
         super(NAME,viewComponent);
         this.socket = SocketManager.getGreenSocket();
         this.loading = GreenLoading.loading;
         this.addConListen();
         this.addFlashListener();
         this.loginInter = new LoginInterFace();
         this.tid = setTimeout(this.directConnectServer,400);
      }
      
      private function addConListen() : void
      {
         this.socket.addEventListener(GreenSocket.CONNECTTED,this.onConnected);
         this.socket.addEventListener(GreenSocket.CONNECTION_ERROR,this.onDisConnect);
         this.socket.attachSocketListener(MsgDoc.OP_CLIENT_CHECK_ACCOUNT.back,this.onRequestLoginBack);
         this.socket.attachSocketListener(MsgDoc.OP_CLIENT_CREATE_ROLE.back,this.onCreateRoleBack);
         this.socket.attachSocketListener(MsgDoc.OP_CLIENT_REQ_WORLD_NUM.back,this.onRequestWordNumBack);
         this.socket.attachSocketListener(MsgDoc.OP_CLIENT_REQ_WORLD_LIST.back,this.onRequestWorldListBack);
         this.socket.attachSocketListener(MsgDoc.OP_GATEWAY_PLAYER_INSTEAD.back,this.onRepeatLogin);
         this.socket.attachSocketListener(MsgDoc.OP_CLIENT_REQ_ENTER_WORLD.back,this.onEnterWorldBack);
         this.socket.attachSocketListener(MsgDoc.OP_CLIENT_CHECK_REPEATNAME.back,this.onCheckNameBack);
         this.socket.attachSocketListener(MsgDoc.OP_CLIENT_NEWHAND.back,this.onNewHandBack);
         this.socket.attachSocketListener(MsgDoc.OP_CLIENT_GETTUIJIAN.back,this.getTuiJianBack);
      }
      
      private function addFlashListener() : void
      {
         ChannelPool.getChannel("newhand").addChannelListener("startgame",this.startGame);
         ChannelPool.getChannel("newhand").addChannelListener("logingame",this.loginGame);
         ChannelPool.getChannel("newhand").addChannelListener("exitplay",this.playOver);
         ChannelPool.getChannel("newhand").addChannelListener("createrole",this.createRoleFlash);
         ChannelPool.getChannel("newhand").addChannelListener("checkname",this.checkName);
         ChannelPool.getChannel("newhand").addChannelListener("cnewhand1",this.cNewHandOneStep);
         ChannelPool.getChannel("newhand").addChannelListener("onclickbaoxiang",this.onClickBaoXiang);
         ChannelPool.getChannel("newhand").addChannelListener("startfight",this.startFight);
         ChannelPool.getChannel("newhand").addChannelListener("zhiyinover",this.zhiYinOver);
         ChannelPool.getChannel("newhand").addChannelListener("gotoziyuan",this.gotoZiyuanCang);
      }
      
      private function directConnectServer() : void
      {
         clearTimeout(this.tid);
         if(GlobalConfig.isCrossPlat)
         {
            this.go();
         }
         else
         {
            this.view.load("assets/login/start.swf?v=" + URLUtil.startVer);
         }
      }
      
      private function go() : void
      {
         this.loginServer();
      }
      
      private function startGame(evt:ChannelEvent) : void
      {
         var param:Object = evt.getMessage().getBody();
         switch(param.type)
         {
            case 0:
               this.getURL("//news.4399.com/login/kbxy.html?reg=0&pass=1&v=" + new Date().valueOf().toString(),"_self");
               break;
            case 1:
               this.view.loadExt(URLUtil.getSvnVer("assets/login/bigperson.swf"));
               break;
            case 3:
               this.getURL("//news.4399.com/login/kbxy.html?reg=1&pass=1&v=" + new Date().valueOf().toString(),"_self");
               break;
            case 2:
               if(ExternalInterface.available)
               {
                  ExternalInterface.call("addToFavorites");
               }
               break;
            case 4:
               if(ExternalInterface.available)
               {
                  ExternalInterface.call("createDesktopShortcut");
               }
         }
      }
      
      private function loginGame(evt:ChannelEvent) : void
      {
         this.userParams = evt.getMessage().getBody();
         if(this.userParams.id.length == 0)
         {
            AlertManager.instance.showTipAlert({
               "systemid":1054,
               "flag":1
            });
            return;
         }
         if(this.userParams.pass.length == 0)
         {
            AlertManager.instance.showTipAlert({
               "systemid":1054,
               "flag":2
            });
            return;
         }
         GlobalConfig.userPass = this.userParams.pass;
         GlobalConfig.userName = this.userParams.id;
         GlobalConfig.userName = ChractorFilter.removeSpceialChar(GlobalConfig.userName);
         this.startGreenGame(null);
      }
      
      private function getURL(url:String, window:String = "_blank") : void
      {
         ExternalInterface.call("window.open(\"" + url + "\",\"" + window + "\")");
      }
      
      private function logOutBack(params:Object) : void
      {
         this.loginInter.login(GlobalConfig.userName,GlobalConfig.userPass,this.loginPlatBack);
      }
      
      private function loginPlatBack(params:Object) : void
      {
         GameDynamicUI.removeUI("loading");
         if(params.code == 100)
         {
            GlobalConfig.token = params.result;
            this.loginServer();
         }
         else
         {
            PlatMonitorLog.instance.writeNewLog(103,params.code);
            new Alert().showOne(params.result + "");
         }
      }
      
      private function loginServer() : void
      {
         GameDynamicUI.addUI(this.view.stage,200,200,"loading");
         if(this.userParams == null)
         {
            this.userParams = {};
            this.userParams.flag = 1;
            this.userParams.id = ChractorFilter.removeSpceialChar(GlobalConfig.userName);
            this.userParams.pass = GlobalConfig.userPass;
         }
         GlobalConfig.userName = ChractorFilter.removeSpceialChar(GlobalConfig.userName);
         if(this.socket.isConnect())
         {
            this.onConnected(null);
         }
         else
         {
            this.loopConnect();
            this.tid = setInterval(this.loopConnect,5000);
            this.logtid = setInterval(this.logtimeout,5000);
         }
      }
      
      private function startGreenGame(evt:MessageEvent) : void
      {
         GameDynamicUI.addUI(this.view.stage,200,200,"loading");
         if(this.loginId)
         {
            this.loginServer();
         }
         else
         {
            this.loginInter.login(GlobalConfig.userName,GlobalConfig.userPass,this.loginPlatBack);
         }
      }
      
      private function logtimeout() : void
      {
         clearInterval(this.logtid);
         PlatMonitorLog.instance.writeNewLog(201);
      }
      
      private function verifyBack(body:Object) : void
      {
         if(body.code == 100)
         {
            this.socket.sendCmd(MsgDoc.OP_CLIENT_CHECK_ACCOUNT.send,300,[int(body.result.uid),int(body.result.time),body.result.token + ""]);
         }
         else
         {
            AlertManager.instance.showTipAlert({
               "systemid":1054,
               "flag":3,
               "stage":this.view.stage
            });
         }
      }
      
      private function loopConnect() : void
      {
         var port:int = 0;
         ++this.loopcount;
         if(GlobalConfig.server == "kbxy.wanwan4399.com")
         {
            port = int(Math.random() * 20) + 12001;
            GlobalConfig.port = port;
         }
         if(this.loopcount == 4)
         {
            if(Boolean(this.socket))
            {
               this.socket.close();
            }
            PlatMonitorLog.instance.writeNewLog(202);
            clearInterval(this.tid);
            GlobalConfig.server = "115.182.52.226";
            GlobalConfig.port = int(Math.random() * 20) + 12001;
         }
         if(Boolean(this.socket))
         {
            this.socket.connect(GlobalConfig.server,GlobalConfig.port);
         }
      }
      
      private function createRoleFlash(evt:ChannelEvent) : void
      {
         var params:Object = evt.getMessage().getBody();
         var sendInt:int = int(params.sex);
         GameData.instance.playerData.sex = int(params.sex);
         var color:int = int(params.color) << 1;
         sendInt |= color;
         this.socket.sendCmd(MsgDoc.OP_CLIENT_CREATE_ROLE.send,0,[sendInt,ShareLocalUtil.instance.getLatestInviteId(),params.userName]);
      }
      
      private function checkName(evt:ChannelEvent) : void
      {
         var obj:Object = evt.getMessage().getBody();
         GameData.instance.playerData.userName = obj.userName;
         if(obj == null || obj.userName == null)
         {
            return;
         }
         if(obj.userName.length < 2)
         {
            AlertManager.instance.showTipAlert({
               "systemid":1054,
               "flag":4,
               "stage":this.view.stage
            });
            dispatch(EventConst.SENDMSGTOSWF,{
               "msgname":"oncreateRoleBack",
               "body":0,
               "radio":"newhand"
            });
            return;
         }
         if(obj.userName.length > 8)
         {
            AlertManager.instance.showTipAlert({
               "systemid":1054,
               "flag":12,
               "stage":this.view.stage
            });
            dispatch(EventConst.SENDMSGTOSWF,{
               "msgname":"oncreateRoleBack",
               "body":0,
               "radio":"newhand"
            });
            return;
         }
         if(!ChractorFilter.ableName(obj.userName))
         {
            dispatch(EventConst.SENDMSGTOSWF,{
               "msgname":"oncreateRoleBack",
               "body":0,
               "radio":"newhand"
            });
            AlertManager.instance.showTipAlert({
               "systemid":1054,
               "flag":5,
               "stage":this.view.stage
            });
            return;
         }
         new Message("createrole",obj).sendToChannel("newhand");
      }
      
      private function onCheckNameBack(evt:MsgEvent) : void
      {
         if(evt.msg.mParams != 0)
         {
            PlatMonitorLog.instance.writeNewLog(206,evt.msg.mParams);
         }
         switch(evt.msg.mParams)
         {
            case -2:
            case -3:
               AlertManager.instance.showTipAlert({
                  "systemid":1054,
                  "flag":evt.msg.mParams,
                  "stage":this.view.stage
               });
               break;
            case 0:
               ShareLocalUtil.instance.setAttribute(GlobalConfig.userName,"roleName",GameData.instance.playerData.userName);
               ShareLocalUtil.instance.flush();
               dispatch(EventConst.SENDMSGTOSWF,{
                  "msgname":"checknameback",
                  "body":null,
                  "radio":"newhand"
               });
         }
      }
      
      override public function listEvents() : Array
      {
         return [[EventConst.GETSERVERLIST,this.requestWorldList],[EventConst.SELECTSERVER,this.requestEnterWorld],[EventConst.EEQ_PLAYERS_LIST,this.requestPlayersList],[EventConst.REQ_NPCS_LIST,this.requestNpcsList],[EventConst.LOGINGAMEBACK,this.loginGameBack],[EventConst.NEWHANDSTART,this.newHandStart],[EventConst.TASKTOFRESHMANGUIDE,this.taskNext],[EventConst.ENABLETASKBTN,this.enableTaskBtn],[EventConst.GETTUIJIANSERVERLIST,this.getTuiJianServerList],[EventConst.REQUESTWORLD_NUM,this.requestWorldNum],[EventConst.OPENCREATEROLEVIEW,this.openFaceView],[EventConst.START_GREEN_GAME,this.startGreenGame]];
      }
      
      private function openFaceView(evt:MessageEvent) : void
      {
         this.view.load(URLUtil.getSvnVer("assets/system/newHand/roleChoice/NewHandRoleChoice.swf"));
      }
      
      private function loginGameHandler(event:Event) : void
      {
         this.socket.connect(GlobalConfig.server,GlobalConfig.port);
      }
      
      private function requestPlayersList(event:MessageEvent) : void
      {
         var sceneId:int = GameData.instance.playerData.sceneId;
         if(sceneId == 901 || sceneId == 902 || sceneId == 903)
         {
            return;
         }
         sendMessage(MsgDoc.OP_CLIENT_REQ_SCENE_PLAYER_LIST.send);
      }
      
      private function requestNpcsList(event:MessageEvent) : void
      {
         sendMessage(MsgDoc.OP_CLIENT_NPC_LIST.send);
      }
      
      private function onRepeatLogin(evt:MsgEvent) : void
      {
         PlatMonitorLog.instance.writeNewLog(205);
         dispatch(EventConst.BATTLE_RELOGIN);
         this.isRepeatLogin = true;
         AlertManager.instance.showTipAlert({
            "systemid":1054,
            "flag":8,
            "callback":this.closeHandler
         });
      }
      
      private function closeHandler(type:String, data:Object) : void
      {
         if(ExternalInterface.available)
         {
            ExternalInterface.call("closeshow");
            if(GlobalConfig.isClient)
            {
               navigateToURL(new URLRequest("javascript:window.parent.location.href=\'http://enter.wanwan4399.com/bin-debug/KBgameindex.html\'"),"_self");
            }
            else
            {
               navigateToURL(new URLRequest("javascript:window.parent.location.href=\'http://www.4399.com/flash/48399.htm\'"),"_self");
            }
         }
      }
      
      private function onCreateRoleBack(evt:MsgEvent) : void
      {
         switch(evt.msg.mParams)
         {
            case 0:
               ShareLocalUtil.instance.setAttribute(GlobalConfig.userName,"body",1000 + GameData.instance.playerData.sex * 10 + 1);
               ShareLocalUtil.instance.flush();
               this.requestWorldNum();
               this.view.visible = false;
               dispatch(EventConst.SENDMSGTOSWF,{
                  "msgname":"checknameback",
                  "body":null,
                  "radio":"newhand"
               });
               dispatch(EventConst.SENDMSGTOSWF,{
                  "msgname":"oncreateRoleBack",
                  "body":1,
                  "radio":"newhand"
               });
               this.loginInter.sendToPbh(GlobalConfig.userName,GlobalConfig.userId,"api/newhand.php",2);
               break;
            case -4:
               dispatch(EventConst.SENDMSGTOSWF,{
                  "msgname":"oncreateRoleBack",
                  "body":0,
                  "radio":"newhand"
               });
               AlertManager.instance.showTipAlert({
                  "systemid":1054,
                  "flag":-2,
                  "stage":this.view.stage
               });
               break;
            default:
               PlatMonitorLog.instance.writeNewLog(301,evt.msg.mParams);
               this.loading.visible = false;
         }
      }
      
      private function requestWorldNum(evt:MessageEvent = null) : void
      {
         this.socket.sendCmd(MsgDoc.OP_CLIENT_REQ_WORLD_NUM.send,0,null);
      }
      
      private function onRequestWordNumBack(evt:MsgEvent) : void
      {
         ReConnectStatus.instance.HAS_REQUEST_WORLD_NUM = true;
         this.loading.visible = false;
         GameData.instance.playerData.totalServerNum = evt.msg.mParams;
         if(ReConnectStatus.instance.isDisConnectInGame())
         {
            this.socket.sendCmd(MsgDoc.OP_CLIENT_REQ_WORLD_LIST.send,1);
         }
         else
         {
            dispatch(EventConst.OPENSELECTSERVER);
         }
      }
      
      private function getTuiJianServerList(evt:MessageEvent) : void
      {
         this.socket.sendCmd(MsgDoc.OP_CLIENT_GETTUIJIAN.send,0,[evt.body.sid1,evt.body.sid2]);
      }
      
      private function getTuiJianBack(evt:MsgEvent) : void
      {
         var i:int = 0;
         var obj:Object = null;
         ReConnectStatus.instance.HAS_REQUEST_WORLD_LIST = true;
         this.loading.visible = false;
         var num:int = evt.msg.mParams;
         var serverList:Array = [];
         if(num < 50)
         {
            for(i = 0; i < num; i++)
            {
               obj = {};
               obj.sid = evt.msg.body.readInt();
               obj.serverName = evt.msg.body.readUTF();
               obj.onlineNumber = evt.msg.body.readInt();
               serverList.push(obj);
            }
            dispatch(EventConst.SHOWSERVERLIST,{
               "worldList":serverList,
               "lastsid":0
            });
         }
         else
         {
            PlatMonitorLog.instance.writeNewLog(303);
            GameDynamicUI.removeUI("loading");
            AlertManager.instance.showTipAlert({
               "systemid":1054,
               "flag":9,
               "replace":num,
               "callback":this.closeHandler
            });
         }
      }
      
      public function requestWorldList(event:MessageEvent) : void
      {
         var params:Object = event.body;
         var code:int = 1000;
         this.socket.sendCmd(MsgDoc.OP_CLIENT_REQ_WORLD_LIST.send,code);
      }
      
      private function onRequestWorldListBack(evt:MsgEvent) : void
      {
         var i:int = 0;
         var lastsid:int = 0;
         var obj:Object = null;
         this.loading.visible = false;
         var serverList:Array = [];
         var totalNum:int = evt.msg.body.readShort();
         GameDynamicUI.removeUI("loading");
         if(totalNum < 2000)
         {
            for(i = 0; i < totalNum; i++)
            {
               obj = {};
               obj.sid = evt.msg.body.readInt();
               obj.serverName = evt.msg.body.readUTF();
               obj.onlineNumber = evt.msg.body.readInt();
               serverList.push(obj);
            }
            lastsid = evt.msg.body.readInt();
            if(ReConnectStatus.instance.isDisConnectInGame())
            {
               this.socket.sendCmd(MsgDoc.OP_CLIENT_REQ_ENTER_WORLD.send,GameData.instance.playerData.serverId);
            }
            else
            {
               dispatch(EventConst.SHOWSERVERLIST,{
                  "worldList":serverList,
                  "lastsid":lastsid
               });
            }
         }
         else
         {
            AlertManager.instance.showTipAlert({
               "systemid":1054,
               "flag":10,
               "replace":totalNum
            });
         }
      }
      
      public function requestEnterWorld(event:MessageEvent) : void
      {
         this.view.visible = true;
         this.view.unload();
         this.serverId = int(event.body);
         this.socket.sendCmd(MsgDoc.OP_CLIENT_REQ_ENTER_WORLD.send,this.serverId);
         this.noAnswerid = setTimeout(this.enterWorldNoAnswer,30000);
      }
      
      private function enterWorldNoAnswer() : void
      {
         ReConnectStatus.instance.SRV_FAILD = true;
         clearTimeout(this.noAnswerid);
         this.socket.sendCmd(1186564);
         GameDynamicUI.removeUI("loading");
         try
         {
            this.socket.close();
         }
         catch(e:*)
         {
         }
         if(ExternalInterface.available)
         {
            ExternalInterface.call("closeshow");
            if(GlobalConfig.isClient)
            {
               navigateToURL(new URLRequest("javascript:window.parent.location.href=\'http://enter.wanwan4399.com/bin-debug/KBgameindex.html\'"),"_self");
            }
            else
            {
               navigateToURL(new URLRequest("javascript:window.parent.location.href=\'http://www.4399.com/flash/48399.htm\'"),"_self");
            }
         }
      }
      
      private function loadComplement(disPlay:Loader) : void
      {
         this.loading.visible = false;
         this.newHandClip = disPlay.content as MovieClip;
         this.newHandClip.addFrameScript(this.newHandClip.totalFrames - 1,this.playOver);
         this.newHandClip.addEventListener(Event.ADDED_TO_STAGE,this.onAddToStage);
         this.view.stage.addChild(this.newHandClip);
      }
      
      private function onAddToStage(evt:Event) : void
      {
         this.newHandClip.gotoAndPlay(2);
         if(this.newHandClip != null)
         {
            this.newHandClip.removeEventListener(Event.ADDED_TO_STAGE,this.onAddToStage);
         }
      }
      
      private function playOver(evt:Event = null) : void
      {
         this.isSeeDonghua = true;
         this.view.unload();
         this.newHandClip.stop();
         this.newHandClip.parent.removeChild(this.newHandClip);
         this.newHandClip = null;
         if(GameData.instance.playerData.hasLogin)
         {
            dispatch(EventConst.CLEARUI);
            dispatch(EventConst.ENTERSCENE,GameData.instance.playerData.sceneId);
         }
         else
         {
            GameData.instance.playerData.hasLogin = true;
            dispatch(EventConst.ENTER_WORLD_BACK);
         }
      }
      
      private function initMute() : void
      {
      }
      
      public function setMute(mute:Boolean) : void
      {
         if(mute)
         {
            SceneSoundManager.getInstance().openSound();
         }
         else
         {
            SceneSoundManager.getInstance().closeSound();
         }
         if(ExternalInterface.available)
         {
            ExternalInterface.addCallback("setMuteFromJS",this.setMute);
         }
      }
      
      private function onEnterWorldBack(evt:MsgEvent) : void
      {
         var v:SelectServer = null;
         var currentMsg:MsgPacket = null;
         var lsid:int = 0;
         var code:int = 0;
         var privatekey:int = 0;
         O.traceSocket(evt);
         clearTimeout(this.noAnswerid);
         GameData.instance.playerData.copyScene = 0;
         dispatch(EventConst.BATTLE_COUNTER);
         ReConnectStatus.instance.HAS_REQUEST_ENTER_WORLD = true;
         ReConnectStatus.instance.IS_IN_CHANGLINE_STATE = false;
         this.view.visible = false;
         GameDynamicUI.removeUI("loading");
         if(evt.msg.mParams == -200)
         {
            PlatMonitorLog.instance.writeNewLog(304);
            v = CacheUtil.pool[SelectServer];
            if(Boolean(v))
            {
               v.enterServerBack(1);
            }
            else
            {
               dispatch(EventConst.OPENSELECTSERVER);
            }
            return;
         }
         CacheUtil.deleteObject(SelectServer);
         var playerData:PlayerData = GameData.instance.playerData;
         if(evt.msg.mParams == 0)
         {
            currentMsg = evt.msg;
            playerData.timeleft = currentMsg.body.readInt() * 1000;
            playerData.isNewHand = currentMsg.body.readInt();
            playerData.coin = currentMsg.body.readInt();
            playerData.x_coin = currentMsg.body.readInt();
            playerData.bossrecord = currentMsg.body.readUTF();
            playerData.challengrecordVictory = currentMsg.body.readInt();
            playerData.challengrecordFail = currentMsg.body.readInt();
            playerData.babelrecordVictory = currentMsg.body.readInt();
            playerData.babelrecordFail = currentMsg.body.readInt();
            lsid = playerData.lastSceneId;
            playerData = this.sdp.myparse(currentMsg,playerData);
            playerData.sceneId = playerData.lastSceneId;
            GlobalConfig.userId = playerData.userId;
            GlobalConfig.roleType = playerData.roleType;
            playerData.lastSceneId = lsid;
            playerData.hasGetBeiBei = currentMsg.body.readInt();
            if(playerData.isNewHand == 2 || playerData.isNewHand == 3 || playerData.isNewHand == 4)
            {
               this.spriteId = currentMsg.body.readInt();
               if(this.spriteId < 1001 || this.spriteId > 1015)
               {
                  this.spriteId = 1007;
               }
               CacheData.instance.newHandSpriteId = this.spriteId;
            }
            playerData.serverId = this.serverId;
            code = GameData.instance.playerData.isNewHand;
            if(code == 1)
            {
               if(playerData.playerStatus == 4)
               {
                  return;
               }
               this.loading.loadModule("请稍后...",URLUtil.getSvnVer("assets/login/newhand.swf"),this.loadComplement);
               dispatch(EventConst.FACEUIOPERATE,{
                  "code":11,
                  "newhand":1
               });
            }
            else
            {
               if(code == 7)
               {
                  GameData.instance.playerData.isNewHand = 9;
               }
               if(code > 7)
               {
                  this.checkNameAble(playerData.userName);
               }
               if(playerData.hasLogin)
               {
                  dispatch(EventConst.CLEARUI);
                  dispatch(EventConst.ENTERSCENE,playerData.currentScenenId);
               }
               else
               {
                  dispatch(EventConst.FACEUIOPERATE,{
                     "code":11,
                     "newhand":code
                  });
                  playerData.hasLogin = true;
                  this.view.visible = false;
                  dispatch(EventConst.ENTER_WORLD_BACK);
               }
            }
            if(code == 9)
            {
               AlphaArea.instance.parent.addChildAt(AlphaArea.instance,1);
               dispatch(EventConst.VERYDAY_SHOWEFFECT);
               CacheData.instance.palyerStateDic[2] = 1;
            }
            else
            {
               GameData.instance.playerData.bigBattleTimes = 20;
               if(ExternalInterface.available)
               {
                  ExternalInterface.call("taskStateFunction",-1,-1,-1,-1,GameData.instance.playerData.bigBattleTimes);
               }
            }
            privatekey = evt.msg.body.readInt();
            playerData.isAcceptInvite = Boolean(privatekey & 1);
            playerData.canChangeName = !Boolean(privatekey & 2);
            playerData.isRefuseUnfamilyChat = Boolean(privatekey & 4);
            if(evt.msg.body.bytesAvailable > 0)
            {
               playerData.littlegameRcore = evt.msg.body.readInt();
            }
            playerData.maxLevel = evt.msg.body.readInt();
            dispatch(EventConst.SHOW_PERSON_PAPERHORSE);
            GlobalConfig.userId = playerData.userId;
            playerData.isInChange = 0;
            playerData.bodyID = 0;
            MouseEnableView.instance.unload();
            this.loginInter.sendToPHP(playerData.userId,3);
            ShareLocalUtil.instance.setAttribute(GlobalConfig.userName,"roleName",playerData.userName);
            ShareLocalUtil.instance.setAttribute(GlobalConfig.userName,"kid",GlobalConfig.userId);
            ShareLocalUtil.instance.flush();
            if(GameData.instance.playerData.onlineTime < 10)
            {
               PhpConnection.instance().loginScore("login");
            }
            else if(GameData.instance.playerData.onlineTime >= 1800 && GameData.instance.playerData.onlineTime < 1810)
            {
               PhpConnection.instance().loginScore("30min");
            }
            this.initMute();
            return;
         }
         PlatMonitorLog.instance.writeNewLog(305);
         this.loading.visible = false;
         AlertManager.instance.showTipAlert({
            "systemid":1054,
            "flag":11,
            "replace":evt.msg.mParams
         });
      }
      
      private function onRequestLoginBack(evt:MsgEvent) : void
      {
         var obj:Object;
         var time:int = 0;
         clearTimeout(this.tid);
         this.loading.visible = false;
         this.isHandClose = false;
         GameDynamicUI.removeUI("loading");
         ReConnectStatus.instance.HAS_CHECK_ACCOUNT = true;
         obj = {};
         obj.flag = this.userParams.flag;
         obj.id = this.userParams.id;
         obj.userName = this.userParams.id;
         obj.pass = this.userParams.pass;
         obj.loginType = this.userParams.loginType;
         switch(evt.msg.mParams)
         {
            case 0:
            case -1:
               PlatMonitorLog.instance.writeNewLog(302,-1);
               AlertManager.instance.showTipAlert({
                  "systemid":1053,
                  "flag":evt.msg.mParams
               });
               break;
            case -2:
            case -3:
               PlatMonitorLog.instance.writeNewLog(302,-3);
               if(this.userParams.loginType == 2)
               {
                  new Alert().showIdPassWordError();
               }
               else
               {
                  new Alert().showUserPassWordError();
               }
               break;
            case -4:
            case -5:
               AlertManager.instance.showTipAlert({
                  "systemid":1053,
                  "flag":evt.msg.mParams
               });
               break;
            case 1:
               ShareLocalUtil.instance.selfLoginData(obj);
               dispatch(EventConst.OPENCREATEROLEVIEW);
               this.loginInter.sendToPbh(GlobalConfig.userName,GlobalConfig.userId,"api/newhand.php",1);
               break;
            case 2:
               this.loading.visible = true;
               ShareLocalUtil.instance.selfLoginData(obj);
               this.view.visible = false;
               this.view.unload();
               this.requestWorldNum();
               break;
            case 3:
               time = evt.msg.body.readInt();
               AlertManager.instance.showTipAlert({
                  "systemid":1053,
                  "flag":evt.msg.mParams,
                  "replace":(time >= 2145888000 ? "永久封停" : DateUtil.getLongShortTime(time))
               });
               break;
            case 4:
               AlertManager.instance.showTipAlert({
                  "systemid":1053,
                  "flag":evt.msg.mParams
               });
               break;
            default:
               AlertManager.instance.showTipAlert({
                  "systemid":1053,
                  "flag":-1000,
                  "replace":evt.msg.mParams
               });
         }
         try
         {
         }
         catch(e:Error)
         {
            O.o("onRequestLoginBack",e);
         }
         GreenLoading.loading.hidebluebg();
      }
      
      private function onConnected(evt:Event) : void
      {
         ReConnectStatus.instance.HAS_CONNECT_SERVER = true;
         clearInterval(this.tid);
         clearInterval(this.logtid);
         this.socket.sendCmd(1185433,GlobalConfig.isClient ? 1 : 0);
         if(O.debug)
         {
            if(GlobalConfig.token == "" || GlobalConfig.token == null)
            {
               this.socket.sendCmd(MsgDoc.OP_CLIENT_CHECK_ACCOUNT.send,200,[int(GlobalConfig.userName),GlobalConfig.takeoverPwd]);
            }
            else
            {
               this.socket.sendCmd(MsgDoc.OP_CLIENT_CHECK_ACCOUNT.send,3,[GlobalConfig.token]);
            }
         }
         else
         {
            this.socket.sendCmd(MsgDoc.OP_CLIENT_CHECK_ACCOUNT.send,3,[GlobalConfig.token]);
         }
         this.tid = setTimeout(this.deathLogin,6000);
         if(GlobalConfig.server == "115.182.52.226")
         {
            PlatMonitorLog.instance.writeNewLog(203);
         }
      }
      
      private function deathLogin() : void
      {
         clearTimeout(this.tid);
         this.isHandClose = true;
         if(!this.socket.isConnect())
         {
            this.loopConnect();
         }
      }
      
      private function onDisConnect(evt:Event) : void
      {
         this.loading.visible = false;
         if(!this.isRepeatLogin)
         {
            GameDynamicUI.removeUI("loading");
            if(!this.isHandClose)
            {
               if(ReConnectStatus.instance.isDisConnectInGame() && !ReConnectStatus.instance.isToMax())
               {
                  dispatch(EventConst.SOCKET_ERROR);
                  ++ReConnectStatus.instance.REC_CONNECT_COUNT;
                  if(GameData.instance.playerData.isInWarCraft)
                  {
                     GameData.instance.playerData.currentScenenId = 1009;
                  }
                  PlatMonitorLog.instance.writeNewLog(204);
                  if(!GlobalConfig.otherObj.hasOwnProperty("MinorsOff"))
                  {
                     new Alert().show(this.loststr[Math.random() * 3 >> 0] + "",this.closeHandler);
                  }
               }
               else
               {
                  dispatch(EventConst.CONNECTION_DEACTIVATE);
                  PlatMonitorLog.instance.writeNewLog(207);
               }
            }
            if(GameData.instance.playerData.playerStatus == 7)
            {
               dispatch(EventConst.TEMLEAVE_VISIBLE,{
                  "uid":GameData.instance.playerData.userId,
                  "type":0
               });
            }
         }
      }
      
      public function lingQu(param:Object) : void
      {
         if(param != null && Boolean(param.hasOwnProperty("code")))
         {
            if(param.code == 1)
            {
               this.loginInter.sendToPbh(GlobalConfig.userName,GlobalConfig.userId,"api/newhand.php",1);
               this.socket.sendCmd(MsgDoc.OP_CLIENT_NEWHAND.send,1,[0,0]);
            }
            if(param.code == 2)
            {
               this.loginInter.sendToPbh(GlobalConfig.userName,GlobalConfig.userId,"api/newhand.php",2);
               this.socket.sendCmd(MsgDoc.OP_CLIENT_NEWHAND.send,2,[param.id,0]);
            }
            if(param.code == 3)
            {
               GameData.instance.playerData.coin += 5000;
               this.loginInter.sendToPbh(GlobalConfig.userName,GlobalConfig.userId,"api/newhand.php",3);
               this.socket.sendCmd(MsgDoc.OP_CLIENT_NEWHAND.send,3,[0,0]);
            }
         }
      }
      
      public function lingquPrize() : void
      {
         this.socket.sendCmd(MsgDoc.OP_CLIENT_LINGQUPRIZE.send);
      }
      
      private function requestEmailState() : void
      {
      }
      
      private function loginGameBack(event:MessageEvent) : void
      {
         if(this.isSeeDonghua)
         {
            this.socket.sendCmd(MsgDoc.OP_CLIENT_NEWHAND.send,9999,[0,""]);
         }
         if(!GameData.instance.playerData.isInscene)
         {
            GameData.instance.playerData.isInscene = true;
            this.socket.sendCmd(MsgDoc.OP_RETURN_MONEY.send);
         }
         var code:int = GameData.instance.playerData.isNewHand;
         var sid:int = GameData.instance.playerData.sceneId;
         trace("===========loginGameBack登陆成功返回============",code,sid,this.spriteId);
         if(code == 1)
         {
            GameDynamicUI.addUI(this.view.stage,340,340,"jiantou");
         }
         if(code == 2)
         {
            ApplicationFacade.getInstance().dispatch(EventConst.BOBSTATECLICK,{"url":"assets/system/newHand/choiceMonster/NewHandChoiceMonster.swf"});
         }
         if(code == 3)
         {
            MapView.instance.masterPerson.setDirection(2);
            dispatch(EventConst.SENDMSGTOSWF,{
               "msgname":"onNewHandMonsterIDBack",
               "body":this.spriteId,
               "radio":"newhand"
            });
         }
         if(code == 4)
         {
            dispatch(EventConst.FACEUIOPERATE,{
               "code":11,
               "newhand":4
            });
            SpecialAreaManager.instance.loadNewHandMask("mapmask");
         }
         if(code == 5)
         {
            dispatch(EventConst.FACEUIOPERATE,{
               "code":11,
               "newhand":5
            });
         }
         if(code == 6)
         {
            sendMessage(MsgDoc.OP_CLIENT_ACTIVITY_QINGYANG_NEW.send,764,["login"]);
            this.socket.sendCmd(MsgDoc.OP_CLIENT_MSG_KABUONLINE.send);
            dispatch(EventConst.FACEUIOPERATE,{
               "code":11,
               "newhand":6
            });
            CacheData.instance.onlinelist.build();
            sendMessage(MsgDoc.OP_CLIENT_ACTIVITY_QINGYANG.send,10000,[0]);
            ApplicationFacade.getInstance().dispatch(EventConst.BOBSTATECLICK,{"url":"assets/activity/zrk2025/Act764/Act764Entrance.swf"});
         }
         this.view.dispatchEvent(new MessageEvent(EventConst.LOGINGAMEBACK));
      }
      
      public function get view() : LoginView
      {
         return this.getViewComponent() as LoginView;
      }
      
      private function newHandStart(evt:MessageEvent) : void
      {
         if(GameData.instance.playerData.isNewHand == 1)
         {
            GameDynamicUI.removeUI("jiantou");
            this.view.visible = true;
            dispatch(EventConst.FRESHMANGUIDETOTASK,{
               "step":100600101,
               "id":14001
            });
         }
      }
      
      private function onClickBaoXiang(evt:MouseEvent) : void
      {
         dispatch(EventConst.FRESHMANGUIDETOTASK,{
            "step":100600102,
            "id":14001
         });
      }
      
      private function cNewHandOneStep(evt:ChannelEvent) : void
      {
         this.view.unload();
         var params:Object = evt.getMessage().getBody();
         this.spriteId = GameData.instance.playerData.mid = params.mid;
         GameData.instance.playerData.mstate = 0;
         GameData.instance.playerData.userName = params.userName;
         dispatch(EventConst.UPDATEPLAYERDATA);
         this.loginInter.sendToPbh(GlobalConfig.userName,GlobalConfig.userId,"api/newhand.php",4);
         this.socket.sendCmd(MsgDoc.OP_CLIENT_NEWHAND.send,2,[params.mid,params.userName + ""]);
      }
      
      private function onNewHandBack(evt:MsgEvent) : void
      {
         var mparams:int = evt.msg.mParams;
         GameData.instance.playerData.isNewHand = mparams + 1;
         trace("===========新手协议返回=============",GameData.instance.playerData.isNewHand);
         switch(mparams)
         {
            case 1:
               ApplicationFacade.getInstance().dispatch(EventConst.BOBSTATECLICK,{"url":"assets/system/newHand/choiceMonster/NewHandChoiceMonster.swf"});
               break;
            case 2:
               CacheData.instance.newHandSpriteId = this.spriteId;
               MapView.instance.masterPerson.setDirection(2);
               dispatch(EventConst.SENDMSGTOSWF,{
                  "msgname":"onNewHandMonsterIDBack",
                  "body":this.spriteId,
                  "radio":"newhand"
               });
               break;
            case 3:
               new SwfAction().loadAndPlay(this.view.stage,"assets/material/magicmap.swf",430,200,this.showBigMap);
               break;
            case 4:
               ApplicationFacade.getInstance().dispatch(EventConst.FRESHMANGUIDETOTASK,{
                  "step":100600108,
                  "id":11001
               });
               break;
            case 5:
               break;
            case 6:
               ApplicationFacade.getInstance().dispatch(EventConst.PERSON_CAN_OR_NOT_MOVE,true);
               this.loginInter.sendToPbh(GlobalConfig.userName,GlobalConfig.userId,"api/newhand.php",9);
               SocketManager.getGreenSocket().sendCmd(MsgDoc.OP_CLIENT_NEWHAND.send,7,[0,""]);
               new SwfAction().loadAndPlay(this.view.stage,"assets/material/magicbrave.swf",420,200,this.closeLastNewHandAlert);
               break;
            case 7:
               break;
            case 9:
               dispatch(EventConst.FACEUIOPERATE,{
                  "code":11,
                  "newhand":9
               });
         }
      }
      
      private function taskNext(evt:MessageEvent) : void
      {
         var step:int = evt.body as int;
         trace("=============== taskNext新手指引中使用到任务对话框的时候，通过这个消息通知新手指引=============",step);
         if(step == 600101)
         {
            this.loginInter.sendToPbh(GlobalConfig.userName,GlobalConfig.userId,"api/newhand.php",3);
            this.socket.sendCmd(MsgDoc.OP_CLIENT_NEWHAND.send,1,[0,0]);
         }
         if(step == 600102)
         {
            MapView.instance.delGameSpirit("机舱小助手");
            MapView.instance.masterPerson.ui.visible = false;
            dispatch(EventConst.SENDMSGTOSWF,{
               "msgname":"onNewHandBattleAmiPlay",
               "radio":"newhand"
            });
         }
         if(step == 600103)
         {
            dispatch(EventConst.FRESHMANGUIDETOTASK,{
               "step":this.getMonsterDialogID(),
               "id":this.getMonsterNPCID()
            });
         }
         if(step == 600107)
         {
            dispatch(EventConst.SENDMSGTOSWF,{
               "msgname":"zhiyinover",
               "radio":"newhand"
            });
         }
         if(step == 600108)
         {
            new AwardAlert().showMoneyAward(2000,this.view.stage,this.closeStep7Award);
            new AwardAlert().showExpAward(5000,this.view.stage);
            this.loginInter.sendToPbh(GlobalConfig.userName,GlobalConfig.userId,"api/newhand.php",7);
            this.socket.sendCmd(MsgDoc.OP_CLIENT_NEWHAND.send,5,[0,""]);
         }
      }
      
      private function closeLastNewHandAlert() : void
      {
         ApplicationFacade.getInstance().dispatch(EventConst.PERSON_CAN_OR_NOT_MOVE,false);
         dispatch(EventConst.FACEUIOPERATE,{
            "code":11,
            "newhand":7
         });
         ApplicationFacade.getInstance().dispatch(EventConst.BOBSTATECLICK,{"url":"assets/activity/zrk2025/Act750/Act750Entrance.swf"});
         CacheData.instance.isPlayBraveEffect = true;
         FaceView.clip.checkIsInActiveTime();
      }
      
      private function closeStep7Award(p:Object) : void
      {
         ApplicationFacade.getInstance().dispatch(EventConst.PERSON_CAN_OR_NOT_MOVE,true);
         new SwfAction().loadAndPlay(this.view.stage,"assets/material/magicNewHand.swf",440,200,this.enableTask);
      }
      
      private function enableTaskBtn(evt:MessageEvent) : void
      {
         new SwfAction().loadAndPlay(this.view.stage,"assets/material/magictask.swf",440,200,this.enableTask);
      }
      
      private function enableTask() : void
      {
         ApplicationFacade.getInstance().dispatch(EventConst.PERSON_CAN_OR_NOT_MOVE,false);
         sendMessage(MsgDoc.OP_CLIENT_ACTIVITY_QINGYANG_NEW.send,764,["login"]);
         this.socket.sendCmd(MsgDoc.OP_CLIENT_MSG_KABUONLINE.send);
         dispatch(EventConst.FACEUIOPERATE,{
            "code":11,
            "newhand":6
         });
         CacheData.instance.onlinelist.build();
         sendMessage(MsgDoc.OP_CLIENT_ACTIVITY_QINGYANG.send,10000,[0]);
         FaceView.clip.topClip.visible = true;
         ApplicationFacade.getInstance().dispatch(EventConst.BOBSTATECLICK,{"url":"assets/activity/zrk2025/Act764/Act764Entrance.swf"});
         sendMessage(MsgDoc.OP_CLIENT_ACTIVITY_QINGYANG_NEW.send,774,["open_ui"]);
         sendMessage(MsgDoc.OP_CLIENT_ACTIVITY_QINGYANG_NEW.send,784,["ui_info"]);
      }
      
      private function addAwardBoxToStage() : void
      {
         GameDynamicUI.addMouseFrameScritUI(MapView.instance,270,400,"newHandBox",MouseEvent.CLICK,this.onClickBaoXiang,this.removeEffect,0.4,38,this.stopEffect);
      }
      
      private function stopEffect() : void
      {
         GameDynamicUI.excute("newHandBox","stop");
         GameDynamicUI.excute("newHandBox","buttonMode",1,false);
      }
      
      private function removeEffect() : void
      {
         GameDynamicUI.removeUI("newHandBox");
         dispatch(EventConst.FACEUIOPERATE,{
            "code":5,
            "name":"packBtn"
         });
         this.loginInter.sendToPbh(GlobalConfig.userName,GlobalConfig.userId,"api/newhand.php",2);
         this.socket.sendCmd(MsgDoc.OP_CLIENT_NEWHAND.send,2,[0,""]);
      }
      
      private function startFight(evt:ChannelEvent) : void
      {
         if(!this.flag)
         {
            this.flag = true;
            if(ApplicationFacade.getInstance().retrieveViewLogic(NewBattleControl.NAME) == null)
            {
               ApplicationFacade.getInstance().registerViewLogic(new NewBattleControl());
            }
            ApplicationFacade.getInstance().dispatch(EventConst.NEW_PLAYER_BATTLE,this.spriteId);
         }
      }
      
      private function zhiYinOver(evt:ChannelEvent) : void
      {
         trace("===========新手指引第二阶段完毕==========");
         dispatch(EventConst.FACEUIOPERATE,{"code":4});
         dispatch(EventConst.FACEUIOPERATE,{
            "code":11,
            "newhand":3
         });
         dispatch(EventConst.ZHIYINOVER);
         this.loginInter.sendToPbh(GlobalConfig.userName,GlobalConfig.userId,"api/newhand.php",5);
         this.socket.sendCmd(MsgDoc.OP_CLIENT_NEWHAND.send,3,[0,""]);
      }
      
      private function gotoZiyuanCang(evt:ChannelEvent) : void
      {
         dispatch(EventConst.GOTOZIYUANCANG);
      }
      
      private function showBigMap() : void
      {
         dispatch(EventConst.FACEUIOPERATE,{
            "code":11,
            "newhand":4
         });
         SpecialAreaManager.instance.loadNewHandMask("mapmask");
         ApplicationFacade.getInstance().dispatch(EventConst.PERSON_CAN_OR_NOT_MOVE,false);
      }
      
      private function checkNameAble(value:String) : void
      {
      }
      
      private function getMonsterDialogID() : int
      {
         var dialogid:int = 0;
         var spriteid:int = CacheData.instance.newHandSpriteId;
         if(spriteid == 1013)
         {
            dialogid = 100600102;
         }
         else if(spriteid == 1007)
         {
            dialogid = 100600103;
         }
         else if(spriteid == 1010)
         {
            dialogid = 100600104;
         }
         else if(spriteid == 1004)
         {
            dialogid = 100600105;
         }
         else if(spriteid == 1001)
         {
            dialogid = 100600106;
         }
         else
         {
            dialogid = 100600106;
         }
         return dialogid;
      }
      
      private function getMonsterNPCID() : int
      {
         var npcid:int = 0;
         var spriteid:int = CacheData.instance.newHandSpriteId;
         if(spriteid == 1013)
         {
            npcid = 9101;
         }
         else if(spriteid == 1007)
         {
            npcid = 9102;
         }
         else if(spriteid == 1010)
         {
            npcid = 9103;
         }
         else if(spriteid == 1004)
         {
            npcid = 9104;
         }
         else if(spriteid == 1001)
         {
            npcid = 9105;
         }
         else
         {
            npcid = 9105;
         }
         return npcid;
      }
   }
}

