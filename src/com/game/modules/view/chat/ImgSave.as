package com.game.modules.view.chat
{
   import com.publiccomponent.loading.GreenLoading;
   import com.publiccomponent.loading.Loading;
   import com.publiccomponent.loading.MaterialLib;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class ImgSave extends Sprite
   {
      
      private var bitmap:Bitmap;
      
      public var loader:Loader;
      
      private var loading:Loading;
      
      public var boderMc:MovieClip;
      
      private var tempbit:BitmapData;
      
      private var tempRect:Rectangle;
      
      private var closeMc:SimpleButton;
      
      public function ImgSave(bitmapda:BitmapData)
      {
         super();
         this.tempbit = bitmapda;
         this.tempRect = bitmapda.rect;
         this.loading = GreenLoading.loading;
         this.loading.visible = true;
         this.loading.loadModule("","assets/material/border.swf",this.loadeComplete);
         this.doubleClickEnabled = true;
         this.addEventListener(MouseEvent.MOUSE_DOWN,this.setDrag);
         this.addEventListener(MouseEvent.MOUSE_UP,this.cancelDrag);
         this.addEventListener(MouseEvent.DOUBLE_CLICK,this.setVisableFalse);
         this.bitmap = new Bitmap();
         this.closeMc = MaterialLib.getInstance().getMaterial("closeBtn") as SimpleButton;
         this.closeMc.addEventListener(MouseEvent.MOUSE_DOWN,this.setVisableFalse);
      }
      
      public function loadeComplete(display:Loader) : void
      {
         this.initImage(this.tempbit);
         this.loading.visible = false;
         this.boderMc = new (display.contentLoaderInfo.applicationDomain.getDefinition("chat") as Class)();
         this.addChild(this.boderMc);
         this.addChild(this.closeMc);
         this.boderMc.width = this.bitmap.width + 43;
         this.boderMc.height = this.bitmap.height + 37;
         this.bitmap.x = -this.boderMc.width / 2 + 19;
         this.bitmap.y = -this.boderMc.height / 2 + 18;
         this.closeMc.x = this.bitmap.width / 2;
         this.closeMc.y = -this.bitmap.height / 2;
      }
      
      public function initImage(bitmapda:BitmapData) : void
      {
         this.bitmap.bitmapData = bitmapda;
         this.addChild(this.bitmap);
      }
      
      private function setDrag(evt:MouseEvent) : void
      {
         this.startDrag();
      }
      
      private function cancelDrag(evt:MouseEvent) : void
      {
         this.stopDrag();
      }
      
      private function setVisableFalse(evt:MouseEvent) : void
      {
         this.bitmap.bitmapData.dispose();
         this.parent.removeChild(this);
      }
   }
}

