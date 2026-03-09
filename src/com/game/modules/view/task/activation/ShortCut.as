package com.game.modules.view.task.activation
{
   import com.publiccomponent.alert.Alert;
   import com.publiccomponent.loading.GreenLoading;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   
   [SWF(width="970",height="570")]
   public class ShortCut extends Sprite
   {
      
      private var loader:Loader;
      
      private var mc:MovieClip;
      
      private var callback:Function;
      
      private var loadCount:int = 4;
      
      public function ShortCut()
      {
         super();
         GreenLoading.loading.visible = true;
         this.mouseEnabled = false;
         this.loader = new Loader();
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoadComplete);
         this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
         this.loader.load(new URLRequest("assets/material/shortcuttask.swf"));
      }
      
      private function onLoadComplete(evt:Event) : void
      {
         this.mc = this.loader.content["getChildAt"](0) as MovieClip;
         this.addChild(this.mc);
         this.mc.x = 320;
         this.mc.y = 172;
         this.cacheAsBitmap = true;
         this.mc.cacheAsBitmap = true;
         this.releaseLoader();
         if(this.callback != null)
         {
            this.init();
         }
      }
      
      private function onLoadError(evt:IOErrorEvent) : void
      {
         evt.stopImmediatePropagation();
         --this.loadCount;
         if(this.loadCount > 0)
         {
            this.loader.load(new URLRequest("assets/material/shortcuttask.swf"));
            return;
         }
         this.releaseLoader();
         this.dispos();
      }
      
      private function releaseLoader() : void
      {
         if(this.loader != null)
         {
            this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoadComplete);
            this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
            this.loader.unloadAndStop();
            this.loader = null;
         }
      }
      
      private function init() : void
      {
         GreenLoading.loading.visible = false;
         this.mc.okbtn.addEventListener(MouseEvent.CLICK,this.onClickOK);
         this.mc.cancelbtn.addEventListener(MouseEvent.CLICK,this.onClickCancel);
      }
      
      private function removeEvent() : void
      {
         this.mc.okbtn.removeEventListener(MouseEvent.CLICK,this.onClickOK);
         this.mc.cancelbtn.removeEventListener(MouseEvent.CLICK,this.onClickCancel);
      }
      
      private function onClickOK(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         this.removeEvent();
         navigateToURL(new URLRequest("http://enter.wanwan4399.com/bin-debug/shortcut.php"),"_blank");
         new Alert().show("贝拉已经帮你创建了快捷方式，快去看一看吧！",this.clickHandler);
      }
      
      private function onClickCancel(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         this.removeEvent();
         if(this.callback != null)
         {
            this.callback.apply(null,["closedialog"]);
         }
         this.dispos();
      }
      
      private function clickHandler(txt:String, ... rest) : void
      {
         if(txt == "确定")
         {
            if(this.callback != null)
            {
               this.callback.apply(null,[false]);
            }
            this.dispos();
         }
      }
      
      public function setData(params:Object) : void
      {
         this.callback = params.callback;
         GreenLoading.loading.visible = true;
         if(this.mc != null)
         {
            this.init();
         }
      }
      
      public function dispos() : void
      {
         this.releaseLoader();
         this.removeEvent();
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
         this.callback = null;
      }
   }
}

