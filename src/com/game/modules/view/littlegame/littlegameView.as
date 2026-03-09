package com.game.modules.view.littlegame
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.locators.GameData;
   import com.game.modules.control.*;
   import com.game.modules.view.MapView;
   import com.game.modules.view.pop.PopView;
   import com.game.util.RenderUtil;
   import com.game.util.SceneSoundManager;
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.loading.GreenLoading;
   import com.xygame.module.battle.event.BattleEvent;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.net.URLRequest;
   import flash.ui.Mouse;
   import flash.ui.MouseCursor;
   import org.green.server.manager.SocketManager;
   
   public class littlegameView
   {
      
      private var _gameType:int = 0;
      
      private var goodrecord:int;
      
      private var littleGameAlert:LittleGameAlert;
      
      private var alertmask:PopView;
      
      private var gamescore:int;
      
      private var gamexiuxing:int;
      
      private var sessionId:int;
      
      public var callback:Function;
      
      private var url:String = URLUtil.getSvnVer("assets/littlegame/TuixiangGame.swf");
      
      private var gameloader:Loader;
      
      public function littlegameView()
      {
         super();
      }
      
      public function set gameType(value:int) : void
      {
         this._gameType = value;
         this.loadLittleGame();
      }
      
      public function get gameType() : int
      {
         return this._gameType;
      }
      
      private function loadLittleGame() : void
      {
         GameData.instance.playerData.playswfStatus = true;
         GreenLoading.loading.visible = true;
         this.gameloader = new Loader();
         this.url = URLUtil.getSvnVer("assets/littlegame/game" + this.gameType + ".swf");
         this.gameloader.load(new URLRequest(this.url));
         this.gameloader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoaderComp);
         this.gameloader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.onLoadProgressHandler);
         this.gameloader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onIoErrorHandler);
         if(this.gameType == 1001)
         {
            this.gameloader.x = 260;
            this.gameloader.y = 80;
         }
      }
      
      private function onLoadProgressHandler(event:ProgressEvent) : void
      {
         GreenLoading.loading.setProgress("正在加载",event.bytesLoaded,event.bytesTotal);
      }
      
      private function onIoErrorHandler(event:IOErrorEvent) : void
      {
         trace("小游戏加载错误");
         this._gameType = 0;
      }
      
      private function onLoaderComp(event:Event) : void
      {
         SceneSoundManager.getInstance().playSound("littlegamemusic");
         SocketManager.getGreenSocket().stopmove = true;
         this.gameloader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoaderComp);
         this.gameloader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,this.onLoadProgressHandler);
         this.gameloader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onIoErrorHandler);
         this.gameloader.getChildAt(0).addEventListener(BattleEvent.littleGameOver,this.onLittleGameOver);
         this.gameloader.getChildAt(0).addEventListener(Event.CANCEL,this.onLittleGameOver);
         this.gameloader.getChildAt(0).addEventListener(Event.CLOSE,this.onCloseLittleGame);
         this.gameloader.addEventListener(Event.ADDED_TO_STAGE,this.onAddToStage);
         var mediator:MapControl = ApplicationFacade.getInstance().retrieveViewLogic(MapControl.NAME) as MapControl;
         GreenLoading.loading.visible = false;
         mediator.getViewComponent().stage.addChild(this.gameloader);
         try
         {
            this.gameloader.getChildAt(0)["goodRecord"](this.goodrecord);
         }
         catch(e:*)
         {
         }
      }
      
      private function onAddToStage(evt:Event) : void
      {
         this.gameloader.removeEventListener(Event.ADDED_TO_STAGE,this.onAddToStage);
         if(this.gameType != 1001 && this.gameType != 3002)
         {
            RenderUtil.instance.stopRender();
         }
      }
      
      private function onLittleGameOver(event:BattleEvent) : void
      {
         Mouse.cursor = MouseCursor.AUTO;
         Mouse.show();
         RenderUtil.instance.startRender();
         var obj:Object = {};
         obj.gameid = this.gameType;
         obj.gamelevel = int(event.battleInfo.level);
         obj.gamescore = int(event.battleInfo.score);
         this.gamescore = int(event.battleInfo.score);
         obj.sessionId = this.sessionId;
         ApplicationFacade.getInstance().dispatch(EventConst.LITTLE_GAME_OVER,obj);
         this.onShowLittleGameOver();
         this.removeLittleGame();
      }
      
      public function gameOverBack(obj:Object) : void
      {
         if(obj.act == -1)
         {
            SocketManager.getGreenSocket().close();
         }
         if(obj.act == 0)
         {
            this.sessionId = obj.result;
         }
         if(obj.act == 4)
         {
            if(obj.result < 0)
            {
               obj.result = 0;
            }
            this.gamexiuxing = obj.result;
            this.onShowLittleGameOver();
            if(Boolean(this.littleGameAlert) && !this.isLittleGameInTask())
            {
               this.littleGameAlert.xiuxing(this.gamexiuxing);
            }
         }
         else if(obj.act == 1)
         {
            this.goodrecord = int(obj.result);
            try
            {
               if(this.gameloader != null)
               {
                  this.gameloader.getChildAt(0)["goodRecord"](this.goodrecord);
               }
            }
            catch(e:*)
            {
            }
         }
      }
      
      private function onShowLittleGameOver() : void
      {
         SocketManager.getGreenSocket().stopmove = false;
         if(this.alertmask == null && !this.isLittleGameInTask())
         {
            this.alertmask = new PopView();
            ApplicationFacade.getInstance().retrieveViewLogic(MapControl.NAME).getViewComponent().stage.addChild(this.alertmask);
         }
         if(this.littleGameAlert == null && !this.isLittleGameInTask())
         {
            this.littleGameAlert = new LittleGameAlert({
               "jifen":this.gamescore,
               "xiuxing":this.gamexiuxing
            });
            SceneSoundManager.getInstance().playSound(MapView.instance.scene.config.@music);
            this.littleGameAlert.show(this.alertmask,300,170);
            this.littleGameAlert.addEventListener(Event.CLOSE,this.onCloseLittleGameAlert);
         }
      }
      
      private function onCloseLittleGameAlert(event:Event) : void
      {
         if(Boolean(this.littleGameAlert) && this.isLittleGameInTask())
         {
            this.littleGameAlert.removeEventListener(Event.CLOSE,this.onCloseLittleGameAlert);
         }
         if(this.alertmask && this.alertmask.parent && this.alertmask.parent.contains(this.alertmask))
         {
            this.alertmask.parent.removeChild(this.alertmask);
            this.alertmask = null;
         }
         this.littleGameAlert = null;
         this.onCloseLittleGame(null);
      }
      
      private function onCloseLittleGame(event:Event) : void
      {
         GameData.instance.playerData.playswfStatus = false;
         RenderUtil.instance.startRender();
         if(this.gameloader != null)
         {
            this.gameloader.getChildAt(0).removeEventListener(Event.CLOSE,this.onCloseLittleGame);
         }
         if(this.callback != null)
         {
            this.callback.apply(null,[false]);
         }
         this.callback = null;
         this.destroy();
      }
      
      private function destroy() : void
      {
         if(Boolean(ApplicationFacade.getInstance().retrieveViewLogic(LittlegameControl.NAME)))
         {
            ApplicationFacade.getInstance().removeViewLogic(LittlegameControl.NAME);
         }
         this.removeLittleGame();
      }
      
      private function removeLittleGame() : void
      {
         if(Boolean(this.gameloader) && this.gameloader.parent.contains(this.gameloader))
         {
            this.gameloader.parent.removeChild(this.gameloader);
         }
         if(Boolean(this.gameloader))
         {
            this.gameloader.unloadAndStop(true);
            this.gameloader.unload();
         }
         this.gameloader = null;
         this.callback = null;
         this._gameType = 0;
      }
      
      private function isLittleGameInTask() : Boolean
      {
         return this._gameType > 1000 && this._gameType != 1004 || this._gameType == 12;
      }
   }
}

