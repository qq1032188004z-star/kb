package com.game.util
{
   import com.game.modules.view.WindowLayer;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol989")]
   public class FloatAlert extends Sprite
   {
      
      public var msgTxt:TextField;
      
      public var bgClip:MovieClip;
      
      private var floatDistance:Number = 100;
      
      private var speed:Number = 3;
      
      public function FloatAlert()
      {
         super();
      }
      
      public function show(parentObj:DisplayObjectContainer, x:Number, y:Number, msg:String, speed:Number = 3, floatDistance:Number = 100) : void
      {
         this.mouseChildren = false;
         this.mouseEnabled = false;
         this.floatDistance = floatDistance;
         this.speed = speed;
         this.msgTxt.text = msg;
         this.x = x - 50;
         this.y = y - 50;
         if(parentObj != null)
         {
            parentObj.addChild(this);
         }
         else
         {
            WindowLayer.instance.addChild(this);
         }
         this.addEventListener(Event.ENTER_FRAME,this.enterFrameHandler);
      }
      
      private function enterFrameHandler(evt:Event) : void
      {
         this.y -= this.speed;
         this.floatDistance -= this.speed;
         if(this.floatDistance <= 0)
         {
            this.removeEventListener(Event.ENTER_FRAME,this.enterFrameHandler);
            if(Boolean(this.parent))
            {
               this.parent.removeChild(this);
            }
         }
      }
   }
}

