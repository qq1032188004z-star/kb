package com.game.modules.control
{
   import com.core.observer.MessageEvent;
   import com.core.view.ViewConLogic;
   import com.game.event.EventConst;
   import com.game.locators.GameData;
   import com.game.locators.MsgDoc;
   import com.game.modules.view.littlegame.littlegameView;
   import com.publiccomponent.alert.Alert;
   
   public class LittlegameControl extends ViewConLogic
   {
      
      public static const NAME:String = "littlegamemediator";
      
      private var _currentLittleGameID:int;
      
      private var pkid:int;
      
      public function LittlegameControl(viewComponent:Object = null)
      {
         super(NAME,viewComponent);
      }
      
      override public function listEvents() : Array
      {
         return [[EventConst.LITTLE_GAME_START,this.onlittleGameStart],[EventConst.LITTLE_GAME_OVER_BACK,this.onlittleGameoverBack],[EventConst.LITTLE_GAME_OVER,this.onlittleGameOver]];
      }
      
      private function onlittleGameStart(event:MessageEvent) : void
      {
         var gameTempID:int = 0;
         var gameType:int = 0;
         if(event.body is int)
         {
            gameTempID = int(event.body);
         }
         else
         {
            gameTempID = int(event.body.gameid);
         }
         if(this._currentLittleGameID == gameTempID)
         {
            return;
         }
         this._currentLittleGameID = gameTempID;
         var lgv:littlegameView = new littlegameView();
         gameType = gameTempID;
         if(!(event.body is int))
         {
            lgv.callback = event.body.callback;
         }
         lgv.gameType = gameType;
         this.viewComponent = lgv;
         if(gameType == GameData.instance.littlegamePkId)
         {
            this.pkid = GameData.instance.littlegameplayerid;
            sendMessage(MsgDoc.OP_CLIENT_LITTLE_GAME.send,gameType,[0,0,0,0,GameData.instance.littlegameplayerid,GameData.instance.littlegameplayerScore]);
            GameData.instance.littlegameplayerid = 0;
            GameData.instance.littlegameplayerScore = 0;
         }
         else
         {
            sendMessage(MsgDoc.OP_CLIENT_LITTLE_GAME.send,gameType,[0,0,0,0,0,0]);
         }
      }
      
      private function onlittleGameOver(event:MessageEvent) : void
      {
         var obj:Object = event.body;
         if(Boolean(obj.hasOwnProperty("gamelevel")) && obj.gamelevel == 0)
         {
            obj.gamelevel = 2;
         }
         if(this._currentLittleGameID == 4 && obj.gamelevel && obj.gamelevel == 2)
         {
            obj.gamelevel = 1;
         }
         sendMessage(MsgDoc.OP_CLIENT_LITTLE_GAME.send,obj.gameid,[4,int(obj.gamelevel) - 1,int(obj.gamescore),int(obj.sessionId),0,0]);
         this._currentLittleGameID = 0;
      }
      
      private function onlittleGameoverBack(event:MessageEvent) : void
      {
         var obj:Object = event.body;
         this.view.gameOverBack(obj);
         if(obj.hasOwnProperty("pkr"))
         {
            if(obj.pkr > 0 && this.pkid != 0)
            {
               new Alert().show("挑战成功!赢了：" + GameData.instance.littlegameplayername);
               this.pkid = 0;
            }
         }
      }
      
      private function get view() : littlegameView
      {
         return this.getViewComponent() as littlegameView;
      }
      
      override public function onRemove() : void
      {
         this.viewComponent = null;
         this._currentLittleGameID = 0;
      }
   }
}

