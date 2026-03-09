package com.game.modules.control.chat
{
   import com.core.observer.MessageEvent;
   import com.core.view.ViewConLogic;
   import com.game.event.EventConst;
   import com.game.locators.GameData;
   import com.game.locators.MsgDoc;
   import com.game.manager.EventManager;
   import com.game.modules.view.chat.MutilChatView;
   import com.game.modules.view.family.FamilySn;
   import flash.events.Event;
   
   public class MutilChatControl extends ViewConLogic
   {
      
      public static const NAME:String = "mutilchatcontrol";
      
      public function MutilChatControl(viewComponent:Object)
      {
         super(NAME,viewComponent);
         this.initViewEvent();
      }
      
      public function get view() : MutilChatView
      {
         return this.getViewComponent() as MutilChatView;
      }
      
      private function initViewEvent() : void
      {
         sendMessage(MsgDoc.OP_CLIENT_REQ_FAMILY_INFO.send,0,[FamilySn.MUTILCHATCONTROL_SN,GameData.instance.playerData.family_id]);
         EventManager.attachEvent(this.view,MutilChatView.EDITNOTIC,this.editNotice);
         EventManager.attachEvent(this.view,MutilChatView.SENDMUTIMSG,this.sendMutiMsg);
         EventManager.attachEvent(this.view,Event.ADDED_TO_STAGE,this.onAddToStage);
      }
      
      private function onAddToStage(evt:Event) : void
      {
         sendMessage(MsgDoc.OP_CLIENT_REQ_FAMILY_INFO.send,0,[FamilySn.MUTILCHATCONTROL_SN,GameData.instance.playerData.family_id]);
      }
      
      private function editNotice(evt:MessageEvent) : void
      {
         sendMessage(MsgDoc.OP_CLIENT_REQ_CHANGE_NOTICE.send,0,[evt.body.toString()]);
      }
      
      private function sendMutiMsg(evt:MessageEvent) : void
      {
         sendMessage(MsgDoc.OP_CLIENT_FAMILY_CHAT.send,0,[evt.body.id,evt.body.name,evt.body.msg]);
      }
      
      override public function listEvents() : Array
      {
         return [[EventConst.REQ_FAMILY_INFO_BACK,this.familyInfoBack],[EventConst.FAMILY_MEMBERS_BACK,this.familyMemberBack],[EventConst.MUTILCHATBACK,this.mutilChatBack]];
      }
      
      override public function onRemove() : void
      {
         EventManager.removeEvent(this.view,MutilChatView.EDITNOTIC,this.editNotice);
         EventManager.removeEvent(this.view,MutilChatView.SENDMUTIMSG,this.sendMutiMsg);
         EventManager.removeEvent(this.view,Event.ADDED_TO_STAGE,this.onAddToStage);
      }
      
      private function familyInfoBack(evt:MessageEvent) : void
      {
         if(evt.body.sn == 9999)
         {
            this.view.initFamilyInfo(evt.body);
            sendMessage(MsgDoc.OP_CLIENT_REQ_FAMILY_MEMBERS.send,0,[GameData.instance.playerData.family_id,0]);
         }
      }
      
      private function familyMemberBack(evt:MessageEvent) : void
      {
         this.view.initFamilyMemberList(evt.body as Array);
      }
      
      private function mutilChatBack(evt:MessageEvent) : void
      {
         var body:Object = null;
         if(GameData.instance.playerData.familyisOpen)
         {
            body = evt.body;
            this.view.chatBack(body);
         }
      }
   }
}

