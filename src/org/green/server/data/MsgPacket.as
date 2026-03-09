package org.green.server.data
{
   public class MsgPacket
   {
      
      public static const HEADER_LEN:uint = 12;
      
      public var body:ByteArray = MsgUtil.createByteArray();
      
      public var bodylen:uint;
      
      public var mParams:int;
      
      public var mOpcode:uint;
      
      public var userdata:Object = {};
      
      public function MsgPacket()
      {
         super();
      }
      
      public function readUTF() : String
      {
         var byte:ByteArray = new ByteArray();
         this.body.readBytes(byte);
         byte.uncompress();
         byte.position = 0;
         return byte.readUTF();
      }
   }
}

