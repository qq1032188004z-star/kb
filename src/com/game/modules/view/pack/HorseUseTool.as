package com.game.modules.view.pack
{
   import com.publiccomponent.URLUtil;
   import flash.events.Event;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.utils.*;
   
   public class HorseUseTool
   {
      
      private static var _instance:HorseUseTool;
      
      private var _horseTipsCfg:Dictionary;
      
      private var urlLoader:URLLoader;
      
      private var _searchTempId:Array;
      
      private var _callBack:Function;
      
      public function HorseUseTool()
      {
         super();
         this.urlLoader = new URLLoader();
         this.urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
         this.urlLoader.addEventListener(Event.COMPLETE,this.loadComplete);
         this.urlLoader.load(new URLRequest(URLUtil.getSvnVer("config/horse_tips")));
      }
      
      public static function get instance() : HorseUseTool
      {
         if(_instance == null)
         {
            _instance = new HorseUseTool();
         }
         return _instance;
      }
      
      public function showHorseUseFailTips(tipsId:int) : void
      {
      }
      
      private function loadComplete(evt:Event) : void
      {
         var item:XML = null;
         var bytes:ByteArray = this.urlLoader.data as ByteArray;
         bytes.uncompress();
         bytes.position = 0;
         var str:String = bytes.readUTFBytes(bytes.bytesAvailable);
         var xmlList:XMLList = new XMLList(str).children();
         this._horseTipsCfg = new Dictionary();
         var len:int = int(xmlList.length());
         for(var i:int = 0; i < len; i++)
         {
            item = xmlList[i];
            this._horseTipsCfg[int(item.@id)] = String(item);
         }
         this._horseTipsCfg[0] = "这里操作不了坐骑哦";
         if(this._callBack != null)
         {
            this.getTipsMsg(this._searchTempId,this._callBack);
         }
      }
      
      public function getTipsMsg(tipsIds:Array, callBack:Function) : void
      {
         var i:int = 0;
         var tips:String = null;
         if(this._horseTipsCfg == null)
         {
            this._searchTempId = tipsIds;
            this._callBack = callBack;
         }
         else
         {
            for(i = 0; i < tipsIds.length; i++)
            {
               tips = this._horseTipsCfg[tipsIds[i]];
               if(Boolean(tips))
               {
                  callBack(tips);
                  return;
               }
            }
            callBack(null);
         }
      }
   }
}

