package com.game.modules.view.menology
{
   import com.game.util.HLoaderSprite;
   import com.publiccomponent.URLUtil;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   
   public class Activity extends HLoaderSprite
   {
      
      private var urlloader:URLLoader;
      
      private var actxml:XMLList;
      
      private var xmldata:XML;
      
      private var getXmlData:Function;
      
      public function Activity(pGetXmlData:Function)
      {
         super();
         this.getXmlData = pGetXmlData;
         this.urlloader = new URLLoader();
         this.urlloader.addEventListener(Event.COMPLETE,this.onURLComplete);
         this.urlloader.addEventListener(IOErrorEvent.IO_ERROR,this.onURLerror);
         this.urlloader.load(new URLRequest(URLUtil.getSvnVer("config/Activity.xml")));
      }
      
      private function onURLComplete(evt:Event) : void
      {
         this.xmldata = new XML(this.urlloader.data);
         this.actxml = this.xmldata.children();
         this.urlloader.removeEventListener(Event.COMPLETE,this.onURLComplete);
         this.urlloader.removeEventListener(IOErrorEvent.IO_ERROR,this.onURLerror);
         this.urlloader = null;
         this.url = "assets/menology/activity.swf";
         this.getXmlData(this.actxml);
      }
      
      private function onURLerror(evt:Event) : void
      {
         trace("xml加载出错！" + evt);
         this.urlloader.removeEventListener(Event.COMPLETE,this.onURLComplete);
         this.urlloader.removeEventListener(IOErrorEvent.IO_ERROR,this.onURLerror);
         this.urlloader = null;
      }
      
      override public function setShow() : void
      {
         if(bg)
         {
            this.bg.cacheAsBitmap = true;
            this.bg.visible = false;
         }
      }
      
      public function showbg(bol:Boolean, str1:String, str2:String, xingqi:int) : void
      {
         var len:int = 0;
         var weekday:String = null;
         var actday:int = 0;
         if(bg)
         {
            this.bg.todaymc.visible = bol;
            this.bg.x = this.mouseX + 30;
            this.bg.y = this.mouseY - 250;
            this.bg.visible = true;
            this.bg.datetxt1.text = str1;
            this.bg.datetxt2.text = str2;
            len = str1.length;
            if(str1.substr(1,1) == "月" && str1.substr(4,1) == "日")
            {
               weekday = str1.substr(2,2);
            }
            if(str1.substr(1,1) == "月" && str1.substr(3,1) == "日")
            {
               weekday = str1.substr(2,1);
            }
            if(str1.substr(2,1) == "月" && str1.substr(5,1) == "日")
            {
               weekday = str1.substr(3,2);
            }
            if(str1.substr(2,1) == "月" && str1.substr(4,1) == "日")
            {
               weekday = str1.substr(3,1);
            }
            actday = int(weekday);
            this.bg.txt1.htmlText = this.actxml.(@id == actday).txt1;
            this.bg.txt2.htmlText = this.actxml.(@id == actday).txt2;
            this.bg.txt3.htmlText = this.actxml.(@id == actday).txt3;
            this.bg.txt4.htmlText = this.actxml.(@id == actday).txt4;
            this.bg.txt5.htmlText = this.actxml.(@id == actday).txt5;
         }
      }
      
      public function hidebg() : void
      {
         if(bg)
         {
            this.bg.visible = false;
         }
      }
      
      override public function disport() : void
      {
         this.urlloader = null;
         this.actxml = null;
         this.xmldata = null;
         super.disport();
      }
   }
}

