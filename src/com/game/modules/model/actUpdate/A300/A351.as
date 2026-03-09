package com.game.modules.model.actUpdate.A300
{
   import com.game.modules.view.FaceView;
   import com.game.modules.vo.ActivityVo;
   import org.green.server.events.MsgEvent;
   
   public class A351
   {
      
      private static var _ins:A351;
      
      public function A351()
      {
         super();
      }
      
      public static function get ins() : A351
      {
         return _ins = _ins || new A351();
      }
      
      public function onAct351Update(vo:ActivityVo, evt:MsgEvent) : void
      {
         if(vo == null || evt == null)
         {
            return;
         }
         switch(vo.protocolID)
         {
            case 1:
               if(evt.msg.body.readInt() == 1)
               {
                  FaceView.clip.topClip.hideBtnByName("peerlessBtn");
               }
         }
      }
   }
}

