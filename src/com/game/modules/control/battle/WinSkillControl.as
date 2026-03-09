package com.game.modules.control.battle
{
   import com.core.observer.MessageEvent;
   import com.core.view.ViewConLogic;
   import com.game.event.EventConst;
   import com.game.locators.MsgDoc;
   import com.game.manager.EventManager;
   import com.game.modules.view.battle.pop.LearnSkillView;
   import com.game.modules.view.wakeup.WakeSkillView;
   import flash.events.Event;
   
   public class WinSkillControl extends ViewConLogic
   {
      
      public static const NAME:String = "winskillmediator";
      
      public function WinSkillControl(viewComponent:Object = null)
      {
         super(NAME,viewComponent);
         if(viewComponent is LearnSkillView)
         {
            sendMessage(MsgDoc.OP_CLIENT_REQ_ON_SKILL.send,this.view.spiritData.spiritid);
         }
         else if(viewComponent is WakeSkillView)
         {
            sendMessage(MsgDoc.OP_CLIENT_REQ_ON_SKILL.send,this.view.spiritData.id);
         }
         this.addListern();
      }
      
      override public function listEvents() : Array
      {
         return [[EventConst.REQ_NEW_OLD_SKILL_BACK,this.newOldSkillBack]];
      }
      
      private function addListern() : void
      {
         this.view.addEventListener("clickchangbtn",this.onClickLearnSkill);
         this.view.addEventListener("clickwakeupbtn",this.onClickWakeUpSkill);
      }
      
      private function wakeUpSkill(event:Event) : void
      {
         if(this.view is WakeSkillView)
         {
            sendMessage(MsgDoc.OP_CLIENT_REQ_ON_SKILL.send,this.view.spiritData.id);
         }
         else if(this.view is LearnSkillView)
         {
            sendMessage(MsgDoc.OP_CLIENT_REQ_ON_SKILL.send,this.view.spiritData.spiritid);
         }
         this.view.initEvents();
         EventManager.attachEvent(this.view,"clickchangbtn",this.onClickLearnSkill);
         EventManager.attachEvent(this.view,"clickwakeupbtn",this.onClickWakeUpSkill);
      }
      
      private function onClickLearnSkill(event:Event) : void
      {
         var i:int = 0;
         var obj:Object = this.view.changdata;
         var arr:Array = [];
         var length:int = int(obj.newskillarr.length);
         for(i = 0; i < length; i++)
         {
            arr.push(obj.newskillarr[i].skillid);
         }
         sendMessage(MsgDoc.OP_CLIENT_CHANGE_SPIRIT_SKILL.send,obj.key,[obj.uniqueid,arr]);
      }
      
      private function onClickWakeUpSkill(event:Event) : void
      {
         var i:int = 0;
         var obj:Object = this.view.changdata;
         var arr:Array = [];
         var length:int = int(obj.newskillarr.length);
         for(i = 0; i < length; i++)
         {
            arr.push(obj.newskillarr[i].skillid);
         }
         sendMessage(MsgDoc.OP_CLIENT_WAKEUP_SKILL.send,obj.uniqueid,[obj.key,arr]);
      }
      
      private function get view() : *
      {
         return getViewComponent();
      }
      
      private function newOldSkillBack(event:MessageEvent) : void
      {
         if(Boolean(this.view.hasOwnProperty("newOldSkillBack")))
         {
            this.view.newOldSkillBack(event.body);
         }
      }
   }
}

