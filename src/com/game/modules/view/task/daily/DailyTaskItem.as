package com.game.modules.view.task.daily
{
   import com.publiccomponent.loading.Hloader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class DailyTaskItem extends Sprite
   {
      
      private var _loader:Hloader;
      
      private var _callback:Function;
      
      private var _taskId:int;
      
      private var _status:int;
      
      private var _index:int;
      
      private var mc:MovieClip;
      
      private var _click:Boolean = false;
      
      public function DailyTaskItem(taskid:int, index:int, callback:Function)
      {
         super();
         this._taskId = taskid;
         this._callback = callback;
         this._index = index;
         this._loader = new Hloader("assets/taskimg/" + this._taskId + ".swf");
         this._loader.addEventListener(Event.COMPLETE,this.onLoadComplete);
      }
      
      public function updateStatus(status:int) : void
      {
         this._status = status;
         this.showTips();
      }
      
      private function onLoadComplete(evt:Event) : void
      {
         this.mc = this._loader.content["getChildAt"](0) as MovieClip;
         this.addChild(this.mc);
         this.mc.x = 0;
         this.mc.y = 0;
         this.mouseChildren = false;
         this.buttonMode = true;
         this.cacheAsBitmap = true;
         this.mc.cacheAsBitmap = true;
         this.mc.gotoAndStop(1);
         this.showTips();
         this.releaseLoader();
         this.addEventListener(MouseEvent.CLICK,this.onMouseClick);
         this.addEventListener(MouseEvent.ROLL_OVER,this.onMouseOver);
         this.addEventListener(MouseEvent.ROLL_OUT,this.onMouseOut);
      }
      
      private function releaseLoader() : void
      {
         if(Boolean(this._loader))
         {
            this._loader.addEventListener(Event.COMPLETE,this.onLoadComplete);
            this._loader.unloadAndStop(true);
            this._loader = null;
         }
      }
      
      private function onMouseClick(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         this._click = true;
         this._callback.apply(null,[this._taskId,this._index]);
      }
      
      private function onMouseOver(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         this.updateFilters(2);
      }
      
      private function onMouseOut(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         this.updateFilters(1);
      }
      
      public function updateFilters(frame:int) : void
      {
         if(this._click && frame == 1)
         {
            return;
         }
         if(frame < 0 || frame > 2)
         {
            return;
         }
         if(Boolean(this.mc))
         {
            this.mc.gotoAndStop(frame);
         }
      }
      
      public function updateClickStatus() : void
      {
         this._click = false;
      }
      
      public function showTips() : void
      {
         if(this.mc == null)
         {
            return;
         }
         switch(this._status)
         {
            case 1:
               this.mc.flag.visible = false;
               break;
            case 2:
               this.mc.flag.visible = true;
               this.mc.flag.gotoAndStop(1);
               break;
            case 4:
               this.mc.flag.visible = true;
               this.mc.flag.gotoAndStop(2);
         }
      }
      
      public function get index() : int
      {
         return this._index;
      }
      
      public function dispos() : void
      {
         this.releaseLoader();
         this.removeEventListener(MouseEvent.CLICK,this.onMouseClick);
         this.removeEventListener(MouseEvent.ROLL_OUT,this.onMouseOut);
         this.removeEventListener(MouseEvent.ROLL_OVER,this.onMouseOver);
         if(Boolean(this.mc))
         {
            this.mc.gotoAndStop(1);
            this.mc.flag.gotoAndStop(1);
            this.mc.flag.visible = false;
         }
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
         this._callback = null;
      }
   }
}

