package com.game.modules.model.actUpdate.A700
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.locators.GameData;
   import org.green.server.events.MsgEvent;
   
   public class A784
   {
      
      private static var _ins:A784;
      
      private var _actPopFlag:Boolean;
      
      public function A784()
      {
         super();
      }
      
      public static function get ins() : A784
      {
         return _ins = _ins || new A784();
      }
      
      public function onAct784Update(evt:MsgEvent) : void
      {
         if(evt == null)
         {
            return;
         }
         evt.msg.body.position = 0;
         var oper:String = evt.msg.body.readUTF();
         var process_status:int = 0;
         switch(oper)
         {
            case "ui_info":
               process_status = evt.msg.body.readInt();
         }
         if(process_status <= 0 && !this._actPopFlag && GameData.instance.playerData.isNewHand >= 9)
         {
            ApplicationFacade.getInstance().dispatch(EventConst.BOBSTATECLICK,{"url":"assets/activity/djj2026/Act784/Act784Entrance.swf"});
         }
         this._actPopFlag = true;
      }
   }
}

