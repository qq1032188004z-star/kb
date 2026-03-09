package com.game.modules.view.pop
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.util.HLoaderSprite;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.net.URLVariables;
   import phpcon.PhpEvent;
   
   public class ShowCheckView extends HLoaderSprite
   {
      
      private var callbackfunction:Function;
      
      private var selectId:int = -1;
      
      private var md5lists:Array;
      
      private var titletype:int;
      
      private var addId:int = 0;
      
      private var loadMD5:String;
      
      private var domainname:String = "http://php.wanwan4399.com/game_guard/image.php";
      
      public function ShowCheckView(callback:Function, value:Object)
      {
         this.md5lists = value.lists;
         this.titletype = value.type;
         this.callbackfunction = callback;
         super();
         this.url = "assets/pop/showcheck.swf";
      }
      
      override public function setShow() : void
      {
         this.bg.okbtn.addEventListener(MouseEvent.CLICK,this.onClickOkHandler);
         this.bg.x = 300;
         this.bg.y = 120;
         for(var i:int = 1; i < 5; i++)
         {
            if(Boolean(this.bg.hasOwnProperty("bg" + i)))
            {
               this.bg["bg" + i].gotoAndStop(1);
               this.bg["bg" + i].addEventListener(MouseEvent.CLICK,this.onSelectClick);
            }
         }
         if(Boolean(this.bg.hasOwnProperty("titletxt")))
         {
            if(this.titletype == 1)
            {
               this.bg["titletxt"].text = "面向你";
            }
            else
            {
               this.bg["titletxt"].text = "背向你";
            }
         }
         this.addId = 0;
         if(Boolean(this.md5lists))
         {
            this.showmd5img();
         }
      }
      
      private function showmd5img() : void
      {
         var tuv:URLVariables = null;
         if(this.addId < 4)
         {
            this.loadMD5 = this.md5lists[this.addId];
            tuv = new URLVariables();
            tuv.md5 = this.loadMD5;
            this.getdata("",tuv);
         }
      }
      
      private function onImageBack(event:PhpEvent) : void
      {
         var obj:Object = event.data;
         var bitmap:Bitmap = new Bitmap(obj as BitmapData);
         this.addChild(bitmap);
      }
      
      private function onClickOkHandler(event:MouseEvent) : void
      {
         ApplicationFacade.getInstance().dispatch(EventConst.BATTLE_MD5_SELECT,this.selectId);
         if(this.callbackfunction != null)
         {
            this.callbackfunction.apply(null);
         }
         if(Boolean(this.parent) && this.parent.contains(this))
         {
            this.parent.removeChild(this);
         }
         this.disport();
      }
      
      private function onSelectClick(event:MouseEvent) : void
      {
         for(var i:int = 1; i < 5; i++)
         {
            if(Boolean(this.bg.hasOwnProperty("bg" + i)))
            {
               this.bg["bg" + i].gotoAndStop(1);
            }
         }
         this.selectId = int(event.currentTarget.name.charAt(2)) - 1;
         MovieClip(event.currentTarget).gotoAndStop(2);
      }
      
      override public function disport() : void
      {
         for(var i:int = 1; i < 5; i++)
         {
            if(this.bg && Boolean(this.bg.hasOwnProperty("bg" + i)))
            {
               this.bg["bg" + i].removeEventListener(MouseEvent.CLICK,this.onSelectClick);
            }
         }
         this.callbackfunction = null;
         super.disport();
      }
      
      public function getdata(value:String, uv:URLVariables = null, url:String = null) : void
      {
         var req:URLRequest;
         var loader:URLLoader;
         var onIOError:Function = null;
         var onSecuError:Function = null;
         var onLoaderCompHandler:Function = null;
         onIOError = function(event:Event):void
         {
            O.o("ShowCheckView-onIOError");
         };
         onSecuError = function(event:SecurityErrorEvent):void
         {
            O.o("ShowCheckView-onSecuError");
         };
         onLoaderCompHandler = function(event:Event):void
         {
            if(event.currentTarget.data == "" || event.currentTarget.data == null)
            {
               return;
            }
            var result:Object = event.currentTarget.data;
            var ploader:Loader = new Loader();
            ploader.loadBytes(event.currentTarget.data);
            ploader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoaderComp);
         };
         if(url == null)
         {
            url = this.domainname;
         }
         req = new URLRequest(url + value);
         req.method = "POST";
         req.data = uv;
         loader = new URLLoader();
         loader.dataFormat = URLLoaderDataFormat.BINARY;
         loader.load(req);
         loader.addEventListener(Event.COMPLETE,onLoaderCompHandler);
         loader.addEventListener(IOErrorEvent.IO_ERROR,onIOError);
         loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onSecuError);
      }
      
      private function onLoaderComp(event:Event) : void
      {
         event.currentTarget.loader.scaleX = 0.8;
         event.currentTarget.loader.scaleY = 0.8;
         event.currentTarget.loader.x = 13;
         event.currentTarget.loader.y = 13;
         this.bg["bg" + (this.addId + 1)].addChild(event.currentTarget.loader);
         ++this.addId;
         this.showmd5img();
      }
   }
}

