package com.channel
{
   public class Message
   {
      
      private var body:Object;
      
      private var name:String;
      
      public function Message(name:String = "", body:Object = null)
      {
         super();
         this.name = name;
         this.body = body;
      }
      
      public function getBody() : Object
      {
         return this.body;
      }
      
      public function getName() : String
      {
         return this.name;
      }
      
      public function sendToChannel(radio:String = "") : void
      {
         ChannelPool.getChannel(radio).sendMessage(this);
      }
   }
}

