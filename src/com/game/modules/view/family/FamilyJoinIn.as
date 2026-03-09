package com.game.modules.view.family
{
   import com.core.observer.MessageEvent;
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.locators.GameData;
   import com.game.manager.AlertManager;
   import com.game.manager.EventManager;
   import com.game.modules.control.family.FamilyControl;
   import com.game.util.CacheUtil;
   import com.game.util.HLoaderSprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class FamilyJoinIn extends HLoaderSprite
   {
      
      public function FamilyJoinIn()
      {
         super();
      }
      
      override public function initParams(params:Object = null) : void
      {
         this.url = "assets/family/familyJoinIn.swf";
         if(ApplicationFacade.getInstance().hasViewLogic(FamilyControl.NAME))
         {
            ApplicationFacade.getInstance().removeViewLogic(FamilyControl.NAME);
         }
         ApplicationFacade.getInstance().registerViewLogic(new FamilyControl(this));
      }
      
      override public function setShow() : void
      {
         this.bg.cacheAsBitmap = true;
         (bg["numberTxt"] as TextField).restrict = "0-9";
         EventManager.attachEvent(bg["closeBtn"],MouseEvent.CLICK,this.on_closeBtn);
         EventManager.attachEvent(bg["joinBtn1"],MouseEvent.CLICK,this.on_joinBtn1);
         EventManager.attachEvent(bg["joinBtn2"],MouseEvent.CLICK,this.on_joinBtn2);
         EventManager.attachEvent(bg["numberTxt"],MouseEvent.CLICK,this.on_numberTxt);
      }
      
      override public function disport() : void
      {
         CacheUtil.deleteObject(FamilyJoinIn);
         EventManager.removeEvent(bg["closeBtn"],MouseEvent.CLICK,this.on_closeBtn);
         EventManager.removeEvent(bg["joinBtn1"],MouseEvent.CLICK,this.on_joinBtn1);
         EventManager.removeEvent(bg["joinBtn2"],MouseEvent.CLICK,this.on_joinBtn2);
         EventManager.removeEvent(bg["numberTxt"],MouseEvent.CLICK,this.on_numberTxt);
         if(Boolean(this.parent) && this.parent.contains(this))
         {
            this.parent.removeChild(this);
         }
         super.disport();
      }
      
      private function on_closeBtn(evt:MouseEvent) : void
      {
         this.disport();
      }
      
      private function on_joinBtn1(evt:MouseEvent) : void
      {
         if(GameData.instance.playerData.family_id > 0)
         {
            AlertManager.instance.showTipAlert({
               "systemid":1065,
               "flag":8,
               "stage":this
            });
            this.disport();
            return;
         }
         if(bg["numberTxt"].text == "" || bg["numberTxt"].text == "请输入家族编号")
         {
            AlertManager.instance.showTipAlert({
               "systemid":1065,
               "flag":9,
               "stage":this
            });
            return;
         }
         var number:int = int(bg["numberTxt"].text);
         if(number <= 0)
         {
            AlertManager.instance.showTipAlert({
               "systemid":1065,
               "flag":10,
               "stage":this
            });
            return;
         }
         this.dispatchEvent(new MessageEvent(EventConst.REQ_JOININ_FAMILY,number));
         this.disport();
      }
      
      private function on_joinBtn2(evt:MouseEvent) : void
      {
         if(GameData.instance.playerData.family_id > 0)
         {
            AlertManager.instance.showTipAlert({
               "systemid":1065,
               "flag":8,
               "stage":this
            });
            this.disport();
            return;
         }
         this.dispatchEvent(new MessageEvent(EventConst.REQ_JOININ_FAMILY,0));
         this.disport();
      }
      
      private function on_numberTxt(evt:MouseEvent) : void
      {
         bg["numberTxt"].text = "";
         bg["numberTxt"].restrict = "0-9";
         EventManager.removeEvent(bg["numberTxt"],MouseEvent.CLICK,this.on_numberTxt);
      }
   }
}

