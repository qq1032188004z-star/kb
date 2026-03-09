package com.game.modules.control.action
{
   import com.core.observer.MessageEvent;
   import com.core.view.ViewConLogic;
   import com.game.locators.MsgDoc;
   import com.game.modules.view.action.ActionView;
   
   public class ActionControl extends ViewConLogic
   {
      
      public static const NAME:String = "ActionControl";
      
      public function ActionControl(viewComponent:Object = null)
      {
         super(NAME,viewComponent);
         this.init();
      }
      
      private function init() : void
      {
         this.view.addEventListener(ActionView.SENDACTIONID,this.onSendAction);
      }
      
      private function remove() : void
      {
         this.view.removeEventListener(ActionView.SENDACTIONID,this.onSendAction);
      }
      
      private function onSendAction(evt:MessageEvent) : void
      {
         var id:int = int(evt.body.actionId);
         this.sendMessage(MsgDoc.OP_CLIENT_MESSAGE_FACE.send,1,[id]);
      }
      
      public function get view() : ActionView
      {
         return this.getViewComponent() as ActionView;
      }
      
      override public function onRemove() : void
      {
         this.remove();
      }
   }
}

