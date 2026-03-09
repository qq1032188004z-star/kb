package com.game.modules.model.actUpdate.A600
{
   import com.game.locators.CacheData;
   import org.green.server.events.MsgEvent;
   
   public class A610
   {
      
      private static var _ins:A610;
      
      public function A610()
      {
         super();
      }
      
      public static function get ins() : A610
      {
         return _ins = _ins || new A610();
      }
      
      public function onAct610Update(evt:MsgEvent) : void
      {
         if(evt == null)
         {
            return;
         }
         evt.msg.body.position = 0;
         var oper:String = evt.msg.body.readUTF();
         var data:Object = {};
         switch(oper)
         {
            case "open_ui":
               data["login_num"] = evt.msg.body.readInt();
               data["flag"] = evt.msg.body.readInt();
               CacheData.instance.kabuOnline.initkabuOnlineLoginData(data);
               break;
            case "reward":
               data["idx"] = evt.msg.body.readInt();
               data["state"] = evt.msg.body.readInt();
               data["flag"] = evt.msg.body.readInt();
               CacheData.instance.kabuOnline.updatekabuOnlineLoginData(data);
         }
      }
   }
}

