package com.game.modules.parse
{
   import com.game.modules.vo.ShowData;
   import org.green.server.data.MsgPacket;
   import org.green.server.interfaces.IParser;
   
   public class RoleInfoParse implements IParser
   {
      
      public var params:ShowData;
      
      public function RoleInfoParse()
      {
         super();
      }
      
      public function parse(msg:MsgPacket) : void
      {
         var code:uint = uint(msg.mParams);
         this.params = new ShowData();
         if(code == 0)
         {
            this.params.userId = msg.body.readUnsignedInt();
            msg.body.readUnsignedInt();
            if(this.params.userId != -1)
            {
               this.params.userName = msg.body.readUTF();
               this.params.roleType = msg.body.readInt();
               this.params.hatId = msg.body.readInt();
               this.params.clothId = msg.body.readInt();
               this.params.weaponId = msg.body.readInt();
               this.params.footId = msg.body.readInt();
               this.params.faceId = msg.body.readInt();
               this.params.wingId = msg.body.readInt();
               this.params.glassId = msg.body.readInt();
               this.params.leftWeapon = msg.body.readInt();
               this.params.taozhuangId = msg.body.readInt();
               this.params.backgroundId = msg.body.readInt();
               this.params.isAccept = msg.body.readInt();
               this.params.horseID = msg.body.readInt();
               this.params.isOnline = msg.body.readInt();
               this.params.historyValue = msg.body.readInt();
               this.params.kabuLevle = msg.body.readInt();
               this.params.signTime = msg.body.readInt();
               this.params.monsterMaxLevel = msg.body.readInt();
               this.params.isFriend = msg.body.readInt();
               this.params.familyId = msg.body.readInt();
               if(msg.body.bytesAvailable > 0)
               {
                  this.params.littlegameRcore = msg.body.readInt();
               }
               this.params.userBeiZhu = msg.body.readUTF();
            }
         }
      }
   }
}

