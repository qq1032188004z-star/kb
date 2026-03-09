package com.game.modules.view.pop
{
   import com.game.locators.GameData;
   import com.publiccomponent.alert.Alert;
   import com.publiccomponent.loading.Hloader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.system.System;
   
   public class Tales extends Sprite
   {
      
      private var loader:Hloader;
      
      private var mc:MovieClip;
      
      private var callback:Function;
      
      public function Tales()
      {
         super();
         this.cacheAsBitmap = true;
         this.loader = new Hloader("assets/material/kabutales.swf");
         this.loader.addEventListener(Event.COMPLETE,this.onLoadComplete);
         this.loader.addEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
      }
      
      private function onLoadComplete(evt:Event) : void
      {
         evt.stopImmediatePropagation();
         this.loader.removeEventListener(Event.COMPLETE,this.onLoadComplete);
         this.loader.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
         this.mc = this.loader.content as MovieClip;
         this.mc.cacheAsBitmap = true;
         this.mc.contenttf.text = "";
         this.mc.contenttf.text = "http://enter.wanwan4399.com/invite/invite.html?inviteId=" + GameData.instance.playerData.userId;
         this.addChild(this.mc);
         this.mc.x = 0;
         this.mc.y = 0;
         this.mc.closebtn.addEventListener(MouseEvent.CLICK,this.onClickClose);
         this.mc.copybtn.addEventListener(MouseEvent.CLICK,this.onClickCopy);
      }
      
      private function onLoadError(evt:Event) : void
      {
         evt.stopImmediatePropagation();
         this.disport();
      }
      
      public function setData(callback:Function = null) : void
      {
         this.callback = callback;
      }
      
      private function onClickClose(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         this.disport();
      }
      
      private function onClickCopy(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         System.setClipboard(this.mc.contenttf.text);
         new Alert().showOne("成功复制游戏地址啦！你现在可以把它黏贴到QQ或论坛上，发送给你的好朋友们。",this.onClickSure);
      }
      
      private function onClickSure(txt:String, ... rest) : void
      {
         if(txt == "确定")
         {
            this.disport();
         }
      }
      
      private function releaseEvent() : void
      {
         if(this.mc != null)
         {
            this.mc.closebtn.removeEventListener(MouseEvent.CLICK,this.onClickClose);
            this.mc.copybtn.removeEventListener(MouseEvent.CLICK,this.onClickCopy);
            this.mc.contenttf.text = "";
         }
      }
      
      private function releaseLoader() : void
      {
         if(this.loader != null)
         {
            this.loader.removeEventListener(Event.COMPLETE,this.onLoadComplete);
            this.loader.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
            this.loader.unloadAndStop(true);
            this.loader = null;
         }
      }
      
      public function disport() : void
      {
         this.releaseLoader();
         this.releaseEvent();
         if(this.callback != null)
         {
            this.callback.apply(null,[true]);
         }
         this.callback = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

