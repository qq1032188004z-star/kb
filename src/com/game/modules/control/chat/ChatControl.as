package com.game.modules.control.chat
{
   import com.core.observer.MessageEvent;
   import com.core.view.ViewConLogic;
   import com.game.event.EventConst;
   import com.game.locators.GameData;
   import com.game.locators.MsgDoc;
   import com.game.manager.EventManager;
   import com.game.modules.view.WindowLayer;
   import com.game.modules.view.chat.ChatEvent;
   import com.game.modules.view.chat.ChatView;
   import com.game.modules.view.team.TeamNotScene;
   import com.game.util.FloatAlert;
   import com.publiccomponent.alert.Alert;
   import flash.events.Event;
   
   public class ChatControl extends ViewConLogic
   {
      
      public static const NAME:String = "chatmediator";
      
      public function ChatControl(viewComponent:Object)
      {
         super(NAME,viewComponent);
         this.initEvent();
      }
      
      private function initEvent() : void
      {
         this.view.addEventListener(Event.ADDED_TO_STAGE,this.onAddToStage);
         this.view.addEventListener(ChatEvent.PKEVENT,this.startPk);
         this.view.addEventListener(ChatEvent.REQUEST_UNFAMILY_CHAT,this.onReuqestUnfamilyChat);
      }
      
      private function onReuqestUnfamilyChat(evt:MessageEvent) : void
      {
         sendMessage(MsgDoc.OP_CLIENT_REQ_SELF_DRESS.send,this.view.params.userId,[0]);
      }
      
      private function startPk(evt:ChatEvent) : void
      {
         dispatch(EventConst.REQUES_BATTLE_WITH,evt.param);
      }
      
      private function onAddToStage(evt:Event) : void
      {
         this.view.buildChat();
         sendMessage(MsgDoc.OP_CLIENT_GET_CHAT_DRESS.send,int(this.view.params.userId));
         this.view.addEventListener("onSendMessage",this.onSendMsg);
         EventManager.attachEvent(this.view,"onInviteTeamBtn",this.onInviteTeamHandler);
         EventManager.attachEvent(this.view,"onCheckWhereBtn",this.onCheckWhereHandler);
         EventManager.attachEvent(this.view,"onGotoHouseBtn",this.onGotoHouseHandler);
         EventManager.attachEvent(this.view,"onCheckInfoBtn",this.onCheckInfoHandler);
      }
      
      private function onInviteTeamHandler(evt:Event) : void
      {
         if(TeamNotScene.hitScene(GameData.instance.playerData.currentScenenId))
         {
            new FloatAlert().show(WindowLayer.instance,300,400,"不能在此场景组队哦~");
            return;
         }
         if(GameData.instance.playerData.myTeamData == null)
         {
            new Alert().showSureOrCancel("先要创建队伍哦！",this.onCreateTeam);
         }
         else if(GameData.instance.playerData.myTeamData.teamHeadPlayer.playerId == GameData.instance.playerData.userId)
         {
            new Alert().showSureOrCancel("是否邀请" + this.view.params.userName + "(" + this.view.params.userId + ")加入你的队伍?",this.addTeamPlayer);
         }
         else
         {
            new FloatAlert().show(this.view,280,400,"只有队长才可以邀请其他玩家哦");
         }
      }
      
      private function onCreateTeam(... rest) : void
      {
         if(rest[0] == "确定")
         {
            GameData.instance.playerData.invitePlayer = this.view.params;
            sendMessage(MsgDoc.OP_CLIENT_CREATE_TEAM.send,0,[0,this.view.params.userName]);
         }
      }
      
      private function addTeamPlayer(... rest) : void
      {
         if(rest[0] == "确定")
         {
            sendMessage(MsgDoc.OP_CLIENT_INVITE_JOIN_TEAM.send,0,[int(this.view.params.userId)]);
         }
      }
      
      private function onCheckWhereHandler(evt:Event) : void
      {
         sendMessage(MsgDoc.OP_CLIENT_CHECK_POSITION.send,this.view.params.userId,[this.view.params.userName]);
      }
      
      private function onGotoHouseHandler(evt:Event) : void
      {
         if(GameData.instance.playerData.isInFishState)
         {
            return;
         }
         var id:int = int(this.view.params.userId);
         dispatch(EventConst.REQ_ENTER_ROOM,{
            "userId":id,
            "userName":this.view.params.userName,
            "houseId":id
         });
      }
      
      private function onCheckInfoHandler(evt:Event) : void
      {
         dispatch(EventConst.OPENPERSONINFOVIEW,{
            "userId":this.view.params.userId,
            "isOnline":1,
            "source":0,
            "userName":this.view.params.userName
         });
      }
      
      public function get view() : ChatView
      {
         return this.getViewComponent() as ChatView;
      }
      
      override public function listEvents() : Array
      {
         return [[EventConst.SENDPRIMSGBACK,this.sendPriMsgBack],[EventConst.FAMILYPRIMSGBACK,this.familyPriMsgBack],[EventConst.SENDPRIMSG,this.sendPriMsg],[EventConst.GETCHATDRESSBACK,this.getChatDressBack],[EventConst.GETPERSONDRESSBACK,this.getRefuseChatBack]];
      }
      
      private function sendPriMsgBack(event:MessageEvent) : void
      {
         var params:Object = event.body;
         if(GameData.instance.playerData.isOpening[params.from_id] != null)
         {
            if(GameData.instance.playerData.isOpening[params.from_id] == true)
            {
               if(this.view.params.userId == params.from_id)
               {
                  this.view.addMsg(params);
               }
            }
         }
      }
      
      private function familyPriMsgBack(evt:MessageEvent) : void
      {
         var params:Object = evt.body;
         if(GameData.instance.playerData.fisOpening[params.from_id] != null)
         {
            if(GameData.instance.playerData.fisOpening[params.from_id] == true)
            {
               if(this.view.params.userId == params.from_id)
               {
                  this.view.addMsg(params);
               }
            }
         }
      }
      
      private function sendPriMsg(event:MessageEvent) : void
      {
         var body:Object = event.body;
         if(this.view.params.userId == body.to_id)
         {
            sendMessage(MsgDoc.OP_CLIENT_CHAT.send,0,[body.type,body.flag,int(body.to_id),body.to_online,body.content,body.roleType]);
         }
      }
      
      private function onSendMsg(evt:MessageEvent) : void
      {
         var body:Object = evt.body;
         if(this.view.params.userId == body.to_id)
         {
            sendMessage(MsgDoc.OP_CLIENT_CHAT.send,0,[body.type,body.flag,int(body.to_id),body.to_online,body.content,body.roleType]);
         }
      }
      
      private function getChatDressBack(evt:MessageEvent) : void
      {
         var body:Object = evt.body;
         if(body == null || this.view == null)
         {
            return;
         }
         if(this.view.checkParams != null)
         {
            if(this.view.checkParams.userId == body.userId)
            {
               this.view.checkParams = body;
               this.view.initPlayerFace(body);
            }
         }
         else
         {
            this.view.checkParams = body;
            this.view.initPlayerFace(body);
         }
      }
      
      private function getRefuseChatBack(evt:MessageEvent) : void
      {
         var body:Object = evt.body;
         if(Boolean(body.hasOwnProperty("isAccept")) && Boolean(body.isAccept & 4))
         {
            this.view.isShowRefuseUnfamilyTis(true);
         }
         else
         {
            this.view.isShowRefuseUnfamilyTis(false);
         }
      }
   }
}

