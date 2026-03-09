package com.game.util
{
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.loading.GreenLoading;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.net.URLRequest;
   
   public class BaseModuleView extends Sprite
   {
      
      private var loader:Loader;
      
      private var path:String;
      
      private var count:int;
      
      protected var bg:MovieClip;
      
      private var loadLabel:String;
      
      public function BaseModuleView()
      {
         super();
      }
      
      override public function set visible(value:Boolean) : void
      {
         if(Boolean(this.bg))
         {
            super.visible = value;
            if(value && !contains(this.bg))
            {
               addChild(this.bg);
            }
            else if(!value && contains(this.bg))
            {
               removeChild(this.bg);
            }
         }
      }
      
      public function setURL(url:String, loadLabel:String = "正在加载....", count:int = 3) : void
      {
         if(url.indexOf("?") == -1)
         {
            this.path = URLUtil.getSvnVer(url);
         }
         else
         {
            this.path = url;
         }
         this.count = count;
         this.loadLabel = loadLabel;
         this.loader = new Loader();
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onCompleteHandler);
         this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onIoErrorHandler);
         this.loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.onProgressHandler);
         this.loader.load(new URLRequest(this.path));
      }
      
      private function onCompleteHandler(e:Event) : void
      {
         e.stopImmediatePropagation();
         GreenLoading.loading.setCloseBtnShow(false);
         GreenLoading.loading.visible = false;
         this.bg = this.loader.content as MovieClip;
         if(this.bg != null)
         {
            this.bg.cacheAsBitmap = true;
            addChild(this.bg);
            this.initialize();
            this.onRegister();
         }
      }
      
      protected function initialize() : void
      {
      }
      
      protected function onRegister() : void
      {
      }
      
      protected function onRemove() : void
      {
      }
      
      private function onIoErrorHandler(e:IOErrorEvent) : void
      {
         e.stopImmediatePropagation();
         if(this.count >= 0)
         {
            --this.count;
            this.loader.load(new URLRequest(this.path));
         }
         else
         {
            GreenLoading.loading.setCloseBtnShow(false);
            GreenLoading.loading.visible = false;
         }
      }
      
      private function onProgressHandler(evt:ProgressEvent) : void
      {
         evt.stopImmediatePropagation();
         GreenLoading.loading.visible = true;
         GreenLoading.loading.setProgress(this.loadLabel,evt.bytesLoaded,evt.bytesTotal);
      }
      
      public function disport() : void
      {
         GreenLoading.loading.setCloseBtnShow(false);
         GreenLoading.loading.visible = false;
         if(this.loader != null)
         {
            this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onCompleteHandler);
            this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onIoErrorHandler);
            this.loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,this.onProgressHandler);
            this.loader.unloadAndStop(false);
            this.loader = null;
         }
         if(Boolean(this.bg))
         {
            this.bg.stop();
            if(Boolean(this.bg.parent))
            {
               this.bg.parent.removeChild(this.bg);
            }
            this.bg = null;
         }
         if(Boolean(this.parent))
         {
            if(this.parent is Loader)
            {
               (this.parent as Loader).unloadAndStop();
            }
            else
            {
               this.parent.removeChild(this);
            }
         }
      }
   }
}

