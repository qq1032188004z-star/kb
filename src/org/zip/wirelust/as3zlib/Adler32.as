package org.zip.wirelust.as3zlib
{
   import flash.utils.ByteArray;
   
   public final class Adler32
   {
      
      private static var BASE:int = 65521;
      
      private static var NMAX:int = 5552;
      
      public function Adler32()
      {
         super();
      }
      
      public function adler32(adler:Number, buf:ByteArray, index:int, len:int) : Number
      {
         var k:int = 0;
         if(buf == null)
         {
            return 1;
         }
         var s1:Number = adler & 0xFFFF;
         var s2:Number = adler >> 16 & 0xFFFF;
         while(len > 0)
         {
            k = len < NMAX ? len : NMAX;
            len -= k;
            while(k >= 16)
            {
               s1 += buf[index++] & 0xFF;
               s2 += s1;
               s1 += buf[index++] & 0xFF;
               s2 += s1;
               s1 += buf[index++] & 0xFF;
               s2 += s1;
               s1 += buf[index++] & 0xFF;
               s2 += s1;
               s1 += buf[index++] & 0xFF;
               s2 += s1;
               s1 += buf[index++] & 0xFF;
               s2 += s1;
               s1 += buf[index++] & 0xFF;
               s2 += s1;
               s1 += buf[index++] & 0xFF;
               s2 += s1;
               s1 += buf[index++] & 0xFF;
               s2 += s1;
               s1 += buf[index++] & 0xFF;
               s2 += s1;
               s1 += buf[index++] & 0xFF;
               s2 += s1;
               s1 += buf[index++] & 0xFF;
               s2 += s1;
               s1 += buf[index++] & 0xFF;
               s2 += s1;
               s1 += buf[index++] & 0xFF;
               s2 += s1;
               s1 += buf[index++] & 0xFF;
               s2 += s1;
               s1 += buf[index++] & 0xFF;
               s2 += s1;
               k -= 16;
            }
            if(k != 0)
            {
               do
               {
                  s1 += buf[index++] & 0xFF;
                  s2 += s1;
               }
               while(--k != 0);
               
            }
            s1 %= BASE;
            s2 %= BASE;
         }
         return s2 << 16 | s1;
      }
   }
}

