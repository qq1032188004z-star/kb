package com.game.util.rectUtils.scroll
{
   import com.core.observer.MessageEvent;
   import com.game.Tools.RectButton;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class RectScrollBar extends Sprite
   {
      
      public static const ON_SCROLL_UPDATE:String = "on_scroll_update";
      
      private var _onBtnInited:Boolean;
      
      private var _upBtn:DisplayObject;
      
      private var _downBtn:DisplayObject;
      
      private var _scrollBtn:Sprite;
      
      private var _scrollBack:DisplayObject;
      
      private var _scrollBtnMinHeight:int;
      
      private var _btnScrollRange:Rectangle;
      
      private var _scrollRange:Rectangle;
      
      private var _scrollShow:Boolean;
      
      private var _hideCookie:int;
      
      private var _noShowScrollBar:Boolean;
      
      private var _scrollRate:Number;
      
      private var _highError:Array = [0,0];
      
      private var _prePos:Point = new Point();
      
      private var _speed:int = 10;
      
      public function RectScrollBar()
      {
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.init,false,0,true);
      }
      
      protected function init(event:Event = null) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.init);
         this.parent.addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheelHandler,false,0,true);
         this.parent.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOverHandler,false,0,true);
         stage.addEventListener(MouseEvent.MOUSE_UP,this.onStageUpHandler,false,0,true);
         addEventListener(Event.ENTER_FRAME,this.onEnterFrameHandler,false,0,true);
      }
      
      private function createRectBtn(skin:DisplayObject) : RectButton
      {
         var btn:RectButton = new RectButton();
         btn.setSkin(skin);
         return btn;
      }
      
      public function setScrollSkin(upBtn:DisplayObject, downBtn:DisplayObject, scrollBtn:Sprite, scrollBack:DisplayObject) : void
      {
         if(this._onBtnInited)
         {
            this._upBtn.removeEventListener(MouseEvent.CLICK,this.onBtnClickHandler);
            this._downBtn.removeEventListener(MouseEvent.CLICK,this.onBtnClickHandler);
            this._scrollBack.removeEventListener(MouseEvent.CLICK,this.onBtnClickHandler);
            this._scrollBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.onBtnDownHandler);
            removeChild(this._upBtn);
            removeChild(this._downBtn);
            removeChild(this._scrollBtn);
            removeChild(this._scrollBack);
         }
         this._onBtnInited = true;
         this._scrollBtn = scrollBtn;
         this._scrollBack = scrollBack;
         addChild(this._scrollBack);
         if(Boolean(upBtn))
         {
            this._upBtn = upBtn;
            this._upBtn.addEventListener(MouseEvent.CLICK,this.onBtnClickHandler,false,0,true);
            addChild(this._upBtn);
         }
         if(Boolean(downBtn))
         {
            this._downBtn = downBtn;
            this._downBtn.addEventListener(MouseEvent.CLICK,this.onBtnClickHandler,false,0,true);
            addChild(this._downBtn);
         }
         addChild(this._scrollBtn);
         this._scrollBtnMinHeight = scrollBtn.height;
         this._scrollBack.addEventListener(MouseEvent.CLICK,this.onBtnClickHandler,false,0,true);
         this._scrollBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.onBtnDownHandler,false,0,true);
      }
      
      public function noShowScrollBar(bool:Boolean) : void
      {
         this._noShowScrollBar = bool;
      }
      
      public function setHighError(arr:Array) : void
      {
         this._highError = arr;
      }
      
      public function setScrollHeight(contentH:Number, showH:Number, showTopBottomBtn:Boolean) : void
      {
         if(showTopBottomBtn)
         {
            this._upBtn.visible = this._downBtn.visible = true;
            this.visible = !this._scrollShow && !this._noShowScrollBar;
            this._upBtn.y = this._upBtn.height * 0.5;
            this._downBtn.y = showH - this._downBtn.height * 0.5;
            this._scrollBack.height = showH - this._upBtn.height - this._downBtn.height;
            this._scrollBack.y = this._upBtn.height;
         }
         else
         {
            if(Boolean(this._upBtn))
            {
               this._upBtn.visible = false;
            }
            if(Boolean(this._downBtn))
            {
               this._downBtn.visible = false;
            }
            this._scrollBack.height = showH;
         }
         this._scrollRange = new Rectangle(this._scrollBack.x,this._scrollBack.y,0,this._scrollBack.height);
         var maxContentH:Number = this._scrollRange.height * showH / this._scrollBtnMinHeight;
         contentH = contentH > maxContentH ? maxContentH : contentH;
         this._scrollBtn.height = this._scrollRange.height * showH / contentH;
         this._scrollBtn.y = this._scrollRange.height * showH / contentH + this._scrollRange.y;
         this._btnScrollRange = new Rectangle(this._scrollRange.x,int(this._scrollRange.y + this._scrollBtn.height * 0.5 + this._highError[0]),0,Math.ceil(this._scrollRange.height - this._scrollBtn.height) + this._highError[1]);
      }
      
      public function setScrollBtnPos(rate:Number) : void
      {
         this._scrollRate = rate;
         this._scrollBtn.y = this._btnScrollRange.height * rate + this._btnScrollRange.y;
      }
      
      protected function onEnterFrameHandler(event:Event) : void
      {
         if(!this._scrollBtn || !this._btnScrollRange)
         {
            this._prePos.x = this._prePos.y = 0;
         }
         else if(this._prePos.x != this._scrollBtn.x || this._prePos.y != this._scrollBtn.y)
         {
            this._prePos.y = this._scrollBtn.x;
            this._prePos.y = this._scrollBtn.y;
            this._scrollRate = (this._scrollBtn.y - this._btnScrollRange.top) / this._btnScrollRange.height;
            dispatchEvent(new MessageEvent(ON_SCROLL_UPDATE,{"rate":this._scrollRate}));
         }
      }
      
      protected function onBtnDownHandler(event:MouseEvent) : void
      {
         switch(event.currentTarget)
         {
            case this._scrollBtn:
               this._scrollBtn.startDrag(false,this._btnScrollRange);
         }
      }
      
      protected function onStageUpHandler(event:MouseEvent) : void
      {
         switch(event.currentTarget)
         {
            case stage:
               this._scrollBtn.stopDrag();
         }
      }
      
      protected function onBtnClickHandler(event:Event) : void
      {
         switch(event.currentTarget)
         {
            case this._upBtn:
               this.moveThumb(true,this._speed);
               break;
            case this._downBtn:
               this.moveThumb(false,this._speed);
               break;
            case this._scrollBack:
               this.moveThumb(mouseY < this._scrollBtn.y,Math.abs(mouseY - this._scrollBtn.y));
         }
      }
      
      protected function onMouseWheelHandler(event:MouseEvent) : void
      {
         this.moveThumb(event.delta > 0,this._speed);
         this.checkScrollShow();
      }
      
      protected function onMouseOverHandler(event:MouseEvent) : void
      {
         this.checkScrollShow();
      }
      
      private function checkScrollShow() : void
      {
         if(this._scrollShow && this._btnScrollRange && Boolean(this._scrollRange))
         {
            this.visible = !this._noShowScrollBar;
            clearTimeout(this._hideCookie);
            this._hideCookie = setTimeout(this.hide,1000);
         }
      }
      
      private function hide() : void
      {
         this.visible = false;
      }
      
      public function scrollShowBar(bool:Boolean) : void
      {
         this._scrollShow = bool;
         this.visible = !bool && !this._noShowScrollBar;
      }
      
      public function clearScrollRange() : void
      {
         this._scrollRange = null;
         this._btnScrollRange = null;
      }
      
      private function moveThumb(isUp:Boolean, speed:int) : void
      {
         if(!this._btnScrollRange)
         {
            return;
         }
         if(isUp)
         {
            this._scrollBtn.y -= speed;
            if(this._scrollBtn.y < this._btnScrollRange.top)
            {
               this._scrollBtn.y = this._btnScrollRange.top;
            }
         }
         else
         {
            this._scrollBtn.y += speed;
            if(this._scrollBtn.y > this._btnScrollRange.bottom)
            {
               this._scrollBtn.y = this._btnScrollRange.bottom;
            }
         }
      }
      
      public function set speed(value:int) : void
      {
         this._speed = value;
      }
      
      public function destroy() : void
      {
         if(Boolean(this._upBtn))
         {
            this._upBtn.removeEventListener(MouseEvent.CLICK,this.onBtnClickHandler);
         }
         if(Boolean(this._downBtn))
         {
            this._downBtn.removeEventListener(MouseEvent.CLICK,this.onBtnClickHandler);
         }
         if(Boolean(this._scrollBack))
         {
            this._scrollBack.removeEventListener(MouseEvent.CLICK,this.onBtnClickHandler);
         }
         if(Boolean(this._scrollBtn))
         {
            this._scrollBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.onBtnDownHandler);
         }
         if(Boolean(this.parent))
         {
            this.parent.removeEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheelHandler);
            this.parent.removeEventListener(MouseEvent.MOUSE_OVER,this.onMouseOverHandler);
         }
         if(Boolean(stage))
         {
            stage.removeEventListener(MouseEvent.MOUSE_UP,this.onStageUpHandler);
         }
         removeEventListener(Event.ENTER_FRAME,this.onEnterFrameHandler);
      }
      
      public function get scrollRate() : Number
      {
         return this._scrollRate;
      }
   }
}

