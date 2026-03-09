package com.game.modules.view.stgcopy
{
   import com.publiccomponent.list.ItemRender;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol397")]
   public class StgCopyRankItem extends ItemRender
   {
      
      public var txt1:TextField;
      
      public var txt2:TextField;
      
      public var txt3:TextField;
      
      public var bgmc:MovieClip;
      
      public function StgCopyRankItem()
      {
         super();
         for(var i:int = 1; i < 4; i++)
         {
            this["txt" + i].mouseEnabled = false;
         }
         this.mouseEnabled = true;
         this.buttonMode = true;
         this.bgmc.visible = false;
         this.addEventListener(MouseEvent.ROLL_OVER,this.onOver);
         this.addEventListener(MouseEvent.ROLL_OUT,this.onOut);
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoved);
      }
      
      private function onOver(evt:MouseEvent) : void
      {
         this.bgmc.visible = true;
      }
      
      private function onOut(evt:MouseEvent) : void
      {
         this.bgmc.visible = false;
      }
      
      private function onRemoved(evt:Event) : void
      {
         super.dispos();
         this.removeEventListener(MouseEvent.ROLL_OVER,this.onOver);
         this.removeEventListener(MouseEvent.ROLL_OUT,this.onOut);
         this.removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemoved);
      }
      
      override public function set data(params:Object) : void
      {
         this.txt1.text = params.rank;
         this.txt2.text = params.uname;
         this.txt3.text = params.score;
         super.data = params;
      }
   }
}

