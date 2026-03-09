package com.game.modules.control.wakeup
{
   import com.core.observer.MessageEvent;
   import com.core.view.ViewConLogic;
   import com.game.event.EventConst;
   import com.game.locators.MsgDoc;
   import com.game.manager.EventManager;
   import com.game.modules.view.wakeup.SelectSpiritView;
   import com.game.modules.view.wakeup.WakeSkillView;
   import flash.events.Event;
   import flash.utils.getQualifiedClassName;
   
   public class SelectSpiritControl extends ViewConLogic
   {
      
      public static const NAME:String = "selectspritmediator";
      
      public function SelectSpiritControl(viewComponent:Object = null)
      {
         super(NAME,viewComponent);
         EventManager.attachEvent(this.view,Event.ADDED_TO_STAGE,this.onAddToStage);
         this.onAddToStage(null);
      }
      
      private function onGetNewOldSkill(event:MessageEvent) : void
      {
         var obj:Object = {
            "body":event.body,
            "showX":0,
            "showY":0
         };
         this.dispatch(EventConst.OPEN_CACHE_VIEW,obj,null,getQualifiedClassName(WakeSkillView));
      }
      
      private function onAddToStage(evt:Event) : void
      {
         EventManager.attachEvent(this.view,SelectSpiritView.OPEN_WAKEUP_WINDOWN,this.onGetNewOldSkill);
         EventManager.attachEvent(this.view,Event.REMOVED_FROM_STAGE,this.onRemoveFromStage);
         sendMessage(MsgDoc.OP_CLIENT_REQ_SPIRIT_LIST.send);
      }
      
      private function onRemoveFromStage(evt:Event) : void
      {
         EventManager.removeEvent(this.view,SelectSpiritView.OPEN_WAKEUP_WINDOWN,this.onGetNewOldSkill);
         EventManager.removeEvent(this.view,Event.REMOVED_FROM_STAGE,this.onRemoveFromStage);
         this.view.removeEvents();
      }
      
      override public function listEvents() : Array
      {
         return [[EventConst.GETMONSTERLISTBACK,this.onGetMonsterListBack]];
      }
      
      private function onGetMonsterListBack(event:MessageEvent) : void
      {
         this.view.build(event.body);
      }
      
      private function get view() : SelectSpiritView
      {
         return this.getViewComponent() as SelectSpiritView;
      }
   }
}

