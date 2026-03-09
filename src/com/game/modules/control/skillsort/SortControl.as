package com.game.modules.control.skillsort
{
   import com.core.observer.MessageEvent;
   import com.core.view.ViewConLogic;
   import com.game.event.EventConst;
   import com.game.locators.MsgDoc;
   import com.game.manager.EventManager;
   import com.game.modules.view.skillsort.SortView;
   import flash.events.Event;
   
   public class SortControl extends ViewConLogic
   {
      
      private static var NAME:String = "sortcontrol";
      
      public function SortControl(viewComponent:Object = null)
      {
         super(NAME,viewComponent);
         EventManager.attachEvent(this.view,Event.ADDED_TO_STAGE,this.addToStage);
         this.addToStage(null);
      }
      
      private function addToStage(evt:Event) : void
      {
         this.view.build();
         this.view.initEvents();
         EventManager.attachEvent(this.view,Event.REMOVED_FROM_STAGE,this.removeFromStage);
         EventManager.attachEvent(this.view,EventConst.STARTSORT,this.startSort);
      }
      
      private function removeFromStage(evt:Event) : void
      {
         this.view.removeEvents();
         EventManager.removeEvent(this.view,Event.REMOVED_FROM_STAGE,this.removeFromStage);
         EventManager.removeEvent(this.view,EventConst.STARTSORT,this.startSort);
      }
      
      override public function listEvents() : Array
      {
         return [[EventConst.CLOSEMONSTERSORTVIEW,this.closeView]];
      }
      
      private function closeView(evt:MessageEvent) : void
      {
         this.view.closeWindow(null);
      }
      
      private function startSort(evt:MessageEvent) : void
      {
         this.sendMessage(MsgDoc.REQ_MONSTER.send,2,evt.body.arrid);
      }
      
      private function get view() : SortView
      {
         return this.getViewComponent() as SortView;
      }
   }
}

