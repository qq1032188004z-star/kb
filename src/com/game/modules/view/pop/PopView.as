package com.game.modules.view.pop
{
   import com.core.observer.MessageEvent;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class PopView extends Sprite
   {
      
      public static const CLICKPOPVIEW:String = "clickpopview";
      
      public var type:int = 0;
      
      public function PopView()
      {
         super();
         this.addEventListener(Event.ADDED_TO_STAGE,this.onAddTostageHandler);
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoveStageHandler);
         this.addEventListener(MouseEvent.CLICK,this.onClickPopView);
      }
      
      private function onAddTostageHandler(event:Event) : void
      {
         this.init();
      }
      
      private function onRemoveStageHandler(event:Event) : void
      {
         while(this.numChildren > 0)
         {
            this.removeChild(this.getChildAt(0));
         }
         this.graphics.clear();
      }
      
      private function init() : void
      {
         this.graphics.beginFill(16777215,0);
         this.graphics.drawRect(-100,-100,1500,1500);
         this.graphics.endFill();
      }
      
      private function onClickPopView(event:MouseEvent) : void
      {
         dispatchEvent(new MessageEvent(PopView.CLICKPOPVIEW,this.type));
      }
   }
}

