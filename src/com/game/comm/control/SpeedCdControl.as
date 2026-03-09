package com.game.comm.control
{
   import com.core.observer.MessageEvent;
   import com.core.view.ViewConLogic;
   import com.game.comm.enum.AlertMessageConst;
   import com.game.comm.event.ActEvent;
   import com.game.comm.event.ActEventConst;
   import com.game.comm.view.SpeedCdView;
   
   public class SpeedCdControl extends ViewConLogic
   {
      
      public static const NAME:String = "actComponent_speed_cd_controller";
      
      public function SpeedCdControl(viewComponent:Object = null)
      {
         super(NAME,viewComponent);
      }
      
      override public function listEvents() : Array
      {
         return [[ActEventConst.SPEED_CD_BACK,this.onSpeedCdBack]];
      }
      
      override public function onRegister() : void
      {
         this.view.addEventListener(ActEventConst.SPEED_CD,this.onSpeedCd);
      }
      
      override public function onRemove() : void
      {
         this.view.addEventListener(ActEventConst.SPEED_CD,this.onSpeedCd);
      }
      
      private function onSpeedCd(evt:ActEvent) : void
      {
         if(AlertMessageConst.DEFAULT_ACTID != 0)
         {
            sendMessage(AlertMessageConst.ACTIVE_COMPONENT.send,AlertMessageConst.DEFAULT_ACTID,[AlertMessageConst.SPEED_CD,evt.data.activeId,evt.data.cdTime]);
         }
         else
         {
            sendMessage(AlertMessageConst.ACTIVE_COMPONENT.send,AlertMessageConst.MPARAMS,[AlertMessageConst.SPEED_CD,evt.data.activeId,evt.data.cdTime]);
         }
      }
      
      private function onSpeedCdBack(evt:MessageEvent) : void
      {
         this.view.disport();
      }
      
      private function get view() : SpeedCdView
      {
         return viewComponent as SpeedCdView;
      }
   }
}

