package com.game.modules.model.actUpdate.A100
{
   import com.core.observer.Dispatcher;
   import com.game.event.EventConst;
   import com.game.modules.vo.ActivityVo;
   import com.game.modules.vo.BossRemarkData;
   import org.green.server.events.MsgEvent;
   
   public class A195
   {
      
      private static var _ins:A195;
      
      public function A195()
      {
         super();
      }
      
      public static function get ins() : A195
      {
         return _ins = _ins || new A195();
      }
      
      public function onBossRemarkHandler(vo:ActivityVo, evt:MsgEvent, dis:Dispatcher) : void
      {
         var mbody:Object = null;
         if(vo == null || evt == null)
         {
            return;
         }
         switch(vo.protocolID)
         {
            case 1:
               mbody = {};
               mbody.open = evt.msg.body.readInt();
               mbody.bossId = evt.msg.body.readInt();
               mbody.initBossHp = evt.msg.body.readInt();
               mbody.bossHp = evt.msg.body.readInt();
               mbody.m_bossElem = evt.msg.body.readInt();
               mbody.hurtValue = evt.msg.body.readInt();
               BossRemarkData.instance.open = mbody.open;
               BossRemarkData.instance.bossId = mbody.bossId;
               BossRemarkData.instance.bossHp = mbody.bossHp;
               BossRemarkData.instance.initBossHp = mbody.initBossHp;
               dis.dispatch(EventConst.BOSSREMARK_NOTIFY_INFO,mbody);
               break;
            case 2:
            case 4:
         }
      }
   }
}

