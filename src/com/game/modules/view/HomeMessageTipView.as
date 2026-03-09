package com.game.modules.view
{
   import com.game.facade.ApplicationFacade;
   import com.game.locators.GameData;
   import com.game.modules.control.ToolSynthesis.HomeMessageTipControl;
   import com.game.util.CacheUtil;
   import com.game.util.HLoaderSprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class HomeMessageTipView extends HLoaderSprite
   {
      
      public static const enterHome:String = "enterhome";
      
      public function HomeMessageTipView()
      {
         super();
         this.url = "assets/homemessage/homemessagetip.swf";
      }
      
      override public function initParams(params:Object = null) : void
      {
      }
      
      override public function setShow() : void
      {
         this.bg.cacheAsBitmap = true;
         this.initEvents();
         this.bg.txt1.text = "亲爱的" + GameData.instance.playerData.userName + ":";
         this.bg.txt2.text = "你的留言板上有新留言哦，快回去看看吧！";
         ApplicationFacade.getInstance().registerViewLogic(new HomeMessageTipControl(this));
      }
      
      private function initEvents() : void
      {
         bg.closebtn.addEventListener(MouseEvent.CLICK,this.onClose);
         bg.cancelbtn.addEventListener(MouseEvent.CLICK,this.onClose);
         bg.gohomebtn.addEventListener(MouseEvent.CLICK,this.onGohome);
      }
      
      private function removeEvents() : void
      {
         bg.closebtn.removeEventListener(MouseEvent.CLICK,this.onClose);
         bg.cancelbtn.removeEventListener(MouseEvent.CLICK,this.onClose);
         bg.gohomebtn.removeEventListener(MouseEvent.CLICK,this.onGohome);
      }
      
      private function onGohome(evt:MouseEvent) : void
      {
         this.dispatchEvent(new Event(enterHome));
      }
      
      private function onClose(evt:MouseEvent) : void
      {
         this.disport();
      }
      
      override public function disport() : void
      {
         CacheUtil.deleteObject(HomeMessageTipView);
         ApplicationFacade.getInstance().removeViewLogic(HomeMessageTipControl.NAME);
         this.removeEvents();
         super.disport();
      }
   }
}

