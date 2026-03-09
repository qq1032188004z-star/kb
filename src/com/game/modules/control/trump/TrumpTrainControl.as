package com.game.modules.control.trump
{
   import com.channel.Message;
   import com.core.observer.MessageEvent;
   import com.core.view.ViewConLogic;
   import com.game.event.EventConst;
   import com.game.locators.GameData;
   import com.game.locators.MsgDoc;
   import com.game.manager.EventManager;
   import com.game.manager.MonsterManger;
   import com.game.modules.view.trump.TrumpTrainningView;
   import flash.events.Event;
   
   public class TrumpTrainControl extends ViewConLogic
   {
      
      public static const NAME:String = "trumptrainControl";
      
      private var stopTrainM:Object;
      
      public function TrumpTrainControl(viewComponent:Object)
      {
         super(NAME,viewComponent);
         EventManager.attachEvent(this.view,TrumpTrainningView.OPENGONGLVE,this.onOpenGonglve);
         EventManager.attachEvent(this.view,TrumpTrainningView.OPENMONSTERLISTVIEW,this.onOpenMonsterListView);
         EventManager.attachEvent(this.view,TrumpTrainningView.OPENTRIPODVIEW,this.onOpenTripodView);
         EventManager.attachEvent(this.view,TrumpEvent.TRAINGETBACKMONSTER,this.getBackTrainMonsters);
      }
      
      public function get view() : TrumpTrainningView
      {
         return this.getViewComponent() as TrumpTrainningView;
      }
      
      private function onOpenGonglve(evt:Event) : void
      {
         dispatch(EventConst.OPENSWFWINDOWS,{
            "url":"assets/fabao/trumptrainmonster.swf",
            "xCoord":0,
            "yCoord":0
         });
      }
      
      private function onOpenMonsterListView(evt:Event) : void
      {
         new Message("onopenmonsterpanel").sendToChannel("itemclick");
         this.view.disport();
      }
      
      private function onOpenTripodView(evt:Event) : void
      {
         dispatch(EventConst.OPEN_MODULE,{
            "url":"assets/module/MonsterStorageModule.swf",
            "xCoord":0,
            "yCoord":0
         });
         this.view.disport();
      }
      
      private function getBackTrainMonsters(evt:MessageEvent) : void
      {
         this.stopTrainM = this.view.monsters[evt.body.trainId];
         if(this.stopTrainM != null)
         {
            sendMessage(MsgDoc.OP_CLIENT_STOP_TRAIN.send,evt.body.trainId);
         }
      }
      
      override public function listEvents() : Array
      {
         return [[EventConst.STOPTRAINMONSTERBACK,this.onStopTrainingBack]];
      }
      
      private function onStopTrainingBack(event:MessageEvent) : void
      {
         if(GameData.instance.playerData.sceneId == 1002 && GameData.instance.playerData.userId == GameData.instance.playerData.houseId)
         {
            if(this.stopTrainM != null)
            {
               MonsterManger.instance.deleteAIMonsterAtHome(this.stopTrainM);
            }
         }
         if(Boolean(this.view))
         {
            this.view.disport();
         }
      }
   }
}

