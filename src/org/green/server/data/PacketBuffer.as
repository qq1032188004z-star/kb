package org.green.server.data
{
   import flash.events.*;
   
   public class PacketBuffer extends EventDispatcher
   {
      
      private static const MAGIC_NUMBER_D:int = 21316;
      
      private static const SPLIT:int = 21316;
      
      private static const MAGIC_NUMBER_C:int = 21315;
      
      public var bufarr:Array = new Array();
      
      public var rb:ByteArray;
      
      private var buf:ByteArray = new ByteArray();
      
      public var socketlock:Boolean = true;
      
      public function PacketBuffer()
      {
         super();
      }
      
      private function getpacket(len:int, magic:uint) : MsgPacket
      {
         var msgpack:MsgPacket = null;
         msgpack.mOpcode = this.buf.readUnsignedInt();
         msgpack.mParams = this.buf.readUnsignedInt();
         if(len > 0)
         {
            msgpack.body = MsgUtil.createByteArray();
            msgpack.body.writeBytes(this.buf,this.buf.position,len);
            this.buf.position += len;
            msgpack.body.position = 0;
         }
         if(magic == MAGIC_NUMBER_C)
         {
            msgpack.body.uncompress();
         }
         return msgpack;
      }
      
      public function getPackets1() : Array
      {
         var magic:* = 0;
         var len:* = 0;
         var ba:* = null;
         var mb:* = null;
         var msg:* = null;
         var shiftbuf:* = this.bufarr.shift() as ByteArray;
         if(this.buf != null)
         {
            this.buf.position = this.buf.length;
            this.buf.writeBytes(shiftbuf);
         }
         else
         {
            this.buf = shiftbuf;
         }
         var ps:* = [];
         var ptr:* = 0;
         this.buf.position = ptr;
         while(this.buf.bytesAvailable >= MsgPacket.HEADER_LEN)
         {
            this.buf.position = ptr;
            magic = this.buf.readShort();
            ptr = this.buf.position - 2;
            len = this.buf.readShort();
            if(this.buf.bytesAvailable < len)
            {
               ba = MsgUtil.createByteArray();
               this.buf.position = ptr;
               ba.writeBytes(this.buf,0,this.buf.bytesAvailable);
               this.buf = ba;
               return ps;
            }
            try
            {
               this.buf.position = ptr + 2;
               mb = MsgUtil.createByteArray();
               this.buf.readBytes(mb,0,len);
               mb.position = 0;
               msg = MsgUtil.createMsgPacket(mb,magic);
               ptr = this.buf.position;
               ps.push(msg);
            }
            catch(e:Error)
            {
            }
         }
         if(this.buf.bytesAvailable <= 0)
         {
            this.buf = null;
         }
         return ps;
      }
      
      public function clear() : void
      {
         this.buf = null;
      }
      
      public function getPackets() : Array
      {
         var msgpack:MsgPacket = null;
         var len:uint = 0;
         this.socketlock = false;
         var shiftbuf:ByteArray = this.bufarr.shift() as ByteArray;
         if(this.buf != null)
         {
            this.buf.position = this.buf.length;
            this.buf.writeBytes(shiftbuf);
            this.buf.position = 0;
         }
         else
         {
            this.buf = shiftbuf;
         }
         var ps:Array = [];
         if(this.buf.bytesAvailable < MsgPacket.HEADER_LEN)
         {
            this.socketlock = true;
            return ps;
         }
         var magic:uint = uint(this.buf.readShort());
         if(magic != MAGIC_NUMBER_C && magic != MAGIC_NUMBER_D)
         {
            this.buf = null;
            this.socketlock = true;
            return ps;
         }
         while((magic == MAGIC_NUMBER_C || magic == MAGIC_NUMBER_D) && this.buf && this.buf.bytesAvailable > 0)
         {
            msgpack = new MsgPacket();
            len = uint(this.buf.readShort());
            len &= 65535;
            msgpack.bodylen = len;
            if(this.buf.bytesAvailable < len + MsgPacket.HEADER_LEN - 4)
            {
               this.buf.position = 0;
               this.socketlock = true;
               magic = 0;
               break;
            }
            msgpack.mOpcode = this.buf.readUnsignedInt();
            msgpack.mParams = this.buf.readUnsignedInt();
            if(len > 0)
            {
               msgpack.body = MsgUtil.createByteArray();
               msgpack.body.writeBytes(this.buf,this.buf.position,len);
               this.buf.position += len;
               msgpack.body.position = 0;
            }
            if(magic == MAGIC_NUMBER_C)
            {
               msgpack.body.uncompress();
            }
            ps.push(msgpack);
            if(this.buf.bytesAvailable > 1)
            {
               magic = uint(this.buf.readShort());
               if(magic != MAGIC_NUMBER_C && magic != MAGIC_NUMBER_D)
               {
                  this.buf = null;
               }
            }
         }
         if(this.buf == null || this.buf.position == this.buf.length)
         {
            this.buf = null;
            this.socketlock = true;
         }
         else
         {
            this.socketlock = true;
         }
         return ps;
      }
      
      public function push(ba:ByteArray) : void
      {
         this.bufarr.push(ba);
      }
   }
}

