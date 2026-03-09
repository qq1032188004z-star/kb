package org.dress.util
{
   import flash.utils.ByteArray;
   
   public class CloneByteArray
   {
      
      public function CloneByteArray()
      {
         super();
      }
      
      public static function clone(value:ByteArray) : ByteArray
      {
         value.position = 0;
         var byteArrary:ByteArray = new ByteArray();
         byteArrary.writeBytes(value,value.position);
         return byteArrary;
      }
   }
}

