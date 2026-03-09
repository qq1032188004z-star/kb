package com.game.util
{
   public class BynaryUtil
   {
      
      public function BynaryUtil()
      {
         super();
      }
      
      public static function checkIndex(index:int, value:int) : Boolean
      {
         var i:int = 0;
         var state:int = 0;
         if(index > 0)
         {
            state = 1;
            for(i = 0; i < index - 1; i++)
            {
               state *= 2;
            }
         }
         return (state & value) > 0;
      }
      
      public static function modifyBinaryBit(num:int, index:int, flag:Boolean) : int
      {
         var ba:int = 0;
         var binaryStr:String = num.toString(2);
         var binaryArray:Array = binaryStr.split("");
         binaryArray.reverse();
         while(binaryArray.length < index)
         {
            binaryArray.push("0");
         }
         if(flag)
         {
            binaryArray[index - 1] = "1";
         }
         else
         {
            binaryArray[index - 1] = "0";
         }
         var modifiedBinaryStr:String = "";
         for each(ba in binaryArray)
         {
            modifiedBinaryStr = ba.toString() + modifiedBinaryStr;
         }
         return parseInt(modifiedBinaryStr,2);
      }
   }
}

