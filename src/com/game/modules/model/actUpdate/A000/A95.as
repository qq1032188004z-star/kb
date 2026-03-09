package com.game.modules.model.actUpdate.A000
{
   import com.game.modules.vo.ActivityVo;
   import org.green.server.events.MsgEvent;
   
   public class A95
   {
      
      private static var _ins:A95;
      
      public function A95()
      {
         super();
      }
      
      public static function get ins() : A95
      {
         return _ins = _ins || new A95();
      }
      
      public function onSpaceChestHandler(vo:ActivityVo, evt:MsgEvent) : void
      {
         var i:int = 0;
         var item:Object = null;
         if(vo == null)
         {
            return;
         }
         if(evt == null)
         {
            return;
         }
         var items:Array = [100483,100484,100485];
         if(vo.protocolID == 1)
         {
            vo.valueobject.suiPian = evt.msg.body.readInt();
            vo.valueobject.huanShiNum = evt.msg.body.readInt();
            vo.valueobject.liuLiNum = evt.msg.body.readInt();
            vo.valueobject.list = [];
            for(i = 0; i < 3; i++)
            {
               item = {};
               item.index = i + 1;
               item.keyId = items[i];
               item.keyNum = evt.msg.body.readInt();
               item.keyNeedNum = evt.msg.body.readInt();
               item.openTimes = evt.msg.body.readInt();
               vo.valueobject.list.push(item);
            }
         }
         else if(vo.protocolID == 2)
         {
            vo.valueobject.type = evt.msg.body.readInt();
            vo.valueobject.result = evt.msg.body.readInt();
            if(vo.valueobject.result == 0)
            {
               vo.valueobject.keyNum = evt.msg.body.readInt();
               vo.valueobject.keyNeedNum = evt.msg.body.readInt();
               vo.valueobject.itemID = evt.msg.body.readInt();
               vo.valueobject.itemNum = evt.msg.body.readInt();
               trace(vo.valueobject.keyNum,vo.valueobject.keyNeedNum,vo.valueobject.itemID,vo.valueobject.itemNum);
            }
         }
         else if(vo.protocolID == 3)
         {
            vo.valueobject.type = evt.msg.body.readInt();
            vo.valueobject.number = evt.msg.body.readInt();
            vo.valueobject.result = evt.msg.body.readInt();
            vo.valueobject.suiPian = evt.msg.body.readInt();
         }
         else if(vo.protocolID == 4)
         {
            vo.valueobject.index = evt.msg.body.readInt();
            vo.valueobject.number = evt.msg.body.readInt();
            vo.valueobject.result = evt.msg.body.readInt();
            vo.valueobject.reduceNum = evt.msg.body.readInt();
         }
      }
   }
}

