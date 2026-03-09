package com.game.modules.model.actUpdate.A900
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.locators.CacheData;
   import com.game.locators.GameData;
   import com.game.modules.view.FaceView;
   import com.game.modules.vo.ActivityVo;
   import com.publiccomponent.util.ButtonEffectUtil;
   import org.green.server.events.MsgEvent;
   
   public class A900
   {
      
      private static var _ins:A900;
      
      public function A900()
      {
         super();
      }
      
      public static function get ins() : A900
      {
         return _ins = _ins || new A900();
      }
      
      public function handleHeavenFurui(vo:ActivityVo, evt:MsgEvent) : void
      {
         var isVailTime:int = 0;
         var clickIconFlag:int = 0;
         var openBoxNum:int = 0;
         var i:int = 0;
         var boxId:int = 0;
         var protocolId:int = vo.protocolID;
         var boxNum:int = 0;
         switch(protocolId)
         {
            case 1:
               isVailTime = evt.msg.body.readInt();
               clickIconFlag = evt.msg.body.readInt();
               boxNum = evt.msg.body.readInt();
               for(i = 0; i < boxNum; i++)
               {
                  boxId = evt.msg.body.readInt();
               }
               openBoxNum = evt.msg.body.readInt();
               if(isVailTime == 1 && boxNum >= 1 && CacheData.instance.openboxscene != GameData.instance.playerData.currentScenenId)
               {
                  CacheData.instance.openboxscene = GameData.instance.playerData.currentScenenId;
                  ApplicationFacade.getInstance().dispatch(EventConst.BOBSTATECLICK,{"url":"assets/system/HeavenFuruiBox/HeavenFuruiBox.swf"});
               }
               break;
            case 6:
               boxNum = evt.msg.body.readInt();
               if(boxNum == 0)
               {
                  ButtonEffectUtil.delEffect(FaceView.clip.getTopButton("heavenFuruiBtn"));
               }
               break;
            default:
               trace("+++++++protocolId:" + protocolId);
         }
      }
   }
}

