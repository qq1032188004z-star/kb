package com.kb.components.list
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class ScrollBar extends Sprite
   {
      
      public static const SCROLL_CHANGED:String = "scroll_changed";
      
      private var bg:DisplayObject;
      
      private var minY:Number;
      
      private var totalSize:int;
      
      private var offsetY:Number;
      
      private var barUI:DisplayObject;
      
      private var upUI:DisplayObject;
      
      private var maxY:Number;
      
      private var downUI:DisplayObject;
      
      private var scrollStep:Number;
      
      public function ScrollBar(mcBg:DisplayObject, mcUp:DisplayObject, mcDown:DisplayObject, mcBar:DisplayObject)
      {
         super();
         this.bg = mcBg;
         this.upUI = mcUp;
         this.downUI = mcDown;
         this.barUI = mcBar;
         this.minY = this.bg.y;
         this.maxY = this.bg.y + this.bg.height;
         this.barUI.y = this.minY;
         this.initEvents();
      }
      
      private function onStageMouseUp(evt:MouseEvent) : void
      {
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.onStageMouseUp);
         if(stage.hasEventListener(MouseEvent.MOUSE_MOVE))
         {
            stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onStageMouseMove);
         }
      }
      
      private function onDownMouseDown(evt:MouseEvent) : void
      {
         this.scrollY = this.barUI.y + this.scrollStep;
      }
      
      private function initEvents() : void
      {
         this.upUI.addEventListener(MouseEvent.MOUSE_DOWN,this.onUpMouseDown,false,0,true);
         this.downUI.addEventListener(MouseEvent.MOUSE_DOWN,this.onDownMouseDown,false,0,true);
         this.barUI.addEventListener(MouseEvent.MOUSE_DOWN,this.onBarMouseDown,false,0,true);
         addEventListener(Event.ADDED_TO_STAGE,this.onAdded,false,0,true);
      }
      
      public function showScroolBar(show:Boolean) : void
      {
         this.bg.visible = show;
         this.upUI.visible = show;
         this.downUI.visible = show;
         this.barUI.visible = show;
      }
      
      private function set scrollY(value:Number) : void
      {
         if(value < this.minY)
         {
            value = this.minY;
         }
         if(value > this.maxY - this.barUI.height)
         {
            value = this.maxY - this.barUI.height;
         }
         this.barUI.y = value;
         var index:int = int(((this.barUI.y - this.minY) / this.scrollStep).toFixed(0));
         if(parent != null && index < this.totalSize)
         {
            parent.dispatchEvent(new BaseListEvent(SCROLL_CHANGED,index != 0));
         }
      }
      
      private function onBarMouseDown(evt:MouseEvent) : void
      {
         this.offsetY = evt.stageY - this.barUI.y;
         if(stage.hasEventListener(MouseEvent.MOUSE_MOVE))
         {
            stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onStageMouseMove);
         }
         stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onStageMouseMove,false,0,true);
         stage.addEventListener(MouseEvent.MOUSE_UP,this.onStageMouseUp,false,0,true);
      }
      
      public function setPageInfo(total:int, pageSize:int) : void
      {
         var temp:Number = NaN;
         this.totalSize = total;
         this.barUI.y = this.minY;
         var value:Number = pageSize / this.totalSize;
         var scrollHeight:Number = this.maxY - this.minY;
         if(value > 0 && value <= 1)
         {
            temp = scrollHeight * value;
            temp = temp < 15 ? 15 : temp;
            this.barUI.height = temp;
         }
         this.scrollStep = (scrollHeight - this.barUI.height) / (this.totalSize - pageSize);
      }
      
      private function onAdded(evt:Event) : void
      {
         if(parent != null)
         {
            parent.addEventListener(MouseEvent.MOUSE_WHEEL,this.onParentMouseWheel,false,0,true);
         }
      }
      
      private function onUpMouseDown(evt:MouseEvent) : void
      {
         this.scrollY = this.barUI.y - this.scrollStep;
      }
      
      private function onStageMouseMove(evt:MouseEvent) : void
      {
         if(evt != null && evt.buttonDown)
         {
            this.scrollY = evt.stageY - this.offsetY;
         }
      }
      
      private function onParentMouseWheel(evt:MouseEvent) : void
      {
         if(evt.currentTarget == parent)
         {
            if(evt.delta > 0)
            {
               this.scrollY = this.barUI.y - this.scrollStep;
            }
            else
            {
               this.scrollY = this.barUI.y + this.scrollStep;
            }
         }
      }
   }
}

