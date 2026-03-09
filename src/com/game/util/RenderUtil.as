package com.game.util
{
   import com.game.locators.CacheData;
   import com.game.locators.GameData;
   import com.game.modules.ai.AlphaArea;
   import com.game.modules.view.FaceView;
   import com.game.modules.view.MapView;
   import com.game.modules.view.VIPPrivilegeView;
   import com.game.modules.view.login.LoginView;
   import com.publiccomponent.alert.AlertContainer;
   import org.engine.frame.FrameTimer;
   
   public class RenderUtil
   {
      
      public static var instance:RenderUtil = new RenderUtil();
      
      public var renderstate:Boolean = true;
      
      public function RenderUtil()
      {
         super();
      }
      
      public function stopRender(value:int = 0) : void
      {
         this.renderstate = false;
         MapView.instance.x = -3000;
         FaceView.clip.x = -3110;
         AlphaArea.instance.x = -2000;
         MagicSprite.instance.x = -3000;
         LoginView.instance.x = -2000;
         ScreenSprite.instance.x = -2000;
         VIPPrivilegeView.getInstance().x = 3000;
         if(!BitValueUtil.getBitValue(value,1) && !CacheData.instance.isEscortModelOpen)
         {
            FrameTimer.getInstance().stop();
         }
      }
      
      public function startRender() : void
      {
         this.renderstate = true;
         MapView.instance.x = 0;
         MagicSprite.instance.x = 0;
         if(GameData.instance.playerData.isInWarCraft)
         {
            FaceView.clip.x = -3110;
            AlphaArea.instance.x = -2000;
            LoginView.instance.x = -2000;
            ScreenSprite.instance.x = -2000;
            VIPPrivilegeView.getInstance().x = 3000;
         }
         else
         {
            FaceView.clip.x = 0;
            AlphaArea.instance.x = 0;
            LoginView.instance.x = 0;
            ScreenSprite.instance.x = 0;
            VIPPrivilegeView.getInstance().x = 690;
         }
         FrameTimer.getInstance().start();
      }
      
      public function stopWarRender(flag:int = 1) : void
      {
         GameData.instance.playerData.isInWarCraft = true;
         DelayShowUtil.instance.systemControl = false;
         FaceView.clip.x = -3110;
         AlphaArea.instance.x = -2000;
         LoginView.instance.x = -2000;
         ScreenSprite.instance.x = -2000;
         VIPPrivilegeView.getInstance().x = 3000;
         if(flag == 2)
         {
            MapView.instance.x = -3000;
            FrameTimer.getInstance().stop();
         }
      }
      
      public function startWarRender() : void
      {
         GameData.instance.playerData.isInWarCraft = false;
         GameData.instance.playerData.isAcceptWarcraftInvite = false;
         GameData.instance.playerData.familyWarcraftWarId = 0;
         GameData.instance.playerData.teamId = 0;
         if(DelayShowUtil.instance.systemControl == false)
         {
            DelayShowUtil.instance.systemControl = true;
         }
         MapView.instance.x = 0;
         FaceView.clip.x = 0;
         AlphaArea.instance.x = 0;
         LoginView.instance.x = 0;
         ScreenSprite.instance.x = 0;
         VIPPrivilegeView.getInstance().x = 690;
         FrameTimer.getInstance().start();
      }
      
      public function stopAlert() : void
      {
         AlertContainer.instance.x = -2000;
      }
      
      public function startAlert() : void
      {
         AlertContainer.instance.x = 0;
      }
   }
}

