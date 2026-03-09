package com.game.modules.control.achieve
{
   import com.core.observer.MessageEvent;
   import com.core.view.ViewConLogic;
   import com.game.event.EventConst;
   import com.game.modules.view.achieve.AchieveRank;
   
   public class AchieveRankControl extends ViewConLogic
   {
      
      public static const NAME:String = "selectspritmediator";
      
      public function AchieveRankControl(viewComponent:Object = null)
      {
         super(NAME,viewComponent);
      }
      
      override public function listEvents() : Array
      {
         return [[EventConst.ACHIEVEMENT_RANK_BACK,this.onAchieventRankBack]];
      }
      
      private function onAchieventRankBack(event:MessageEvent) : void
      {
         this.view.onAchieveback(event.body);
      }
      
      private function get view() : AchieveRank
      {
         return this.getViewComponent() as AchieveRank;
      }
   }
}

