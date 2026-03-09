package com.game.myComboBox
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
   
   public class ArchivesScrollBar extends Sprite
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
      
      public function ArchivesScrollBar(maskRect:Rectangle, target:DisplayObject, upStyleName:String = "upBtn", downStyleName:String = "downBtn", scrollStyleName:String = "scrollBtn", scrollbgStyleName:String = "scrollbg")
      {
         super();
         this.scroll_bg_mc = MaterialLib.getInstance().getMaterial(scrollbgStyleName) as MovieClip;
         addChild(this.scroll_bg_mc);
         this.scroll_bg_mc.height = maskRect.height - 50;
         this.scroll_bg_mc.y += 25;
         this.upButton = MaterialLib.getInstance().getMaterial(upStyleName) as SimpleButton;
         this.upButton.x -= 2;
         addChild(this.upButton);
         this.scrollBtn = MaterialLib.getInstance().getMaterial(scrollStyleName) as MovieClip;
         this.scrollBtn.y = this.scroll_bg_mc.y;
         this.scrollBtn.x += 0;
         this.scrollBtn.buttonMode = true;
         addChild(this.scrollBtn);
         this.downButton = MaterialLib.getInstance().getMaterial(downStyleName) as SimpleButton;
         this.downButton.y = maskRect.height - this.downButton.height;
         this.downButton.x -= 2;
         addChild(this.downButton);
         this.scrollHeight = this.scroll_bg_mc.height;
         this.top = this.scroll_bg_mc.y;
         this.bottom = this.scroll_bg_mc.height - this.scrollBtn.height;
         this.maskRect = maskRect;
         this.target = target;
         this.targetInitY = target.y;
         this.scrollArea = new Rectangle(this.scrollBtn.x,this.scrollBtn.y,0,this.bottom);
         this.setTargetMask();
      }
      
      public function setTargetMask(tar:DisplayObject = null) : void
      {
         if(this.target != null)
         {
            this.target.mask = null;
         }
         if(tar != null)
         {
            this.target = tar;
            this.targetInitY = this.target.y;
         }
         this.scrollableHeight = this.target.height - this.maskRect.height;
         if(this.shape == null)
         {
            this.shape = new Shape();
            this.shape.graphics.beginFill(16711680,1);
            this.shape.graphics.drawRect(this.maskRect.x,this.maskRect.y,this.maskRect.width,this.maskRect.height);
            this.shape.graphics.endFill();
            this.target.parent.addChild(this.shape);
         }
         this.target.mask = this.shape;
         this.addEventListener(Event.ADDED_TO_STAGE,this.onAddToStage);
      }
      
      public function updateScrollBarVisible() : void
      {
         var lastHeight:Number = this.scrollBtn.height;
         this.scrollBtn.height = this.maskRect.height / this.target.height * this.scroll_bg_mc.height;
         if(lastHeight != this.scrollBtn.height)
         {
            this.heightChanged = true;
         }
         this.bottom = this.scroll_bg_mc.height - this.scrollBtn.height + 7;
         this.scrollableHeight = this.target.height - this.maskRect.height;
         if(this.scrollableHeight <= 0)
         {
            this.updateScrollBarButtons(false);
            this.scrollBtn.y = this.scroll_bg_mc.y;
            this.update(null);
         }
         else
         {
            this.updateScrollBarButtons(true);
            this.visible = true;
            if(this.scrollBtn.y + this.scrollBtn.height > this.scroll_bg_mc.y + this.scroll_bg_mc.height + 7)
            {
               this.scrollBtn.y = this.scroll_bg_mc.y + this.scroll_bg_mc.height - this.scrollBtn.height + 7;
               this.update(null);
            }
         }
      }
      
      public function updateScrollBarButtons(flag:Boolean) : void
      {
         if(this.scrollBtn.visible == flag)
         {
            return;
         }
         this.scrollBtn.visible = flag;
         if(flag)
         {
            this.upButton.addEventListener(MouseEvent.MOUSE_DOWN,this.moveUp);
            this.downButton.addEventListener(MouseEvent.MOUSE_DOWN,this.moveDown);
            this.scrollBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.scroll);
            if(Boolean(stage))
            {
               stage.addEventListener(MouseEvent.MOUSE_UP,this.stopScroll);
            }
            this.addEventListener(MouseEvent.ROLL_OVER,this.onMouseOver);
            this.target.addEventListener(MouseEvent.ROLL_OVER,this.onMouseOver);
         }
         else
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
         }
      }
      
      public function alwaysShowLastest() : void
      {
         if(!this.heightChanged || !this.visible)
         {
            return;
         }
         this.scrollBtn.y = this.scroll_bg_mc.y + this.scroll_bg_mc.height - this.scrollBtn.height;
         this.update(null);
      }
      
      private function onAddToStage(evt:Event) : void
      {
         this.removeEventListener(Event.ADDED_TO_STAGE,this.onAddToStage);
         this.updateScrollBarButtons(false);
      }
      
      private function onMouseOver(evt:MouseEvent) : void
      {
         this.addEventListener(MouseEvent.ROLL_OUT,this.onMouseOut);
         this.target.addEventListener(MouseEvent.ROLL_OUT,this.onMouseOut);
      }
      
      private function onMouseOut(evt:MouseEvent) : void
      {
         this.removeEventListener(MouseEvent.ROLL_OUT,this.onMouseOut);
         if(Boolean(this.shape))
         {
            this.shape.removeEventListener(MouseEvent.ROLL_OUT,this.onMouseOut);
         }
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
         this.scrollArea.height = this.bottom;
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
         if(this.scrollBtn == null || this.scroll_bg_mc == null)
         {
            return;
         }
         this.scrollBtn.y = Math.max(this.top,this.scrollBtn.y - this.moveSpeed);
         if(this.scrollBtn.y <= this.scroll_bg_mc.y)
         {
            this.scrollBtn.y = this.scroll_bg_mc.y;
         }
         this.update(null);
      }
      
      private function downScroll(evt:Event) : void
      {
         if(this.scroll_bg_mc != null && this.scrollBtn != null)
         {
            this.scrollBtn.y = Math.min(this.scroll_bg_mc.y + this.scroll_bg_mc.height - this.scrollBtn.height + 7,this.scrollBtn.y + this.moveSpeed);
         }
         this.update(null);
      }
      
      private function update(evt:Event = null) : void
      {
         if(this.target == null || this.scrollBtn == null)
         {
            return;
         }
         var percen_scroll:Number = (this.scrollBtn.y - this.scroll_bg_mc.y) / (this.scrollHeight - this.scrollBtn.height);
         this.target.y = Math.round(this.targetInitY - this.scrollableHeight * percen_scroll);
      }
      
      public function resetScrollBtnPosition() : void
      {
         this.scrollBtn.y = this.scroll_bg_mc.y;
         this.scrollBtn.x += 0;
         if(Boolean(this.target))
         {
            this.target.y = this.targetInitY;
         }
      }
      
      public function dispos() : void
      {
         this.upButton.removeEventListener(MouseEvent.MOUSE_DOWN,this.moveUp);
         this.downButton.removeEventListener(MouseEvent.MOUSE_DOWN,this.moveDown);
         this.scrollBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.scroll);
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.stopScroll);
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

