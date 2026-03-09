package com.game.modules.model.actUpdate.A000
{
   import com.game.locators.CacheData;
   import com.game.locators.GameData;
   import com.game.modules.view.FaceView;
   import com.game.modules.view.MapView;
   import com.game.modules.view.WindowLayer;
   import com.game.modules.vo.ActivityVo;
   import com.game.util.FloatAlert;
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.ui.ButtonEffect;
   import com.publiccomponent.util.ButtonEffectUtil;
   import org.engine.core.GameSprite;
   import org.green.server.events.MsgEvent;
   
   public class A325
   {
      
      private static var _ins:A325;
      
      private var _treasureBox:GameSprite;
      
      public function A325()
      {
         super();
      }
      
      public static function get ins() : A325
      {
         return _ins = _ins || new A325();
      }
      
      public function handleSevenTreasureData(vo:ActivityVo, evt:MsgEvent) : void
      {
         var treasureResult:Object = new Object();
         var protocolId:int = vo.protocolID;
         switch(protocolId)
         {
            case 4:
               treasureResult.result = evt.msg.body.readInt();
               if(treasureResult.result == 0)
               {
                  CacheData.instance.treasureSceneId = evt.msg.body.readInt();
                  CacheData.instance.treasureRestHuntTime = evt.msg.body.readInt();
                  if(GameData.instance.playerData.sceneId == CacheData.instance.treasureSceneId && CacheData.instance.treasureRestHuntTime > 0)
                  {
                     if(this._treasureBox != null)
                     {
                        this._treasureBox.dispos();
                        this._treasureBox = null;
                     }
                     this.addTreasureBox();
                  }
                  if(CacheData.instance.treasureSceneId != 0 && CacheData.instance.treasureRestHuntTime > 0)
                  {
                     ButtonEffectUtil.registerEffect(FaceView.clip.getTopButton("sevenTreasureBtn"),ButtonEffect.EFFECT_TIMER,false,0,0,CacheData.instance.treasureRestHuntTime);
                  }
               }
               else
               {
                  CacheData.instance.treasureSceneId = 0;
                  CacheData.instance.treasureRestHuntTime = 0;
               }
               break;
            case 5:
               treasureResult.result = evt.msg.body.readInt();
               if(treasureResult.result != 0)
               {
                  new FloatAlert().show(WindowLayer.instance,250,400,"寻宝时间已过");
               }
               ButtonEffectUtil.delEffect(FaceView.clip.getTopButton("sevenTreasureBtn"));
         }
      }
      
      private function addTreasureBox() : void
      {
         this._treasureBox = new GameSprite();
         this._treasureBox.url = URLUtil.getSvnVer("assets/system/sevenTreasure/SevenTreasureBoxAI.swf");
         MapView.instance.addGameSprite(this._treasureBox);
      }
   }
}

