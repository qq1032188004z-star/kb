package com.game.comm.view
{
   import com.game.comm.*;
   import com.game.comm.manager.ActViewManager;
   import com.game.global.GlobalConfig;
   import com.game.locators.GameData;
   import com.game.util.OldBaseSprite;
   import flash.events.MouseEvent;
   import flash.external.ExternalInterface;
   
   public class NoKbCoinView extends OldBaseSprite
   {
      
      public function NoKbCoinView(callback:Function = null)
      {
         super();
         start(callback);
         setURL(ActComponentUrl.NO_KB_COIN_VIEW);
      }
      
      override protected function setShow() : void
      {
         if(Boolean(bg))
         {
            this.initEvents();
         }
      }
      
      private function initEvents() : void
      {
         bg.openRecharge.addEventListener(MouseEvent.CLICK,this.onRecharge);
         bg.closeBtn.addEventListener(MouseEvent.CLICK,this.onClose);
         bg.cancelBtn.addEventListener(MouseEvent.CLICK,this.onClose);
      }
      
      private function removeEvents() : void
      {
         bg.openRecharge.removeEventListener(MouseEvent.CLICK,this.onRecharge);
         bg.closeBtn.removeEventListener(MouseEvent.CLICK,this.onClose);
         bg.cancelBtn.removeEventListener(MouseEvent.CLICK,this.onClose);
      }
      
      private function onRecharge(evt:MouseEvent) : void
      {
         if(ExternalInterface.available)
         {
            ExternalInterface.call("webOpenCharge",10,GlobalConfig.czUserName,0,GameData.instance.playerData.userName);
         }
      }
      
      private function onClose(evt:MouseEvent) : void
      {
         this.disport();
      }
      
      override public function disport() : void
      {
         if(Boolean(bg))
         {
            this.removeEvents();
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
         ActViewManager.NO_KB_COIN_VIEW = 0;
         super.disport();
         if(_callback != null)
         {
            _callback();
         }
         _callback = null;
      }
   }
}

