package com.game.modules.model.actUpdate.A700
{
   import com.game.modules.view.FaceView;
   import org.green.server.events.MsgEvent;
   
   public class A758
   {
      
      private static var _ins:A758;
      
      public function A758()
      {
         super();
      }
      
      public static function get ins() : A758
      {
         return _ins = _ins || new A758();
      }
      
      public function onAct758Update(evt:MsgEvent) : void
      {
         var redPoint:int = 0;
         if(evt == null)
         {
            return;
         }
         evt.msg.body.position = 0;
         var oper:String = evt.msg.body.readUTF();
         var code:int = 0;
         switch(oper)
         {
            case "get_red":
               code = evt.msg.body.readInt();
               redPoint = evt.msg.body.readInt();
               if(code == 0)
               {
                  FaceView.clip.topClip.showRedPointByName("RegressionBtn",Boolean(redPoint >= 1));
               }
         }
      }
   }
}

