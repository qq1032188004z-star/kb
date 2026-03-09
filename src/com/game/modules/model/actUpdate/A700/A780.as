package com.game.modules.model.actUpdate.A700
{
   import com.game.global.GlobalConfig;
   import com.game.locators.GameData;
   import com.game.locators.MsgDoc;
   import com.game.modules.vo.NewsVo;
   import flash.utils.Timer;
   import org.green.server.core.GreenSocket;
   import org.green.server.events.MsgEvent;
   import org.green.server.manager.SocketManager;
   
   public class A780
   {
      
      private static var _ins:A780;
      
      private var _con:GreenSocket;
      
      private var _gopTime:Timer;
      
      public function A780()
      {
         super();
         this._gopTime = new Timer(3000,1);
      }
      
      public static function get ins() : A780
      {
         return _ins = _ins || new A780();
      }
      
      protected function get con() : GreenSocket
      {
         if(this._con == null)
         {
            this._con = SocketManager.getGreenSocket();
         }
         return this._con;
      }
      
      public function onTimer() : void
      {
         var i:int = 0;
         var vo:NewsVo = null;
         if(!GlobalConfig.otherObj.hasOwnProperty("A780Sweep"))
         {
            if(!this._gopTime.running)
            {
               this.con.sendCmd(MsgDoc.OP_CLIENT_ACTIVITY_QINGYANG_NEW.send,780,["sweep_time"]);
               this._gopTime.start();
            }
         }
         else
         {
            i = int(GlobalConfig.otherObj["A780Sweep"]);
            if(i != 0)
            {
               if(!GlobalConfig.otherObj.hasOwnProperty("A780Message") && i <= GameData.instance.playerData.systemTimes)
               {
                  GlobalConfig.otherObj["A780Message"] = true;
                  vo = new NewsVo();
                  vo.alertType = 3;
                  vo.type = 5;
                  vo.data["otherKey"] = "A780Message";
                  vo.data["actId"] = 780;
                  vo.data["actTime"] = [20260227000000,20260409235959];
                  vo.data["actName"] = "惊雷大仙超进化·雷劫挑战";
                  vo.data["url"] = "assets/activity/djj2026/Act780/Act780Entrance.swf";
                  vo.msg = "您在“惊雷大仙超进化·雷劫挑战”活动中的扫荡已完成，记得及时领取！";
                  GameData.instance.boxVipMessages.push(vo);
                  GameData.instance.showMessagesCome();
               }
            }
         }
      }
      
      public function onAct780Update(evt:MsgEvent) : void
      {
         var endTime:Number = NaN;
         if(evt == null)
         {
            return;
         }
         evt.msg.body.position = 0;
         var oper:String = evt.msg.body.readUTF();
         var params:Object = {};
         switch(oper)
         {
            case "sweep_time":
               GlobalConfig.otherObj["A780Sweep"] = evt.msg.body.readInt();
         }
      }
   }
}

