package com.game.modules.control.monsteridentify
{
   import com.core.observer.MessageEvent;
   import com.core.view.ViewConLogic;
   import com.game.event.EventConst;
   import com.game.locators.GameData;
   import com.game.locators.MsgDoc;
   import com.game.modules.view.monsteridentify.MonidAction;
   import com.game.modules.view.monsteridentify.MonsterShowView;
   import com.publiccomponent.alert.Alert;
   import flash.events.Event;
   import flash.utils.getQualifiedClassName;
   
   public class MonsterShowControl extends ViewConLogic
   {
      
      public static var NAME:String = "MonsterShowControl";
      
      public function MonsterShowControl(viewComponent:Object = null)
      {
         super(NAME,viewComponent);
         this.listviewevent();
         sendMessage(MsgDoc.OP_CLIENT_REQ_SPIRIT_LIST.send);
      }
      
      private function listviewevent() : void
      {
         this.view.addEventListener(Event.ADDED_TO_STAGE,this.addToStage);
         this.view.addEventListener(MonsterShowView.SURECHECKMONSTER,this.sureCheckHandler);
      }
      
      private function sureCheckHandler(event:Event) : void
      {
         sendMessage(MsgDoc.OP_CLIENT_MONSTER_CHECK.send,0);
      }
      
      override public function listEvents() : Array
      {
         return [[EventConst.GETMONVIEW,this.getMonView],[EventConst.GETMONSTERLISTBACK,this.openMonsterIdenViewBack],[EventConst.HAVEMONEYTOCHECK,this.onHaveMoneyToCheck]];
      }
      
      private function getMonView(evt:MessageEvent) : void
      {
         this.sendMessage(MsgDoc.REQ_MONSTER.send,3,[evt.body.packID]);
      }
      
      private function addToStage(evt:Event) : void
      {
         this.view.initEvents();
         sendMessage(MsgDoc.OP_CLIENT_REQ_SPIRIT_LIST.send);
      }
      
      private function onHaveMoneyToCheck(event:MessageEvent) : void
      {
         var obj:Object = null;
         if(int(event.body) == 0)
         {
            GameData.instance.playerData.coin -= 50;
            obj = {
               "monsterdetail":this.view.monsterdetail,
               "packIID":this.view.packIID,
               "showX":0,
               "showY":0
            };
            dispatch(EventConst.OPEN_CACHE_VIEW,obj,null,getQualifiedClassName(MonidAction));
            this.view.packID = 0;
            this.view.closeWindow(null);
         }
         else
         {
            new Alert().show("你身上不足50铜钱，无法继续对妖怪进行鉴定。");
         }
         this.view.flag = 1;
      }
      
      public function get view() : MonsterShowView
      {
         return this.getViewComponent() as MonsterShowView;
      }
      
      private function openMonsterIdenViewBack(evt:MessageEvent) : void
      {
         this.view.build(evt.body);
      }
   }
}

