package com.channel
{
   import flash.events.Event;
   
   public class ChannelEvent extends Event
   {
      
      private var message:Message;
      
      public function ChannelEvent(type:String, message:Message)
      {
         super(type);
         this.message = message;
      }
      
      public function getMessage() : Message
      {
         return this.message;
      }
   }
}

