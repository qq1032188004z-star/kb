package com.game.util
{
   import com.publiccomponent.URLUtil;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   
   public class PropertyLoader
   {
      
      private var urlLoader:URLLoader;
      
      private var keyCode:String;
      
      private var xmlList:Dictionary;
      
      private var callback:Function;
      
      private var args:Array;
      
      private var url:String;
      
      private var keyList:Array;
      
      private var index:int = 0;
      
      public function PropertyLoader()
      {
         super();
         this.urlLoader = new URLLoader();
         this.urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
         this.urlLoader.addEventListener(Event.COMPLETE,this.onLoadComplete);
         this.urlLoader.addEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
      }
      
      public function startLoad(url:String, keyCode:String, keyList:Array, callback:Function, rest:Array = null) : void
      {
         if(url == "")
         {
            return;
         }
         this.url = url;
         this.keyCode = keyCode;
         this.keyList = keyList;
         this.callback = callback;
         this.args = rest;
         this.index = 0;
         this.xmlList = new Dictionary(true);
         this.loadSingle();
      }
      
      private function loadSingle() : void
      {
         if(this.index == this.keyList.length)
         {
            this.apply();
         }
         else
         {
            this.load(this.url + this.keyList[this.index]);
            ++this.index;
         }
      }
      
      private function load(url:String) : void
      {
         this.urlLoader.load(new URLRequest(URLUtil.getSvnVer(url)));
      }
      
      private function onLoadComplete(evt:Event) : void
      {
         evt.stopImmediatePropagation();
         var ba:ByteArray = this.urlLoader.data as ByteArray;
         ba.uncompress();
         var str:String = "";
         ba.position = 0;
         str = ba.readUTFBytes(ba.length);
         ba.clear();
         var xml:XML = new XML(str);
         this.xmlList[this.keyList[this.index - 1]] = xml;
         this.loadSingle();
      }
      
      private function onLoadError(evt:IOErrorEvent) : void
      {
         evt.stopImmediatePropagation();
         this.xmlList[this.keyList[this.index - 1]] = null;
         this.loadSingle();
      }
      
      private function apply() : void
      {
         if(this.callback == null)
         {
            return;
         }
         this.callback.apply(null,[this.keyCode,this.keyList,this.xmlList,this.args]);
         this.disport();
      }
      
      private function releaseLoader() : void
      {
         if(this.urlLoader == null)
         {
            return;
         }
         this.urlLoader.removeEventListener(Event.COMPLETE,this.onLoadComplete);
         this.urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
         this.urlLoader.close();
         this.urlLoader = null;
      }
      
      private function disport() : void
      {
         this.releaseLoader();
         this.callback = null;
         this.keyCode = "";
         this.keyList = null;
         this.xmlList = null;
         this.args = null;
      }
   }
}

