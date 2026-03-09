package com.game.modules.model.actUpdate.A000
{
   import com.game.modules.vo.ActivityVo;
   import org.green.server.events.MsgEvent;
   
   public class A154
   {
      
      private static var _ins:A154;
      
      public function A154()
      {
         super();
      }
      
      public static function get ins() : A154
      {
         return _ins = _ins || new A154();
      }
      
      public function onMallActivity($vo:ActivityVo, $evt:MsgEvent) : void
      {
         if($vo == null || $evt == null)
         {
            return;
         }
         $vo.valueobject.result = $evt.msg.body.readInt();
         $vo.valueobject.rest = $evt.msg.body.readInt();
         $vo.valueobject.index = $evt.msg.body.readInt();
      }
   }
}

