package org.engine.math
{
   public class MapMath
   {
      
      public static const SQRT2:Number = Math.sqrt(2);
      
      public function MapMath()
      {
         super();
      }
      
      public static function abs(value:Number) : Number
      {
         if(value > 0)
         {
            return value;
         }
         return -value;
      }
      
      public static function min(value1:Number, value2:Number) : Number
      {
         if(value1 < value2)
         {
            return value1;
         }
         return value2;
      }
      
      public static function max(value1:Number, value2:Number) : Number
      {
         if(value1 > value2)
         {
            return value1;
         }
         return value2;
      }
      
      public static function sqrt(value:Number) : Number
      {
         var x:Number = NaN;
         x = value;
         for(var i:int = 1; i <= 5; i++)
         {
            x = x + value / x >> 1;
         }
         return x;
      }
   }
}

