package com.game.util
{
   import com.publiccomponent.loading.MaterialLib;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class VSpriteScrollBar extends Sprite
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
      
      private var heightChanged:Boolean = false;
      
      public function VSpriteScrollBar(maskRect:Rectangle, target:DisplayObject, upStyleName:String = "upBtn", downStyleName:String = "downBtn", scrollStyleName:String = "scrollBtn", scrollbgStyleName:String = "scrollbg")
      {
         super();
         this.scroll_bg_mc = MaterialLib.getInstance().getMaterial(scrollbgStyleName) as MovieClip;
         addChild(this.scroll_bg_mc);
         this.scroll_bg_mc.height = maskRect.height;
         this.upButton = MaterialLib.getInstance().getMaterial(upStyleName) as SimpleButton;
         this.upButton.x -= 2;
         addChild(this.upButton);
         this.scrollBtn = MaterialLib.getInstance().getMaterial(scrollStyleName) as MovieClip;
         this.scrollBtn.y = this.upButton.height;
         this.scrollBtn.x += 4;
         this.scrollBtn.buttonMode = true;
         addChild(this.scrollBtn);
         this.downButton = MaterialLib.getInstance().getMaterial(downStyleName) as SimpleButton;
         this.downButton.y = this.scroll_bg_mc.height - this.downButton.height;
         this.downButton.x -= 2;
         addChild(this.downButton);
         this.scrollHeight = this.scroll_bg_mc.height - this.upButton.height * 2;
         this.top = this.scroll_bg_mc.y;
         this.bottom = this.scroll_bg_mc.y + this.scroll_bg_mc.height - this.scrollBtn.height - this.upButton.height * 2;
         this.maskRect = maskRect;
         this.target = target;
         this.targetInitY = target.y;
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
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoveStage);
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
         if(this.scrollableHeight <= 0)
         {
            this.visible = false;
            this.scrollBtn.y = this.upButton.y + this.upButton.height;
            this.update(null);
         }
         else
         {
            this.visible = true;
         }
      }
      
      public function updateScrollBarButtons() : void
      {
         this.scrollBtn.y = this.upButton.height;
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
      
      private function onAddToStage(evt:Event) : void
      {
         this.upButton.addEventListener(MouseEvent.MOUSE_DOWN,this.moveUp);
         this.downButton.addEventListener(MouseEvent.MOUSE_DOWN,this.moveDown);
         this.scrollBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.scroll);
         stage.addEventListener(MouseEvent.MOUSE_UP,this.stopScroll);
         this.addEventListener(MouseEvent.ROLL_OVER,this.onMouseOver);
         this.target.addEventListener(MouseEvent.ROLL_OVER,this.onMouseOver);
      }
      
      private function onRemoveStage(event:Event) : void
      {
         if(Boolean(stage))
         {
            stage.removeEventListener(MouseEvent.MOUSE_UP,this.stopScroll);
         }
         if(Boolean(this.upButton))
         {
            this.upButton.removeEventListener(MouseEvent.MOUSE_DOWN,this.moveUp);
            this.downButton.removeEventListener(MouseEvent.MOUSE_DOWN,this.moveDown);
            this.scrollBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.scroll);
         }
         if(Boolean(this.target))
         {
            this.target.removeEventListener(MouseEvent.ROLL_OVER,this.onMouseOver);
         }
         this.removeEventListener(MouseEvent.ROLL_OVER,this.onMouseOver);
         this.removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemoveStage);
      }
      
      private function onMouseOver(evt:MouseEvent) : void
      {
         this.addEventListener(MouseEvent.ROLL_OUT,this.onMouseOut);
         this.target.addEventListener(MouseEvent.ROLL_OUT,this.onMouseOut);
         this.addEventListener(MouseEvent.MOUSE_WHEEL,this.wheelMove);
         this.target.addEventListener(MouseEvent.MOUSE_WHEEL,this.wheelMove);
      }
      
      private function onMouseOut(evt:MouseEvent) : void
      {
         this.removeEventListener(MouseEvent.ROLL_OUT,this.onMouseOut);
         this.shape.removeEventListener(MouseEvent.ROLL_OUT,this.onMouseOut);
         this.removeEventListener(MouseEvent.MOUSE_WHEEL,this.wheelMove);
         this.shape.removeEventListener(MouseEvent.MOUSE_WHEEL,this.wheelMove);
      }
      
      private function moveUp(evt:MouseEvent) : void
      {
         this.upButton.addEventListener(Event.ENTER_FRAME,this.upScroll);
      }
      
      private function moveDown(evt:MouseEvent) : void
      {
         this.downButton.addEventListener(Event.ENTER_FRAME,this.downScroll);
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
         this.scrollBtn.startDrag(false,this.scrollArea);
         this.scrollBtn.addEventListener(Event.ENTER_FRAME,this.update);
      }
      
      private function stopScroll(evt:MouseEvent) : void
      {
         this.scrollBtn.stopDrag();
         this.scrollBtn.removeEventListener(Event.ENTER_FRAME,this.update);
         this.upButton.removeEventListener(Event.ENTER_FRAME,this.upScroll);
         this.downButton.removeEventListener(Event.ENTER_FRAME,this.downScroll);
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
         this.upButton.removeEventListener(MouseEvent.MOUSE_DOWN,this.moveUp);
         this.downButton.removeEventListener(MouseEvent.MOUSE_DOWN,this.moveDown);
         this.scrollBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.scroll);
         if(Boolean(stage))
         {
            stage.removeEventListener(MouseEvent.MOUSE_UP,this.stopScroll);
         }
         this.removeEventListener(MouseEvent.ROLL_OVER,this.onMouseOver);
         this.target.removeEventListener(MouseEvent.ROLL_OVER,this.onMouseOver);
         if(this.target.parent != null)
         {
            this.target.parent.mask = null;
            this.target.parent.removeChild(this.shape);
         }
         this.scrollArea = null;
         this.removeChild(this.upButton);
         this.upButton = null;
         this.removeChild(this.downButton);
         this.downButton = null;
         this.removeChild(this.scrollBtn);
         this.scrollBtn = null;
         this.removeChild(this.scroll_bg_mc);
         this.scroll_bg_mc = null;
         this.target = null;
         this.maskRect = null;
         this.shape = null;
      }
   }
}

