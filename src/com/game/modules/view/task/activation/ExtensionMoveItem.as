package com.game.modules.view.task.activation
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class ExtensionMoveItem extends Sprite
   {
      
      private var mc:MovieClip;
      
      private var speed:int = 0;
      
      public var flag:Boolean = false;
      
      public var xIndex:int;
      
      public var yIndex:int;
      
      public var _status:int;
      
      public var removed:Boolean = true;
      
      public var stoped:Boolean = true;
      
      public function ExtensionMoveItem(cls:Class, status:int, type:Boolean, xCoord:int, yCoord:int)
      {
         super();
         this.xIndex = xCoord;
         this.yIndex = yCoord;
         this.flag = type;
         this._status = status;
         this.mc = new cls() as MovieClip;
         this.mc.gotoAndStop(status);
         this.addChild(this.mc);
         this.mc.x = 0;
         this.mc.y = 0;
         if(this.flag)
         {
            this.buttonMode = true;
            this.addEventListener(MouseEvent.CLICK,this.onMouseClick);
         }
      }
      
      private function onMouseClick(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         if(this.mc.currentFrame == this.mc.totalFrames)
         {
            this._status = 1;
         }
         else
         {
            ++this._status;
         }
         this.mc.gotoAndStop(this._status);
      }
      
      private function onEnterFrame(evt:Event) : void
      {
         if(!this.flag)
         {
            return;
         }
         var vx:int = 0;
         var vy:int = 0;
         if(this._status == 1)
         {
            vx = 1;
         }
         else if(this._status == 2)
         {
            vy = 1;
         }
         else if(this._status == 3)
         {
            vx = -1;
         }
         else
         {
            vy = -1;
         }
         if(vx < 0 && this.x <= 0)
         {
            this.x = 0;
            this.removeEvent();
            return;
         }
         if(vx > 0 && this.x >= 400)
         {
            this.x = 400;
            this.removeEvent();
            return;
         }
         if(vy < 0 && this.y <= 0)
         {
            this.y = 0;
            this.removeEvent();
            return;
         }
         if(vy > 0 && this.y >= 350)
         {
            this.y = 350;
            this.removeEvent();
            return;
         }
         this.x += vx * this.speed;
         this.y += vy * this.speed;
      }
      
      private function removeEvent() : void
      {
         this.stoped = true;
         this.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      public function removeClick(speed:int) : void
      {
         if(!this.flag)
         {
            return;
         }
         this.removeEventListener(MouseEvent.CLICK,this.onMouseClick);
         this.speed = speed;
         this.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         this.stoped = false;
      }
      
      public function stop() : void
      {
         this.removeEvent();
      }
      
      public function win() : void
      {
         this.stoped = true;
         this.dispos();
      }
      
      public function dispos() : void
      {
         if(this.hasEventListener(Event.ENTER_FRAME))
         {
            this.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         }
         if(this.hasEventListener(MouseEvent.CLICK))
         {
            this.removeEventListener(MouseEvent.CLICK,this.onMouseClick);
         }
         this.flag = false;
         this.xIndex = 0;
         this.yIndex = 0;
         this._status = 0;
         this.mc.gotoAndStop(1);
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
         this.removed = true;
      }
   }
}

