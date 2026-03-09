package com.game.comm.control
{
   import com.core.view.ViewConLogic;
   import com.game.comm.enum.AlertMessageConst;
   import com.game.comm.event.ActEvent;
   import com.game.comm.event.ActEventConst;
   import com.game.comm.view.GourdShopView;
   
   public class GourdShopControl extends ViewConLogic
   {
      
      public static const NAME:String = "actComponent_gourd_shop_control";
      
      public function GourdShopControl(viewComponent:Object = null)
      {
         super(NAME,viewComponent);
      }
      
      override public function onRegister() : void
      {
         this.view.addEventListener(ActEventConst.BUY_GOURD,this.onBuyGourd);
      }
      
      override public function onRemove() : void
      {
         this.view.removeEventListener(ActEventConst.BUY_GOURD,this.onBuyGourd);
      }
      
      private function onBuyGourd(evt:ActEvent) : void
      {
         if(AlertMessageConst.DEFAULT_ACTID != 0)
         {
            sendMessage(AlertMessageConst.ACTIVE_COMPONENT.send,AlertMessageConst.DEFAULT_ACTID,[AlertMessageConst.BUY_GOURD,AlertMessageConst.MPARAMS,evt.data.type,evt.data.num]);
         }
         else
         {
            sendMessage(AlertMessageConst.ACTIVE_COMPONENT.send,AlertMessageConst.MPARAMS,[AlertMessageConst.BUY_GOURD,evt.data.type,evt.data.num]);
         }
      }
      
      private function get view() : GourdShopView
      {
         return viewComponent as GourdShopView;
      }
   }
}

