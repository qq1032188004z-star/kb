package com.game.modules.control
{
   import com.channel.Message;
   import com.core.observer.MessageEvent;
   import com.core.view.ViewConLogic;
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.locators.GameData;
   import com.game.locators.MsgDoc;
   import com.game.modules.ai.SpecialAreaManager;
   import com.game.modules.control.task.util.Task;
   import com.game.modules.control.task.util.TaskListItems;
   import com.game.modules.view.DomainView;
   import com.game.modules.view.FaceView;
   import com.game.modules.view.HomeMessageTipView;
   import com.game.modules.view.MapView;
   import com.game.modules.view.SelectServer;
   import com.game.modules.view.WindowLayer;
   import com.game.modules.view.achieve.GetAchieve;
   import com.game.modules.view.challenge.ChallengeView;
   import com.game.modules.view.chat.ChatView;
   import com.game.modules.view.chat.ImgSave;
   import com.game.modules.view.gameexchange.GameExchange;
   import com.game.modules.view.pop.Tales;
   import com.game.modules.view.pop.TrigramesGame;
   import com.game.modules.view.task.CellPhone;
   import com.game.modules.view.task.CellPhoneToLuote;
   import com.game.modules.view.task.CellPhoneToUrl;
   import com.game.modules.view.task.CollectSingleChoice;
   import com.game.modules.view.task.DailyTask;
   import com.game.modules.view.task.EightTrigrams;
   import com.game.modules.view.task.FoundWayGame;
   import com.game.modules.view.task.SingleChoice;
   import com.game.modules.view.task.TaskDialog;
   import com.game.modules.view.task.TaskView;
   import com.game.modules.view.task.activation.AwardBox;
   import com.game.modules.view.task.activation.ChildrensDay;
   import com.game.modules.view.task.activation.ExtensionMoveGame;
   import com.game.modules.view.task.activation.FlashingMouse;
   import com.game.modules.view.task.activation.GetFreshManPet;
   import com.game.modules.view.task.activation.HardWorkAward;
   import com.game.modules.view.task.activation.InputAndConfirm;
   import com.game.modules.view.task.activation.PractisePuzzle;
   import com.game.modules.view.task.activation.SevenCountryAward;
   import com.game.modules.view.task.activation.ShortCut;
   import com.game.modules.view.task.activation.TestForMessager;
   import com.game.modules.view.task.freshman.BetaOnline;
   import com.game.modules.view.task.freshman.FreshmanTask;
   import com.game.modules.view.task.freshman.ThanksGiven;
   import com.game.util.CacheUtil;
   import com.game.util.CheckOnlineUtil;
   import com.game.util.FloatAlert;
   import com.game.util.HLoaderSprite;
   import com.game.util.LittleGameStartUI;
   import com.game.util.TaskAcceptMachine;
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.alert.Alert;
   import com.publiccomponent.alert.AlertContainer;
   import com.publiccomponent.quickmsg.QuickMessage;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.utils.clearInterval;
   import flash.utils.clearTimeout;
   import flash.utils.getDefinitionByName;
   import flash.utils.setInterval;
   import flash.utils.setTimeout;
   import phpcon.PhpConnection;
   
   public class WindowLayerControl extends ViewConLogic
   {
      
      public static const NAME:String = "WindowLayerControl";
      
      private var hadOpenNewHandView:Boolean;
      
      private var leaveTid:uint;
      
      private var timeOut:uint;
      
      private var startTime:Number;
      
      private var npcautoCallback:Function;
      
      public function WindowLayerControl(viewComponent:Object)
      {
         super(NAME,viewComponent);
      }
      
      public function get view() : WindowLayer
      {
         return this.getViewComponent() as WindowLayer;
      }
      
      override public function onRegister() : void
      {
         this.view.stage.addEventListener(Event.DEACTIVATE,this.onDeactivateHandler);
         this.view.stage.addEventListener(Event.ACTIVATE,this.onActivateHandler);
      }
      
      private function onDeactivateHandler(e:Event = null) : void
      {
         this.onActivateHandler();
         if(GameData.instance.playerData.bobOwner != 0)
         {
            return;
         }
         if(GameData.instance.playerData.isAutoBattle)
         {
            this.timeOut = setTimeout(this.onDeactivateHandler,3000);
         }
         else if(GameData.instance.playerData.playerStatus == 7)
         {
            this.startTime = new Date().getTime();
            this.leaveTid = setInterval(this.onEnterFrame,2000);
         }
      }
      
      private function onEnterFrame() : void
      {
         var endTime:Number = new Date().getTime() - this.startTime;
         if(endTime > 300000)
         {
            this.onLeave();
         }
      }
      
      private function onActivateHandler(e:Event = null) : void
      {
         clearInterval(this.leaveTid);
         clearTimeout(this.timeOut);
      }
      
      private function onLeave() : void
      {
         clearInterval(this.leaveTid);
         if(GameData.instance.playerData.playerStatus == 7 || GameData.instance.playerData.isAutoBattle || GameData.instance.playerData.bobOwner != 0)
         {
            return;
         }
         sendMessage(MsgDoc.OP_CLIETN_SERV_STOP.send,GameData.instance.playerData.userId,[1]);
      }
      
      override public function listEvents() : Array
      {
         return [[EventConst.OPEN_CACHE_VIEW,this.openCacheView],[EventConst.OPEN_EXTRAL_CACHE_VIEW,this.openExtralCacheView],[EventConst.OPENSWFWINDOWS,this.onOpenSwfWindow],[EventConst.OPEN_MODULE,this.onOpenModule],[EventConst.GETPROPSLIST,this.onGetPropsList],[EventConst.USEPROPS,this.onUseProps],[EventConst.OPENDIAVIEW,this.onOpenDiaView],[EventConst.OPENTASKARCHIVES,this.onOpenTaskArchives],[EventConst.ADDTASKINTOTASKLISTITEMS,this.onAddTaskIntoTaskListItems],[EventConst.REMOVETASKFROMTASKLISTITEMS,this.onRemoveTaskFromTaskListItems],[EventConst.ONCLICKDAILYTASKBACK,this.openDailyTaskList],[EventConst.ONCLICKRUCLIPONE,this.openTestView],[EventConst.OPENPOPUPINDIALOG,this.openPopUpInDialog],[EventConst.OPENTASKACCEPTCLIP,this.onOpenTaskAccepClip],[EventConst.OPENSINGLECHOICE,this.onOpenSingleChoice],[EventConst.OPENEIGHTTRIGRAM,this.openEightTrigram],[EventConst.NONSENSE_NPC_SAY_OVER,this.npcAutoSayOver],[EventConst.ACTIVE_TASK_BACK,this.activeTaskBack],[EventConst.SHOW_ACTIVE_UI_VIEW,this.openActiveUIView]
         ,[EventConst.POPUP_WINDOW_TO_CONTROL,this.sendActivation],[EventConst.CONTROL_TO_POPUP_WINDOW,this.getActivationBack],[EventConst.OPEN_HARDWORKAWARDBACK,this.openHardworkawardback],[EventConst.TO_REQ_HARDWORKAWARD,this.toRequesetHardworkaward],[EventConst.OPEN_LABOR_DAY_VIEW,this.openLaborDayView],[EventConst.OPENSELECTSERVER,this.openSelectServer],[EventConst.SHOWSERVERLIST,this.showServerList],[EventConst.CLEARUI,this.onClearHandler],[EventConst.OPENPERSONINFOVIEW,this.openPersonInfoView],[EventConst.OPENPERSONDETAILVIEW,this.openPersonDetailView],[EventConst.GETMONSTERINFO,this.onGetMonsterInfo],[EventConst.CHATWITHFRIEND,this.openChatView],[EventConst.SENDQUICKMSG,this.onOpenQuickMsgView],[EventConst.SHOWVIEW,this.showView],[EventConst.REQ_RECALL_TRUMP,this.onRecallTrump],[EventConst.REQ_DOCTOR_SPIRIT,this.onDoctorSpirit],[EventConst.SHOW_LITTLE_GAME_START,this.onShowLittleGameStartUI],[EventConst.OP_THE_BALLON_ACTIVE_AWARD,this.onBallonActiveAwardBack],[EventConst.ON_CLICK_YAOJIANGJI
         ,this.onClickYaojiangji],[EventConst.GETCLASSPASSEXP,this.onGetClassPassExp],[EventConst.REQ_DENGLONG_INFO,this.onGetDenglongInfo],[EventConst.BOBSTATECLICK,this.onClickBobState],[EventConst.BUYSHENSHOUTOOLS,this.onBuyShenshouTools],[EventConst.SHOWLITGAMELIST,this.openLitgameList],[EventConst.JUSTSENDTOSERVER,this.onJustSendToServer],[EventConst.GETTRAININGMONSTERINFO,this.onGetTrainingMonsterInfo],[EventConst.FARMNEWHANDSTATUSERROR,this.onFarmNewHandStatusError],[EventConst.REQ_MOA_BACK,this.onReqMOABack],[EventConst.BOX_MESSAGES_EVENT,this.onBoxMessageCome],[EventConst.GET_WEEDKEND_AWARD,this.onGetWeedkend],[EventConst.GETANSWERAWARD,this.onGetAnswerAward],[EventConst.MAA_TASK_ACTION,this.onMaaTaskAction],[EventConst.TREAT_MANY_SPIRIT,this.onTreatManySpirit],[EventConst.MAA_TASK_COMPLETE,this.onMaaTaskComplete],[EventConst.GET_ITEM_NUM,this.onGetItemNum]];
      }
      
      private function openCacheView(event:MessageEvent) : void
      {
         var cls:Class = null;
         var ui:HLoaderSprite = null;
         if(event.name == "com.game.modules.view.FriendView")
         {
            if(!GameData.instance.playerData.isFriendViewOpen)
            {
               dispatch(EventConst.BOBSTATECLICK,{
                  "url":"assets/friend/FriendsView.swf",
                  "xCoord":560,
                  "yCoord":80
               });
            }
         }
         else if(event.name == "com.game.modules.view::PackView" || event.name == "com.game.modules.view.PackView")
         {
            dispatch(EventConst.BOBSTATECLICK,{
               "url":"assets/module/MyInfoDetailView.swf",
               "moduleParams":{"actTab":"packTab"}
            });
         }
         else
         {
            cls = getDefinitionByName(event.name) as Class;
            ui = CacheUtil.getObject(cls) as HLoaderSprite;
            if(Boolean(ui))
            {
               ui.initParams(event.body);
               if(AlertContainer.instance.numChildren >= 1)
               {
                  if(Boolean(event.body) && Boolean(event.body.hasOwnProperty("showX")))
                  {
                     ui.x = event.body.showX;
                     ui.y = event.body.showY;
                  }
                  this.view.stage.addChild(ui);
               }
               else
               {
                  this.view.showUI(ui,event.body.showX,event.body.showY);
               }
            }
         }
      }
      
      private function openExtralCacheView(event:MessageEvent) : void
      {
         var flag:int = 0;
         var display:DisplayObject = null;
         var cls:Class = getDefinitionByName(event.name) as Class;
         var ui:HLoaderSprite = new cls() as HLoaderSprite;
         ui.initParams(event.body);
         for(var k:int = 0; k < this.view.numChildren; k++)
         {
            display = this.view.getChildAt(k) as DisplayObject;
            if(display is GetAchieve)
            {
               flag++;
            }
         }
         this.view.showExtraUI(ui,event.body.showX,event.body.showY - flag * 60);
      }
      
      private function openGameexhchangeView(evt:MessageEvent) : void
      {
         var obj:DisplayObject = CacheUtil.getObject(GameExchange) as DisplayObject;
         this.view.showUI(obj,0,0);
      }
      
      private function onOpenSwfWindow(event:MessageEvent) : void
      {
         this.view.clear();
         var obj:Object = event.body;
         if(Boolean(obj.hasOwnProperty("callback")) && obj.callback != null)
         {
            this.view.openSwfView("正在打开",URLUtil.getSvnVer(obj.url),true,false,obj.callback,obj.xCoord,obj.yCoord);
         }
         else
         {
            this.view.openSwfView("正在打开",URLUtil.getSvnVer(obj.url),true,true,null,obj.xCoord,obj.yCoord);
         }
      }
      
      private function onOpenModule(evt:MessageEvent) : void
      {
         var obj:Object = evt.body;
         this.view.openModule("正在打开",URLUtil.getSvnVer(obj.url),true,true,null,obj.xCoord,obj.yCoord,obj.params);
      }
      
      private function onGetPropsList(event:MessageEvent) : void
      {
         var code:int = event.body as int;
         sendMessage(MsgDoc.OP_CLIENT_REQ_PACKAGE_DATA.send,code);
      }
      
      private function onUseProps(event:MessageEvent) : void
      {
         var selectData:Object = null;
         var list:Array = null;
         var symmObj:Object = null;
         var params:Object = event.body;
         if(params.prosid == 103013 || params.prosid == 103014)
         {
            if(GameData.instance.playerData.sceneType == 0 && GameData.instance.playerData.currentScenenId != 15000)
            {
               sendMessage(MsgDoc.OP_CLIENT_USE_PROPS.send,params.prosid,[params.jinghunid,params.gongneng,params.temp1,params.temp2]);
               if(params.prosid == 103013)
               {
                  sendMessage(MsgDoc.OP_CLIENT_REQ_PACKAGE_DATA.send,4294967295);
               }
            }
            else
            {
               new Alert().showOne("该场景不能使用寻宝罗盘哦!");
            }
         }
         else if(params.prosid == 400225)
         {
            if(GameData.instance.playerData.sceneType != 0 || GameData.instance.playerData.currentScenenId == 15000)
            {
               new Alert().showOne("当前场景不可使用同享符，请到其他场景试试看吧!");
            }
            else
            {
               sendMessage(MsgDoc.OP_CLIENT_USE_PROPS.send,params.prosid,[params.jinghunid,params.gongneng,params.temp1,params.temp2]);
            }
         }
         else if(params.prosid == 100746)
         {
            sendMessage(MsgDoc.OP_CLIENT_USE_PROPS.send,params.prosid,[params.jinghunid,params.gongneng,params.temp1,params.temp2]);
            sendMessage(MsgDoc.OP_CLIENT_REQ_ZHUANGBEI.send);
            sendMessage(MsgDoc.OP_CLIENT_REQ_PRESURES.send);
            sendMessage(MsgDoc.OP_CLIENT_REQ_PACKAGE_DATA.send,4294967295);
         }
         else if(params.prosid == 920702)
         {
            sendMessage(MsgDoc.OP_CLIENT_USE_PROPS.send,params.prosid,[params.jinghunid,params.gongneng,params.temp1,params.temp2]);
            sendMessage(MsgDoc.OP_CLIENT_SPIRIT_EQUIP_ALL.send,GameData.instance.playerData.userId,[1]);
         }
         else if(params.prosid >= 103017 && params.prosid <= 103020)
         {
            selectData = params.selectdata;
            if(selectData == null)
            {
               new Alert().showOne("请先选择一只妖怪");
               return;
            }
            if(selectData.hasOwnProperty("symmList"))
            {
               list = selectData.symmList;
               for each(symmObj in list)
               {
                  if(symmObj.symmPlace == 2)
                  {
                     sendMessage(MsgDoc.OP_CLIENT_USE_PROPS.send,params.prosid,[params.jinghunid,params.gongneng,params.temp1,params.temp2,symmObj.symmIndex]);
                     return;
                  }
               }
               new Alert().showOne("抱歉，妖怪身上没有装备灵玉");
            }
         }
         else
         {
            sendMessage(MsgDoc.OP_CLIENT_USE_PROPS.send,params.prosid,[params.jinghunid,params.gongneng,params.temp1,params.temp2]);
         }
      }
      
      private function onClearHandler(event:MessageEvent) : void
      {
         this.view.clear();
      }
      
      private function openPersonInfoView(event:MessageEvent) : void
      {
         dispatch(EventConst.BOBSTATECLICK,{
            "url":"assets/module/PersonInfoView.swf",
            "moduleParams":event.body
         });
      }
      
      private function openPersonDetailView(event:MessageEvent) : void
      {
         if(GameData.instance.playerData.isNewHand == 9)
         {
            dispatch(EventConst.BOBSTATECLICK,{"url":"assets/module/MyInfoDetailView.swf"});
         }
      }
      
      private function openLitgameList(evt:MessageEvent) : void
      {
         var object:DisplayObject = CacheUtil.getObject(ChallengeView) as DisplayObject;
         object["gameArr"] = evt.body;
         this.view.showUI(object,524,68);
      }
      
      private function openChatView(event:MessageEvent) : void
      {
         var object:DisplayObject = null;
         var params:Object = event.body;
         if(params.hasOwnProperty("family"))
         {
            object = CacheUtil.getObjectByName(params.userId,ChatView) as DisplayObject;
         }
         else
         {
            object = CacheUtil.getObjectByName(params.userId + "family",ChatView) as DisplayObject;
         }
         object["params"] = params;
         this.view.showExtraUI(object,400,280);
      }
      
      private function onOpenDiaView(evt:MessageEvent) : void
      {
         if(GameData.instance.playerData.isNewHand < 9)
         {
            SpecialAreaManager.instance.removeNewHandMask();
         }
         var object:DisplayObject = CacheUtil.getObject(TaskDialog) as DisplayObject;
         if(GameData.instance.playerData.currentScenenId != 1013 && GameData.instance.playerData.currentScenenId != 1018 && GameData.instance.playerData.currentScenenId != 1023 && TaskView.instance.currentDialogID != 601000401 && GameData.instance.playerData.copyScene <= 0)
         {
            this.view.clear();
         }
         var obj:Object = evt.body;
         if(!obj.hasOwnProperty("needchoose"))
         {
            obj.needchoose = 0;
         }
         (CacheUtil.pool[TaskDialog] as TaskDialog).setData(obj.task as Task,obj.position,obj.needchoose);
         if(MapView.instance.masterPerson != null)
         {
            MapView.instance.masterPerson.stop();
         }
         this.view.showUI(object,0,0);
      }
      
      private function onAddTaskIntoTaskListItems(event:MessageEvent) : void
      {
         if(GameData.instance.playerData.currentScenenId != 1013)
         {
            this.view.clear();
         }
         var object:DisplayObject = CacheUtil.getObject(TaskListItems) as DisplayObject;
         (CacheUtil.pool[TaskListItems] as TaskListItems).addTask(event.body);
         FaceView.clip.hideBottom();
         MapView.instance.masterPerson.stop();
         this.view.showUI(object,0,0);
      }
      
      private function onRemoveTaskFromTaskListItems(event:MessageEvent) : void
      {
         this.view.clearPopUpBox(CacheUtil.getObject(TaskListItems) as DisplayObject);
      }
      
      private function onOpenTaskArchives(event:MessageEvent) : void
      {
         var object:DisplayObject = null;
         var type:int = event.body as int;
         if(type == 1)
         {
            trace("任务档案已经不能再从这里打开了哟。。。亲....");
         }
         else if(type == 2)
         {
            if(GameData.instance.playerData.isNewHand != 9)
            {
               new Alert().showOne("你还没有做完新手指引哦...");
               return;
            }
            object = CacheUtil.getObject(ChildrensDay) as DisplayObject;
         }
         if(!this.view.contains(object))
         {
            object["setData"]();
         }
         this.view.showUI(object,0,0);
      }
      
      private function onOpenQuickMsgView(event:MessageEvent) : void
      {
         var object:DisplayObject = CacheUtil.getObject(QuickMessage) as DisplayObject;
         this.view.showUI(object,0,15,false);
      }
      
      private function openSelectServer(event:MessageEvent) : void
      {
         var object:DisplayObject = CacheUtil.getObject(SelectServer) as DisplayObject;
         this.view.showUI(object,0,0,false);
      }
      
      private function showServerList(event:MessageEvent) : void
      {
         var object:DisplayObject = CacheUtil.getObject(SelectServer) as DisplayObject;
         object["setData"](event.body);
      }
      
      private function onGetMonsterInfo(event:MessageEvent) : void
      {
         sendMessage(MsgDoc.OP_CLIENT_REQ_MONSTER_INFO.send,int(event.body));
      }
      
      private function showView(event:MessageEvent) : void
      {
         var object:ImgSave = new ImgSave(event.body as BitmapData);
         object.initImage(event.body as BitmapData);
         this.view.showExtraUI(object,400,280);
      }
      
      private function clearPopUpBox(event:MessageEvent) : void
      {
         this.view.clearPopUpBox();
      }
      
      private function openDailyTaskList(event:MessageEvent) : void
      {
         var param:Object = event.body;
         var cls:DisplayObject = CacheUtil.getObject(DailyTask) as DisplayObject;
         (CacheUtil.pool[DailyTask] as DailyTask).setData();
         this.view.showUI(cls,0,0);
      }
      
      private function openTestView(event:MessageEvent) : void
      {
         var params:int = int(event.body);
         var cls:DisplayObject = CacheUtil.getObject(FreshmanTask) as DisplayObject;
         (CacheUtil.pool[FreshmanTask] as FreshmanTask).setData(params);
         this.view.showUI(cls,0,0);
      }
      
      private function openPopUpInDialog(evt:MessageEvent) : void
      {
         var params:Object = null;
         var cls:DisplayObject = null;
         var shape:Sprite = null;
         var len:int = 0;
         var i:int = 0;
         var nonsenseArr:Array = null;
         var cur:int = 0;
         var tmp:int = 0;
         params = evt.body;
         var preStr:String = params.opdata.opName.substr(0,7);
         if(preStr == "swfview")
         {
            this.view.openSwfView("正在加载...",URLUtil.getSvnVer("assets/material/" + params.opdata.opName + ".swf"),true,false,params.callback,0,0);
            return;
         }
         if(preStr == "modules")
         {
            if(params.opdata.opName == "modules30" || params.opdata.opName == "modules39")
            {
               if(params.opdata.opName == "modules39")
               {
                  this.dispatch(EventConst.BOBSTATECLICK,{
                     "url":"assets/system/symmModule/SymmModule.swf",
                     "callback":params.callback
                  });
               }
               else
               {
                  this.dispatch(EventConst.BOBSTATECLICK,{
                     "url":"assets/module/" + params.opdata.opName + ".swf",
                     "callback":params.callback
                  });
               }
            }
            else
            {
               this.view.openModule("正在加载...",URLUtil.getSvnVer("assets/module/" + params.opdata.opName + ".swf"),true,false,params.callback,0,0,params.opdata.popid);
            }
            if(params.opdata.opName == "modules307900106" || params.opdata.opName == "modules960001701" || params.opdata.opName == "modules100300302")
            {
               params.callback.apply(null,[false]);
            }
            return;
         }
         switch(params.opdata.opName)
         {
            case "phonecalltourl":
               cls = CacheUtil.getObject(CellPhoneToUrl) as DisplayObject;
               cls["initView"](params.opdata.opurl);
               cls["setData"](params);
               break;
            case "phonecall":
               cls = CacheUtil.getObject(CellPhone) as DisplayObject;
               cls["setData"](params);
               break;
            case "phonecallluote":
               cls = CacheUtil.getObject(CellPhoneToLuote) as DisplayObject;
               cls["setData"](params);
               break;
            case "littegame":
               if(params.opdata.popid == 12)
               {
                  this.dispatch(EventConst.SHOW_LITTLE_GAME_START,12);
                  (params.callback as Function).apply(null,[false]);
                  return;
               }
               if(ApplicationFacade.getInstance().retrieveViewLogic(LittlegameControl.NAME) == null)
               {
                  ApplicationFacade.getInstance().registerViewLogic(new LittlegameControl());
               }
               if(params.opdata.popid > 1000 && params.opdata.popid != 1004 && params.opdata.popid != 1008 && params.opdata.popid != 1002 && params.opdata.popid != 1003)
               {
                  this.dispatch(EventConst.LITTLE_GAME_START,params.opdata.popid);
                  (params.callback as Function).apply(null,[false]);
               }
               else
               {
                  this.dispatch(EventConst.LITTLE_GAME_START,{
                     "gameid":params.opdata.popid,
                     "callback":params.callback
                  });
               }
               break;
            case "newhandbook":
               this.view.openSwfView("正在加载飞船手册.",URLUtil.getSvnVer("assets/login/book.swf"),true,true,params.callback as Function);
               break;
            case "nonsense":
               shape = new Sprite();
               shape.graphics.beginFill(16711680,0);
               shape.graphics.drawRect(0,0,1100,700);
               shape.graphics.endFill();
               shape.mouseEnabled = false;
               shape.mouseChildren = false;
               this.view.showUI(shape,-100,-100);
               this.npcautoCallback = params.callback;
               len = int(params.opdata.desc.length);
               i = 0;
               nonsenseArr = [];
               for(i = 0; i < len; i++)
               {
                  nonsenseArr.push(this.parseAutoTalk(params.opdata.desc[i]));
               }
               this.dispatch(EventConst.NONSENSE_NPC_SAY_SOMETHING,nonsenseArr);
               break;
            case "makeupbook":
               this.view.openSwfView("正在加载装扮手册...",URLUtil.getSvnVer("assets/login/zhuanban.swf"),true,false,params.callback as Function);
               break;
            case "learnmagic1":
               this.view.openSwfView("正在加载法术说明...","assets/material/learnmagic1.swf",false,true);
               break;
            case "raremonster":
               cls = CacheUtil.getObject(InputAndConfirm) as DisplayObject;
               cls["show"]();
               break;
            case "foundway":
               cls = CacheUtil.getObject(FoundWayGame) as DisplayObject;
               cls["setData"](params);
               break;
            case "practisepuzzle":
               cls = new PractisePuzzle();
               cls["setData"](params);
               break;
            case "magicmedicine":
               this.view.openSwfView("正在加载神奇的药...",URLUtil.getSvnVer("assets/material/magicmedicine.swf"),false,true,params.callback as Function);
               break;
            case "zhuomicang":
               cur = (Math.random() * 3 >> 0) + 1;
               this.view.openSwfView("正在加载捉迷藏...",URLUtil.getSvnVer("assets/material/zhuomicang" + cur + ".swf"),false,true,params.callback as Function);
               break;
            case "desktopshortcut":
               cls = new ShortCut();
               cls["setData"](params);
               break;
            case "testformessager":
               cls = new TestForMessager();
               cls["setData"](params);
               break;
            case "flashingmouse":
               cls = new FlashingMouse();
               cls["setData"](params);
               break;
            case "extension22game":
               cls = new ExtensionMoveGame();
               cls["setData"](params);
               break;
            case "extension22ai":
               if(!params.hasOwnProperty("callback"))
               {
                  this.view.openSwfView("正在加载...",URLUtil.getSvnVer("assets/material/extensionai" + params.opdata.item + ".swf"),true,true);
               }
               else
               {
                  this.view.openSwfView("正在加载...",URLUtil.getSvnVer("assets/material/extensionai" + params.opdata.item + ".swf"),true,true,params.callback);
               }
               break;
            case "texiao6006002":
               if(params.hasOwnProperty("callback"))
               {
                  this.dispatch(EventConst.ADDDYNAMICUIONMAINUI,{
                     "type":3,
                     "x":360,
                     "y":11,
                     "uiname":"texiao2",
                     "index":31,
                     "lastFrame":params.callback
                  });
               }
               break;
            case "kabutales":
               cls = new Tales();
               cls["setData"](params.callback);
               break;
            case "extension25ai":
               cls = new TrigramesGame();
               cls["setData"](params);
               break;
            case "mask":
               if(params.opdata.popid == 7009)
               {
                  this.dispatch(EventConst.OPENPERSONDETAILVIEW,{
                     "userId":GameData.instance.playerData.userId,
                     "isOnline":1,
                     "source":0,
                     "userName":GameData.instance.playerData.userName,
                     "sex":GameData.instance.playerData.roleType & 1,
                     "body":GameData.instance.playerData
                  });
                  this.view.openSwfView("正在加载...",URLUtil.getSvnVer("assets/material/mask7009.swf"),true,false,params.callback,0,0);
               }
               break;
            case "mazeisland":
               (params.callback as Function).apply(null,[false]);
               this.sendMessage(MsgDoc.OP_QUERY_COPYP_ROGRESS.send,3);
               break;
            case "leavemazeisland":
               GameData.instance.playerData.isInMazeIsland = false;
               (params.callback as Function).apply(null,[false]);
               this.dispatch(EventConst.ONLEFTCOPY,{
                  "steerX":MapView.instance.masterPerson.x,
                  "steerY":MapView.instance.masterPerson.y,
                  "id":5003
               });
               break;
            case "showface":
               (params.callback as Function).apply(null,[null]);
               tmp = int(params.opdata.popid);
               if(params.opdata.popid == -4)
               {
                  tmp = GameData.instance.playerData.initFaceId;
               }
               else if(Boolean(GameData.instance.playerData.roleType & 1 <= 0))
               {
                  tmp -= 4;
               }
               MapView.instance.masterPerson.roleFace.setRole({"faceId":tmp});
               break;
            case "NewBattle2":
               dispatch(EventConst.BOBSTATECLICK,{
                  "url":"assets/module/NewBattle2.swf",
                  "xCoord":0,
                  "yCoord":0,
                  "callback":params.callback
               });
               break;
            case "NewBattle3":
               dispatch(EventConst.BOBSTATECLICK,{
                  "url":"assets/module/NewBattle3.swf",
                  "xCoord":0,
                  "yCoord":0,
                  "callback":params.callback
               });
         }
         if(cls != null)
         {
            this.view.showUI(cls,0,0);
         }
      }
      
      private function onOpenSingleChoice(evt:MessageEvent) : void
      {
         var cls:DisplayObject = null;
         var xCoord:Number = 0;
         var yCoord:Number = 0;
         switch(evt.body.boardId)
         {
            case 1:
               cls = CacheUtil.getObject(SingleChoice) as DisplayObject;
               cls["setData"](evt.body);
               xCoord = 0;
               yCoord = 0;
               break;
            case 2:
               cls = CacheUtil.getObject(CollectSingleChoice) as DisplayObject;
               cls["setData"](evt.body);
               xCoord = 0;
               yCoord = 0;
         }
         if(cls != null)
         {
            this.view.showUI(cls,xCoord,yCoord);
         }
         if(!FaceView.clip.bottomClip.visible)
         {
            FaceView.clip.showBottom();
         }
      }
      
      private function onRecallTrump(event:MessageEvent) : void
      {
         var index:int = int(event.body);
         sendMessage(MsgDoc.OP_CLIENT_TRUMP_OPRATION.send,index);
      }
      
      private function onDoctorSpirit(event:MessageEvent) : void
      {
         sendMessage(MsgDoc.OP_CLIENT_DOCTOR_SPIRIT.send,1);
      }
      
      private function onOpenTaskAccepClip(evt:MessageEvent) : void
      {
         var cls:DisplayObject = CacheUtil.getObject(TaskAcceptMachine) as DisplayObject;
         (CacheUtil.getObject(TaskAcceptMachine) as TaskAcceptMachine).setData(evt.body);
         this.view.showUI(cls,100,50);
      }
      
      private function openEightTrigram(evt:MessageEvent) : void
      {
         var cls:DisplayObject = CacheUtil.getObject(EightTrigrams) as DisplayObject;
         (cls as EightTrigrams).setData(evt.body.trigram,evt.body.exp,evt.body.npcid,evt.body.currentId,evt.body.itemid);
         MapView.instance.masterPerson.stop();
         this.view.showUI(cls,0,0);
      }
      
      private function onShowLittleGameStartUI(evt:MessageEvent) : void
      {
         var cls:DisplayObject = CacheUtil.getObject(LittleGameStartUI) as DisplayObject;
         (cls as LittleGameStartUI).startLittleGame(int(evt.body));
         this.view.showUI(cls,0,0);
      }
      
      private function parseAutoTalk(str:String) : Object
      {
         var obj:Object = {};
         obj.id = int(str.slice(str.indexOf("#") + 1,str.lastIndexOf("#")));
         obj.msg = str.slice(str.lastIndexOf("#") + 1);
         return obj;
      }
      
      private function npcAutoSayOver(evt:MessageEvent) : void
      {
         this.view.clear();
         if(this.npcautoCallback != null)
         {
            this.npcautoCallback.apply(null,[null]);
         }
      }
      
      private function activeTaskBack(evt:MessageEvent) : void
      {
         this.view.clear();
         var cls:DisplayObject = CacheUtil.getObject(BetaOnline) as DisplayObject;
         cls["setData"](evt.body);
         this.view.showUI(cls,0,0,false);
      }
      
      private function openActiveUIView(evt:MessageEvent) : void
      {
         this.view.showUI(new ThanksGiven(),0,0,false);
      }
      
      private function sendActivation(evt:MessageEvent) : void
      {
         this.sendMessage(MsgDoc.OP_CLIENT_REQ_ACTIVATION.send,0,[evt.body as String]);
      }
      
      private function getActivationBack(evt:MessageEvent) : void
      {
         var param:Object = evt.body;
         var cls:DisplayObject = CacheUtil.getObject(InputAndConfirm) as DisplayObject;
         if(this.view.contains(cls))
         {
            cls["showTips"](param.type,param.monsterID);
         }
      }
      
      private function openLaborDayView(evt:MessageEvent) : void
      {
         var cls:DisplayObject = null;
         var params:Object = evt.body;
         if(params.hasOwnProperty("type"))
         {
            if(params.type == 13)
            {
               cls = new SevenCountryAward() as DisplayObject;
               cls["setData"](params);
            }
            else if(params.type == 16)
            {
               cls = CacheUtil.getObject(GetFreshManPet) as DisplayObject;
               cls["setData"](params.version,params.progress);
            }
            this.view.showUI(cls,0,0);
         }
      }
      
      private function openHardworkawardback(evt:MessageEvent) : void
      {
         var cls:DisplayObject = CacheUtil.getObject(HardWorkAward) as DisplayObject;
         var param:Object = evt.body;
         if(param.type == 1)
         {
            cls["setData"](param);
         }
         else
         {
            cls["dataBack"](param);
         }
         var view:AwardBox = CacheUtil.pool[AwardBox];
         if(Boolean(view))
         {
            view.onOpenHardWordView(cls as HardWorkAward);
         }
      }
      
      private function toRequesetHardworkaward(evt:MessageEvent) : void
      {
         this.sendMessage(MsgDoc.OP_CLIENT_GET_HARDWORKAWARD.send,2,[evt.body as int]);
      }
      
      private function onBallonActiveAwardBack(evt:MessageEvent) : void
      {
         var obj:Object = evt.body;
         if(obj.type == -1)
         {
            new Alert().showOne("你还没有摇奖卷哦，快去档案室找贝拉参加疯狂档案室获取积分兑换摇奖券吧！");
         }
         else
         {
            new Message("ballonballactive",obj).sendToChannel("active");
         }
      }
      
      private function onClickYaojiangji(evt:MessageEvent) : void
      {
         var type:int = int(evt.body);
         if(type == 1)
         {
            this.sendMessage(MsgDoc.OP_CLIENT_REQ_TRAIN_INFO.send,8);
         }
         else if(type == 2)
         {
            this.sendMessage(MsgDoc.OP_CLIENT_ACTIVE_AWARD_BACK.send,1);
         }
      }
      
      private function onGetClassPassExp(evt:MessageEvent) : void
      {
         sendMessage(MsgDoc.OP_CLIENT_REQ_PASS_EXP.send,int(evt.body));
      }
      
      private function onGetDenglongInfo(evt:MessageEvent) : void
      {
         if(evt.body.hasOwnProperty("done"))
         {
            sendMessage(MsgDoc.OP_CLIENT_REQ_TRAIN_INFO.send,int(evt.body.param),[int(evt.body.id),int(evt.body.done)]);
         }
         else if(evt.body.hasOwnProperty("id"))
         {
            sendMessage(MsgDoc.OP_CLIENT_REQ_TRAIN_INFO.send,int(evt.body.param),[int(evt.body.id)]);
         }
         else
         {
            sendMessage(MsgDoc.OP_CLIENT_REQ_TRAIN_INFO.send,int(evt.body.param));
         }
      }
      
      private function onBuyShenshouTools(evt:MessageEvent) : void
      {
         sendMessage(MsgDoc.OP_CLIENT_SHENSHOU_BUY_TOOLS.send,int(evt.body.id),[int(evt.body.count)]);
      }
      
      private function onJustSendToServer(event:MessageEvent) : void
      {
         if(Boolean(event.body) && event.body.type == 1)
         {
            sendMessage(MsgDoc.OP_CLIENT_LITTLE_GAME.send,10003,[0]);
         }
         else
         {
            sendMessage(MsgDoc.OP_CLIENT_LITTLE_GAME.send,10003,[4,0,0,0]);
         }
      }
      
      private function onClickBobState(event:MessageEvent) : void
      {
         var mouseright:Boolean;
         var xCoord:int;
         var yCoord:int;
         var onArriveHandler:Function;
         var ui:DomainView = null;
         var domainFlag:Boolean = false;
         var showloading:Boolean = false;
         var domainUrl:String = null;
         var encryption:Boolean = false;
         WindowLayer.instance.mouseEnabled = false;
         ui = new DomainView();
         domainFlag = true;
         mouseright = false;
         showloading = true;
         domainUrl = "";
         xCoord = 0;
         yCoord = 0;
         if(Boolean(event.body))
         {
            if(Boolean(event.body.hasOwnProperty("domainFlag")) && !event.body.domainFlag)
            {
               domainFlag = false;
            }
            if(Boolean(event.body.hasOwnProperty("callback")) && event.body.callback != null)
            {
               ui.callback = event.body.callback;
            }
            if(event.body.hasOwnProperty("moduleParams"))
            {
               ui.moduleParams = event.body.moduleParams;
            }
            if(event.body.hasOwnProperty("mouseright"))
            {
               mouseright = Boolean(event.body.mouseright);
            }
            if(event.body.hasOwnProperty("showloading"))
            {
               showloading = Boolean(event.body.showloading);
            }
            if(event.body.hasOwnProperty("url"))
            {
               domainUrl = event.body.url;
               encryption = Boolean(event.body.hasOwnProperty("encryption"));
               if(event.body.hasOwnProperty("tx"))
               {
                  onArriveHandler = function():void
                  {
                     ui.domainurl(domainUrl,domainFlag,showloading,encryption);
                  };
                  MapView.instance.masterPerson.moveto(event.body.tx,event.body.ty,onArriveHandler);
               }
               else
               {
                  ui.domainurl(domainUrl,domainFlag,showloading,encryption);
               }
            }
            if(event.body.hasOwnProperty("xCoord"))
            {
               xCoord = int(event.body.xCoord);
               yCoord = int(event.body.yCoord);
            }
         }
         if(domainUrl == "")
         {
            domainUrl = "assets/bobState/Rank.swf";
            ui.domainurl(domainUrl,domainFlag);
         }
         this.view.mouseEnabled = mouseright;
         this.view.showUI(ui,xCoord,yCoord);
      }
      
      private function onGetTrainingMonsterInfo(evt:MessageEvent) : void
      {
         sendMessage(MsgDoc.OP_CLIENT_GET_TRAININFO.send,int(evt.body));
      }
      
      private function onFarmNewHandStatusError(evt:MessageEvent) : void
      {
         this.view.clearPopUpBox(CacheUtil.getObject(TaskDialog) as TaskDialog);
      }
      
      private function onReqMOABack(evt:MessageEvent) : void
      {
         var body:Object = evt.body;
         if(body.data.flag == 1)
         {
            PhpConnection.instance().messageList.push(body.data.name);
         }
         else if(body.data.mParams == 3)
         {
            PhpConnection.instance().insertMAAMessage(body.data.name,114);
         }
         else if(body.data.mParams == 5)
         {
            PhpConnection.instance().insertMAAMessage(body.data.name,104);
         }
         CheckOnlineUtil.Instance.checkIsOnline(body.data.id,this.onlineHanlder,this.notOnlineHandler,body);
      }
      
      private function onlineHanlder(... rest) : void
      {
         var body:Object = rest[0];
         sendMessage(MsgDoc.OP_GATEWAY_MASTER_OR_APPRENTICE.send,body.data.mParams,[body.data.flag]);
      }
      
      private function notOnlineHandler(... rest) : void
      {
         new FloatAlert().show(this.view,300,400,"对方不在线，操作失败！",4,300);
      }
      
      private function onBoxMessageCome(event:MessageEvent) : void
      {
         var ui:HLoaderSprite = null;
         if(event.body.type == 4 && event.body.mytype == 2)
         {
            ui = CacheUtil.getObject(HomeMessageTipView) as HLoaderSprite;
            this.view.showUI(ui,0,0);
         }
      }
      
      private function onGetWeedkend(evt:MessageEvent) : void
      {
         sendMessage(MsgDoc.OP_CLIENT_WEEDKEND_AWARD.send,int(evt.body));
      }
      
      private function onGetAnswerAward(evt:MessageEvent) : void
      {
         sendMessage(MsgDoc.OP_CLIENT_ANSWER_AWARD.send,int(evt.body));
      }
      
      private function onMaaTaskAction(evt:MessageEvent) : void
      {
         sendMessage(MsgDoc.OP_CLIENT_MAA_REQ_TASK_ACTION.send,0,[int(evt.body)]);
      }
      
      private function onTreatManySpirit(evt:MessageEvent) : void
      {
         var ary:Array = null;
         ary = evt.body as Array;
         if(GameData.instance.playerData.isVip)
         {
            sendMessage(MsgDoc.OP_CLIENT_TREAT_MANY_SPIRIT.send,0,ary);
         }
         else
         {
            new Alert().showSureOrCancel("你确定花50铜钱治疗所有妖怪吗?",function(str:String, data:Object):void
            {
               switch(str)
               {
                  case "确定":
                     sendMessage(MsgDoc.OP_CLIENT_TREAT_MANY_SPIRIT.send,0,ary);
               }
            });
         }
      }
      
      private function onGetItemNum(evt:MessageEvent) : void
      {
         var ary:Array = null;
         var len:int = 0;
         if(Boolean(evt.body) && Boolean(evt.body.hasOwnProperty("item")))
         {
            ary = (evt.body["item"] as Array).slice();
            len = int(ary.length);
            ary.unshift(len);
            sendMessage(MsgDoc.OP_CLIENT_REQ_PLAYER_INFO.send,1,ary);
         }
      }
      
      private function onMaaTaskComplete(evt:MessageEvent) : void
      {
         sendMessage(MsgDoc.OP_CLIENT_MAA_REQ_TASK_COMPLETE.send);
      }
   }
}

