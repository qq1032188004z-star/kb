package com.game.modules.vo.list
{
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class OnlineTimerList
   {
      
      private var onlines:Array = [];
      
      private var _timer:Timer;
      
      private var delay:int = 1000;
      
      public function OnlineTimerList()
      {
         super();
      }
      
      public function addOnline($function:Function) : void
      {
         if(!this.hasOnline($function))
         {
            this.onlines.push($function);
            if(!this.timer.running)
            {
               this.timer.start();
            }
         }
      }
      
      public function delOnline($function:Function) : void
      {
         var funcs:Array = null;
         var index:int = this.indexOf($function);
         if(index != -1)
         {
            funcs = this.onlines.splice(index,1);
            funcs[0] = null;
            funcs = null;
         }
      }
      
      public function hasOnline($function:Function) : Boolean
      {
         return this.indexOf($function) != -1;
      }
      
      public function indexOf($function:Function) : int
      {
         return this.onlines.indexOf($function);
      }
      
      public function disport() : void
      {
         var func:Function = null;
         if(Boolean(this._timer))
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.onTimerHandler);
            this._timer = null;
         }
         if(Boolean(this.onlines))
         {
            while(this.onlines.length > 0)
            {
               func = this.onlines.shift();
               func = null;
            }
            this.onlines = null;
         }
      }
      
      private function get timer() : Timer
      {
         if(this._timer == null)
         {
            this._timer = new Timer(this.delay);
            this._timer.addEventListener(TimerEvent.TIMER,this.onTimerHandler);
         }
         return this._timer;
      }
      
      private function onTimerHandler(e:TimerEvent) : void
      {
         var func:Function = null;
         if(this.onlines.length > 0)
         {
            for each(func in this.onlines)
            {
               func.apply();
            }
         }
         else
         {
            this.timer.stop();
         }
      }
   }
}

