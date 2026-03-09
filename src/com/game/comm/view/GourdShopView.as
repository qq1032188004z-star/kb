package com.game.comm.view
{
   import com.game.comm.ActComponentUrl;
   import com.game.comm.control.GourdShopControl;
   import com.game.comm.enum.AlertMessageConst;
   import com.game.comm.event.ActEvent;
   import com.game.comm.event.ActEventConst;
   import com.game.comm.manager.ActViewManager;
   import com.game.comm.model.ActComponentModel;
   import com.game.facade.ApplicationFacade;
   import com.game.modules.view.WindowLayer;
   import com.game.util.GameDynamicUI;
   import com.game.util.HLoaderSprite;
   import com.publiccomponent.URLUtil;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.text.TextField;
   import flash.utils.getTimer;
   
   public class GourdShopView extends HLoaderSprite
   {
      
      private const PRICE1:int = 100;
      
      private const PRICE2:int = 200;
      
      private const PRICE3:int = 10;
      
      private var _activeId:int;
      
      private var _otherFun:Function;
      
      private var _startTime:int;
      
      public function GourdShopView(activeId:int, otherFun:Function = null)
      {
         super();
         this._activeId = activeId;
         this._otherFun = otherFun;
         GameDynamicUI.addUI(WindowLayer.instance,200,200,"loading");
         url = URLUtil.getSvnVer(ActComponentUrl.GOURD_SHOP_VIEW);
      }
      
      override public function setShow() : void
      {
         var i:int = 0;
         GameDynamicUI.removeUI("loading");
         if(bg)
         {
            for(i = 1; i <= 3; i++)
            {
               this.buttonCannotClick(bg["reduceBtn" + i]);
            }
            this.initEvents();
            this.onRegister();
         }
      }
      
      private function onRegister() : void
      {
         if(ApplicationFacade.getInstance().hasModel(ActComponentModel.NAME))
         {
            ApplicationFacade.getInstance().removeModel(ActComponentModel.NAME);
         }
         if(ApplicationFacade.getInstance().hasViewLogic(GourdShopControl.NAME))
         {
            ApplicationFacade.getInstance().removeViewLogic(GourdShopControl.NAME);
         }
         ApplicationFacade.getInstance().registerModel(new ActComponentModel(this._otherFun == null));
         ApplicationFacade.getInstance().registerViewLogic(new GourdShopControl(this));
      }
      
      private function onRemove() : void
      {
         ApplicationFacade.getInstance().removeModel(ActComponentModel.NAME);
         ApplicationFacade.getInstance().removeViewLogic(GourdShopControl.NAME);
      }
      
      private function initEvents() : void
      {
         bg.closeBtn.addEventListener(MouseEvent.CLICK,this.onClose);
         for(var i:int = 1; i <= 3; i++)
         {
            bg["buyBtn" + i].addEventListener(MouseEvent.CLICK,this.onBuy);
            bg["addBtn" + i].addEventListener(MouseEvent.CLICK,this.onAdd);
            bg["reduceBtn" + i].addEventListener(MouseEvent.CLICK,this.onReduce);
            bg["numTf" + i].addEventListener(Event.CHANGE,this.onChangeNum);
         }
      }
      
      private function removeEvents() : void
      {
         bg.closeBtn.removeEventListener(MouseEvent.CLICK,this.onClose);
         for(var i:int = 1; i <= 3; i++)
         {
            bg["buyBtn" + i].removeEventListener(MouseEvent.CLICK,this.onBuy);
            bg["addBtn" + i].removeEventListener(MouseEvent.CLICK,this.onAdd);
            bg["reduceBtn" + i].removeEventListener(MouseEvent.CLICK,this.onReduce);
            bg["numTf" + i].removeEventListener(Event.CHANGE,this.onChangeNum);
         }
      }
      
      private function onBuy(evt:MouseEvent) : void
      {
         if(getTimer() - this._startTime < 1000)
         {
            return;
         }
         this._startTime = getTimer();
         var index:int = int(evt.currentTarget.name.substr(6,1));
         var tf:TextField = bg["numTf" + index] as TextField;
         if(this._otherFun != null)
         {
            this._otherFun.apply(null,[{
               "activeId":this._activeId,
               "type":index,
               "num":int(tf.text)
            }]);
         }
         else
         {
            dispatchEvent(new ActEvent(ActEventConst.BUY_GOURD,{
               "activeId":this._activeId,
               "type":index,
               "num":int(tf.text)
            }));
         }
      }
      
      private function onAdd(evt:MouseEvent) : void
      {
         var index:String = evt.currentTarget.name.substr(6,1);
         var tf:TextField = bg["numTf" + index] as TextField;
         if(tf.text == "99")
         {
            return;
         }
         tf.text = String(int(tf.text) + 1);
         this.numTfChanged(tf);
      }
      
      private function onReduce(evt:MouseEvent) : void
      {
         var index:String = evt.currentTarget.name.substr(9,1);
         var tf:TextField = bg["numTf" + index] as TextField;
         if(tf.text == "1")
         {
            return;
         }
         tf.text = String(int(tf.text) - 1);
         this.numTfChanged(tf);
      }
      
      private function onChangeNum(evt:Event) : void
      {
         var tf:TextField = evt.currentTarget as TextField;
         this.numTfChanged(tf);
      }
      
      private function numTfChanged(tf:TextField) : void
      {
         var index:int = int(tf.name.substr(5,1));
         var priceTf:TextField = bg["priceTf" + index] as TextField;
         if(int(tf.text) >= 99)
         {
            tf.text = "99";
            this.buttonCannotClick(bg["addBtn" + index]);
         }
         else if(int(tf.text) <= 1)
         {
            tf.text = "1";
            this.buttonCannotClick(bg["reduceBtn" + index]);
         }
         else
         {
            this.buttonCanClick(bg["addBtn" + index]);
            this.buttonCanClick(bg["reduceBtn" + index]);
         }
         priceTf.text = String(int(tf.text) * this["PRICE" + index]);
      }
      
      private function buttonCannotClick(btn:SimpleButton) : void
      {
         btn.enabled = false;
         btn.filters = [new ColorMatrixFilter([0.4,0.4,0.4,0,0,0.4,0.4,0.4,0,0,0.4,0.4,0.4,0,0,0,0,0,1,0])];
      }
      
      private function buttonCanClick(btn:SimpleButton) : void
      {
         btn.enabled = true;
         btn.filters = [];
      }
      
      private function onClose(evt:MouseEvent) : void
      {
         this.disport();
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
         ActViewManager.GOURD_SHOP_VIEW = 0;
         if(AlertMessageConst.DEFAULT_ACTID != 0)
         {
            AlertMessageConst.DEFAULT_ACTID = 0;
         }
         if(AlertMessageConst.BUY_GOURD != 2)
         {
            AlertMessageConst.BUY_GOURD = 2;
         }
      }
   }
}

