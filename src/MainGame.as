package
{
   import com.core.observer.MessageEvent;
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.global.GlobalConfig;
   import com.game.locators.GameData;
   import com.game.locators.GlobalAPI;
   import com.game.manager.EventManager;
   import com.game.manager.cursor.CursorLayer;
   import com.game.modules.ai.AlphaArea;
   import com.game.modules.view.FaceView;
   import com.game.modules.view.MapView;
   import com.game.modules.view.VIPPrivilegeView;
   import com.game.modules.view.WindowLayer;
   import com.game.modules.view.battle.util.FramedAniMgr;
   import com.game.modules.view.battle.util.FramedAnimation;
   import com.game.modules.view.login.LoginView;
   import com.game.modules.view.task.TaskView;
   import com.game.util.MagicSprite;
   import com.game.util.ScreenSprite;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.getTimer;
   
   public class MainGame extends Sprite
   {
      
      private var _framedAniMgrUpdate:Function;
      
      private var _needKeepAniRate:Boolean = true;
      
      private var _preFramedTime:Number;
      
      public function MainGame()
      {
         super();
         GameData.instance;
         EventManager.attachEvent(this,Event.ADDED_TO_STAGE,this.onAddToStage);
      }
      
      private function onAddToStage(evt:Event) : void
      {
         FramedAniMgr.stage = stage;
         FramedAnimation.mainFrameRate = stage.frameRate;
         FramedAniMgr.getMainInstance().setUpdateFNCacher(this.getFramedAniMgrUpdate);
         addEventListener(Event.ENTER_FRAME,this.onEnterFrameHandler,false,0,true);
         EventManager.removeEvent(this,Event.ADDED_TO_STAGE,this.onAddToStage);
         this.startMVC();
         this.initGame();
      }
      
      private function startMVC() : void
      {
         GlobalAPI.eventDispatcher = new EventDispatcher();
         ApplicationFacade.getInstance().startUp();
      }
      
      private function initGame() : void
      {
         EventManager.attachEvent(LoginView.instance,EventConst.LOGINGAMEBACK,this.onLoginComplement);
         this.addChild(MapView.instance);
         this.addChild(MagicSprite.instance);
         this.addChild(WindowLayer.instance);
         FaceView.registerParent(this,0,0);
         addChild(LoginView.instance);
         this.addChild(TaskView.instance);
         this.addChild(AlphaArea.instance);
      }
      
      private function getFramedAniMgrUpdate(updateFN:Function) : void
      {
         this._framedAniMgrUpdate = updateFN;
      }
      
      private function onLoginComplement(evt:MessageEvent) : void
      {
         EventManager.removeEvent(LoginView.instance,EventConst.LOGINGAMEBACK,this.onLoginComplement);
         this.createGame();
      }
      
      private function createGame() : void
      {
         FaceView.clip.visible = true;
         this.addChild(new CursorLayer());
         this.swapChildren(WindowLayer.instance,FaceView.clip);
         var windowlayerIndex:int = this.getChildIndex(WindowLayer.instance);
         this.addChildAt(VIPPrivilegeView.getInstance(),windowlayerIndex);
         this.addChild(ScreenSprite.instance);
         ApplicationFacade.getInstance().dispatch(EventConst.GETUSERTASKLIST);
         ApplicationFacade.getInstance().dispatch(EventConst.ONGETRIGHTUPCLIP);
      }
      
      protected function onEnterFrameHandler(event:Event) : void
      {
         var curFramedTime:Number = NaN;
         var count:int = 0;
         var i:int = 0;
         if(this._needKeepAniRate)
         {
            curFramedTime = getTimer();
            count = (curFramedTime - this._preFramedTime) / 42;
            count = count <= 0 ? 1 : count;
            count = count >= 2 ? count + 1 : count;
            switch(GlobalConfig.COMBAT_GAP_TIME)
            {
               case 2:
                  count *= 2;
                  break;
               case 3:
                  count *= 3;
            }
            for(i = 0; i < count; i++)
            {
               this._framedAniMgrUpdate();
            }
            this._preFramedTime = curFramedTime;
         }
         else
         {
            this._framedAniMgrUpdate();
         }
      }
   }
}

