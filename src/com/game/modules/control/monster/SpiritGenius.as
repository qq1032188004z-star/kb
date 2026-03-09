package com.game.modules.control.monster
{
   public class SpiritGenius
   {
      
      public function SpiritGenius()
      {
         super();
      }
      
      public static function cheakGenius(i:int) : int
      {
         var j:int = 1;
         if(i <= 5 && i >= 0)
         {
            j = 2;
         }
         else if(i <= 11 && i >= 6)
         {
            j = 3;
         }
         else if(i >= 12 && i <= 17)
         {
            j = 4;
         }
         else if(i >= 18 && i <= 26)
         {
            j = 5;
         }
         else if(i >= 27 && i <= 31)
         {
            j = 6;
         }
         return j;
      }
      
      public static function countGenius(i1:int, i2:int, i3:int, i4:int, i5:int, i6:int) : String
      {
         var i:int = i1 + i2 + i3 + i4 + i5 + i6 - 6;
         var geniusStr:String = "";
         if(i <= 9 && i >= 5)
         {
            geniusStr = "泛泛之辈";
         }
         else if(i <= 14 && i >= 10)
         {
            geniusStr = "璞玉之质";
         }
         else if(i >= 15 && i <= 19)
         {
            geniusStr = "百里挑一";
         }
         else if(i >= 20 && i <= 24)
         {
            geniusStr = "千载难逢";
         }
         else if(i >= 25 && i <= 29)
         {
            geniusStr = "万众瞩目";
         }
         else if(i == 30)
         {
            geniusStr = "绝代妖王";
         }
         else
         {
            O.o("啥都没有");
         }
         return geniusStr;
      }
      
      public static function countGeniusType(i1:int, i2:int, i3:int, i4:int, i5:int, i6:int) : int
      {
         var state:int = 0;
         var i:int = i1 + i2 + i3 + i4 + i5 + i6 - 6;
         if(i <= 9 && i >= 5)
         {
            state = 1;
         }
         else if(i <= 14 && i >= 10)
         {
            state = 2;
         }
         else if(i >= 15 && i <= 19)
         {
            state = 3;
         }
         else if(i >= 20 && i <= 24)
         {
            state = 4;
         }
         else if(i >= 25 && i <= 29)
         {
            state = 5;
         }
         else if(i == 30)
         {
            state = 6;
         }
         else
         {
            state = 0;
         }
         return state;
      }
      
      public static function countGeniusTotal($total:int) : int
      {
         var state:int = 0;
         if($total <= 9 && $total >= 5)
         {
            state = 1;
         }
         else if($total <= 14 && $total >= 10)
         {
            state = 2;
         }
         else if($total >= 15 && $total <= 19)
         {
            state = 3;
         }
         else if($total >= 20 && $total <= 24)
         {
            state = 4;
         }
         else if($total >= 25 && $total <= 29)
         {
            state = 5;
         }
         else if($total == 30)
         {
            state = 6;
         }
         else
         {
            O.o("啥都没有");
            state = 0;
         }
         return state;
      }
   }
}

