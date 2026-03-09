package com.game.modules.control.trump
{
   import com.core.observer.MessageEvent;
   import com.core.view.ViewConLogic;
   import com.game.event.EventConst;
   import com.game.locators.MsgDoc;
   import com.game.modules.view.trump.XiuweiView;
   import flash.events.Event;
   
   public class XiuweiControl extends ViewConLogic
   {
      
      public static const NAME:String = "xiuweicontrol";
      
      public function XiuweiControl(viewComponent:Object = null)
      {
         super(NAME,viewComponent);
         this.view.addEventListener(Event.ADDED_TO_STAGE,this.addToStage);
         this.addToStage(null);
      }
      
      override public function listEvents() : Array
      {
         return [[EventConst.REQXIUWEIBACK,this.reqXiuweiBack],[EventConst.CONFIRMXIUWEI,this.confirmxiufei],[EventConst.DISTRIBUTEXIUWEIBACK,this.distributeXiuweiBack]];
      }
      
      private function distributeXiuweiBack(evt:MessageEvent) : void
      {
         this.view.openSuccessWindow(evt.body);
      }
      
      private function confirmxiufei(evt:MessageEvent) : void
      {
         var arr:Array = [evt.body.id,evt.body.gongji,evt.body.fangyu,evt.body.fashu,evt.body.kangxing,evt.body.tili,evt.body.sudu];
         this.sendMessage(MsgDoc.REQ_XIUWEI_DATA.send,2,arr);
      }
      
      private function reqXiuweiBack(evt:MessageEvent) : void
      {
         this.view.initData(evt.body);
      }
      
      private function get view() : XiuweiView
      {
         return this.getViewComponent() as XiuweiView;
      }
      
      private function addToStage(evt:Event) : void
      {
         this.view.initEvents();
         this.view.addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoveFromStage);
         this.sendMessage(MsgDoc.REQ_XIUWEI_DATA.send,1);
      }
      
      private function onRemoveFromStage(evt:Event) : void
      {
         this.view.removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemoveFromStage);
         this.view.removeEvents();
      }
   }
}

