package com.publiccomponent.loading
{
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class HloadManager
   {
      
      private static var _instance:HloadManager;
      
      private var timeline:int;
      
      public var sbloading:Boolean = false;
      
      public var isloading:Boolean = false;
      
      private var loadtime:Timer;
      
      private var loadarr:Array = [];
      
      public function HloadManager()
      {
         super();
      }
      
      public static function get instance() : HloadManager
      {
         if(_instance == null)
         {
            _instance = new HloadManager();
         }
         return _instance;
      }
      
      private function onTimeHandler(event:TimerEvent) : void
      {
         ++this.timeline;
         this.loadarr.forEach(this.loadLineCheck);
      }
      
      public function removeFromCheck(value:Hload) : void
      {
         var index:int = int(this.loadarr.indexOf(value));
         if(index != -1)
         {
            this.loadarr.splice(index,1);
         }
         if(this.loadarr.length == 0)
         {
            this.stopTime();
            this.isloading = false;
            GreenLoading.loading.visible = false;
         }
      }
      
      public function addToCheck(value:Hload) : void
      {
         value.timeline = this.timeline;
         this.loadarr.push(value);
         if(this.loadtime == null)
         {
            this.startTime();
         }
         this.isloading = true;
      }
      
      private function loadLineCheck(element:Hload, index:int, arr:Array) : void
      {
         if(element.timeline + 1 < this.timeline && element.needReload())
         {
            if(element.loadtimes < element.loadMaxTimes)
            {
               element.reload();
            }
         }
      }
      
      private function startTime() : void
      {
         this.stopTime();
         this.loadtime = new Timer(10000);
         this.loadtime.addEventListener(TimerEvent.TIMER,this.onTimeHandler);
         this.loadtime.start();
         this.timeline = 0;
      }
      
      private function stopTime() : void
      {
         if(Boolean(this.loadtime))
         {
            this.loadtime.stop();
            this.loadtime.removeEventListener(TimerEvent.TIMER,this.onTimeHandler);
            this.loadtime = null;
         }
      }
   }
}

