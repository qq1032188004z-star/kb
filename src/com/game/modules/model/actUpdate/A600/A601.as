package com.game.modules.model.actUpdate.A600
{
   import com.core.observer.Dispatcher;
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.global.GlobalConfig;
   import com.game.modules.view.FaceView;
   import org.green.server.events.MsgEvent;
   
   public class A601
   {
      
      private static var _ins:A601;
      
      public function A601()
      {
         super();
      }
      
      public static function get ins() : A601
      {
         return _ins = _ins || new A601();
      }
      
      public function onAct601Update(evt:MsgEvent, dis:Dispatcher) : void
      {
         var flag:int = 0;
         var result:int = 0;
         if(evt == null)
         {
            return;
         }
         evt.msg.body.position = 0;
         var oper:String = evt.msg.body.readUTF();
         switch(oper)
         {
            case "open_ui":
               flag = evt.msg.body.readInt();
               if(flag == 1)
               {
                  FaceView.clip.topClip.hideBtnByName("yearVipMc");
               }
               break;
            case "reward":
               flag = evt.msg.body.readInt();
               if(flag == 0)
               {
                  FaceView.clip.topClip.hideBtnByName("yearVipMc");
               }
               break;
            case "super_vip":
               result = evt.msg.body.readInt();
               if(result == GlobalConfig.currVipYear)
               {
                  ApplicationFacade.getInstance().dispatch(EventConst.OPEN_MODULE,{"url":"assets/vip/privilege/BecomeSuperVip.swf"});
                  dis.dispatch(EventConst.S_VIP_LEVEL_UP_TO_SUPER);
               }
         }
      }
   }
}

