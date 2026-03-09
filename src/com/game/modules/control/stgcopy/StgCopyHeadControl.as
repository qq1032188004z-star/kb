package com.game.modules.control.stgcopy
{
   import com.core.observer.MessageEvent;
   import com.core.view.ViewConLogic;
   import com.game.event.EventConst;
   import com.game.locators.MsgDoc;
   import com.game.modules.view.stgcopy.StgCopyRank;
   import flash.events.Event;
   
   public class StgCopyHeadControl extends ViewConLogic
   {
      
      public static const name:String = "stgcopyheadcontrol";
      
      private var nextCopyLevel:int;
      
      private var passCopy:Boolean;
      
      private var passLevel:Boolean;
      
      public function StgCopyHeadControl(viewobj:Object = null)
      {
         super(name,viewobj);
         this.view.addEventListener(StgCopyRank.STGEXCHANGE,this.onExchange);
         this.view.addEventListener(StgCopyRank.CHECKEXCHANGE,this.onCheckExchange);
      }
      
      override public function listEvents() : Array
      {
         return [[EventConst.GET_STGCOPY_SCORE,this.onGetMyScore],[EventConst.STG_GETHEAD,this.onGetHead],[EventConst.GETCHATDRESSBACK,this.onGetHeadBack],[EventConst.STGCOPYRANK_EXCHANGE_BACK,this.onCheckExchangeBack]];
      }
      
      private function get view() : StgCopyRank
      {
         return this.getViewComponent() as StgCopyRank;
      }
      
      override public function onRemove() : void
      {
         this.view.removeEventListener(StgCopyRank.STGEXCHANGE,this.onExchange);
         this.view.removeEventListener(StgCopyRank.CHECKEXCHANGE,this.onCheckExchange);
      }
      
      private function onGetMyScore(evt:MessageEvent) : void
      {
         this.sendMessage(MsgDoc.OP_CLIENT_GET_STGCOPY_SCORE.send,1);
      }
      
      private function onGetHead(evt:MessageEvent) : void
      {
         var id:uint = uint(evt.body);
         this.sendMessage(MsgDoc.OP_CLIENT_GET_CHAT_DRESS.send,int(id));
      }
      
      private function onGetHeadBack(evt:MessageEvent) : void
      {
         var data:Object = evt.body;
         this.view.showhead(data);
      }
      
      private function onExchange(evt:MessageEvent) : void
      {
         var index:int = int(evt.body.index) - 1;
         this.sendMessage(MsgDoc.OP_CLIENT_STGCOPY_EXCHANGE.send,2,[1,index]);
      }
      
      private function onCheckExchange(evt:Event) : void
      {
         this.sendMessage(MsgDoc.OP_CLIENT_GET_STGCOPY_SCORE.send,2);
      }
      
      private function onCheckExchangeBack(evt:MessageEvent) : void
      {
         this.view.checkExchange(evt.body);
      }
   }
}

