package org.green.server.util
{
   import flash.events.Event;
   
   public class TimeoutEvent extends Event
   {
      
      public static const TIMEOUT:String = "timeoutaa";
      
      public var seq:uint;
      
      public var context:Object;
      
      public function TimeoutEvent(type:String)
      {
         super(type,false,false);
      }
   }
}

