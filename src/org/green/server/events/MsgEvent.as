package org.green.server.events
{
   import flash.events.Event;
   import org.green.server.data.MsgPacket;
   
   public class MsgEvent extends Event
   {
      
      private var _msg:MsgPacket;
      
      public function MsgEvent(cmd:uint, msg:MsgPacket)
      {
         super(cmd + "",false,false);
         this._msg = msg;
      }
      
      public function get msg() : MsgPacket
      {
         return this._msg;
      }
   }
}

