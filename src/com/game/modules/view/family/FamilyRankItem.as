package com.game.modules.view.family
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.publiccomponent.list.ItemRender;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol952")]
   public class FamilyRankItem extends ItemRender
   {
      
      public var txt1:TextField;
      
      public var txt2:TextField;
      
      public var txt3:TextField;
      
      public var txt4:TextField;
      
      public var txt5:TextField;
      
      public var txt6:TextField;
      
      public var txt7:TextField;
      
      public var txt8:TextField;
      
      private const NUM:Array = ["一","二","三","四","五","六","七","八","九"];
      
      public function FamilyRankItem()
      {
         super();
         this.txt1.mouseEnabled = false;
         this.txt2.mouseEnabled = false;
         this.txt3.mouseEnabled = false;
         this.txt4.mouseEnabled = false;
         this.txt5.mouseEnabled = false;
         this.txt6.mouseEnabled = false;
         this.txt7.mouseEnabled = false;
         this.addEventListener(MouseEvent.ROLL_OVER,this.onOver);
         this.addEventListener(MouseEvent.ROLL_OUT,this.onOut);
         this.addEventListener(MouseEvent.CLICK,this.onClick);
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoved);
      }
      
      private function onOver(evt:MouseEvent) : void
      {
      }
      
      private function onOut(evt:MouseEvent) : void
      {
      }
      
      private function onClick(evt:MouseEvent) : void
      {
         ApplicationFacade.getInstance().dispatch(EventConst.REQ_FAMILY_INFO,data.fid);
      }
      
      private function onRemoved(evt:Event) : void
      {
         super.dispos();
         this.removeEventListener(MouseEvent.ROLL_OVER,this.onOver);
         this.removeEventListener(MouseEvent.ROLL_OUT,this.onOut);
         this.removeEventListener(MouseEvent.CLICK,this.onClick);
         this.removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemoved);
      }
      
      override public function set data(params:Object) : void
      {
         if(params == null || params.fid == null)
         {
            return;
         }
         if(params.hasOwnProperty("strengthValue"))
         {
            this.txt1.text = params.rank + "";
            this.txt2.text = params.fname + "(" + params.fid + ")";
            this.txt3.text = params.leaderName + "";
            this.txt4.text = params.strengthValue + "";
            this.txt8.text = this.NUM[int(params.star) - 1] + "星";
            this.txt5.visible = false;
            this.txt6.visible = false;
            this.txt7.visible = false;
         }
         else
         {
            this.txt1.visible = false;
            this.txt2.visible = false;
            this.txt3.visible = false;
            this.txt4.visible = false;
            this.txt5.text = params.fname + "(" + params.fid + ")";
            this.txt6.text = params.leaderName;
            this.txt7.text = params.memberNum;
            this.txt8.visible = false;
         }
         super.data = params;
         this.buttonMode = true;
      }
   }
}

