package com.game.modules.control
{
   import com.core.observer.MessageEvent;
   import com.core.view.ViewConLogic;
   import com.game.event.EventConst;
   import com.game.locators.MsgDoc;
   import com.game.manager.EventManager;
   import com.game.modules.view.RankingListView;
   import flash.events.Event;
   import flash.net.URLVariables;
   import phpcon.PhpConnection;
   import phpcon.PhpEvent;
   import phpcon.PhpEventConst;
   
   public class RankingListControl extends ViewConLogic
   {
      
      private static const NAME:String = "RankingListControl";
      
      public function RankingListControl(viewComponent:Object)
      {
         super(NAME,viewComponent);
         EventManager.attachEvent(this.view,Event.ADDED_TO_STAGE,this.addToStage);
         this.addToStage(null);
      }
      
      private function addToStage(evt:Event) : void
      {
         this.view.initEvents();
         EventManager.attachEvent(this.view,Event.REMOVED_FROM_STAGE,this.removeFromStage);
         EventManager.attachEvent(this.view,EventConst.GETTRANSFERRESULT,this.getResult);
         EventManager.attachEvent(this.view,EventConst.GETRANKINFO,this.getRankInfo);
         EventManager.attachEvent(PhpConnection.instance(),PhpEventConst.RANKINGLISTBACK,this.onPhpRankingListBack);
      }
      
      private function removeFromStage(evt:Event) : void
      {
         this.view.removeEvents();
         EventManager.removeEvent(this.view,Event.REMOVED_FROM_STAGE,this.removeFromStage);
         EventManager.removeEvent(this.view,EventConst.GETTRANSFERRESULT,this.getResult);
         EventManager.removeEvent(this.view,EventConst.GETRANKINFO,this.getRankInfo);
         EventManager.removeEvent(PhpConnection.instance(),PhpEventConst.RANKINGLISTBACK,this.onPhpRankingListBack);
      }
      
      public function get view() : RankingListView
      {
         return this.getViewComponent() as RankingListView;
      }
      
      override public function listEvents() : Array
      {
         return [[EventConst.GETTRANSFERRESULTBACK,this.getResultBack]];
      }
      
      private function getResult(event:Event) : void
      {
         sendMessage(MsgDoc.OP_CLIENT_LITTLE_GAME.send,this.view.getGameId(),[3]);
      }
      
      private function getResultBack(event:MessageEvent) : void
      {
         this.view.transferByResult(event.body.result as int);
      }
      
      private function getRankInfo(event:Event) : void
      {
         var urlvar:URLVariables = new URLVariables();
         urlvar.gameid = this.view.getGameId();
         urlvar.page = this.view.getCurrentPage();
         PhpConnection.instance().getdata("game_ranking.php",urlvar);
      }
      
      private function onPhpRankingListBack(evt:PhpEvent) : void
      {
         if(Boolean(evt.data))
         {
            this.view.setData(evt.data);
         }
      }
   }
}

