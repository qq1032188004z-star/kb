package com.game.modules.model.actUpdate.A400
{
   import com.game.global.GlobalConfig;
   import com.game.locators.GameData;
   import com.game.locators.MsgDoc;
   import com.game.modules.view.MapView;
   import com.game.modules.view.WindowLayer;
   import com.game.modules.vo.ActivityVo;
   import com.game.util.DateUtil;
   import com.game.util.DelayShowUtil;
   import com.game.util.GameAction;
   import com.game.util.SceneSoundManager;
   import org.green.server.events.MsgEvent;
   import org.green.server.manager.SocketManager;
   
   public class A405
   {
      
      private static var _ins:A405;
      
      private var _fallPageFlag:Boolean = true;
      
      public function A405()
      {
         super();
      }
      
      public static function get ins() : A405
      {
         return _ins = _ins || new A405();
      }
      
      public function onAct405Update(vo:ActivityVo, evt:MsgEvent) : void
      {
         var pre_ani:int = 0;
         if(vo == null || evt == null)
         {
            return;
         }
         switch(vo.protocolID)
         {
            case 1:
               GlobalConfig.COMBAT_GAP_TIME = evt.msg.body.readInt();
               SceneSoundManager.getInstance().setBgVolumn(evt.msg.body.readInt() / 100);
               SceneSoundManager.getInstance().effectMusicVolumn = evt.msg.body.readInt() / 100;
               GlobalConfig.STAGE_QUALITY = evt.msg.body.readInt();
               WindowLayer.instance.stage.quality = GlobalConfig.getCurQuality();
               GlobalConfig.is_show_restraint = evt.msg.body.readInt();
               GlobalConfig.is_show_collect_auto_alert = evt.msg.body.readInt();
               GlobalConfig.is_vip_auto_recover = evt.msg.body.readInt();
               GlobalConfig.is_hide_beibei = evt.msg.body.readInt();
               pre_ani = evt.msg.body.readInt();
               GlobalConfig.pre_ani = pre_ani;
               if(GlobalConfig.is_hide_beibei == 1 && DelayShowUtil.instance.isShowPlayer)
               {
                  DelayShowUtil.instance.hidePlayersBeiBei();
               }
               if(GameData.instance.playerData.isNewHand >= 9)
               {
                  if(GlobalConfig.pre_ani == 0)
                  {
                     this.getFallPage();
                  }
               }
         }
      }
      
      public function getFallPage() : void
      {
         var timeArr:Array;
         if(!this._fallPageFlag)
         {
            return;
         }
         this._fallPageFlag = false;
         timeArr = ["20260130000000","20260305235959"];
         if(DateUtil.isServerTimeBetween(timeArr[0],timeArr[1]))
         {
            GameAction.instance.playSwf(MapView.instance,200,100,"assets/activity/ani/PreHotMovie" + GameData.instance.playerData.sex + ".swf",function():void
            {
            },1,true);
            SocketManager.getGreenSocket().sendCmd(MsgDoc.OP_CLIENT_ACTIVITY_QINGYANG.send,405,[3,9,1]);
         }
      }
   }
}

