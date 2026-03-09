package com.game.modules.view
{
   import com.game.comm.AlertUtil;
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.locators.GameData;
   import com.game.locators.MsgDoc;
   import com.game.util.CacheUtil;
   import com.game.util.HLoaderSprite;
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.loading.GreenLoading;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import org.green.server.manager.SocketManager;
   
   public class VIPNoticeView extends HLoaderSprite
   {
      
      public function VIPNoticeView()
      {
         super();
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoveFromStage);
         GreenLoading.loading.visible = true;
         this.url = URLUtil.getSvnVer("assets/vip/vipnotice.swf");
      }
      
      override public function setShow() : void
      {
         this.loader.loader.unloadAndStop(false);
         this.bg.cacheAsBitmap = true;
         if(bg != null)
         {
            bg.checkClip.gotoAndStop(2);
            bg.nameTxt.text = GameData.instance.playerData.userName;
            addChild(bg);
            this.initEvent();
         }
      }
      
      private function initEvent() : void
      {
         if(bg != null)
         {
            bg.closeBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.closeView);
            bg.xufeiBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.onClickBtn);
            bg.tequanBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.onClickBtn);
            bg.baokanBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.onClickBtn);
            bg.shopBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.onClickBtn);
            bg.weekBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.onClickBtn);
            bg.checkBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.checkSelect);
         }
      }
      
      private function removeEvent() : void
      {
         if(bg != null)
         {
            bg.closeBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.closeView);
            bg.xufeiBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.onClickBtn);
            bg.tequanBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.onClickBtn);
            bg.baokanBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.onClickBtn);
            bg.shopBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.onClickBtn);
            bg.weekBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.onClickBtn);
            bg.checkBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.checkSelect);
         }
      }
      
      private function onClickBtn(evt:MouseEvent) : void
      {
         switch(evt.target)
         {
            case bg.xufeiBtn:
               AlertUtil.showNoKbCoinView();
               this.closeView(null);
               break;
            case bg.tequanBtn:
               ApplicationFacade.getInstance().dispatch(EventConst.OPEN_MODULE,{
                  "url":"assets/vip/privilege/VipMainView.swf",
                  "params":{"actTab":1}
               });
               break;
            case bg.baokanBtn:
               ApplicationFacade.getInstance().dispatch(EventConst.BOBSTATECLICK,{
                  "url":"assets/vip/VIPShiBao.swf",
                  "xCoord":0,
                  "yCoord":0
               });
               break;
            case bg.shopBtn:
               ApplicationFacade.getInstance().dispatch(EventConst.OPEN_MODULE,{
                  "url":"assets/vip/VIPShop.swf",
                  "xCoord":0,
                  "yCoord":0
               });
               break;
            case bg.weekBtn:
               ApplicationFacade.getInstance().dispatch(EventConst.OPEN_MODULE,{
                  "url":"assets/vip/privilege/VipMainView.swf",
                  "params":{"actTab":2}
               });
         }
      }
      
      private function checkSelect(evt:MouseEvent) : void
      {
         if(bg.checkClip.currentFrame == 1)
         {
            bg.checkClip.gotoAndStop(2);
         }
         else
         {
            bg.checkClip.gotoAndStop(1);
         }
      }
      
      private function closeView(evt:MouseEvent) : void
      {
         this.onRemoveFromStage(null);
      }
      
      override public function disport() : void
      {
         this.onRemoveFromStage(null);
      }
      
      private function onRemoveFromStage(evt:Event) : void
      {
         this.removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemoveFromStage);
         CacheUtil.deleteObject(VIPNoticeView);
         this.removeEvent();
         if(bg != null)
         {
            if(bg.checkClip.currentFrame == 1)
            {
               SocketManager.getGreenSocket().sendCmd(MsgDoc.OP_CLIENT_REMOVE_VIP_TIMEUP.send);
            }
         }
         super.disport();
      }
   }
}

