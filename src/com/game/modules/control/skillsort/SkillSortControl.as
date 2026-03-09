package com.game.modules.control.skillsort
{
   import com.core.observer.MessageEvent;
   import com.core.view.ViewConLogic;
   import com.game.event.EventConst;
   import com.game.locators.MsgDoc;
   import com.game.manager.EventManager;
   import com.game.modules.view.skillsort.SkillSort;
   import flash.events.Event;
   
   public class SkillSortControl extends ViewConLogic
   {
      
      public static var NAME:String = "skillsortcontrol";
      
      public function SkillSortControl(viewComponent:Object = null)
      {
         super(NAME,viewComponent);
         EventManager.attachEvent(this.view,Event.ADDED_TO_STAGE,this.addToStage);
         this.addToStage(null);
      }
      
      private function addToStage(evt:Event) : void
      {
         this.view.initEvents();
         EventManager.attachEvent(this.view,Event.REMOVED_FROM_STAGE,this.removeFromStage);
         EventManager.attachEvent(this.view,EventConst.OPENSORTVIEW,this.reqSortInfo);
         this.sendMessage(MsgDoc.REQ_MONSTER.send,1);
      }
      
      private function removeFromStage(evt:Event) : void
      {
         this.view.removeEvents();
         EventManager.removeEvent(this.view,Event.REMOVED_FROM_STAGE,this.removeFromStage);
         EventManager.removeEvent(this.view,EventConst.OPENSORTVIEW,this.reqSortInfo);
      }
      
      override public function listEvents() : Array
      {
         return [[EventConst.OPENMONSTERSORTVIEW,this.openMonsterSortViewBack]];
      }
      
      private function reqSortInfo(evt:MessageEvent) : void
      {
         this.sendMessage(MsgDoc.REQ_MONSTER.send,3,[evt.body.packID]);
      }
      
      public function get view() : SkillSort
      {
         return this.getViewComponent() as SkillSort;
      }
      
      private function openMonsterSortViewBack(evt:MessageEvent) : void
      {
         this.view.build(evt.body);
      }
   }
}

