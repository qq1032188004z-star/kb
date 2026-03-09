package com.game.util
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class ScrollBar extends Sprite
   {
      
      private var moveSpeed:Number = 4;
      
      private var scrollHeight:Number;
      
      private var scrollableHeight:Number;
      
      private var targetInitY:Number;
      
      private var top:Number;
      
      private var bottom:Number;
      
      private var scrollArea:Rectangle;
      
      private var upButton:SimpleButton;
      
      private var downButton:SimpleButton;
      
      private var scrollBtn:Sprite;
      
      private var scroll_bg_mc:Sprite;
      
      private var target:DisplayObject;
      
      private var maskRect:Rectangle;
      
      private var shape:Shape;
      
      private var scrollClip:MovieClip;
      
      private var heightChanged:Boolean = false;
      
      public function ScrollBar($maskRect:Rectangle, $target:DisplayObject, $scrollClip:MovieClip)
      {
         super();
         this.scrollClip = $scrollClip;
         this.maskRect = $maskRect;
         this.target = $target;
         this.scroll_bg_mc = this.scrollClip.bgClip;
         addChild(this.scroll_bg_mc);
         this.upButton = this.scrollClip.upBtn;
         addChild(this.upButton);
         this.scrollBtn = this.scrollClip.scrollClip;
         addChild(this.scrollBtn);
         this.scrollBtn.y = this.upButton.height;
         this.scrollBtn.buttonMode = true;
         this.downButton = this.scrollClip.downBtn;
         addChild(this.downButton);
         this.downButton.y = this.scroll_bg_mc.height - this.downButton.height;
         this.scrollHeight = this.scroll_bg_mc.height - this.upButton.height * 2;
         this.top = this.upButton.y + this.upButton.height;
         this.bottom = this.scroll_bg_mc.y + this.scroll_bg_mc.height - this.scrollBtn.height - this.upButton.height * 2;
         this.targetInitY = this.target.y;
         this.scrollArea = new Rectangle(this.scrollBtn.x,this.scrollBtn.y,0,this.bottom);
         this.setTargetMask();
      }
      
      public function setTargetMask(tar:DisplayObject = null) : void
      {
         if(tar != null)
         {
            this.target = tar;
            this.targetInitY = this.target.y;
         }
         this.scrollableHeight = this.target.height - this.maskRect.height;
         this.shape = new Shape();
         this.shape.graphics.beginFill(16711680,1);
         this.shape.graphics.drawRect(this.maskRect.x,this.maskRect.y,this.maskRect.width,this.maskRect.height);
         this.shape.graphics.endFill();
         this.target.mask = this.shape;
         this.target.parent.addChild(this.shape);
         this.addEventListener(Event.ADDED_TO_STAGE,this.onAddToStage);
      }
      
      public function updateScrollBarVisible() : void
      {
         var lastHeight:Number = this.scrollBtn.height;
         this.scrollBtn.height = this.maskRect.height / this.target.height * (this.downButton.y - this.upButton.y - this.upButton.height);
         if(lastHeight != this.scrollBtn.height)
         {
            this.heightChanged = true;
         }
         this.bottom = this.scroll_bg_mc.y + this.scroll_bg_mc.height - this.scrollBtn.height - this.upButton.height * 2;
         this.scrollableHeight = this.target.height - this.maskRect.height;
         this.scrollBtn.y = this.upButton.y + this.upButton.height;
         if(this.scrollableHeight <= 0)
         {
            this.visible = false;
         }
         else
         {
            this.visible = true;
         }
         this.update(null);
      }
      
      public function updateScrollBarButtons() : void
      {
         this.scrollBtn.y = this.downButton.y - this.scrollBtn.height;
         this.scrollableHeight = this.target.height - this.maskRect.height;
         if(this.scrollableHeight <= 0)
         {
            this.upButton.mouseEnabled = false;
            this.downButton.mouseEnabled = false;
            this.scrollBtn.mouseEnabled = false;
         }
         else
         {
            this.upButton.mouseEnabled = true;
            this.downButton.mouseEnabled = true;
            this.scrollBtn.mouseEnabled = true;
         }
      }
      
      public function alwaysShowLastest() : void
      {
         if(!this.heightChanged || !this.visible)
         {
            return;
         }
         this.scrollBtn.y = this.downButton.y - this.scrollBtn.height;
         this.update(null);
      }
      
      private function onAddToStage(e:Event) : void
      {
         this.removeEventListener(Event.ADDED_TO_STAGE,this.onAddToStage);
         this.upButton.addEventListener(MouseEvent.MOUSE_DOWN,this.moveUp);
         this.downButton.addEventListener(MouseEvent.MOUSE_DOWN,this.moveDown);
         this.scrollBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.scroll);
         stage.addEventListener(MouseEvent.MOUSE_UP,this.stopScroll);
         this.addEventListener(MouseEvent.ROLL_OVER,this.onMouseOver);
         this.target.addEventListener(MouseEvent.ROLL_OVER,this.onMouseOver);
      }
      
      private function onMouseOver(evt:MouseEvent) : void
      {
         if(!this.hasEventListener(MouseEvent.ROLL_OUT))
         {
            this.addEventListener(MouseEvent.ROLL_OUT,this.onMouseOut);
         }
         if(this.target != null && !this.target.hasEventListener(MouseEvent.ROLL_OUT))
         {
            this.target.addEventListener(MouseEvent.ROLL_OUT,this.onMouseOut);
         }
         if(!this.hasEventListener(MouseEvent.MOUSE_WHEEL))
         {
            this.addEventListener(MouseEvent.MOUSE_WHEEL,this.wheelMove);
         }
         if(this.target != null && !this.target.hasEventListener(MouseEvent.MOUSE_WHEEL))
         {
            this.target.addEventListener(MouseEvent.MOUSE_WHEEL,this.wheelMove);
         }
      }
      
      private function onMouseOut(evt:MouseEvent) : void
      {
         this.removeEventListener(MouseEvent.ROLL_OUT,this.onMouseOut);
         this.removeEventListener(MouseEvent.MOUSE_WHEEL,this.wheelMove);
         if(this.target != null)
         {
            this.target.removeEventListener(MouseEvent.ROLL_OUT,this.onMouseOut);
            this.target.removeEventListener(MouseEvent.MOUSE_WHEEL,this.wheelMove);
         }
      }
      
      private function moveUp(evt:MouseEvent) : void
      {
         if(this.upButton != null && !this.upButton.hasEventListener(Event.ENTER_FRAME))
         {
            this.upButton.addEventListener(Event.ENTER_FRAME,this.upScroll);
         }
      }
      
      private function moveDown(evt:MouseEvent) : void
      {
         if(this.downButton != null && !this.downButton.hasEventListener(Event.ENTER_FRAME))
         {
            this.downButton.addEventListener(Event.ENTER_FRAME,this.downScroll);
         }
      }
      
      private function wheelMove(evt:MouseEvent) : void
      {
         if(evt.delta > 0)
         {
            this.upScroll(null);
         }
         else
         {
            this.downScroll(null);
         }
      }
      
      private function scroll(evt:MouseEvent) : void
      {
         this.scrollArea.height = this.bottom + 1;
         if(this.scrollBtn != null)
         {
            this.scrollBtn.startDrag(false,this.scrollArea);
            if(!this.scrollBtn.hasEventListener(Event.ENTER_FRAME))
            {
               this.scrollBtn.addEventListener(Event.ENTER_FRAME,this.update);
            }
         }
      }
      
      private function stopScroll(evt:MouseEvent) : void
      {
         if(this.scrollBtn != null)
         {
            this.scrollBtn.stopDrag();
            this.scrollBtn.removeEventListener(Event.ENTER_FRAME,this.update);
         }
         if(this.upButton != null)
         {
            this.upButton.removeEventListener(Event.ENTER_FRAME,this.upScroll);
         }
         if(this.downButton != null)
         {
            this.downButton.removeEventListener(Event.ENTER_FRAME,this.downScroll);
         }
      }
      
      private function upScroll(evt:Event) : void
      {
         this.scrollBtn.y = Math.max(this.top,this.scrollBtn.y - this.moveSpeed);
         if(this.scrollBtn.y <= this.upButton.height)
         {
            this.scrollBtn.y = this.upButton.height;
         }
         this.update(null);
      }
      
      private function downScroll(evt:Event) : void
      {
         this.scrollBtn.y = Math.min(this.downButton.y - this.scrollBtn.height,this.scrollBtn.y + this.moveSpeed);
         this.update(null);
      }
      
      private function update(evt:Event = null) : void
      {
         var percen_scroll:Number = (this.scrollBtn.y - this.upButton.height) / (this.scrollHeight - this.scrollBtn.height);
         this.target.y = Math.round(this.targetInitY - this.scrollableHeight * percen_scroll);
      }
      
      public function dispos() : void
      {
         this.removeEventListener(Event.ADDED_TO_STAGE,this.onAddToStage);
         if(Boolean(stage))
         {
            stage.removeEventListener(MouseEvent.MOUSE_UP,this.stopScroll);
         }
         if(this.scroll_bg_mc != null)
         {
            if(Boolean(this.scroll_bg_mc.parent))
            {
               this.scroll_bg_mc.parent.removeChild(this.scroll_bg_mc);
            }
         }
         this.scroll_bg_mc = null;
         if(this.scrollBtn != null)
         {
            this.scrollBtn.stopDrag();
            this.scrollBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.scroll);
            this.scrollBtn.removeEventListener(Event.ENTER_FRAME,this.update);
            if(Boolean(this.scrollBtn.parent))
            {
               this.scrollBtn.parent.removeChild(this.scrollBtn);
            }
         }
         this.scrollBtn = null;
         if(this.upButton != null)
         {
            this.upButton.removeEventListener(Event.ENTER_FRAME,this.upScroll);
            this.upButton.removeEventListener(MouseEvent.MOUSE_DOWN,this.moveUp);
            if(Boolean(this.upButton.parent))
            {
               this.upButton.parent.removeChild(this.upButton);
            }
         }
         this.upButton = null;
         if(this.downButton != null)
         {
            this.downButton.removeEventListener(Event.ENTER_FRAME,this.downScroll);
            this.downButton.removeEventListener(MouseEvent.MOUSE_DOWN,this.moveDown);
            if(Boolean(this.downButton.parent))
            {
               this.downButton.parent.removeChild(this.downButton);
            }
         }
         this.downButton = null;
         this.removeEventListener(MouseEvent.ROLL_OUT,this.onMouseOut);
         this.removeEventListener(MouseEvent.MOUSE_WHEEL,this.wheelMove);
         if(this.target != null)
         {
            this.target.removeEventListener(MouseEvent.ROLL_OUT,this.onMouseOut);
            this.target.removeEventListener(MouseEvent.MOUSE_WHEEL,this.wheelMove);
         }
         if(this.shape != null)
         {
            this.shape.graphics.clear();
            if(Boolean(this.shape.parent))
            {
               this.shape.parent.removeChild(this.shape);
            }
         }
         if(this.target != null)
         {
            this.target.mask = null;
         }
         this.shape = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

