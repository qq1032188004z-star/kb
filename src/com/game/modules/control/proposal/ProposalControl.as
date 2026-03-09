package com.game.modules.control.proposal
{
   import com.core.observer.MessageEvent;
   import com.core.view.ViewConLogic;
   import com.game.event.EventConst;
   import com.game.locators.MsgDoc;
   import com.game.manager.EventManager;
   import com.game.modules.view.proposal.ProposalView;
   import com.game.util.PhpInterFace;
   import com.publiccomponent.alert.Alert;
   import flash.events.Event;
   import flash.net.URLVariables;
   
   public class ProposalControl extends ViewConLogic
   {
      
      private static const NAME:String = "proposalcontrol";
      
      private var tempvar:URLVariables;
      
      public function ProposalControl(viewComponent:Object = null)
      {
         super(NAME,viewComponent);
         EventManager.attachEvent(this.view,Event.ADDED_TO_STAGE,this.onAddToStage);
         this.onAddToStage(null);
      }
      
      private function onAddToStage(evt:Event) : void
      {
         this.view.initEventListener();
         EventManager.attachEvent(this.view,EventConst.STARTSENDPROPOSAL,this.sendProposal);
         EventManager.attachEvent(this.view,Event.REMOVED_FROM_STAGE,this.onRemoveFromStage);
      }
      
      private function onRemoveFromStage(evt:Event) : void
      {
         this.view.removeEvents();
         EventManager.removeEvent(this.view,EventConst.STARTSENDPROPOSAL,this.sendProposal);
         EventManager.removeEvent(this.view,Event.REMOVED_FROM_STAGE,this.onRemoveFromStage);
      }
      
      private function get view() : ProposalView
      {
         return this.getViewComponent() as ProposalView;
      }
      
      override public function listEvents() : Array
      {
         return [[EventConst.REDUCESUCCESS,this.reduceSuccess]];
      }
      
      private function sendProposal(evt:MessageEvent) : void
      {
         this.tempvar = evt.body as URLVariables;
         this.sendMessage(MsgDoc.req_reduce_cosin.send);
      }
      
      private function reduceSuccess(evt:MessageEvent) : void
      {
         new PhpInterFace().getData("http://php.wanwan4399.com/api/write_dingDing1.php",this.tempvar,this.onSendBack);
      }
      
      private function onSendBack(ob:Object) : void
      {
         new Alert().show(ob.toString());
         this.view.clearTxt();
      }
   }
}

