package com.game.dohko.view
{
   import com.core.view.ViewConLogic;
   import com.game.facade.ApplicationFacade;
   import com.game.modules.view.WindowLayer;
   import com.game.util.GameDynamicUI;
   import com.publiccomponent.URLUtil;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLRequest;
   
   public class BaseDisplay extends Sprite
   {
      
      public static const LOAD_FIRST:int = 1;
      
      public static const SET_PARAM_FIRST:int = 2;
      
      private var _loader:Loader;
      
      private var _retryCount:int;
      
      private var _resUrl:String;
      
      public var mainUI:MovieClip;
      
      private var _moduleParams:Object;
      
      public var isLoaded:Boolean = false;
      
      private var _needLoaded:Boolean = true;
      
      public function BaseDisplay()
      {
         super();
      }
      
      protected function setUrl(url:String, showLoading:Boolean = true, retry:int = 3) : void
      {
         if(showLoading)
         {
            GameDynamicUI.addUI(WindowLayer.instance,200,200,"loading");
         }
         this._loader = new Loader();
         this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoadedHandler);
         this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onIoErrorHandler);
         this._resUrl = URLUtil.getSvnVer(url);
         this._retryCount = retry;
         this._loader.load(new URLRequest(this._resUrl));
      }
      
      private function onLoadedHandler(evt:Event) : void
      {
         this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoadedHandler);
         this._loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onIoErrorHandler);
         this.mainUI = this._loader.content as MovieClip;
         this._loader.unload();
         this._loader = null;
         if(this.mainUI != null)
         {
            this.mainUI.cacheAsBitmap = true;
            this.addChildAt(this.mainUI,0);
            this.onViewShowed();
         }
      }
      
      private function onIoErrorHandler(evt:IOErrorEvent) : void
      {
         --this._retryCount;
         if(this._retryCount < 0)
         {
            this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoadedHandler);
            this._loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onIoErrorHandler);
            this._loader = null;
         }
         else
         {
            this._loader.load(new URLRequest(this._resUrl));
         }
      }
      
      protected function onViewShowed() : void
      {
         GameDynamicUI.removeUI("loading");
         this.isLoaded = true;
         if(this._moduleParams != null && this._needLoaded)
         {
            this.refreshView();
         }
      }
      
      public function registerControl(viewLogic:ViewConLogic, name:String) : void
      {
         if(ApplicationFacade.getInstance().hasViewLogic(name))
         {
            ApplicationFacade.getInstance().removeViewLogic(name);
         }
         ApplicationFacade.getInstance().registerViewLogic(viewLogic);
      }
      
      public function removeControl(name:String) : void
      {
         ApplicationFacade.getInstance().removeViewLogic(name);
      }
      
      public function get moduleParams() : Object
      {
         return this._moduleParams;
      }
      
      public function set loadSequence(type:int) : void
      {
         this._needLoaded = type == LOAD_FIRST;
      }
      
      public function set moduleParams(params:Object) : void
      {
         this._moduleParams = params;
         if(this.isLoaded || !this._needLoaded)
         {
            this.refreshView();
         }
      }
      
      protected function refreshView() : void
      {
      }
      
      public function dispos() : void
      {
         if(this.mainUI != null && this.mainUI.parent != null)
         {
            this.mainUI.parent.removeChild(this.mainUI);
         }
         this.mainUI = null;
         if(this._loader != null)
         {
            this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoadedHandler);
            this._loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onIoErrorHandler);
            this._loader.unload();
            this._loader = null;
         }
         if(parent != null)
         {
            parent.removeChild(this);
         }
      }
   }
}

