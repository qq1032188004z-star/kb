package com.game.modules.control.task
{
   import com.channel.Message;
   import com.core.observer.MessageEvent;
   import com.core.view.ViewConLogic;
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.global.GlobalConfig;
   import com.game.locators.CacheData;
   import com.game.locators.GameData;
   import com.game.locators.MsgDoc;
   import com.game.manager.EventManager;
   import com.game.modules.ai.SpecialAreaManager;
   import com.game.modules.control.WindowLayerControl;
   import com.game.modules.control.battle.BattleControl;
   import com.game.modules.control.task.util.Task;
   import com.game.modules.control.task.util.TaskUtils;
   import com.game.modules.control.task.util.TaskXMLParser;
   import com.game.modules.control.task.util.TasklistItemVo;
   import com.game.modules.view.CinemaView;
   import com.game.modules.view.FaceView;
   import com.game.modules.view.MapView;
   import com.game.modules.view.WindowLayer;
   import com.game.modules.view.person.GamePerson;
   import com.game.modules.view.person.NPCWithOutScene;
   import com.game.modules.view.person.WalkableNPC;
   import com.game.modules.view.person.actAI.Act638AI;
   import com.game.modules.view.person.actAI.NPC14017;
   import com.game.modules.view.task.TaskDialog;
   import com.game.modules.view.task.TaskView;
   import com.game.util.CacheUtil;
   import com.game.util.DynamicBuild;
   import com.game.util.FloatAlert;
   import com.game.util.IdName;
   import com.game.util.MultipleRewardsAlert;
   import com.game.util.NpcXMLParser;
   import com.game.util.PropertyPool;
   import com.game.util.SceneAIFactory;
   import com.publiccomponent.alert.Alert;
   import com.xygame.module.battle.event.BattleEvent;
   import flash.display.DisplayObject;
   import flash.utils.clearTimeout;
   import flash.utils.getQualifiedClassName;
   import flash.utils.setTimeout;
   
   public class TaskControl extends ViewConLogic
   {
      
      public static const NAME:String = "taskmediator";
      
      private var dialogCallback:Function;
      
      private var diaComGoodPara:Object;
      
      private var targetSceneId:int;
      
      private var currentDialogId:int;
      
      private var battleSid:int;
      
      public var hasDialogOnStage:Boolean = false;
      
      private var taskAward:Object;
      
      private var tDialogObj:Object;
      
      private var dialogList:Array;
      
      private var lastNPCid:int;
      
      private var freqClkId:int;
      
      private var freqBlank:int = 200;
      
      private var singleTaskInfoCallback:Function;
      
      private var animationCallback:Function;
      
      private var popupback:Function;
      
      private var _dailyCompassMsgStatus:int = 0;
      
      private var npcEffectBack:Function;
      
      private var lanternid:int = 0;
      
      private var lanterntype:int = -1;
      
      private var delayTid:int = 0;
      
      public function TaskControl(viewComponent:Object = null)
      {
         super(TaskControl.NAME,viewComponent);
         this.initEvent();
      }
      
      private function initEvent() : void
      {
         EventManager.attachEvent(this.view,TaskView.GET_TASK_DIALOG,this.getTaskDialog);
         EventManager.attachEvent(this.view,TaskView.COM_TASK_DIALOG,this.taskDialogComplete);
         EventManager.attachEvent(this.view,TaskEvent.SENDTOOTHERSCENE,this.sendUserToOtherScene);
         EventManager.attachEvent(this.view,EventConst.OPENDIAVIEW,this.openTaskDialog);
         EventManager.attachEvent(this.view,TaskView.ADD_DYNAMICUI,this.addDynamicUIOnMainUI);
         EventManager.attachEvent(this.view,TaskView.NEED_SPECIAL_OP,this.specialOpToEffect);
         EventManager.attachEvent(this.view,TaskView.GET_TASK_STATUS,this.toGetNPCStatus);
         TaskUtils.getInstance().addEventListener(TaskEvent.DIALOGFINISHED,this.onDialogFinished);
         TaskUtils.getInstance().addEventListener(TaskEvent.PLAYANIMATION,this.playAni);
         TaskUtils.getInstance().addEventListener(TaskEvent.SENDTOOTHERSCENE,this.sendToOtherScene);
         TaskUtils.getInstance().addEventListener(TaskEvent.REMOVESOMETHING,this.removeSomething);
         TaskUtils.getInstance().addEventListener(TaskEvent.OPENOTHERPOPUP,this.openOtherPopUp);
         TaskUtils.getInstance().addEventListener(TaskEvent.OPENDIALOG,this.openDialog);
         TaskUtils.getInstance().addEventListener(TaskEvent.SHOW_OR_HIDE_BOTTOM,this.showOrHideBottomClip);
         TaskUtils.getInstance().addEventListener(TaskEvent.DAILYTASKOPINNOTDAILY,this.dailyTaskOP);
         TaskUtils.getInstance().addEventListener(TaskEvent.NEED_SPECIAL_OP_TO_VIEW,this.onNeedSpecialOp);
         TaskUtils.getInstance().addEventListener(TaskEvent.SET_DIALOG_VIEW_FALSE,this.setDialogViewFalse);
         TaskUtils.getInstance().addEventListener(TaskEvent.PLAY_NPC_EFFECT,this.playNPCEffectEvent);
         TaskUtils.getInstance().addEventListener(TaskEvent.STARTBATTLE,this.onTaskToBattle);
      }
      
      public function get view() : TaskView
      {
         return TaskView.instance;
      }
      
      override public function listEvents() : Array
      {
         return [[EventConst.GETTASKFINISHEDINFOBACK,this.onTaskFinishedInfoBack],[EventConst.DROPTASKINFO,this.onDropSpecifiedTask],[EventConst.DROPTASKINFOBACK,this.onDropTaskInfoBack],[EventConst.GETUSERTASKLIST,this.getUserTaskList],[EventConst.GETNPCTASKLISTBACK,this.onNPCTaskListBack],[EventConst.BATTLE_TO_TASK,this.onBattleWin],[EventConst.TASKCONDITIONCOMPLETE,this.onTaskConditionComplete],[EventConst.NOTICETOGETTASKWOODS,this.showGetTaskWoods],[EventConst.SHOWTASKTIPS,this.showTaskTips],[EventConst.ONGETDIALOGBACK,this.onGetDialogBack],[EventConst.ONNPCTALK,this.onNPCTalk],[EventConst.ONTASKTOBATTLE,this.onTaskToBattle],[EventConst.ONGETRIGHTUPCLIP,this.getRightUpClip],[EventConst.GETUSERTASKLISTBACK,this.onGetUserTaskListBack],[EventConst.MASTERISINSPECIALAREA,this.getTaskDialog],[EventConst.MASTERISOUTSPECIALAREA,this.taskDialogComplete],[EventConst.FRESHMANGUIDETOTASK,this.onGetDialogBack],[EventConst.ONACCEPTTASKBYTASKMACHINE,this.onAcceptTask],[EventConst.GETSINGLETASKINFO,this.getSingleTaskInfo]
         ,[EventConst.GETSINGLETASKINFOBACK,this.getSingleTaskInfoBack],[EventConst.BATTLE_CAN_NOT_BE_STARTED,this.onBattleCannotBeStarted],[EventConst.ACTIVE_TASK_BY_DAILY_TASK,this.opActiveTaskByDailyTask],[EventConst.PERSON_CAN_OR_NOT_MOVE,this.doPersonCanMove],[EventConst.SEND_PACKET_IN_MATERIAL,this.onSendPacketInMaterial],[EventConst.SEND_PACKET_IN_MATERIAL_BACK,this.onSendPacketInMaterialBack],[EventConst.SEND_PACKET_IN_MID_AUTUMN,this.onSendPacketInMidAutumn],[EventConst.SEND_PACKET_IN_MID_AUTUMN_BACK,this.onSendPacketInMidAutumnBack],[EventConst.GET_ANNIVERSARY_ACTIVITY_INFO_BACK,this.onGetAnniversaryInfoBack],[EventConst.GET_EFFECT_AWARD_BACK,this.onGetEffectAwardBack],[EventConst.SEND_SIGNAL_OF_ACTIVITY_AI,this.toSendSignalOfActivityAI],[EventConst.EVENT_TASKLISTITEMS_SEND_MSG_TO_SRV,this.sendMsgToSrvFromTaskListItems],[EventConst.CLICK__DAILYTASK_COMPLETED,this.onOpDailyTaskCompleteBack]];
      }
      
      public function onTaskFinishedInfoBack(evt:MessageEvent) : void
      {
         var param:Object = evt.body;
         if(ApplicationFacade.getInstance().retrieveViewLogic(BattleControl.NAME).getViewComponent() == null)
         {
            this.showTaskFinishedInfo(param);
         }
         else
         {
            this.taskAward = param;
         }
         trace("this.taskAward :",this.taskAward);
      }
      
      private function showTaskFinishedInfo(param:Object) : void
      {
         var page:int = 0;
         TaskList.getInstance().freshManTaskFlag = 0;
         this.view.taskCompleteBack(param);
         if(this.taskAward != null)
         {
            this.taskAward = null;
         }
         if(param.subtaskID >= 1004001 && param.subtaskID < 1005006)
         {
            if(param.subtaskID == 1004004)
            {
               TaskUtils.getInstance().dispatchEvent(TaskEvent.REMOVESOMETHING,21515);
            }
            if(param.subtaskID == 1005004)
            {
               ApplicationFacade.getInstance().dispatch(EventConst.REQ_RECALL_TRUMP,1);
            }
            if(CacheData.instance.isNewBrave == 0)
            {
               ApplicationFacade.getInstance().dispatch(EventConst.BOBSTATECLICK,{"url":"assets/system/newHand/brave/NewHandBraveRoad.swf"});
            }
            else
            {
               page = param.subtaskID <= 1004004 ? 2 : 3;
               ApplicationFacade.getInstance().dispatch(EventConst.BOBSTATECLICK,{
                  "url":"assets/activity/zrk2025/Act750/Act750Entrance.swf",
                  "moduleParams":{"page":page}
               });
            }
         }
      }
      
      private function onDropSpecifiedTask(evt:MessageEvent) : void
      {
         this.sendMessage(MsgDoc.OP_CLIENT_REQ_TASKDROP.send,evt.body as int);
      }
      
      public function onDropTaskInfoBack(evt:MessageEvent) : void
      {
         var param:Object = evt.body;
         TaskList.getInstance().updateTask(TaskList.getInstance().getSpecifiedTask(TaskList.TASK_LIST_ACCEPTED,param.subtaskID),TaskList.TASK_REMOVE_DROP);
      }
      
      private function onBattleWin(evt:MessageEvent) : void
      {
         var flag:Boolean = false;
         var param:Object = evt.body;
         if(Boolean(param.win & 0x80000000))
         {
            flag = true;
         }
         else
         {
            flag = false;
         }
         if(this.battleSid != 0 && param.spiritid == this.battleSid && (param.type == 1 || param.type == 2 || param.type == 10) || this.battleSid == -1 && (param.type == 7 || param.type == 11))
         {
            this.battleSid = 0;
            if(this.dialogCallback != null)
            {
               if(GameData.instance.playerData.currentScenenId != 1013)
               {
                  FaceView.clip.hideBottom();
               }
               MapView.instance.masterPerson.stop();
               (ApplicationFacade.getInstance().retrieveViewLogic(WindowLayerControl.NAME) as WindowLayerControl).view.nonContainsThenAdd(CacheUtil.getObject(TaskDialog) as DisplayObject);
               this.dialogCallback.apply(null,[flag]);
               this.dialogCallback = null;
            }
         }
         if(this.taskAward != null)
         {
            this.showTaskFinishedInfo(this.taskAward);
         }
         if(this.tDialogObj != null)
         {
            this.opDialogAfterBattle(this.tDialogObj,true);
         }
      }
      
      private function onTaskConditionComplete(evt:MessageEvent) : void
      {
         var obj:Object = null;
         var len:int = 0;
         var param:Object = evt.body;
         var task:Task = TaskList.getInstance().getSpecifiedTask(TaskList.TASK_LIST_ACCEPTED,param.subtaskID) as Task;
         var i:int = 0;
         var count:int = 0;
         if(task == null)
         {
            return;
         }
         if(task.condition != null)
         {
            len = int(task.condition.length);
         }
         for(i = 0; i < len; i++)
         {
            if(task.condition[i].id == param.id && task.condition[i].type == param.type)
            {
               obj = task.condition[i];
               if(param.number >= obj.number)
               {
                  obj.currentNum = obj.number;
                  count++;
               }
               else
               {
                  obj.currentNum = param.number;
               }
               task.condition[i] = obj;
            }
            else if(task.condition[i].currentNum == task.condition[i].number)
            {
               count++;
            }
         }
         if(count == len)
         {
            task.state = true;
            dispatch(EventConst.ONSHOWTASKSTATETIP,false);
         }
      }
      
      private function showGetTaskWoods(evt:MessageEvent) : void
      {
         var param:Object = evt.body;
         switch(param.opid)
         {
            case 3:
               this.view.showGetTaskWoods(param,true);
               break;
            case 4:
               this.view.showGetTaskWoods(param,false);
         }
      }
      
      private function showTaskTips(params:Object) : void
      {
      }
      
      private function onGetDialogBack(evt:MessageEvent) : void
      {
         var params:Object = null;
         var item:Object = null;
         var itemArr:Array = null;
         var i:int = 0;
         var listItem:Object = null;
         var rnid:int = 0;
         if(!GameData.instance.playerData.ableName)
         {
            return;
         }
         if(GameData.instance.playerData.isNewHand == 0)
         {
            return;
         }
         if(this.hasDialogOnStage && evt.body.type != 6 && evt.body.type != 9 && evt.body.type != 19 && evt.body.type != 20 && evt.body.type != 15 && evt.body.type != 18 && evt.body.type != 24)
         {
            if(ApplicationFacade.getInstance().retrieveViewLogic(BattleControl.NAME).getViewComponent() != null)
            {
               this.tDialogObj = evt.body;
            }
            return;
         }
         if(!(GameData.instance.playerData.isNewHand == 9 || evt.body != null && Boolean(evt.body.hasOwnProperty("dialogId")) && evt.body.dialogId == 100300101))
         {
            if(GameData.instance.playerData.isNewHand == 6)
            {
               params = evt.body;
               this.view.getAwardWithoutComplete(params);
               return;
            }
            if(evt.body.hasOwnProperty("farm"))
            {
               new Alert().show("你还没做完新手任务哦！~快去驾驶舱找阳光机长吧！~");
               return;
            }
            params = {};
            params.dialogId = evt.body.step;
            params.npcid = evt.body.id;
            params.subtaskID = params.dialogId;
            params.taskID = params.dialogId;
            params.type = 1;
            if(evt.body.hasOwnProperty("list"))
            {
               params.itemCount = (evt.body.list as Array).length;
               itemArr = [];
               for(i = 0; i < params.itemCount; i++)
               {
                  listItem = (evt.body.list as Array)[i];
                  item = {};
                  if(!(Boolean(listItem.hasOwnProperty("type")) || listItem is int))
                  {
                     item.type = listItem.type;
                     item.id = listItem.id;
                     item.number = listItem.count;
                     itemArr.push(item);
                  }
               }
               params.itemArr = itemArr;
            }
            this.opDialogBackType1to5(params);
         }
         else if(Boolean(evt.body.hasOwnProperty("farm")) && evt.body.farm == 1)
         {
            params = {};
            params.dialogId = evt.body.step;
            params.npcid = 0;
            params.subtaskID = params.dialogId;
            params.taskID = params.dialogId;
            params.type = 1;
            this.opDialogBackType1to5(params);
         }
         else
         {
            params = evt.body;
            trace("params.npcid :",params.npcid);
            trace("params.dialogId :",params.dialogId);
            trace("params.taskID :",params.taskID,params.type);
            switch(params.type)
            {
               case 1:
                  this.opDialogBackType1to5(params);
                  break;
               case 2:
                  this.opDialogBackType1to5(params);
                  break;
               case 3:
                  this.opDialogBackType1to5(params);
                  break;
               case 4:
                  this.opDialogBackType4(params);
                  break;
               case 5:
                  this.opDialogBackType1to5(params);
                  break;
               case 6:
                  this.opDialogBackType6(params);
                  break;
               case 7:
                  this.opDialogBackType7(params);
                  break;
               case 8:
                  this.opDialogBackType8(params);
                  break;
               case 9:
                  this.opDialogBackType9(params);
                  break;
               case 10:
                  this.opDialogBackType10(params);
                  break;
               case 11:
                  this.opDialogBackType11(params);
                  break;
               case 12:
                  this.opDailyCompassAwardBack(params);
                  break;
               case 13:
                  this.dispatch(EventConst.OPEN_LABOR_DAY_VIEW,params);
                  break;
               case 14:
                  this.view.showAlertNotUseTaskAlert(params,1);
                  break;
               case 15:
                  if(GameData.instance.playerData.currentScenenId == 80002 && GameData.instance.playerData.copyScene == 7)
                  {
                     this.delayTid = setTimeout(this.delayAwardHandler,8000,params);
                  }
                  else
                  {
                     this.view.getAwardWithoutComplete(params);
                  }
                  break;
               case 16:
                  this.dispatch(EventConst.OPEN_LABOR_DAY_VIEW,params);
                  break;
               case 17:
                  this.view.showAlertNotUseTaskAlert(params,2);
                  break;
               case 18:
                  this.view.getXiuwei(params);
                  break;
               case 19:
                  if(params.account > 0)
                  {
                     for each(rnid in params.list)
                     {
                        this.dispatch(EventConst.REMOVEDYNAMICTASKNPC,rnid);
                     }
                  }
                  break;
               case 20:
                  new Message("newhandstatus",params.status).sendToChannel("shenshou");
                  break;
               case 21:
                  this.opDialogBackType1to5(params);
                  break;
               case 22:
                  params.chooseId = -1;
                  this.opDialogBackType1to5(params);
                  break;
               case 23:
                  GameData.instance.playerData.renqizhi = params.count;
                  new Message("addrenqizhi",params.count).sendToChannel("shenshou");
                  break;
               case 24:
                  dispatch(EventConst.SHOW_MONSTER,params);
                  break;
               case 26:
                  params.npcid = this.view.currentNPCID;
                  this.opDialogBackType1to5(params);
                  break;
               case 100:
                  if(params && params.hasOwnProperty("itemList") && params.itemList.length > 0)
                  {
                     new MultipleRewardsAlert(params,WindowLayer.instance.stage);
                  }
            }
         }
      }
      
      private function opDialogBackType1to5(params:Object) : void
      {
         if(ApplicationFacade.getInstance().retrieveViewLogic(BattleControl.NAME).getViewComponent() == null)
         {
            this.opDialogAfterBattle(params);
         }
         else
         {
            this.tDialogObj = params;
         }
      }
      
      private function opDialogAfterBattle(params:Object, flag:Boolean = false) : void
      {
         if(params.itemCount > 0 && params.type == 1)
         {
            this.view.onShowWoodsInDialog(params);
         }
         else
         {
            if(params.itemCount > 0 && params.type == 5 || params.type == 26)
            {
               this.diaComGoodPara = params;
            }
            this.view.onGetDialogBack(params);
         }
         if(flag)
         {
            this.tDialogObj = null;
         }
      }
      
      private function opDialogBackType4(params:Object) : void
      {
         var sceneMaterial:* = undefined;
         if(MapView.instance.findGameSprite(IdName.specialArea(31203)) != null)
         {
            MapView.instance.delGameSpirit(IdName.specialArea(31203));
         }
         var param:Object = NpcXMLParser.parse(params.targetId);
         if(param != null)
         {
            if(param.hasOwnProperty("removeNPCList"))
            {
               this.removeNPCList(param.removeNPCList);
            }
            if(param.mapid != GameData.instance.playerData.currentScenenId)
            {
               return;
            }
            sceneMaterial = SceneAIFactory.instance.produce(param.type,param);
            MapView.instance.addGameSprite(sceneMaterial);
            (sceneMaterial as DynamicBuild).load();
            (sceneMaterial as DynamicBuild).update({
               "status":params.currentStatus,
               "canChange":params.isNext,
               "nextTime":params.nextTime
            });
         }
      }
      
      private function opDialogBackType6(params:Object) : void
      {
         this.dispatch(EventConst.CHANGEBODYCARDBACK,{
            "roleid":params.roletype,
            "callback":null
         });
      }
      
      private function opDialogBackType7(params:Object) : void
      {
         PropertyPool.instance.getTaskProps(params.dialogId,this.getPropsBack,params);
      }
      
      private function getPropsBack(props:XML, arr:Array) : void
      {
         var params:Object = null;
         var xml:XML = null;
         var task:* = undefined;
         var i:int = 0;
         var len:int = 0;
         var obj:Object = null;
         if(props == null)
         {
            return;
         }
         params = arr[0];
         xml = props.children().(@id == params.dialogId)[0] as XML;
         task = TaskXMLParser.getInstance().parseXML(xml,params.subtaskID,params.taskID,params.dialogId);
         if(task is Task)
         {
            i = 0;
            len = int((task as Task).otherpopup.length);
            obj = {};
            obj.boardId = params.boardId;
            obj.npcid = params.npcid;
            obj.desc = [];
            for(i = 0; i < len; i++)
            {
               obj.desc.push({
                  "desc":(task as Task).otherpopup[i].desc,
                  "ans":(task as Task).otherpopup[i].popid
               });
            }
            this.dispatch(EventConst.OPENSINGLECHOICE,obj);
         }
      }
      
      private function opDialogBackType8(params:Object) : void
      {
         var result:Object = {};
         result.npcid = this.view.currentNPCID;
         result.dialogId = params.dialogId;
         if(params.hasOwnProperty("abilityNum"))
         {
            result.abilityNum = params.abilityNum;
            result.abilityList = params.functionList;
         }
         dispatch(EventConst.ADDTASKINTOTASKLISTITEMS,result);
      }
      
      private function opDialogBackType9(params:Object) : void
      {
         var xml:XML = null;
         var node:Object = null;
         var sceneMaterial:* = undefined;
         var i:int = 0;
         var leng:int = int(params.account);
         for(i = 0; i < leng; i++)
         {
            node = NpcXMLParser.parse(params.list[i]);
            if(node != null)
            {
               if(node.hasOwnProperty("removeNPCList"))
               {
                  this.removeNPCList(node.removeNPCList);
               }
               sceneMaterial = SceneAIFactory.instance.produce(node.type,node);
               if(sceneMaterial != undefined)
               {
                  switch(node.type)
                  {
                     case 11:
                        (sceneMaterial as NPCWithOutScene).load();
                        break;
                     case 13:
                        (sceneMaterial as WalkableNPC).load();
                        break;
                     case 15:
                        (sceneMaterial as Act638AI).load();
                        break;
                     case 16:
                        (sceneMaterial as NPC14017).load();
                  }
                  MapView.instance.addGameSprite(sceneMaterial);
               }
            }
         }
      }
      
      private function opDialogBackType10(params:Object) : void
      {
         var param:Object = null;
         this.dialogList = [];
         var i:int = 0;
         var len:int = 2;
         for(i = 0; i < 2; i++)
         {
            param = {};
            if(i == 0)
            {
               param.dialogId = params.dialogOne;
            }
            else
            {
               param.dialogId = params.dialogTwo;
            }
            if(param.dialogId != 9999999)
            {
               param.subtaskID = (param.dialogId - param.dialogId % 100) / 100;
               param.taskID = param.subtaskID - param.subtaskID % 1000;
               param.itemCount = 0;
               param.type = 1;
               param.npcid = params.npcid;
               this.dialogList.push(param);
            }
         }
         this.opDialogBackType1to5(this.dialogList.shift());
      }
      
      private function opDialogBackType11(params:Object) : void
      {
         var tempArr:Array = null;
         var runringTask:Task = null;
         if(params.id == 1111111)
         {
            tempArr = TaskList.getInstance().getSubtaskList(4006000);
            runringTask = tempArr[params.currentId - 1];
            TaskList.getInstance().updateTask(runringTask,TaskList.TASK_REMOVE_COMPLETE);
            this.dispatch(EventConst.OPENEIGHTTRIGRAM,params);
         }
      }
      
      private function opDailyCompassAwardBack(params:Object) : void
      {
         this.view.showAwardInDailyCompass(params.awardbox,params.awardindex);
      }
      
      private function opGoodsAfterDialog() : void
      {
         this.diaComGoodPara.callback = this.callbackOpGoodsAfterDialog;
         if(this.diaComGoodPara.type == 26)
         {
            this.view.getAwardWithoutComplete(this.diaComGoodPara);
         }
         else
         {
            this.view.onShowWoodsInDialog(this.diaComGoodPara);
         }
      }
      
      private function callbackOpGoodsAfterDialog(param:Object = null) : void
      {
         if(this.currentDialogId != 0)
         {
            this.view.onDialogComplete(this.currentDialogId);
         }
         if(this.targetSceneId != 0)
         {
            this.toOtherScene(this.targetSceneId);
         }
         this.targetSceneId = 0;
         this.diaComGoodPara = null;
         this.currentDialogId = 0;
      }
      
      private function onDialogFinished(evt:TaskEvent) : void
      {
         var jdID:int = 0;
         var t_step:int = 0;
         var i:int = 0;
         var len:int = 0;
         var opName:String = null;
         var obj:Object = null;
         var ids:Array = null;
         var prefix:String = null;
         var ai:Object = null;
         var isNewHand:int = GameData.instance.playerData.isNewHand;
         if(isNewHand != 9)
         {
            if(evt.param.dialogId >= 100600102 && evt.param.dialogId <= 100600106)
            {
               evt.param.dialogId = 100600102;
            }
            if(evt.param.dialogId >= 100600101 && evt.param.dialogId < 100700101)
            {
               jdID = evt.param.dialogId % 10000000;
            }
            else
            {
               jdID = evt.param.dialogId % 10;
            }
            if(jdID == 0)
            {
               jdID == 10;
            }
            this.dispatch(EventConst.TASKTOFRESHMANGUIDE,jdID);
         }
         else if(evt.param.dialogId <= 25 && evt.param.dialogId >= 21)
         {
            t_step = evt.param.dialogId % 10;
            this.dispatch(EventConst.TASKTOZHUANGYUANGUIDE,{
               "flag":true,
               "step0":t_step - 1,
               "step1":t_step
            });
         }
         else
         {
            if(Boolean(evt.param.hasOwnProperty("ai")))
            {
               i = 0;
               len = int((evt.param.ai as Array).length);
               for(i = 0; i < len; i++)
               {
                  opName = (evt.param.ai as Array)[i].opname.toString();
                  switch(opName)
                  {
                     case "mouse":
                        this.dispatch(EventConst.NEEDLISTENMOUSECURSORAI,evt.param.ai[i].targetId);
                        break;
                     case "learnmagic":
                        obj = {};
                        obj.opdata = {};
                        obj.opdata.opName = "learnmagic" + evt.param.ai[i].targetId;
                        this.dispatch(EventConst.OPENPOPUPINDIALOG,obj);
                        GameData.instance.playerData.magicstate |= 1;
                        break;
                     case "npcEffect":
                        ids = [];
                        for each(ai in evt.param.ai)
                        {
                           ids.push(ai.id);
                        }
                        this.dispatch(EventConst.PLAYNPCEFFECTBYTASK,{
                           "id":ids,
                           "type":ai.targetId
                        });
                        break;
                     default:
                        prefix = opName.substr(0,7);
                        if(prefix == "modules")
                        {
                           dispatch(EventConst.OPEN_MODULE,{
                              "url":"assets/module/" + opName + ".swf",
                              "xCoord":0,
                              "yCoord":0
                           });
                        }
                        else if(prefix == "swfview")
                        {
                           dispatch(EventConst.OPENSWFWINDOWS,{
                              "url":"assets/material/" + opName + ".swf",
                              "xCoord":0,
                              "yCoord":0
                           });
                        }
                  }
               }
            }
            if(this.diaComGoodPara != null)
            {
               this.currentDialogId = evt.param.dialogId;
               if(evt.param.sceneId != 0)
               {
                  this.targetSceneId = evt.param.sceneId;
               }
               this.opGoodsAfterDialog();
            }
            else
            {
               this.view.onDialogComplete(evt.param.dialogId,evt.param.needchoose);
               if(evt.param.sceneId != 0)
               {
                  this.toOtherScene(evt.param.sceneId);
               }
               this.diaComGoodPara = null;
            }
         }
      }
      
      private function onNPCTalk(evt:MessageEvent) : void
      {
         this.view.onNPCTalkBack(int(evt.body));
      }
      
      private function onTaskToBattle(evt:TaskEvent) : void
      {
         FaceView.clip.showBottom();
         var params:Object = evt.param;
         this.dialogCallback = params.callback;
         this.battleSid = params.spiritid;
         var useid:int = 0;
         if(params.hasOwnProperty("useID"))
         {
            useid = int(params.useID);
         }
         this.dispatch(BattleEvent.npcClick,{
            "sid":params.sid,
            "useid":useid
         });
      }
      
      private function onNPCTaskListBack(evt:MessageEvent) : void
      {
         if(this.hasDialogOnStage)
         {
            return;
         }
         var params:Object = evt.body;
         if(!params.hasOwnProperty("dialogId"))
         {
            O.o("找后端问问啊....为什么这里没有对话id？？？？");
            return;
         }
         var result:Object = {};
         result.npcid = params.npcid;
         result.dialogId = params.dialogId;
         this.view.currentNPCID = result.npcid;
         if(Boolean(params.hasOwnProperty("specialType")) && params.specialType < 0)
         {
            result.chooseId = params.specialType;
         }
         if(params.hasOwnProperty("type"))
         {
            result.taskCount = params.taskcount;
            if(params.taskcount > 0)
            {
               if(params.type == 0)
               {
                  this.onLoadPropsList(params,result);
                  return;
               }
               if(params.type == 1)
               {
                  (params.tasklist as Array).sort(Array.NUMERIC);
                  this.dispatch(EventConst.OPENTASKACCEPTCLIP,{
                     "list":params.tasklist,
                     "type":params.canReceive,
                     "taskId":params.taskId
                  });
                  return;
               }
            }
         }
         if(params.hasOwnProperty("abilityNum"))
         {
            result.abilityNum = params.abilityNum;
            result.abilityList = params.functionList;
         }
         dispatch(EventConst.ADDTASKINTOTASKLISTITEMS,result);
      }
      
      private function onLoadPropsList(params:Object, result:Object) : void
      {
         (params.tasklist as Array).sortOn("dialogId",Array.NUMERIC);
         var arr:Array = [];
         var i:int = 0;
         var len:int = int(params.taskcount);
         for(i = 0; i < len; i++)
         {
            arr.push(params.tasklist[i].dialogId);
         }
         PropertyPool.instance.getTaskPropsList(arr,this.loadPropsListBack,params,result);
      }
      
      private function loadPropsListBack(arr:Array) : void
      {
         var task:Object = null;
         var xml:XML = null;
         var params:Object = arr[0];
         var result:Object = arr[1];
         var i:int = 0;
         var len:int = int(params.taskcount);
         var tasklist:Array = [];
         for(i = 0; i < len; i++)
         {
            task = {};
            xml = PropertyPool.instance.getSpecifiedProp(String(params.tasklist[i].dialogId / 1000 >> 0) + "0").children().(@id == params.tasklist[i].dialogId)[0] as XML;
            task.data = TaskXMLParser.getInstance().parseXML(xml,params.tasklist[i].subtaskID,params.tasklist[i].taskID,params.tasklist[i].dialogId);
            if(task.data != null)
            {
               task.state = params.tasklist[i].state;
               tasklist.push(task);
            }
         }
         result.tasklist = tasklist;
         if(params.hasOwnProperty("abilityNum"))
         {
            result.abilityNum = params.abilityNum;
            result.abilityList = params.functionList;
         }
         dispatch(EventConst.ADDTASKINTOTASKLISTITEMS,result);
      }
      
      private function onGetUserTaskListBack(evt:MessageEvent) : void
      {
         TaskList.getInstance().initAllTask(evt.body);
      }
      
      private function getUserTaskList(evt:MessageEvent) : void
      {
         this.sendMessage(MsgDoc.OP_CLIENT_REQ_USERTASKLIST.send);
         this.sendMessage(MsgDoc.OP_CLIENT_EFFECT_BACK.send,1);
      }
      
      private function getTaskDialog(evt:MessageEvent) : void
      {
         if(GameData.instance.playerData.isNewHand != 9)
         {
            new Alert().show("你还没有做完新手指引哦，去驾驶舱找阳光机长吧");
            return;
         }
         if(this.hasDialogOnStage)
         {
            if(!TaskList.getInstance().isSpecialFreshManFlag(true))
            {
               return;
            }
            this.onOpenPopupBack(false);
         }
         if(evt.body is int || !evt.body.hasOwnProperty("sid"))
         {
            this.view.currentNPCID = evt.body as int;
            if(evt.body as int == 31316)
            {
               this.sendToPlayNPCEffect({
                  "id":[31314,31317,31319],
                  "type":3
               });
            }
            if(this.frequentClickFilter(evt.body as int))
            {
               this.sendMessage(MsgDoc.OP_CLIENT_CLICK_NPC.send,evt.body as int,[0]);
            }
         }
         else
         {
            this.view.currentNPCID = evt.body.npcid;
            if(this.frequentClickFilter(evt.body.npcid))
            {
               this.sendMessage(MsgDoc.OP_CLIENT_CLICK_NPC.send,evt.body.npcid,[evt.body.sid]);
            }
         }
      }
      
      private function frequentClickFilter(npcid:int) : Boolean
      {
         if(this.freqClkId != 0 && this.lastNPCid == npcid)
         {
            trace("【TaskControl_frequentClickFilter】 不能点...");
            return false;
         }
         if(this.lastNPCid != npcid)
         {
            this.frequentFilter();
         }
         trace("【TaskControl_frequentClickFilter】 能点.....");
         this.lastNPCid = npcid;
         this.freqClkId = setTimeout(this.frequentFilter,this.freqBlank);
         return true;
      }
      
      private function frequentFilter() : void
      {
         if(this.freqClkId == 0)
         {
            return;
         }
         clearTimeout(this.freqClkId);
         this.freqClkId = 0;
         trace("【TaskControl_frequentClickFilter】 现在能点了....");
      }
      
      private function taskDialogComplete(evt:MessageEvent) : void
      {
         var t_dialogid:int = 0;
         if(this.dialogList != null && this.dialogList.length > 0)
         {
            this.opDialogBackType1to5(this.dialogList.shift());
            if(this.dialogList.length == 0)
            {
               this.dialogList = null;
            }
         }
         else
         {
            if(this.dialogList != null)
            {
               this.dialogList = null;
            }
            t_dialogid = int(evt.body.dialogID);
            if(TaskList.getInstance().isSpecialFreshManFlag() && !evt.body.hasOwnProperty("freshman"))
            {
               TaskList.getInstance().addFreshManTaskMask();
               return;
            }
            if(Boolean(evt.body.hasOwnProperty("chooseid")) && evt.body.chooseid != 0)
            {
               this.sendMessage(MsgDoc.OP_CLIENT_REQ_TRAIN_INFO.send,7,[t_dialogid,evt.body.chooseid]);
            }
            this.sendMessage(MsgDoc.OP_CLIENT_REQ_TASKTALK.send,evt.body.npcid,[t_dialogid]);
            this.view.personCannotMove(false);
            if(t_dialogid == 40)
            {
               new Message("demon_hunt_3_1").sendToChannel("DemonHunt3");
            }
            else if(t_dialogid == 41)
            {
               new Message("demon_hunt_3_2").sendToChannel("DemonHunt3");
            }
            else if(t_dialogid == 100500401)
            {
               ApplicationFacade.getInstance().dispatch(EventConst.REQ_RECALL_TRUMP,2);
            }
            ApplicationFacade.getInstance().dispatch(EventConst.TASK_DIALOG_FUNCTION_ITEM,evt.body);
         }
      }
      
      private function onAcceptTask(evt:MessageEvent) : void
      {
         this.sendMessage(MsgDoc.OP_CLIENT_REQ_ACCEPTTASK.send,evt.body as int);
      }
      
      private function getRightUpClip(evt:MessageEvent) : void
      {
         var sid:int = 0;
         if(evt.body != null)
         {
            sid = evt.body as int;
         }
         this.sendMessage(MsgDoc.OP_CLIENT_GET_RIGHTUP_CLIP.send,sid);
      }
      
      private function getSingleTaskInfo(evt:MessageEvent) : void
      {
         this.singleTaskInfoCallback = evt.body.callback;
         this.sendMessage(MsgDoc.OP_CLIENT_GET_SINGLE_TASK_INFO.send,evt.body.taskId);
      }
      
      private function sendUserToOtherScene(evt:MessageEvent) : void
      {
         this.toOtherScene(evt.body as int);
      }
      
      private function sendToOtherScene(evt:TaskEvent) : void
      {
         this.toOtherScene(evt.param as int);
      }
      
      private function toOtherScene(sceneId:int) : void
      {
         if(sceneId == 1002)
         {
            dispatch(EventConst.REQ_ENTER_ROOM,{
               "userId":GlobalConfig.userId,
               "userName":GameData.instance.playerData.userName,
               "houseId":GlobalConfig.userId
            });
            return;
         }
         if(sceneId == 1013 || sceneId == 1018)
         {
            this.dispatch(EventConst.ENTERSHENSHOU);
            return;
         }
         dispatch(EventConst.SENDUSERTOOTHERSCENE,sceneId);
      }
      
      private function openTaskDialog(evt:MessageEvent) : void
      {
         if(GameData.instance.playerData.isNewHand < 9)
         {
            SpecialAreaManager.instance.removeNewHandMask();
         }
         this.sendOpenDialog(evt.body);
      }
      
      private function openDialog(evt:TaskEvent) : void
      {
         var tmpTask:Task = evt.param.task;
         if((tmpTask.describe == null || tmpTask.describe.length == 0) && (tmpTask.flash == null || tmpTask.flash.length == 0) && tmpTask.battle == null && (tmpTask.otherpopup == null || tmpTask.otherpopup.length == 0))
         {
            this.dispatch(EventConst.MASTERISOUTSPECIALAREA,{
               "npcid":this.view.currentNPCID,
               "dialogID":tmpTask.dialogID,
               "chooseid":evt.param.needchoose
            });
         }
         else
         {
            this.sendOpenDialog(evt.param);
         }
      }
      
      private function sendOpenDialog(param:*) : void
      {
         this.hasDialogOnStage = true;
         this.dispatch(EventConst.OPENDIAVIEW,param);
      }
      
      private function dailyTaskOP(evt:TaskEvent) : void
      {
         var obj:Object = evt.param;
         this.sendMessage(MsgDoc.OP_CLIENT_DAILY_TASK.send,obj.type,[obj.taskID,obj.actionID]);
      }
      
      private function playAni(evt:TaskEvent) : void
      {
         if(GameData.instance.playerData.sceneType == 0 || GameData.instance.playerData.sceneType == 4)
         {
            FaceView.clip.showBottom();
         }
         var obj:Object = evt.param;
         this.animationCallback = obj.targetFunction;
         obj.targetFunction = this.playAnimationBack;
         this.dispatch(EventConst.STARTTOPLAYANIMATION,obj);
      }
      
      private function playAnimationBack(param:Object = null) : void
      {
         if(this.animationCallback != null)
         {
            this.animationCallback.apply(null,[param]);
         }
         this.animationCallback = null;
         this.dispatch(EventConst.HIDE_GAMEPERSON,{"type":2});
      }
      
      private function removeSomething(evt:TaskEvent) : void
      {
         var i:int = 0;
         var len:int = 0;
         if(evt.param is int)
         {
            this.dispatch(EventConst.REMOVEDYNAMICTASKNPC,evt.param as int);
         }
         else if(evt.param is Array)
         {
            i = 0;
            len = int(evt.param.length);
            for(i = 0; i < len; i++)
            {
               this.dispatch(EventConst.REMOVEDYNAMICTASKNPC,evt.param[i]);
            }
         }
      }
      
      private function openOtherPopUp(evt:TaskEvent) : void
      {
         trace("=============打开其他的对话框=============");
         if(GameData.instance.playerData.sceneType == 0 || GameData.instance.playerData.sceneType == 4)
         {
            FaceView.clip.showBottom();
         }
         var obj:Object = evt.param;
         this.popupback = obj.callback;
         obj.callback = this.onOpenPopupBack;
         this.dispatch(EventConst.OPENPOPUPINDIALOG,evt.param);
      }
      
      private function onOpenPopupBack(param:* = null) : void
      {
         if(this.popupback != null)
         {
            this.popupback.apply(null,[param]);
         }
         this.popupback = null;
      }
      
      private function getSingleTaskInfoBack(evt:MessageEvent) : void
      {
         var i:int = 0;
         var obj:Object = null;
         var hbAcceptCount:int = 0;
         var hbAcceptStatus:int = 0;
         var param:Object = evt.body;
         if(param.taskId == 555555)
         {
            return;
         }
         if(param.taskId == 6010005)
         {
            param.showX = 0;
            param.showY = 0;
            dispatch(EventConst.OPEN_CACHE_VIEW,param,null,getQualifiedClassName(CinemaView));
            return;
         }
         if(param.taskId == 6010008)
         {
            this.dispatch(EventConst.MENOLOGYVIEWDATA,param);
            return;
         }
         if(param.taskId == 6010009)
         {
            if(Boolean(param.flag))
            {
               new Message("classtexuns2c",param).sendToChannel("datatrans");
            }
            return;
         }
         if(param.taskId == 6005001)
         {
            GameData.instance.playerData.benevolentEveryDay = this.getBenevolentScene(param);
            this._dailyCompassMsgStatus = 1;
            sendMessage(MsgDoc.OP_CLIENT_GET_SINGLE_TASK_INFO.send,4014001);
            return;
         }
         if(param.taskId == 6017001)
         {
            this._dailyCompassMsgStatus = 0;
            this.dispatch(EventConst.SHOW_DAILY_COMPASS_VIEW,param);
            return;
         }
         if(param.taskId == 333444)
         {
            new Message("gettaskprogressback",param).sendToChannel("datatrans");
            return;
         }
         if(param.taskId == 777777)
         {
            if(!param.hasOwnProperty("list"))
            {
               return;
            }
            i = param.list.length - 1;
            for(obj = {}; i >= 0; )
            {
               obj = param.list[i];
               GameData.instance.badgeData[obj.key] = obj.value;
               i--;
            }
            new Message("getbadgevalueback",param).sendToChannel("badge");
            return;
         }
         if(param.taskId == 4014001)
         {
            if(this._dailyCompassMsgStatus == 1)
            {
               hbAcceptCount = this.getValueByKeyFromSingleTaskInfo(param,1);
               hbAcceptStatus = this.getValueByKeyFromSingleTaskInfo(param,8);
               if(hbAcceptStatus == 1)
               {
                  TaskList.getInstance().hbTaskCompleteCount = hbAcceptCount - 1;
               }
               else
               {
                  TaskList.getInstance().hbTaskCompleteCount = hbAcceptCount;
               }
               sendMessage(MsgDoc.OP_CLIENT_GET_SINGLE_TASK_INFO.send,6017001);
            }
            else
            {
               this.dispatch(EventConst.GET_HB_TASK_DETAIL_INFO_BACK,param);
            }
         }
         if(this.singleTaskInfoCallback != null)
         {
            this.singleTaskInfoCallback.apply(null,[evt.body]);
         }
         this.singleTaskInfoCallback = null;
      }
      
      private function getBenevolentScene(param:Object) : int
      {
         var temp:Object = null;
         var obj:Object = null;
         var tempindex:int = 0;
         if(param == null || !param.hasOwnProperty("list") || param.list == null)
         {
            return 0;
         }
         var result:int = 0;
         var tempList:Array = [3001,4001,5002,6001,7002,10001,9001];
         for each(obj in param.list)
         {
            if(obj.key == 5)
            {
               tempindex = obj.value % 10 - 2;
               if(tempindex >= 0 && tempindex <= tempList.length - 1)
               {
                  result = int(tempList[tempindex]);
               }
            }
            else if(obj.key == 600500110)
            {
               if(obj.value == 1)
               {
                  TaskList.getInstance().setTaskBitStatus(4,true);
               }
            }
         }
         return result;
      }
      
      private function showOrHideBottomClip(evt:TaskEvent) : void
      {
         if(GameData.instance.playerData.sceneType == 0 || GameData.instance.playerData.sceneType == 4)
         {
            if(evt.param as Boolean)
            {
               FaceView.clip.showBottom();
            }
            else
            {
               FaceView.clip.hideBottom();
            }
         }
      }
      
      private function addDynamicUIOnMainUI(evt:MessageEvent) : void
      {
         this.dispatch(EventConst.ADDDYNAMICUIONMAINUI,evt.body);
      }
      
      private function onBattleCannotBeStarted(evt:MessageEvent) : void
      {
         if(this.battleSid != 0 && (ApplicationFacade.getInstance().retrieveViewLogic(BattleControl.NAME) as BattleControl).battleView == null)
         {
            this.battleSid = 0;
            this.dialogCallback = null;
            (CacheUtil.getObject(TaskDialog) as TaskDialog).dispos();
            this.tDialogObj = null;
         }
      }
      
      private function opActiveTaskByDailyTask(evt:MessageEvent) : void
      {
         this.sendMessage(MsgDoc.OP_CLIENT_DAILY_TASK.send,evt.body.type,[evt.body.taskID,evt.body.actionID]);
      }
      
      private function onNeedSpecialOp(evt:TaskEvent) : void
      {
         this.view.needSpecialOp(evt.param as int);
      }
      
      private function specialOpToEffect(evt:MessageEvent) : void
      {
         var spOP:Object = evt.body;
         this.sendToPlayNPCEffect({
            "id":[spOP.npcid],
            "type":spOP.type,
            "callback":spOP.callback
         });
      }
      
      private function setDialogViewFalse(evt:TaskEvent) : void
      {
         this.hasDialogOnStage = false;
      }
      
      private function toGetNPCStatus(evt:MessageEvent) : void
      {
         sendMessage(MsgDoc.OP_CLIENT_NPC_STATUS.send,int(evt.body));
      }
      
      private function playNPCEffectEvent(evt:TaskEvent) : void
      {
         var obj:Object = evt.param;
         this.npcEffectBack = obj.callback;
         obj.callback = this.onNpcEffectBack;
         this.sendToPlayNPCEffect(obj);
      }
      
      private function sendToPlayNPCEffect(param:Object) : void
      {
         this.dispatch(EventConst.PLAYNPCEFFECTBYTASK,param);
      }
      
      private function onNpcEffectBack(npcname:String = "") : void
      {
         if(this.npcEffectBack != null)
         {
            this.npcEffectBack.apply(null,[npcname]);
         }
         this.npcEffectBack = null;
      }
      
      private function doPersonCanMove(evt:MessageEvent) : void
      {
         var tstatus:Boolean = false;
         try
         {
            if(evt.body is Boolean)
            {
               tstatus = evt.body as Boolean;
               this.view.personCannotMove(tstatus);
            }
            else
            {
               new FloatAlert().show(WindowLayer.instance.stage,300,400,"玩家是否能动设置错误" + evt.body);
            }
         }
         catch(e:*)
         {
            trace("【TaskControl_doPersonCanMove_EventConst.PERSON_CAN_OR_NOT_MOVE】NND....谁发的消息？参数都不对就来了...");
         }
      }
      
      private function onSendPacketInMaterial(evt:MessageEvent) : void
      {
         var param:Object = null;
         var obj:Object = evt.body;
         if(obj.param == -1)
         {
            param = {};
            param.subtaskID = 7004001;
            param.taskID = 7004000;
            this.showTaskFinishedInfo(param);
            TaskList.getInstance().makeTaskComplete(7004000,7004001);
         }
         else
         {
            this.sendMessage(MsgDoc.OP_CLIENT_GET_MOJINGLUOPAN.send,obj.param,obj.body);
         }
      }
      
      private function onSendPacketInMaterialBack(evt:MessageEvent) : void
      {
         new Message("mojingluopans2c",evt.body).sendToChannel("datatrans");
      }
      
      private function onSendPacketInMidAutumn(evt:MessageEvent) : void
      {
         var obj:Object = evt.body;
         if(obj.flag == 1)
         {
            obj.index = this.lanternid;
            obj.type = this.lanterntype;
            this.lanternid = 0;
            this.lanterntype = -1;
         }
         else if(obj.flag == 0)
         {
            obj.index = 0;
            obj.type = 0;
         }
         this.sendMessage(MsgDoc.OP_CLIENT_GET_MID_AUTUMN.send,obj.flag,[obj.index,obj.type]);
      }
      
      private function onSendPacketInMidAutumnBack(evt:MessageEvent) : void
      {
         var obj:Object = evt.body;
         if(obj.flag == 0)
         {
            new Message("zhongqiudengjias2c",{
               "type":1,
               "list":obj.shelflist
            }).sendToChannel("datatrans");
            new Message("zhongqiudengchuans2c",{
               "type":1,
               "list":obj.shiplist
            }).sendToChannel("datatrans");
         }
         else if(obj.flag == 1)
         {
            if(obj.type == 0)
            {
               new Message("zhongqiudengchuans2c",{
                  "type":2,
                  "index":obj.index,
                  "status":obj.status
               }).sendToChannel("datatrans");
            }
            else
            {
               new Message("zhongqiudengjias2c",{
                  "type":2,
                  "index":obj.index,
                  "status":obj.status
               }).sendToChannel("datatrans");
            }
         }
         else if(obj.flag == 2)
         {
            if(obj.able == 1)
            {
               this.lanternid = obj.index;
               this.lanterntype = obj.type;
               if(this.lanterntype == 1)
               {
                  new Message("zhongqiudengjias2c",{"type":3}).sendToChannel("datatrans");
               }
               else
               {
                  new Message("zhongqiudengchuans2c",{"type":3}).sendToChannel("datatrans");
               }
            }
         }
      }
      
      private function onGetAnniversaryInfoBack(evt:MessageEvent) : void
      {
         var gameperson:GamePerson = null;
         var param:Object = evt.body;
         if(Boolean(param.flag))
         {
            gameperson = MapView.instance.findGameSprite(param.uid) as GamePerson;
            if(gameperson != null)
            {
               gameperson.playActivityAnimation();
            }
            if(GameData.instance.playerData.userId == param.uid)
            {
               this.view.personCannotMove(true);
               gameperson.stop(true);
            }
         }
         else if(GameData.instance.playerData.userId == param.uid)
         {
            new Alert().show("当前场景不能使用同享符哦！~");
         }
      }
      
      private function onGetEffectAwardBack(evt:MessageEvent) : void
      {
         var param:Object = evt.body;
         var fontSize:int = 20;
         var fontColor:uint = 16776960;
         var xCoord:Number = 0;
         var yCoord:Number = 0;
         var gameperson:GamePerson = MapView.instance.findGameSprite(param.uid) as GamePerson;
         if(gameperson == null)
         {
            return;
         }
         xCoord = gameperson.x;
         yCoord = gameperson.y - 55;
         if(!param.flag)
         {
            fontSize = 15;
            fontColor = 65535;
         }
         else
         {
            this.view.personCannotMove(false);
         }
         if(CacheData.instance.palyerStateDic[1] != 1)
         {
            this.view.showEffectAward(param,fontSize,fontColor,xCoord,yCoord);
         }
         if(param.uid == GameData.instance.playerData.userId)
         {
            if(CacheData.instance.palyerStateDic[1] != 1)
            {
               this.view.showFloatAlert("恭喜获得来自【同享符】分享的 " + param.exp + " 历练!!",3);
            }
         }
      }
      
      private function delayAwardHandler(... rest) : void
      {
         clearTimeout(this.delayTid);
         this.delayTid = 0;
         this.view.getAwardWithoutComplete(rest[0]);
      }
      
      private function removeNPCList(removeList:Array) : void
      {
         var rnid:int = 0;
         for each(rnid in removeList)
         {
            this.dispatch(EventConst.REMOVEDYNAMICTASKNPC,rnid);
         }
      }
      
      private function toSendSignalOfActivityAI(evt:MessageEvent) : void
      {
         sendMessage(MsgDoc.OP_CLIENT_ACTIVITY.send,27,[(evt.body as int) - 10029]);
      }
      
      private function sendMsgToSrvFromTaskListItems(evt:MessageEvent) : void
      {
         var vo:TasklistItemVo = evt.body as TasklistItemVo;
         sendMessage(vo.msgCode,vo.head,vo.body);
      }
      
      private function getValueByKeyFromSingleTaskInfo(param:Object, key:int) : int
      {
         var obj:Object = null;
         if(param == null || !param.hasOwnProperty("list") || param.list == null)
         {
            return 0;
         }
         for each(obj in param.list)
         {
            if(obj.key == key)
            {
               return obj.value;
            }
         }
         return 0;
      }
      
      private function onOpDailyTaskCompleteBack(evt:MessageEvent) : void
      {
         var taskid:int = int(evt.body.readInt());
         this.view.showFloatAlert("完成了1个日常任务，快去日常任务中抽奖吧！",3);
      }
   }
}

