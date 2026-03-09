package com.publiccomponent.loading
{
   import com.game.global.GlobalConfig;
   import com.publiccomponent.URLUtil;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.events.ProgressEvent;
   import flash.external.ExternalInterface;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.system.LoaderContext;
   import flash.utils.clearInterval;
   import flash.utils.clearTimeout;
   import flash.utils.setInterval;
   import flash.utils.setTimeout;
   
   public class Loading extends Sprite
   {
      
      private var visiblevalue:int = 0;
      
      private var tid:int;
      
      private var clip:MovieClip;
      
      private var doloading:Boolean = true;
      
      private var index:int;
      
      private var loader:Loader;
      
      private var topTxtList:Array = [];
      
      public var materialLoader:MaterialLoader;
      
      private var visiblebool:Boolean = false;
      
      private var list:Array = [];
      
      private var context:LoaderContext;
      
      private var dsid:uint;
      
      public function Loading()
      {
         super();
         this.graphics.beginFill(0,0.4);
         this.graphics.drawRect(-480,-270,1500,1000);
         this.graphics.endFill();
         this.materialLoader = new MaterialLoader();
         this.loader = new Loader();
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoadeComponent);
         this.loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.onLoadingProgress);
         this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onerror);
         this.loader.load(new URLRequest(URLUtil.getSvnVer("assets/material/loading.swf")),this.context);
      }
      
      private function loopShow() : void
      {
         if(this.index <= this.topTxtList.length - 1)
         {
            this.clip.topTxt.text = this.topTxtList[this.index];
            ++this.index;
         }
         else
         {
            this.index = 0;
         }
      }
      
      public function dispos() : void
      {
         try
         {
            this.parent.removeChild(this);
         }
         catch(e:Error)
         {
         }
      }
      
      private function onRefreash(evt:MouseEvent) : void
      {
         if(!this.doloading)
         {
            if(ExternalInterface.available)
            {
               ExternalInterface.call("closeshow");
               if(GlobalConfig.isClient)
               {
                  navigateToURL(new URLRequest("javascript:window.parent.location.href=\'http://enter.wanwan4399.com/bin-debug/KBgameindex.html\'"),"_self");
               }
               else
               {
                  navigateToURL(new URLRequest("javascript:window.parent.location.href=\'http://www.4399.com/flash/48399.htm\'"),"_self");
               }
            }
         }
      }
      
      public function onerror(e:IOErrorEvent) : void
      {
         trace(e);
      }
      
      public function loadgame() : void
      {
      }
      
      public function setTopTxt(configStr:String) : void
      {
         this.topTxtList.length = 0;
         this.topTxtList = configStr.split(",");
         this.clip.topTxt.text = this.topTxtList[this.index];
      }
      
      public function hidebluebg(value:Boolean = false) : void
      {
         if(Boolean(this.clip) && Boolean(this.clip.hasOwnProperty("bg")))
         {
            this.clip.bg.visible = value;
         }
      }
      
      private function onCloseLoading(evt:MouseEvent) : void
      {
         this.visible = false;
         this.materialLoader.close();
      }
      
      public function loadXML(showTxt:String, url:String, callBack:Function) : void
      {
         this.materialLoader.loadXML(showTxt,url,callBack,this.loadProgress);
      }
      
      private function onLoadingProgress(evt:ProgressEvent) : void
      {
         this.dispatchEvent(evt);
      }
      
      override public function set visible(value:Boolean) : void
      {
         var _local3:* = undefined;
         value = value;
         if(this.visiblebool == value)
         {
            return;
         }
         if(!value && HloadManager.instance.isloading)
         {
            return;
         }
         this.visiblebool = value;
         if(value && this.clip != null)
         {
            clearInterval(this.tid);
            this.tid = setInterval(this.loopShow,1000);
            try
            {
               if(Boolean(this.clip) && Boolean(this.clip.hasOwnProperty("xClip")))
               {
                  _local3 = this.clip.xClip;
                  _local3["gotoAndPlay"](1);
               }
            }
            catch(e:Error)
            {
            }
         }
         else if(this.clip != null)
         {
            clearInterval(this.tid);
            _local3 = this.clip.xClip;
            _local3["gotoAndStop"](1);
         }
         super.visible = value;
         clearTimeout(this.dsid);
         this.dsid = setTimeout(this.timeoutCanRefresh,1000);
      }
      
      private function timeoutCanRefresh() : void
      {
         clearTimeout(this.dsid);
         this.doloading = false;
      }
      
      public function loadMaterial(urlList:Array, callBack:Function) : void
      {
         this.visible = true;
         this.materialLoader.loadSWF(urlList,callBack,this.loadProgress);
      }
      
      public function loadModule(showTxt:String, url:String, callBack:Function, ioerrorCallback:Function = null) : void
      {
         this.visible = true;
         this.materialLoader.loadModule(showTxt,url,callBack,this.loadProgress,ioerrorCallback);
      }
      
      private function loadProgress(showTxt:String, bytesLoaded:Number, bytesTotal:Number) : void
      {
         this.doloading = true;
         var frame:int = int(bytesLoaded / bytesTotal * 100);
         if(frame <= 0)
         {
            frame = 1;
         }
         if(frame > 100)
         {
            frame = 100;
         }
         this.clip.bottomTxt.text = "正在加载……" + (frame + "%");
         this.clip.pClip.gotoAndStop(frame);
         clearTimeout(this.dsid);
         this.dsid = setTimeout(this.timeoutCanRefresh,1000);
      }
      
      public function setCloseBtnShow(isShow:Boolean) : void
      {
      }
      
      private function onLoadeComponent(evt:Event) : void
      {
         var _local3:* = undefined;
         evt = evt;
         this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoadeComponent);
         this.clip = this.loader.content as MovieClip;
         this.addChild(this.clip);
         this.clip.reLoadBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.onRefreash);
         try
         {
            _local3 = this.loader;
            _local3["unloadAndStop"]();
         }
         catch(e:Error)
         {
         }
         this.loader = null;
         this.dispatchEvent(new Event(Event.COMPLETE));
      }
      
      public function setProgress(showTxt:String, bytesLoaded:Number, bytesTotal:Number) : void
      {
         this.doloading = true;
         var frame:int = int(bytesLoaded / bytesTotal * 100);
         if(frame <= 0)
         {
            frame = 1;
         }
         if(frame > 100)
         {
            frame = 100;
         }
         if(Boolean(this.clip))
         {
            this.clip.bottomTxt.text = "正在加载……" + (frame + "%");
            this.clip.pClip.gotoAndStop(frame);
         }
         clearTimeout(this.dsid);
         this.dsid = setTimeout(this.timeoutCanRefresh,1000);
      }
      
      public function loadMain(showTxt:String, url:String, callBack:Function) : void
      {
         this.visible = true;
         this.materialLoader.loadMain(showTxt,url,callBack,this.loadProgress);
      }
   }
}

