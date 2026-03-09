package com.game.modules.view.task.activation
{
   import com.publiccomponent.loading.GreenLoading;
   import com.publiccomponent.loading.Hloader;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   
   public class PractisePuzzle extends Sprite
   {
      
      private var uiLoader:Hloader;
      
      private var mc:MovieClip;
      
      private var win:Boolean = false;
      
      private var goal:Array;
      
      private var currentIndex:int = -1;
      
      private var callback:Function;
      
      public function PractisePuzzle()
      {
         super();
         GreenLoading.loading.visible = true;
         this.uiLoader = new Hloader("assets/material/practisepuzzle.swf");
         this.uiLoader.addEventListener(Event.COMPLETE,this.onLoadComplete);
         this.uiLoader.addEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
      }
      
      private function onLoadComplete(evt:Event) : void
      {
         evt.stopImmediatePropagation();
         this.mc = this.uiLoader.content as MovieClip;
         this.mc.addFrameScript(0,this.funFrame1);
         this.mc.addFrameScript(1,this.funFrame2);
         this.mc.addFrameScript(2,this.funFrame3);
         this.mc.addFrameScript(3,this.funFrame4);
         this.mc.addFrameScript(4,this.funFrame5);
         this.mc.gotoAndStop(5);
         this.addChild(this.mc);
         this.mc.x = 0;
         this.mc.y = 0;
         this.uiLoader.removeEventListener(Event.COMPLETE,this.onLoadComplete);
         this.uiLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
         GreenLoading.loading.visible = false;
         if(this.currentIndex != -1)
         {
            this.mc.soundMC.buttonMode = true;
            this.mc.soundMC.gotoAndStop(1);
            this.mc.soundMC.addEventListener(MouseEvent.CLICK,this.onClickCloseSound);
            this.mc.closeBtn.addEventListener(MouseEvent.CLICK,this.onClickClose);
            this.mc.gotoAndStop(this.currentIndex);
         }
      }
      
      private function onLoadError(evt:IOErrorEvent) : void
      {
         evt.stopImmediatePropagation();
         GreenLoading.loading.visible = false;
         this.dispos();
      }
      
      private function releaseLoader() : void
      {
         if(Boolean(this.uiLoader))
         {
            this.uiLoader.removeEventListener(Event.COMPLETE,this.onLoadComplete);
            this.uiLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
            this.uiLoader.unloadAndStop();
            this.uiLoader = null;
         }
      }
      
      private function funFrame1() : void
      {
         var i:int = 1;
         for(i = 1; i < 8; i++)
         {
            this.mc["src" + i].addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDownSrc);
         }
         this.goal = [0,0,0,0,0,0,0];
      }
      
      private function funFrame2() : void
      {
         var i:int = 1;
         for(i = 1; i < 9; i++)
         {
            this.mc["src" + i].addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDownSrc);
         }
         this.goal = [0,0,0,0,0,0,0,0];
      }
      
      private function funFrame3() : void
      {
         var i:int = 1;
         for(i = 1; i < 9; i++)
         {
            this.mc["src" + i].addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDownSrc);
         }
         this.goal = [0,0,0,0,0,0,0,0];
      }
      
      private function funFrame4() : void
      {
         var i:int = 1;
         for(i = 1; i < 9; i++)
         {
            this.mc["src" + i].addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDownSrc);
         }
         this.goal = [0,0,0,0,0,0,0,0];
      }
      
      private function funFrame5() : void
      {
         if(this.win)
         {
            this.mc.tips.visible = true;
            this.mc.sureBtn.visible = true;
            this.mc.overshow.gotoAndStop(this.currentIndex);
            this.mc.sureBtn.addEventListener(MouseEvent.CLICK,this.onMouseClickSure);
         }
         else
         {
            this.mc.tips.visible = false;
            this.mc.sureBtn.visible = false;
            this.mc.overshow.stop();
         }
      }
      
      private function onMouseClickSure(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         this.mc.sureBtn.removeEventListener(MouseEvent.CLICK,this.onMouseClickSure);
         this.dispos();
      }
      
      private function onMouseDownSrc(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         evt.target.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUpSrc);
         this.mc.setChildIndex(evt.target as DisplayObject,this.mc.numChildren - 1);
         evt.target["startDrag"]();
      }
      
      private function onMouseUpSrc(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         evt.target.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUpSrc);
         evt.target["stopDrag"]();
         var str:String = evt.target.name;
         var index:int = int(str.charAt(str.length - 1));
         var xCoordS:Number = (evt.target as DisplayObject).x;
         var yCoordS:Number = (evt.target as DisplayObject).y;
         var xCoordT:Number = Number(this.mc["target" + index].x);
         var yCoordT:Number = Number(this.mc["target" + index].y);
         if(Math.abs(xCoordT - xCoordS) <= 10 && yCoordS - yCoordT <= 10)
         {
            evt.target.x = xCoordT;
            evt.target.y = yCoordT;
            evt.target.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDownSrc);
            this.goal[index - 1] = 1;
            if(this.goal.indexOf(0) == -1)
            {
               this.win = true;
               this.mc.gotoAndStop(5);
            }
         }
      }
      
      private function releaseEvent() : void
      {
         if(Boolean(this.mc.soundMC.hasEventListener(MouseEvent.CLICK)))
         {
            this.mc.soundMC.removeEventListener(MouseEvent.CLICK,this.onClickCloseSound);
         }
         if(Boolean(this.mc.closeBtn.hasEventListener(MouseEvent.CLICK)))
         {
            this.mc.closeBtn.removeEventListener(MouseEvent.CLICK,this.onClickClose);
         }
      }
      
      private function onClickCloseSound(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         this.mc.soundMC.gotoAndStop(this.mc.soundMC.currentFrame == 1 ? 2 : 1);
      }
      
      private function onClickClose(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         this.dispos();
      }
      
      public function setData(param:Object) : void
      {
         this.currentIndex = Math.random() * 4 + 1 >> 0;
         this.callback = param.callback;
         if(this.mc != null)
         {
            this.mc.soundMC.buttonMode = true;
            this.mc.soundMC.gotoAndStop(1);
            this.mc.soundMC.addEventListener(MouseEvent.CLICK,this.onClickCloseSound);
            this.mc.closeBtn.addEventListener(MouseEvent.CLICK,this.onClickClose);
            this.mc.gotoAndStop(this.currentIndex);
         }
         else if(this.uiLoader == null)
         {
            GreenLoading.loading.visible = true;
            this.uiLoader = new Hloader("assets/material/practisepuzzle.swf");
            this.uiLoader.addEventListener(Event.COMPLETE,this.onLoadComplete);
            this.uiLoader.addEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
         }
      }
      
      public function dispos() : void
      {
         var i:int = 0;
         var len:int = 0;
         this.releaseLoader();
         this.releaseEvent();
         if(this.goal != null && this.goal.indexOf(0) != -1)
         {
            i = 1;
            len = int(this.goal.length);
            for(i = 1; i <= len; i++)
            {
               if(this.goal[i - 1] == 0)
               {
                  this.mc["src" + i].removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDownSrc);
               }
            }
         }
         if(this.callback != null)
         {
            if(this.win)
            {
               this.callback.apply(null,[true]);
            }
            else
            {
               this.callback.apply(null,["closedialog"]);
            }
            this.callback = null;
         }
         this.goal = null;
         this.win = false;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

