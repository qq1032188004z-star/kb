package com.game.modules.control
{
   import com.core.observer.MessageEvent;
   import com.core.view.ViewConLogic;
   import com.game.event.EventConst;
   import com.game.locators.MsgDoc;
   import com.game.modules.view.SceneAIGameView;
   
   public class SceneAIGameControl extends ViewConLogic
   {
      
      public static const NAME:String = "sceneaigamecontrol";
      
      public function SceneAIGameControl(viewComponent:Object)
      {
         super(NAME,viewComponent);
      }
      
      override public function listEvents() : Array
      {
         return [[EventConst.STARTSCENEAIGAME,this.onSceneAIGameStart],[EventConst.GET_XIAO_YIN_YU,this.onHitFish]];
      }
      
      private function onSceneAIGameStart(evt:MessageEvent) : void
      {
         var body:Object = evt.body;
         SceneAIGameView.instance.dispos();
         SceneAIGameView.instance.load(body.id);
      }
      
      private function onHitFish(evt:MessageEvent) : void
      {
         sendMessage(MsgDoc.GETXIAOYINYU.send,401301);
      }
   }
}

