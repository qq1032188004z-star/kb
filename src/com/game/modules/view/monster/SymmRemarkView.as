package com.game.modules.view.monster
{
   import com.game.util.CacheUtil;
   import com.game.util.HLoaderSprite;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class SymmRemarkView extends HLoaderSprite
   {
      
      private var closeBtn:SimpleButton;
      
      public function SymmRemarkView()
      {
         this.graphics.beginFill(16777215,0.01);
         this.graphics.drawRect(-100,-100,1200,800);
         this.graphics.endFill();
         super();
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoveStageHandler);
         this.url = "assets/material/symmRemark.swf";
      }
      
      override public function setShow() : void
      {
         this.closeBtn = bg.closeBtn;
         this.closeBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
      }
      
      public function onMouseDown(e:MouseEvent) : void
      {
         if(Boolean(this.parent) && this.parent.contains(this))
         {
            this.parent.removeChild(this);
         }
      }
      
      private function onRemoveStageHandler(e:Event) : void
      {
         this.removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemoveStageHandler);
         CacheUtil.deleteObject(SymmRemarkView);
         this.disport();
      }
      
      override public function disport() : void
      {
         this.graphics.clear();
         if(Boolean(this.closeBtn))
         {
            this.closeBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         }
      }
   }
}

