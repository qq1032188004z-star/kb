package org.green.server.data
{
   import flash.utils.Endian;
   
   public class MsgUtil
   {
      
      public function MsgUtil()
      {
         super();
      }
      
      public static function createMsgPacket(ba:ByteArray, magic:int) : MsgPacket
      {
         ;
         ;
         var packet:MsgPacket = new MsgPacket();
         packet.bodylen = ba.readShort();
         packet.mOpcode = ba.readUnsignedInt();
         packet.mParams = ba.readUnsignedInt();
         if(packet.bodylen > ba.bytesAvailable)
         {
            packet.bodylen = ba.bytesAvailable;
         }
         if(packet.bodylen > 0)
         {
            packet.body = MsgUtil.createByteArray();
            ba.readBytes(packet.body,0,packet.bodylen);
            if(magic == 21315)
            {
               try
               {
                  packet.body.uncompress();
               }
               catch(error:Error)
               {
                  O.o("createMsgPacket()","【21325】数据解压缩错误",error);
               }
            }
            packet.body.position = 0;
         }
         return packet;
      }
      
      public static function createByteArray() : ByteArray
      {
         var ba:ByteArray = new ByteArray();
         ba.endian = Endian.LITTLE_ENDIAN;
         return ba;
      }
   }
}

