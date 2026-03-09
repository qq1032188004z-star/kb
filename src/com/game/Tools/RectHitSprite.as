package com.game.Tools
{
   import flash.display.Sprite;
   
   public class RectHitSprite extends Sprite
   {
      
      private var _tipHeight:Number = 0;
      
      public function RectHitSprite()
      {
         super();
      }
      
      public function get tipHeight() : Number
      {
         return this._tipHeight;
      }
      
      public function set tipHeight(value:Number) : void
      {
         this._tipHeight = value;
      }
   }
}

