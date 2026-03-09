package com.game.modules.view.task.activation
{
   import com.publiccomponent.alert.Alert;
   import com.publiccomponent.loading.GreenLoading;
   import com.publiccomponent.loading.Hloader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.system.ApplicationDomain;
   import flash.utils.Timer;
   
   public class FlashingMouse extends Sprite
   {
      
      private var loader:Hloader;
      
      private var mc:MovieClip;
      
      private var fsm:int;
      
      private var timer:Timer;
      
      private var oldX:Number;
      
      private var oldY:Number;
      
      private var currentX:Number;
      
      private var currentY:Number;
      
      private var count:int = 0;
      
      private var callback:Function;
      
      public function FlashingMouse()
      {
         super();
         GreenLoading.loading.visible = true;
         this.loader = new Hloader("assets/material/flashingmouse.swf");
         this.loader.addEventListener(Event.COMPLETE,this.onLoadComplete);
         this.loader.addEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
      }
      
      private function onLoadError(evt:IOErrorEvent) : void
      {
         new Alert().show("额偶!~加载失败了呢...");
         this.dispos();
      }
      
      private function onLoadComplete(evt:Event) : void
      {
         evt.stopImmediatePropagation();
         GreenLoading.loading.visible = false;
         var domain:ApplicationDomain = this.loader.contentLoaderInfo.applicationDomain;
         var cls:* = domain.getDefinition("bg") as Class;
         this.mc = new cls() as MovieClip;
         this.mc.stop();
         this.mc.cacheAsBitmap = true;
         this.cacheAsBitmap = true;
         this.addChild(this.mc);
         this.mc.x = 0;
         this.mc.y = 0;
         this.loader.removeEventListener(Event.COMPLETE,this.onLoadComplete);
         this.loader.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
         this.setState(1);
      }
      
      private function setTime(delay:int = 2000) : void
      {
         if(this.timer != null)
         {
            this.timer.reset();
            this.timer.stop();
            this.timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
            this.timer = null;
         }
         this.timer = new Timer(delay);
         this.timer.addEventListener(TimerEvent.TIMER,this.onTimer);
         this.timer.start();
      }
      
      private function onTimer(evt:TimerEvent) : void
      {
         evt.stopImmediatePropagation();
         if(this.timer != null)
         {
            this.timer.reset();
            this.timer.stop();
            this.timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
            this.timer = null;
         }
         this.setState(this.fsm + 1);
      }
      
      private function setState(status:int) : void
      {
         this.fsm = status;
         switch(status)
         {
            case 1:
               this.mc.zongde.paopao.visible = false;
               this.mc.zongde.paopao.stop();
               this.mc.zongde.wenzi.visible = true;
               this.mc.zongde.wenzi.gotoAndStop(1);
               this.mc.zongde.piaodonghua.visible = false;
               this.mc.zongde.piaodonghua.stop();
               this.mc.zongde.jinmaoshu.gotoAndStop(1);
               this.mc.zongde.shuipiao.gotoAndStop(1);
               this.setTime();
               break;
            case 2:
               this.mc.zongde.wenzi.visible = false;
               this.mc.zongde.shuipiao.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDownPiao);
               this.mc.zongde.shuipiao.buttonMode = true;
               this.oldX = this.mc.zongde.shuipiao.x;
               this.oldY = this.mc.zongde.shuipiao.y;
               break;
            case 3:
               this.mc.zongde.shuipiao.gotoAndStop(2);
               this.mc.zongde.shuipiao.x = this.mc.zongde.shuipiao2.x;
               this.mc.zongde.shuipiao.y = this.mc.zongde.shuipiao2.y;
               this.mc.zongde.shuipiao.visible = true;
               this.mc.zongde.shuipiao.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDownPiao);
               this.mc.zongde.shuitong.gotoAndStop(1);
               this.mc.zongde.shuitong.addFrameScript(this.mc.zongde.shuitong.totalFrames - 1,null);
               break;
            case 4:
               this.mc.zongde.shuipiao.x = this.oldX;
               this.mc.zongde.shuipiao.y = this.oldY;
               this.mc.zongde.shuipiao.gotoAndStop(1);
               this.mc.zongde.shuipiao.buttonMode = false;
               this.mc.zongde.shuipiao.visible = true;
               this.mc.zongde.piaodonghua.stop();
               this.mc.zongde.piaodonghua.addFrameScript(this.mc.zongde.piaodonghua.totalFrames - 1,null);
               this.mc.zongde.piaodonghua.visible = false;
               this.mc.zongde.wenzi.gotoAndStop(2);
               this.mc.zongde.wenzi.visible = true;
               this.setTime();
               break;
            case 5:
               this.mc.zongde.wenzi.visible = false;
               this.mc.zongde.feizao.buttonMode = true;
               this.mc.zongde.feizao.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDownPiao);
               this.oldX = this.mc.zongde.feizao.x;
               this.oldY = this.mc.zongde.feizao.y;
               break;
            case 6:
               this.mc.zongde.feizao.stopDrag();
               this.mc.zongde.feizao.x = this.oldX;
               this.mc.zongde.feizao.y = this.oldY;
               this.mc.zongde.feizao.buttonMode = false;
               this.mc.zongde.feizao.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDownPiao);
               this.mc.zongde.feizao.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
               this.mc.zongde.feizao.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUpPiao);
               this.mc.zongde.feizao.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
               this.mc.zongde.wenzi.gotoAndStop(3);
               this.mc.zongde.wenzi.visible = true;
               this.setTime();
               break;
            case 7:
               this.mc.zongde.wenzi.visible = false;
               this.mc.zongde.shuipiao.buttonMode = true;
               this.mc.zongde.shuipiao.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDownPiao);
               this.oldX = this.mc.zongde.shuipiao.x;
               this.oldY = this.mc.zongde.shuipiao.y;
               break;
            case 8:
               this.mc.zongde.shuipiao.gotoAndStop(2);
               this.mc.zongde.shuipiao.x = this.mc.zongde.shuipiao2.x;
               this.mc.zongde.shuipiao.y = this.mc.zongde.shuipiao2.y;
               this.mc.zongde.shuipiao.visible = true;
               this.mc.zongde.shuipiao.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDownPiao);
               this.mc.zongde.shuitong.gotoAndStop(1);
               this.mc.zongde.shuitong.addFrameScript(this.mc.zongde.shuitong.totalFrames - 1,null);
               break;
            case 9:
               this.mc.zongde.shuipiao.x = this.oldX;
               this.mc.zongde.shuipiao.y = this.oldY;
               this.mc.zongde.shuipiao.gotoAndStop(1);
               this.mc.zongde.shuipiao.buttonMode = false;
               this.mc.zongde.shuipiao.visible = true;
               this.mc.zongde.piaodonghua.stop();
               this.mc.zongde.piaodonghua.addFrameScript(this.mc.zongde.piaodonghua.totalFrames - 1,null);
               this.mc.zongde.piaodonghua.visible = false;
               this.mc.zongde.wenzi.gotoAndStop(4);
               this.mc.zongde.wenzi.visible = true;
               this.setTime();
               break;
            case 10:
               this.mc.zongde.wenzi.visible = false;
               this.mc.zongde.maojing.buttonMode = true;
               this.mc.zongde.maojing.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDownPiao);
               this.oldX = this.mc.zongde.maojing.x;
               this.oldY = this.mc.zongde.maojing.y;
               break;
            case 11:
               this.mc.zongde.maojing.stopDrag();
               this.mc.zongde.maojing.x = this.oldX;
               this.mc.zongde.maojing.y = this.oldY;
               this.mc.zongde.maojing.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDownPiao);
               this.mc.zongde.maojing.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
               this.mc.zongde.maojing.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUpPiao);
               this.mc.zongde.maojing.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
               this.mc.zongde.maojing.buttonMode = false;
               this.mc.zongde.jinmaoshu.addFrameScript(this.mc.zongde.jinmaoshu.totalFrames - 1,this.gameOver);
               this.mc.zongde.jinmaoshu.gotoAndPlay(4);
         }
      }
      
      private function onMouseDownPiao(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         evt.currentTarget.startDrag();
         evt.currentTarget.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         evt.currentTarget.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUpPiao);
         this.mc.zongde.setChildIndex(evt.currentTarget,this.mc.zongde.numChildren - 1);
         if(this.fsm == 5 || this.fsm == 10)
         {
            evt.currentTarget.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
         }
      }
      
      private function onEnterFrame(evt:Event) : void
      {
         if(evt.currentTarget.x < -50 || evt.currentTarget.y < -70 || evt.currentTarget.x + evt.currentTarget.width > 360 || evt.currentTarget.y + evt.currentTarget.height > 160)
         {
            evt.currentTarget.stopDrag();
            evt.currentTarget.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
            evt.currentTarget.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUpPiao);
            evt.currentTarget.x = this.oldX;
            evt.currentTarget.y = this.oldY;
         }
      }
      
      private function onMouseUpPiao(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         evt.currentTarget.stopDrag();
         evt.currentTarget.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         evt.currentTarget.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUpPiao);
         if(this.fsm == 2 || this.fsm == 7)
         {
            if(Boolean(this.mc.zongde.shuipiao2.hitTestObject(this.mc.zongde.shuipiao)))
            {
               this.mc.zongde.shuipiao.visible = false;
               this.mc.zongde.shuipiao.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDownPiao);
               this.mc.zongde.shuitong.addFrameScript(this.mc.zongde.shuitong.totalFrames - 1,this.onGetWaterOK);
               this.mc.zongde.shuitong.play();
            }
         }
         else if(this.fsm == 3 || this.fsm == 8)
         {
            if(Boolean(this.mc.zongde.shuipiao.hitTestObject(this.mc.zongde.jinmaoshu)))
            {
               this.mc.zongde.shuipiao.visible = false;
               this.mc.zongde.shuipiao.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDownPiao);
               this.mc.zongde.piaodonghua.visible = true;
               this.mc.zongde.piaodonghua.addFrameScript(this.mc.zongde.piaodonghua.totalFrames - 1,this.onWaterOver);
               this.mc.zongde.piaodonghua.play();
               this.mc.zongde.paopao.visible = false;
               this.mc.zongde.jinmaoshu.nextFrame();
            }
         }
      }
      
      private function onMouseMove(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         if(Boolean(this.mc.zongde.jinmaoshu.hitTestObject(evt.currentTarget)))
         {
            if(this.fsm == 5)
            {
               this.mc.zongde.paopao.visible = true;
               if(this.mc.zongde.paopao.currentFrame < this.mc.zongde.paopao.totalFrames)
               {
                  if(this.countDistance(1) || this.mc.zongde.paopao.currentFrame == 1)
                  {
                     this.mc.zongde.paopao.nextFrame();
                     this.currentX = this.mc.zongde.feizao.x;
                     this.currentY = this.mc.zongde.feizao.y;
                  }
               }
               else
               {
                  this.setState(6);
               }
            }
            else if(this.fsm == 10)
            {
               if(this.countDistance(2) || this.count == 0)
               {
                  ++this.count;
                  this.currentX = this.mc.zongde.maojing.x;
                  this.currentY = this.mc.zongde.maojing.y;
               }
               if(this.count >= 5)
               {
                  this.setState(this.fsm + 1);
               }
            }
         }
      }
      
      private function onGetWaterOK() : void
      {
         this.setState(this.fsm + 1);
      }
      
      private function onWaterOver() : void
      {
         this.setState(this.fsm + 1);
      }
      
      private function gameOver() : void
      {
         this.mc.zongde.jinmaoshu.stop();
         this.mc.zongde.jinmaoshu.addFrameScript(this.mc.zongde.jinmaoshu.totalFrames - 1,null);
         this.dispos(true);
      }
      
      private function countDistance(type:int) : Boolean
      {
         var num:Number = NaN;
         var flag:Boolean = false;
         switch(type)
         {
            case 1:
               num = Math.sqrt((this.currentX - this.mc.zongde.feizao.x) * (this.currentX - this.mc.zongde.feizao.x) + (this.currentY - this.mc.zongde.feizao.y) * (this.currentY - this.mc.zongde.feizao.y));
               if(num > 50)
               {
                  flag = true;
               }
               break;
            case 2:
               num = Math.sqrt((this.currentX - this.mc.zongde.maojing.x) * (this.currentX - this.mc.zongde.maojing.x) + (this.currentY - this.mc.zongde.maojing.y) * (this.currentY - this.mc.zongde.maojing.y));
               if(num > 50)
               {
                  flag = true;
               }
         }
         return flag;
      }
      
      public function setData(param:Object) : void
      {
         this.callback = param.callback;
      }
      
      public function dispos(flag:Boolean = false) : void
      {
         if(this.callback != null)
         {
            if(flag)
            {
               this.callback.apply(null,[false]);
            }
            else
            {
               this.callback.apply(null,["closedialog"]);
            }
         }
         this.callback = null;
         this.fsm = 0;
         if(this.timer != null)
         {
            this.timer.reset();
            this.timer.stop();
            this.timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
            this.timer = null;
         }
         this.oldX = 0;
         this.oldY = 0;
         this.currentX = 0;
         this.currentY = 0;
         this.count = 0;
         if(this.loader != null)
         {
            this.loader.removeEventListener(Event.COMPLETE,this.onLoadComplete);
            this.loader.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
            this.loader.unloadAndStop();
            this.loader = null;
         }
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

