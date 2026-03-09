package com.game.modules.control.exchange
{
   import com.core.observer.MessageEvent;
   import com.core.view.ViewConLogic;
   import com.game.event.EventConst;
   import com.game.locators.GameData;
   import com.game.locators.MsgDoc;
   import com.game.manager.EventManager;
   import com.game.manager.cursor.ViewEvent;
   import com.game.modules.view.exchange.ExchangeView;
   import com.publiccomponent.alert.Alert;
   import flash.events.Event;
   
   public class ExchangeControl extends ViewConLogic
   {
      
      public static const NAME:String = "EXCHANGEMEDIATOR";
      
      public function ExchangeControl(viewComponent:Object)
      {
         super(NAME,viewComponent);
         EventManager.attachEvent(this.view,Event.ADDED_TO_STAGE,this.onAddToStage);
         this.onAddToStage(null);
      }
      
      private function onAddToStage(evt:Event) : void
      {
         this.view.initEvents();
         dispatch(EventConst.GETPROPSLIST,262176);
         EventManager.attachEvent(this.view,EventConst.STARTDUIHUAN,this.onStartDuiHuan);
         EventManager.attachEvent(this.view,Event.REMOVED_FROM_STAGE,this.onRemoveFromStage);
      }
      
      private function onRemoveFromStage(evt:Event) : void
      {
         this.view.removeEvents();
         EventManager.removeEvent(this.view,EventConst.STARTDUIHUAN,this.onStartDuiHuan);
         EventManager.removeEvent(this.view,Event.REMOVED_FROM_STAGE,this.onRemoveFromStage);
      }
      
      public function get view() : ExchangeView
      {
         return this.getViewComponent() as ExchangeView;
      }
      
      override public function listEvents() : Array
      {
         return [[EventConst.GETDUIHUANBACK,this.onDuiHuanListBack],[EventConst.STARTDUIHUANBACK,this.onDuihuanBack]];
      }
      
      private function onDuiHuanListBack(event:MessageEvent) : void
      {
         this.view.setData(event.body);
      }
      
      private function onDuihuanBack(event:MessageEvent) : void
      {
         var params:Object = event.body;
         new Alert().show("你获得了 " + params.money + " 铜钱");
         GameData.instance.playerData.coin += params.money;
         this.view.duihuanBack(params);
      }
      
      private function onStartDuiHuan(event:ViewEvent) : void
      {
         var params:Object = event.getData();
         sendMessage(MsgDoc.OP_CLIENT_DUI_TOOL.send,0,[params.id,params.count]);
      }
   }
}

