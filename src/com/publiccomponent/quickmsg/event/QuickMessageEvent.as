package com.publiccomponent.quickmsg.event
{
   import flash.events.Event;
   
   public class QuickMessageEvent extends Event
   {
      
      public var body:Object;
      
      public var callBack:Function;
      
      public var name:String;
      
      public function QuickMessageEvent(type:String, body:Object = null, callback:Function = null, name:String = "")
      {
         super(type);
         this.body = body;
         this.name = name;
         this.callBack = callback;
      }
   }
}

