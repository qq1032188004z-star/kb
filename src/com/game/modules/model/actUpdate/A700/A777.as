package com.game.modules.model.actUpdate.A700
{
   import com.game.modules.view.FaceView;
   import org.green.server.events.MsgEvent;
   
   public class A777
   {
      
      private static var _ins:A777;
      
      public function A777()
      {
         super();
      }
      
      public static function get ins() : A777
      {
         return _ins = _ins || new A777();
      }
      
      public function onAct777Update(evt:MsgEvent) : void
      {
         var code:int = 0;
         if(evt == null)
         {
            return;
         }
         evt.msg.body.position = 0;
         var oper:String = evt.msg.body.readUTF();
         var flag:int = 0;
         switch(oper)
         {
            case "open_ui":
               flag = evt.msg.body.readInt();
               break;
            case "reward":
               code = evt.msg.body.readInt();
               if(code == 0)
               {
                  flag = 1;
               }
         }
         if(Boolean(flag))
         {
            FaceView.clip.topClip.hideBtnByName("givehorseBtn");
         }
      }
   }
}

