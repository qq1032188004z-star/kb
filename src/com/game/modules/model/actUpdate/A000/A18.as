package com.game.modules.model.actUpdate.A000
{
   import com.game.modules.vo.ActivityVo;
   import org.green.server.events.MsgEvent;
   
   public class A18
   {
      
      private static var _ins:A18;
      
      public function A18()
      {
         super();
      }
      
      public static function get ins() : A18
      {
         return _ins = _ins || new A18();
      }
      
      public function onShenDanHandler(vo:ActivityVo, evt:MsgEvent) : void
      {
         if(vo == null || evt == null)
         {
            return;
         }
         var valueobject:Object = {};
         switch(vo.protocolID)
         {
            case 1:
               valueobject.xinZhang = evt.msg.body.readInt();
               vo.valueobject = valueobject;
               break;
            case 2:
               valueobject.time = evt.msg.body.readInt();
               valueobject.flag = evt.msg.body.readInt();
               if(valueobject.flag == 2)
               {
                  valueobject.hp = evt.msg.body.readInt();
               }
               else if(valueobject.flag == 1)
               {
                  valueobject.gift = evt.msg.body.readInt();
                  valueobject.gift2 = evt.msg.body.readInt();
                  valueobject.gift3 = evt.msg.body.readInt();
               }
               vo.valueobject = valueobject;
               break;
            case 3:
               valueobject.result3 = evt.msg.body.readInt();
               valueobject.state = evt.msg.body.readInt();
               vo.valueobject = valueobject;
               break;
            case 5:
               valueobject.result = evt.msg.body.readInt();
               valueobject.xinZhangCount = evt.msg.body.readInt();
               vo.valueobject = valueobject;
               break;
            case 10:
               valueobject.time10 = evt.msg.body.readInt();
               vo.valueobject = valueobject;
               break;
            case 11:
               valueobject.giftT = evt.msg.body.readInt();
               valueobject.giftT2 = evt.msg.body.readInt();
               valueobject.giftT3 = evt.msg.body.readInt();
               vo.valueobject = valueobject;
               break;
            case 12:
               valueobject.hp12 = evt.msg.body.readInt();
               vo.valueobject = valueobject;
               break;
            case 13:
               valueobject.state13 = evt.msg.body.readInt();
               vo.valueobject = valueobject;
         }
      }
   }
}

