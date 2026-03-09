package com.game.modules.view.person
{
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol922")]
   public class PersonUserNameAlert extends Sprite
   {
      
      public var closeBtn:SimpleButton;
      
      public var nameTxt:TextField;
      
      public var okBtn:SimpleButton;
      
      public function PersonUserNameAlert()
      {
         super();
         this.graphics.beginFill(0,0.3);
         this.graphics.drawRect(-1000,-1000,2000,2000);
         this.graphics.endFill();
         this.initEvent();
      }
      
      private function initEvent() : void
      {
         this.closeBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.closeView);
         this.okBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.closeView);
      }
      
      private function removeEvent() : void
      {
         this.closeBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.closeView);
         this.okBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.closeView);
      }
      
      public function showUserName(userName:String) : void
      {
         this.nameTxt.text = userName;
      }
      
      private function closeView(evt:MouseEvent) : void
      {
         this.dispos();
      }
      
      public function dispos() : void
      {
         this.graphics.clear();
         this.removeEvent();
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

