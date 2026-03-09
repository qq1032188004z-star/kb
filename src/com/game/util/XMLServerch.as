package com.game.util
{
   import com.publiccomponent.URLUtil;
   import flash.events.Event;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   
   public class XMLServerch
   {
      
      public static var instance:XMLServerch = new XMLServerch();
      
      private var urlLoader:URLLoader;
      
      private var urlRequest:URLRequest;
      
      private var callBack:Function;
      
      private var _key:String;
      
      private var _xmlDic:Dictionary = new Dictionary();
      
      public function XMLServerch()
      {
         super();
         this.urlLoader = new URLLoader();
         this.urlRequest = new URLRequest();
         this.urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
         this.urlLoader.addEventListener(Event.COMPLETE,this.onLoaded);
      }
      
      public function searchXML(url:String, callBack:Function, key:String = "") : void
      {
         this.callBack = callBack;
         this._key = key;
         url = URLUtil.getSvnVer(url);
         if(this._xmlDic.hasOwnProperty(url))
         {
            this.onCallBack(url);
         }
         else
         {
            this.urlRequest.url = url;
            this.urlLoader.load(this.urlRequest);
         }
      }
      
      public function onCallBack(url:String) : void
      {
         var target:ByteArray = null;
         var xml:XML = null;
         var result:XML = null;
         if(this._xmlDic.hasOwnProperty(url))
         {
            target = new ByteArray();
            this._xmlDic[url].position = 0;
            while(this._xmlDic[url].bytesAvailable > 0)
            {
               target.writeByte(this._xmlDic[url].readByte());
            }
            target.position = 0;
            xml = new XML(target.readUTFBytes(target.length));
            if(this._key != "")
            {
               result = xml.children().(@id == _key)[0] as XML;
               if(this.callBack != null)
               {
                  this.callBack.apply(null,[result]);
               }
            }
            else if(this.callBack != null)
            {
               this.callBack.apply(null,[xml]);
            }
         }
      }
      
      private function onLoaded(evt:Event) : void
      {
         var byte:ByteArray = ByteArray(this.urlLoader.data);
         byte.uncompress();
         this._xmlDic[this.urlRequest.url] = byte;
         this.onCallBack(this.urlRequest.url);
      }
   }
}

