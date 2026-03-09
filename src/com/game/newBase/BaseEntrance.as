package com.game.newBase
{
   import com.core.observer.MessageEvent;
   import flash.display.Loader;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class BaseEntrance extends Sprite
   {
      
      protected var _mainView:BaseSprite;
      
      private var _moduleParams:Object;
      
      public function BaseEntrance()
      {
         super();
         if(Boolean(stage))
         {
            this.init();
         }
         else
         {
            this.addEventListener(Event.ADDED_TO_STAGE,this.init);
         }
      }
      
      private function init(evt:Event = null) : void
      {
         if(this.hasEventListener(Event.ADDED_TO_STAGE))
         {
            this.removeEventListener(Event.ADDED_TO_STAGE,this.init);
         }
         this.initView();
         this.initEvent();
      }
      
      public function get moduleParams() : Object
      {
         return this._moduleParams;
      }
      
      public function set moduleParams(value:Object) : void
      {
         this._moduleParams = value;
      }
      
      protected function removeEvent() : void
      {
         if(Boolean(this._mainView) && this._mainView.hasEventListener(BaseSprite.CLOSE_MAIN_VIEW))
         {
            this._mainView.removeEventListener(BaseSprite.CLOSE_MAIN_VIEW,this.onCloseMainHandler);
         }
      }
      
      protected function initEvent() : void
      {
         if(Boolean(this._mainView))
         {
            this._mainView.addEventListener(BaseSprite.CLOSE_MAIN_VIEW,this.onCloseMainHandler);
         }
      }
      
      protected function onCloseMainHandler(event:MessageEvent) : void
      {
         this.disport();
      }
      
      protected function childDisport() : void
      {
         if(Boolean(this._mainView))
         {
            this._mainView.disport();
            this._mainView = null;
         }
      }
      
      protected function initView() : void
      {
      }
      
      public function disport() : void
      {
         this.removeEventListener(Event.ADDED_TO_STAGE,this.init);
         this.removeEvent();
         this.childDisport();
         if(Boolean(this.parent))
         {
            if(this.parent is Loader)
            {
               Loader(this.parent).unloadAndStop(false);
            }
            else
            {
               this.parent.removeChild(this);
            }
         }
      }
   }
}

