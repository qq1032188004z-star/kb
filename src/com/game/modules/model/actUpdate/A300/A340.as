package com.game.modules.model.actUpdate.A300
{
   import com.game.modules.vo.ActivityVo;
   import org.green.server.events.MsgEvent;
   
   public class A340
   {
      
      private static var _ins:A340;
      
      public function A340()
      {
         super();
      }
      
      public static function get ins() : A340
      {
         return _ins = _ins || new A340();
      }
      
      public function onSignIn340Handler(vo:ActivityVo, evt:MsgEvent) : void
      {
         if(vo == null || evt == null)
         {
            return;
         }
         var valueobject:Object = {};
         switch(vo.protocolID)
         {
            case 1:
               valueobject.passday = evt.msg.body.readInt();
               valueobject.flag = evt.msg.body.readInt();
               valueobject.registerDay = evt.msg.body.readInt();
               break;
            case 2:
               valueobject.result = evt.msg.body.readInt();
               valueobject.registerDay = evt.msg.body.readInt();
               break;
            case 3:
               valueobject.result = evt.msg.body.readInt();
               valueobject.registerDay = evt.msg.body.readInt();
         }
      }
   }
}

