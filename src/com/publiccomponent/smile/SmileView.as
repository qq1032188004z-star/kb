package com.publiccomponent.smile
{
   import com.publiccomponent.events.ItemClickEvent;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol200")]
   public class SmileView extends Sprite
   {
      
      public var clip:MovieClip;
      
      private var mcArray:Array = [];
      
      public function SmileView(xCoord:Number = 0, yCoord:Number = 0)
      {
         super();
         this.x = xCoord;
         this.y = yCoord;
         this.addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
         this.initEvent();
         this.addEventListener(Event.ADDED_TO_STAGE,this.addToStage);
      }
      
      private function addToStage(evt:Event) : void
      {
         this.removeEventListener(Event.ADDED_TO_STAGE,this.addToStage);
         stage.addEventListener(MouseEvent.MOUSE_DOWN,this.onRollOut);
      }
      
      private function initEvent() : void
      {
         for(var i:int = 0; i <= 15; i++)
         {
            this.mcArray.push(this.clip["face" + i]);
            this.clip["face" + i].addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         }
      }
      
      private function onRollOut(evt:MouseEvent) : void
      {
         this.visible = false;
      }
      
      private function onMouseDown(evt:MouseEvent) : void
      {
         var code:int = int(this.mcArray.indexOf(evt.currentTarget));
         if(code != -1)
         {
            this.dispatchEvent(new ItemClickEvent(ItemClickEvent.ITEMCLICKEVENT,code));
            this.visible = false;
         }
      }
      
      public function dispos() : void
      {
         this.removeEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
         this.removeEventListener(Event.ADDED_TO_STAGE,this.addToStage);
         if(Boolean(stage))
         {
            stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.onRollOut);
         }
         for(var i:int = 0; i <= 15; i++)
         {
            this.mcArray.push(this.clip["face" + i]);
            this.clip["face" + i].removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         }
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

