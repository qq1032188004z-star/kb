package com.game.modules.control.replace
{
   import com.core.observer.MessageEvent;
   import com.core.view.ViewConLogic;
   import com.game.event.EventConst;
   import com.game.locators.MsgDoc;
   import com.game.manager.EventManager;
   import com.game.modules.view.replace.ReplaceMonsterView;
   
   public class ReplaceMonsterControl extends ViewConLogic
   {
      
      public static var NAME:String = "replacemediator";
      
      public function ReplaceMonsterControl(viewConment:Object)
      {
         super(NAME,viewConment);
         EventManager.attachEvent(this.view,ReplaceEvent.REPLACEEVENT,this.startReplace);
      }
      
      private function get view() : ReplaceMonsterView
      {
         return this.getViewComponent() as ReplaceMonsterView;
      }
      
      override public function listEvents() : Array
      {
         return [[EventConst.GETREPLACEMONSTERBACK,this.getReplaceMonsterBack]];
      }
      
      private function startReplace(evt:ReplaceEvent) : void
      {
         var params:Object = evt.params;
         sendMessage(MsgDoc.OP_REPLACE_MONSTER_BACK.send,0,[params.storeID,params.packID]);
      }
      
      private function getReplaceMonsterBack(evt:MessageEvent) : void
      {
         var params:Object = evt.body;
         this.view.closeWindow(null);
      }
   }
}

