package com.game.cue.base
{
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   
   public class CueBaseWithClose extends CueBase
   {
      
      public function CueBaseWithClose()
      {
         super();
      }
      
      override protected function initialize() : void
      {
         super.initialize();
      }
      
      protected function registerCloseHandler($event:EventDispatcher) : void
      {
         if(Boolean($event) && !$event.hasEventListener(MouseEvent.MOUSE_DOWN))
         {
            $event.addEventListener(MouseEvent.MOUSE_DOWN,this.onCloseHandler);
         }
         else
         {
            trace(" 退出按钮为空，不能注册  ",$event == null);
         }
      }
      
      protected function removeCloseHandler($event:EventDispatcher) : void
      {
         if(Boolean($event))
         {
            $event.removeEventListener(MouseEvent.MOUSE_DOWN,this.onCloseHandler);
         }
         else
         {
            trace("退出按钮为空 ， 不能移除事件操作");
         }
      }
      
      protected function onCloseHandler(e:MouseEvent) : void
      {
         e.stopImmediatePropagation();
         this.disport();
      }
      
      override public function disport() : void
      {
         super.disport();
      }
   }
}

