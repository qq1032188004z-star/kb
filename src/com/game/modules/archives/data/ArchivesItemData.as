package com.game.modules.archives.data
{
   public class ArchivesItemData
   {
      
      public var currentState:int;
      
      public var taskID:int;
      
      public var themeID:int;
      
      public var taskName:String = "";
      
      public var taskDiff:String = "";
      
      public var taskStatus:int = 0;
      
      public var isNew:int;
      
      public var taskType:int;
      
      public var taskTime:int;
      
      public var childList:Array;
      
      public function ArchivesItemData()
      {
         super();
      }
   }
}

