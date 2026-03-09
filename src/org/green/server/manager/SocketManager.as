package org.green.server.manager
{
   import flash.utils.Dictionary;
   import org.green.server.core.GreenSocket;
   
   public class SocketManager
   {
      
      public static var managername:String;
      
      private static var dic:Dictionary = new Dictionary(true);
      
      public function SocketManager()
      {
         super();
         managername = SocketManager.dic.toString();
      }
      
      public static function getGreenSocket(type:String = "") : GreenSocket
      {
         var socket:GreenSocket = null;
         socket = dic[type];
         if(socket == null)
         {
            dic[type] = socket = new GreenSocket();
         }
         return socket;
      }
      
      public static function delGreenSocket(type:String) : void
      {
         var socket:GreenSocket = dic[type];
         if(Boolean(socket))
         {
            socket.close();
            dic[type] = null;
            delete dic[type];
         }
      }
      
      public static function hasGreenSocket(type:String) : *
      {
         return dic[type];
      }
   }
}

