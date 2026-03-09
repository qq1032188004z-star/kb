package com.game.modules.archives.data.hbtask
{
   import com.game.modules.archives.data.ArchivesDataAdapter;
   import com.game.modules.archives.data.SortedTaskList;
   import com.game.modules.control.task.TaskList;
   import com.game.modules.control.task.util.Task;
   import com.game.util.PropertyPool;
   
   public class HBDataBase
   {
      
      private static var instance:HBDataBase;
      
      private var callback:Function;
      
      private var xml:XML;
      
      private var _taskInfo:HBVO;
      
      private var awardContentList:Array;
      
      public function HBDataBase()
      {
         super();
      }
      
      public static function getInstance() : HBDataBase
      {
         if(instance == null)
         {
            instance = new HBDataBase();
         }
         return instance;
      }
      
      public static function disport() : void
      {
         if(instance == null)
         {
            return;
         }
         instance.callback = null;
         instance.xml = null;
         instance._taskInfo = null;
         instance.awardContentList = null;
         instance = null;
      }
      
      public function loadProperty(back:Function) : void
      {
         this.callback = back;
         PropertyPool.instance.getXML("assets/hbtask/","hbconfig",this.onLoadComplete);
      }
      
      private function onLoadComplete(... rest) : void
      {
         this.xml = rest[0] as XML;
         this.awardContentList = [];
         this.parseAwardContent();
         if(this.callback != null)
         {
            this.callback.apply(null,null);
         }
         this.callback = null;
      }
      
      private function parseAwardContent() : void
      {
         var subxml:XML = null;
         var award:HBAwardVO = null;
         if(this.xml == null)
         {
            return;
         }
         var tmpxml:XML = this.xml.child("awards")[0] as XML;
         var i:int = 0;
         var len:int = int(tmpxml.child("award").length());
         for(i = 0; i < len; i++)
         {
            subxml = tmpxml.child("award")[i] as XML;
            if(subxml != null)
            {
               award = new HBAwardVO();
               award.coin = int(subxml.coin);
               award.exp = int(subxml.exp);
               award.cultive = int(subxml.cultive);
               award.cultiveType = int(subxml.cultive.@id);
               award.kbCoin = int(subxml.kbcoin);
               award.kbMoney = int(subxml.kbmoney);
               award.goodID = int(subxml.good.@id);
               award.goodNum = int(subxml.good.@num);
               award.serialize();
               this.awardContentList.push(award);
            }
         }
      }
      
      public function get taskInfo() : HBVO
      {
         return this._taskInfo;
      }
      
      public function setTaskInfo() : void
      {
         var tmpTask:Task = null;
         this._taskInfo = new HBVO();
         if(SortedTaskList.taskClipData.paramList == null)
         {
            this._taskInfo.isAccepted = false;
            return;
         }
         var tmpStatus:Boolean = false;
         this._taskInfo.acceptCount = SortedTaskList.taskClipData.getValueByKey(1);
         this._taskInfo.completeCount = SortedTaskList.taskClipData.getValueByKey(2);
         this._taskInfo.difficultLevel = SortedTaskList.taskClipData.getValueByKey(3);
         this._taskInfo.taskIndex = SortedTaskList.taskClipData.getValueByKey(4);
         this._taskInfo.awardLevel = SortedTaskList.taskClipData.getValueByKey(5);
         this._taskInfo.progress = SortedTaskList.taskClipData.getValueByKey(6);
         if(SortedTaskList.taskClipData.getValueByKey(7) == 1)
         {
            tmpTask = TaskList.getInstance().getSpecifiedAcceptTask(4014000);
            if(tmpTask != null)
            {
               TaskList.getInstance().updateTask(tmpTask,TaskList.TASK_REMOVE_COMPLETE);
            }
         }
         tmpStatus = ArchivesDataAdapter.getBooleanByInt(SortedTaskList.taskClipData.getValueByKey(7));
         this._taskInfo.isAccepted = ArchivesDataAdapter.getBooleanByInt(SortedTaskList.taskClipData.getValueByKey(8));
         if(tmpStatus)
         {
            this._taskInfo.isAccepted = false;
         }
         this.getTaskInfoFromXML();
      }
      
      public function updateTaskInfo(taskDif:int, taskIndex:int, awardLevel:int) : void
      {
         this._taskInfo.difficultLevel = taskDif;
         this._taskInfo.taskIndex = taskIndex;
         this._taskInfo.awardLevel = awardLevel;
         this.getTaskInfoFromXML();
      }
      
      private function getTaskInfoFromXML() : void
      {
         var tmpxml:XML = null;
         var subxml:XML = null;
         tmpxml = this.xml.child("items").(@id == this._taskInfo.difficultLevel)[0] as XML;
         subxml = tmpxml.child("item").(@id == this._taskInfo.taskIndex)[0] as XML;
         this._taskInfo.taskType = int(subxml.type);
         this._taskInfo.targetID = int(subxml.tid);
         this._taskInfo.targetNum = int(subxml.tnum);
         this._taskInfo.targetSceneID = int(subxml.tscene);
         this._taskInfo.deserialize();
         this._taskInfo.content += subxml.desc.toString();
      }
      
      public function getAwardInfo() : HBAwardVO
      {
         return this.awardContentList[this._taskInfo.awardLevel - 1];
      }
   }
}

