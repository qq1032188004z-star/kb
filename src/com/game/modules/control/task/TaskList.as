package com.game.modules.control.task
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.locators.GameData;
   import com.game.modules.ai.SpecialAreaManager;
   import com.game.modules.control.task.util.Task;
   import com.game.modules.control.task.util.TaskInfoXMLParser;
   import com.game.modules.control.task.util.TaskUtils;
   import com.game.modules.control.task.util.TasklistItemVo;
   import com.game.modules.vo.DailyTaskData;
   import com.game.util.PropertyPool;
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.loading.XMLLocator;
   import flash.external.ExternalInterface;
   import flash.utils.Dictionary;
   
   public class TaskList
   {
      
      private static var instance:TaskList;
      
      public static const TASK_STATUS_NORMAL:int = 1;
      
      public static const TASK_STATUS_TASK:int = 2;
      
      public static const TASK_STATUS_WAIT:int = 3;
      
      public static const TASK_STATUS_AWARD:int = 4;
      
      public static const TASK_LIST_UNACCEPTED:String = "tasklistunaccepted";
      
      public static const TASK_LIST_ACCEPTED:String = "tasklistaccepted";
      
      public static const TASK_LIST_COMPLETED:String = "tasklistcompleted";
      
      public static const DAILY_TASK_LIST:String = "dailytasklist";
      
      public static const TASK_REMOVE_DROP:String = "taskremovedrop";
      
      public static const TASK_REMOVE_COMPLETE:String = "taskremovecomplete";
      
      private var taskDic:Dictionary;
      
      private var _allTaskObj:Array;
      
      private var _taskBitStatus:int = 0;
      
      private var _familyTaskCompleteCount:int = 0;
      
      private var _hbTaskCompleteCount:int = 0;
      
      private var _freshManTaskFlag:int = 0;
      
      private var dropID:int;
      
      private var _functionList:Dictionary;
      
      private var _freshManMap:Dictionary;
      
      private var _overlordList:Array;
      
      private var _chapterList:Array;
      
      private const DAILY_TASK_NUM:int = 4;
      
      public function TaskList()
      {
         super();
         if(instance != null)
         {
            throw new Error("任务列表类是单例类,他已经实例化了.");
         }
         this.taskDic = new Dictionary(true);
         this.taskDic[TaskList.TASK_LIST_ACCEPTED] = [];
         this.taskDic[TaskList.TASK_LIST_COMPLETED] = [];
         this.taskDic[TASK_LIST_UNACCEPTED] = [];
         this.taskDic[DAILY_TASK_LIST] = [];
         this.loadFunctionList();
      }
      
      public static function getInstance() : TaskList
      {
         if(instance == null)
         {
            instance = new TaskList();
         }
         return instance;
      }
      
      public function initAllTask(params:Object) : void
      {
         GameData.instance.tasklistInited = true;
         if(params.hasOwnProperty("newestFlag"))
         {
            TaskInfoXMLParser.instance.loadNewest(URLUtil.getSvnVer("assets/taskprop/" + params.newestFlag + ".xml"));
         }
         this.specialDataFilter(params);
         this._allTaskObj = TaskInfoXMLParser.instance.parse();
         if(params.acceptedTaskCount > 0)
         {
            this.magicStatus(params.finishedTaskList);
         }
         if(params.finishedTaskCount == 0 && params.acceptedTaskCount == 0)
         {
            this.split(null,null);
            return;
         }
         if(params.acceptedTaskCount == 0)
         {
            this.split(null,params.finishedTaskList);
         }
         else if(params.finishedTaskCount == 0)
         {
            this.split(params.acceptedTaskList,null);
         }
         else
         {
            this.split(params.acceptedTaskList,params.finishedTaskList);
         }
      }
      
      private function magicStatus(com:Array) : void
      {
         var obj:Object = null;
         for each(obj in com)
         {
            if(obj.subtaskID == 6007001)
            {
               GameData.instance.playerData.magicstate |= 1;
               return;
            }
         }
      }
      
      public function getSpecifiedTask(type:String, subtaskId:int) : Task
      {
         var task:Task = null;
         var tempArr:Array = this.taskDic[type];
         if(tempArr == null)
         {
            trace("指定的任务不存在..");
            return null;
         }
         for each(task in tempArr)
         {
            if(task.subtaskID == subtaskId)
            {
               return task;
            }
         }
         trace("就没有这个任务嘛....TaskList -> getSpecifiedTask",subtaskId,type);
         return null;
      }
      
      public function getSpecifiedAcceptTask(taskId:int) : Task
      {
         var tempArr:Array = this.taskDic[TaskList.TASK_LIST_ACCEPTED];
         var i:int = 0;
         var len:int = int(tempArr.length);
         if(len == 0)
         {
            return null;
         }
         for(i = 0; i < len; i++)
         {
            if(tempArr[i].taskID == taskId)
            {
               return tempArr[i];
            }
         }
         return null;
      }
      
      public function getLastCompleteTaskIn(taskid:int) : Task
      {
         var task:Task = null;
         var frontState:int = 0;
         var temparr:Array = null;
         switch(this.getStateOfSpecifiedTask(taskid))
         {
            case 0:
            case 3:
               frontState = this.getStateOfSpecifiedTask(taskid - 1000);
               if(frontState == 2 || frontState == -1)
               {
                  task = this.getSpecifiedTask(TaskList.TASK_LIST_UNACCEPTED,taskid + 1);
               }
               break;
            case 1:
               task = this.getSpecifiedAcceptTask(taskid);
               if(task != null)
               {
                  return task;
               }
               temparr = this.getSubtaskList(taskid);
               temparr = temparr.filter(this.unAcceptFilter);
               temparr.sortOn("subtaskID",Array.NUMERIC);
               task = temparr[0];
               break;
            case 2:
               task = this.getSpecifiedTask(TaskList.TASK_LIST_COMPLETED,taskid + 1);
         }
         return task;
      }
      
      private function unAcceptFilter(item:*, index:int, array:Array) : Boolean
      {
         return (item as Task).currentState == 0 ? true : false;
      }
      
      public function hasBeenComplete(subtaskId:int) : Boolean
      {
         var task:Task = null;
         var tempArr:Array = this.taskDic[TaskList.TASK_LIST_COMPLETED];
         for each(task in tempArr)
         {
            if(task.subtaskID == subtaskId)
            {
               return true;
            }
         }
         return false;
      }
      
      public function updateTask(task:Task, type:String = "") : void
      {
         trace("【任务列表打印输出】 进行任务状态更新之前 未接任务数： " + this.taskDic[TASK_LIST_UNACCEPTED].length + "\t已接任务数： " + this.taskDic[TASK_LIST_ACCEPTED].length + "\t已完成任务数： " + this.taskDic[TASK_LIST_COMPLETED].length);
         var tempstate:int = this.getStateOfSpecifiedSubtask(task.subtaskID);
         if(tempstate == 2)
         {
            trace("【任务列表打印输出】 要更新状态的任务已经完成...不予以进行更新...");
            return;
         }
         switch(type)
         {
            case "":
               this.update(task);
               break;
            case TaskList.TASK_REMOVE_COMPLETE:
               this.complete(task);
               break;
            case TaskList.TASK_REMOVE_DROP:
               this.drop(task);
         }
         trace("【任务列表打印输出】 进行任务状态更新之后 未接任务数： " + this.taskDic[TASK_LIST_UNACCEPTED].length + "\t已接任务数： " + this.taskDic[TASK_LIST_ACCEPTED].length + "\t已完成任务数： " + this.taskDic[TASK_LIST_COMPLETED].length);
      }
      
      public function get acceptedTaskList() : Array
      {
         return this.taskDic[TaskList.TASK_LIST_ACCEPTED];
      }
      
      public function get completeTaskList() : Array
      {
         return this.taskDic[TaskList.TASK_LIST_COMPLETED];
      }
      
      public function get unAcceptedTaskList() : Array
      {
         return this.taskDic[TASK_LIST_UNACCEPTED];
      }
      
      public function get dailyTaskList() : Array
      {
         return this.taskDic[DAILY_TASK_LIST];
      }
      
      public function getSubtaskList(taskID:int) : Array
      {
         var tempArr:Array = null;
         var len:int = 0;
         var state:int = this.getStateOfSpecifiedTask(taskID);
         if(state == -1)
         {
            return [];
         }
         var result:Array = [];
         var i:int = 0;
         switch(state)
         {
            case 0:
            case 3:
               tempArr = this.taskDic[TASK_LIST_UNACCEPTED];
               break;
            case 1:
               tempArr = this.taskDic[TASK_LIST_UNACCEPTED];
               tempArr = tempArr.concat(this.taskDic[TASK_LIST_ACCEPTED]);
               tempArr = tempArr.concat(this.taskDic[TASK_LIST_COMPLETED]);
               break;
            case 2:
               tempArr = this.taskDic[TASK_LIST_COMPLETED];
         }
         len = int(tempArr.length);
         for(i = 0; i < len; i++)
         {
            if((tempArr[i] as Task).taskID == taskID)
            {
               result.push(tempArr[i]);
            }
         }
         result.sortOn("subtaskID",Array.NUMERIC);
         return result;
      }
      
      private function split(acc:Array, comp:Array) : void
      {
         var task:Task = null;
         if(acc != null)
         {
            acc = acc.filter(this.wildBossFilter);
         }
         if(comp != null)
         {
            comp = comp.filter(this.wildBossFilter);
         }
         var i:int = 0;
         var j:int = 0;
         var alen:int = 0;
         var olen:int = int(this._allTaskObj.length);
         if(acc != null && acc.length > 0)
         {
            alen = int(acc.length);
            for(i = 0; i < alen; i++)
            {
               for(j = 0; j < olen; j++)
               {
                  task = this._allTaskObj[j];
                  if(task.taskID == 4014000 && acc[i].taskID == 4014000)
                  {
                     if(acc[i].params[7].value == 1)
                     {
                        task.currentState = 2;
                        (this.taskDic[TASK_LIST_COMPLETED] as Array).push(task);
                     }
                     else if(acc[i].params[1].value > 0)
                     {
                        task.currentState = 1;
                        (this.taskDic[TASK_LIST_ACCEPTED] as Array).push(task);
                     }
                  }
                  else if(task.subtaskID == acc[i].subtaskID && !this.tasksWithOutChangeStatus(task.subtaskID))
                  {
                     task.currentState = 1;
                     (this.taskDic[TASK_LIST_ACCEPTED] as Array).push(task);
                     break;
                  }
               }
               if(acc[i].subtaskID == 6010009)
               {
                  this.setTaskBitStatus(5,true);
               }
            }
         }
         this._allTaskObj = this._allTaskObj.filter(this.acceptFilter);
         olen = int(this._allTaskObj.length);
         if(comp != null && comp.length > 0)
         {
            alen = int(comp.length);
            for(i = 0; i < alen; i++)
            {
               for(j = 0; j < olen; j++)
               {
                  task = this._allTaskObj[j];
                  if(task.subtaskID == comp[i].subtaskID && !this.tasksWithOutChangeStatus(task.subtaskID) && !task.off)
                  {
                     task.currentState = 2;
                     (this.taskDic[TASK_LIST_COMPLETED] as Array).push(task);
                     if(task.subtaskID == 4006008 && ExternalInterface.available)
                     {
                        ExternalInterface.call("taskStateFunction",-1,-1,-1,0,-1);
                     }
                     break;
                  }
                  if(comp[i].subtaskID >= 8001001 && comp[i].subtaskID <= 8001005)
                  {
                     this._familyTaskCompleteCount = 1;
                  }
               }
               if(comp[i].subtaskID == 6010009)
               {
                  this.setTaskBitStatus(5,false);
               }
            }
         }
         this.taskDic[TASK_LIST_UNACCEPTED] = this._allTaskObj.filter(this.acceptFilter);
         this._allTaskObj = null;
      }
      
      private function hbTaskFilter() : void
      {
      }
      
      private function acceptFilter(item:*, index:int, array:Array) : Boolean
      {
         return (item as Task).currentState == 0 && !(item as Task).off;
      }
      
      private function wildBossFilter(item:*, index:int, arr:Array) : Boolean
      {
         var temp:int = item.taskID / 1000000 >> 0;
         if(temp <= 4 || temp >= 7 && temp <= 9)
         {
            return true;
         }
         return false;
      }
      
      private function complete(task:Task) : void
      {
         var i:int = 0;
         var t:Task = null;
         var tempArr:Array = this.taskDic[TaskList.TASK_LIST_ACCEPTED];
         tempArr.sortOn("subtaskID",Array.NUMERIC);
         for(var j:int = 0; j < tempArr.length; j++)
         {
            if((tempArr[j] as Task).subtaskID == task.subtaskID)
            {
               i = j;
               break;
            }
         }
         var flag:Boolean = false;
         while(i >= 0)
         {
            t = tempArr[i];
            if(t.taskID == task.taskID && !this.tasksWithOutChangeStatus(t.subtaskID))
            {
               tempArr.splice(i,1) as Task;
               t.currentState = 2;
               (this.taskDic[TaskList.TASK_LIST_COMPLETED] as Array).push(t);
            }
            i--;
         }
         if(this.getStateOfSpecifiedTask(task.taskID) == 2)
         {
            PropertyPool.instance.deleteXMLByKey(task.taskID + "");
         }
         if(task.subtaskID == 4006008 && ExternalInterface.available)
         {
            ExternalInterface.call("taskStateFunction",-1,-1,-1,0,-1);
         }
         if(task.subtaskID == 1003003)
         {
            this.releaseFreshManMap();
         }
      }
      
      public function updateFamilyTaskCompleteCount() : void
      {
         this._familyTaskCompleteCount = 1;
      }
      
      private function drop(task:Task) : void
      {
         var tempArr:Array = this.taskDic[TaskList.TASK_LIST_ACCEPTED];
         this.dropID = task.taskID;
         tempArr = tempArr.filter(this.dropFilter);
         this.taskDic[TaskList.TASK_LIST_ACCEPTED] = tempArr;
         this.opUnacceptedTaskList(task,true);
      }
      
      private function dropFilter(item:*, index:int, array:Array) : Boolean
      {
         return (item as Task).taskID == this.dropID ? false : true;
      }
      
      private function update(task:Task) : void
      {
         var tempArr:Array = this.taskDic[TaskList.TASK_LIST_ACCEPTED];
         var i:int = 0;
         var len:int = int(tempArr.length);
         var flag:Boolean = false;
         if(!this.tasksWithOutChangeStatus(task.subtaskID))
         {
            task.currentState = 1;
         }
         for(i = 0; i < len; i++)
         {
            if((tempArr[i] as Task).subtaskID == task.subtaskID)
            {
               tempArr[i] = task;
               flag = true;
            }
         }
         if(!flag)
         {
            tempArr.push(task);
            this.opUnacceptedTaskList(task);
         }
      }
      
      private function opUnacceptedTaskList(task:Task, opFlag:Boolean = false) : void
      {
         var tempArr:Array = this.taskDic[TASK_LIST_UNACCEPTED];
         if(opFlag)
         {
            tempArr.push(task);
            tempArr.sortOn("subtaskID",Array.NUMERIC);
            return;
         }
         var i:int = 0;
         var len:int = int(tempArr.length);
         for(i = 0; i < len; i++)
         {
            if(tempArr[i].subtaskID == task.subtaskID)
            {
               tempArr.splice(i,1);
               break;
            }
         }
      }
      
      public function getStateOfSpecifiedTask(taskId:int) : int
      {
         var xmlList:XML = XMLLocator.getInstance().getTaskInfo(taskId);
         if(xmlList == null)
         {
            return -1;
         }
         if(this.acceptedTaskList.length == 0 && this.completeTaskList.length == 0 && this.unAcceptedTaskList.length == 0)
         {
            trace("######【TaskList】####### 紧急bug....紧急bug.....赶紧通知服务器.....又没有发任务列表的包回来...");
            return 0;
         }
         var last:int = int(xmlList.children().length());
         if(this.isInList(int((xmlList.children()[0] as XML).@id),this.taskDic[TASK_LIST_UNACCEPTED]))
         {
            if(!this.isTaskCanAccept(taskId))
            {
               return 3;
            }
            return 0;
         }
         if(this.isInList(int((xmlList.children()[last - 1] as XML).@id),this.taskDic[TASK_LIST_COMPLETED]))
         {
            return 2;
         }
         return 1;
      }
      
      public function isTaskCanAccept(taskid:int) : Boolean
      {
         return TaskInfoXMLParser.instance.getTaskCanAcceptOrNot(taskid);
      }
      
      public function getStateOfSpecifiedSubtask(subtaskID:int) : int
      {
         if(this.isInList(subtaskID,this.taskDic[TASK_LIST_UNACCEPTED]))
         {
            return 0;
         }
         if(this.isInList(subtaskID,this.taskDic[TASK_LIST_ACCEPTED]))
         {
            return 1;
         }
         if(this.isInList(subtaskID,this.taskDic[TASK_LIST_COMPLETED]))
         {
            return 2;
         }
         return 0;
      }
      
      private function isInList(subtaskID:int, list:Array) : Boolean
      {
         var task:Task = null;
         var i:int = 0;
         var len:int = int(list.length);
         for(i = 0; i < len; i++)
         {
            task = list[i];
            if(task.subtaskID == subtaskID)
            {
               return true;
            }
         }
         return false;
      }
      
      private function contentFilter(id:int, tid:int) : int
      {
         var result:int = 0;
         var arr:Array = null;
         tid = (tid / 1000 >> 0) % 100;
         switch(tid)
         {
            case 1:
               arr = [1004,1006,1005,1008,1009,1003,1011,1007,1010];
               result = arr.indexOf(id) + 1;
               break;
            case 3:
               arr = [9003,6004,7001];
               result = arr.indexOf(id) + 1;
               break;
            case 7:
               arr = [6,7,2];
               result = arr.indexOf(id) + 1;
               break;
            case 10:
               result = id + 1;
               break;
            case 11:
               result = id + 1;
               break;
            case 12:
               arr = [37,229,241,235,247,280,1049,1093,1096];
               result = arr.indexOf(id) + 1;
         }
         return result;
      }
      
      public function updateDailyTask(taskID:int, status:int) : void
      {
         var dailytask:DailyTaskData = null;
         var cond:Object = null;
         var tempArr:Array = this.taskDic[DAILY_TASK_LIST];
         var i:int = 0;
         var len:int = int(tempArr.length);
         for(i = 0; i < len; i++)
         {
            dailytask = tempArr[i];
            if(dailytask.taskid == taskID)
            {
               dailytask.status = status;
               if(status == 1 && dailytask.condition != null && dailytask.condition.length > 0)
               {
                  for each(cond in dailytask.condition)
                  {
                     cond.state = false;
                  }
               }
               break;
            }
         }
         TaskUtils.getInstance().dispatchEvent(TaskEvent.OP_UPDATE_DAILY_TASK);
      }
      
      public function statusInDailyTaskList(taskid:int) : int
      {
         var dailytask:DailyTaskData = null;
         var tempArr:Array = this.taskDic[DAILY_TASK_LIST];
         var i:int = 0;
         var len:int = int(tempArr.length);
         for(i = 0; i < len; i++)
         {
            dailytask = tempArr[i];
            if(dailytask.taskid == taskid)
            {
               return dailytask.status;
            }
         }
         return 0;
      }
      
      public function makeTaskComplete(taskid:int, subtaskid:int) : void
      {
         var task:Task = null;
         var step:int = 0;
         var t_state:int = this.getStateOfSpecifiedTask(taskid);
         if(t_state == 0 || t_state == 1 || t_state == 3)
         {
            if(t_state == 1)
            {
               task = this.getSpecifiedTask(TaskList.TASK_LIST_ACCEPTED,subtaskid);
            }
            else
            {
               step = 0;
               for(step = taskid + 1; step <= subtaskid; step++)
               {
                  task = this.getSpecifiedTask(TaskList.TASK_LIST_UNACCEPTED,subtaskid);
                  this.update(task);
               }
            }
            this.complete(task);
         }
      }
      
      public function tasksWithOutChangeStatus(subtaskid:int) : Boolean
      {
         if(subtaskid == 7014001)
         {
            return true;
         }
         return false;
      }
      
      public function dailyTaskCompleted(taskID:int) : Boolean
      {
         return false;
      }
      
      public function getUnfinishedDailyTaskNum() : int
      {
         var dailytask:DailyTaskData = null;
         var arr:Array = this.taskDic[DAILY_TASK_LIST];
         var unfinishedDailyCount:int = 0;
         for each(dailytask in arr)
         {
            if(dailytask.status != 3 && dailytask.status != 4)
            {
               unfinishedDailyCount++;
            }
         }
         return unfinishedDailyCount;
      }
      
      private function specialDataFilter(params:Object) : void
      {
         var arr:Array = null;
         var tmpArr:Array = null;
         var obj:Object = null;
         GameData.instance.disableUIIcon = true;
         if(Boolean(params.hasOwnProperty("acceptedTaskList")) && params.acceptedTaskList != null)
         {
            arr = params.acceptedTaskList;
            for each(obj in arr)
            {
               if(obj.hasOwnProperty("params"))
               {
                  if(obj.subtaskID == 9000000)
                  {
                     this.opSpecialDataFilter(obj.params,"param",1,1);
                  }
                  else if(obj.taskID == 4000000)
                  {
                     this.opSpecialDataFilter(obj.params,"param",4000000,2);
                  }
                  else if(obj.subtaskID == 6010055)
                  {
                     GameData.instance.disableUIIcon = false;
                  }
               }
            }
         }
      }
      
      private function opSpecialDataFilter(arr:Array, type:String, tid:int, opCode:int) : void
      {
         var obj:Object = null;
         if(arr == null || arr.length <= 0)
         {
            return;
         }
         for each(obj in arr)
         {
            if(Boolean(obj.hasOwnProperty(type)) && obj[type] == tid)
            {
               if(opCode == 1)
               {
                  GameData.instance.playerData.bigBattleTimes = 20 - obj.value <= 0 ? 0 : int(20 - obj.value);
                  if(ExternalInterface.available)
                  {
                     ExternalInterface.call("taskStateFunction",-1,-1,-1,-1,GameData.instance.playerData.bigBattleTimes);
                  }
               }
               else if(opCode == 2)
               {
               }
            }
            if(obj.param == 23)
            {
               if(obj.value == 4040001)
               {
                  GameData.instance.playerData.dailyTaskInGameHall = 1;
               }
               else if(obj.value == 4040002 || obj.value == 4040004)
               {
                  GameData.instance.playerData.dailyTaskInGameHall = 2;
               }
               else if(obj.value == 4040003)
               {
                  GameData.instance.playerData.dailyTaskInGameHall = 3;
               }
            }
         }
      }
      
      public function getAcceptedTaskList() : Array
      {
         var xml:XML = null;
         var tmpTask:Task = null;
         var xmllist:XMLList = XMLLocator.getInstance().taskInfo.child("task");
         var i:int = 0;
         var len:int = int(xmllist.length());
         var tmpID:int = 0;
         var result:Array = [];
         for(i = 0; i < len; i++)
         {
            xml = xmllist[i] as XML;
            tmpID = int(xml.@id);
            if(this.getStateOfSpecifiedTask(tmpID) == 1)
            {
               tmpTask = this.getSpecifiedAcceptTask(tmpID);
               if(tmpTask == null)
               {
                  tmpTask = this.getSpecifiedTask(TASK_LIST_COMPLETED,tmpID + 1);
                  if(tmpTask == null)
                  {
                     continue;
                  }
               }
               result.push(tmpTask);
            }
         }
         return result;
      }
      
      public function setTaskBitStatus(bit:int, flag:Boolean) : void
      {
         if(flag)
         {
            this._taskBitStatus |= 1 << bit - 1;
         }
         else
         {
            this._taskBitStatus &= ~(1 << bit - 1);
         }
      }
      
      public function getTaskBitStatus(bit:int) : Boolean
      {
         return (this._taskBitStatus & 1 << bit - 1) > 0 ? true : false;
      }
      
      public function get familyTaskCompleteCount() : int
      {
         return this._familyTaskCompleteCount;
      }
      
      public function set hbTaskCompleteCount(value:int) : void
      {
         this._hbTaskCompleteCount = value;
      }
      
      public function get hbTaskCompleteCount() : int
      {
         return this._hbTaskCompleteCount;
      }
      
      public function functionListOnCurrentNPC(npcid:int) : Array
      {
         var arr:Array = null;
         if(this._functionList != null)
         {
            arr = this._functionList[npcid];
         }
         return this.resetBeUsedStatus(arr);
      }
      
      public function functionIndexListOnCurrentNPC(npcid:int) : Array
      {
         var i:int = 0;
         var len:int = 0;
         var result:Array = null;
         var arr:Array = this.functionListOnCurrentNPC(npcid);
         if(arr != null && arr.length > 0)
         {
            i = 0;
            len = int(arr.length);
            result = [];
            for(i = 0; i < len; i++)
            {
               result.push((arr[i] as TasklistItemVo).index);
            }
            return result;
         }
         return null;
      }
      
      private function resetBeUsedStatus(arr:Array) : Array
      {
         var vo:TasklistItemVo = null;
         for each(vo in arr)
         {
            vo.beUsed = false;
         }
         return arr;
      }
      
      private function loadFunctionList() : void
      {
         PropertyPool.instance.getXML("config/","functionlist",this.loadFunctionListBack);
      }
      
      private function loadFunctionListBack(xml:XML) : void
      {
         if(xml == null)
         {
            trace("功能列表加载失败！！~~~~");
            return;
         }
         this._functionList = new Dictionary(true);
         var i:int = 0;
         var len:int = int(xml.child("node").length());
         for(i = 0; i < len; i++)
         {
            this.parseFunctionXMLNode(xml.child("node")[i]);
         }
      }
      
      private function parseFunctionXMLNode(xml:XML) : void
      {
         if(xml == null)
         {
            return;
         }
         var npcid:int = int(xml.@npcid);
         var functionItem:TasklistItemVo = new TasklistItemVo();
         functionItem.unAcceptTaskID = int(xml.unaccepttask);
         functionItem.acceptTaskID = int(xml.accepttask);
         functionItem.completeTaskID = int(xml.completetask);
         functionItem.bitValue = int(xml.bitindex);
         functionItem.index = int(xml.@id);
         functionItem.type = int(xml.@type);
         functionItem.npcid = int(xml.@npcid);
         functionItem.code = int(xml.code);
         functionItem.name = xml.name.toString();
         functionItem.url = xml.url.toString();
         functionItem.xCoord = Number(xml.xCoord);
         functionItem.yCoord = Number(xml.yCoord);
         functionItem.channel = xml.channel.toString();
         functionItem.event = xml.event.toString();
         functionItem.php = xml.php.toString();
         functionItem.time = xml.time.toString();
         functionItem.isOnline = int(xml.isonline);
         if(int(xml.msgcode) > 0)
         {
            functionItem.msg = xml.msgcode;
            functionItem.head = int(xml.head);
            functionItem.msgBody = xml.body.toString();
         }
         if(this._functionList[npcid] == null)
         {
            this._functionList[npcid] = [];
         }
         (this._functionList[npcid] as Array).push(functionItem);
      }
      
      public function checkUrlAndFreshManTask(url:String, index:int = 1) : void
      {
         var valueList:Array = null;
         var i:int = 0;
         var len:int = 0;
         var obj:Object = null;
         if(this._freshManTaskFlag != 0)
         {
            valueList = this._freshManMap[this._freshManTaskFlag];
            if(valueList != null && valueList.length > 0)
            {
               i = 0;
               len = int(valueList.length);
               for(i = 0; i < len; i++)
               {
                  obj = valueList[i];
                  if(url.indexOf(obj.src) != -1)
                  {
                     index--;
                     if(index <= 0)
                     {
                        SpecialAreaManager.instance.removeNewHandMask();
                        if(obj.src == "assets/material/shop.swf")
                        {
                           return;
                        }
                        SpecialAreaManager.instance.loadNewHandMask(obj.target);
                        return;
                     }
                  }
               }
            }
         }
      }
      
      public function set freshManTaskFlag(value:int) : void
      {
         this._freshManTaskFlag = value;
         if(value == 0)
         {
            return;
         }
         this.initFreshManMap();
      }
      
      public function get freshManTaskFlag() : int
      {
         return this._freshManTaskFlag;
      }
      
      private function initFreshManMap() : void
      {
         if(this._freshManMap == null)
         {
            this._freshManMap = new Dictionary(true);
            this._freshManMap[102] = [{
               "src":"assets/map/BigMapView.swf",
               "target":"freshmanmask_map_10"
            },{
               "src":"assets/map/country/AreaMapView10.swf",
               "target":"freshmanmask_map_1005"
            }];
            this._freshManMap[105] = [{
               "src":"assets/material/shop.swf",
               "target":"null"
            }];
            this._freshManMap[109] = [{
               "src":"assets/map/BigMapView.swf",
               "target":"freshmanmask_map_20"
            },{
               "src":"assets/map/country/AreaMapView20.swf",
               "target":"freshmanmask_map_2005"
            }];
            this._freshManMap[201] = [{
               "src":"assets/material/monsterlist.swf",
               "target":"freshmanmask_pet_1"
            }];
            this._freshManMap[301] = [{
               "src":"assets/material/trumpInfo.swf",
               "target":"freshmanmask_beibei_1"
            },{
               "src":"assets/material/disexp.swf",
               "target":"freshmanmask_beibei_2"
            },{
               "src":"assets/material/disexp.swf",
               "target":"freshmanmask_beibei_3"
            }];
            this._freshManMap[400201] = [{
               "src":"assets/material/shop.swf",
               "target":"null"
            }];
            this._freshManMap[500301] = [{
               "src":"assets/material/trumpInfo.swf",
               "target":"freshmanmask_beibei_1"
            },{
               "src":"assets/material/disexp.swf",
               "target":"freshmanmask_beibei_2"
            },{
               "src":"assets/material/disexp.swf",
               "target":"freshmanmask_beibei_3"
            }];
         }
      }
      
      private function releaseFreshManMap() : void
      {
         var key:String = null;
         if(this._freshManMap != null)
         {
            for each(key in this._freshManMap)
            {
               this._freshManMap[key] = null;
               delete this._freshManMap[key];
            }
            this._freshManMap = null;
         }
         this._freshManTaskFlag = 0;
      }
      
      public function isSpecialFreshManFlag($specified:Boolean = false) : Boolean
      {
         if(this._freshManTaskFlag > 0)
         {
            if(!$specified)
            {
               if(this._freshManTaskFlag == 107 || this._freshManTaskFlag == 202 || this._freshManTaskFlag == 302)
               {
                  return false;
               }
               return true;
            }
            if(this._freshManTaskFlag == 101 || this._freshManTaskFlag == 104)
            {
               return true;
            }
         }
         return false;
      }
      
      public function addFreshManTaskMask() : void
      {
         SpecialAreaManager.instance.removeNewHandMask();
         var freshmanMaskName:String = "";
         switch(this._freshManTaskFlag)
         {
            case 102:
            case 109:
               freshmanMaskName = "freshmanmask_map";
               break;
            case 105:
               freshmanMaskName = "freshmanmask_shop";
               break;
            case 201:
               freshmanMaskName = "freshmanmask_pet";
               break;
            case 301:
               freshmanMaskName = "freshmanmask_beibei";
               break;
            case 400201:
               freshmanMaskName = "freshmanmask_shop";
               break;
            case 500301:
               freshmanMaskName = "freshmanmask_beibei";
         }
         if(freshmanMaskName != "")
         {
            SpecialAreaManager.instance.loadNewHandMask(freshmanMaskName);
         }
      }
      
      public function sendTalkBack() : void
      {
         if(this.isSpecialFreshManFlag())
         {
            if(this._freshManTaskFlag == 105)
            {
               ApplicationFacade.getInstance().dispatch(EventConst.MASTERISOUTSPECIALAREA,{
                  "npcid":13002,
                  "dialogID":100300105,
                  "freshman":1
               });
            }
            else if(this._freshManTaskFlag == 201)
            {
               ApplicationFacade.getInstance().dispatch(EventConst.MASTERISOUTSPECIALAREA,{
                  "npcid":21515,
                  "dialogID":100300201,
                  "freshman":1
               });
            }
            else if(this._freshManTaskFlag == 301)
            {
               ApplicationFacade.getInstance().dispatch(EventConst.MASTERISOUTSPECIALAREA,{
                  "npcid":19038,
                  "dialogID":100300301,
                  "freshman":1
               });
            }
            else if(this._freshManTaskFlag == 400201)
            {
               this.freshManTaskFlag = 0;
               ApplicationFacade.getInstance().dispatch(EventConst.MASTERISOUTSPECIALAREA,{
                  "npcid":13001,
                  "dialogID":100400201,
                  "freshman":1
               });
            }
            else if(this._freshManTaskFlag == 500301)
            {
               this.freshManTaskFlag = 0;
               ApplicationFacade.getInstance().dispatch(EventConst.MASTERISOUTSPECIALAREA,{
                  "npcid":12005,
                  "dialogID":100500301,
                  "freshman":1
               });
            }
            SpecialAreaManager.instance.removeNewHandMask();
         }
      }
      
      public function setOverlordAt($value:*, $index:int) : Boolean
      {
         if(this._overlordList == null)
         {
            this._overlordList = new Array(3);
         }
         this._overlordList[$index - 1] = $value;
         return false;
      }
      
      public function getOverlordAt($index:int) : *
      {
         if(this._overlordList == null)
         {
            return null;
         }
         return this._overlordList[$index - 1];
      }
      
      public function setChapterData($value:Array, $index:int) : void
      {
         if(this._chapterList == null)
         {
            this._chapterList = new Array(3);
         }
         this._chapterList[$index - 1] = [];
         var i:int = 0;
         var len:int = int($value.length);
         for(i = 0; i < len; i++)
         {
            this._chapterList[$index - 1].push({
               "hasPassed":$value[i].hasPassed,
               "hadPassed":$value[i].hadPassed
            });
         }
         this._chapterList[$index - 1] = $value;
      }
      
      public function getChapterData($index:int) : *
      {
         if(this._chapterList == null)
         {
            return null;
         }
         return this._chapterList[$index - 1];
      }
   }
}

