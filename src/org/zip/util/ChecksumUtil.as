package org.zip.util
{
   import flash.utils.ByteArray;
   
   public class ChecksumUtil
   {
      
      private static var crcTable:Array = makeCRCTable();
      
      public function ChecksumUtil()
      {
         super();
      }
      
      private static function makeCRCTable() : Array
      {
         var i:uint = 0;
         var j:uint = 0;
         var c:uint = 0;
         var table:Array = [];
         for(i = 0; i < 256; i++)
         {
            c = i;
            for(j = 0; j < 8; j++)
            {
               if(Boolean(c & 1))
               {
                  c = uint(0xEDB88320 ^ c >>> 1);
               }
               else
               {
                  c >>>= 1;
               }
            }
            table.push(c);
         }
         return table;
      }
      
      public static function CRC32(data:ByteArray, start:uint = 0, len:uint = 0) : uint
      {
         var i:uint = 0;
         if(start >= data.length)
         {
            start = data.length;
         }
         if(len == 0)
         {
            len = uint(data.length - start);
         }
         if(len + start > data.length)
         {
            len = uint(data.length - start);
         }
         var c:uint = 4294967295;
         for(i = start; i < len; i++)
         {
            c = uint(uint(crcTable[(c ^ data[i]) & 0xFF]) ^ c >>> 8);
         }
         return c ^ 0xFFFFFFFF;
      }
      
      public static function Adler32(data:ByteArray, start:uint = 0, len:uint = 0) : uint
      {
         var tlen:uint = 0;
         if(start >= data.length)
         {
            start = data.length;
         }
         if(len == 0)
         {
            len = uint(data.length - start);
         }
         if(len + start > data.length)
         {
            len = uint(data.length - start);
         }
         var i:uint = start;
         var a:uint = 1;
         var b:uint = 0;
         while(Boolean(len))
         {
            tlen = len > 5550 ? 5550 : len;
            len -= tlen;
            do
            {
               a += data[i++];
               b += a;
            }
            while(Boolean(--tlen));
            
            a = uint((a & 0xFFFF) + (a >> 16) * 15);
            b = uint((b & 0xFFFF) + (b >> 16) * 15);
         }
         if(a >= 65521)
         {
            a -= 65521;
         }
         b = uint((b & 0xFFFF) + (b >> 16) * 15);
         if(b >= 65521)
         {
            b -= 65521;
         }
         return b << 16 | a;
      }
   }
}

