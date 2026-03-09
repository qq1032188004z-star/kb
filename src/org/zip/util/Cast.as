package org.zip.util
{
   public class Cast
   {
      
      public function Cast()
      {
         super();
      }
      
      public static function toShort(valueIn:int) : int
      {
         var unsignedValue:Number = valueIn & 0x7FFF;
         var signedValue:Number = unsignedValue;
         if(valueIn >> 15 == 1)
         {
            signedValue = unsignedValue - 32768;
         }
         return signedValue;
      }
      
      public static function toByte(valueIn:int) : int
      {
         var unsignedValue:Number = valueIn & 0x7F;
         var signedValue:Number = unsignedValue;
         var signedBit:Number = (valueIn & 0xFF) >> 7;
         if(signedBit == 1)
         {
            signedValue = unsignedValue - 128;
         }
         return signedValue;
      }
   }
}

