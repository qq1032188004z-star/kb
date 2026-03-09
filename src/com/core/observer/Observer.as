package com.core.observer
{
   import flash.events.EventDispatcher;
   
   public class Observer extends EventDispatcher
   {
      
      private static var instance:Observer;
      
      protected const SINGLETON_MSG:String = "Observer单例类已经被实例化!";
      
      public function Observer()
      {
         super();
         if(Boolean(instance))
         {
            throw Error(this.SINGLETON_MSG);
         }
      }
      
      public static function getInstance() : Observer
      {
         if(instance == null)
         {
            instance = new Observer();
         }
         return instance;
      }
   }
}

