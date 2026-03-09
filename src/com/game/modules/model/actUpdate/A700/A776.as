package com.game.modules.model.actUpdate.A700
{
   import com.game.global.GlobalConfig;
   import com.game.locators.GameData;
   import com.game.modules.vo.NewsVo;
   import org.green.server.core.GreenSocket;
   import org.green.server.events.MsgEvent;
   import org.green.server.manager.SocketManager;
   
   public class A776
   {
      
      private static var _ins:A776;
      
      private var _con:GreenSocket;
      
      public function A776()
      {
         super();
      }
      
      public static function get ins() : A776
      {
         return _ins = _ins || new A776();
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
         var sweepTime:int = 0;
         var t:int = 0;
         var vo:NewsVo = null;
         if(GlobalConfig.otherObj.hasOwnProperty("A776Sweep"))
         {
            sweepTime = int(GlobalConfig.otherObj["A776Sweep"]);
            if(sweepTime != 0)
            {
               t = sweepTime - GameData.instance.playerData.systemTimes;
               if(!GlobalConfig.otherObj.hasOwnProperty("A776Message") && t <= 0)
               {
                  GlobalConfig.otherObj["A776Message"] = true;
                  vo = new NewsVo();
                  vo.alertType = 3;
                  vo.type = 5;
                  vo.data["otherKey"] = "A776Message";
                  vo.data["actId"] = 776;
                  vo.data["goScene"] = 6004;
                  vo.msg = "本源之门·涂山境扫荡已结束";
                  GameData.instance.boxVipMessages.push(vo);
                  GameData.instance.showMessagesCome();
               }
            }
         }
      }
      
      public function onAct776Update(evt:MsgEvent) : void
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
            case "sweep_info":
               params.result = evt.msg.body.readInt();
               params.sweepState = evt.msg.body.readInt();
               if(params.sweepState != 0)
               {
                  params.rank = evt.msg.body.readInt();
                  params.curNum = evt.msg.body.readInt();
                  params.sweepTime = evt.msg.body.readInt();
               }
               if(params.sweepState == 1)
               {
                  GlobalConfig.otherObj["A776Sweep"] = params.sweepTime;
               }
               else
               {
                  GlobalConfig.otherObj["A776Sweep"] = 0;
               }
               break;
            case "sweep_reward":
               GlobalConfig.otherObj["A776Sweep"] = 0;
         }
      }
   }
}

