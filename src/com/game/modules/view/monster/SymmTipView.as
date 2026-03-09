package com.game.modules.view.monster
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   public class SymmTipView extends Sprite
   {
      
      private var msgText:TextField;
      
      public var ground:MovieClip;
      
      public function SymmTipView()
      {
         super();
         this.mouseChildren = false;
         this.mouseEnabled = false;
         this.msgText = new TextField();
         this.msgText.x = 30;
         this.msgText.y = 12;
         this.msgText.width = 150;
         this.msgText.wordWrap = true;
         this.msgText.multiline = true;
         addChild(this.msgText);
      }
      
      override public function set x(value:Number) : void
      {
         if(value + width > 970)
         {
            super.x = 970 - width;
         }
         else
         {
            super.x = value;
         }
      }
      
      override public function set y(value:Number) : void
      {
         if(value + height > 570)
         {
            super.y = 570 - height;
         }
         else
         {
            super.y = value;
         }
      }
      
      public function disport() : void
      {
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
      
      public function setMsg(value:String) : void
      {
         this.msgText.htmlText = value;
         this.msgText.height = this.msgText.textHeight + 5;
         this.ground.height = this.msgText.height + this.msgText.y + 2;
      }
   }
}

