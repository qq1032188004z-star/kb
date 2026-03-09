package com.game.modules.control.job
{
   import com.core.observer.MessageEvent;
   import com.core.view.ViewConLogic;
   import com.game.event.EventConst;
   import com.game.locators.GameData;
   import com.game.locators.MsgDoc;
   import com.game.manager.EventManager;
   import com.game.modules.view.job.JobView;
   import com.publiccomponent.alert.Alert;
   import flash.events.Event;
   
   public class JobControl extends ViewConLogic
   {
      
      public static var NAME:String = "jobcontrol";
      
      public function JobControl(viewcon:Object = null)
      {
         super(NAME,viewcon);
         this.initEvent();
      }
      
      private function initEvent() : void
      {
         EventManager.attachEvent(this.view,JobView.startjob,this.checkJobOrnot);
      }
      
      override public function listEvents() : Array
      {
         return [[EventConst.STOPJOBING,this.stopJobing],[EventConst.JOBAWARD,this.reqJobAward],[EventConst.JOB_INFO_BACK,this.onJobInfoBack]];
      }
      
      private function get view() : JobView
      {
         return this.getViewComponent() as JobView;
      }
      
      private function stopJobing(evt:MessageEvent) : void
      {
         this.sendMessage(MsgDoc.CHECK_JOB_ORNOT.send,3);
      }
      
      private function reqJobAward(event:MessageEvent) : void
      {
         sendMessage(MsgDoc.CHECK_JOB_ORNOT.send,2);
      }
      
      private function onJobInfoBack(event:MessageEvent) : void
      {
         if(event.body.params == 1 && event.body.checknum == -1)
         {
            new Alert().showOne("你今天已经在这里打过一次工了，这样的体力活一天进行太多会累坏了身体哦。明天再来吧！");
            this.view.disport();
         }
         if(event.body.params == 2)
         {
            new Alert().showOne("感谢你的帮助，" + event.body.checknum + "铜钱的工资已经发放，欢迎明天再来帮忙！");
            GameData.instance.playerData.coin += event.body.checknum;
            this.view.disport();
         }
      }
      
      private function checkJobOrnot(evt:Event) : void
      {
         this.sendMessage(MsgDoc.CHECK_JOB_ORNOT.send,1);
      }
   }
}

