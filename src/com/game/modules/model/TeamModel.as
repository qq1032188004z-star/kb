package com.game.modules.model
{
   import com.core.model.Model;
   import com.game.event.EventConst;
   import com.game.global.GlobalConfig;
   import com.game.locators.GameData;
   import com.game.locators.MsgDoc;
   import com.game.manager.AlertManager;
   import com.game.modules.vo.NewsVo;
   import com.game.modules.vo.team.PlayerVo;
   import com.game.modules.vo.team.TeamVo;
   import com.game.util.ChatUtil;
   import com.game.util.HtmlUtil;
   import com.publiccomponent.alert.Alert;
   import flash.utils.setTimeout;
   import org.green.server.events.MsgEvent;
   
   public class TeamModel extends Model
   {
      
      private var teamModeName:String = "teamModelName";
      
      private var itemIndex:int;
      
      private var _timeNum:int;
      
      private var _num:int;
      
      private var _msgEvent:MsgEvent;
      
      public function TeamModel(modelName:String = null)
      {
         var newModelName:String = modelName == null ? this.teamModeName : modelName;
         super(newModelName);
      }
      
      private function sendMessage(mOpcode:uint, mprams:int = 0, body:Array = null) : void
      {
         con.sendCmd(mOpcode,mprams,body);
      }
      
      override public function onRegister() : void
      {
         registerListener(MsgDoc.OP_CLIENT_MESSAGE_SHOW.back.toString(),this.onMessageShowHandler);
         registerListener(MsgDoc.OP_CLIENT_CREATE_TEAM.back.toString(),this.onCreateTeamHandler);
         registerListener(MsgDoc.OP_CLIENT_GET_TEAM_INFO.back.toString(),this.onGetTeamInfoHandler);
         registerListener(MsgDoc.OP_CLIENT_OUT_TEAM.back.toString(),this.onOutTeamHandler);
         registerListener(MsgDoc.OP_CLIENT_KICK_PLAYER.back.toString(),this.onKickPlayerHandler);
         registerListener(MsgDoc.OP_CLIENT_APP_TEAM_HEADER.back.toString(),this.onAppTeamHeaderHandler);
         registerListener(MsgDoc.OP_CLIENT_TEAM_CHANGE_NAME.back.toString(),this.onTeamChangeNameHandler);
         registerListener(MsgDoc.OP_CLIENT_TEAM_OWEN_ACCEPT.back.toString(),this.onTeamOwenAcceptHandler);
         registerListener(MsgDoc.OP_CLIENT_TEAM_OWEN_JOIN.back.toString(),this.onTeamOwenJoinHandler);
         registerListener(MsgDoc.OP_CLIENT_INVITE_JOIN_TEAM.back.toString(),this.onInviteJoinTeamHandler);
         registerListener(MsgDoc.OP_CLIENT_NEAR_TEAM_LIST.back.toString(),this.onNearTeamListHandler);
         registerListener(MsgDoc.OP_CLIENT_APPLY_TEAM.back.toString(),this.onApplyTeamHandler);
         registerListener(MsgDoc.OP_CLIENT_PLAYER_JOIN.back.toString(),this.onPlayerJoinTeamHandler);
         registerListener(MsgDoc.OP_CLIENT_PLAYER_OVNER_RECEVE.back.toString(),this.onPlayerOvnerHandler);
         registerListener(MsgDoc.OP_CLIENT_TEAM_CHAT.back.toString(),this.onClientTeamChatHandler);
         registerListener(MsgDoc.OP_CLIENT_PLAYER_BATTLE.back.toString(),this.onPlayerBattleHandler);
         registerListener(MsgDoc.OP_CLIENT_INVITE_PLAYER_MESSAGE.back.toString(),this.onInvitePlayerHandler);
         registerListener(MsgDoc.OP_CLIENT_FIND_PLAYER.back.toString(),this.onFindPlayerBackHandler);
         registerListener(MsgDoc.OP_CLIENT_FIND_BY_PLAYERID.back.toString(),this.onFindByPlayerId);
         registerListener(MsgDoc.OP_CLIENT_FIND_NEAR_PLAYER.back.toString(),this.onFindNearPlayer);
         registerListener(MsgDoc.OP_CLIENT_FIND_SERVER_PLAYER.back.toString(),this.onFindPlayerServer);
      }
      
      private function onMessageShowHandler(e:MsgEvent) : void
      {
         var teamName:String = null;
         var uid:int = 0;
         e.stopImmediatePropagation();
         e.msg.body.position = 0;
         var o:NewsVo = new NewsVo();
         var msg:String = "";
         if(e.msg.mParams == 1)
         {
            teamName = e.msg.body.readUTF();
            msg = "你已成功加入 [" + teamName + "] 的队伍";
         }
         else if(e.msg.mParams == 2)
         {
            teamName = e.msg.body.readUTF();
            msg = "你已经离开 [" + teamName + "] 的队伍";
         }
         else if(e.msg.mParams == 3)
         {
            uid = e.msg.body.readInt();
            teamName = e.msg.body.readUTF();
            msg = ChatUtil.onCheckStr(teamName) + "(" + uid + ")已加入队伍";
         }
         else if(e.msg.mParams == 4)
         {
            uid = e.msg.body.readInt();
            teamName = e.msg.body.readUTF();
            msg = ChatUtil.onCheckStr(teamName) + "(" + uid + ")已离开队伍";
         }
         if(msg != null && msg != "")
         {
            o.msg = msg;
            o.alertType = 3;
            GameData.instance.boxMessagesArray.push(o);
            GameData.instance.showMessagesCome();
         }
      }
      
      private function onCreateTeamHandler(e:MsgEvent) : void
      {
         e.stopImmediatePropagation();
         e.msg.body.position = 0;
         var teamId:int = e.msg.body.readInt();
         if(teamId > 0)
         {
            AlertManager.instance.showTipAlert({
               "systemid":1048,
               "flag":1
            });
            this.sendMessage(MsgDoc.OP_CLIENT_GET_TEAM_INFO.send,0,[teamId]);
         }
         else
         {
            AlertManager.instance.showTipAlert({
               "systemid":1048,
               "flag":2
            });
         }
      }
      
      private function onGetTeamInfoHandler(e:MsgEvent) : void
      {
         var teamPlayerVo:PlayerVo = null;
         e.stopImmediatePropagation();
         e.msg.body.position = 0;
         var teamVo:TeamVo = new TeamVo();
         var teamId:int = e.msg.body.readInt();
         var headId:int = e.msg.body.readInt();
         var apply:int = e.msg.body.readInt() == 0 ? 1 : 2;
         var teamName:String = e.msg.body.readUTF();
         teamVo.teamIndex = teamId;
         teamVo.teamName = teamName;
         teamVo.apply = apply;
         var len:int = e.msg.body.readInt();
         var playerList:Array = [];
         for(var i:int = 0; i < len; i++)
         {
            teamPlayerVo = new PlayerVo();
            teamPlayerVo.playerId = e.msg.body.readInt();
            teamPlayerVo.sex = Boolean(e.msg.body.readInt() & 1 > 0) ? 1 : 2;
            teamPlayerVo.playerName = e.msg.body.readUTF();
            teamPlayerVo.clanId = e.msg.body.readInt();
            teamPlayerVo.clanName = e.msg.body.readUTF();
            teamPlayerVo.isSameScene = e.msg.body.readInt() == GameData.instance.playerData.sceneId ? true : false;
            if(teamPlayerVo.playerId == headId)
            {
               teamPlayerVo.isHead = true;
               teamVo.teamHeadPlayer = teamPlayerVo;
            }
            else
            {
               teamPlayerVo.isHead = false;
            }
            playerList.push(teamPlayerVo);
         }
         teamVo.teamPlayerList = playerList;
         if(GameData.instance.playerData.myTeamData != null)
         {
            GameData.instance.playerData.myTeamData.disport();
            GameData.instance.playerData.myTeamData = null;
         }
         GameData.instance.playerData.myTeamData = teamVo;
         dispatch(EventConst.TEAM_PLAYER_LIST_BACK);
         dispatch(EventConst.TEAM_OPEN_MESSAGE_VIEW);
         if(GameData.instance.playerData.invitePlayer != null)
         {
            this.sendMessage(MsgDoc.OP_CLIENT_INVITE_JOIN_TEAM.send,0,[int(GameData.instance.playerData.invitePlayer.userId)]);
            GameData.instance.playerData.invitePlayer = null;
         }
      }
      
      private function onOutTeamHandler(e:MsgEvent) : void
      {
         var name:String = null;
         e.stopImmediatePropagation();
         e.msg.body.position = 0;
         var playerId:int = e.msg.body.readInt();
         var teamHeadId:int = e.msg.body.readInt();
         if(GameData.instance.playerData.myTeamData != null)
         {
            if(GameData.instance.playerData.userId == playerId)
            {
               dispatch(EventConst.TEAM_KILL_PLAYER);
               dispatch(EventConst.TEAM_CLOSE_MESSAGE_VIEW);
               if(GameData.instance.playerData.myTeamData == null)
               {
                  return;
               }
               GameData.instance.playerData.myTeamData.disport();
               GameData.instance.playerData.myTeamData = null;
            }
            else
            {
               name = GameData.instance.playerData.myTeamData.getTeamPlayerNameById(playerId);
               if(name != null && name != "")
               {
                  dispatch(EventConst.TEAM_CHAT_MESSAGE,{
                     "code":2,
                     "content":name + "离开了队伍"
                  });
               }
               GameData.instance.playerData.myTeamData.removeTeamPlayer(playerId);
               GameData.instance.playerData.myTeamData.updateHead(teamHeadId);
               dispatch(EventConst.TEAM_MY_UPDADA_LIST);
            }
         }
      }
      
      private function onKickPlayerHandler(e:MsgEvent) : void
      {
         var uid:int = 0;
         var username:String = null;
         e.stopImmediatePropagation();
         if(e.msg.mParams != 0)
         {
            if(e.msg.mParams == 1)
            {
               uid = e.msg.body.readInt();
               username = e.msg.body.readUTF();
               AlertManager.instance.showTipAlert({
                  "systemid":1048,
                  "flag":3,
                  "replace":username,
                  "replaceNum":uid
               });
               dispatch(EventConst.TEAM_ME_OUT_TEAM);
            }
         }
      }
      
      private function onAppTeamHeaderHandler(e:MsgEvent) : void
      {
         var news:NewsVo = null;
         e.stopImmediatePropagation();
         e.msg.body.position = 0;
         var playerId:int = e.msg.body.readInt();
         var apply:int = e.msg.body.readInt();
         if(GameData.instance.playerData.myTeamData != null)
         {
            GameData.instance.playerData.myTeamData.apply = apply == 0 ? 1 : 2;
            GameData.instance.playerData.myTeamData.updateHead(playerId);
            dispatch(EventConst.TEAM_APP_TEAM_HEADER);
            news = new NewsVo();
            news.msg = GameData.instance.playerData.myTeamData.getTeamPlayerNameById(playerId) + "(" + playerId + ")已成为队长";
            news.alertType = 3;
            GameData.instance.boxMessagesArray.push(news);
            GameData.instance.showMessagesCome();
         }
      }
      
      private function onTeamChangeNameHandler(e:MsgEvent) : void
      {
         e.stopImmediatePropagation();
         e.msg.body.position = 0;
         var teamName:String = e.msg.body.readUTF();
         if(GameData.instance.playerData.myTeamData != null)
         {
            GameData.instance.playerData.myTeamData.teamName = teamName;
            if(GameData.instance.playerData.myTeamData.teamHeadPlayer.playerId == GlobalConfig.userId)
            {
               AlertManager.instance.showTipAlert({
                  "systemid":1048,
                  "flag":4
               });
            }
            dispatch(EventConst.TEAM_CHANGE_NAME);
         }
      }
      
      private function onTeamOwenAcceptHandler(e:MsgEvent) : void
      {
         e.stopImmediatePropagation();
         var flag:int = e.msg.body.readInt() == 0 ? 1 : 2;
         dispatch(EventConst.TEAM_CHANGE_IVINTE_OWNER,{
            "type":1,
            "flag":flag
         });
         var param:int = flag == 1 ? 1 : 0;
         AlertManager.instance.showTipAlert({
            "systemid":1048,
            "flag":5,
            "params":param
         });
      }
      
      private function onTeamOwenJoinHandler(e:MsgEvent) : void
      {
         e.stopImmediatePropagation();
         var flag:int = e.msg.body.readInt() == 0 ? 1 : 2;
         dispatch(EventConst.TEAM_CHANGE_IVINTE_OWNER,{
            "type":2,
            "flag":flag
         });
         var param:int = flag == 1 ? 1 : 0;
         AlertManager.instance.showTipAlert({
            "systemid":1048,
            "flag":6,
            "params":param
         });
      }
      
      private function onInviteJoinTeamHandler(event:MsgEvent) : void
      {
         event.stopImmediatePropagation();
         this._msgEvent = event;
         ++this._num;
         if(this._timeNum == 0)
         {
            this._timeNum = setTimeout(function():void
            {
               var uid:* = undefined;
               var username:* = undefined;
               var teamId:* = undefined;
               if(_num == 1)
               {
                  if(_msgEvent.msg.mParams == 1)
                  {
                     _msgEvent.msg.body.position = 0;
                     uid = _msgEvent.msg.body.readUnsignedInt();
                     username = _msgEvent.msg.body.readUTF();
                     teamId = _msgEvent.msg.body.readInt();
                     sendMessage(MsgDoc.OP_CLIENT_INVITE_PLAYER_MESSAGE.send,uid);
                     new Alert().showAcceptOrRefuse(HtmlUtil.getRealHtmlStr(username) + "(" + uid + ")邀请你加入队伍！",onInviteJoinBack,teamId);
                  }
                  else if(_msgEvent.msg.mParams == -1)
                  {
                     AlertManager.instance.showTipAlert({
                        "systemid":1048,
                        "flag":7
                     });
                  }
               }
               _timeNum = 0;
               _num = 0;
            },1000);
         }
      }
      
      private function onInviteJoinBack(... rest) : void
      {
         if(rest[0] == "接受")
         {
            this.sendMessage(MsgDoc.OP_CLIENT_APPLY_TEAM.send,0,[rest[1],1]);
         }
      }
      
      private function onNearTeamListHandler(e:MsgEvent) : void
      {
         var teamVo:Object = null;
         var teamHeadId:int = 0;
         var teamPlayer:Object = null;
         e.stopImmediatePropagation();
         e.msg.body.position = 0;
         var len:int = e.msg.body.readInt();
         var nearTeamList:Array = [];
         var j:int = 0;
         var i:int = 0;
         for(i = 0; i < len; i++)
         {
            teamVo = {};
            teamVo.teamIndex = e.msg.body.readInt();
            teamHeadId = e.msg.body.readInt();
            teamVo.apply = e.msg.body.readInt();
            teamVo.teamName = e.msg.body.readUTF();
            teamVo.length = e.msg.body.readInt();
            for(j = 0; j < teamVo.length; j++)
            {
               teamPlayer = {};
               teamPlayer.playerId = e.msg.body.readInt();
               teamPlayer.sex = Boolean(e.msg.body.readInt() & 1 > 0) ? 1 : 2;
               teamPlayer.isHead = teamPlayer.playerId == teamHeadId ? true : false;
               teamPlayer.playerName = e.msg.body.readUTF();
               teamPlayer.clanId = e.msg.body.readInt();
               teamPlayer.clanName = e.msg.body.readUTF();
               teamPlayer.isSameScene = e.msg.body.readInt() == GameData.instance.playerData.sceneId ? true : false;
               if(teamHeadId == teamPlayer.playerId)
               {
                  teamVo.playerId = teamPlayer.playerId;
                  teamVo.sex = teamPlayer.sex;
                  teamVo.playerName = teamPlayer.playerName;
               }
            }
            nearTeamList.push(teamVo);
         }
         nearTeamList.sortOn("length",Array.NUMERIC);
         dispatch(EventConst.TEAM_NEAR_TEAM_LIST_BACK,nearTeamList);
      }
      
      private function onApplyTeamHandler(e:MsgEvent) : void
      {
         var uid:int = 0;
         var username:String = null;
         var teamId:int = 0;
         e.stopImmediatePropagation();
         if(e.msg.mParams == 1)
         {
            uid = e.msg.body.readInt();
            username = e.msg.body.readUTF();
            teamId = e.msg.body.readInt();
            this.itemIndex = teamId;
            new Alert().showAcceptOrRefuse(HtmlUtil.getRealHtmlStr(ChatUtil.onCheckStr(username)) + "(" + uint(uid) + ")申请加入队伍",this.onAcceptBackHandler,uid);
         }
      }
      
      private function onAcceptBackHandler(... rest) : void
      {
         if(rest[0] == "接受")
         {
            this.sendMessage(MsgDoc.OP_CLIENT_PLAYER_ACCEPT.send,0,[rest[1]]);
         }
      }
      
      private function onPlayerJoinTeamHandler(e:MsgEvent) : void
      {
         var teamPlayerVo:PlayerVo = null;
         e.stopImmediatePropagation();
         e.msg.body.position = 0;
         var playerId:int = e.msg.body.readInt();
         if(playerId == GameData.instance.playerData.userId)
         {
            this.sendMessage(MsgDoc.OP_CLIENT_GET_TEAM_INFO.send,0,[this.itemIndex]);
         }
         else
         {
            teamPlayerVo = new PlayerVo();
            teamPlayerVo.playerId = playerId;
            teamPlayerVo.sex = Boolean(e.msg.body.readInt() & 1 > 0) ? 1 : 2;
            teamPlayerVo.playerName = e.msg.body.readUTF();
            teamPlayerVo.clanId = e.msg.body.readInt();
            teamPlayerVo.clanName = e.msg.body.readUTF();
            teamPlayerVo.isSameScene = e.msg.body.readInt() == GameData.instance.playerData.sceneId ? true : false;
            if(GameData.instance.playerData.myTeamData != null)
            {
               GameData.instance.playerData.myTeamData.addTeamPlayer(teamPlayerVo);
               dispatch(EventConst.TEAM_CHAT_MESSAGE,{
                  "code":2,
                  "content":teamPlayerVo.playerName + "加入了队伍"
               });
               dispatch(EventConst.TEAM_MY_UPDADA_LIST);
            }
         }
      }
      
      private function onPlayerOvnerHandler(e:MsgEvent) : void
      {
         e.stopImmediatePropagation();
         e.msg.body.position = 0;
         var inviteFlag:int = e.msg.body.readInt();
         dispatch(EventConst.TEAM_PLAYER_OVNER_RECEVE,inviteFlag);
      }
      
      private function onClientTeamChatHandler(e:MsgEvent) : void
      {
         e.stopImmediatePropagation();
         e.msg.body.position = 0;
         var msg:String = e.msg.body.readUTF();
         dispatch(EventConst.TEAM_CHAT_MESSAGE,{
            "code":1,
            "content":msg
         });
      }
      
      private function onPlayerBattleHandler(e:MsgEvent) : void
      {
         e.stopImmediatePropagation();
         e.msg.body.position = 0;
         var playerId:int = e.msg.body.readInt();
         var isCombat:int = e.msg.body.readInt();
         if(GameData.instance.playerData.myTeamData != null)
         {
            if(GameData.instance.playerData.myTeamData.updateBattle(playerId,isCombat))
            {
               dispatch(EventConst.TEAM_UPDATE_BATTLE);
            }
         }
      }
      
      private function onInvitePlayerHandler(e:MsgEvent) : void
      {
         e.stopImmediatePropagation();
         var playerId:int = e.msg.mParams;
         AlertManager.instance.showTipAlert({
            "systemid":1048,
            "flag":8
         });
      }
      
      private function onFindPlayerBackHandler(e:MsgEvent) : void
      {
         var list:Array = null;
         e.stopImmediatePropagation();
         var len:int = e.msg.mParams;
         if(len > 0)
         {
            list = this.anysis(e);
            dispatch(EventConst.TEAM_PLAYER_FIND,{
               "type":1,
               "data":list
            });
         }
         else
         {
            AlertManager.instance.showTipAlert({
               "systemid":1048,
               "flag":9
            });
         }
      }
      
      private function onFindByPlayerId(e:MsgEvent) : void
      {
         var playerVo:Object = null;
         e.stopImmediatePropagation();
         e.msg.body.position = 0;
         var playerId:int = e.msg.body.readInt();
         if(playerId == -1)
         {
            AlertManager.instance.showTipAlert({
               "systemid":1048,
               "flag":10
            });
         }
         else
         {
            playerVo = {};
            playerVo.playerId = playerId;
            playerVo.playerName = e.msg.body.readUTF();
            playerVo.sex = Boolean(e.msg.body.readInt() & 1 > 0) ? 1 : 2;
            playerVo.teamId = e.msg.body.readInt();
            playerVo.teamName = e.msg.body.readUTF();
            dispatch(EventConst.TEAM_PLAYER_FIND,{
               "type":1,
               "data":[playerVo]
            });
         }
      }
      
      private function onFindNearPlayer(e:MsgEvent) : void
      {
         e.stopImmediatePropagation();
         var data:Array = this.anysis(e);
         dispatch(EventConst.TEAM_PLAYER_FIND,{
            "type":2,
            "data":data
         });
      }
      
      private function onFindPlayerServer(e:MsgEvent) : void
      {
         e.stopImmediatePropagation();
         var data:Array = this.anysis(e);
         dispatch(EventConst.TEAM_PLAYER_FIND,{
            "type":2,
            "data":data
         });
      }
      
      private function anysis(e:MsgEvent) : Array
      {
         var playerVo:Object = null;
         var len:int = e.msg.mParams;
         var data:Array = [];
         for(var i:int = 0; i < len; i++)
         {
            playerVo = {};
            playerVo.playerId = e.msg.body.readInt();
            playerVo.playerName = e.msg.body.readUTF();
            playerVo.sex = Boolean(e.msg.body.readInt() & 1 > 0) ? 1 : 2;
            playerVo.teamId = e.msg.body.readInt();
            playerVo.teamName = e.msg.body.readUTF();
            data.push(playerVo);
         }
         data.sortOn("teamId",Array.NUMERIC);
         return data;
      }
   }
}

