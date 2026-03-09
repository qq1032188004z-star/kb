package com.core.observer
{
   import flash.events.Event;
   
   public class MessageEvent extends Event
   {
      
      public var body:Object;
      
      public var callBack:Function;
      
      public var name:String;
      
      public function MessageEvent(type:String, body:Object = null, callback:Function = null, name:String = "")
      {
         super(type);
         this.body = body;
         this.name = name;
         this.callBack = callback;
      }
   }
}

