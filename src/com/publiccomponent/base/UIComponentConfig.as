package com.publiccomponent.base
{
   import com.game.locators.CacheData;
   import com.game.locators.GameData;
   import com.game.util.LuaObjUtil;
   import com.publiccomponent.URLUtil;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.utils.ByteArray;
   
   public class UIComponentConfig
   {
      
      private var urlloader:URLLoader;
      
      private var xmldata:XML;
      
      private var callback:Function;
      
      public var dataList:Array = [];
      
      public var activeIconList:Array = [];
      
      private var hour:int = 0;
      
      private var minutes:int = 0;
      
      public function UIComponentConfig($callback:Function = null)
      {
         super();
         this.callback = $callback;
         this.urlloader = new URLLoader();
         this.urlloader.addEventListener(Event.COMPLETE,this.onURLComplete);
         this.urlloader.addEventListener(IOErrorEvent.IO_ERROR,this.onURLerror);
         this.urlloader.dataFormat = URLLoaderDataFormat.BINARY;
         this.urlloader.load(new URLRequest(URLUtil.getSvnVer("config/uiConfig")));
      }
      
      private function onURLComplete(evt:Event) : void
      {
         var ba:ByteArray = this.urlloader.data as ByteArray;
         ba.uncompress();
         this.xmldata = new XML(ba);
         this.initXml();
         if(Boolean(this.urlloader))
         {
            this.urlloader.removeEventListener(Event.COMPLETE,this.onURLComplete);
            this.urlloader.removeEventListener(IOErrorEvent.IO_ERROR,this.onURLerror);
            this.urlloader = null;
         }
      }
      
      private function onURLerror(evt:Event) : void
      {
         this.urlloader.removeEventListener(Event.COMPLETE,this.onURLComplete);
         this.urlloader.removeEventListener(IOErrorEvent.IO_ERROR,this.onURLerror);
      }
      
      private function initXml() : void
      {
         var xml:XML = null;
         var data:Object = null;
         var tempList:XMLList = null;
         var times:XML = null;
         var subxml:XML = null;
         var obj:Object = null;
         var j:int = 0;
         var timeLen:int = 0;
         var list:XMLList = this.xmldata.children() as XMLList;
         var len:int = int(list.length());
         for(var i:int = 0; i < len; i++)
         {
            this.dataList["typelist" + i] = new Array();
            tempList = list[i].children() as XMLList;
            for each(xml in tempList)
            {
               data = new Object();
               data.targetScene = int(xml.targetScene);
               data.jump = String(xml.jump);
               data.name = String(xml.name);
               data.desc = String(xml.desc);
               data.row = int(xml.row);
               data.col = int(xml.col);
               data.showPos = int(xml.showPos);
               data.hide = int(xml.hide);
               data.type = int(xml.type);
               data.showTime = LuaObjUtil.getLuaObjArr(xml.show_time);
               if(data.type == 3)
               {
                  data.url = String(xml.url);
               }
               data.c = int(xml.writelog);
               data.showPhares = int(xml.showPhares);
               data.timeList = [];
               this.dataList["typelist" + i].push(data);
               times = xml.times[0] as XML;
               if(times != null)
               {
                  subxml = xml.times[0] as XML;
                  if(subxml.children().length() > 0 && subxml.children()[0].@id != 0)
                  {
                     j = 0;
                     timeLen = int(subxml.children().length());
                     for(j = 0; j < timeLen; j++)
                     {
                        obj = {};
                        obj.start_hour = int(subxml.children()[j].@start_hour);
                        obj.start_minutes = int(subxml.children()[j].@start_minutes);
                        obj.end_hour = int(subxml.children()[j].@end_hour);
                        obj.end_minutes = int(subxml.children()[j].@end_minutes);
                        obj.effect = int(subxml.children()[j].@effect);
                        data.timeList.push(obj);
                        CacheData.instance.uiEffectDic[data.name] = false;
                     }
                  }
               }
               if(Boolean(data.timeList) && data.timeList.length > 0)
               {
                  this.activeIconList.push(data);
               }
            }
         }
         this.apply({"type":-1});
      }
      
      public function checkActiveTime() : void
      {
         var b:Boolean = false;
         var inActive:Boolean = false;
         var list:Array = null;
         var timeLen:int = 0;
         var j:int = 0;
         var date:Date = new Date(GameData.instance.playerData.systemTimes * 1000);
         var inActiveList:Array = [];
         var outActiveList:Array = [];
         var len:int = int(this.activeIconList.length);
         this.hour = date.hours;
         this.minutes = date.minutes;
         for(var i:int = 0; i < len; i++)
         {
            list = this.activeIconList[i].timeList;
            timeLen = int(list.length);
            inActive = false;
            for(j = 0; j < timeLen; j++)
            {
               b = false;
               if(list[j].start_hour == this.hour)
               {
                  if(list[j].start_minutes <= this.minutes)
                  {
                     b = true;
                  }
               }
               else if(list[j].start_hour < this.hour)
               {
                  b = true;
               }
               if(b)
               {
                  if(list[j].end_hour == this.hour)
                  {
                     if(list[j].end_minutes > this.minutes)
                     {
                        inActive = true;
                        this.activeIconList[i].effect = list[j].effect;
                     }
                  }
                  else if(list[j].end_hour > this.hour)
                  {
                     if(list[j].end_minutes < this.minutes)
                     {
                        inActive = true;
                        this.activeIconList[i].effect = list[j].effect;
                     }
                  }
               }
            }
            if(inActive)
            {
               inActiveList.push(this.activeIconList[i]);
            }
            else
            {
               this.activeIconList[i].effect = 0;
               outActiveList.push(this.activeIconList[i]);
            }
         }
         this.sendActiveInfo(inActiveList,1);
         this.sendActiveInfo(outActiveList,2);
      }
      
      private function sendActiveInfo(list:Array, type:int) : void
      {
         var len:int = 0;
         var i:int = 0;
         if(Boolean(list))
         {
            len = int(list.length);
            for(i = 0; i < len; i++)
            {
               this.apply({
                  "type":type,
                  "name":list[i].name,
                  "effect":list[i].effect
               });
            }
         }
      }
      
      public function apply(data:Object) : void
      {
         if(this.callback != null)
         {
            this.callback(data);
         }
      }
      
      public function disport() : void
      {
         if(Boolean(this.urlloader))
         {
            this.urlloader.removeEventListener(Event.COMPLETE,this.onURLComplete);
            this.urlloader.removeEventListener(IOErrorEvent.IO_ERROR,this.onURLerror);
            this.urlloader = null;
         }
         if(this.callback != null)
         {
            this.callback();
            this.callback = null;
         }
         this.dataList.length = 0;
         this.dataList = null;
         this.xmldata = null;
         this.callback = null;
      }
   }
}

