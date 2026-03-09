package com.game.modules.control.trump
{
   import com.core.observer.MessageEvent;
   import com.core.view.ViewConLogic;
   import com.game.event.EventConst;
   import com.game.locators.MsgDoc;
   import com.game.manager.EventManager;
   import com.game.modules.view.VIPPrivilegeView;
   import com.game.modules.view.trump.TrumpInfoview;
   import flash.events.Event;
   
   public class TrumpInfoControl extends ViewConLogic
   {
      
      public static const NAME:String = "trumpInfomediator";
      
      private var tempId:int;
      
      public function TrumpInfoControl(viewComponent:Object)
      {
         super(NAME,viewComponent);
         this.init();
      }
      
      private function init() : void
      {
         this.view.initEvents();
         this.initEvent();
         sendMessage(MsgDoc.OP_GET_TRUMP_INFO.send,this.view.masterId);
         sendMessage(MsgDoc.OP_TRUMP_LIST_BACK.send,1);
      }
      
      private function onAddToStage(evt:Event) : void
      {
         sendMessage(MsgDoc.OP_GET_TRUMP_INFO.send,this.view.masterId);
         sendMessage(MsgDoc.OP_TRUMP_LIST_BACK.send,1);
      }
      
      private function initEvent() : void
      {
         EventManager.attachEvent(this.view,TrumpEvent.openmonsterTrainWindow,this.getTrainInfo);
         EventManager.attachEvent(this.view,TrumpEvent.closetrumpinfoview,this.closeView);
         EventManager.attachEvent(this.view,Event.ADDED_TO_STAGE,this.onAddToStage);
         EventManager.attachEvent(this.view,TrumpEvent.changeTrump,this.onChangeTrump);
      }
      
      override public function onRemove() : void
      {
         this.view.removeEvents();
         EventManager.removeEvent(this.view,TrumpEvent.openmonsterTrainWindow,this.getTrainInfo);
         EventManager.removeEvent(this.view,TrumpEvent.closetrumpinfoview,this.closeView);
         EventManager.removeEvent(this.view,Event.ADDED_TO_STAGE,this.onAddToStage);
         EventManager.removeEvent(this.view,TrumpEvent.changeTrump,this.onChangeTrump);
      }
      
      private function getTrainInfo(evt:MessageEvent) : void
      {
         sendMessage(MsgDoc.OP_CLIENT_GET_TRAININFO.send,0);
      }
      
      private function onChangeTrump(evt:MessageEvent) : void
      {
         this.tempId = int(evt.body);
         sendMessage(MsgDoc.OP_TRUMP_LIST_BACK.send,2,[evt.body]);
      }
      
      private function closeView(evt:MessageEvent) : void
      {
         this.view.dispos();
      }
      
      public function get view() : TrumpInfoview
      {
         return this.getViewComponent() as TrumpInfoview;
      }
      
      override public function listEvents() : Array
      {
         return [[EventConst.GETTRUMPINFOBACK,this.getTrumpInfoBack],[EventConst.GETTRUMPLISTBACK,this.getTrumpListBack],[EventConst.CHANGETRUMPBACK,this.changeTrumpBack]];
      }
      
      private function getTrumpListBack(evt:MessageEvent) : void
      {
         this.view.setTrumpList(evt.body);
      }
      
      private function getTrumpInfoBack(event:MessageEvent) : void
      {
         this.view.setData(event.body);
      }
      
      private function changeTrumpBack(evt:MessageEvent) : void
      {
         var result:int = int(evt.body);
         if(result == 0)
         {
            this.view.changeDecor(this.tempId);
            VIPPrivilegeView.getInstance().updateView(this.tempId);
         }
      }
   }
}

