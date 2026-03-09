package com.game.modules.control.challenge
{
   import com.core.observer.MessageEvent;
   import com.core.view.ViewConLogic;
   import com.game.event.EventConst;
   import com.game.modules.view.challenge.ChallengeView;
   
   public class ChallengeControl extends ViewConLogic
   {
      
      public static const name:String = "challengecontrol";
      
      public function ChallengeControl(viewCon:Object = null)
      {
         super(name,viewCon);
      }
      
      override public function listEvents() : Array
      {
         return [[EventConst.CLOSECHALLENGE,this.closeView]];
      }
      
      private function get view() : ChallengeView
      {
         return this.getViewComponent() as ChallengeView;
      }
      
      private function closeView(evt:MessageEvent) : void
      {
         this.view.disport();
      }
   }
}

