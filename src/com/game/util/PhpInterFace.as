package com.game.util
{
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLVariables;
   
   public class PhpInterFace
   {
      
      private var callBack:Function;
      
      private var urlLoader:URLLoader;
      
      public function PhpInterFace()
      {
         super();
         this.urlLoader = new URLLoader();
         this.urlLoader.addEventListener(Event.COMPLETE,this.onLoaded);
         this.urlLoader.addEventListener(IOErrorEvent.IO_ERROR,this.onIoErrorHandler);
      }
      
      public function getData(url:String, data:URLVariables, handler:Function = null, method:String = "POST") : void
      {
         this.callBack = handler;
         var urlRequest:URLRequest = new URLRequest(url);
         urlRequest.data = data;
         urlRequest.method = method;
         this.urlLoader.load(urlRequest);
      }
      
      private function onIoErrorHandler(e:IOErrorEvent) : void
      {
      }
      
      private function onLoaded(evt:Event) : void
      {
         if(this.callBack != null)
         {
            this.callBack.apply(null,[this.urlLoader.data]);
         }
      }
      
      public function dispos() : void
      {
         if(Boolean(this.urlLoader))
         {
            this.urlLoader.removeEventListener(Event.COMPLETE,this.onLoaded);
            this.urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.onIoErrorHandler);
         }
         this.urlLoader = null;
      }
   }
}

