package com.game.comm
{
   import com.game.comm.enum.AlertMessageConst;
   import com.game.comm.manager.ActViewManager;
   import com.game.comm.view.ChatReportView;
   import com.game.comm.view.GourdShopView;
   import com.game.comm.view.NoCopperView;
   import com.game.comm.view.NoKbCoinView;
   import com.game.comm.view.SpeedCdView;
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.global.GlobalConfig;
   import com.game.locators.GameData;
   import com.game.modules.view.WindowLayer;
   import flash.external.ExternalInterface;
   
   public class AlertUtil
   {
      
      public function AlertUtil()
      {
         super();
      }
      
      public static function show() : void
      {
      }
      
      public static function showReportView(data:Object) : void
      {
         var view:ChatReportView = new ChatReportView(data);
         WindowLayer.instance.addChild(view);
      }
      
      public static function showNoKbCoinView(showNoKBFlag:Boolean = false, callback:Function = null) : void
      {
         var view:NoKbCoinView = null;
         if(showNoKBFlag)
         {
            if(ActViewManager.NO_KB_COIN_VIEW == 0)
            {
               ActViewManager.NO_KB_COIN_VIEW = 1;
               view = new NoKbCoinView(callback);
               WindowLayer.instance.addChild(view);
               return;
            }
            trace("【活动通用界面 の 卡布币不足】已经存在了");
         }
         if(ExternalInterface.available)
         {
            ExternalInterface.call("webOpenCharge",10,GlobalConfig.czUserName,0,GameData.instance.playerData.userName);
         }
      }
      
      public static function showNoCopperView(callback:Function = null) : void
      {
         var view:NoCopperView = null;
         if(ActViewManager.NO_COPPER_VIEW == 0)
         {
            ActViewManager.NO_COPPER_VIEW = 1;
            view = new NoCopperView(callback);
            WindowLayer.instance.addChild(view);
         }
         else
         {
            trace("【活动通用界面 の 铜钱不足】已经存在了");
         }
      }
      
      public static function showSpeedCdView(activeId:int, restCdTime:int, default_id:int = 0, otherFun:Function = null) : void
      {
         var view:SpeedCdView = null;
         AlertMessageConst.MPARAMS = activeId;
         AlertMessageConst.DEFAULT_ACTID = default_id;
         if(ActViewManager.SPEED_CD_VIEW == 0)
         {
            ActViewManager.SPEED_CD_VIEW = 1;
            view = new SpeedCdView(activeId,restCdTime,otherFun);
            WindowLayer.instance.addChild(view);
         }
         else
         {
            trace("【活动通用界面 の 加速CD】已经存在了");
         }
      }
      
      public static function showBuyGourdView(activeId:int, default_id:int = 0, otherFun:Function = null) : void
      {
         var view:GourdShopView = null;
         AlertMessageConst.MPARAMS = activeId;
         AlertMessageConst.DEFAULT_ACTID = default_id;
         if(ActViewManager.GOURD_SHOP_VIEW == 0)
         {
            ActViewManager.GOURD_SHOP_VIEW = 1;
            view = new GourdShopView(activeId,otherFun);
            WindowLayer.instance.addChild(view);
         }
         else
         {
            trace("【活动通用界面 の 葫芦商店】已经存在了");
         }
      }
      
      public static function showOpenVIP() : void
      {
         ApplicationFacade.getInstance().dispatch(EventConst.OPEN_MODULE,{
            "url":"assets/vip/VipExchangeModule.swf",
            "xCoord":0,
            "yCoord":0
         });
      }
   }
}

