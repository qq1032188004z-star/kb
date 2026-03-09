package org.green.server.data
{
   public class CmdPacket
   {
      
      private static const SIZE_BYTE_HEAD:uint = 12;
      
      private static const SPLIT:int = 21316;
      
      public var body:ByteArray;
      
      public var mParams:uint;
      
      public var mOpcode:uint;
      
      public var bodyargs:Array;
      
      public function CmdPacket()
      {
         super();
      }
      
      public static function build(mOpcode:uint, mParams:uint, body:Array) : CmdPacket
      {
         var value:Object = null;
         var packet:CmdPacket = new CmdPacket();
         packet.bodyargs = body;
         packet.mOpcode = mOpcode;
         packet.mParams = mParams;
         if(body != null && body.length > 0)
         {
            packet.body = MsgUtil.createByteArray();
         }
         for each(value in body)
         {
            if(value is ShortInt)
            {
               packet.body.writeShort(ShortInt(value).data);
            }
            else if(value is int)
            {
               packet.body.writeInt(value as int);
            }
            else if(value is Number)
            {
               packet.body.writeFloat(value as Number);
            }
            else if(value is String)
            {
               packet.body.writeUTF(value as String);
            }
            else if(value is Boolean)
            {
               packet.body.writeBoolean(value as Boolean);
            }
            else if(value is Array)
            {
               packet = writeArr(packet,value as Array);
            }
            else if(value is ByteArray)
            {
               packet.body.writeBytes(ByteArray(value));
            }
         }
         return packet;
      }
      
      private static function writeArr(packet:CmdPacket, arr:Array) : CmdPacket
      {
         packet.body.writeInt(arr.length);
         var i:int = 0;
         while(i < arr.length)
         {
            if(arr[i] is ShortInt)
            {
               packet.body.writeShort(ShortInt(arr[i]).data);
            }
            else if(arr[i] is int)
            {
               packet.body.writeInt(arr[i] as int);
            }
            else if(arr[i] is Number)
            {
               packet.body.writeFloat(arr[i] as Number);
            }
            else if(arr[i] is String)
            {
               packet.body.writeUTF(arr[i] as String);
            }
            else if(arr[i] is Boolean)
            {
               packet.body.writeBoolean(arr[i] as Boolean);
            }
            else if(arr[i] is Array)
            {
               packet = writeArr(packet,arr[i] as Array);
            }
            else if(arr[i] is ByteArray)
            {
               packet.body.writeBytes(ByteArray(arr[i]));
            }
            i++;
         }
         return packet;
      }
      
      public function encode() : ByteArray
      {
         var ba:ByteArray = MsgUtil.createByteArray();
         ba.writeShort(SPLIT);
         if(this.body == null)
         {
            ba.writeShort(0);
         }
         else
         {
            ba.writeShort(this.body.length);
         }
         ba.writeUnsignedInt(this.mOpcode);
         ba.writeUnsignedInt(this.mParams);
         if(this.body != null)
         {
            ba.writeBytes(this.body);
         }
         return ba;
      }
   }
}

