package com.game.modules.view.gameexchange
{
   import com.channel.Message;
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.locators.GameData;
   import com.game.util.CacheUtil;
   import com.game.util.HLoaderSprite;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class GameExchange extends HLoaderSprite
   {
      
      private var mc:MovieClip;
      
      public function GameExchange()
      {
         super();
         this.url = "assets/material/gameExchange.swf";
      }
      
      override public function setShow() : void
      {
         this.mc = this.bg;
         this.mc.cacheAsBitmap = true;
         this.addChild(this.mc);
         this.initEventListener();
      }
      
      private function initEventListener() : void
      {
         this.mc.inputTxt.restrict = "0-9";
         this.mc.inputTxt.text = "1";
         this.mc.copperAcountTxt.text = GameData.instance.playerData.coin + "";
         this.mc.inputTxt.addEventListener(Event.CHANGE,this.onCountChange);
         this.mc.leftBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.leftClick);
         this.mc.rightBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.rightClick);
         this.mc.okBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.startExchange);
         this.mc.cancelBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.cancelBtn);
         this.mc.closeBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.closeWindow);
         this.onCountChange(null);
      }
      
      private function cancelBtn(evt:MouseEvent) : void
      {
         this.closeWindow(null);
         new Message("onEnterGamehall",{
            "steerX":420,
            "steerY":255
         }).sendToChannel("itemclick");
      }
      
      private function onCountChange(evt:Event) : void
      {
         var myPattern:RegExp = null;
         if(Boolean(this.mc) && Boolean(this.mc.inputTxt))
         {
            myPattern = /([ \n\r]{1})/g;
            this.mc.inputTxt.text = this.mc.inputTxt.text.replace(myPattern,"");
            if(evt == null)
            {
               if(GameData.instance.playerData.coin >= 500)
               {
                  this.mc.inputTxt.text = "10";
               }
            }
         }
         if(int(this.mc.inputTxt.text) > 99)
         {
            this.mc.inputTxt.text = "99";
         }
         this.mc.needPayTxt.text = int(this.mc.inputTxt.text) * 50;
         this.mc.copperAcountTxt.text = GameData.instance.playerData.coin;
      }
      
      private function leftClick(evt:Event) : void
      {
         if(int(this.mc.inputTxt.text) > 0)
         {
            this.mc.inputTxt.text = int(this.mc.inputTxt.text) - 1 + "";
            this.mc.needPayTxt.text = int(this.mc.inputTxt.text) * 50;
            this.mc.copperAcountTxt.text = GameData.instance.playerData.coin;
         }
      }
      
      private function rightClick(evt:Event) : void
      {
         if(int(this.mc.inputTxt.text) < 99 && int(this.mc.copperAcountTxt.text) > 49)
         {
            this.mc.inputTxt.text = int(this.mc.inputTxt.text) + 1 + "";
            this.mc.needPayTxt.text = int(this.mc.inputTxt.text) * 50;
            this.mc.copperAcountTxt.text = GameData.instance.playerData.coin;
         }
      }
      
      private function startExchange(evt:Event) : void
      {
         var num:int = int(this.mc.inputTxt.text);
         ApplicationFacade.getInstance().dispatch(EventConst.BUYGOODS,{
            "id":100030,
            "count":num,
            "price":50
         });
      }
      
      private function closeWindow(evt:Event) : void
      {
         this.mc.inputTxt.text = 0 + "";
         this.mc.needPayTxt.text = "0";
         this.mc.copperAcountTxt.text = GameData.instance.playerData.coin + "";
         if(this.parent != null)
         {
            if(this.parent.contains(this))
            {
               this.parent.removeChild(this);
            }
         }
         this.disport();
      }
      
      override public function disport() : void
      {
         CacheUtil.deleteObject(GameExchange);
         this.graphics.clear();
         super.disport();
      }
   }
}

