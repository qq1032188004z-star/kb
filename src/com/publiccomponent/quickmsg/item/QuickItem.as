package com.publiccomponent.quickmsg.item
{
   import com.publiccomponent.quickmsg.event.QuickMessageEvent;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class QuickItem extends Sprite
   {
      
      public static const ADDITEM:String = "additem";
      
      public static const HIDEITEM:String = "hideitem";
      
      private var num:int;
      
      private var txt:String;
      
      private var index:int;
      
      private var xml:XML;
      
      public var itemmc:MovieClip;
      
      public function QuickItem(mc:MovieClip, index:int, xml:XML, num:int)
      {
         super();
         this.itemmc = mc["itemmc"];
         this.itemmc.cacheAsBitmap = true;
         this.itemmc.mouseChildren = false;
         this.x = 5;
         this.y = index;
         this.xml = xml;
         this.num = num;
         this.itemmc.stop();
         this.initEvents();
         addChild(this.itemmc);
      }
      
      private function initTxt() : void
      {
         if(Boolean(this.itemmc))
         {
            this.itemmc.txt.text = String(this.xml.@name);
         }
      }
      
      private function initEvents() : void
      {
         this.itemmc.addEventListener(MouseEvent.ROLL_OVER,this.onOver);
         this.itemmc.addEventListener(MouseEvent.ROLL_OUT,this.onOut);
         this.itemmc.addFrameScript(0,this.initTxt);
         this.itemmc.addFrameScript(1,this.initTxt);
      }
      
      public function dispos() : void
      {
         this.xml = null;
         this.itemmc = null;
         this.itemmc.removeEventListener(MouseEvent.ROLL_OVER,this.onOver);
         this.itemmc.removeEventListener(MouseEvent.ROLL_OUT,this.onOut);
         this.itemmc.addFrameScript(0,null);
         this.itemmc.addFrameScript(1,null);
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
      
      private function onOut(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         if(Boolean(this.itemmc))
         {
            this.itemmc.gotoAndStop(1);
         }
      }
      
      private function onOver(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         if(Boolean(this.itemmc))
         {
            this.itemmc.gotoAndStop(2);
         }
         if(Boolean(this.xml))
         {
            this.dispatchEvent(new QuickMessageEvent(ADDITEM,{
               "len":this.xml.children().length(),
               "xml":this.xml,
               "num":this.num
            }));
         }
      }
   }
}

