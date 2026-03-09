package org.engine.util
{
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.utils.ByteArray;
   
   public class ConfigLoader
   {
      
      private var urlLoader:URLLoader;
      
      private var maxCount:int = 3;
      
      private var url:String;
      
      private var successBack:Function;
      
      public function ConfigLoader()
      {
         super();
         this.urlLoader = new URLLoader();
         this.urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
         this.urlLoader.addEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
         this.urlLoader.addEventListener(Event.COMPLETE,this.onLoaded);
      }
      
      public function loadConfig(configURL:String, successBack:Function, maxTempCount:int = 3) : void
      {
         this.url = configURL;
         this.successBack = successBack;
         this.maxCount = maxTempCount;
         this.urlLoader.load(new URLRequest(configURL));
      }
      
      private function ioErrorHandler(evt:IOErrorEvent) : void
      {
         if(this.maxCount > 0)
         {
            --this.maxCount;
            this.urlLoader.load(new URLRequest(this.url));
         }
      }
      
      private function onLoaded(evt:Event) : void
      {
         var byte:ByteArray = ByteArray(this.urlLoader.data);
         byte.uncompress();
         if(this.successBack != null)
         {
            this.successBack(byte);
         }
      }
      
      public function dispos() : void
      {
         if(Boolean(this.urlLoader))
         {
            this.urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
            this.urlLoader.removeEventListener(Event.COMPLETE,this.onLoaded);
         }
         this.urlLoader = null;
      }
   }
}

