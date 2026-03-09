package com.xygame.module.battle.util
{
   import flash.display.MovieClip;
   
   public class Rotation180
   {
      
      private static var _instance:Rotation180;
      
      public function Rotation180()
      {
         super();
      }
      
      public static function get instance() : Rotation180
      {
         if(_instance == null)
         {
            _instance = new Rotation180();
         }
         return _instance;
      }
      
      public static function rotationX180Child(mc:MovieClip) : MovieClip
      {
         var tempx:Number = mc.getChildAt(0).x;
         var tempy:Number = mc.getChildAt(0).y;
         mc.getChildAt(0).x = mc.getChildAt(0).width / 2;
         mc.getChildAt(0).y = mc.getChildAt(0).height / 2;
         mc.getChildAt(0).scaleX = -mc.getChildAt(0).scaleX;
         mc.getChildAt(0).x = tempx;
         mc.getChildAt(0).y = tempy;
         return mc;
      }
      
      public static function rotationY180(mc:MovieClip) : MovieClip
      {
         var tempx:Number = mc.x;
         var tempy:Number = mc.y;
         mc.x = mc.width / 2;
         mc.y = mc.height / 2;
         mc.scaleY = -mc.scaleY;
         mc.x = tempx;
         mc.y = tempy;
         return mc;
      }
      
      public static function rotationX180(mc:MovieClip) : MovieClip
      {
         var tempx:Number = mc.x;
         var tempy:Number = mc.y;
         mc.x = mc.width / 2;
         mc.y = mc.height / 2;
         mc.scaleX = -mc.scaleX;
         mc.x = tempx;
         mc.y = tempy;
         return mc;
      }
   }
}

