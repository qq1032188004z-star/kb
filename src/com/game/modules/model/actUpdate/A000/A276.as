package com.game.modules.model.actUpdate.A000
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.locators.CacheData;
   import com.game.modules.view.FaceView;
   import com.game.modules.vo.ActivityVo;
   import com.game.util.CheckMetalHeroBtnUtil;
   import com.publiccomponent.ui.ButtonEffect;
   import com.publiccomponent.util.ButtonEffectUtil;
   import org.green.server.events.MsgEvent;
   
   public class A276
   {
      
      private static var _ins:A276;
      
      public function A276()
      {
         super();
      }
      
      public static function get ins() : A276
      {
         return _ins = _ins || new A276();
      }
      
      public function onNewHandBraveInfo($vo:ActivityVo, $evt:MsgEvent) : void
      {
         FaceView.clip.topClip.hideBtnByName("metalHeroBtn");
         FaceView.clip.topClip.hideBtnByName("newBraveBtn");
         if($vo == null || $evt == null)
         {
            return;
         }
         if($vo.protocolID == 1)
         {
            $vo.valueobject.flag = $evt.msg.body.readInt();
            $vo.valueobject.index1 = $evt.msg.body.readInt();
            $vo.valueobject.index2 = $evt.msg.body.readInt();
            $vo.valueobject.index3 = $evt.msg.body.readInt();
            $vo.valueobject.boss1 = $evt.msg.body.readInt();
            $vo.valueobject.boss2 = $evt.msg.body.readInt();
            if($vo.valueobject.flag == 0)
            {
               if(CacheData.instance.isPlayBraveEffect)
               {
                  ButtonEffectUtil.registerEffect(FaceView.clip.getTopButton("braveBtn"),ButtonEffect.EFFECT_BRAVER,true);
               }
            }
            else if($vo.valueobject.flag == 1)
            {
               if(CacheData.instance.isPlayBraveEffect)
               {
                  ButtonEffectUtil.registerEffect(FaceView.clip.getTopButton("braveBtn"),ButtonEffect.EFFECT_BRAVER_AWARD,true);
               }
               else
               {
                  ButtonEffectUtil.registerEffect(FaceView.clip.getTopButton("braveBtn"),ButtonEffect.EFFECT_AWARD1,false);
               }
            }
            else if($vo.valueobject.flag == 2)
            {
               FaceView.clip.topClip.hideBtnByName("braveBtn");
               CheckMetalHeroBtnUtil.instance().braveStatus = false;
               ButtonEffectUtil.delEffect(FaceView.clip.getTopButton("braveBtn"));
            }
         }
         else if($vo.protocolID == 2)
         {
            $vo.valueobject.index = $evt.msg.body.readInt();
            $vo.valueobject.result = $evt.msg.body.readInt();
            $vo.valueobject.flag = $evt.msg.body.readInt();
            if($vo.valueobject.flag == 0)
            {
               ButtonEffectUtil.delEffect(FaceView.clip.getTopButton("braveBtn"));
            }
            else if($vo.valueobject.flag == 1)
            {
               ButtonEffectUtil.registerEffect(FaceView.clip.getTopButton("braveBtn"),ButtonEffect.EFFECT_AWARD1,false);
            }
            else
            {
               FaceView.clip.topClip.hideBtnByName("braveBtn");
               CheckMetalHeroBtnUtil.instance().braveStatus = false;
               ButtonEffectUtil.delEffect(FaceView.clip.getTopButton("braveBtn"));
            }
         }
         else if($vo.protocolID == 3)
         {
            $vo.valueobject.result = $evt.msg.body.readInt();
            if($vo.valueobject.result == 1)
            {
               ApplicationFacade.getInstance().dispatch(EventConst.BOBSTATECLICK,{"url":"assets/system/newHand/brave/NewHandBraveRoad.swf"});
            }
         }
      }
   }
}

