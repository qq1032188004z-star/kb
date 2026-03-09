package com.game.modules.view
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.manager.AlertManager;
   import com.game.manager.EventManager;
   import com.game.util.CacheUtil;
   import com.game.util.ColorUtil;
   import com.game.util.HLoaderSprite;
   import flash.events.MouseEvent;
   
   public class WeedkendAward extends HLoaderSprite
   {
      
      private var index:int = 0;
      
      private var getAwardFlag:Boolean = false;
      
      public function WeedkendAward()
      {
         super();
         this.url = "assets/material/weedkend_award.swf";
      }
      
      override public function setShow() : void
      {
         bg.cacheAsBitmap = true;
         bg.boxmc0.gotoAndStop(1);
         bg.boxmc1.gotoAndStop(37);
         bg.boxmc2.gotoAndStop(73);
         bg.btn1.gotoAndStop(1);
         EventManager.attachEvent(bg.box0,MouseEvent.CLICK,this.onbox0);
         EventManager.attachEvent(bg.box1,MouseEvent.CLICK,this.onbox1);
         EventManager.attachEvent(bg.box2,MouseEvent.CLICK,this.onbox2);
         EventManager.attachEvent(bg.btn0,MouseEvent.CLICK,this.onbtn0);
         EventManager.attachEvent(bg.btn1,MouseEvent.CLICK,this.onbtn1);
      }
      
      private function onbox0(evt:MouseEvent) : void
      {
         this.index = 0;
         this.getAwardHandler();
      }
      
      private function onbox1(evt:MouseEvent) : void
      {
         this.index = 1;
         this.getAwardHandler();
      }
      
      private function onbox2(evt:MouseEvent) : void
      {
         this.index = 2;
         this.getAwardHandler();
      }
      
      private function onbtn0(evt:MouseEvent) : void
      {
         this.disport();
      }
      
      private function onbtn1(evt:MouseEvent) : void
      {
         if(bg.btn1.currentFrame == 2)
         {
            this.disport();
         }
         else if(Boolean(bg.box1.visible))
         {
            this.index = int(Math.random() * 3);
            this.getAwardHandler();
         }
      }
      
      private function getAwardHandler() : void
      {
         bg.box0.visible = false;
         bg.box1.visible = false;
         bg.box2.visible = false;
         bg.boxmc0.addFrameScript(36,this.getAward);
         bg.boxmc0.gotoAndPlay(1);
         bg.boxmc1.gotoAndPlay(37);
         bg.boxmc2.gotoAndPlay(73);
      }
      
      private function getAward() : void
      {
         bg.boxmc0.addFrameScript(36,null);
         ApplicationFacade.getInstance().dispatch(EventConst.GET_WEEDKEND_AWARD,2);
      }
      
      override public function disport() : void
      {
         if(!bg)
         {
            return;
         }
         if(bg.btn1.currentFrame == 2)
         {
            this.showGetAwards();
         }
         CacheUtil.deleteObject(WeedkendAward);
         EventManager.removeEvent(bg.box0,MouseEvent.CLICK,this.onbox0);
         EventManager.removeEvent(bg.box1,MouseEvent.CLICK,this.onbox1);
         EventManager.removeEvent(bg.box2,MouseEvent.CLICK,this.onbox2);
         EventManager.removeEvent(bg.btn0,MouseEvent.CLICK,this.onbtn0);
         EventManager.removeEvent(bg.btn1,MouseEvent.CLICK,this.onbtn1);
         super.disport();
      }
      
      public function getAwardBack(i:int, j:int) : void
      {
         var list:Array = [[12,24,36],[48,60,72],[84,96,108]];
         bg["boxmc" + this.index].gotoAndStop(list[i][j]);
         bg["boxmc" + (this.index + 1) % 3].gotoAndStop(list[i][(j + 1) % 3]);
         bg["boxmc" + (this.index + 2) % 3].gotoAndStop(list[i][(j + 2) % 3]);
         bg["boxmc" + (this.index + 1) % 3].filters = ColorUtil.getColorMatrixFilterGray();
         bg["boxmc" + (this.index + 2) % 3].filters = ColorUtil.getColorMatrixFilterGray();
         bg.btn1.gotoAndStop(2);
      }
      
      private function showGetAwards() : void
      {
         var frame:int = int(bg["boxmc" + this.index].currentFrame);
         if(frame == 12)
         {
            AlertManager.instance.showAwardAlertList([{"toolid":100002},{"toolid":100007},{"money":500}]);
         }
         else if(frame == 24)
         {
            AlertManager.instance.showAwardAlertList([{"toolid":800055},{"toolid":100002},{"toolid":100006},{"money":900}]);
         }
         else if(frame == 36)
         {
            AlertManager.instance.showAwardAlertList([{"toolid":800054},{"toolid":100002},{"toolid":100006},{"money":1500}]);
         }
         else if(frame == 48)
         {
            AlertManager.instance.showAwardAlertList([{"toolid":100001},{"toolid":100007},{"money":350}]);
         }
         else if(frame == 60)
         {
            AlertManager.instance.showAwardAlertList([{"toolid":800055},{"toolid":100002},{"toolid":100006},{"money":700}]);
         }
         else if(frame == 72)
         {
            AlertManager.instance.showAwardAlertList([{"toolid":800054},{"toolid":100002},{"toolid":100006},{"money":1200}]);
         }
         else if(frame == 84)
         {
            AlertManager.instance.showAwardAlertList([{"toolid":100001},{"toolid":100007},{"money":300}]);
         }
         else if(frame == 96)
         {
            AlertManager.instance.showAwardAlertList([{"toolid":800055},{"toolid":100001},{"toolid":100007},{"money":500}]);
         }
         else if(frame == 108)
         {
            AlertManager.instance.showAwardAlertList([{"toolid":800054},{"toolid":100001},{"toolid":100007},{"money":1000}]);
         }
      }
   }
}

