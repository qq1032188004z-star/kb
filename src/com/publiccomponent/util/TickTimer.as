package com.publiccomponent.util
{
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class TickTimer
   {
      
      private static var _instance:TickTimer;
      
      private var _timer:Timer;
      
      private var _timerList:Array = [];
      
      public function TickTimer()
      {
         super();
         this._timer = new Timer(1000);
         this._timer.addEventListener(TimerEvent.TIMER,this.onTimer);
      }
      
      public static function getInstance() : TickTimer
      {
         if(_instance == null)
         {
            _instance = new TickTimer();
         }
         return _instance;
      }
      
      public function addTimerHandler($callback:Function, $priority:int = 4) : void
      {
         if(this._timerList.indexOf($callback) == -1)
         {
            this._timerList.splice($priority,0,$callback);
         }
         this.enableTimer(this._timerList.length > 0);
      }
      
      public function removeTimerHandler($callback:Function) : void
      {
         var index:int = int(this._timerList.indexOf($callback));
         if(index != -1)
         {
            this._timerList.splice(index,1);
         }
         this.enableTimer(this._timerList.length > 0);
      }
      
      private function onTimer(evt:TimerEvent) : void
      {
         var handler:Function = null;
         for each(handler in this._timerList)
         {
            handler();
         }
      }
      
      private function enableTimer($enabled:Boolean) : void
      {
         if($enabled)
         {
            if(!this._timer.running)
            {
               this._timer.start();
            }
         }
         else
         {
            this._timer.stop();
         }
      }
      
      public function stop() : void
      {
         this._timer.stop();
      }
   }
}

