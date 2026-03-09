package com.game.icon
{
   import flash.display.BitmapData;
   
   public class IconBitMapData extends BitmapData
   {
      
      private var timesCited:int = 0;
      
      public var _dx:int;
      
      public var _dy:int;
      
      public function IconBitMapData(width:int, height:int, transparent:Boolean = true, fillColor:uint = 4294967295)
      {
         super(width,height,transparent,fillColor);
      }
      
      public function checkOut() : void
      {
         if(this.timesCited > 0)
         {
            --this.timesCited;
         }
         else
         {
            trace("warning.......iconbitmapdata_release");
         }
      }
      
      public function checkIn() : void
      {
         ++this.timesCited;
      }
      
      public function canDispose() : Boolean
      {
         return this.timesCited == 0;
      }
   }
}

