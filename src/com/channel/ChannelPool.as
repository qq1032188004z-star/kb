package com.channel
{
   import flash.utils.Dictionary;
   
   public class ChannelPool
   {
      
      private static var dic:Dictionary = new Dictionary(true);
      
      public function ChannelPool()
      {
         super();
      }
      
      public static function getChannel(radio:String = "") : Channel
      {
         var channel:Channel = dic[radio] as Channel;
         if(channel == null)
         {
            channel = new Channel();
            dic[radio] = channel;
         }
         return channel;
      }
   }
}

