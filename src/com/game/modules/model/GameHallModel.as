package com.game.modules.model
{
   import com.channel.Message;
   import com.core.model.Model;
   import com.game.facade.ApplicationFacade;
   import com.game.locators.GameData;
   import com.game.locators.MsgDoc;
   import com.game.modules.control.gamehall.GameHallControl;
   import com.game.modules.vo.NewsVo;
   import com.publiccomponent.alert.Alert;
   import org.green.server.events.MsgEvent;
   import org.green.server.manager.SocketManager;
   
   public class GameHallModel extends Model
   {
      
      public function GameHallModel(modelName:String = null)
      {
         super(modelName);
      }
      
      override public function onRegister() : void
      {
         registerListener(MsgDoc.OP_CLIENT_GET_GAMEHALL_KEY.back.toString(),this.onGameHallKeyBack);
         registerListener(MsgDoc.OP_CLIENT_REQ_SELF_DRESS.back.toString(),this.onGameHallDressBack);
         registerListener(MsgDoc.OP_CLIENT_SGMSG_INVITEACTIVE.back.toString(),this.reqGameInviteactiveBack);
      }
      
      private function reqGameInviteactiveBack(evt:MsgEvent) : void
      {
         O.traceSocket(evt);
         evt.msg.body.position = 0;
         var type:int = evt.msg.mParams;
         GameData.instance.playerData.inviteType = type;
         var GameId:int = evt.msg.body.readInt();
         var RoomId:int = evt.msg.body.readInt();
         var TableId:int = evt.msg.body.readInt();
         var InviterUID:int = evt.msg.body.readInt();
         var userName:String = evt.msg.body.readUTF();
         var o1:NewsVo = new NewsVo();
         o1.alertType = 8;
         if(type == 2)
         {
            if(RoomId == 7)
            {
               o1.msg = "游戏乐园的战果分享";
               o1.data.littleAlertType = 4;
               o1.data.GameId = GameId;
               o1.data.RoomId = RoomId;
               o1.data.TableId = TableId;
            }
            else
            {
               o1.msg = "游戏乐园的战果分享";
               o1.data.littleAlertType = 3;
               o1.data.GameId = GameId;
               o1.data.RoomId = RoomId;
               o1.data.TableId = TableId;
            }
         }
         else if(type == 1)
         {
            o1.msg = "来自游戏乐园的邀请";
            if(GameId != -1)
            {
               o1.data.littleAlertType = 2;
               o1.data.GameId = GameId;
               o1.data.RoomId = RoomId;
               o1.data.TableId = TableId;
            }
            else
            {
               o1.data.littleAlertType = 1;
            }
         }
         o1.type = 7;
         o1.data.playerId = InviterUID;
         o1.data.playerName = userName;
         GameData.instance.boxMessagesArray.push(o1);
         GameData.instance.showMessagesCome();
      }
      
      private function onGameHallKeyBack(event:MsgEvent) : void
      {
         var ghc:GameHallControl = null;
         O.traceSocket(event);
         if(SocketManager.hasGreenSocket("hall"))
         {
            ghc = ApplicationFacade.getInstance().retrieveViewLogic(GameHallControl.NAME) as GameHallControl;
            if(Boolean(ghc) && !ghc.hasSend)
            {
               return;
            }
            if(Boolean(ghc))
            {
               ghc.hasSend = false;
            }
         }
         var obj:Object = {};
         obj.type = event.msg.mParams;
         if(obj.type == 0)
         {
            event.msg.body.position = 0;
            obj.result = event.msg.body.readInt();
            if(obj.result >= 0)
            {
               obj.uid = event.msg.body.readInt();
               obj.name = event.msg.body.readUTF();
               obj.sex = event.msg.body.readInt();
               obj.time = event.msg.body.readInt();
               obj.key = event.msg.body.readUTF();
               if(GameData.instance.playerData.getkeyfromHallType == 0)
               {
                  new Message("gamehallkeyback",obj).sendToChannel("gamehall");
               }
               else
               {
                  new Message("submitwordsgamehallkeyback",obj).sendToChannel("gamehall");
               }
            }
            else if(obj.result < 0)
            {
               new Alert().show("获取进入资格失败");
            }
         }
      }
      
      private function onGameHallDressBack(event:MsgEvent) : void
      {
         O.traceSocket(event);
         var code:uint = uint(event.msg.mParams);
         var params:Object = {};
         if(code > 0)
         {
            event.msg.body.position = 0;
            params.userId = event.msg.body.readInt();
            if(params.userId != -1)
            {
               params.userName = event.msg.body.readUTF();
               params.roleType = event.msg.body.readInt();
               params.hatId = event.msg.body.readInt();
               params.clothId = event.msg.body.readInt();
               params.weaponId = event.msg.body.readInt();
               params.footId = event.msg.body.readInt();
               params.faceId = event.msg.body.readInt();
               params.wingId = event.msg.body.readInt();
               params.glassId = event.msg.body.readInt();
               params.isAccept = event.msg.body.readInt();
               params.isOnline = event.msg.body.readInt();
               params.isFriend = event.msg.body.readInt();
               params.familyId = event.msg.body.readInt();
               new Message("playerdressback",params).sendToChannel("gamehall");
            }
         }
      }
   }
}

