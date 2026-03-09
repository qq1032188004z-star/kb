package com.core.observer
{
   public class Dispatcher
   {
      
      private static var _instance:Dispatcher;
      
      public function Dispatcher()
      {
         super();
      }
      
      public static function get instance() : Dispatcher
      {
         if(_instance == null)
         {
            _instance = new Dispatcher();
         }
         return _instance;
      }
      
      public function dispatch(type:String, body:Object = null, callback:Function = null, name:String = "") : void
      {
         Observer.getInstance().dispatchEvent(new MessageEvent(type,body,callback,name));
      }
      
      public function dispatchToTargets(type:String, body:Object = null, callback:Function = null, name:String = "", targets:Array = null) : void
      {
         var msgEvt:MessageEvent = null;
         var target:Object = null;
         var events:Array = null;
         var i:int = 0;
         if(Boolean(targets))
         {
            msgEvt = new MessageEvent(type,body,callback,name);
            for each(target in targets)
            {
               events = target.listEvents();
               i = 0;
               while(i < events.length)
               {
                  if(events[i][0].toString() == type)
                  {
                     events[i][1].apply(null,msgEvt);
                  }
                  i++;
               }
            }
         }
         else
         {
            this.dispatch(type,body,callback,name);
         }
      }
   }
}

