package com.game.modules.archives.data
{
   import com.game.modules.control.task.util.TaskInfoXMLParser;
   import flash.utils.Dictionary;
   
   public class TaskClipData
   {
      
      public var taskID:int;
      
      public var sid:int;
      
      public var taskDiff:String = "";
      
      public var targetScene:int;
      
      public var paramAcount:int;
      
      public var paramList:Dictionary;
      
      public var flag:Boolean = false;
      
      public function TaskClipData()
      {
         super();
      }
      
      public function getCoin(subtaskID:int) : int
      {
         return TaskInfoXMLParser.instance.parseAwardCoin(this.sid,subtaskID);
      }
      
      public function getExp(subtaskID:int) : int
      {
         return TaskInfoXMLParser.instance.parseAwardExp(this.sid,subtaskID);
      }
      
      public function getCultive(subtaskID:int) : int
      {
         return TaskInfoXMLParser.instance.parseAwardCultive(this.sid,subtaskID);
      }
      
      public function getTargetScene(subtaskID:int) : int
      {
         this.targetScene = TaskInfoXMLParser.instance.parseTargetScene(this.sid,subtaskID);
         return this.targetScene;
      }
      
      public function getValueByKey(key:int) : int
      {
         var result:int = 0;
         if(Boolean(this.paramList) && this.paramList[key] != null)
         {
            result = int(this.paramList[key]);
         }
         trace("result,",result);
         return result;
      }
      
      public function setValueByKey(key:int, value:int) : void
      {
         if(this.paramList == null)
         {
            this.paramList = new Dictionary(true);
         }
         this.paramList[key] = value;
      }
      
      public function release() : void
      {
         this.taskID = 0;
         this.sid = 0;
         this.paramAcount = 0;
         this.releaseList();
      }
      
      public function releaseList() : void
      {
         var key:String = null;
         if(this.paramList != null)
         {
            for(key in this.paramList)
            {
               this.paramList[key] = null;
               delete this.paramList[key];
            }
         }
         this.paramList = null;
      }
   }
}

