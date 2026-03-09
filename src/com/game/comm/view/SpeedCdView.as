package com.game.comm.view
{
   import com.game.comm.ActComponentUrl;
   import com.game.comm.control.SpeedCdControl;
   import com.game.comm.enum.AlertMessageConst;
   import com.game.comm.event.ActEvent;
   import com.game.comm.event.ActEventConst;
   import com.game.comm.manager.ActViewManager;
   import com.game.comm.model.ActComponentModel;
   import com.game.facade.ApplicationFacade;
   import com.game.modules.view.WindowLayer;
   import com.game.util.GameDynamicUI;
   import com.game.util.HLoaderSprite;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   
   public class SpeedCdView extends HLoaderSprite
   {
      
      private var _maxTime:int;
      
      private var _activeId:int;
      
      private var _otherFun:Function;
      
      public function SpeedCdView(activeId:int, restCdTime:int, otherFun:Function = null)
      {
         super();
         this._activeId = activeId;
         this._otherFun = otherFun;
         this._maxTime = Math.ceil(restCdTime / 60);
         GameDynamicUI.addUI(WindowLayer.instance,200,200,"loading");
         url = ActComponentUrl.SPEED_CD_VIEW;
      }
      
      override public function setShow() : void
      {
         GameDynamicUI.removeUI("loading");
         if(bg)
         {
            bg.timeTf.text = String(this._maxTime);
            bg.priceTf.text = String(this._maxTime);
            if(this._maxTime == 1)
            {
               this.disableBtn(bg.reduceBtn);
            }
            this.disableBtn(bg.addBtn);
            this.onRegister();
            this.initEvents();
         }
      }
      
      private function onRegister() : void
      {
         if(ApplicationFacade.getInstance().hasModel(ActComponentModel.NAME))
         {
            ApplicationFacade.getInstance().removeModel(ActComponentModel.NAME);
         }
         if(ApplicationFacade.getInstance().hasViewLogic(SpeedCdControl.NAME))
         {
            ApplicationFacade.getInstance().removeViewLogic(SpeedCdControl.NAME);
         }
         ApplicationFacade.getInstance().registerModel(new ActComponentModel());
         ApplicationFacade.getInstance().registerViewLogic(new SpeedCdControl(this));
      }
      
      private function onRemove() : void
      {
         ApplicationFacade.getInstance().removeModel(ActComponentModel.NAME);
         ApplicationFacade.getInstance().removeViewLogic(SpeedCdControl.NAME);
      }
      
      private function initEvents() : void
      {
         bg.reduceBtn.addEventListener(MouseEvent.CLICK,this.onReduce);
         bg.addBtn.addEventListener(MouseEvent.CLICK,this.onAdd);
         bg.okBtn.addEventListener(MouseEvent.CLICK,this.onSure);
         bg.cancelBtn.addEventListener(MouseEvent.CLICK,this.onClose);
         bg.closeBtn.addEventListener(MouseEvent.CLICK,this.onClose);
      }
      
      private function removeEvents() : void
      {
         bg.reduceBtn.removeEventListener(MouseEvent.CLICK,this.onReduce);
         bg.addBtn.removeEventListener(MouseEvent.CLICK,this.onAdd);
         bg.okBtn.removeEventListener(MouseEvent.CLICK,this.onSure);
         bg.cancelBtn.removeEventListener(MouseEvent.CLICK,this.onClose);
         bg.closeBtn.removeEventListener(MouseEvent.CLICK,this.onClose);
      }
      
      private function onReduce(evt:MouseEvent) : void
      {
         var n:int = int(bg.timeTf.text);
         if(n == 1)
         {
            return;
         }
         bg.timeTf.text = String(n - 1);
         bg.priceTf.text = String(n - 1);
         if(n == 2)
         {
            this.disableBtn(bg.reduceBtn);
         }
         if(n == this._maxTime)
         {
            this.enableBtn(bg.addBtn);
         }
      }
      
      private function onAdd(evt:MouseEvent) : void
      {
         var n:int = int(bg.timeTf.text);
         if(n >= this._maxTime)
         {
            return;
         }
         bg.timeTf.text = String(n + 1);
         bg.priceTf.text = String(n + 1);
         if(n + 1 == this._maxTime)
         {
            this.disableBtn(bg.addBtn);
         }
         if(n == 1)
         {
            this.enableBtn(bg.reduceBtn);
         }
      }
      
      private function onSure(evt:MouseEvent) : void
      {
         var params:Object = new Object();
         params.activeId = this._activeId;
         params.cdTime = int(bg.timeTf.text);
         if(this._otherFun != null)
         {
            this._otherFun.apply(null,[params]);
            this.onClose(null);
         }
         else
         {
            dispatchEvent(new ActEvent(ActEventConst.SPEED_CD,params));
         }
      }
      
      private function onClose(evt:MouseEvent) : void
      {
         this.disport();
      }
      
      private function disableBtn(btn:SimpleButton) : void
      {
         btn.enabled = false;
         btn.filters = [new ColorMatrixFilter([0.4,0.4,0.4,0,0,0.4,0.4,0.4,0,0,0.4,0.4,0.4,0,0,0,0,0,1,0])];
      }
      
      private function enableBtn(btn:SimpleButton) : void
      {
         btn.enabled = true;
         btn.filters = [];
      }
      
      override public function disport() : void
      {
         if(bg)
         {
            this.removeEvents();
         }
         this.onRemove();
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
         super.disport();
         ActViewManager.SPEED_CD_VIEW = 0;
         if(AlertMessageConst.DEFAULT_ACTID != 0)
         {
            AlertMessageConst.DEFAULT_ACTID = 0;
         }
         if(AlertMessageConst.SPEED_CD != 1)
         {
            AlertMessageConst.SPEED_CD = 1;
         }
      }
   }
}

