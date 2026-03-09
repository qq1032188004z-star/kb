package com.game.modules.control.task.util
{
   import com.game.modules.control.task.TaskEvent;
   import flash.events.EventDispatcher;
   
   public class TaskUtils
   {
      
      private static var instance:TaskUtils;
      
      private var eventDispatcher:EventDispatcher;
      
      public function TaskUtils()
      {
         super();
         if(instance != null)
         {
            throw new Error("任务工具类,单例类,只能实例化一次");
         }
         this.eventDispatcher = new EventDispatcher();
      }
      
      public static function getInstance() : TaskUtils
      {
         if(instance == null)
         {
            instance = new TaskUtils();
         }
         return instance;
      }
      
      public function dispatchEvent(type:String, data:* = null) : void
      {
         this.eventDispatcher.dispatchEvent(new TaskEvent(type,data));
      }
      
      public function addEventListener(type:String, callBack:Function) : void
      {
         this.eventDispatcher.addEventListener(type,callBack,false,0,true);
      }
      
      public function hasEventListener(type:String) : Boolean
      {
         return this.eventDispatcher.hasEventListener(type);
      }
      
      public function removeEventListener(type:String, callback:Function) : void
      {
         this.eventDispatcher.removeEventListener(type,callback);
      }
   }
}

