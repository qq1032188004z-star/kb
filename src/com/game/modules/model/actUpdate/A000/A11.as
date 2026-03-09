package com.game.modules.model.actUpdate.A000
{
   import com.game.modules.parse.BobAwardParse;
   import com.game.modules.view.task.activation.AwardBox;
   import com.game.modules.vo.ActivityVo;
   import com.game.util.CacheUtil;
   import org.green.server.events.MsgEvent;
   
   public class A11
   {
      
      private static var _ins:A11;
      
      public function A11()
      {
         super();
      }
      
      public static function get ins() : A11
      {
         return _ins = _ins || new A11();
      }
      
      public function update(vo:ActivityVo, evt:MsgEvent) : void
      {
         var view:AwardBox = null;
         if(vo.protocolID == 1)
         {
            vo.valueobject.loginDays = evt.msg.body.readInt();
            vo.valueobject.d1 = evt.msg.body.readInt();
            vo.valueobject.d2 = evt.msg.body.readInt();
            vo.valueobject.d3 = evt.msg.body.readInt();
            vo.valueobject.d4 = evt.msg.body.readInt();
            vo.valueobject.d5 = evt.msg.body.readInt();
            vo.valueobject.d6 = evt.msg.body.readInt();
            vo.valueobject.d7 = evt.msg.body.readInt();
            view = CacheUtil.pool[AwardBox];
            if(Boolean(view))
            {
               view.on7daysBack(vo);
            }
         }
         else if(vo.protocolID == 2)
         {
            vo.valueobject.rewardLevel = evt.msg.body.readInt();
            vo.valueobject.result = evt.msg.body.readInt();
            if(vo.valueobject.result == 0)
            {
               evt.msg.mParams = 999;
               new BobAwardParse().parse(evt.msg);
            }
            view = CacheUtil.pool[AwardBox];
            if(Boolean(view))
            {
               view.onlinqu7daysBack(vo);
            }
         }
      }
   }
}

