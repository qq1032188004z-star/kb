package com.game.modules.view.family
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.locators.GameData;
   import com.game.manager.AlertManager;
   import com.game.util.CacheUtil;
   import com.game.util.HLoaderSprite;
   import com.publiccomponent.loading.GreenLoading;
   import flash.events.MouseEvent;
   
   public class FamilyCheckIn extends HLoaderSprite
   {
      
      private var flag:Boolean = false;
      
      private const Level:Array = ["游民","族长","副族长","护法","精英","族员"];
      
      public function FamilyCheckIn()
      {
         GreenLoading.loading.visible = true;
         super();
      }
      
      override public function initParams(params:Object = null) : void
      {
         this.url = "assets/family/familyCheckin.swf";
      }
      
      override public function setShow() : void
      {
         var date:Date = new Date();
         this.bg.cacheAsBitmap = true;
         this.bg.getmc.visible = false;
         this.bg.lookBtn.visible = false;
         this.bg.lookBtn.mouseEnabled = false;
         this.bg.movie.visible = false;
         this.bg.movie.gotoAndStop(1);
         this.bg.nameTxt.text = GameData.instance.playerData.userName;
         this.bg.levelTxt.text = this.Level[GameData.instance.playerData.family_level];
         this.bg.timeTxt.text = date.fullYear + "年" + (date.month + 1) + "月" + date.date + "日";
         this.bg.closeBtn.addEventListener(MouseEvent.CLICK,this.on_closeBtn);
         this.bg.checkinBtn.addEventListener(MouseEvent.CLICK,this.on_checkinBtn);
         this.bg.lookBtn.addEventListener(MouseEvent.CLICK,this.on_lookBtn);
         this.flag = Boolean(GameData.instance.playerData.family_base_id == GameData.instance.playerData.family_id);
         this.bg.lookBtn.visible = this.flag;
         this.bg.lookBtn.mouseEnabled = this.flag;
         GreenLoading.loading.visible = false;
      }
      
      private function on_closeBtn(evt:MouseEvent) : void
      {
         this.disport();
      }
      
      private function on_checkinBtn(evt:MouseEvent) : void
      {
         if(GameData.instance.playerData.family_id > 0)
         {
            ApplicationFacade.getInstance().dispatch(EventConst.REQ_FAMILY_CHECK_IN);
         }
         else
         {
            AlertManager.instance.showTipAlert({
               "systemid":1065,
               "flag":3,
               "stage":this.parent
            });
            this.disport();
         }
      }
      
      public function onChecking() : void
      {
         this.bg.movie.visible = true;
         this.bg.movie.play();
         this.bg.movie.addFrameScript(this.bg.movie.totalFrames - 1,this.onChecked);
      }
      
      private function onChecked() : void
      {
         this.bg.movie.visible = false;
         this.bg.movie.gotoAndStop(1);
         this.bg.getmc.visible = true;
      }
      
      private function on_lookBtn(evt:MouseEvent) : void
      {
         if(this.flag)
         {
            ApplicationFacade.getInstance().dispatch(EventConst.REQ_FAMILY_CHECK_LIST);
         }
      }
      
      override public function disport() : void
      {
         CacheUtil.deleteObject(FamilyCheckIn);
         this.bg.closeBtn.removeEventListener(MouseEvent.CLICK,this.on_closeBtn);
         this.bg.checkinBtn.removeEventListener(MouseEvent.CLICK,this.on_checkinBtn);
         this.bg.lookBtn.removeEventListener(MouseEvent.CLICK,this.on_lookBtn);
         this.parent.removeChild(this);
         super.disport();
      }
   }
}

