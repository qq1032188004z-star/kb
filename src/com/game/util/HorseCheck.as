package com.game.util
{
   import com.game.locators.*;
   import com.game.modules.vo.HorseCheckVo;
   import flash.utils.Dictionary;
   
   public class HorseCheck
   {
      
      private static var _instance:HorseCheck;
      
      private var _reqTemp:Array = [];
      
      private var _horseDic:Dictionary;
      
      private var _cmpCallBack:Array = [];
      
      private var _isLoaded:Boolean = false;
      
      public function HorseCheck()
      {
         super();
         PropertyPool.instance.getXML("config/","horse",this.loadXmlComplete);
      }
      
      public static function get instance() : HorseCheck
      {
         if(_instance == null)
         {
            _instance = new HorseCheck();
         }
         return _instance;
      }
      
      public function checkBySceneId(checkData:HorseCheckVo, callback:Function) : void
      {
         var item:Object = null;
         var result:Boolean = false;
         if(Boolean(this._horseDic))
         {
            item = this._horseDic[checkData.horseId];
            if(Boolean(item) && callback != null)
            {
               result = (CacheData.instance.scenceHorseLimited & item.horseState) != 0;
               checkData.checkResult = result;
               checkData.horseState = item.horseState;
               checkData.userState = item.useState;
               callback(checkData);
            }
         }
         else
         {
            this._reqTemp.push({
               "data":checkData,
               "callBack":callback
            });
         }
      }
      
      public function getHorseConfig(horseId:int) : Object
      {
         if(Boolean(this._horseDic))
         {
            return this._horseDic[horseId];
         }
         return null;
      }
      
      public function isFlyHorse(horseId:int) : Boolean
      {
         var item:Object = null;
         if(Boolean(this._horseDic))
         {
            item = this._horseDic[horseId];
            if(Boolean(item) && (item.horseState & 6) != 0)
            {
               return true;
            }
         }
         return false;
      }
      
      public function isVipHorse(horseId:int) : Boolean
      {
         var item:Object = null;
         if(Boolean(this._horseDic))
         {
            item = this._horseDic[horseId];
            if(Boolean(item) && (item.useState & 1) != 0)
            {
               return true;
            }
         }
         return false;
      }
      
      public function isNeedHorseCloth(horseId:int) : Boolean
      {
         var item:Object = null;
         if(Boolean(this._horseDic))
         {
            item = this._horseDic[horseId];
            if(Boolean(item) && (item.useState & 2) != 0)
            {
               return true;
            }
         }
         return false;
      }
      
      private function loadXmlComplete(... args) : void
      {
         var propItem:Object = null;
         var item:XML = null;
         this._isLoaded = true;
         var configData:XML = args[0] as XML;
         var xmlList:XMLList = configData.children();
         var len:int = int(xmlList.length());
         var i:int = 0;
         for(this._horseDic = new Dictionary(); i < len; )
         {
            item = xmlList[i];
            propItem = {};
            propItem.id = int(item.@id);
            propItem.horseState = int(item.horseState);
            propItem.useState = int(item.useState);
            this._horseDic[propItem.id] = propItem;
            i++;
         }
         this.doCheck();
         this.doCallBack();
      }
      
      private function doCallBack() : void
      {
         var len:int = int(this._cmpCallBack.length);
         while(Boolean(len--))
         {
            this._cmpCallBack.pop()();
         }
      }
      
      public function addCmpCallBack(back:Function) : void
      {
         if(this._isLoaded)
         {
            back();
         }
         else
         {
            this._cmpCallBack.push(back);
         }
      }
      
      private function doCheck() : void
      {
         var len:int = 0;
         var dataItem:Object = null;
         var i:int = 0;
         if(Boolean(this._reqTemp) && this._reqTemp.length > 0)
         {
            len = int(this._reqTemp.length);
            for(i = 0; i < len; i++)
            {
               dataItem = this._reqTemp[i];
               this.checkBySceneId(dataItem.data,dataItem.callBack);
               dataItem.callBack = null;
            }
         }
      }
   }
}

