package com.game.modules.model.actUpdate.A000
{
   import com.game.locators.CacheData;
   import com.game.locators.GameData;
   import com.game.modules.view.FaceView;
   import com.game.modules.vo.ActivityVo;
   import com.game.util.CheckMetalHeroBtnUtil;
   import com.publiccomponent.ui.ButtonEffect;
   import com.publiccomponent.util.ButtonEffectUtil;
   import org.green.server.events.MsgEvent;
   
   public class A151
   {
      
      private static var _ins:A151;
      
      public function A151()
      {
         super();
      }
      
      public static function get ins() : A151
      {
         return _ins = _ins || new A151();
      }
      
      public function onNewPlayerSign($vo:ActivityVo, $evt:MsgEvent) : void
      {
         FaceView.clip.topClip.hideBtnByName("metalHeroBtn");
         if($vo == null || $evt == null)
         {
            return;
         }
         if($vo.protocolID == 1)
         {
            $vo.valueobject.iResult = $evt.msg.body.readInt();
            $vo.valueobject.iSignTimes = $evt.msg.body.readInt();
            if($vo.valueobject.iResult == 0 || $vo.valueobject.iResult == 3)
            {
               if(GameData.instance.playerData.isNewHand >= 6)
               {
                  CheckMetalHeroBtnUtil.instance().freshManAwardStatus = true;
                  if($vo.valueobject.iResult == 0)
                  {
                     ButtonEffectUtil.registerEffect(FaceView.clip.getTopButton("freshManAwardBtn"),ButtonEffect.EFFECT_AWARD1,false);
                  }
                  else
                  {
                     ButtonEffectUtil.delEffect(FaceView.clip.getTopButton("freshManAwardBtn"));
                  }
               }
            }
            else
            {
               ButtonEffectUtil.delEffect(FaceView.clip.getTopButton("freshManAwardBtn"));
               FaceView.clip.topClip.hideBtnByName("freshManAwardBtn");
               CheckMetalHeroBtnUtil.instance().freshManAwardStatus = false;
            }
         }
         else if($vo.protocolID == 2)
         {
            $vo.valueobject.iResult = $evt.msg.body.readInt();
            $vo.valueobject.iSignTimes = $evt.msg.body.readInt();
            ButtonEffectUtil.delEffect(FaceView.clip.getTopButton("freshManAwardBtn"));
            if($vo.valueobject.iSignTimes >= 7)
            {
               FaceView.clip.topClip.hideBtnByName("freshManAwardBtn");
               CheckMetalHeroBtnUtil.instance().freshManAwardStatus = false;
               if(CacheData.instance.isPlayBraveEffect)
               {
                  ButtonEffectUtil.registerEffect(FaceView.clip.getTopButton("braveBtn"),ButtonEffect.EFFECT_BRAVER,true);
               }
               else
               {
                  ButtonEffectUtil.delEffect(FaceView.clip.getTopButton("braveBtn"));
               }
            }
         }
      }
   }
}

