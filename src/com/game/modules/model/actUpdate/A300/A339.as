package com.game.modules.model.actUpdate.A300
{
   import com.core.observer.Dispatcher;
   import com.game.event.EventConst;
   import com.game.modules.vo.ActivityVo;
   import org.green.server.events.MsgEvent;
   
   public class A339
   {
      
      private static var _ins:A339;
      
      public function A339()
      {
         super();
      }
      
      public static function get ins() : A339
      {
         return _ins = _ins || new A339();
      }
      
      public function onEvoBattleBackHandler(vo:ActivityVo, evt:MsgEvent, dis:Dispatcher) : void
      {
         if(vo == null || evt == null)
         {
            return;
         }
         var valueobject:Object = {};
         if(vo.protocolID == 8)
         {
            valueobject.hurt = evt.msg.body.readInt();
            valueobject.score = evt.msg.body.readInt();
            valueobject.exp = evt.msg.body.readInt();
            valueobject.coin = evt.msg.body.readInt();
            dis.dispatch(EventConst.EVOLUTION_BATTLE_END,valueobject);
         }
      }
   }
}

