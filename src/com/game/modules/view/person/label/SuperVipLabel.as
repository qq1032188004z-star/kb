package com.game.modules.view.person.label
{
   import com.game.global.GlobalConfig;
   import com.publiccomponent.ui.NameLabelLoader;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class SuperVipLabel extends Sprite
   {
      
      private static var shareBmd:BitmapData;
      
      private var _year:int;
      
      private var _labelBitmap:Bitmap;
      
      private var _effectMc:MovieClip;
      
      public function SuperVipLabel()
      {
         super();
         var date:Date = new Date();
         this._year = int(date.fullYear);
         if(Boolean(shareBmd))
         {
            this.init();
         }
         else
         {
            this.loadRescoure();
         }
      }
      
      private function loadRescoure() : void
      {
         var currYear:int = GlobalConfig.currVipYear;
         NameLabelLoader.instance.load("assets/nameboder/boder_supervip.swf",this.loadComplete,currYear + "_boder_supervip");
      }
      
      private function loadComplete(bmd:BitmapData) : void
      {
         if(!shareBmd)
         {
            shareBmd = bmd;
         }
         else if(Boolean(bmd))
         {
            bmd.dispose();
         }
         if(Boolean(shareBmd))
         {
            this.init();
         }
      }
      
      private function init() : void
      {
         this._labelBitmap = new Bitmap();
         this._labelBitmap.bitmapData = shareBmd;
         this._labelBitmap.x = -shareBmd.width / 2 - 8;
         addChild(this._labelBitmap);
         this._effectMc = NameLabelLoader.instance.getMaterial(GlobalConfig.currVipYear + "_effect_supervip") as MovieClip;
         if(Boolean(this._effectMc))
         {
            this._effectMc.x = this._labelBitmap.x + 4;
            addChild(this._effectMc);
         }
      }
      
      public function dispose() : void
      {
         if(Boolean(this._effectMc))
         {
            this._effectMc.stop();
            this._effectMc = null;
         }
         if(Boolean(this._labelBitmap))
         {
            this._labelBitmap.bitmapData = null;
            this._labelBitmap = null;
         }
      }
   }
}

