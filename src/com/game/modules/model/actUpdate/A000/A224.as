package com.game.modules.model.actUpdate.A000
{
   import com.game.locators.GameData;
   import com.game.modules.view.FaceView;
   import com.game.modules.vo.ActivityVo;
   import com.publiccomponent.ui.ButtonEffect;
   import com.publiccomponent.util.ButtonEffectUtil;
   import org.green.server.events.MsgEvent;
   
   public class A224
   {
      
      private static var _ins:A224;
      
      public function A224()
      {
         super();
      }
      
      public static function get ins() : A224
      {
         return _ins = _ins || new A224();
      }
      
      public function handlerPresuresIconMovie(vo:ActivityVo, evt:MsgEvent) : void
      {
         if(GameData.instance.playerData.isNewHand < 8)
         {
            return;
         }
         var mbody:Object = {};
         switch(vo.protocolID)
         {
            case 3:
               mbody.showFlag = evt.msg.body.readInt();
               if(mbody.showFlag == 1)
               {
                  ButtonEffectUtil.registerEffect(FaceView.clip.getTopButton("presureBtn"),ButtonEffect.EFFECT_NEW,false);
               }
         }
      }
   }
}

