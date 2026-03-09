package com.publiccomponent.loading
{
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.utils.getTimer;
   
   public class HurlLoader extends Hload
   {
      
      protected var _urlloader:URLLoader;
      
      private var udf:String;
      
      public function HurlLoader(url:String = "", loadinfo:Object = null, df:String = "text")
      {
         super();
         this.loadinfo = loadinfo;
         this.udf = df;
         if(this._urlloader == null)
         {
            this._urlloader = new URLLoader();
         }
         if(url != "")
         {
            this.url = url;
         }
      }
      
      override public function reload() : void
      {
         HloadManager.instance.removeFromCheck(this);
         if(Boolean(this.urlloader))
         {
            this.urlloader.removeEventListener(Event.COMPLETE,this.onLoaderCompHandler);
            this.urlloader.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoaderIoError);
            this.urlloader.removeEventListener(ProgressEvent.PROGRESS,this.onLoadProgress);
            this.urlloader.removeEventListener(Event.UNLOAD,this.onLoaderUnload);
         }
         this.urlloader.close();
         this.exeload();
      }
      
      public function get urlloader() : URLLoader
      {
         if(this._urlloader == null)
         {
            this._urlloader = new URLLoader();
         }
         return this._urlloader;
      }
      
      protected function onLoaderCompHandler(event:Event) : void
      {
         HloadManager.instance.removeFromCheck(this);
         this.urlloader.removeEventListener(Event.COMPLETE,this.onLoaderCompHandler);
         this.urlloader.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoaderIoError);
         this.urlloader.removeEventListener(ProgressEvent.PROGRESS,this.onLoadProgress);
         this.urlloader.removeEventListener(Event.UNLOAD,this.onLoaderUnload);
         if(this.urlloader.bytesTotal == this.urlloader.bytesLoaded)
         {
            dispatchEvent(event);
         }
         else
         {
            this.extendsver = "" + getTimer();
            this.reload();
         }
      }
      
      public function get data() : Object
      {
         return this.urlloader.data;
      }
      
      public function disport() : void
      {
         HloadManager.instance.removeFromCheck(this);
         if(Boolean(this.urlloader))
         {
            this.delload();
            this.urlloader.close();
         }
         this._urlloader = null;
      }
      
      private function onLoaderIoError(event:IOErrorEvent) : void
      {
         event = event;
         if(this.loadtimes == this.loadMaxTimes)
         {
            HloadManager.instance.removeFromCheck(this);
            try
            {
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
      
      private function onLoaderUnload(event:Event) : void
      {
         this.urlloader.close();
      }
      
      private function onLoadProgress(event:ProgressEvent) : void
      {
         dispatchEvent(event);
         loaderbytes = event.bytesLoaded;
         GreenLoading.loading.setProgress("正在加载...",event.bytesLoaded,event.bytesTotal);
      }
      
      override public function exeload() : void
      {
         ++this.loadtimes;
         this.urlloader.dataFormat = this.udf;
         this.urlloader.addEventListener(Event.COMPLETE,this.onLoaderCompHandler);
         this.urlloader.addEventListener(IOErrorEvent.IO_ERROR,this.onLoaderIoError);
         this.urlloader.addEventListener(ProgressEvent.PROGRESS,this.onLoadProgress);
         this.urlloader.addEventListener(Event.UNLOAD,this.onLoaderUnload);
         HloadManager.instance.addToCheck(this);
         if(this.extendsver == "")
         {
            this.urlloader.load(new URLRequest(this.url));
         }
         else if(this.url.indexOf("?") == -1)
         {
            this.urlloader.load(new URLRequest(this.url + "?v=" + this.extendsver));
         }
         else
         {
            this.urlloader.load(new URLRequest(this.url + this.extendsver));
         }
      }
      
      private function delload() : void
      {
         this.urlloader.removeEventListener(Event.COMPLETE,this.onLoaderCompHandler);
         this.urlloader.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoaderIoError);
         this.urlloader.removeEventListener(ProgressEvent.PROGRESS,this.onLoadProgress);
         this.urlloader.removeEventListener(Event.UNLOAD,this.onLoaderUnload);
      }
      
      public function close() : void
      {
         if(Boolean(this.urlloader))
         {
            this.delload();
            this.urlloader.close();
         }
      }
   }
}

