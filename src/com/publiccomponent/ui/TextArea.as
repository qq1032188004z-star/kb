package com.publiccomponent.ui
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol71")]
   public class TextArea extends Sprite
   {
      
      public var chatbg:MovieClip;
      
      public var spCon:Sprite;
      
      public var msgTxt:TextField;
      
      private var tid:int;
      
      public function TextArea(x:Number = 0, y:Number = 0, dir:int = 1)
      {
         super();
         this.x = x;
         this.y = y;
         this.mouseEnabled = false;
         this.mouseChildren = false;
         this.spCon.visible = this.chatbg.visible = false;
         this.msgTxt.text = "";
         if(dir == 2)
         {
            this.chatbg.rotationMc.gotoAndStop(2);
         }
         else
         {
            this.chatbg.rotationMc.gotoAndStop(1);
         }
         this.msgTxt.width = 114;
         this.msgTxt.multiline = true;
         this.msgTxt.autoSize = TextFieldAutoSize.LEFT;
         this.msgTxt.wordWrap = true;
      }
      
      public function set text(value:String) : void
      {
         clearTimeout(this.tid);
         this.visible = true;
         this.msgTxt.text = value;
         this.spCon.visible = this.chatbg.visible = value.length != 0;
         if(this.chatbg.visible)
         {
            this.spCon.width = this.msgTxt.textWidth + 10;
            this.spCon.height = this.msgTxt.textHeight + 8;
            this.spCon.x = this.chatbg.x - this.spCon.width / 2;
            this.spCon.y = this.chatbg.y - this.spCon.height - 10;
            this.msgTxt.x = this.chatbg.x + 4 - this.spCon.width / 2;
            this.msgTxt.y = this.chatbg.y - this.spCon.height - 8;
         }
         this.tid = setTimeout(this.delay,5000);
      }
      
      public function clear() : void
      {
         this.text = "";
         this.dispos();
      }
      
      private function delay() : void
      {
         this.dispos();
      }
      
      public function dispos() : void
      {
         clearTimeout(this.tid);
         if(this.parent != null)
         {
            if(this.parent.contains(this))
            {
               this.parent.removeChild(this);
            }
         }
      }
   }
}

