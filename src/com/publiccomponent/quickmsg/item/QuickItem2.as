package com.publiccomponent.quickmsg.item
{
   import com.channel.Message;
   import com.publiccomponent.quickmsg.event.QuickMessageEvent;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class QuickItem2 extends Sprite
   {
      
      public static const CLOSE:String = "close";
      
      public var dialogmc:MovieClip;
      
      private var num:int;
      
      private var xml:XML;
      
      public function QuickItem2(mc:MovieClip, index:int, xml:XML, num:int)
      {
         super();
         this.dialogmc = mc["dialogmc"];
         this.dialogmc.cacheAsBitmap = true;
         this.dialogmc.mouseChildren = false;
         this.dialogmc.buttonMode = true;
         this.x = 20;
         this.y = index;
         this.xml = xml;
         this.num = num + 1;
         this.initEvents();
         this.initTxt();
         addChild(this.dialogmc);
      }
      
      private function initTxt() : void
      {
         if(Boolean(this.dialogmc))
         {
            this.dialogmc.txt.text = String(this.xml["txt" + this.num]);
         }
      }
      
      private function ondown(evt:MouseEvent) : void
      {
         if(Boolean(this.dialogmc))
         {
            this.dialogmc.removeEventListener(MouseEvent.MOUSE_DOWN,this.ondown);
         }
         new Message("onsendqkmsg",String(this.dialogmc.txt.text)).sendToChannel("itemclick");
         this.dispatchEvent(new QuickMessageEvent(CLOSE));
      }
      
      private function initEvents() : void
      {
         this.dialogmc.addEventListener(MouseEvent.MOUSE_DOWN,this.ondown,false);
      }
      
      public function dispos() : void
      {
         this.xml = null;
         this.dialogmc = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

