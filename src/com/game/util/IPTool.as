package com.game.util
{
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   
   public class IPTool
   {
      
      private var urlLoader:URLLoader;
      
      private var successBack:Function;
      
      private var failBack:Function;
      
      public function IPTool()
      {
         super();
         this.urlLoader = new URLLoader();
         this.urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
         this.urlLoader.addEventListener(Event.COMPLETE,this.onLoaded);
         this.urlLoader.addEventListener(IOErrorEvent.IO_ERROR,this.ioError);
      }
      
      private function onLoaded(evt:Event) : void
      {
         this.urlLoader.removeEventListener(Event.COMPLETE,this.onLoaded);
         this.urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.ioError);
         var result:String = String(this.urlLoader.data);
         var centerIndex:int = result.lastIndexOf("</center>");
         var kuoIndex:int = result.lastIndexOf("[");
         var ip:String = result.substr(kuoIndex + 1,centerIndex - kuoIndex - 3);
         if(this.successBack != null)
         {
            this.successBack.apply(null,[ip]);
         }
      }
      
      private function ioError(evt:Event) : void
      {
         this.urlLoader.removeEventListener(Event.COMPLETE,this.onLoaded);
         this.urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.ioError);
         if(this.failBack != null)
         {
            this.failBack.apply(null,[evt.toString()]);
         }
      }
      
      public function getClientIP(successBack:Function, failBack:Function = null) : void
      {
         this.successBack = successBack;
         this.failBack = failBack;
         this.urlLoader.load(new URLRequest("http://www.ip138.com/ip2city.asp"));
      }
   }
}

