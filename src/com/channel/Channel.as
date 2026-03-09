package com.channel
{
   import flash.events.EventDispatcher;
   
   public class Channel
   {
      
      private var dispatch:EventDispatcher;
      
      public function Channel()
      {
         super();
         this.dispatch = new EventDispatcher();
      }
      
      public function addChannelListener(messageName:String, callBack:Function) : void
      {
         this.dispatch.addEventListener(messageName,callBack);
      }
      
      public function removeListener(messageName:String, callBack:Function) : void
      {
         this.dispatch.removeEventListener(messageName,callBack);
      }
      
      public function sendMessagaToChannel(radio:String, message:Message) : void
      {
         var channel:Channel = ChannelPool.getChannel(radio);
         channel.sendMessage(message);
      }
      
      public function sendMessage(message:Message) : void
      {
         this.dispatch.dispatchEvent(new ChannelEvent(message.getName(),message));
      }
   }
}

