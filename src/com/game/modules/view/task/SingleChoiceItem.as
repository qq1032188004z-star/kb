package com.game.modules.view.task
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class SingleChoiceItem extends Sprite
   {
      
      private var mc:MovieClip;
      
      private var uid:int;
      
      private var callback:Function;
      
      public var beChoocen:Boolean;
      
      public function SingleChoiceItem(mc:MovieClip, describe:String, uid:int, callback:Function)
      {
         super();
         this.uid = uid + 1;
         this.callback = callback;
         this.mc = mc;
         this.mc.flag.buttonMode = true;
         this.addChild(this.mc);
         this.mc.flag.gotoAndStop(1);
         this.mc.desc.text = describe;
         this.addEventListener(MouseEvent.CLICK,this.onMouseClickFlag);
         this.mc.buttonMode = true;
      }
      
      public function changeState() : void
      {
         this.mc.flag.gotoAndStop(1);
         this.beChoocen = false;
      }
      
      private function onMouseClickFlag(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         if(this.mc.flag.currentFrame == 1)
         {
            this.mc.flag.gotoAndStop(2);
            this.beChoocen = true;
         }
         else
         {
            this.mc.flag.gotoAndStop(1);
            this.beChoocen = false;
         }
         this.callback.apply(null,[this.uid,this.beChoocen]);
      }
      
      public function dispos() : void
      {
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
         this.removeEventListener(MouseEvent.CLICK,this.onMouseClickFlag);
         this.mc = null;
      }
   }
}

