package com.game.modules.view.chat
{
   import flash.events.Event;
   
   public class ChatEvent extends Event
   {
      
      public static const PKEVENT:String = "pkevent";
      
      public static const REQUEST_UNFAMILY_CHAT:String = "request_unfamily_chat";
      
      private var data:Object;
      
      public function ChatEvent(type:String, _data:Object = null)
      {
         super(type);
         this.data = _data;
      }
      
      public function get param() : Object
      {
         return this.data;
      }
   }
}

