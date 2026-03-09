package com.publiccomponent.util
{
   import flash.display.DisplayObject;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class SimpleTweener
   {
      
      public static var instance:SimpleTweener = new SimpleTweener();
      
      private var targetObj:DisplayObject;
      
      private var ty:Number;
      
      private var updown:Boolean;
      
      private var timer:Timer;
      
      public function SimpleTweener()
      {
         super();
      }
      
      public function addTweener(thisObj:DisplayObject, targetY:Number, flag:Boolean) : void
      {
         if(this.timer != null)
         {
            if(this.targetObj != null)
            {
               this.targetObj.y = this.ty;
            }
            this.timer.reset();
            this.timer.stop();
            this.timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
            this.timer = null;
         }
         this.timer = new Timer(100);
         this.timer.addEventListener(TimerEvent.TIMER,this.onTimer);
         this.timer.start();
         this.updown = flag;
         this.targetObj = thisObj;
         this.ty = targetY;
      }
      
      private function onTimer(evt:TimerEvent) : void
      {
         if(this.timer == null)
         {
            return;
         }
         if(this.targetObj == null)
         {
            this.timer.stop();
            this.timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
            this.timer = null;
            return;
         }
         if(this.ty <= this.targetObj.y + 100 && this.ty >= this.targetObj.y - 100)
         {
            this.timer.stop();
            this.timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
            this.timer = null;
            this.targetObj.y = this.ty;
            this.targetObj.visible = this.updown;
            this.targetObj = null;
         }
         else if(this.updown)
         {
            this.targetObj.y -= 100;
         }
         else
         {
            this.targetObj.y += 100;
         }
      }
   }
}

