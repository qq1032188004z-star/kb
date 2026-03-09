package com.publiccomponent.quickmsg
{
   import com.publiccomponent.*;
   import com.publiccomponent.quickmsg.event.QuickMessageEvent;
   import com.publiccomponent.quickmsg.item.QuickBackGround;
   import com.publiccomponent.quickmsg.item.QuickItem;
   import com.publiccomponent.quickmsg.item.QuickItem2;
   import flash.display.*;
   import flash.events.*;
   import flash.net.*;
   import flash.system.ApplicationDomain;
   
   public class QuickMessage extends Sprite
   {
      
      private var xmldata:XML;
      
      private var urlloader:URLLoader;
      
      private var dialog:QuickBackGround;
      
      private var quickxml:XMLList;
      
      private var background:QuickBackGround;
      
      private var _skinLoader:Loader;
      
      private var _application:ApplicationDomain;
      
      public function QuickMessage()
      {
         super();
         this._skinLoader = new Loader();
         this._skinLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onSkinComplete);
         this._skinLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onSkinerror);
         this._skinLoader.load(new URLRequest(URLUtil.getSvnVer("assets/material/QuickMessage.swf")));
      }
      
      private function onURLComplete(event:Event) : void
      {
         this.xmldata = new XML(this.urlloader.data);
         this.quickxml = this.xmldata.children();
         this.urlloader.removeEventListener(Event.COMPLETE,this.onURLComplete);
         this.urlloader.removeEventListener(IOErrorEvent.IO_ERROR,this.onURLerror);
         this.urlloader = null;
         this.init();
         this.initEvents();
      }
      
      public function dispos() : void
      {
         this.onclose(null);
      }
      
      private function onSkinComplete(event:Event) : void
      {
         this._application = event.currentTarget.applicationDomain;
         this._skinLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onSkinComplete);
         this._skinLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onSkinerror);
         this._skinLoader = null;
         this.urlloader = new URLLoader();
         this.urlloader.addEventListener(Event.COMPLETE,this.onURLComplete);
         this.urlloader.addEventListener(IOErrorEvent.IO_ERROR,this.onURLerror);
         this.urlloader.load(new URLRequest(URLUtil.getSvnVer("config/quickmsg.xml")));
      }
      
      private function onSkinerror(event:Event) : void
      {
         this._skinLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onSkinComplete);
         this._skinLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onSkinerror);
         this._skinLoader = null;
      }
      
      private function onadditem(event:QuickMessageEvent) : void
      {
         var len:* = event.body.len;
         var xml:* = event.body.xml;
         var num:* = event.body.num;
         if(Boolean(this.dialog))
         {
            this.dialog.dispos();
            this.dialog = null;
         }
         this.dialog = new QuickBackGround(this._application,len,null,xml);
         this.dialog.bgmc.width += 30;
         this.dialog.setData2(len);
         this.dialog.setindex(num * 30);
         this.addChild(this.dialog);
      }
      
      private function initEvents() : void
      {
         this.background.addEventListener(QuickItem.ADDITEM,this.onadditem,true);
         this.addEventListener(QuickItem2.CLOSE,this.onclose,true);
      }
      
      private function init() : void
      {
         var len:int = int(this.quickxml.length());
         this.background = new QuickBackGround(this._application,len,this.quickxml);
         this.background.setData(len);
         this.background.x = 100;
         this.background.y = 500;
         this.addChild(this.background);
      }
      
      private function onURLerror(event:Event) : void
      {
         this.urlloader.removeEventListener(Event.COMPLETE,this.onURLComplete);
         this.urlloader.removeEventListener(IOErrorEvent.IO_ERROR,this.onURLerror);
         this.urlloader = null;
      }
      
      private function onclose(event:QuickMessageEvent) : void
      {
         if(Boolean(this.dialog))
         {
            this.dialog.dispos();
            this.dialog = null;
         }
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
      
      private function removeEvents() : void
      {
         if(Boolean(this.background) && this.background.hasEventListener(QuickItem.ADDITEM))
         {
            this.background.removeEventListener(QuickItem.ADDITEM,this.onadditem,true);
         }
      }
   }
}

