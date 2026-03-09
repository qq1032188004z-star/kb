package com.game.modules.control.battle
{
   import com.core.observer.MessageEvent;
   import com.core.view.ViewConLogic;
   import com.game.event.EventConst;
   import com.game.modules.view.battle.BeforeBattleView;
   import com.xygame.module.battle.event.BattleEvent;
   
   public class BeforeBattleControl extends ViewConLogic
   {
      
      public static const NAME:String = "beforebattlemediator";
      
      public function BeforeBattleControl(viewComponent:Object = null)
      {
         super(NAME,viewComponent);
         this.listenViewEvent();
      }
      
      public function listenViewEvent() : void
      {
         this.view.addEventListener(BattleEvent.showBeforeBattle,this.onShowBeforeBattle);
      }
      
      private function onShowBeforeBattle(event:BattleEvent) : void
      {
         dispatch(EventConst.SHOW_BEFORE_BATTLE_VIEW);
      }
      
      override public function listEvents() : Array
      {
         return [[EventConst.LOAD_BATTLE_SOURCE,this.loadPercent]];
      }
      
      private function loadPercent(event:MessageEvent) : void
      {
         this.view.loadPercent(event.body);
      }
      
      private function get view() : BeforeBattleView
      {
         return this.getViewComponent() as BeforeBattleView;
      }
   }
}

