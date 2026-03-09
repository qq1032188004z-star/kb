package com.game.modules.parse
{
   import com.game.global.GlobalConfig;
   import com.game.locators.GameData;
   import com.game.modules.vo.ShowData;
   import org.green.server.data.MsgPacket;
   import org.green.server.interfaces.IParser;
   
   public class ShowDataParse implements IParser
   {
      
      public function ShowDataParse()
      {
         super();
      }
      
      public function parse(msg:MsgPacket) : void
      {
      }
      
      public function myparse(msg:MsgPacket, sd:ShowData = null) : *
      {
         if(sd == null)
         {
            sd = new ShowData();
         }
         sd.lastSceneId = msg.body.readInt();
         var num:Number = msg.body.readUnsignedInt();
         sd.userId = num;
         sd.uid = num.toString();
         sd.userName = msg.body.readUTF();
         sd.roleType = msg.body.readInt();
         sd.familyName = msg.body.readUTF();
         sd.familyAllName = msg.body.readUTF();
         sd.hatId = msg.body.readInt();
         sd.clothId = msg.body.readInt();
         sd.weaponId = msg.body.readInt();
         sd.footId = msg.body.readInt();
         sd.faceId = msg.body.readInt();
         sd.wingId = msg.body.readInt();
         sd.glassId = msg.body.readInt();
         sd.leftWeapon = msg.body.readInt();
         sd.taozhuangId = msg.body.readInt();
         sd.backgroundId = msg.body.readInt();
         sd.horseID = msg.body.readInt();
         sd.horseSpeed = msg.body.readInt();
         sd.historyValue = msg.body.readInt();
         sd.kabuLevle = msg.body.readInt();
         sd.signTime = msg.body.readInt();
         sd.trump = msg.body.readInt();
         sd.msid = msg.body.readInt();
         sd.mid = msg.body.readInt();
         sd.mstateCount = msg.body.readInt();
         sd.isOnline = 1;
         if(sd.mid != 0)
         {
            sd.mstate = 1;
         }
         sd.mname = msg.body.readUTF();
         sd.nameBorderId = msg.body.readInt();
         sd.trumpstate = msg.body.readInt();
         if(sd.trumpstate == 1)
         {
            sd.trumpmaster = msg.body.readInt();
            sd.trumpAppearance = msg.body.readInt();
            sd.state = 2;
         }
         sd.isVip = Boolean(msg.body.readInt());
         sd.vipLevel = msg.body.readInt();
         sd.vipScore = msg.body.readInt();
         sd.actFoodDiskStatus = msg.body.readInt();
         if(sd.isVip != true)
         {
            sd.vipLevel = 0;
         }
         sd.isInChange = msg.body.readInt();
         if(sd.isInChange != 0)
         {
            sd.bodyID = msg.body.readInt();
         }
         if(GameData.instance.playerData.isInWarCraft)
         {
            sd.playerState = msg.body.readInt();
            sd.teamId = msg.body.readInt();
         }
         sd.playerStatus = msg.body.readShort();
         sd.titleIndex = msg.body.readInt();
         sd.setShowFamily(msg.body.readInt());
         sd.familyId = msg.body.readInt();
         var superNunm:int = msg.body.readInt();
         sd.isSupertrump = superNunm == GlobalConfig.currVipYear;
         if(sd.isSupertrump)
         {
            sd.vipLevel = 6;
         }
         return sd;
      }
   }
}

