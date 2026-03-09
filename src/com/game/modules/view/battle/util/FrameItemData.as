package com.game.modules.view.battle.util
{
   import flash.display.BitmapData;
   
   public class FrameItemData
   {
      
      public var bitmapData:BitmapData;
      
      public var offsetX:Number;
      
      public var offsetY:Number;
      
      public var scaleX:Number;
      
      public var scaleY:Number;
      
      public var isGlobalBlankFrame:Boolean;
      
      public function FrameItemData(bitmapData:BitmapData = null, offsetX:Number = 0, offsetY:Number = 0, scaleX:Number = 1, scaleY:Number = 1, isGlobalBlankFrame:Boolean = false)
      {
         super();
         this.bitmapData = bitmapData;
         this.offsetX = offsetX;
         this.offsetY = offsetY;
         this.scaleX = scaleX;
         this.scaleY = scaleY;
         this.isGlobalBlankFrame = isGlobalBlankFrame;
      }
      
      public function dispose() : void
      {
         if(Boolean(this.bitmapData) && !this.isGlobalBlankFrame)
         {
            this.bitmapData.dispose();
         }
      }
   }
}

