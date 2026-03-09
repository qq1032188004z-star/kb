package com.game.util
{
   import com.game.Tools.RectButton;
   import com.game.modules.view.WindowLayer;
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.loading.GreenLoading;
   import com.publiccomponent.loading.Hloader;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.events.ProgressEvent;
   import flash.events.TimerEvent;
   import flash.system.LoaderContext;
   import flash.utils.Timer;
   
   public class HLoaderSprite extends Sprite
   {
      
      public static const SIMPLE_BUTTON:int = 1;
      
      public static const RECT_BUTTON:int = 2;
      
      protected var _isEncryption:Boolean;
      
      private var _btnList:Vector.<DisplayObject>;
      
      public var maskShape:Shape = new Shape();
      
      private var _url:String;
      
      public var showloading:Boolean = true;
      
      public var loader:Hloader;
      
      public var context:LoaderContext;
      
      public var datepass:Boolean = true;
      
      public var bg:*;
      
      private var innerMask:Sprite;
      
      private var oinnerMask:Sprite;
      
      private var mytimer:Timer;
      
      private var havestart:Boolean = false;
      
      public function HLoaderSprite()
      {
         super();
         this._btnList = new Vector.<DisplayObject>();
      }
      
      public function initParams(params:Object = null) : void
      {
      }
      
      public function getserverdata() : void
      {
      }
      
      public function set url(value:String) : void
      {
         if(this.loader == null)
         {
            this._url = URLUtil.getSvnVer(value);
            this.loadswf();
         }
      }
      
      public function get url() : String
      {
         return this._url;
      }
      
      private function loadswf() : void
      {
         if(this.showloading)
         {
            GreenLoading.loading.visible = true;
         }
         this.loader = new Hloader(this._url,null,this.context,this._isEncryption);
         this.loader.addEventListener(Event.COMPLETE,this.loadComponent,false,0,true);
         this.loader.addEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler,false,0,true);
         this.loader.addEventListener(ProgressEvent.PROGRESS,this.onLoadProgressHandler,false,0,true);
      }
      
      protected function loadComponent(event:Event) : void
      {
         this.stoptime("loadcomponent");
         if(this.loader == null)
         {
            if(this.showloading)
            {
               GreenLoading.loading.visible = false;
            }
            return;
         }
         this.loader.removeEventListener(Event.COMPLETE,this.loadComponent);
         this.loader.removeEventListener(ProgressEvent.PROGRESS,this.onLoadProgressHandler);
         this.bg = this.loader.content;
         this.addChild(this.bg);
         if(Boolean(this.bg.hasOwnProperty("dragClip")) && this.bg.dragClip != null)
         {
            this.addDrag();
         }
         this.setShow();
         if(this.showloading)
         {
            GreenLoading.loading.visible = false;
         }
      }
      
      private function onLoadProgressHandler(event:ProgressEvent) : void
      {
         var valuetime:int = 0;
         if(!this.havestart)
         {
            valuetime = int(event.bytesTotal);
            valuetime = valuetime < 6000 ? 6000 : valuetime;
         }
         if(this.showloading)
         {
            GreenLoading.loading.setProgress("正在加载...",event.bytesLoaded,event.bytesTotal);
         }
      }
      
      private function ioErrorHandler(event:IOErrorEvent) : void
      {
         if(this.showloading)
         {
            GreenLoading.loading.visible = false;
         }
         O.o("记载出错" + this._url + event);
      }
      
      private function addDrag() : void
      {
         this.bg.dragClip.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDownHandler);
         this.bg.dragClip.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUpHandler);
      }
      
      private function onMouseDownHandler(evt:MouseEvent) : void
      {
         this.startDrag();
         stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMoveHandler);
      }
      
      private function onMouseUpHandler(evt:MouseEvent) : void
      {
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMoveHandler);
         this.stopDrag();
      }
      
      private function onMouseMoveHandler(event:MouseEvent) : void
      {
         if(stage == null)
         {
            this.stopDrag();
            return;
         }
         if(stage.mouseX < 0 || stage.mouseX > 970 || stage.mouseY < 0 || stage.mouseY > 570)
         {
            stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMoveHandler);
            this.stopDrag();
         }
      }
      
      public function setShow() : void
      {
         this.getserverdata();
      }
      
      public function show(parent:DisplayObjectContainer, x:int = 300, y:int = 60) : void
      {
         this.x = x;
         this.y = y;
         parent.addChild(this);
      }
      
      public function parentRemove(b:Boolean = false) : void
      {
         this.datepass = true;
         try
         {
            if(Boolean(this.parent))
            {
               if(this.parent is Loader)
               {
                  Loader(this.parent).unloadAndStop(false);
               }
               else if(Boolean(this.parent) && this.parent.contains(this))
               {
                  if(b)
                  {
                     this.parent.removeChild(this);
                  }
                  else
                  {
                     this.parent.removeChild(this);
                  }
               }
            }
         }
         catch(e:*)
         {
            O.o("【HloaderSprite累积起来的将就太多了】" + e);
         }
      }
      
      public function disport() : void
      {
         var display:DisplayObject = null;
         WindowLayer.instance.mouseEnabled = false;
         this.stoptime("");
         if(this.showloading)
         {
            GreenLoading.loading.visible = false;
         }
         if(this.bg)
         {
            if(this.contains(this.bg))
            {
               if(this.bg is MovieClip)
               {
                  MovieClip(this.bg).stop();
               }
               this.removeChild(this.bg);
            }
         }
         this.bg = null;
         if(Boolean(this.loader))
         {
            this.loader.removeEventListener(Event.COMPLETE,this.loadComponent);
            this.loader.removeEventListener(ProgressEvent.PROGRESS,this.onLoadProgressHandler);
            this.loader.removeEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
            if(this.loader.hasOwnProperty("unloadAndStop"))
            {
               this.loader.unloadAndStop();
            }
            else
            {
               this.loader.unload();
            }
         }
         this.loader = null;
         if(Boolean(this.innerMask) && this.contains(this.innerMask))
         {
            this.removeChild(this.innerMask);
            this.innerMask.graphics.clear();
            this.innerMask = null;
         }
         if(Boolean(this.oinnerMask) && this.contains(this.oinnerMask))
         {
            this.removeChild(this.oinnerMask);
            this.oinnerMask.graphics.clear();
            this.oinnerMask = null;
         }
         if(Boolean(this._btnList))
         {
            for each(display in this._btnList)
            {
               if(display is RectButton)
               {
                  (display as RectButton).onRemoveRect();
               }
            }
            this._btnList = null;
         }
         this.parentRemove(true);
      }
      
      public function setCircleMask(maskParent:*, mr:int, mx:int = 0, my:int = 0, color:uint = 16711680) : void
      {
         this.innerMask = new Sprite();
         this.innerMask.graphics.clear();
         this.innerMask.graphics.beginFill(color,1);
         this.innerMask.graphics.drawCircle(mx,my,mr);
         this.innerMask.graphics.endFill();
         if(maskParent)
         {
            maskParent.mask = this.innerMask;
         }
         this.addChild(this.innerMask);
      }
      
      public function setOCircleMask(maskParent:*, mr:int, mx:int = 0, my:int = 0, color:uint = 16711680) : void
      {
         this.oinnerMask = new Sprite();
         this.oinnerMask.graphics.clear();
         this.oinnerMask.graphics.beginFill(color,1);
         this.oinnerMask.graphics.drawCircle(mx,my,mr);
         this.oinnerMask.graphics.endFill();
         if(maskParent)
         {
            maskParent.mask = this.oinnerMask;
         }
         this.addChild(this.oinnerMask);
      }
      
      private function starttime(value:int) : void
      {
         if(Boolean(this.mytimer) && !this.havestart)
         {
            this.mytimer.stop();
            this.mytimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerCompHandler);
            this.mytimer = null;
         }
         if(!this.havestart)
         {
            this.havestart = true;
            this.mytimer = new Timer(value,1);
            this.mytimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerCompHandler);
            this.mytimer.start();
         }
      }
      
      private function onTimerCompHandler(event:TimerEvent) : void
      {
         this.stoptime("ontimercomphandler");
      }
      
      private function stoptime(str:String) : void
      {
         if(Boolean(this.mytimer))
         {
            this.mytimer.stop();
            this.mytimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerCompHandler);
            this.mytimer = null;
         }
      }
      
      protected function createMyBtn(type:int, displayObj:DisplayObject, needListener:Boolean = true) : DisplayObject
      {
         var btn:DisplayObject = null;
         switch(type)
         {
            case SIMPLE_BUTTON:
               btn = displayObj;
               break;
            case RECT_BUTTON:
               btn = DisplayUtil.getRectButton(displayObj);
         }
         this._btnList.push(btn);
         if(needListener)
         {
            btn.addEventListener(MouseEvent.CLICK,this.onMyBtnMouseClick,false,0,true);
         }
         return btn;
      }
      
      protected function onMyBtnMouseClick(event:MouseEvent) : void
      {
      }
   }
}

