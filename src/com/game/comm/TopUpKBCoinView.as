package com.game.comm
{
   import com.game.locators.CacheData;
   import com.game.util.HLoaderSprite;
   import flash.events.MouseEvent;
   import flash.system.System;
   
   public class TopUpKBCoinView extends HLoaderSprite
   {
      
      public function TopUpKBCoinView()
      {
         super();
         this.url = "assets/mall/mall_alert_1.swf";
      }
      
      override public function setShow() : void
      {
         bg.cacheAsBitmap = true;
         bg.btn0.addEventListener(MouseEvent.CLICK,this.btn0Handler);
         bg.btn1.addEventListener(MouseEvent.CLICK,this.btn1Handler);
         bg.txt0.text = CacheData.instance.payUrl;
      }
      
      private function btn0Handler(evt:MouseEvent) : void
      {
         this.disport();
      }
      
      private function btn1Handler(evt:MouseEvent) : void
      {
         System.setClipboard(CacheData.instance.payUrl);
         this.disport();
      }
      
      override public function disport() : void
      {
         if(bg)
         {
            bg.btn0.removeEventListener(MouseEvent.CLICK,this.btn0Handler);
            bg.btn1.removeEventListener(MouseEvent.CLICK,this.btn1Handler);
         }
         super.disport();
      }
   }
}

