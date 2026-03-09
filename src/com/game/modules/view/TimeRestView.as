package com.game.modules.view
{
   import com.game.util.CacheUtil;
   import com.game.util.HLoaderSprite;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   
   public class TimeRestView extends HLoaderSprite
   {
      
      private var tempClip:MovieClip;
      
      private var count:int = 60;
      
      private var tid:int;
      
      public function TimeRestView()
      {
         super();
         this.url = "assets/material/timerest.swf";
      }
      
      override public function setShow() : void
      {
         this.tempClip = this.bg;
         if(this.tempClip != null)
         {
            addChild(this.tempClip);
            this.addEventListener(Event.ADDED_TO_STAGE,this.onAddToStage);
            this.onAddToStage(null);
         }
      }
      
      private function onAddToStage(evt:Event) : void
      {
         if(this.tempClip.hasOwnProperty("closeBtn"))
         {
            this.tempClip.closeBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.closeView);
         }
         clearInterval(this.tid);
         this.count = 60;
         this.tid = setInterval(this.loopCount,1000);
      }
      
      private function loopCount() : void
      {
         if(this.count <= 0)
         {
            this.closeView(null);
         }
         else
         {
            --this.count;
            this.tempClip.msgTxt.text = this.count + "";
         }
      }
      
      private function closeView(evt:MouseEvent) : void
      {
         if(Boolean(this.tempClip) && Boolean(this.tempClip.closeBtn))
         {
            this.tempClip.closeBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.closeView);
         }
         this.removeEventListener(Event.ADDED_TO_STAGE,this.onAddToStage);
         CacheUtil.deleteObject(TimeRestView);
         clearInterval(this.tid);
         if(this.tempClip.hasOwnProperty("closeBtn"))
         {
            this.tempClip.closeBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.closeView);
         }
         if(Boolean(this.parent) && this.parent.contains(this))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

