package com.game.dohko.event
{
   import flash.events.EventDispatcher;
   
   public class ActiveDispatcher extends EventDispatcher
   {
      
      private static var _instance:ActiveDispatcher;
      
      public function ActiveDispatcher(c:PrivateClass)
      {
         super();
         if(c == null)
         {
            throw new Error("请通过.instance获取实例");
         }
      }
      
      public static function get instance() : ActiveDispatcher
      {
         if(_instance == null)
         {
            _instance = new ActiveDispatcher(new PrivateClass());
         }
         return _instance;
      }
      
      public static function destroyStatic() : void
      {
         _instance = null;
      }
   }
}

class PrivateClass
{
   
   public function PrivateClass()
   {
      super();
   }
}
