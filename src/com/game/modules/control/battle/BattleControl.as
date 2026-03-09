package com.game.modules.control.battle
{
   import com.core.observer.MessageEvent;
   import com.core.view.ViewConLogic;
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.global.GlobalConfig;
   import com.game.locators.EventDefine;
   import com.game.locators.GameData;
   import com.game.locators.MsgDoc;
   import com.game.manager.MouseManager;
   import com.game.modules.action.SwfAction;
   import com.game.modules.control.MapControl;
   import com.game.modules.view.MapView;
   import com.game.modules.view.WindowLayer;
   import com.game.modules.view.battle.BattleView;
   import com.game.modules.view.battle.BeforeBattleView;
   import com.game.modules.view.battle.pop.ChangeSkillView;
   import com.game.modules.view.battle.pop.LearnSkillView;
   import com.game.modules.view.battle.pop.WinExpView;
   import com.game.modules.view.battle.pop.WinLevelView;
   import com.game.util.AwardAlert;
   import com.game.util.BitValueUtil;
   import com.game.util.LuaObjUtil;
   import com.game.util.RenderUtil;
   import com.game.util.SceneSoundManager;
   import com.publiccomponent.alert.Alert;
   import com.publiccomponent.alert.AlertContainer;
   import com.publiccomponent.loading.XMLLocator;
   import com.util.SkillEffectDictory;
   import com.xygame.module.battle.data.BattleData;
   import com.xygame.module.battle.data.BattleLookList;
   import com.xygame.module.battle.data.BattleOpration;
   import com.xygame.module.battle.data.BufData;
   import com.xygame.module.battle.data.LevelUpData;
   import com.xygame.module.battle.data.SpiritData;
   import com.xygame.module.battle.event.BattleEvent;
   import com.xygame.module.battle.util.BattleAlert;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.external.ExternalInterface;
   import flash.utils.Timer;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import org.green.server.manager.SocketManager;
   import sound.SoundManager;
   
   public class BattleControl extends ViewConLogic
   {
      
      public static const NAME:String = "battlemediator";
      
      private var bobOwner:Boolean;
      
      private var gameOver:Boolean;
      
      private var bufObject:Object;
      
      private var clearOver:Boolean = true;
      
      private var battleClose:Object;
      
      private var endBuf:Array;
      
      private var _isPVP:Boolean;
      
      private var _checkTime:uint;
      
      private var battleresult:Object;
      
      private var newBattleResult:String;
      
      private var isAvail:int;
      
      private var cmwdObj:Object;
      
      private var isEscape:Boolean;
      
      private var canshowbattle:Boolean;
      
      private var srcloadover:Boolean;
      
      private var saveMouseName:String = "";
      
      private var battlesid:int;
      
      private var counter:int = 1;
      
      private var battle:Boolean = false;
      
      public var step:int = 0;
      
      public var playOverBool:Boolean = true;
      
      private var canShowAlert:Boolean = false;
      
      private var round:int = 0;
      
      private var expObj:Object;
      
      private var pkObj:Object;
      
      private var taskobj:Object = {};
      
      private var flag:Boolean;
      
      private var expArr:Array = [];
      
      private var levelArr:Array = [];
      
      private var tempLud:LevelUpData;
      
      private var failtitle:Boolean;
      
      private var spiritsExp:Array = [];
      
      private var wintools:Array = [];
      
      private var winExpWindow:WinExpView;
      
      private var winLevelWindow:WinLevelView;
      
      private var changSkiWindow:ChangeSkillView;
      
      private var learnSkiWindow:LearnSkillView;
      
      private var failWindow:BattleAlert;
      
      private var passCopy:Boolean;
      
      private var copyThings:Object;
      
      private var battleType:int;
      
      public var battleView:BattleView;
      
      private var beforeBattleView:BeforeBattleView;
      
      private var mapControl:MapControl;
      
      private var mytimer:Timer;
      
      private var movieid:int;
      
      private var needplay:Boolean = false;
      
      public function BattleControl(viewComponent:Object = null)
      {
         super(NAME,viewComponent);
      }
      
      private function addViewListen() : void
      {
         this.battleView.addEventListener(BattleEvent.showBattle,this.onShowBattle);
         this.battleView.addEventListener(BattleEvent.battleOpration,this.onBattleOpration);
         this.battleView.addEventListener(BattleEvent.battlePlayOver,this.onBattlePlayOver);
         this.battleView.addEventListener(BattleEvent.requestBattlTool,this.onReqBattleTool);
         this.battleView.addEventListener(BattleEvent.spiritsEnterOver,this.onSpiritEnterOver);
         this.battleView.addEventListener(BattleEvent.cancelAutoBattle,this.onCancelAutoBattle);
         this.battleView.addEventListener(BattleEvent.catchover,this.onCatchOver);
         this.battleView.addEventListener(BattleEvent.LEAVE_BATTLE_CLICK,this.leaveLookBattle);
         GameData.instance.addEventListener(EventDefine.LOOK_BATTLE_RESULT,this.onLookBattleResult);
      }
      
      private function remeViewListen() : void
      {
         this.battleView.removeEventListener(BattleEvent.showBattle,this.onShowBattle);
         this.battleView.removeEventListener(BattleEvent.battleOpration,this.onBattleOpration);
         this.battleView.removeEventListener(BattleEvent.battlePlayOver,this.onBattlePlayOver);
         this.battleView.removeEventListener(BattleEvent.requestBattlTool,this.onReqBattleTool);
         this.battleView.removeEventListener(BattleEvent.spiritsEnterOver,this.onSpiritEnterOver);
         this.battleView.removeEventListener(BattleEvent.cancelAutoBattle,this.onCancelAutoBattle);
         this.battleView.removeEventListener(BattleEvent.catchover,this.onCatchOver);
         this.battleView.removeEventListener(BattleEvent.LEAVE_BATTLE_CLICK,this.leaveLookBattle);
         GameData.instance.removeEventListener(EventDefine.LOOK_BATTLE_RESULT,this.onLookBattleResult);
      }
      
      private function onLookBattleResult(event:MessageEvent) : void
      {
         var obj:Object = event.body;
         if(Boolean(obj.res1 & 0x80000000))
         {
            this.newBattleResult = "【" + obj.pName1 + "】击败【" + obj.pName2 + "】,取得战斗胜利！";
         }
         else
         {
            this.newBattleResult = "【" + obj.pName2 + "】击败【" + obj.pName1 + "】,取得战斗胜利！";
         }
         this.dealgameover();
      }
      
      private function leaveLookBattle(_arg1:Event) : void
      {
         ApplicationFacade.getInstance().dispatch("leavebattleclick");
         this.newBattleResult = null;
         this.clearBattleView(true);
      }
      
      private function onShowBattle(event:BattleEvent) : void
      {
         this.srcloadover = true;
         if((this.canshowbattle || this.battleType != 5) && !this.clearOver)
         {
            this.realShowBattle();
         }
      }
      
      private function onAfterBefore(event:MessageEvent) : void
      {
         this.canshowbattle = true;
         if(this.srcloadover && !this.clearOver)
         {
            this.realShowBattle();
         }
      }
      
      private function realShowBattle() : void
      {
         this.srcloadover = false;
         this.canshowbattle = false;
         this.mapControl = ApplicationFacade.getInstance().retrieveViewLogic(MapControl.NAME) as MapControl;
         if(Boolean(this.beforeBattleView) && WindowLayer.instance.stage.contains(this.beforeBattleView))
         {
            WindowLayer.instance.stage.removeChild(this.beforeBattleView);
            this.beforeBattleView.destroy();
            this.beforeBattleView = null;
         }
         if(this.battleView == null)
         {
            new Alert().showOne("妖怪害怕你的强大，跑了！");
            return;
         }
         if(this.gameOver)
         {
            this.clearBattleView(false);
            return;
         }
         this.mapControl.getViewComponent().stage.addChild(this.battleView);
         RenderUtil.instance.stopRender();
         if(this.battleType == 2 && Boolean(SoundManager.instance.hasOwnProperty("playBossMusic")))
         {
            SoundManager.instance.playBossMusic();
         }
         else if(SoundManager.instance.hasOwnProperty("playNomalMusic"))
         {
            SoundManager.instance.playNomalMusic();
         }
         SceneSoundManager.getInstance().playbattlesound = true;
         if(SceneSoundManager.getInstance().hasOwnProperty("stop"))
         {
            SceneSoundManager.getInstance().stop();
         }
         this.saveMouseName = MouseManager.getInstance().cursorName;
         MouseManager.getInstance().setCursor("");
         WindowLayer.instance.visible = false;
      }
      
      private function onSpiritEnterOver(event:BattleEvent) : void
      {
         if(GameData.instance.lookBattle == 1)
         {
            switch(GameData.instance.newLookType)
            {
               case 2:
               case 1:
                  ++BattleEvent.newLookRound;
                  break;
               default:
                  sendMessage(MsgDoc.OP_GATEWAY_BATTLE_LOOK_READY.send,0,[this.round + 1]);
                  this.starttime(15000);
            }
         }
         else
         {
            if(!this.battleView.battleObject.newbattle)
            {
               sendMessage(MsgDoc.OP_GATEWAY_BATTLE_READY.send);
               this.starttime(150000);
               if(this._isPVP)
               {
                  this._checkTime = setTimeout(function():void
                  {
                     battleView && battleView.showCheck();
                  },5000);
               }
            }
            else
            {
               dispatch(EventConst.SHOW_BATTLE_VIEW);
            }
            this.battleEnd(null);
         }
      }
      
      private function onCancelAutoBattle(event:BattleEvent) : void
      {
         dispatch("cancelfrombattle");
      }
      
      private function onCatchOver(event:MessageEvent) : void
      {
         dispatch("catch_over",event.body);
      }
      
      private function onClientNpc(event:MessageEvent) : void
      {
         if(GameData.instance.playerData.playerStatus == 2 || GameData.instance.playerData.playerSurplus == 0)
         {
            if(event && event.body && event.body.sid != 0)
            {
               new Alert().showOne("今天你已经在西游世界冒险很久了哦，休息休息，养好精神明天再来战斗吧O(∩_∩)O~");
               this.dispatch(EventConst.BATTLE_CAN_NOT_BE_STARTED);
               return;
            }
         }
         var userid:int = GameData.instance.playerData.userId;
         var r:int = (userid >> 2 & 3) % 3;
         var send:int = 1186051 + int(r);
         if(GameData.instance.playerData.copyScene > 0)
         {
            this.battle = true;
            if(GameData.instance.playerData.copyScene == 4)
            {
               sendMessage(1186184,3,[event.body.monsterLevel]);
            }
            else if(GameData.instance.playerData.copyScene == 5)
            {
               sendMessage(1186184,4,[event.body.index]);
            }
            else if(GameData.instance.playerData.copyScene == 9)
            {
               sendMessage(MsgDoc.OP_CLIENT_COPY.send,9,[2,event.body.copyMonsterId]);
            }
            else if(GameData.instance.playerData.copyScene == 10)
            {
               sendMessage(1186184,10,[2,(int(event.body.sid) & 0xFFFF00) >> 8]);
            }
            else if(GameData.instance.playerData.copyScene == 23)
            {
               if(!this.clearOver || this.battleView != null)
               {
                  sendMessage(MsgDoc.OP_CLIENT_COPY.send,23,[3,1]);
               }
               else
               {
                  sendMessage(MsgDoc.OP_CLIENT_COPY.send,23,[2,event.body.copyMonsterId]);
               }
            }
            else
            {
               sendMessage(1186184);
            }
         }
         else if(Boolean(event.body.hasOwnProperty("useid")) && event.body.useid != 0)
         {
            this.battle = true;
            sendMessage(MsgDoc.OP_CLIENT_CLICK_NPC.send,event.body.sid,[this.counter,event.body.useid]);
         }
         else
         {
            this.battle = true;
            sendMessage(MsgDoc.OP_CLIENT_CLICK_NPC.send,int(event.body.sid),[this.counter]);
         }
         this.battlesid = event.body.sid;
      }
      
      private function showBeforeBattle(obj:Object) : void
      {
         this.canshowbattle = false;
         this.srcloadover = false;
         if(this.beforeBattleView == null)
         {
            this.beforeBattleView = new BeforeBattleView(this.battlesid,obj);
         }
         this.mapControl = ApplicationFacade.getInstance().retrieveViewLogic(MapControl.NAME) as MapControl;
         this.beforeBattleView.bgBitMapData = this.mapControl.getViewComponent().scene.getStaticBg();
         this.beforeBattleView.battleType = this.battleType;
         this._isPVP = BattleEvent.NEW_PVP.indexOf(this.battleType) != -1;
         WindowLayer.instance.stage.addChild(this.beforeBattleView);
      }
      
      private function onBattleOpration(event:BattleEvent) : void
      {
         var obj:Object = event.battleInfo;
         if(!this.battleView.battleObject.newbattle)
         {
            if(obj.param == 0)
            {
               sendMessage(MsgDoc.OP_CLIENT_USER_OP.send,obj.param,[obj.target,obj.skillId]);
            }
            else if(obj.param == 1)
            {
               sendMessage(MsgDoc.OP_CLIENT_USER_OP.send,obj.param,[obj.spiritid]);
            }
            else if(obj.param == 2)
            {
               sendMessage(MsgDoc.OP_CLIENT_USER_OP.send,obj.param,[obj.packcode,obj.position,obj.sid]);
            }
            else if(obj.param == 3)
            {
               sendMessage(MsgDoc.OP_CLIENT_USER_OP.send,obj.param);
               this.isEscape = true;
            }
         }
         else
         {
            if(obj.param == 2 && this.step != 3)
            {
               return;
            }
            dispatch(EventConst.ON_BATTLE_OP,++this.step);
         }
      }
      
      private function onBattlePlayOver(event:BattleEvent) : void
      {
         if(GameData.instance.lookBattle == 1 && GameData.instance.newLookType == 0)
         {
            this.checkEndBuf();
            sendMessage(MsgDoc.OP_GATEWAY_BATTLE_LOOK_READY.send,0,[this.round + 1]);
            this.starttime(15000);
            this.dealgameover();
         }
         else
         {
            if(this.battleView.battleObject.newbattle)
            {
               dispatch(EventConst.ON_BATTLE_OP,++this.step);
            }
            else if(this.playOverBool && this.battleView.myPlayOver)
            {
               this.playOverBool = false;
               switch(GameData.instance.newLookType)
               {
                  case 1:
                     this.dealgameover();
                  case 2:
                     setTimeout(function():void
                     {
                        ++BattleEvent.newLookRound;
                     },1000);
                     break;
                  default:
                     sendMessage(MsgDoc.OP_CLIENT_BATTLE_PLAY_OVER.send);
                     this.starttime(150000);
               }
               this.checkEndBuf();
            }
            this.canShowAlert = true;
            if(this.isEscape)
            {
               this.isEscape = false;
            }
            this.battleNewExpBack(null);
         }
      }
      
      private function checkEndBuf() : void
      {
         var buf:Object = null;
         if(Boolean(this.endBuf))
         {
            for each(buf in this.endBuf)
            {
               switch(buf.add_or_remove)
               {
                  case BufData.BUF_TYPE_4:
                     this.battleView.battleBufBlood(buf);
                     break;
                  case BufData.BUF_TYPE_5:
                     this.battleView.battleBufRecover(buf);
               }
            }
            this.endBuf = [];
         }
      }
      
      private function onReqBattleTool(event:BattleEvent) : void
      {
         if(!this.battleView.battleObject.newbattle)
         {
            if(this.battleType == 14 || this.battleType == 15)
            {
               sendMessage(MsgDoc.OP_CLIENT_REQ_PACKAGE_DATA.send,1025);
            }
            else
            {
               sendMessage(MsgDoc.OP_CLIENT_REQ_PACKAGE_DATA.send,257);
            }
         }
         else
         {
            dispatch(EventConst.ON_BATTLE_OP,++this.step);
         }
      }
      
      private function releaseCatchSpirit(event:MessageEvent) : void
      {
         sendMessage(MsgDoc.OP_CLIENT_RELEASE_SPIRIT.send,int(event.body.spiritsid),[event.body.spiritPackid]);
      }
      
      override public function listEvents() : Array
      {
         return [[BattleEvent.npcClick,this.onClientNpc],[EventConst.CLEAR_BATTLE,this.clearBattle],[EventConst.BATTLE_MONSTER_INFO,this.battleMonsterInfo],[EventConst.BATTLE_START,this.battleStart],[EventConst.BATTLE_ROUND_START,this.battleRoundStart],[EventConst.BATTLE_ROUND_END,this.battleRoundEnd],[EventConst.BATTLE_USE_PROPS,this.useProps],[EventConst.BATTLE_END,this.battleEnd],[EventConst.BATTLE_BUF,this.battleBuf],[EventConst.BATTLE_BUF_BLOOD,this.battleBufBlood],[EventConst.BATTLE_BUF_RECOVER,this.battleBufRecover],[EventConst.BATTLE_BUF_DIS,this.battleBufDis],[EventConst.BATTLE_TOOL_BACK,this.battleToolBack],[EventConst.BATTLE_NEWEXP_BACK,this.battleNewExpBack],[EventConst.BATTLE_RELOGIN,this.showReloginAlert],[EventConst.SOCKET_ERROR,this.socketErrorAlert],[EventConst.CONNECTION_DEACTIVATE,this.showDeactivate],[EventConst.WIN_COPY_THINGS,this.winCopyThings],[EventConst.PASS_COPY,this.passCopyHandler],[EventConst.SPIRIT_LEVEL_UP,this.onSpiritLevelUp],[EventConst.BIGBATTLE_BEFOREOVER,this
         .onAfterBefore],[EventConst.BATTLE_BUFS,this.onBufsHandler],[EventConst.BATTLE_COUNTER,this.onBattleCounter],[EventConst.PLAYBADGEMOVIE,this.onPlayBadgeMovie],[EventConst.RELEASE_CATCH_SPIRIT,this.releaseCatchSpirit],[EventConst.BATTLE_FSPK,this.onBattleFSPKback],[EventConst.BATTLE_ACT_OVER,this.onBattleActOver],[EventConst.BATTLE_SITE,this.onBattleSite],["send_code",this.onMsgCode]];
      }
      
      private function onBufsHandler(event:MessageEvent) : void
      {
         if(Boolean(this.battleView))
         {
            this.battleView.battlebufs(event.body);
         }
         else
         {
            this.bufObject = event.body;
         }
      }
      
      private function onBattleCounter(event:MessageEvent) : void
      {
         this.counter = 1;
      }
      
      public function clearBattle(event:MessageEvent) : void
      {
         this.onCloseFailBattleView(null);
         this.onCloseWinExpWindow(null);
      }
      
      public function battleMonsterInfo(event:MessageEvent) : void
      {
         var skillobj:Object = null;
         var xml:XML = null;
         if(this.battleView == null)
         {
            return;
         }
         var data:SpiritData = event.body as SpiritData;
         this.battleView.addNewSpirit(data);
         for each(skillobj in data.skillArr)
         {
            xml = XMLLocator.getInstance().getSkill(skillobj.skillid);
            if(Boolean(xml) && int(xml.effect) != 0)
            {
               SkillEffectDictory.instance.addEffect(xml.effect);
            }
         }
      }
      
      public function battleStart(event:MessageEvent) : void
      {
         if(!this.clearOver || this.battleView != null)
         {
            return;
         }
         this.clearOver = false;
         this.passCopy = false;
         this.gameOver = false;
         this.isAvail = 0;
         this.pkObj = null;
         this.starttime(300000);
         this.battleType = event.body.battleType;
         GlobalConfig.otherObj["MainBattleInfo"] = {"battleType":this.battleType};
         this._isPVP = BattleEvent.NEW_PVP.indexOf(this.battleType) != -1;
         this.showBeforeBattle(event.body);
         this.mapControl = ApplicationFacade.getInstance().retrieveViewLogic(MapControl.NAME) as MapControl;
         if(this.battleView == null)
         {
            this.battleView = new BattleView();
         }
         if((this.battleType == 14 || this.battleType == 15) && Boolean(GameData.instance.playerData.arenaVo))
         {
            if(Boolean(GameData.instance.playerData.arenaVo.battleBg))
            {
               this.battleView.bgBitMapData = GameData.instance.playerData.arenaVo.battleBg;
            }
         }
         else if(Boolean(this.mapControl.getViewComponent().scene) && Boolean(this.mapControl.getViewComponent().scene.getStaticBg()))
         {
            this.battleView.bgBitMapData = this.mapControl.getViewComponent().scene.getStaticBg();
         }
         this.viewComponent = this.battleView;
         this.addViewListen();
         this.battleView.battleObject = event.body as BattleData;
         this.round = 0;
         this.expArr = [];
         this.step = 0;
         this.flag = true;
         if(GameData.instance.lookBattle == 1)
         {
            return;
         }
         this.bobOwner = GameData.instance.playerData.leitaidata > 0;
         if(!this.battleView.battleObject.newbattle)
         {
            this.counter = this.counter + GameData.instance.playerData.userId & 0xFFFF;
            this.counter += 9;
         }
         if(this.battleType == 3 || this.battleType == 5 || this.battleType == 6 || this.battleType == 14 || this.battleType == 15 || this._isPVP)
         {
            this.counter = 1;
         }
         if(this.battleType == 12 || GameData.instance.playerData.isInWarCraft)
         {
            this.battleView.initValue = 286326785;
         }
         if(this.battleType == 14 || this.battleType == 15 || this.battleType == 11 || this._isPVP)
         {
            this.battleView.initValue = 286330897;
         }
         if(this.battleType == 17)
         {
            GameData.instance.battleItemNum = 6;
            GameData.instance.battleNoList = [100758];
         }
         var xml:XML = XMLLocator.getInstance().getErrofInfo(910);
         var ary:Array = LuaObjUtil.getLuaObjArr(String(xml.combatID));
         if(ary.indexOf(this.battleType) != -1)
         {
            this.battleView.initValue = 286331153;
         }
         GameData.instance.playerData.taskStatus = BitValueUtil.setBitValue(GameData.instance.playerData.taskStatus,1,true);
      }
      
      private function battleRoundStart(event:MessageEvent) : void
      {
         if(GameData.instance.lookBattle != 1)
         {
            this.stoptime("battleroundstart");
         }
         if(this._checkTime != 0)
         {
            clearTimeout(this._checkTime);
            this._checkTime = 0;
         }
         if(this.battleView == null)
         {
            return;
         }
         this.battleView.newRound();
         if(GameData.instance.lookBattle != 0)
         {
            return;
         }
         if(this._isPVP)
         {
            this.battleView.clearCheck();
         }
         this.battleView.myPlayOver = false;
         var value:Object = event.body;
         if(value > 0)
         {
            this.battleView.showCountTime(value);
         }
         else
         {
            if(this.step == 0)
            {
               this.battleView.oprationValue = 286261249;
               this.battleView.setBattleSkillFilters();
            }
            else if(this.step == 2)
            {
               this.battleView.oprationValue = 65537;
            }
            else if(this.step == 6)
            {
               this.battleView.oprationValue = 286261249;
            }
            this.battleView.stopTime();
            this.battleView.canBattle = true;
         }
         ++this.round;
         if(this.round > 0)
         {
            this.battleView.setBattleSkillFilters();
            this.battleView.toolControl.setToolFilter();
         }
         if(Boolean(this.bufObject))
         {
            this.battleView.battlebufs(this.bufObject);
            this.bufObject = null;
         }
      }
      
      private function battleRoundEnd(event:MessageEvent) : void
      {
         this.stoptime("battleroundend");
         if(this.battleView == null)
         {
            return;
         }
         if(this.battleView.gameOver)
         {
            return;
         }
         this.canShowAlert = false;
         this.playOverBool = true;
         var bo:BattleOpration = event.body.battleRoundOpration;
         if(bo.avail == 1)
         {
            this.isAvail = 1;
         }
         this.battleView.battleRoundOpration = bo;
      }
      
      private function useProps(event:MessageEvent) : void
      {
         if(this.battleView.playerRole.roleInfo.sid == event.body.sid)
         {
            --GameData.instance.battleItemNum;
         }
      }
      
      private function battleEnd(event:MessageEvent) : void
      {
         this.round = 0;
         if(GameData.instance.lookBattle == 1)
         {
            switch(GameData.instance.newLookType)
            {
               case 2:
                  this.onShowFailWin("\t本场战斗已结束！",0);
                  break;
               default:
                  this.battleresult = event.body;
            }
         }
         else
         {
            if(Boolean(event) && Boolean(event.body))
            {
               this.battleClose = event.body;
               if(Boolean(this.battleView) && this.battleView.canPlayNextOpration)
               {
                  this.battleView.stopTime();
                  this.dealgameover();
               }
            }
            if(Boolean(this.battleClose))
            {
               if(this.battleClose.arr && this.battleClose.arr.length > 0 && Boolean(this.battleClose.arr[0].res & 0x20))
               {
                  this.failWindow = new BattleAlert(this.battleView,"\t开启战斗失败，请重新匹配对手！",false,true,false,this.onErrorOver,0);
                  this.failWindow.addEventListener(BattleAlert.battleAlertOk,this.onCloseFailBattleView);
                  if(SoundManager.instance.hasOwnProperty("stopBattleMusic"))
                  {
                     SoundManager.instance.stopBattleMusic();
                  }
                  if(Boolean(this.battleView) && Boolean(this.failWindow))
                  {
                     this.battleView.addChild(this.failWindow);
                  }
                  return;
               }
               if(this.battleClose.arr && this.battleClose.arr.length > 0 && this.srcloadover)
               {
                  this.clearBattleView(true);
                  this.clearBattle(null);
               }
            }
         }
      }
      
      private function battleBufRecover(event:MessageEvent) : void
      {
         if(this.battleView == null)
         {
            return;
         }
         if(this.endBuf == null)
         {
            this.endBuf = [];
         }
         this.endBuf.push(event.body);
      }
      
      private function battleBufBlood(event:MessageEvent) : void
      {
         if(this.battleView == null)
         {
            return;
         }
         if(this.endBuf == null)
         {
            this.endBuf = [];
         }
         this.endBuf.push(event.body);
      }
      
      private function battleBuf(event:MessageEvent) : void
      {
         this.stoptime("battlebuf");
         if(this.battleView == null)
         {
            return;
         }
         this.battleView.battleBuf(event.body as BufData);
      }
      
      private function battleBufDis(event:MessageEvent) : void
      {
         this.stoptime("battlebufdis");
         if(this.battleView == null)
         {
            return;
         }
         this.battleView.battleBufDis(event.body);
      }
      
      private function battleToolBack(event:MessageEvent) : void
      {
         this.stoptime("battletoolback");
         if(this.battleView == null)
         {
            return;
         }
         this.battleView.battleToolBack(event.body);
      }
      
      private function battleNewExpBack(event:MessageEvent) : void
      {
         var xml:XML = null;
         var ary:Array = null;
         if(Boolean(this.beforeBattleView))
         {
            if(WindowLayer.instance.stage.contains(this.beforeBattleView))
            {
               WindowLayer.instance.stage.removeChild(this.beforeBattleView);
               this.beforeBattleView.destroy();
               this.beforeBattleView = null;
            }
         }
         if(Boolean(event) && event.body != null)
         {
            this.gameOver = true;
            this.stoptime("battlenewexpback");
            if(this.battleView == null)
            {
               return;
            }
            this.expObj = event.body;
            this.taskobj.win = this.expObj.win;
            this.taskobj.type = this.battleView.battleObject.battleType;
            this.taskobj.spiritid = this.battleView.killMonsterId();
            this.taskobj.escap = this.battleView.escap;
            this.battleView.gameOver = true;
            if(!(this.battleView.canalerwin() || this.expObj.win & 0x10) || this.battleView.puzhuovalue == 1)
            {
               this.battleView.gameOver = false;
            }
            if(Boolean(this.expObj.win & 8))
            {
               this.battleView.otherrun = true;
               this.battleView.playerwin = true;
            }
            else if(Boolean(this.expObj.win & 0x40))
            {
               if(Boolean(this.expObj.win & 0x80))
               {
                  this.battleView.playerwin = true;
               }
               else
               {
                  this.battleView.otherwin = true;
               }
               this.onShowFailWin("本次战场战斗结束啦！这位小卡布请手下留情！",1);
            }
            else if(Boolean(this.expObj.win & 0x80000000))
            {
               this.battleView.playerwin = true;
            }
            else if(!(this.expObj.win & 1))
            {
               this.battleView.otherwin = true;
            }
            if(this.battleView.otherwin != this.battleView.playerwin)
            {
               this.battleView.battlefinish();
            }
            if(Boolean(this.battleView) && 5 == this.battleView.battleObject.battleType)
            {
               --GameData.instance.playerData.bigBattleTimes;
               if(GameData.instance.playerData.bigBattleTimes >= 0 && ExternalInterface.available)
               {
                  ExternalInterface.call("taskStateFunction",-1,-1,-1,-1,GameData.instance.playerData.bigBattleTimes);
               }
            }
         }
         if(this.battleType != 14 && this.battleType != 15 && this.expObj != null && (this.battleView.canalerwin() || this.expObj.win & 0x10 || event == null) && this.battleView.puzhuovalue != 1 && this.flag)
         {
            this.flag = false;
            if(Boolean(this.expObj.win & 1))
            {
               xml = XMLLocator.getInstance().getErrofInfo(910);
               ary = LuaObjUtil.getLuaObjArr(String(xml.combatID));
               if(ary.indexOf(this.battleType) != -1)
               {
                  this.onShowFailWin("中途退出，战斗失败！",0);
               }
               else
               {
                  this.showBattleAlert();
               }
            }
            else if(Boolean(this.expObj.win & 2))
            {
               if(this.expObj.saveExp > 0)
               {
                  this.onShowFailWin("对方中途退出，你在本场较量中获得" + this.expObj.saveExp + "历练",0);
               }
               else if(Boolean(this.expObj.win & 0x80000000))
               {
                  this.onShowFailWin("对方中途退出，你获得了这场战斗的胜利！",0);
               }
               else
               {
                  this.onShowFailWin("中途退出，战斗失败！",0);
               }
            }
            else if(Boolean(this.expObj.win & 8))
            {
               this.onShowFailWin("\t\t妖怪逃跑了！",0);
            }
            else if(Boolean(this.expObj.win & 0x80000000))
            {
               this.spiritsExp = this.expObj.spiritsExp;
               this.wintools = this.expObj.goods;
               if(this.failWindow == null)
               {
                  if(this._isPVP)
                  {
                     if(this.isAvail == 1)
                     {
                        this.onShowFailWin("对方中途退出，你获得了这场战斗的胜利！",0);
                     }
                     else
                     {
                        this.onShowFailWin("恭喜你获得了这场战斗的胜利！",0);
                     }
                  }
                  else
                  {
                     this.showBattleAlert();
                  }
               }
            }
            else if(Boolean(this.expObj.win & 0x10))
            {
               this.onShowFailWin("本次战场战斗结束啦！这位小卡布请手下留情！",1);
            }
            else if(this.battleType == 4)
            {
               if(this.bobOwner)
               {
                  this.onShowFailWin("很可惜，这次战斗你没有获胜，下次继续努力！夺回擂主的资格",1);
               }
               else
               {
                  this.onShowFailWin("很可惜，这次挑战你没有获胜，下次继续努力！",1);
               }
            }
            else if(this.battleType == 6 && this.expObj.totalexp > 0)
            {
               this.spiritsExp = this.expObj.spiritsExp;
               this.wintools = this.expObj.goods;
               this.failtitle = true;
               this.showBattleAlert();
            }
            else if(this.expObj.saveExp > 0)
            {
               this.onShowFailWin("你在本场较量中获得" + this.expObj.saveExp + "历练",0);
            }
            else
            {
               this.onShowFailWin("很遗憾！你在本场较量中失败了！",1);
            }
         }
         else if((this.battleType == 14 || this.battleType == 15) && this.pkObj && this.battleView && (this.battleView.canalerwin() || this.canShowAlert) && this.flag)
         {
            this.flag = false;
            if(this.pkObj.win >= 0)
            {
               this.onShowFailWin("",6,{
                  "xianli":this.pkObj.xianli,
                  "zhangong":this.pkObj.zhangong,
                  "win":this.pkObj.win
               });
            }
            else
            {
               this.onShowFailWin("\t\t对方逃跑了!" + this.pkObj.win,0);
            }
         }
         else if(this.battleType == 7 && Boolean(this.cmwdObj))
         {
            this.clearBattleView(true);
         }
      }
      
      private function onShowFailWin2(str:String, type:int, fun:Function = null) : void
      {
         this.failWindow = new BattleAlert(this.battleView,str,false,true,false,fun,type);
         this.failWindow.addEventListener(BattleAlert.battleAlertOk,this.closeHandler);
         this.battleView.addChild(this.failWindow);
      }
      
      private function onShowFailWin(str:String, type:int, other:Object = null) : void
      {
         this.failWindow = new BattleAlert(this.battleView,str,false,true,false,this.onOverWinClose,type,other);
         this.failWindow.addEventListener(BattleAlert.battleAlertOk,this.onCloseFailBattleView);
         if(SoundManager.instance.hasOwnProperty("stopBattleMusic"))
         {
            SoundManager.instance.stopBattleMusic();
         }
         SoundManager.instance.playSound("battlefail");
         this.battleView.addChild(this.failWindow);
      }
      
      private function onErrorOver(... arg) : void
      {
         dispatch(EventConst.BATTLE_ERROR_OVER);
      }
      
      private function onOverWinClose(... _args) : void
      {
         if(this._isPVP)
         {
            dispatch(EventConst.ARENA_BATTLE_OVER,Boolean(this.expObj.win & 0x80000000));
         }
      }
      
      private function onBattleFSPKback(event:MessageEvent) : void
      {
         this.pkObj = event.body;
         this.battleNewExpBack(null);
      }
      
      private function showBattleAlert() : void
      {
         var i:int = 0;
         var lud:LevelUpData = null;
         if(this.mapControl == null)
         {
            this.mapControl = ApplicationFacade.getInstance().retrieveViewLogic(MapControl.NAME) as MapControl;
         }
         if(Boolean(this.expArr) && Boolean(this.spiritsExp) && Boolean(this.spiritsExp.length))
         {
            for(i = 0; i < this.spiritsExp.length; i++)
            {
               this.expArr.push(this.spiritsExp[i]);
               if(this.spiritsExp[i].type == 2)
               {
                  this.levelArr.push(this.spiritsExp[i]);
               }
            }
            this.spiritsExp = null;
         }
         if(this.expArr && this.expArr.length > 0 && this.battleView != null)
         {
            this.winExpWindow = new WinExpView(this.expArr,this.battleView == null,this.failtitle);
            this.winExpWindow.addEventListener(Event.CLOSE,this.onCloseWinExpWindow);
            this.winExpWindow.x = 338;
            this.winExpWindow.y = (550 - this.winExpWindow.height) / 2;
            if(this.battleView != null)
            {
               if(SoundManager.instance.hasOwnProperty("stopBattleMusic"))
               {
                  SoundManager.instance.stopBattleMusic();
               }
               SoundManager.instance.playSound("battlewin");
            }
            this.winExpWindow.show(this.mapControl.getViewComponent().stage);
            this.failtitle = false;
         }
         else if(Boolean(this.levelArr) && this.levelArr.length > 0)
         {
            lud = this.levelArr.shift();
            this.winLevelWindow = new WinLevelView(lud);
            this.winLevelWindow.addEventListener(Event.CLOSE,this.onCloseWinLevelWindow);
            this.winLevelWindow.x = 308;
            this.winLevelWindow.y = 55;
            SoundManager.instance.playSound("levelUp");
            this.winLevelWindow.show(this.mapControl.getViewComponent().stage);
            if(lud.skillarr.length > 0 && lud.oldskill.length < 4)
            {
               this.learnSkiWindow = new LearnSkillView(lud);
               this.learnSkiWindow.addEventListener(Event.CLOSE,this.onCloseLearnSkillWindow);
               this.learnSkiWindow.addEventListener(Event.CANCEL,this.onCancelLearnSkillWindow);
            }
            else if(lud.skillarr.length > 0 && lud.oldskill.length + lud.skillarr.length > 4)
            {
               this.changSkiWindow = new ChangeSkillView(lud);
               this.changSkiWindow.addEventListener(Event.CLOSE,this.onCloseChangeSkillWindow);
            }
            this.tempLud = lud;
         }
         else if(Boolean(this.expObj) && this.expObj.saveExp > 0)
         {
            if(this.battleView != null)
            {
               if(this.battleType == 4)
               {
                  this.failWindow = new BattleAlert(this.battleView,"恭喜你获得了擂台战的胜利，现在你是擂主了，接受其他玩家的挑战吧！看看你能连胜多少次。赢了" + this.expObj.saveExp + "历练",false,true);
               }
               else
               {
                  this.failWindow = new BattleAlert(this.battleView,"这次战斗你获得" + this.expObj.saveExp + "历练",false,true);
               }
               this.failWindow.addEventListener(BattleAlert.battleAlertOk,this.onCloseFailBattleView);
               this.battleView.addChild(this.failWindow);
            }
         }
         else if(Boolean(this.battleView))
         {
            this.clearBattleView(true);
         }
      }
      
      private function onCloseWinExpWindow(event:Event) : void
      {
         if(Boolean(this.winExpWindow))
         {
            this.winExpWindow.removeEventListener(Event.CLOSE,this.onCloseWinExpWindow);
            this.winExpWindow = null;
            this.expArr = null;
            this.showBattleAlert();
         }
      }
      
      private function onCloseWinLevelWindow(event:Event) : void
      {
         if(this.winLevelWindow == null)
         {
            return;
         }
         this.winLevelWindow.removeEventListener(Event.CLOSE,this.onCloseWinLevelWindow);
         this.winLevelWindow = null;
         if(this.learnSkiWindow != null)
         {
            this.learnSkiWindow.x = 258;
            this.learnSkiWindow.y = 55;
            this.learnSkiWindow.show(this.mapControl.getViewComponent().stage);
         }
         else if(Boolean(this.changSkiWindow))
         {
            this.changSkiWindow.x = 258 + 50;
            this.changSkiWindow.y = 55 - 30 - 50 - 20;
            this.changSkiWindow.show(this.mapControl.getViewComponent().stage);
            this.changSkiWindow.addEventListener(Event.CLOSE,this.onCloseChangeSkillWindow);
         }
         else
         {
            this.showBattleAlert();
         }
      }
      
      private function onCloseChangeSkillWindow(event:Event) : void
      {
         this.changSkiWindow.removeEventListener(Event.CLOSE,this.onCloseChangeSkillWindow);
         this.changSkiWindow = null;
         this.showBattleAlert();
      }
      
      private function onCloseLearnSkillWindow(event:Event) : void
      {
         this.learnSkiWindow.removeEventListener(Event.CLOSE,this.onCloseLearnSkillWindow);
         this.learnSkiWindow = null;
         this.showBattleAlert();
      }
      
      private function onCancelLearnSkillWindow(event:Event) : void
      {
         this.learnSkiWindow.removeEventListener(Event.CLOSE,this.onCloseLearnSkillWindow);
         this.learnSkiWindow.removeEventListener(Event.CANCEL,this.onCancelLearnSkillWindow);
         this.learnSkiWindow = null;
         this.changSkiWindow = new ChangeSkillView(this.tempLud);
         this.changSkiWindow.x = 258 + 50;
         this.changSkiWindow.y = 55 - 30 - 50 - 20;
         this.changSkiWindow.show(AlertContainer.instance);
         this.changSkiWindow.addEventListener(Event.CLOSE,this.onCloseChangeSkillWindow);
      }
      
      private function onCloseFailBattleView(event:Event) : void
      {
         this.failWindow = null;
         if(Boolean(this.expObj) && this.expObj.saveExp <= 0)
         {
            dispatch(EventConst.BATTLE_TO_BOB);
         }
         this.clearBattleView(true);
      }
      
      private function winCopyThings(event:MessageEvent) : void
      {
         this.copyThings = event.body;
      }
      
      private function passCopyHandler(event:MessageEvent) : void
      {
         this.passCopy = true;
      }
      
      private function showBattleRecive(... rest) : void
      {
         var windata:Object = null;
         var xml:XML = null;
         var i:int = 0;
         var str:String = null;
         var url:String = null;
         var awardalert:AwardAlert = null;
         var usetool:String = null;
         if(Boolean(this.wintools) && this.wintools.length > 0)
         {
            this.mapControl = ApplicationFacade.getInstance().retrieveViewLogic(MapControl.NAME) as MapControl;
            windata = this.wintools.shift();
            xml = XMLLocator.getInstance().tooldic[int(windata.itemid)];
            new AwardAlert().showGoodsAward("assets/tool/" + windata.itemid + ".swf",MapView.instance.stage,windata.itemnum + "个" + xml.name,true,this.closeAward);
         }
         else if(Boolean(this.copyThings) && (this.copyThings.thingsdata || this.copyThings.coin != 0))
         {
            for(i = 0; i < this.copyThings.thingsdata.length; i++)
            {
               if(this.copyThings.thingsdata[i].type == 2)
               {
                  str = String(XMLLocator.getInstance().getSprited(this.copyThings.thingsdata[i].getthingsid).name);
                  url = "assets/monsterimg/" + this.copyThings.thingsdata[i].getthingsid + ".swf";
                  awardalert = new AwardAlert();
                  awardalert.showMonsterAward(url,MapView.instance.stage,"你获得了一只" + str,true,this.showBattleRecive);
               }
               else
               {
                  usetool = XMLLocator.getInstance().tooldic[int(this.copyThings.thingsdata[0].getthingsid)].name;
                  new BattleAlert(this,"你获得了" + this.copyThings.thingsdata[0].getthings + "个" + usetool,false,true,false,this.showBattleRecive);
               }
            }
            this.copyThings.thingsdata.length = 0;
            if(this.copyThings.coin == -1)
            {
               new BattleAlert(this,"你刷了好多铜钱了已经，请下次再来吧！",false,true,false,this.showBattleRecive);
            }
            else if(this.copyThings.coin > 0)
            {
               if(Boolean(awardalert))
               {
                  awardalert["removeCallBack"]();
               }
               new BattleAlert(this,"你获得了" + this.copyThings.coin + "铜钱",false,true,false,this.showBattleRecive);
            }
            this.copyThings = null;
         }
         else if(this.passCopy)
         {
            new BattleAlert(this,"<font color=\'#000000\' size=\'24\'>你已经通关!</font>",false,true,false,this.showBattleRecive);
            this.passCopy = false;
         }
         else
         {
            try
            {
               if(Boolean(this.taskobj))
               {
                  dispatch(EventConst.BATTLE_TO_TASK,this.taskobj);
               }
               if(Boolean(this.taskobj.win & 0x80000000))
               {
                  if(GameData.instance.playerData.currentCopyType == 0)
                  {
                     dispatch(EventConst.BATTLE_TO_COPY);
                  }
                  if(GameData.instance.playerData.currentCopyType == 1)
                  {
                     dispatch(EventConst.BATTLE_TO_WANYAOCOPY);
                  }
                  if(GameData.instance.playerData.currentCopyType == 2)
                  {
                     dispatch(EventConst.BATTLE_TO_DOUBLECOPY);
                  }
               }
               else
               {
                  dispatch(EventConst.BATTLE_TO_WARCRAFT,this.taskobj);
               }
            }
            catch(e:*)
            {
            }
         }
         this.mapControl = null;
      }
      
      private function onMsgCode(event:MessageEvent) : void
      {
         if(Boolean(this.battleView))
         {
            this.battleView.updateCode(event.body as String);
         }
      }
      
      private function onBattleSite(event:MessageEvent) : void
      {
         if(Boolean(this.battleView))
         {
            this.battleView.updateSite(event.body);
         }
      }
      
      private function onBattleActOver(event:MessageEvent) : void
      {
         this.cmwdObj = event.body;
         if(this.cmwdObj["result"] == 0 || !this.isEscape)
         {
            this.clearBattleView(true);
         }
      }
      
      private function closeAward(... rest) : void
      {
         this.showBattleRecive();
      }
      
      private function socketErrorAlert(event:MessageEvent) : void
      {
         if(this.battleView == null)
         {
            return;
         }
         this.battleView.stopTime();
         this.onShowFailWin2("飞船受到寒流影响，刚才出现颠簸，你掉线了。",0);
      }
      
      private function showReloginAlert(event:MessageEvent) : void
      {
         if(this.battleView == null)
         {
            return;
         }
         this.battleView.stopTime();
         this.onShowFailWin2("同一个账号又登录了",0);
      }
      
      private function closeHandler(event:Event) : void
      {
         if(Boolean(this.failWindow) && this.battleView.contains(this.failWindow))
         {
            this.battleView.removeChild(this.failWindow);
         }
         this.clearBattleView(false);
         if(ExternalInterface.available)
         {
            ExternalInterface.call("closeshow");
         }
      }
      
      private function showDeactivate(event:MessageEvent) : void
      {
         if(this.battleView == null)
         {
            return;
         }
         this.battleView.stopTime();
         this.onShowFailWin2("这个妖怪被召唤走了！",0);
      }
      
      private function clearBattleView(bool:Boolean) : void
      {
         if(GameData.instance.lookBattle == 1)
         {
            switch(GameData.instance.newLookType)
            {
               case 1:
                  sendMessage(MsgDoc.OP_CLIENT_ACTIVITY_QINGYANG_NEW.send,703,["video_leave"]);
               case 2:
                  GameData.instance.newLookType = 0;
                  GameData.instance.lookBattle = 0;
                  break;
               default:
                  sendMessage(1186234);
            }
         }
         this.remeViewListen();
         if(GameData.instance.playerData.sceneId == 200007)
         {
            sendMessage(MsgDoc.OP_CLIENT_COPY.send,23,[4,0]);
         }
         WindowLayer.instance.visible = true;
         this.stoptime("gameover");
         if(Boolean(this.beforeBattleView))
         {
            if(WindowLayer.instance.stage.contains(this.beforeBattleView))
            {
               WindowLayer.instance.stage.contains(this.beforeBattleView);
               this.beforeBattleView.destroy();
            }
            this.beforeBattleView = null;
         }
         if(Boolean(this.battleView))
         {
            this.battleView.stopTime();
         }
         if(this.battleView && this.battleView.battleObject && this.battleView.battleObject.newbattle)
         {
            dispatch(EventConst.SENDMSGTOSWF,{
               "msgname":"beatover",
               "body":null,
               "radio":"newhand"
            });
         }
         this.mapControl = ApplicationFacade.getInstance().retrieveViewLogic(MapControl.NAME) as MapControl;
         if(Boolean(this.battleView) && Boolean(this.mapControl.getViewComponent().stage.contains(this.battleView)))
         {
            this.mapControl.getViewComponent().stage.removeChild(this.battleView);
         }
         this.viewComponent = null;
         if(Boolean(this.battleView))
         {
            this.battleView.destroy();
         }
         this.mapControl = null;
         this.battleView = null;
         this.expObj = null;
         this.pkObj = null;
         this.cmwdObj = null;
         this.isEscape = false;
         this.expArr = null;
         this.battleClose = null;
         this.showBattleRecive();
         if((this.battleType == 4 || this.battleType == 13) && Boolean(this.taskobj.win & 0x80000000))
         {
            if(Boolean(GameData.instance.playerData.bobOwner & 1 == 1))
            {
               sendMessage(MsgDoc.OP_CLIENT_READY_BOB.send);
            }
            else
            {
               sendMessage(MsgDoc.OP_CLIENT_READY_DBOB.send);
            }
         }
         SocketManager.getGreenSocket().stopmove = false;
         RenderUtil.instance.startRender();
         SoundManager.instance.stopBattleMusic();
         SceneSoundManager.getInstance().playbattlesound = false;
         SceneSoundManager.getInstance().continuePlay();
         sendMessage(MsgDoc.OP_GATEWAY_BATTLE_END.send);
         if(Boolean(this.failWindow))
         {
            this.failWindow.destroy();
            this.failWindow = null;
         }
         this.clearOver = true;
         if(this.needplay)
         {
            new SwfAction().loadAndPlay(MapView.instance,"assets/badge/swf/" + int(this.movieid) + ".swf",0,0);
            this.needplay = false;
         }
         if(GameData.instance.playerData.isAutoBattle)
         {
            this.dispatch(EventConst.AUTOBATTLE_CONTINUE);
         }
         GameData.instance.lookBattle = 0;
         GameData.instance.playerData.taskStatus = BitValueUtil.setBitValue(GameData.instance.playerData.taskStatus,1,false);
         MouseManager.getInstance().setCursor(this.saveMouseName);
         dispatch(EventConst.BATTLE_VIEW_CLEARD);
      }
      
      private function onSpiritLevelUp(event:MessageEvent) : void
      {
         this.expArr = [];
         this.spiritsExp = [];
         this.spiritsExp.push(event.body);
         this.showBattleAlert();
      }
      
      private function starttime(value:int) : void
      {
         if(Boolean(this.mytimer))
         {
            this.mytimer.stop();
            this.mytimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerCompHandler);
            this.mytimer = null;
         }
         this.mytimer = new Timer(value,1);
         this.mytimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerCompHandler);
         this.mytimer.start();
      }
      
      private function onTimerCompHandler(event:TimerEvent) : void
      {
         this.stoptime("ontimercomphandler");
         if(Boolean(this.battleView))
         {
            if(GameData.instance.lookBattle == 1)
            {
               if(GameData.instance.newLookType == 0)
               {
                  sendMessage(MsgDoc.OP_GATEWAY_BATTLE_LOOK_READY.send,0,[this.round]);
                  this.starttime(15000);
                  this.dealgameover();
               }
            }
            else
            {
               this.clearBattleView(false);
            }
         }
      }
      
      private function stoptime(str:String) : void
      {
         if(Boolean(this.mytimer))
         {
            this.mytimer.stop();
            this.mytimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerCompHandler);
            this.mytimer = null;
         }
      }
      
      private function onPlayBadgeMovie(event:MessageEvent) : void
      {
         if(this.battleView != null)
         {
            this.needplay = true;
            this.movieid = int(event.body);
         }
      }
      
      private function dealgameover() : void
      {
         var len:int = 0;
         var msg:String = null;
         var flag:Boolean = false;
         var curIndex:int = 0;
         var res:int = 0;
         if(Boolean(this.battleView))
         {
            if(GameData.instance.newLookType == 1 && BattleLookList.ins.getLookLen() == 0 && Boolean(this.newBattleResult))
            {
               this.onShowFailWin2(this.newBattleResult,5);
               this.newBattleResult = null;
            }
            else if(Boolean(this.battleresult))
            {
               if(this.battleresult.hasOwnProperty("arr"))
               {
                  if(Boolean(this.battleView.playerRole))
                  {
                     len = int(this.battleresult.arr.length);
                     msg = "";
                     flag = true;
                     curIndex = 0;
                     while(curIndex < len)
                     {
                        O.o("【battlelookerControl观战结束处理】");
                        if(this.battleresult.arr[curIndex].sid == this.battleView.playerRole.roleInfo.sid)
                        {
                           res = int(this.battleresult.arr[curIndex].res);
                           if(Boolean(res & 0x80000000) && this.failWindow == null)
                           {
                              msg = "擂主【" + this.battleView.pn + "】" + "击败挑战者【" + this.battleView.on + "】,守擂成功！";
                              flag = false;
                           }
                           else if((Boolean(res & 0x10) || Boolean(res & 8)) && this.failWindow == null)
                           {
                              msg = "挑战者【" + this.battleView.pn + "】" + "擂主【" + this.battleView.on + "】,守擂成功！";
                              flag = false;
                           }
                           else if(this.failWindow == null && curIndex == len - 1)
                           {
                              O.o("【battlelookerControl没符合条件最终处理】" + len);
                              msg = "挑战者【" + this.battleView.on + "】" + "击败擂主【" + this.battleView.pn + "】,挑战成功！";
                              flag = false;
                           }
                           this.onShowFailWin2(msg,5);
                        }
                        curIndex++;
                     }
                     if(flag && this.failWindow == null)
                     {
                        O.o("【battlelookerControl没符合条件bbbbb最终处理】" + len);
                        msg = "擂主【" + this.battleView.pn + "】" + "掉线了，【" + this.battleView.on + "】,挑战成功！";
                        this.onShowFailWin2(msg,5);
                     }
                     this.battleresult = null;
                     this.stoptime("dealgameover");
                  }
               }
            }
         }
      }
   }
}

