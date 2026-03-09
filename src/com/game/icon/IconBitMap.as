package com.game.icon
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   
   public class IconBitMap extends Bitmap
   {
      
      public var iconPath:String;
      
      private var _iconData:IconBitMapData;
      
      public function IconBitMap()
      {
         super();
      }
      
      override public function set bitmapData(value:BitmapData) : void
      {
         this._iconData = value as IconBitMapData;
         if(Boolean(this._iconData))
         {
            this.x = super.x;
            this.y = super.y;
            this._iconData.checkIn();
         }
         super.bitmapData = value;
      }
      
      public function clear() : void
      {
         super.bitmapData = null;
         if(Boolean(this._iconData))
         {
            this._iconData.checkOut();
            super.x = this.x;
            super.y = this.y;
            this._iconData = null;
         }
         else if(Boolean(this.iconPath) && this.iconPath != "")
         {
            IconBuilder.stopLoadingIcon(this);
            this.iconPath = "";
         }
      }
      
      override public function get x() : Number
      {
         if(Boolean(this._iconData))
         {
            return super.x - this._iconData._dx;
         }
         return super.x;
      }
      
      override public function get y() : Number
      {
         if(Boolean(this._iconData))
         {
            return super.y - this._iconData._dy;
         }
         return super.y;
      }
      
      override public function set x(value:Number) : void
      {
         if(Boolean(this._iconData))
         {
            super.x = value + this._iconData._dx;
         }
         else
         {
            super.x = value;
         }
      }
      
      override public function set y(value:Number) : void
      {
         if(Boolean(this._iconData))
         {
            super.y = value + this._iconData._dy;
         }
         else
         {
            super.y = value;
         }
      }
      
      public function dispose() : void
      {
         this.clear();
      }
   }
}

