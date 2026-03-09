package com.game.modules.control.task.util
{
   public class Task
   {
      
      public var dialogID:int;
      
      public var subtaskID:int;
      
      public var taskID:int;
      
      public var taskName:String;
      
      public var condition:Array;
      
      public var state:Boolean = false;
      
      public var battle:Object;
      
      public var flash:Array;
      
      public var targetScene:int;
      
      public var ai:Array;
      
      public var otherpopup:Array;
      
      public var describe:Array;
      
      public var currentState:int;
      
      public var taskDifficult:String;
      
      public var off:Boolean = false;
      
      public var argument:Array;
      
      public function Task()
      {
         super();
      }
   }
}

