package org.green.server.data
{
   import flash.utils.ByteArray;
   
   public class ByteArray extends flash.utils.ByteArray
   {
      
      public function ByteArray()
      {
         super();
      }
      
      override public function readBytes(bytes:flash.utils.ByteArray, offset:uint = 0, length:uint = 0) : void
      {
         try
         {
            super.readBytes(bytes,offset,length);
         }
         catch(e:Error)
         {
         }
      }
      
      override public function readBoolean() : Boolean
      {
         try
         {
            return super.readBoolean();
         }
         catch(e:Error)
         {
            return false;
         }
      }
      
      override public function readByte() : int
      {
         try
         {
            return super.readByte();
         }
         catch(e:Error)
         {
            return 0;
         }
      }
      
      override public function readUnsignedByte() : uint
      {
         try
         {
            return super.readUnsignedByte();
         }
         catch(e:Error)
         {
            return 0;
         }
      }
      
      override public function readShort() : int
      {
         try
         {
            return super.readShort();
         }
         catch(e:Error)
         {
            return 0;
         }
      }
      
      override public function readUnsignedShort() : uint
      {
         try
         {
            return super.readUnsignedShort();
         }
         catch(e:Error)
         {
            return 0;
         }
      }
      
      override public function readInt() : int
      {
         try
         {
            return super.readInt();
         }
         catch(e:Error)
         {
            return 0;
         }
      }
      
      override public function readUnsignedInt() : uint
      {
         try
         {
            return super.readUnsignedInt();
         }
         catch(e:Error)
         {
            return 0;
         }
      }
      
      override public function readFloat() : Number
      {
         try
         {
            return super.readFloat();
         }
         catch(e:Error)
         {
            return 0;
         }
      }
      
      override public function readDouble() : Number
      {
         try
         {
            return super.readDouble();
         }
         catch(e:Error)
         {
            return 0;
         }
      }
      
      override public function readMultiByte(length:uint, charSet:String) : String
      {
         try
         {
            return super.readMultiByte(length,charSet);
         }
         catch(e:Error)
         {
            return "";
         }
      }
      
      override public function readUTF() : String
      {
         try
         {
            return super.readUTF();
         }
         catch(e:Error)
         {
            return "";
         }
      }
      
      override public function readUTFBytes(length:uint) : String
      {
         try
         {
            return super.readUTFBytes(length);
         }
         catch(e:Error)
         {
            return "";
         }
      }
      
      override public function get bytesAvailable() : uint
      {
         return super.bytesAvailable;
      }
      
      override public function get objectEncoding() : uint
      {
         return super.objectEncoding;
      }
      
      override public function set objectEncoding(version:uint) : void
      {
         super.objectEncoding = version;
      }
      
      override public function get endian() : String
      {
         return super.endian;
      }
      
      override public function set endian(type:String) : void
      {
         super.endian = type;
      }
      
      override public function writeBytes(bytes:flash.utils.ByteArray, offset:uint = 0, length:uint = 0) : void
      {
         try
         {
            super.writeBytes(bytes,offset,length);
         }
         catch(e:Error)
         {
         }
      }
      
      override public function writeBoolean(value:Boolean) : void
      {
         try
         {
            super.writeBoolean(value);
         }
         catch(e:Error)
         {
         }
      }
      
      override public function writeByte(value:int) : void
      {
         try
         {
            super.writeByte(value);
         }
         catch(e:Error)
         {
         }
      }
      
      override public function writeShort(value:int) : void
      {
         try
         {
            super.writeShort(value);
         }
         catch(e:Error)
         {
         }
      }
      
      override public function writeInt(value:int) : void
      {
         try
         {
            super.writeInt(value);
         }
         catch(e:Error)
         {
         }
      }
      
      override public function writeUnsignedInt(value:uint) : void
      {
         try
         {
            super.writeUnsignedInt(value);
         }
         catch(e:Error)
         {
         }
      }
      
      override public function writeFloat(value:Number) : void
      {
         try
         {
            super.writeFloat(value);
         }
         catch(e:Error)
         {
         }
      }
      
      override public function writeDouble(value:Number) : void
      {
         try
         {
            super.writeDouble(value);
         }
         catch(e:Error)
         {
         }
      }
      
      override public function writeMultiByte(value:String, charSet:String) : void
      {
         try
         {
            super.writeMultiByte(value,charSet);
         }
         catch(e:Error)
         {
         }
      }
      
      override public function writeUTF(value:String) : void
      {
         try
         {
            super.writeUTF(value);
         }
         catch(e:Error)
         {
         }
      }
      
      override public function writeUTFBytes(value:String) : void
      {
         try
         {
            super.writeUTFBytes(value);
         }
         catch(e:Error)
         {
         }
      }
   }
}

