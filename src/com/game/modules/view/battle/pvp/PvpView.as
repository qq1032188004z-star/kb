package com.game.modules.view.battle.pvp
{
   import com.game.util.HLoaderSprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class PvpView extends HLoaderSprite
   {
      
      public static const SINGLE:String = "single";
      
      public static const MULTI:String = "multi";
      
      public function PvpView()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         url = "assets/pvp/pvpview.swf";
      }
      
      override public function setShow() : void
      {
         bg["closeBtn"].addEventListener(MouseEvent.CLICK,this.onClickCloseBtn);
         bg["singleBtn"].gotoAndStop(1);
         bg["multiBtn"].gotoAndStop(1);
         bg["singleBtn"].addEventListener(MouseEvent.ROLL_OVER,this.onRollOverSingleBtn);
         bg["multiBtn"].addEventListener(MouseEvent.ROLL_OVER,this.onRollOverMultiBtn);
         bg["singleBtn"].addEventListener(MouseEvent.ROLL_OUT,this.onRollOutSingleBtn);
         bg["multiBtn"].addEventListener(MouseEvent.ROLL_OUT,this.onRollOutMultiBtn);
         bg["singleBtn"].addEventListener(MouseEvent.CLICK,this.onClickSingleBtn);
         bg["multiBtn"].addEventListener(MouseEvent.CLICK,this.onClickMultiBtn);
      }
      
      private function onClickCloseBtn(event:MouseEvent) : void
      {
         dispatchEvent(new Event(Event.CLOSE));
         this.disport();
      }
      
      private function onRollOverSingleBtn(event:MouseEvent) : void
      {
         bg["singleBtn"].gotoAndStop(2);
      }
      
      private function onRollOverMultiBtn(event:MouseEvent) : void
      {
         bg["multiBtn"].gotoAndStop(2);
      }
      
      private function onRollOutSingleBtn(event:MouseEvent) : void
      {
         bg["singleBtn"].gotoAndStop(1);
      }
      
      private function onRollOutMultiBtn(event:MouseEvent) : void
      {
         bg["multiBtn"].gotoAndStop(1);
      }
      
      private function onClickSingleBtn(event:MouseEvent) : void
      {
         dispatchEvent(new Event(PvpView.SINGLE));
         this.disport();
      }
      
      private function onClickMultiBtn(event:MouseEvent) : void
      {
         dispatchEvent(new Event(PvpView.MULTI));
         this.disport();
      }
      
      override public function disport() : void
      {
         bg["singleBtn"].removeEventListener(MouseEvent.ROLL_OVER,this.onRollOverSingleBtn);
         bg["multiBtn"].removeEventListener(MouseEvent.ROLL_OVER,this.onRollOverMultiBtn);
         bg["singleBtn"].removeEventListener(MouseEvent.ROLL_OUT,this.onRollOutSingleBtn);
         bg["multiBtn"].removeEventListener(MouseEvent.ROLL_OUT,this.onRollOutMultiBtn);
         bg["singleBtn"].removeEventListener(MouseEvent.CLICK,this.onClickSingleBtn);
         bg["multiBtn"].removeEventListener(MouseEvent.CLICK,this.onClickMultiBtn);
         if(Boolean(this.parent) && this.parent.contains(this))
         {
            this.parent.removeChild(this);
         }
         super.disport();
      }
   }
}

