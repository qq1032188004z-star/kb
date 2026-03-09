package com.game.modules.control.exchange
{
   import com.core.observer.MessageEvent;
   import com.core.view.ViewConLogic;
   import com.game.event.EventConst;
   import com.game.locators.MsgDoc;
   import com.game.manager.cursor.ViewEvent;
   import com.game.modules.view.gameexchange.EnterDoorView;
   
   public class EnterDoorControl extends ViewConLogic
   {
      
      public static const NAME:String = "ENTERDOORCONTROL";
      
      public function EnterDoorControl(viewComponent:Object)
      {
         super(NAME,viewComponent);
         this.init();
      }
      
      private function init() : void
      {
         dispatch(EventConst.GETPROPSLIST,262176);
         this.sendMessage(MsgDoc.GET_KEY.send,1);
      }
      
      public function get view() : EnterDoorView
      {
         return this.getViewComponent() as EnterDoorView;
      }
      
      override public function listEvents() : Array
      {
         return [[EventConst.DEDUCTGAMECOINBACK,this.deductGamecoinBack]];
      }
      
      private function deductGamecoinBack(evt:MessageEvent) : void
      {
         this.view.checkCoinBack(evt.body);
      }
      
      private function reqUsecosinToGamehall(event:ViewEvent) : void
      {
         sendMessage(MsgDoc.REQ_USECOSIN_TO_GAMEHALL.send,0);
      }
   }
}

