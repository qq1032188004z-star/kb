package org.engine.map
{
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.net.URLRequest;
   import flash.utils.ByteArray;
   import org.zip.FZip;
   import org.zip.FZipErrorEvent;
   
   public class MapIO
   {
      
      private var fzip:FZip;
      
      private var callBack:Function;
      
      private var _url:String;
      
      private var progressBack:Function;
      
      private var parseError:Function;
      
      public function MapIO(fileEncoding:String = "utf-8")
      {
         super();
         this.fzip = new FZip(fileEncoding);
         this.fzip.addEventListener(Event.COMPLETE,this.onFileLoaded);
         this.fzip.addEventListener(ProgressEvent.PROGRESS,this.onProgress);
         this.fzip.addEventListener(IOErrorEvent.IO_ERROR,this.ioError);
         this.fzip.addEventListener(FZipErrorEvent.PARSE_ERROR,this.parseError2);
      }
      
      public function loadZip(url:String, callBack:Function, progressBack:Function, parseError:Function) : void
      {
         this._url = url;
         this.callBack = callBack;
         this.progressBack = progressBack;
         this.parseError = parseError;
         this.fzip.load(new URLRequest(url));
      }
      
      public function get url() : String
      {
         return this._url;
      }
      
      private function parseError2(evt:FZipErrorEvent) : void
      {
         if(this.parseError != null)
         {
            this.parseError();
         }
      }
      
      private function onProgress(e:ProgressEvent) : void
      {
         this.progressBack(e.bytesLoaded,e.bytesTotal);
      }
      
      private function ioError(evt:IOErrorEvent) : void
      {
         if(this.parseError != null)
         {
            this.parseError();
         }
      }
      
      private function onFileLoaded(evt:Event) : void
      {
         this.callBack.apply(null,["ok"]);
      }
      
      public function getFileByName(name:String) : ByteArray
      {
         var ba:ByteArray = new ByteArray();
         try
         {
            ba = this.fzip.getFileByName(name).content;
         }
         catch(e:*)
         {
         }
         return ba;
      }
      
      public function getFileCount() : int
      {
         return this.fzip.getFileCount();
      }
      
      public function close() : void
      {
         this.fzip.close();
      }
   }
}

