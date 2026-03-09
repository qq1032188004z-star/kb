package com.game.modules.model.actUpdate.A000
{
   import com.game.modules.vo.ActivityVo;
   import org.green.server.events.MsgEvent;
   
   public class A38
   {
      
      private static var _ins:A38;
      
      public function A38()
      {
         super();
      }
      
      public static function get ins() : A38
      {
         return _ins = _ins || new A38();
      }
      
      public function onRegressionActivityHandler(evt:MsgEvent) : ActivityVo
      {
         var protocolId:int = 0;
         var vo:ActivityVo = new ActivityVo();
         vo.head = evt.msg.mParams;
         if(evt.msg.body != null)
         {
            evt.msg.body.position = 0;
            protocolId = evt.msg.body.readInt();
            vo.protocolID = protocolId;
            switch(protocolId)
            {
               case 1:
                  vo.valueobject.award1 = evt.msg.body.readInt();
                  vo.valueobject.award2 = evt.msg.body.readInt();
                  vo.valueobject.award3 = evt.msg.body.readInt();
                  vo.valueobject.callTime = evt.msg.body.readInt();
                  vo.valueobject.flag = evt.msg.body.readInt();
                  break;
               case 2:
                  vo.valueobject.result = evt.msg.body.readInt();
                  break;
               case 3:
                  vo.valueobject.result = evt.msg.body.readInt();
                  vo.valueobject.id = evt.msg.body.readInt();
                  break;
               case 4:
                  vo.valueobject.result = evt.msg.body.readInt();
                  break;
               case 5:
                  vo.valueobject.result = evt.msg.body.readInt();
                  break;
               case 6:
                  vo.valueobject.result = evt.msg.body.readInt();
            }
         }
         return vo;
      }
   }
}

