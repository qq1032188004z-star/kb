package com.game.cue.view
{
   import com.game.cue.base.CueBaseWithClose;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   
   public class CueNotKbCoin extends CueBaseWithClose
   {
      
      public function CueNotKbCoin()
      {
         super();
      }
      
      override protected function initialize() : void
      {
         super.initialize();
      }
      
      override protected function onRegister() : void
      {
         this.registerOkHandler(this.bg.okBtn);
         registerCloseHandler(this.bg.noBtn);
         registerCloseHandler(this.bg.closeBtn);
      }
      
      protected function registerOkHandler($event:EventDispatcher) : void
      {
         if(Boolean($event) && !$event.hasEventListener(MouseEvent.MOUSE_DOWN))
         {
            $event.addEventListener(MouseEvent.MOUSE_DOWN,this.onClickOkHandler);
         }
      }
      
      protected function removeOkHandler($event:EventDispatcher) : void
      {
         if(Boolean($event) && $event.hasEventListener(MouseEvent.MOUSE_DOWN))
         {
            $event.removeEventListener(MouseEvent.MOUSE_DOWN,this.onClickOkHandler);
         }
      }
      
      override protected function onRemove() : void
      {
         if(Boolean(this.bg))
         {
            removeCloseHandler(this.bg.noBtn);
            removeCloseHandler(this.bg.closeBtn);
            this.removeOkHandler(this.bg.okBtn);
         }
      }
      
      protected function onClickOkHandler(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         navigateToURL(new URLRequest("http://pay.my.4399.com/?ac=exchange&je=10&union=80006"));
         this.disport();
      }
      
      override public function disport() : void
      {
         this.onRemove();
         super.disport();
      }
   }
}

