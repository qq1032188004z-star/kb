package com.game.modules.control.ToolSynthesis
{
   import com.core.view.ViewConLogic;
   import com.game.event.EventConst;
   import com.game.global.GlobalConfig;
   import com.game.locators.GameData;
   import com.game.modules.view.HomeMessageTipView;
   import flash.events.Event;
   
   public class HomeMessageTipControl extends ViewConLogic
   {
      
      public static const NAME:String = "homemessagetipcontrol";
      
      public function HomeMessageTipControl(viewComponent:Object = null)
      {
         super(NAME,viewComponent);
         this.view.addEventListener(HomeMessageTipView.enterHome,this.enterhome);
      }
      
      override public function listEvents() : Array
      {
         return [];
      }
      
      private function enterhome(event:Event) : void
      {
         this.view.removeEventListener(HomeMessageTipView.enterHome,this.enterhome);
         dispatch(EventConst.REQ_ENTER_ROOM,{
            "userId":GlobalConfig.userId,
            "userName":GameData.instance.playerData.userName,
            "houseId":GlobalConfig.userId
         });
         this.view.disport();
      }
      
      public function get view() : HomeMessageTipView
      {
         return this.getViewComponent() as HomeMessageTipView;
      }
   }
}

