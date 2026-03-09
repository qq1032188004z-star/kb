package com.game.modules.control.achieve
{
   import com.channel.ChannelEvent;
   import com.channel.ChannelPool;
   import com.core.observer.MessageEvent;
   import com.core.view.ViewConLogic;
   import com.game.event.EventConst;
   import com.game.locators.MsgDoc;
   import com.game.manager.EventManager;
   import com.game.modules.view.achieve.AchieveView;
   import com.publiccomponent.loading.GreenLoading;
   import flash.events.Event;
   
   public class AchieveControl extends ViewConLogic
   {
      
      public static const NAME:String = "achievecontrol";
      
      public function AchieveControl(viewComponent:Object = null)
      {
         super(NAME,viewComponent);
         this.listenerchannel();
         this.onaddtostage();
      }
      
      private function initEvent() : void
      {
         EventManager.attachEvent(this.view,EventConst.ACHIEVEMENT_AWARD_REQ_INFO,this.onReqAchieveInfo);
         EventManager.attachEvent(this.view,EventConst.ACHIEVEMENT_REQ_AWARD_GET_TWO,this.onGetAchieveAward);
      }
      
      override public function listEvents() : Array
      {
         return [[EventConst.ACHIEVEMENT_BACK,this.onAchievementback],[EventConst.ACHIEVEMENT_AWARD_INFO_BACK,this.onAchievemenAwardInfoback],[EventConst.ACHIEVEMENT_AWARD_GET_BACK,this.onAchievementGetback]];
      }
      
      private function onAchievementback(evt:MessageEvent) : void
      {
         GreenLoading.loading.visible = true;
         this.view.ba = evt.body.ba;
         this.view.startload();
      }
      
      private function onAchievemenAwardInfoback(evt:MessageEvent) : void
      {
         this.view.achievementAwardInfoBack(evt.body);
      }
      
      private function onAchievementGetback(evt:MessageEvent) : void
      {
         this.view.achievementAwardGetBack(evt.body);
      }
      
      private function listenerchannel() : void
      {
         ChannelPool.getChannel("achievement").addChannelListener("closeachievement",this.onCloseAchievement);
         ChannelPool.getChannel("achievement").addChannelListener("cleangreenloading",this.onCleangreenloading);
      }
      
      private function onCloseAchievement(event:ChannelEvent) : void
      {
         ChannelPool.getChannel("achievement").removeListener("closeachievement",this.onCloseAchievement);
         ChannelPool.getChannel("achievement").removeListener("cleangreenloading",this.onCleangreenloading);
         this.view.disport();
      }
      
      private function onCleangreenloading(evt:ChannelEvent) : void
      {
         GreenLoading.loading.visible = false;
      }
      
      private function onaddtostage() : void
      {
         this.sendMessage(MsgDoc.OP_CLIENT_ACHIEVEMENT.send,this.view.id);
         this.initEvent();
      }
      
      private function onReqAchieveInfo(evt:Event) : void
      {
         if(this.view.id == 0)
         {
            sendMessage(MsgDoc.OP_CLIENT_ACTIVITY_QINGYANG.send,336,[1]);
         }
      }
      
      private function onGetAchieveAward(evt:Event) : void
      {
         if(this.view.id == 0)
         {
            sendMessage(MsgDoc.OP_CLIENT_ACTIVITY_QINGYANG.send,336,[2]);
         }
      }
      
      private function get view() : AchieveView
      {
         return this.getViewComponent() as AchieveView;
      }
   }
}

