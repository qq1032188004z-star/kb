package com.publiccomponent.loading
{
   import com.game.util.PoolObject;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.utils.getTimer;
   
   public class Hloader extends Hload
   {
      
      private var _loader:Loader;
      
      private var _isEncryption:Boolean;
      
      protected var _appDomain:ApplicationDomain;
      
      public function Hloader(url:String = "", loadinfo:Object = null, context:LoaderContext = null, isEncryption:Boolean = false)
      {
         super();
         this._isEncryption = isEncryption;
         this.loadinfo = loadinfo;
         this.loadcontext = context;
         if(this._loader == null)
         {
            this._loader = new Loader();
         }
         if(url != "")
         {
            this.url = url;
         }
      }
      
      override public function reload() : void
      {
         HloadManager.instance.removeFromCheck(this);
         if(Boolean(this.loader))
         {
            this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoaderCompHandler);
            this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoaderIoError);
            this.loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,this.onLoadProgress);
            this.loader.contentLoaderInfo.removeEventListener(Event.UNLOAD,this.onLoaderUnload);
            this.loader.unload();
         }
         this.exeload();
      }
      
      private function onLoadProgress(event:ProgressEvent) : void
      {
         event = event;
         dispatchEvent(event);
         loaderbytes = event.bytesLoaded;
         try
         {
            GreenLoading.loading.setProgress("正在加载...",event.bytesLoaded,event.bytesTotal);
         }
         catch(e:Error)
         {
         }
      }
      
      public function unloadAndStop(value:Boolean = false) : void
      {
         var _local3:* = undefined;
         value = value;
         this.delload();
         HloadManager.instance.removeFromCheck(this);
         try
         {
            _local3 = this.loader;
            _local3["unloadAndStop"]();
            this.loader.unload();
         }
         catch(error:Error)
         {
         }
         this._loader = null;
      }
      
      public function get content() : DisplayObject
      {
         if(Boolean(this.loader) && Boolean(this.loader.content))
         {
            return this.loader.content;
         }
         return null;
      }
      
      private function onLoaderCompHandler(event:Event) : void
      {
         HloadManager.instance.removeFromCheck(this);
         this._appDomain = this.loader.contentLoaderInfo.applicationDomain;
         this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoaderCompHandler);
         this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoaderIoError);
         this.loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,this.onLoadProgress);
         this.loader.contentLoaderInfo.removeEventListener(Event.UNLOAD,this.onLoaderUnload);
         if(this.loader.contentLoaderInfo.bytesTotal != this.loader.contentLoaderInfo.bytesLoaded)
         {
            this.extendsver = "" + getTimer();
            this.reload();
         }
         else
         {
            dispatchEvent(event);
         }
      }
      
      public function getInstanceByClass(className:String) : Object
      {
         if(Boolean(this._appDomain))
         {
            return new (this._appDomain.getDefinition(className) as Class)();
         }
         return null;
      }
      
      private function onLoaderIoError(event:IOErrorEvent) : void
      {
         if(this.loadtimes == this.loadMaxTimes)
         {
            HloadManager.instance.removeFromCheck(this);
            try
            {
               this.delload();
               dispatchEvent(event);
            }
            catch(error:Error)
            {
            }
         }
         else
         {
            this.reload();
         }
      }
      
      private function delload() : void
      {
         if(Boolean(this.loader))
         {
            this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoaderCompHandler);
            this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoaderIoError);
            this.loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,this.onLoadProgress);
            this.loader.contentLoaderInfo.removeEventListener(Event.UNLOAD,this.onLoaderUnload);
         }
      }
      
      override public function exeload() : void
      {
         ++this.loadtimes;
         if(Boolean(this.loader))
         {
            this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoaderCompHandler,false,0,true);
            this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onLoaderIoError,false,0,true);
            this.loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.onLoadProgress,false,0,true);
            this.loader.contentLoaderInfo.addEventListener(Event.UNLOAD,this.onLoaderUnload,false,0,true);
            HloadManager.instance.addToCheck(this);
            if(this._isEncryption)
            {
               this.urlLoader.load(new URLRequest(this.url));
            }
            else if(this.extendsver == "")
            {
               this.loader.load(new URLRequest(this.url),this.loadcontext);
            }
            else if(this.url.indexOf("?") == -1)
            {
               this.loader.load(new URLRequest(this.url + "?v=" + this.extendsver),this.loadcontext);
            }
            else
            {
               this.loader.load(new URLRequest(this.url + this.extendsver),this.loadcontext);
            }
         }
      }
      
      public function get urlLoader() : URLLoader
      {
         var urlLoader:URLLoader = new URLLoader();
         urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
         urlLoader.addEventListener(Event.COMPLETE,this.onBytesLoadedHandler);
         return urlLoader;
      }
      
      public function onBytesLoadedHandler(e:Event) : void
      {
         var urlLoader:URLLoader = e.currentTarget as URLLoader;
         urlLoader.removeEventListener(Event.COMPLETE,this.onBytesLoadedHandler);
         this.loader.loadBytes(PoolObject.instance.encrypeTool(urlLoader.data),this.loadcontext);
      }
      
      public function get loader() : Loader
      {
         if(this._loader == null)
         {
            this._loader = new Loader();
         }
         return this._loader;
      }
      
      public function get contentLoaderInfo() : LoaderInfo
      {
         if(Boolean(this.loader) && Boolean(this.loader.contentLoaderInfo))
         {
            return this.loader.contentLoaderInfo;
         }
         return null;
      }
      
      private function onLoaderUnload(event:Event) : void
      {
      }
      
      public function unload() : void
      {
         this.delload();
         HloadManager.instance.removeFromCheck(this);
         try
         {
            this._loader.unload();
         }
         catch(error:Error)
         {
         }
         this._loader = null;
      }
   }
}

