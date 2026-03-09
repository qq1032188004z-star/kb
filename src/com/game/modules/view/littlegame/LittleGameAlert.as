package com.game.modules.view.littlegame
{
   import com.game.util.HLoaderSprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class LittleGameAlert extends HLoaderSprite
   {
      
      private var data:Object;
      
      public function LittleGameAlert(value:Object)
      {
         super();
         this.data = value;
         this.loadbg();
      }
      
      private function loadbg() : void
      {
         this.url = "assets/littlegame/littlegameawad.swf";
      }
      
      override public function setShow() : void
      {
         bg["closeBtn"].addEventListener(MouseEvent.CLICK,this.onClickCloseHandler);
         bg["jifen"].text = this.data.jifen + "";
         bg["xiuxing"].text = this.data.xiuxing + "";
      }
      
      private function onClickCloseHandler(event:MouseEvent) : void
      {
         this.dispatchEvent(new Event(Event.CLOSE));
         if(this && this.parent && this.parent.contains(this))
         {
            this.parent.removeChild(this);
         }
         disport();
      }
      
      public function xiuxing(value:int) : void
      {
         this.data.xiuxing = value;
         if(bg && Boolean(bg["xiuxing"]))
         {
            bg["xiuxing"].text = value + "";
         }
      }
   }
}

