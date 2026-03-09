package com.game.modules.archives.data
{
   import com.game.modules.control.task.TaskList;
   import com.game.modules.control.task.util.Task;
   import com.game.modules.control.task.util.TaskInfoXMLParser;
   import com.publiccomponent.loading.XMLLocator;
   
   public class ArchivesDataAdapter
   {
      
      public function ArchivesDataAdapter()
      {
         super();
      }
      
      public static function getSubtaskAccountByTaskID(taskid:int) : int
      {
         var xml:XML = XMLLocator.getInstance().getTaskInfo(taskid);
         if(xml == null)
         {
            return 0;
         }
         return xml.child("subtask").length();
      }
      
      public static function getStatusByTaskID(taskid:int) : int
      {
         return TaskList.getInstance().getStateOfSpecifiedTask(taskid);
      }
      
      public static function getStatusBySubtaskID(subtaskid:int) : int
      {
         return TaskList.getInstance().getStateOfSpecifiedSubtask(subtaskid);
      }
      
      public static function getTypeByID(id:int) : int
      {
         return id / 1000000 >> 0;
      }
      
      public static function getIDByType(type:int) : int
      {
         return type * 1000000;
      }
      
      public static function getKey(id:int) : int
      {
         return (id / 1000000 >> 0) * 1000000;
      }
      
      public static function taskIDNormalize(taskID:int) : int
      {
         var tmp:int = 0;
         if(taskID < ArchivesConst.CLASSIFY_TYPE_COUNT)
         {
            tmp = taskID;
         }
         else
         {
            tmp = (taskID / 1000 >> 0) * 1000;
         }
         return tmp;
      }
      
      public static function parseObjectToTaskClipData(value:Object) : void
      {
         var obj:Object = null;
         if(value == null)
         {
            return;
         }
         SortedTaskList.taskClipData.release();
         SortedTaskList.taskClipData.taskID = value.taskId;
         SortedTaskList.taskClipData.flag = value.flag;
         SortedTaskList.taskClipData.sid = ArchivesDataAdapter.taskIDNormalize(value.taskId);
         if(value.hasOwnProperty("account"))
         {
            SortedTaskList.taskClipData.paramAcount = value.account;
         }
         else
         {
            SortedTaskList.taskClipData.paramAcount = 0;
         }
         if(Boolean(value.hasOwnProperty("list")) && value.list != null && value.list.length > 0)
         {
            for each(obj in value.list)
            {
               SortedTaskList.taskClipData.setValueByKey(obj.key,obj.value);
            }
         }
         else
         {
            SortedTaskList.taskClipData.releaseList();
         }
      }
      
      public static function sort(list:Array) : Array
      {
         var value:ArchivesItemData = null;
         var i:int = 0;
         var len:int = int(list.length);
         var completed:Array = [];
         var accepted:Array = [];
         var locked:Array = [];
         var acceptable:Array = [];
         for(i = 0; i < len; i++)
         {
            value = list[i];
            if(value.taskID < ArchivesConst.CLASSIFY_TYPE_COUNT)
            {
               return list;
            }
            if(value.taskStatus == 2)
            {
               completed.push(value);
            }
            else if(value.taskStatus == 1)
            {
               accepted.push(value);
            }
            else if(value.taskStatus == 3)
            {
               locked.push(value);
            }
            else
            {
               acceptable.push(value);
            }
         }
         completed.sortOn("taskID",Array.NUMERIC);
         accepted = insertDataIntoList(acceptable,accepted);
         accepted = insertDataIntoList(locked,accepted);
         return insertDataIntoList(completed,accepted);
      }
      
      public static function insertDataIntoList(sourceList:Array, targetList:Array) : Array
      {
         var i:int = 0;
         var len:int = int(sourceList.length);
         for(i = 0; i < len; i++)
         {
            targetList.push(sourceList[i]);
         }
         return targetList;
      }
      
      public static function isSpecifiedTaskCanAccept(taskID:int) : Boolean
      {
         return TaskInfoXMLParser.instance.getTaskCanAcceptOrNot(taskID);
      }
      
      public static function getPrefixTask(taskID:int) : ArchivesItemData
      {
         var task:Task = TaskInfoXMLParser.instance.getPrefixTask(taskID);
         if(task == null)
         {
            return null;
         }
         var item:ArchivesItemData = new ArchivesItemData();
         item.taskID = task.taskID;
         item.taskName = task.taskName;
         item.taskDiff = task.taskDifficult;
         item.taskStatus = getStatusByTaskID(item.taskID);
         return item;
      }
      
      public static function getBooleanByInt(type:int) : Boolean
      {
         return type > 0 ? true : false;
      }
   }
}

