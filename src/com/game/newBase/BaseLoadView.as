package com.game.newBase
{
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.loading.GreenLoading;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.net.URLRequest;
   
   public class BaseLoadView extends BaseSprite
   {
      
      private var loader:Loader;
      
      private var url:String;
      
      private var count:int;
      
      private var loadLabel:String;
      
      public var _callback:Function;
      
      private var _isShowLoading:Boolean;
      
      public function BaseLoadView(url:String, isShowLoading:Boolean = true, dis:IEventDispatcher = null, bgAlpha:Number = 0.4)
      {
         super();
         _dis = dis;
         this._isShowLoading = isShowLoading;
         this.graphics.beginFill(0,bgAlpha);
         this.graphics.drawRect(-1000,-1000,2000,2000);
         this.graphics.endFill();
         this.loader = new Loader();
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoaded);
         this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.ioError);
         this.loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.onProgress);
         this.setURL(url);
      }
      
      protected function setURL(url:String, loadLabel:String = "", count:int = 3) : void
      {
         this.url = URLUtil.getSvnVer(url);
         this.count = count;
         this.loadLabel = loadLabel;
         GreenLoading.loading.visible = this._isShowLoading;
         this.loader.load(new URLRequest(this.url));
      }
      
      private function onLoaded(evt:Event) : void
      {
         this.onLoadingHide();
         initSkin(evt.currentTarget.applicationDomain,"uiSkin");
      }
      
      private function ioError(evt:IOErrorEvent) : void
      {
         if(this.count >= 0)
         {
            --this.count;
            this.loader.load(new URLRequest(this.url));
         }
         else
         {
            this.onLoadingHide();
         }
      }
      
      private function onProgress(evt:ProgressEvent) : void
      {
         if(GreenLoading.loading.visible)
         {
            GreenLoading.loading.setProgress("正在加载....",evt.bytesLoaded,evt.bytesTotal);
         }
      }
      
      public function start(callback:Function) : void
      {
         this._callback = callback;
      }
      
      public function apply(code:int) : void
      {
         if(this._callback != null)
         {
            this._callback(code);
         }
      }
      
      override public function disport() : void
      {
         this._callback = null;
         this.onLoadingHide();
         if(this.loader != null)
         {
            this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoaded);
            this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.ioError);
            this.loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,this.onProgress);
            this.loader.unloadAndStop(false);
            this.loader = null;
         }
         super.disport();
      }
      
      private function onLoadingHide() : void
      {
         if(GreenLoading.loading.visible)
         {
            GreenLoading.loading.setCloseBtnShow(false);
            GreenLoading.loading.visible = false;
         }
      }
   }
}

