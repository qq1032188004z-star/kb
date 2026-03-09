package com.game.modules.view.item
{
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.list.ItemRender;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLRequest;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol943")]
   public class MonsterImageItem extends ItemRender
   {
      
      public var packImg:MovieClip;
      
      public var numTxt:TextField;
      
      public var yiClip:MovieClip;
      
      public var loader:Loader;
      
      public var maskSpr:Sprite;
      
      public function MonsterImageItem()
      {
         super();
         if(this.yiClip != null)
         {
            this.yiClip.visible = false;
         }
         this.loader = new Loader();
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoadComplete);
         this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.errFunc);
         this.buttonMode = true;
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.onRemove);
      }
      
      private function onRemove(evt:Event) : void
      {
         this.removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemove);
         if(Boolean(this.loader))
         {
            this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoadComplete);
            this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.errFunc);
            if(this.loader.content != null && this.contains(this.loader.content))
            {
               this.removeChild(this.loader.content);
            }
            this.loader.unloadAndStop(false);
         }
      }
      
      private function errFunc(evt:IOErrorEvent) : void
      {
         O.o("MonsterImageItem - errFunc");
      }
      
      private function onLoadComplete(evt:Event) : void
      {
         this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoadComplete);
         this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.errFunc);
         addChild(this.loader.content);
         this.loader.content.mask = this.maskSpr;
      }
      
      override public function set data(params:Object) : void
      {
         if(params.hasOwnProperty("iid"))
         {
            if(params.iid == 0)
            {
               return;
            }
            this.loader.load(new URLRequest(URLUtil.getSvnVer("assets/monsterimg/" + params.iid + ".swf")));
            this.numTxt.text = "";
         }
         super.data = params;
      }
      
      public function setSelect(frame:int) : void
      {
         super.data.select = frame;
         this.packImg.gotoAndStop(1);
      }
   }
}

