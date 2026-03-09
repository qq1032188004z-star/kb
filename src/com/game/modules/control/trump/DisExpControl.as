package com.game.modules.control.trump
{
   import com.core.observer.MessageEvent;
   import com.core.view.ViewConLogic;
   import com.game.event.EventConst;
   import com.game.locators.MsgDoc;
   import com.game.manager.EventManager;
   import com.game.modules.view.trump.DisExpView;
   import flash.events.Event;
   
   public class DisExpControl extends ViewConLogic
   {
      
      public static const NAME:String = "disexpcontrol";
      
      public function DisExpControl(viewComponent:Object)
      {
         super(NAME,viewComponent);
         this.view.addEventListener(Event.ADDED_TO_STAGE,this.addTostage);
         this.addTostage(null);
      }
      
      private function addTostage(evt:Event) : void
      {
         this.view.initEvents();
         EventManager.attachEvent(this.view,TrumpEvent.distributeExp,this.disExp);
         EventManager.attachEvent(this.view,TrumpEvent.reupdateimg,this.reupdateImg);
         sendMessage(MsgDoc.OP_CLIENT_DISTRIBUTE_EXP.send,1);
      }
      
      override public function onRemove() : void
      {
         this.view.removeEvents();
         EventManager.removeEvent(this.view,TrumpEvent.distributeExp,this.disExp);
         EventManager.removeEvent(this.view,TrumpEvent.reupdateimg,this.reupdateImg);
      }
      
      override public function listEvents() : Array
      {
         return [[EventConst.DISTRIBUTE_EXP_BACK,this.disExpBack],[EventConst.STORE_EXP_BACK,this.openDisExpView]];
      }
      
      private function get view() : DisExpView
      {
         return this.getViewComponent() as DisExpView;
      }
      
      private function openDisExpView(event:MessageEvent) : void
      {
         this.view.build(event.body);
      }
      
      private function disExp(evt:TrumpEvent) : void
      {
         sendMessage(MsgDoc.OP_CLIENT_DISTRIBUTE_EXP.send,2,[evt.data.uniqueid,evt.data.expvalue]);
      }
      
      private function reupdateImg(evt:TrumpEvent) : void
      {
         sendMessage(MsgDoc.OP_CLIENT_DISTRIBUTE_EXP.send,1);
      }
      
      private function disExpBack(evt:MessageEvent) : void
      {
         this.view.disExpBack(evt.body);
      }
   }
}

