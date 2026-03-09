package org.engine.frame
{
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.utils.getTimer;
   
   public class FrameTimer
   {
      
      private static var instance:FrameTimer;
      
      private var callBackList:Array = [];
      
      private var renderCallList:Array = [];
      
      private var count:int;
      
      private var lastTime:Number = 0;
      
      private var currentTime:Number;
      
      private var frameSprite:Sprite = new Sprite();
      
      private var stage:Stage;
      
      private var isActive:Boolean;
      
      public function FrameTimer()
      {
         super();
         if(instance != null)
         {
            throw new Error("单列类只能被实例化一次");
         }
         instance = this;
      }
      
      public static function getInstance() : FrameTimer
      {
         if(instance == null)
         {
            instance = new FrameTimer();
         }
         return instance;
      }
      
      public function start(stage:Stage = null) : void
      {
         if(stage != null)
         {
            this.stage = stage;
         }
         if(this.stage != null)
         {
            this.stage.removeEventListener(Event.ACTIVATE,this.onActive);
            this.stage.removeEventListener(Event.DEACTIVATE,this.onDeActive);
            this.stage.addEventListener(Event.ACTIVATE,this.onActive);
            this.stage.addEventListener(Event.DEACTIVATE,this.onDeActive);
         }
         this.frameSprite.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         this.frameSprite.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      private function onActive(evt:Event) : void
      {
         this.isActive = true;
      }
      
      private function onDeActive(evt:Event) : void
      {
         this.isActive = false;
      }
      
      private function onEnterFrame(evt:Event) : void
      {
         var callBack:Function = null;
         var callBack2:Function = null;
         if(this.lastTime == 0)
         {
            this.lastTime = getTimer();
         }
         this.currentTime = getTimer();
         var times:int = (this.currentTime - this.lastTime) * this.stage.frameRate / 1000;
         if((this.currentTime - this.lastTime) * this.stage.frameRate / 1000 < 0.5)
         {
            return;
         }
         this.lastTime = this.currentTime;
         if(times < 1)
         {
            times = 1;
         }
         if(this.isActive)
         {
            times /= 5;
            if(times < 1)
            {
               times = 1;
            }
         }
         if(times > 2)
         {
            times = 2;
         }
         for(var i:int = 0; i < times; i++)
         {
            for each(callBack in this.renderCallList)
            {
               callBack();
            }
            ++this.count;
            if(this.count > 2)
            {
               this.count = 0;
               for each(callBack2 in this.callBackList)
               {
                  callBack2();
               }
            }
         }
      }
      
      public function stop() : void
      {
         this.frameSprite.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      public function addCallBack(callBack:Function, flag:int = 0) : void
      {
         var index:int = 0;
         if(flag == 1)
         {
            index = int(this.renderCallList.indexOf(callBack));
            if(index == -1)
            {
               this.renderCallList.push(callBack);
            }
         }
         else
         {
            index = int(this.callBackList.indexOf(callBack));
            if(index == -1)
            {
               this.callBackList.push(callBack);
            }
         }
      }
      
      public function clearCallBack() : void
      {
         this.callBackList.length = 0;
         this.renderCallList.length = 0;
      }
      
      public function removeCallBack(callBack:Function, flag:int = 0) : void
      {
         var index:int = 0;
         if(flag == 1)
         {
            index = int(this.renderCallList.indexOf(callBack));
            if(index != -1)
            {
               this.renderCallList.splice(index,1);
            }
         }
         else
         {
            index = int(this.callBackList.indexOf(callBack));
            if(index != -1)
            {
               this.callBackList.splice(index,1);
            }
         }
      }
      
      public function hasCallBack(callBack:Function) : Boolean
      {
         return this.callBackList.indexOf(this.callBackList) != -1;
      }
   }
}

