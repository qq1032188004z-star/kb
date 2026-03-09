package com.game.modules.tweener
{
   import com.game.global.GlobalConfig;
   import com.game.modules.control.task.TaskEvent;
   import com.game.modules.control.task.util.TaskUtils;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class Tweener
   {
      
      private var ui:MovieClip;
      
      private var destX:Number;
      
      private var destY:Number;
      
      private var speed:Number;
      
      private var userId:int;
      
      private var callBack:Function;
      
      private var data:Object;
      
      public function Tweener()
      {
         super();
      }
      
      public function addTween(ui:MovieClip, destX:Number, destY:Number, speed:Number, userId:int, callBack:Function = null, data:Object = null) : void
      {
         this.ui = ui;
         this.destX = destX;
         this.destY = destY;
         this.userId = userId;
         this.callBack = callBack;
         this.data = data;
         this.speed = speed;
         var dx:Number = destX - ui.x;
         var dy:Number = destY - ui.y;
         var distance:Number = Math.sqrt(dx * dx + dy * dy);
         this.speed = distance / 10;
         if(ui != null)
         {
            ui.addEventListener(Event.ENTER_FRAME,this.enterFrameHandler);
         }
      }
      
      private function enterFrameHandler(evt:Event) : void
      {
         var dx:Number = this.destX - this.ui.x;
         var dy:Number = this.destY - this.ui.y;
         var distance:Number = Math.sqrt(dx * dx + dy * dy);
         var vx:Number = dx / distance * this.speed;
         var vy:Number = dy / distance * this.speed;
         if(isNaN(vx))
         {
            vx = 0;
         }
         if(isNaN(vy))
         {
            vy = 0;
         }
         if(Math.abs(dx) < Math.abs(vx))
         {
            vx = dx;
         }
         if(Math.abs(dy) < Math.abs(vy))
         {
            vy = dy;
         }
         this.ui.x += vx;
         this.ui.y += vy;
         if(distance < 10)
         {
            if(this.ui != null)
            {
               this.ui.removeEventListener(Event.ENTER_FRAME,this.enterFrameHandler);
               if(this.ui.totalFrames > 1)
               {
                  this.ui.addFrameScript(this.ui.totalFrames - 1,null);
                  this.ui.addFrameScript(this.ui.totalFrames - 1,this.dispos);
                  this.ui.gotoAndPlay(2);
               }
               else
               {
                  this.dispos();
               }
            }
         }
      }
      
      private function dispos() : void
      {
         if(this.callBack != null)
         {
            this.callBack(this.data);
         }
         if(this.ui != null)
         {
            this.ui.addFrameScript(this.ui.totalFrames - 1,null);
            this.ui.stop();
            if(Boolean(this.ui.parent))
            {
               this.ui.parent.removeChild(this.ui);
            }
         }
         this.ui = null;
         if(this.userId == GlobalConfig.userId)
         {
            TaskUtils.getInstance().dispatchEvent(TaskEvent.OP_MOUSE_ACTION_AI);
         }
      }
   }
}

