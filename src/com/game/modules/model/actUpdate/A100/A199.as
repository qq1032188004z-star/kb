package com.game.modules.model.actUpdate.A100
{
   import com.game.modules.view.MapView;
   import com.game.modules.vo.ActivityVo;
   import org.green.server.events.MsgEvent;
   
   public class A199
   {
      
      private static var _ins:A199;
      
      public function A199()
      {
         super();
      }
      
      public static function get ins() : A199
      {
         return _ins = _ins || new A199();
      }
      
      public function onAct199Update(vo:ActivityVo, evt:MsgEvent) : void
      {
         if(vo == null || evt == null)
         {
            return;
         }
         switch(vo.protocolID)
         {
            case 1:
               vo.valueobject.restNaughtyMonsterCnt = evt.msg.body.readInt();
               vo.valueobject.restLotteryCnt = evt.msg.body.readInt();
               vo.valueobject.monsterFollowState = evt.msg.body.readInt();
               MapView.instance.masterPerson["showData"]["actFoodDiskStatus"] = vo.valueobject.monsterFollowState;
               break;
            case 2:
            case 3:
               break;
            case 4:
               vo.valueobject.result4 = evt.msg.body.readInt();
               vo.valueobject.coolTimeLeft = evt.msg.body.readInt();
               vo.valueobject.restNaughtyMonsterCnt = evt.msg.body.readInt();
               vo.valueobject.restLotteryCnt = evt.msg.body.readInt();
               vo.valueobject.eventSceneId = evt.msg.body.readInt();
               break;
            case 5:
               break;
            case 6:
               vo.valueobject.result6 = evt.msg.body.readInt();
               vo.valueobject.awardId = evt.msg.body.readInt();
               vo.valueobject.restLotteryCnt = evt.msg.body.readInt();
               break;
            case 7:
               vo.valueobject.result7 = evt.msg.body.readInt();
               vo.valueobject.cd = evt.msg.body.readInt();
               vo.valueobject.kbcoin = evt.msg.body.readInt();
               break;
            case 8:
            case 9:
               vo.valueobject.eventID = evt.msg.body.readInt();
               vo.valueobject.eventSceneId = evt.msg.body.readInt();
               vo.valueobject.exp = evt.msg.body.readInt();
               vo.valueobject.awardIndex = evt.msg.body.readInt();
               vo.valueobject.awardIndex2 = evt.msg.body.readInt();
               vo.valueobject.coin = evt.msg.body.readInt();
               break;
            case 10:
               vo.valueobject.restLotteryCnt = evt.msg.body.readInt();
               vo.valueobject.drawAwardIdx = evt.msg.body.readInt();
               break;
            case 11:
            case 12:
               break;
            case 13:
               vo.valueobject.result13 = evt.msg.body.readInt();
               break;
            case 22:
               vo.valueobject.consciousAccepted = evt.msg.body.readInt();
               vo.valueobject.userId = evt.msg.body.readUnsignedInt();
         }
      }
   }
}

