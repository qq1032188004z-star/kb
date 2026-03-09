package com.game.util
{
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.loading.GreenLoading;
   import com.publiccomponent.loading.HurlLoader;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   
   public class OldBaseSprite extends Sprite
   {
      
      private var loader:Loader;
      
      private var url:String;
      
      private var count:int;
      
      protected var urlloader:HurlLoader;
      
      protected var bg:MovieClip;
      
      private var loadLabel:String;
      
      public var _callback:Function;
      
      public var domain:ApplicationDomain;
      
      public function OldBaseSprite()
      {
         super();
         this.graphics.beginFill(0,0.6);
         this.graphics.drawRect(-1000,-1000,2000,2000);
         this.graphics.endFill();
         this.loader = new Loader();
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoaded);
         this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.ioError);
         this.loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.onProgress);
      }
      
      public function applyData(data:Object) : void
      {
         if(this._callback != null)
         {
            this._callback(data);
         }
      }
      
      protected function setURL(url:String, loadLabel:String = "", count:int = 3) : void
      {
         this.url = URLUtil.getSvnVer(url);
         this.count = count;
         this.loadLabel = loadLabel;
         GreenLoading.loading.visible = true;
         this.loader.load(new URLRequest(this.url));
      }
      
      private function onLoaded(evt:Event) : void
      {
         this.domain = evt.currentTarget.applicationDomain;
         GreenLoading.loading.setCloseBtnShow(false);
         GreenLoading.loading.visible = false;
         this.bg = this.loader.content as MovieClip;
         if(this.bg != null)
         {
            this.bg.cacheAsBitmap = true;
            addChild(this.bg);
            this.setShow();
         }
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
            GreenLoading.loading.setCloseBtnShow(false);
            GreenLoading.loading.visible = false;
         }
      }
      
      private function onProgress(evt:ProgressEvent) : void
      {
         GreenLoading.loading.visible = true;
         GreenLoading.loading.setProgress("正在加载....",evt.bytesLoaded,evt.bytesTotal);
      }
      
      protected function setShow() : void
      {
      }
      
      public function start(callback:Function) : void
      {
         this._callback = callback;
      }
      
      public function apply(data:Object) : void
      {
         if(this._callback != null)
         {
            this._callback(data);
         }
      }
      
      public function getMovieClipByName(name:String) : MovieClip
      {
         var cls:Class = null;
         if(this.domain.hasDefinition(name))
         {
            cls = this.domain.getDefinition(name) as Class;
            return new cls() as MovieClip;
         }
         return null;
      }
      
      public function getClassByName(name:String) : Class
      {
         var cls:Class = null;
         if(this.domain.hasDefinition(name))
         {
            return this.domain.getDefinition(name) as Class;
         }
         return null;
      }
      
      public function disport() : void
      {
         this._callback = null;
         this.domain = null;
         this.graphics.clear();
         GreenLoading.loading.setCloseBtnShow(false);
         GreenLoading.loading.visible = false;
         if(this.loader != null)
         {
            this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoaded);
            this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.ioError);
            this.loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,this.onProgress);
            this.loader.unloadAndStop(false);
         }
         if(Boolean(this.urlloader))
         {
            this.urlloader.close();
         }
         this.urlloader = null;
         this.loader = null;
         if(this.bg != null)
         {
            if(Boolean(this.bg.parent))
            {
               this.bg.parent.removeChild(this.bg);
            }
         }
         this.bg = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

