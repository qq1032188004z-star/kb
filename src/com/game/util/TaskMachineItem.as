package com.game.util
{
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol626")]
   public class TaskMachineItem extends Sprite
   {
      
      public var taskname:TextField;
      
      public var taskId:int;
      
      private var _callback:Function;
      
      public function TaskMachineItem(callback:Function)
      {
         super();
         this.buttonMode = true;
         this._callback = callback;
         this.addEventListener(MouseEvent.CLICK,this.onMouseClick);
         this.mouseChildren = false;
      }
      
      private function onMouseClick(evt:MouseEvent) : void
      {
         if(this._callback != null)
         {
            this._callback.apply(null,[this.taskId]);
         }
      }
   }
}

