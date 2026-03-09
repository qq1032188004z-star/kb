package com.game.modules.view.task
{
   import com.core.observer.MessageEvent;
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.locators.EventDefine;
   import com.game.locators.GameData;
   import com.game.manager.EventManager;
   import com.game.manager.MouseManager;
   import com.game.modules.control.task.TaskControl;
   import com.game.modules.control.task.TaskEvent;
   import com.game.modules.control.task.TaskList;
   import com.game.modules.control.task.util.Task;
   import com.game.modules.control.task.util.TaskUtils;
   import com.game.modules.control.task.util.TaskXMLParser;
   import com.game.modules.view.WindowLayer;
   import com.game.util.AwardAlert;
   import com.game.util.FloatAlert;
   import com.game.util.HtmlUtil;
   import com.game.util.PropertyPool;
   import com.kb.util.CommonDefine;
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.alert.Alert;
   import com.publiccomponent.loading.MaterialLib;
   import com.publiccomponent.loading.XMLLocator;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   [SWF(width="970",height="570")]
   public class TaskView extends Sprite
   {
      
      private static var _instance:TaskView;
      
      public static const GET_TASK_DIALOG:String = "gettaskdialog";
      
      public static const COM_TASK_DIALOG:String = "comtaskdialog";
      
      public static const ADD_DYNAMICUI:String = "adddynamicui";
      
      public static const NEED_SPECIAL_OP:String = "needspecialop";
      
      public static const GET_TASK_STATUS:String = "gettaskstatus";
      
      public var currentNPCID:int;
      
      private var currentNPCStatus:int;
      
      private var currentTask:Task;
      
      public var currentDialogID:int;
      
      private var taskStateTip:MovieClip;
      
      private var taskParams:Object;
      
      private var wholemask:MovieClip;
      
      private var needToChangeMouse:Object;
      
      private var safeGuideID:int;
      
      public function TaskView()
      {
         super();
         this.wholemask = new MovieClip();
         this.wholemask.graphics.beginFill(0,0);
         this.wholemask.graphics.drawRect(0,0,970,570);
         this.wholemask.graphics.endFill();
         this.addChild(this.wholemask);
         this.wholemask.x = 0;
         this.wholemask.y = 0;
         this.wholemask.mouseEnabled = false;
         this.wholemask.visible = false;
      }
      
      public static function get instance() : TaskView
      {
         if(_instance == null)
         {
            _instance = new TaskView();
            ApplicationFacade.getInstance().registerViewLogic(new TaskControl(_instance));
         }
         return _instance;
      }
      
      public function onGetDialogBack(params:Object = null) : void
      {
         if(params == null)
         {
            return;
         }
         if(params.hasOwnProperty("dialogId"))
         {
            if(params.dialogId == 0)
            {
               if(params.hasOwnProperty("npcid"))
               {
                  EventManager.dispatch(this,new MessageEvent(GET_TASK_DIALOG,params.npcid));
               }
               return;
            }
            if(params.dialogId == params.npcid)
            {
               this.currentNPCID = params.npcid;
               this.onDialogComplete(params.dialogId);
               return;
            }
            PropertyPool.instance.getTaskProps(params.dialogId,this.onGetPropsBack,params);
         }
      }
      
      private function onGetPropsBack(props:XML, arr:Array) : void
      {
         var params:Object;
         var xml:XML;
         var obj:* = undefined;
         var chooseId:int = 0;
         var taskinfoXML:XML = null;
         var subTaskInfoXML:XML = null;
         if(props == null)
         {
            return;
         }
         params = arr[0];
         xml = props.children().(@id == params.dialogId)[0] as XML;
         if(params.hasOwnProperty("npcid"))
         {
            this.currentNPCID = params.npcid;
         }
         this.currentDialogID = params.dialogId;
         if(xml != null)
         {
            if(xml.children().length() == 0)
            {
               this.onDialogComplete(params.dialogId);
               return;
            }
            obj = TaskXMLParser.getInstance().parseXML(xml,params.subtaskID,params.taskID,params.dialogId);
            xml = null;
            if(obj == null)
            {
               return;
            }
            if(obj is Task)
            {
               if(Boolean(params.hasOwnProperty("paramList")) && params.paramList.length > 0)
               {
                  (obj as Task).argument = params.paramList;
               }
               chooseId = 0;
               if(Boolean(params.hasOwnProperty("chooseId")) && params.chooseId != 0)
               {
                  chooseId = int(params.chooseId);
               }
               this.currentTask = obj;
               EventManager.dispatch(this,new MessageEvent(EventConst.OPENDIAVIEW,{
                  "task":obj,
                  "position":0,
                  "needchoose":chooseId
               }));
            }
            else
            {
               if(params.taskID < 4000000 && params.taskID != 0)
               {
                  taskinfoXML = XMLLocator.getInstance().getTaskInfo(params.taskID);
                  subTaskInfoXML = taskinfoXML.children().(@id == params.subtaskID)[0] as XML;
                  obj.title = subTaskInfoXML.@name;
                  taskinfoXML = null;
                  subTaskInfoXML = null;
               }
               else
               {
                  obj.title = obj.tName;
               }
               if(Boolean(params.hasOwnProperty("flag")) && params.flag != 0)
               {
                  this.currentNPCID = params.flag;
                  obj.flag = params.flag;
               }
               obj.type = params.type;
               if(Boolean(params.hasOwnProperty("paramList")) && params.paramList.length > 0)
               {
                  obj.desc = this.replaceDynamicArguments(obj.desc,params.paramList);
               }
               if(Boolean(params.hasOwnProperty("goods")) && params.goods.length > 0)
               {
                  obj.callback = this.showTaskAlert;
                  obj.goods = params.goods;
                  obj.type = params.type;
                  this.onShowWoodsInDialog(obj);
               }
               else
               {
                  this.showTaskAlert(obj);
               }
            }
         }
         else if(GameData.instance.playerData.isNewHand != 9)
         {
            new Alert().show("你还没有做完新手指引哦，去驾驶舱找阳光机长吧");
         }
      }
      
      private function showTaskAlert(params:Object) : void
      {
         if(Boolean(params.hasOwnProperty("opname")) && params.opname != "" && Boolean(params.hasOwnProperty("opid")) && params.opid != 0)
         {
            if(this.needToChangeMouse == null)
            {
               this.needToChangeMouse = {};
            }
            this.needToChangeMouse.opname = params.opname;
            this.needToChangeMouse.opid = params.opid;
         }
         if(Boolean(params.hasOwnProperty("flag")) && params.flag != 0)
         {
            if(this.needToChangeMouse == null)
            {
               this.needToChangeMouse = {};
            }
            this.needToChangeMouse.sendback = 1;
         }
         if(params.type == 26)
         {
            if(this.needToChangeMouse == null)
            {
               this.needToChangeMouse = {};
            }
            this.needToChangeMouse.sendback = -1;
         }
         TaskAlert.show(stage,params.title,params.desc,params.imgUrl,this.tipsNeedSendPacket,params.sceneId);
      }
      
      private function tipsNeedSendPacket() : void
      {
         if(this.currentDialogID == 200100504)
         {
            EventManager.dispatch(this,new MessageEvent(ADD_DYNAMICUI,{
               "type":1,
               "x":296,
               "y":480,
               "uiname":"jiantou"
            }));
         }
         if(this.needToChangeMouse != null)
         {
            if(this.needToChangeMouse.hasOwnProperty("opname"))
            {
               switch(this.needToChangeMouse.opname)
               {
                  case "mouse":
                     MouseManager.getInstance().setCursor("CursorTool" + this.needToChangeMouse.opid);
               }
            }
            if(this.needToChangeMouse.hasOwnProperty("sendback"))
            {
               if(this.needToChangeMouse.sendback == 1)
               {
                  this.onDialogComplete(this.currentDialogID);
               }
               else if(this.needToChangeMouse.sendback == -1)
               {
                  TaskUtils.getInstance().dispatchEvent(TaskEvent.DIALOGFINISHED,{
                     "dialogId":this.currentDialogID,
                     "sceneId":0,
                     "needchoose":0
                  });
               }
            }
            this.needToChangeMouse = null;
         }
      }
      
      public function onShowWoodsInDialog(params:Object) : void
      {
         var i:int = 0;
         var len:int = 0;
         var arr:Array = null;
         var str:String = null;
         var url:String = null;
         i = 0;
         if(params.type == 1 || params.type == 5)
         {
            len = int(params.itemArr.length);
            arr = params.itemArr;
         }
         else if(params.type == 2 && Boolean(params.hasOwnProperty("goods")))
         {
            len = int(params.goods.length);
            arr = params.goods;
         }
         for(i = 0; i < len; i++)
         {
            if(arr[i].id != 0)
            {
               if(arr[i].type == 1)
               {
                  try
                  {
                     str = String(XMLLocator.getInstance().getTool(arr[i].id).name);
                  }
                  catch(e:*)
                  {
                     str = arr[i].id + "   不知道是什么";
                  }
               }
               else if(arr[i].type == 2)
               {
                  try
                  {
                     str = String(XMLLocator.getInstance().getSprited(arr[i].id).name);
                  }
                  catch(e:*)
                  {
                     str = arr[i].id + "   不知道是神马";
                  }
               }
               else if(arr[i].type == 3)
               {
                  try
                  {
                     str = String(XMLLocator.getInstance().getTool(arr[i].number).name);
                  }
                  catch(e:*)
                  {
                     str = arr[i].number + "   不知道是什么";
                  }
               }
               if(i == 0)
               {
                  if(params.type == 1)
                  {
                     if(arr[i].type == 1)
                     {
                        url = "assets/tool/" + arr[i].id + ".swf";
                        new AwardAlert().showGoodsAward(url,stage," 获得 " + HtmlUtil.getHtmlText(12,"#FF0000",str),true,this.onGetDialogBack,params);
                     }
                     else if(arr[i].type == 2)
                     {
                        url = "assets/monsterimg/" + arr[i].id + ".swf";
                        new AwardAlert().showMonsterAward(url,stage," 获得 " + str,true,this.onGetDialogBack,params);
                     }
                     else if(arr[i].type == 3)
                     {
                        new AwardAlert().showMultipleAward(URLUtil.getSvnVer("assets/tool/" + arr[i].id + ".swf"),URLUtil.getSvnVer("assets/tool/" + arr[i].number + ".swf"),this.stage," 获得 " + HtmlUtil.getHtmlText(12,"#FF0000",str),true);
                     }
                  }
                  else if(params.hasOwnProperty("callback"))
                  {
                     new AwardAlert().showGoodsAward("assets/tool/" + arr[i].id + ".swf",stage," 获得 " + HtmlUtil.getHtmlText(12,"#FF0000",str),true,params.callback,params);
                  }
                  else
                  {
                     new AwardAlert().showGoodsAward("assets/tool/" + arr[i].id + ".swf",stage," 获得 " + HtmlUtil.getHtmlText(12,"#FF0000",str),true);
                  }
               }
               else if(arr[i].type == 1)
               {
                  new AwardAlert().showGoodsAward("assets/tool/" + arr[i].id + ".swf",stage," 获得 " + HtmlUtil.getHtmlText(12,"#FF0000",str),true);
               }
               else if(arr[i].type == 2)
               {
                  new AwardAlert().showMonsterAward("assets/monsterimg/" + arr[i].id + ".swf",stage," 获得 " + str,true);
               }
               else if(arr[i].type == 3)
               {
                  new AwardAlert().showMultipleAward(URLUtil.getSvnVer("assets/tool/" + arr[i].id + ".swf"),URLUtil.getSvnVer("assets/tool/" + arr[i].number + ".swf"),this.stage," 获得 " + HtmlUtil.getHtmlText(12,"#FF0000",str),true);
               }
            }
         }
      }
      
      public function onDialogComplete(dialogID:int, needChoose:int = 0) : void
      {
         this.dispatchEvent(new MessageEvent(COM_TASK_DIALOG,{
            "npcid":this.currentNPCID,
            "dialogID":dialogID,
            "chooseid":needChoose
         }));
      }
      
      public function taskCompleteBack(param:Object) : void
      {
         var tmpDailyFlag:Boolean = false;
         if(param.subtaskID >= 8001001 && param.subtaskID <= 8001005)
         {
            TaskList.getInstance().updateFamilyTaskCompleteCount();
         }
         this.taskParams = param;
         var task:Task = TaskList.getInstance().getSpecifiedTask(TaskList.TASK_LIST_ACCEPTED,param.subtaskID);
         if(task == null)
         {
            tmpDailyFlag = TaskList.getInstance().dailyTaskCompleted(param.subtaskID);
         }
         else
         {
            task.state = true;
            TaskList.getInstance().updateTask(task,TaskList.TASK_REMOVE_COMPLETE);
         }
         this.taskStateTip = MaterialLib.getInstance().getMaterial("taskComplete") as MovieClip;
         this.taskStateTip.addFrameScript(this.taskStateTip.totalFrames - 1,this.removeTaskStateTip);
         this.addChild(this.taskStateTip);
         this.taskStateTip.x = 295;
         this.taskStateTip.y = 250;
         this.taskStateTip.gotoAndPlay(1);
      }
      
      private function removeTaskStateTip() : void
      {
         if(this.taskStateTip != null)
         {
            this.taskStateTip.stop();
            if(this.contains(this.taskStateTip))
            {
               this.removeChild(this.taskStateTip);
            }
            this.taskStateTip = null;
         }
         if(this.taskParams.hasOwnProperty("coin"))
         {
            this.awardAlert(this.taskParams);
         }
      }
      
      private function awardAlert(params:Object) : void
      {
         var goods:Array = null;
         var tempexp:int = 0;
         var tempcoin:int = 0;
         var tempcul:int = 0;
         if(Boolean(params.hasOwnProperty("cultivate")) && params.cultivate > 0)
         {
            tempcul = int(params.cultivate);
         }
         if(Boolean(params.hasOwnProperty("item")) && params.item.length > 0)
         {
            goods = params.item;
         }
         if(Boolean(params.hasOwnProperty("coin")) && params.coin > 0)
         {
            tempcoin = int(params.coin);
         }
         if(Boolean(params.hasOwnProperty("exp")) && params.exp > 0)
         {
            tempexp = int(params.exp);
         }
         this.showAward(tempexp,tempcoin,tempcul,goods,this.onClickComplete);
         if(Boolean(params.hasOwnProperty("limitaward")) && params.limitaward > 0)
         {
            ApplicationFacade.getInstance().dispatch(EventConst.BOBSTATECLICK,{"url":"assets/system/taskaward/taskLimitAwardTip.swf"});
         }
         if(Boolean(params.hasOwnProperty("bigaward")) && params.bigaward > 0)
         {
            ApplicationFacade.getInstance().dispatch(EventConst.BOBSTATECLICK,{"url":"assets/system/taskaward/taskEndAwardTip.swf"});
         }
      }
      
      private function onClickComplete(param:Object = null) : void
      {
         if(this.currentTask != null)
         {
            if(this.currentTask.targetScene != 0)
            {
               EventManager.dispatch(this,new MessageEvent(TaskEvent.SENDTOOTHERSCENE,this.currentTask.targetScene));
            }
            this.onDialogComplete(this.currentTask.dialogID);
         }
      }
      
      public function showGetTaskWoods(params:Object, flag:Boolean) : void
      {
         var xml:XML = null;
         var url:String = null;
         var str:String = null;
         var i:int = 0;
         for(i = 0; i < params.number; i++)
         {
            str = "";
            xml = XMLLocator.getInstance().getTool(params.woods[i].param);
            if(xml == null)
            {
               xml = XMLLocator.getInstance().getSprited(params.woods[i].param);
               if(xml == null)
               {
                  return;
               }
            }
            else
            {
               url = "assets/tool/" + params.woods[0].param + ".swf";
            }
            if(flag)
            {
               str += "获得 " + xml.name.toString() + params.woods[i].value + " 个,快去背包看看吧!";
            }
            else
            {
               str += "失去 " + xml.name.toString() + params.woods[i].value + " 个,快去背包看看吧!";
            }
            new AwardAlert().showGoodsAward(url,stage,str,flag);
         }
      }
      
      public function onNPCTalkBack(sid:int, needChoose:int = 0) : void
      {
         this.currentNPCID = sid;
         this.dispatchEvent(new MessageEvent(COM_TASK_DIALOG,{
            "npcid":this.currentNPCID,
            "dialogID":this.currentDialogID,
            "chooseid":needChoose
         }));
      }
      
      public function showAwardInDailyCompass(index:int, rand:int) : void
      {
         var exp:int = 0;
         var goodId:int = 0;
         var goodNum:int = 0;
         switch(index)
         {
            case 1:
               exp = 200;
               if(rand == 1)
               {
                  goodId = 100008;
                  goodNum = 3;
               }
               else if(rand == 2)
               {
                  goodId = 100001;
                  goodNum = 1;
               }
               else
               {
                  goodId = 100010;
                  goodNum = 1;
               }
               break;
            case 2:
               exp = 400;
               if(rand == 1)
               {
                  goodId = 100008;
                  goodNum = 5;
               }
               else if(rand == 2)
               {
                  goodId = 100001;
                  goodNum = 2;
               }
               else
               {
                  goodId = 100010;
                  goodNum = 2;
               }
               break;
            case 3:
               exp = 600;
               if(rand == 1)
               {
                  goodId = 100007;
                  goodNum = 3;
               }
               else if(rand == 2)
               {
                  goodId = 100001;
                  goodNum = 3;
               }
               else
               {
                  goodId = 100011;
                  goodNum = 2;
               }
               break;
            case 4:
               exp = 800;
               if(rand == 1)
               {
                  goodId = 100007;
                  goodNum = 5;
               }
               else if(rand == 2)
               {
                  goodId = 100002;
                  goodNum = 3;
               }
               else
               {
                  goodId = 100011;
                  goodNum = 3;
               }
               break;
            case 5:
               if(rand == 1)
               {
                  exp = 10000;
               }
               else
               {
                  goodId = 100034;
                  goodNum = 1;
               }
               break;
            case 6:
               if(rand == 1)
               {
                  exp = 15000;
               }
               else
               {
                  goodId = 100004;
                  goodNum = 1;
               }
               break;
            case 7:
               if(rand == 1)
               {
                  exp = 20000;
               }
               else
               {
                  goodId = 100013;
                  goodNum = 1;
               }
         }
         if(exp != 0)
         {
            new AwardAlert().showExpAward(exp,stage);
         }
         if(goodId == 0)
         {
            return;
         }
         var xml:XML = XMLLocator.getInstance().getTool(goodId);
         if(xml == null)
         {
            return;
         }
         new AwardAlert().showGoodsAward("assets/tool/" + goodId + ".swf",stage,"获得" + HtmlUtil.getHtmlText(12,"#FF0000",goodNum + "个" + xml.name.toString()),true);
      }
      
      public function needSpecialOp(spIndex:int) : void
      {
         switch(spIndex)
         {
            case 5:
               new Alert().showSureOrCancel("你确定要将账号告诉陌生人吗？",this.safeGuideHandler);
               break;
            case 6:
               this.safeGuideHandler("取消");
               break;
            case 7:
               EventManager.dispatch(this,new MessageEvent(GET_TASK_DIALOG,this.currentNPCID));
               break;
            case 8:
               EventManager.dispatch(this,new MessageEvent(GET_TASK_STATUS,this.currentNPCID));
         }
      }
      
      private function safeGuideHandler(... rest) : void
      {
         if(rest[0] == "确定")
         {
            this.safeGuideID = 600600102;
         }
         else
         {
            this.safeGuideID = 600600103;
         }
         EventManager.dispatch(this,new MessageEvent(NEED_SPECIAL_OP,{
            "npcid":18003,
            "type":3,
            "callback":this.safeGuideHandlerBack
         }));
      }
      
      private function safeGuideHandlerBack(spriteName:String = "") : void
      {
         if(this.safeGuideID == 0)
         {
            return;
         }
         this.onGetDialogBack({
            "npcid":18003,
            "itemcount":0,
            "dialogId":this.safeGuideID,
            "subtaskID":6006001,
            "taskID":6006000
         });
         this.safeGuideID = 0;
      }
      
      public function getAwardWithoutComplete(param:Object) : void
      {
         var goods:Array = null;
         if(param == null)
         {
            return;
         }
         if(Boolean(GameData.instance.autoLookForPresuresData.isAutoNum))
         {
            return;
         }
         var tempexp:int = 0;
         var tempcoin:int = 0;
         var tempcul:int = 0;
         if(Boolean(param.hasOwnProperty("item")) && param.item.length > 0)
         {
            goods = param.item;
         }
         if(param.hasOwnProperty("cultivate"))
         {
            tempcul = int(param.cultivate);
         }
         if(param.hasOwnProperty("coin"))
         {
            tempcoin = int(param.coin);
         }
         if(param.hasOwnProperty("exp"))
         {
            tempexp = int(param.exp);
         }
         if(Boolean(param.hasOwnProperty("callback")) && param.callback != null)
         {
            this.showAward(tempexp,tempcoin,tempcul,goods,param.callback);
         }
         else
         {
            this.showAward(tempexp,tempcoin,tempcul,goods);
         }
      }
      
      public function showAlertNotUseTaskAlert(params:Object, showType:int) : void
      {
         if(params == null)
         {
            return;
         }
         if(params.hasOwnProperty("dialogId"))
         {
            if(params.dialogId == 0)
            {
               if(params.hasOwnProperty("npcid"))
               {
                  EventManager.dispatch(this,new MessageEvent(GET_TASK_DIALOG,params.npcid));
               }
               return;
            }
            if(params.dialogId == params.npcid)
            {
               this.currentNPCID = params.npcid;
               this.onDialogComplete(params.dialogId);
               return;
            }
            if(params.dialogId == 601005904)
            {
               GameData.instance.dispatchEvent(new MessageEvent(EventDefine.XUNBAO_224_CANT_USE));
            }
            PropertyPool.instance.getTaskProps(params.dialogId,this.onGetPropsBackAlert,params,showType);
         }
      }
      
      private function onGetPropsBackAlert(props:XML, arr:Array) : void
      {
         var params:Object;
         var xml:XML;
         var obj:* = undefined;
         var tempexp:int = 0;
         var tempcoin:int = 0;
         var tempcul:int = 0;
         var goods:Array = null;
         if(props == null)
         {
            return;
         }
         params = arr[0];
         xml = props.children().(@id == params.dialogId)[0] as XML;
         if(params.hasOwnProperty("flag"))
         {
            this.currentNPCID = params.flag;
         }
         this.currentDialogID = params.dialogId;
         if(xml != null)
         {
            if(xml.children().length() == 0)
            {
               this.onDialogComplete(params.dialogId);
               return;
            }
            obj = TaskXMLParser.getInstance().parseXML(xml,params.subtaskID,params.taskID,params.dialogId);
            xml = null;
            if(obj == null)
            {
               return;
            }
            if(arr.length > 1)
            {
               if(arr[1] == 1)
               {
                  new Alert().showOne(obj.desc,this.onCloseAlertHandler);
               }
               else
               {
                  new FloatAlert().show(this.stage,300,400,obj.desc,3,300);
               }
            }
         }
         if(Boolean(params.hasOwnProperty("goods")) && params.goods.length > 0)
         {
            tempexp = 0;
            tempcoin = 0;
            tempcul = 0;
            if(params.hasOwnProperty("exp"))
            {
               tempexp = int(params.exp);
            }
            if(params.hasOwnProperty("coin"))
            {
               tempcoin = int(params.coin);
            }
            if(params.hasOwnProperty("cultivate"))
            {
               tempcul = int(params.cultivate);
            }
            goods = params.goods;
            this.showAward(tempexp,tempcoin,tempcul,goods);
         }
      }
      
      private function onCloseAlertHandler(txt:String, ... rest) : void
      {
         if(txt == "确定")
         {
            this.onDialogComplete(this.currentDialogID);
         }
      }
      
      public function getXiuwei(param:Object) : void
      {
         if(Boolean(GameData.instance.autoLookForPresuresData.isAutoNum))
         {
            return;
         }
         var str:String = "获得" + param.xiuweiNum;
         switch(param.xiuweiType)
         {
            case 1:
               str += "攻击";
               break;
            case 2:
               str += "防御";
               break;
            case 3:
               str += "法术";
               break;
            case 4:
               str += "抗性";
               break;
            case 5:
               str += "体力";
               break;
            case 6:
               str += "速度";
         }
         str += "修为，已经放入你的贝贝，请使用贝贝自行分配！";
         new Alert().showOne(str);
      }
      
      private function showAward(exp:int = 0, coin:int = 0, cultivate:int = 0, goods:Array = null, callback:Function = null) : void
      {
         var i:int = 0;
         var len:int = 0;
         var str:String = null;
         var tool:XML = null;
         var showFlag:Boolean = false;
         if(cultivate > 0)
         {
            new AwardAlert().showCultivateAward(cultivate,WindowLayer.instance.stage,callback);
            if(callback != null)
            {
               showFlag = true;
            }
         }
         if(goods != null && goods.length > 0)
         {
            i = 0;
            len = int(goods.length);
            str = "";
            for(i = 0; i < len; i++)
            {
               if(goods[i].id != 0)
               {
                  if(goods[i].type == 1)
                  {
                     try
                     {
                        tool = XMLLocator.getInstance().getTool(goods[i].id);
                        str = tool.name;
                        if(CommonDefine.DRESS_ALL.indexOf(int(tool.type)) != -1)
                        {
                           ApplicationFacade.getInstance().dispatch(EventDefine.GET_NEW_DRESS,{"xml":tool});
                        }
                     }
                     catch(e:*)
                     {
                        str = goods[i].id + "   不知道是什么";
                     }
                     if(!showFlag && callback != null)
                     {
                        new AwardAlert().showGoodsAward("assets/tool/" + goods[i].id + ".swf",this," 获得 " + HtmlUtil.getHtmlText(12,"#FF0000",goods[i].number + "个" + str),true,callback);
                        showFlag = true;
                     }
                     else
                     {
                        new AwardAlert().showGoodsAward("assets/tool/" + goods[i].id + ".swf",this," 获得 " + HtmlUtil.getHtmlText(12,"#FF0000",goods[i].number + "个" + str),true);
                     }
                  }
                  else if(goods[i].type == 2)
                  {
                     try
                     {
                        str = String(XMLLocator.getInstance().getSprited(goods[i].id).name);
                     }
                     catch(e:*)
                     {
                        str = goods[i].id + "   不知道是神马";
                     }
                     if(!showFlag && callback != null)
                     {
                        new AwardAlert().showMonsterAward("assets/monsterimg/" + goods[i].id + ".swf",this," 获得 " + str,true,callback);
                        showFlag = true;
                     }
                     else
                     {
                        new AwardAlert().showMonsterAward("assets/monsterimg/" + goods[i].id + ".swf",this," 获得 " + str,true);
                     }
                  }
                  else if(goods[i].type == 3)
                  {
                     try
                     {
                        str = String(XMLLocator.getInstance().getTool(goods[i].number).name);
                     }
                     catch(e:*)
                     {
                        str = goods[i].number + "   不知道是什么";
                     }
                     if(!showFlag && callback != null)
                     {
                        new AwardAlert().showMultipleAward(URLUtil.getSvnVer("assets/tool/" + goods[i].id + ".swf"),URLUtil.getSvnVer("assets/tool/" + goods[i].number + ".swf"),this," 获得 " + HtmlUtil.getHtmlText(12,"#FF0000",str),true,callback);
                        showFlag = true;
                     }
                     else
                     {
                        new AwardAlert().showMultipleAward(URLUtil.getSvnVer("assets/tool/" + goods[i].id + ".swf"),URLUtil.getSvnVer("assets/tool/" + goods[i].number + ".swf"),this," 获得 " + HtmlUtil.getHtmlText(12,"#FF0000",str),true);
                     }
                  }
                  else if(goods[i].type == 4)
                  {
                     this.getXiuwei({
                        "xiuweiType":goods[i].id,
                        "xiuweiNum":goods[i].number
                     });
                  }
                  else if(goods[i].type == 5)
                  {
                     str = goods[i].id + "点";
                     new Alert().showOne(" 获得 " + str + "点券， 请注意查看!");
                  }
                  else if(goods[i].type == 6)
                  {
                     try
                     {
                        str = String(XMLLocator.getInstance().getTool(goods[i].id).name);
                     }
                     catch(e:*)
                     {
                        str = goods[i].number + "   不知道是什么";
                     }
                     new AwardAlert().showMultipleAward(URLUtil.getSvnVer("assets/tool/" + goods[i].id + ".swf"),URLUtil.getSvnVer("assets/material/storeage.swf"),this," 获得 " + HtmlUtil.getHtmlText(12,"#FF0000",str),true);
                  }
               }
            }
         }
         if(coin > 0)
         {
            if(!showFlag && callback != null)
            {
               new AwardAlert().showMoneyAward(coin,stage,callback);
               showFlag = true;
            }
            else
            {
               new AwardAlert().showMoneyAward(coin,stage);
            }
         }
         if(exp > 0)
         {
            if(!showFlag && callback != null)
            {
               new AwardAlert().showExpAward(exp,stage,callback);
               showFlag = true;
            }
            else
            {
               new AwardAlert().showExpAward(exp,stage);
            }
         }
      }
      
      public function personCannotMove(flag:Boolean) : void
      {
         if(Boolean(this.wholemask))
         {
            this.wholemask.visible = flag;
         }
      }
      
      private function replaceDynamicArguments(str:String, args:Array) : String
      {
         var item:Object = null;
         var itemXML:XML = null;
         if(args == null || args.length == 0)
         {
            return str;
         }
         var i:int = 0;
         var len:int = int(args.length);
         var tmp:String = "";
         var tIndex:int = 0;
         for(i = 0; i < len; i++)
         {
            item = args[i];
            switch(item.type)
            {
               case 1:
                  itemXML = XMLLocator.getInstance().getMap(item.id);
                  tmp = HtmlUtil.getHtmlText(14,"#FF0000",itemXML.@name.toString());
                  break;
               case 2:
                  itemXML = XMLLocator.getInstance().getTool(item.id);
                  tmp = HtmlUtil.getHtmlText(14,"#FF0000",itemXML.name.toString());
            }
            if(tIndex >= 0)
            {
               tIndex = int(str.indexOf("instead",tIndex));
               if(tIndex == -1)
               {
                  return str;
               }
               str = str.replace(/instead/i,tmp);
            }
         }
         return str;
      }
      
      public function showEffectAward(param:Object, fontSize:int, fontColor:uint, xCoord:Number, yCoord:Number) : void
      {
         var tmpMsg:String = null;
         if(param.hasOwnProperty("exp"))
         {
            AwardTips.showMsg(this.stage,xCoord,yCoord,"历练 ",param.exp,20,80,fontSize,fontColor);
         }
         if(param.hasOwnProperty("coin"))
         {
            AwardTips.showMsg(this.stage,xCoord,yCoord,"铜钱 ",param.coin,20,80,fontSize,fontColor);
         }
         if(param.hasOwnProperty("cultive"))
         {
            tmpMsg = "";
            switch(param.cultiveType)
            {
               case 1:
                  tmpMsg += "攻击";
                  break;
               case 2:
                  tmpMsg += "防御";
                  break;
               case 3:
                  tmpMsg += "法术";
                  break;
               case 4:
                  tmpMsg += "抗性";
                  break;
               case 5:
                  tmpMsg += "体力";
                  break;
               case 6:
                  tmpMsg += "速度";
            }
            tmpMsg += "修为 ";
            AwardTips.showMsg(this.stage,xCoord,yCoord,tmpMsg,param.exp,20,60,fontSize,fontColor);
         }
         if(!param.hasOwnProperty("goodList"))
         {
         }
      }
      
      public function showFloatAlert(msg:String, time:int) : void
      {
         new FloatAlert().show(this.stage,300,400,msg,time,300);
      }
      
      public function showDailyTaskComplete() : void
      {
         ApplicationFacade.getInstance().dispatch(EventConst.BOBSTATECLICK,{"url":"assets/module/DailyTaskCompletedTip.swf"});
      }
   }
}

