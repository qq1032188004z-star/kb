package com.game.modules.view.task.freshman
{
   import com.publiccomponent.URLUtil;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   
   public class BetaOnline extends Sprite
   {
      
      private var loader:Loader;
      
      private var mc:MovieClip;
      
      private var list:Array;
      
      public function BetaOnline()
      {
         super();
         this.loader = new Loader();
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoadComplete);
         this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
         this.loader.load(new URLRequest(URLUtil.getSvnVer("assets/material/betaonline.swf")));
      }
      
      private function onLoadComplete(evt:Event) : void
      {
         evt.stopImmediatePropagation();
         this.mc = this.loader.content as MovieClip;
         this.releaseLoader();
         this.addChild(this.mc);
         this.mc.x = 0;
         this.mc.y = 0;
         this.mc.complete1.visible = false;
         this.mc.complete2.visible = false;
         this.mc.friend.buttonMode = true;
         this.mc.collect.buttonMode = true;
         this.mc.friend.gotoAndStop(1);
         this.mc.collect.gotoAndStop(1);
         if(this.list != null)
         {
            this.initView();
         }
      }
      
      private function initView() : void
      {
         this.initEvent();
         var i:int = 0;
         var len:int = int(this.list.length);
         if(len == 0)
         {
            return;
         }
         for(i = 0; i < len; i++)
         {
            if(this.list[i].status == 4)
            {
               this.mc["complete" + (i + 1)].visible = true;
            }
         }
         this.onClickFriend(null);
      }
      
      private function initEvent() : void
      {
         this.mc.friend.addEventListener(MouseEvent.CLICK,this.onClickFriend);
         this.mc.collect.addEventListener(MouseEvent.CLICK,this.onClickCollect);
         this.mc.close.addEventListener(MouseEvent.CLICK,this.onClickClose);
      }
      
      private function removeEvent() : void
      {
         this.mc.friend.removeEventListener(MouseEvent.CLICK,this.onClickFriend);
         this.mc.collect.removeEventListener(MouseEvent.CLICK,this.onClickCollect);
      }
      
      private function onClickFriend(evt:MouseEvent) : void
      {
         this.mc.friend.gotoAndStop(2);
         this.mc.collect.gotoAndStop(1);
         this.mc.content.text = "新的时空，小卡布们面临着巨大的挑战。困难面前，我们需要集合大家的力量，一起去接受挑战。行动起来，到超时空舱找亚赛吧！";
      }
      
      private function onClickCollect(evt:MouseEvent) : void
      {
         this.mc.collect.gotoAndStop(2);
         this.mc.friend.gotoAndStop(1);
         this.mc.content.text = "最近胖墩博士对于西游时代的妖怪研究又有了新的进展，快去宠物房找胖墩博士了解下吧。";
      }
      
      private function onClickClose(evt:MouseEvent) : void
      {
         this.dispos();
      }
      
      public function setData(arr:Array) : void
      {
         this.list = arr;
         if(this.mc != null)
         {
            this.initView();
         }
      }
      
      private function onLoadError(evt:IOErrorEvent) : void
      {
         evt.stopImmediatePropagation();
         this.dispos();
      }
      
      private function releaseLoader() : void
      {
         if(this.loader != null)
         {
            this.loader.unloadAndStop();
            this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoadComplete);
            this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
            this.loader = null;
         }
      }
      
      public function dispos() : void
      {
         this.releaseLoader();
         this.removeEvent();
         if(this.list != null)
         {
            this.list.length = 0;
            this.list = null;
         }
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

