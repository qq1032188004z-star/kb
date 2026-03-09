package com.xygame.module.battle.util
{
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.loading.XMLLocator;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   
   public class SpiritXmlData
   {
      
      private static var _instance:SpiritXmlData;
      
      private static var _spiritDic:Dictionary;
      
      private static var bossCount:int = 215;
      
      private var spiritXmlLoader:URLLoader;
      
      private var spiritXml:XMLList;
      
      private var spiritXmlUrl:String = URLUtil.getSvnVer("config/spiritdata");
      
      private var spiritXmlBool:Boolean;
      
      private var xmlcallbacklist:Array = [];
      
      public function SpiritXmlData()
      {
         _spiritDic = new Dictionary();
         super();
      }
      
      public static function spirititem(targetId:String) : XML
      {
         var mid:int = 0;
         var currentItem:XML = null;
         var currentId:int = 0;
         if(_instance.spiritXml == null)
         {
            return null;
         }
         if(_spiritDic.hasOwnProperty(targetId))
         {
            return _spiritDic[targetId];
         }
         var xmlList:XMLList = _instance.spiritXml.children();
         var low:int = 0;
         var high:int = xmlList.length() - 1;
         while(low <= high)
         {
            mid = Math.floor((low + high) / 2);
            currentItem = xmlList[mid];
            currentId = int(currentItem.attribute("id"));
            if(currentId == int(targetId))
            {
               _spiritDic[targetId] = currentItem;
               return currentItem;
            }
            if(currentId < int(targetId))
            {
               low = mid + 1;
            }
            else
            {
               high = mid - 1;
            }
         }
         return null;
      }
      
      public static function get instance() : SpiritXmlData
      {
         if(_instance == null)
         {
            _instance = new SpiritXmlData();
         }
         return _instance;
      }
      
      private function onXmlLoaderComp(event:Event) : void
      {
         var cb:Function = null;
         this.spiritXmlLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.onIoErrorHandler);
         this.spiritXmlLoader.removeEventListener(Event.COMPLETE,this.onXmlLoaderComp);
         var bytesarray:ByteArray = this.spiritXmlLoader.data;
         bytesarray.uncompress();
         this.spiritXml = new XMLList(bytesarray);
         this.spiritXmlBool = true;
         while(this.xmlcallbacklist.length > 0)
         {
            cb = this.xmlcallbacklist.shift();
            cb.call(null,this.spiritXml);
         }
      }
      
      private function onIoErrorHandler(event:IOErrorEvent) : void
      {
         this.loadXml();
      }
      
      private function loadXml() : void
      {
         if(Boolean(this.spiritXmlLoader))
         {
            this.spiritXmlBool = false;
            this.spiritXmlLoader.removeEventListener(Event.COMPLETE,this.onXmlLoaderComp);
            this.spiritXmlLoader = null;
         }
         this.spiritXmlLoader = new URLLoader();
         this.spiritXmlLoader.dataFormat = URLLoaderDataFormat.BINARY;
         this.spiritXmlLoader.addEventListener(Event.COMPLETE,this.onXmlLoaderComp);
         this.spiritXmlLoader.addEventListener(IOErrorEvent.IO_ERROR,this.onIoErrorHandler);
         this.spiritXmlLoader.load(new URLRequest(this.spiritXmlUrl));
      }
      
      public function spiritXmlData(callback:Function) : void
      {
         if(this.spiritXmlBool)
         {
            callback.call(null,this.spiritXml);
         }
         else
         {
            this.xmlcallbacklist.push(callback);
            this.loadXml();
         }
      }
      
      public function attrInfo(attElem:int, defElem:int) : int
      {
         return int(XMLLocator.getInstance().getNature(2,(attElem + 1).toString(),(defElem + 1).toString()));
      }
   }
}

