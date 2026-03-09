package com.publiccomponent.ui
{
   import caurina.transitions.Tweener;
   import com.game.util.ColorUtil;
   import com.game.util.DateUtil;
   import com.publiccomponent.URLUtil;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   
   public class TopButton extends Sprite
   {
      
      private var _tips:String;
      
      private var _bmpdata:BitmapData;
      
      private var _bmp:Bitmap;
      
      private var _mc:MovieClip;
      
      private var _index:int;
      
      public var row:int;
      
      public var col:int;
      
      public var showPos:int;
      
      public var hide:int = 0;
      
      public var c:int;
      
      public var place:int;
      
      public var showPhares:int;
      
      public var jump:String;
      
      public var targetScene:int;
      
      public var showTime:Array;
      
      private var _redPoint:MovieClip;
      
      private var _loader:Loader;
      
      public function TopButton(top:*, type:int = 1)
      {
         super();
         this.buttonMode = true;
         switch(type)
         {
            case 1:
               this._bmpdata = top;
               this._bmp = new Bitmap(this._bmpdata);
               addChild(this._bmp);
               break;
            case 2:
               if(top == null)
               {
                  return;
               }
               this._mc = top;
               this._mc.mouseEnabled = false;
               this._mc.mouseChildren = false;
               addChild(this._mc);
               if(Boolean(this._mc["redPoint"]))
               {
                  this._redPoint = this._mc["redPoint"];
                  this._redPoint.visible = false;
               }
               break;
            case 3:
               this._loader = new Loader();
               this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoadComplete);
               this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
               this._loader.load(new URLRequest(URLUtil.getSvnVer(top)));
         }
         this.initEvent();
      }
      
      private function onLoadComplete(evt:Event) : void
      {
         this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoadComplete);
         addChild(this._loader.contentLoaderInfo.content);
      }
      
      private function onLoadError(evt:IOErrorEvent) : void
      {
         try
         {
            this._loader.unloadAndStop();
            this._loader = null;
         }
         catch(e:*)
         {
         }
      }
      
      private function initEvent() : void
      {
         this.addEventListener(MouseEvent.ROLL_OUT,this.onMouseRollOut);
         this.addEventListener(MouseEvent.ROLL_OVER,this.onMouseRollOver);
      }
      
      public function set tips(value:String) : void
      {
         this._tips = value;
      }
      
      public function get tips() : String
      {
         return this._tips;
      }
      
      public function set index(value:int) : void
      {
         this._index = value;
      }
      
      public function get index() : int
      {
         return this._index;
      }
      
      private function onMouseRollOut(evt:MouseEvent) : void
      {
         Tweener.addTween(this,{
            "scaleX":1,
            "scaleY":1,
            "y":y - 2,
            "x":x + 0.5
         });
         this.filters = [];
      }
      
      private function onMouseRollOver(evt:MouseEvent) : void
      {
         Tweener.addTween(this,{
            "scaleX":1.03,
            "scaleY":1.03,
            "y":y + 2,
            "x":x - 0.5
         });
         this.filters = ColorUtil.getColorMatrixFilterShine1();
      }
      
      public function setRedPoint(flag:Boolean) : void
      {
         if(Boolean(this._redPoint))
         {
            this._redPoint.visible = flag;
         }
      }
      
      public function get getRedPointVisible() : Boolean
      {
         if(Boolean(this._redPoint))
         {
            return this._redPoint.visible;
         }
         return false;
      }
      
      public function checkShowIcon() : Boolean
      {
         if(Boolean(this.showTime) && this.showTime.length >= 2)
         {
            if(!DateUtil.isPassTime(this.showTime[0]) || DateUtil.isPassTime(this.showTime[1]))
            {
               return false;
            }
         }
         return true;
      }
      
      public function dispose() : void
      {
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

