package com.game.modules.model.actUpdate.A600
{
   import com.game.locators.MsgDoc;
   import com.game.modules.view.FaceView;
   import org.green.server.core.GreenSocket;
   import org.green.server.events.MsgEvent;
   
   public class A604
   {
      
      private static var _ins:A604;
      
      public function A604()
      {
         super();
      }
      
      public static function get ins() : A604
      {
         return _ins = _ins || new A604();
      }
      
      public function onAct604Update(evt:MsgEvent, con:GreenSocket) : void
      {
         var result:int = 0;
         var num:int = 0;
         var updateFlag:int = 0;
         var len:int = 0;
         var hasAllReward:Boolean = false;
         var flag:int = 0;
         var i:int = 0;
         if(evt == null)
         {
            return;
         }
         evt.msg.body.position = 0;
         var oper:String = evt.msg.body.readUTF();
         switch(oper)
         {
            case "ui_info":
               num = evt.msg.body.readInt();
               updateFlag = evt.msg.body.readInt();
               len = evt.msg.body.readInt();
               hasAllReward = true;
               for(i = 0; i < len; i++)
               {
                  flag = evt.msg.body.readInt();
                  if(flag != 1)
                  {
                     hasAllReward = false;
                     break;
                  }
               }
               if(hasAllReward)
               {
                  FaceView.clip.topClip.hideBtnByName("shopRechargeBtn");
               }
               break;
            case "receive_reward":
               result = evt.msg.body.readInt();
               if(result == 0)
               {
                  con.sendCmd(MsgDoc.OP_CLIENT_ACTIVITY_QINGYANG_NEW.send,604,["ui_info"]);
               }
         }
      }
   }
}

