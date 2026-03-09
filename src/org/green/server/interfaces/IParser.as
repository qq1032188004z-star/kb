package org.green.server.interfaces
{
   import org.green.server.data.MsgPacket;
   
   public interface IParser
   {
      
      function parse(param1:MsgPacket) : void;
   }
}

