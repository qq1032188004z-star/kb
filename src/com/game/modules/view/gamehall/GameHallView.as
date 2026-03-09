package com.game.modules.view.gamehall
{
   import com.core.observer.MessageEvent;
   import com.game.facade.ApplicationFacade;
   import com.game.locators.CacheData;
   import com.game.locators.GameData;
   import com.game.modules.control.gamehall.GameHallControl;
   import com.game.modules.view.MapView;
   import com.game.util.CacheUtil;
   import com.game.util.HLoaderSprite;
   import com.game.util.RenderUtil;
   import com.publiccomponent.loading.GreenLoading;
   import flash.display.Bitmap;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import org.green.server.manager.SocketManager;
   
   public class GameHallView extends HLoaderSprite
   {
      
      public static const haveplaygame:String = "haveplaygame";
      
      private var bitmap:Bitmap;
      
      private var enterdata:Object;
      
      private var logstring:String;
      
      public var onlineId:int;
      
      public function GameHallView()
      {
         super();
         ApplicationFacade.getInstance().registerViewLogic(new GameHallControl(this));
      }
      
      override public function initParams(obj:Object = null) : void
      {
         var hallcontrol:GameHallControl = null;
         hallcontrol = ApplicationFacade.getInstance().retrieveViewLogic(GameHallControl.NAME) as GameHallControl;
         GreenLoading.loading.visible = true;
         GameData.instance.playerData.playswfStatus = true;
         this.addBitmap();
         SocketManager.getGreenSocket().stopmove = true;
         this.context = new LoaderContext(false,ApplicationDomain.currentDomain);
         if(obj.onlineid == 2000)
         {
            this.onlineId = int(obj.onlineid);
            if(Boolean(obj.enter))
            {
               this.enterdata = GameData.instance.playerData.gamehalldata;
            }
            this.url = "assets/gamehall/onlinegame/OnlineGameRelease.swf";
            this.dispatchEvent(new MessageEvent(GameHallView.haveplaygame,10001));
            this.logstring = "gamehall/0";
            hallcontrol.startHallListen("hall");
            GameData.instance.playerData.gamehalldata.inhall = true;
         }
         if(obj.onlineid == 2100)
         {
            this.url = "assets/kbclass/answer/AnswerOnline.swf";
            this.dispatchEvent(new MessageEvent(GameHallView.haveplaygame,10002));
            this.logstring = "classonline/0";
            hallcontrol.startHallListen("class");
         }
         hallcontrol = null;
      }
      
      override public function setShow() : void
      {
         CacheData.instance.palyerStateDic[1] = 1;
         GreenLoading.loading.visible = false;
         if(bg && Boolean(bg.hasOwnProperty("enterToGame")))
         {
            bg["enterToGame"](this.enterdata);
         }
      }
      
      public function addBitmap() : void
      {
         this.bitmap = new Bitmap(MapView.instance.getStaticBg());
         this.addChild(this.bitmap);
         RenderUtil.instance.stopRender();
      }
      
      override public function disport() : void
      {
         CacheData.instance.palyerStateDic[1] = 0;
         GameData.instance.playerData.gamehalldata.inhall = false;
         SocketManager.getGreenSocket().stopmove = false;
         CacheUtil.deleteObject(GameHallView);
         ApplicationFacade.getInstance().removeViewLogic(GameHallControl.NAME);
         GameData.instance.playerData.playswfStatus = false;
         RenderUtil.instance.startRender();
         if(Boolean(this.bitmap))
         {
            if(this.contains(this.bitmap))
            {
               this.removeChild(this.bitmap);
            }
            if(Boolean(this.bitmap.bitmapData))
            {
               this.bitmap.bitmapData.dispose();
            }
         }
         this.bitmap = null;
         try
         {
            loader.loader.content["disport"]();
         }
         catch(e:*)
         {
         }
         super.disport();
      }
   }
}

