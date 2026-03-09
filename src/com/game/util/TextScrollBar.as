package com.game.util
{
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TextScrollBar extends Sprite
   {
      
      private var upBtn:SimpleButton;
      
      private var downBtn:SimpleButton;
      
      private var flag:Boolean = true;
      
      private var textField:TextField;
      
      private var scrollBtn:SimpleButton;
      
      private var distance:Number;
      
      public function TextScrollBar(ub:SimpleButton, sb:SimpleButton, db:SimpleButton, textfield:TextField, d:Number)
      {
         super();
         this.upBtn = ub;
         this.scrollBtn = sb;
         this.downBtn = db;
         this.textField = textfield;
         this.distance = d;
         this.initListen();
      }
      
      public function updata() : void
      {
         if(this.textField.textHeight > this.textField.height)
         {
            this.scrollBtn.visible = true;
         }
         this.textField.scrollV = this.textField.maxScrollV;
         this.scrollBtn.y = this.textField.scrollV / this.textField.maxScrollV * this.distance;
      }
      
      private function onClickUpHandler(event:MouseEvent) : void
      {
         if(this.scrollBtn.y > this.scrollBtn.height / 2 && this.textField.scrollV > 0)
         {
            --this.scrollBtn.y;
            this.textField.scrollV = this.scrollBtn.y / (this.distance - this.scrollBtn.height / 2) * this.textField.maxScrollV;
         }
      }
      
      private function onMouseDownscrollBtn(event:MouseEvent) : void
      {
         this.flag = false;
         this.scrollBtn.stage.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUpscrollBtn);
         this.scrollBtn.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMovescrollBtn);
      }
      
      private function onMouseUpscrollBtn(event:MouseEvent) : void
      {
         this.flag = true;
         if(Boolean(this.scrollBtn))
         {
            this.scrollBtn.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMovescrollBtn);
            this.scrollBtn.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMovescrollBtn);
         }
      }
      
      private function onMouseWheeltextField(event:MouseEvent) : void
      {
         if(Boolean(this.scrollBtn))
         {
            this.scrollBtn.y = this.textField.scrollV / this.textField.maxScrollV * (this.distance - 15);
            this.scrollBtn.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMovescrollBtn);
         }
      }
      
      public function destroy() : void
      {
         this.scrollBtn.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMovescrollBtn);
         if(Boolean(stage))
         {
            this.scrollBtn.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUpscrollBtn);
            this.scrollBtn.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMovescrollBtn);
         }
         this.scrollBtn = null;
         this.textField = null;
      }
      
      private function onMouseOutscrollBtn(event:MouseEvent) : void
      {
         this.flag = true;
         if(Boolean(this.scrollBtn))
         {
            this.scrollBtn.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMovescrollBtn);
            this.scrollBtn.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMovescrollBtn);
         }
      }
      
      private function initListen() : void
      {
         this.scrollBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDownscrollBtn);
         this.textField.addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheeltextField);
         this.upBtn.addEventListener(MouseEvent.CLICK,this.onClickUpHandler);
         this.downBtn.addEventListener(MouseEvent.CLICK,this.onClickDownHandler);
         this.scrollBtn.visible = false;
      }
      
      private function onMouseMovescrollBtn(event:MouseEvent) : void
      {
         if(this.scrollBtn == null)
         {
            return;
         }
         var temp:int = this.scrollBtn.height / 2;
         var value:Number = mouseY - this.scrollBtn.parent.parent.y - temp;
         if(value > this.distance)
         {
            this.scrollBtn.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMovescrollBtn);
            this.scrollBtn.y = this.distance;
            this.textField.scrollV = this.textField.maxScrollV;
         }
         else if(value < temp)
         {
            this.scrollBtn.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMovescrollBtn);
            this.scrollBtn.y = temp;
            this.textField.scrollV = 0;
         }
         else
         {
            this.scrollBtn.y = value;
            this.textField.scrollV = value / (this.distance - temp) * this.textField.maxScrollV;
         }
         event.updateAfterEvent();
      }
      
      private function onClickDownHandler(event:MouseEvent) : void
      {
         if(this.scrollBtn.y < this.distance && this.textField.scrollV < this.textField.maxScrollV)
         {
            ++this.scrollBtn.y;
            this.textField.scrollV = this.scrollBtn.y / (this.distance - this.scrollBtn.height / 2) * this.textField.maxScrollV;
         }
      }
   }
}

