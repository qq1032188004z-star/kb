package com.game.util
{
   import flash.utils.Dictionary;
   
   public class PropertyPool
   {
      
      public static var instance:PropertyPool = new PropertyPool();
      
      private var xmlDic:Dictionary;
      
      private var callbackDic:Dictionary;
      
      public function PropertyPool()
      {
         super();
         this.xmlDic = new Dictionary(true);
         this.callbackDic = new Dictionary(true);
      }
      
      private function load(url:String, keyCode:String, keyList:Array, rest:Array = null) : void
      {
         var loader:PropertyLoader = new PropertyLoader();
         loader.startLoad(url,keyCode,keyList,this.loadComplete,rest);
      }
      
      private function loadComplete(keyCode:String, keyList:Array, xmlList:Dictionary, rest:Array = null) : void
      {
         var key:String = null;
         if(this.callbackDic[keyCode] != null)
         {
            for each(key in keyList)
            {
               if(xmlList[key] != null)
               {
                  this.xmlDic[key] = xmlList[key];
               }
            }
            if(keyCode.indexOf("prolist") != -1)
            {
               this.callbackDic[keyCode].apply(null,[rest]);
            }
            else if(rest == null)
            {
               this.callbackDic[keyCode].apply(null,[this.xmlDic[keyList[0]]]);
            }
            else
            {
               this.callbackDic[keyCode].apply(null,[this.xmlDic[keyList[0]],rest]);
            }
            this.releaseCallback(keyCode);
         }
      }
      
      private function loadedFilter(item:*, index:int, array:Array) : Boolean
      {
         return this.xmlDic[item as String] == null ? true : false;
      }
      
      private function releaseCallback(keyCode:String) : void
      {
         this.callbackDic[keyCode] = null;
         delete this.callbackDic[keyCode];
      }
      
      public function getXML(preUrl:String, keycode:String, callback:Function, rest:Array = null) : void
      {
         if(this.xmlDic[keycode] != null)
         {
            if(Boolean(rest) && rest.length > 0)
            {
               callback.apply(null,[this.xmlDic[keycode],rest]);
            }
            else
            {
               callback.apply(null,[this.xmlDic[keycode]]);
            }
            return;
         }
         this.callbackDic[keycode] = callback;
         this.load(preUrl,keycode,[keycode],rest);
      }
      
      public function getXMLList(preUrl:String, list:Array, callback:Function, rest:Array = null) : void
      {
         if(list == null)
         {
            return;
         }
         list = list.filter(this.loadedFilter);
         if(list.length == 0)
         {
            callback.apply(null,[rest]);
            return;
         }
         var keyCode:String = list[0] + "prolist";
         this.callbackDic[keyCode] = callback;
         this.load(preUrl,keyCode,list,rest);
      }
      
      public function deleteXMLByKey(keyCode:String) : void
      {
         if(this.xmlDic[keyCode] != null)
         {
            this.xmlDic[keyCode] = null;
            delete this.xmlDic[keyCode];
         }
      }
      
      public function get length() : int
      {
         var k:String = null;
         var i:int = 0;
         for(k in this.xmlDic)
         {
            i++;
         }
         return i;
      }
      
      public function getTaskProps(dialogId:int, callback:Function, ... rest) : void
      {
         var str:String = String(dialogId / 1000 >> 0) + "0";
         this.getXML("assets/taskprop/",str,callback,rest);
      }
      
      public function getTaskPropsList(list:Array, callback:Function, ... rest) : void
      {
         var arr:Array = [];
         var i:int = 0;
         var len:int = int(list.length);
         for(i = 0; i < len; i++)
         {
            arr.push(String(list[i] / 1000 >> 0) + "0");
         }
         this.getXMLList("assets/taskprop/",arr,callback,rest);
      }
      
      public function getSpecifiedProp(key:String) : XML
      {
         return this.xmlDic[key];
      }
   }
}

