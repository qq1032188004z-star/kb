package com.game.modules.model.actUpdate.A700
{
   import com.core.observer.MessageEvent;
   import com.game.global.GlobalConfig;
   import com.game.locators.EventDefine;
   import com.game.locators.GameData;
   import com.xygame.module.battle.data.BattleLookList;
   import org.green.server.data.ByteArray;
   import org.green.server.data.MsgUtil;
   import org.green.server.events.MsgEvent;
   
   public class A703
   {
      
      private static var _ins:A703;
      
      public function A703()
      {
         super();
      }
      
      public static function get ins() : A703
      {
         return _ins = _ins || new A703();
      }
      
      public function onAct703Update(evt:MsgEvent) : void
      {
         var combatID:String = null;
         var obj:Object = null;
         var code:int = 0;
         var pID1:int = 0;
         var pName1:String = null;
         var res1:int = 0;
         var pID2:int = 0;
         var pName2:String = null;
         var res2:int = 0;
         var len:int = 0;
         var i:int = 0;
         var round:int = 0;
         var size:int = 0;
         var extractedData:ByteArray = null;
         if(evt == null)
         {
            return;
         }
         evt.msg.body.position = 0;
         var oper:String = evt.msg.body.readUTF();
         switch(oper)
         {
            case "video_state":
               GlobalConfig.otherObj["Act703"] = {"combatID":evt.msg.body.readUTF()};
               GlobalConfig.otherObj["Act703"]["sn" + evt.msg.body.readInt()] = {
                  "id":evt.msg.body.readInt(),
                  "name":evt.msg.body.readUTF(),
                  "isMaster":evt.msg.body.readInt()
               };
               GlobalConfig.otherObj["Act703"]["sn" + evt.msg.body.readInt()] = {
                  "id":evt.msg.body.readInt(),
                  "name":evt.msg.body.readUTF(),
                  "isMaster":evt.msg.body.readInt()
               };
               obj = GlobalConfig.otherObj["Act703"];
               break;
            case "video_apply":
               BattleLookList.ins.initData(1);
            case "video_broadcast":
               code = evt.msg.body.readInt();
               switch(code)
               {
                  case -1:
                     break;
                  case 0:
                     combatID = evt.msg.body.readUTF();
                     len = evt.msg.body.readInt();
                     for(i = 0; i < len; i++)
                     {
                        round = evt.msg.body.readInt();
                        size = evt.msg.body.readInt();
                        extractedData = MsgUtil.createByteArray();
                        evt.msg.body.readBytes(extractedData,0,size);
                        BattleLookList.ins.addLookData(extractedData);
                     }
                     GameData.instance.dispatchEvent(new MessageEvent(EventDefine.LOOK_BATTLE));
               }
               break;
            case "video_result":
               combatID = evt.msg.body.readUTF();
               pID1 = evt.msg.body.readInt();
               pName1 = evt.msg.body.readUTF();
               res1 = evt.msg.body.readInt();
               pID2 = evt.msg.body.readInt();
               pName2 = evt.msg.body.readUTF();
               res2 = evt.msg.body.readInt();
               GameData.instance.dispatchEvent(new MessageEvent(EventDefine.LOOK_BATTLE_RESULT,{
                  "pID1":pID1,
                  "pName1":pName1,
                  "res1":res1,
                  "pID2":pID2,
                  "pName2":pName2,
                  "res2":res2
               }));
         }
      }
   }
}

