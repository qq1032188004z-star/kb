package com.game.modules.view.pop
{
   import com.game.util.HLoaderSprite;
   import flash.events.MouseEvent;
   
   public class SurplusView extends HLoaderSprite
   {
      
      private var message:String;
      
      private var callback:Function;
      
      private var state:int;
      
      public function SurplusView(message:String = "", callback:Function = null, state:int = 1)
      {
         super();
         this.message = message;
         this.callback = callback;
         this.state = state;
         this.init();
      }
      
      private function init() : void
      {
         this.url = "assets/pop/surplus.swf";
      }
      
      override public function setShow() : void
      {
         if(this.message.length > 1 && Boolean(this.bg.hasOwnProperty("txt")))
         {
            this.bg["txt"].text = this.message;
         }
         this.bg["closeBtn"].addEventListener(MouseEvent.CLICK,this.onClickCloseBtn);
         if(Boolean(this.bg.hasOwnProperty("mcstate")))
         {
            this.bg["mcstate"].gotoAndStop(this.state);
         }
      }
      
      private function onClickCloseBtn(event:MouseEvent) : void
      {
         if(this.callback != null)
         {
            this.callback.apply();
         }
         if(Boolean(this.parent) && this.parent.contains(this))
         {
            this.parent.removeChild(this);
         }
         disport();
      }
   }
}

