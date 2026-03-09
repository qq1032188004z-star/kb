package com.game.modules.control.gamehall
{
   import com.channel.ChannelEvent;
   import com.channel.ChannelPool;
   import com.channel.Message;
   import com.core.observer.MessageEvent;
   import com.core.view.ViewConLogic;
   import com.game.event.EventConst;
   import com.game.global.GlobalConfig;
   import com.game.locators.GameData;
   import com.game.locators.MsgDoc;
   import com.game.modules.view.gamehall.GameHallView;
   import org.green.server.core.GreenSocket;
   import org.green.server.data.CmdPacket;
   import org.green.server.data.MsgUtil;
   import org.green.server.events.MsgEvent;
   import org.green.server.manager.SocketManager;
   
   public class GameHallControl extends ViewConLogic
   {
      
      public static const NAME:String = "gamehallcontrol";
      
      private var hallsocket:GreenSocket;
      
      private var hallsocket2:GreenSocket;
      
      private var palygametype:int;
      
      private var sessionid:int;
      
      public var hasSend:Boolean;
      
      public function GameHallControl(viewcon:GameHallView)
      {
         super(NAME,viewcon);
         this.listenerchannel();
      }
      
      override public function listEvents() : Array
      {
         return [[EventConst.BATTLE_RELOGIN,this.onRelogInGameHall],[EventConst.LITTLE_GAME_OVER_BACK,this.onLittleGameOverBack]];
      }
      
      private function listenerchannel() : void
      {
         this.view.addEventListener(GameHallView.haveplaygame,this.onHavePlayGame);
         ChannelPool.getChannel("gamehall").addChannelListener("closegamehall",this.onCloseGameHallHandler);
         ChannelPool.getChannel("gamehall").addChannelListener("getgamehallkey",this.onGetGameHallKeyHandler);
         ChannelPool.getChannel("gamehall").addChannelListener("playerdress",this.onPlayDressBackHandler);
         ChannelPool.getChannel("gamehall").addChannelListener("openexchangeview",this.onOpenExchangeViewHandler);
         ChannelPool.getChannel("gamehall").addChannelListener("openscartchcard",this.onOpenScartcardView);
         ChannelPool.getChannel("gamehall").addChannelListener("playeruserid",this.onPlayerUserIdHandler);
         ChannelPool.getChannel("gamehall").addChannelListener("starthallgame",this.onStartHallGameHandler);
         ChannelPool.getChannel("gamehall").addChannelListener("endhallgame",this.onEndHallGameHandler);
      }
      
      public function startHallListen(value:String) : void
      {
         this.hallsocket = SocketManager.getGreenSocket(value);
         this.hallsocket.attachSocketListener(855638016,this.onHallAchievementHandler);
         this.hallsocket.attachSocketListener(855638019,this.onSleepHandler);
         this.hallsocket2 = SocketManager.getGreenSocket("hallNew");
         this.hallsocket2.attachSocketListener(855638019,this.onSleepHandler);
      }
      
      private function onHallAchievementHandler(event:MsgEvent) : void
      {
         var cmdpacket:CmdPacket = new CmdPacket();
         cmdpacket.mOpcode = 1184789;
         cmdpacket.mParams = event.msg.mParams;
         cmdpacket.body = MsgUtil.createByteArray();
         event.msg.body.position = 0;
         event.msg.body.readBytes(cmdpacket.body,0,event.msg.body.length);
         SocketManager.getGreenSocket().sendpacket(cmdpacket);
      }
      
      private function onSleepHandler(event:MsgEvent) : void
      {
         sendMessage(1184004,0,[0,0,GlobalConfig.userId,1]);
      }
      
      private function onHavePlayGame(event:MessageEvent) : void
      {
         this.palygametype = int(event.body);
         sendMessage(MsgDoc.OP_CLIENT_LITTLE_GAME.send,this.palygametype,[0]);
      }
      
      private function onCloseGameHallHandler(event:ChannelEvent) : void
      {
         var onlineid:int = 0;
         if(Boolean(event.getMessage().getBody()) && Boolean(event.getMessage().getBody().hasOwnProperty("onlineid")))
         {
            onlineid = int(event.getMessage().getBody().onlineid);
         }
         if(this.view.onlineId == 0 || this.view.onlineId == 2000 && this.view.onlineId == onlineid)
         {
            sendMessage(MsgDoc.OP_CLIENT_LITTLE_GAME.send,this.palygametype,[4,0,0,0]);
            ChannelPool.getChannel("gamehall").removeListener("closegamehall",this.onCloseGameHallHandler);
            ChannelPool.getChannel("gamehall").removeListener("getgamehallkey",this.onGetGameHallKeyHandler);
            ChannelPool.getChannel("gamehall").removeListener("playerdress",this.onPlayDressBackHandler);
            ChannelPool.getChannel("gamehall").removeListener("openexchangeview",this.onOpenExchangeViewHandler);
            ChannelPool.getChannel("gamehall").removeListener("openscartchcard",this.onOpenScartcardView);
            ChannelPool.getChannel("gamehall").removeListener("playeruserid",this.onPlayerUserIdHandler);
            ChannelPool.getChannel("gamehall").removeListener("starthallgame",this.onStartHallGameHandler);
            ChannelPool.getChannel("gamehall").removeListener("endhallgame",this.onEndHallGameHandler);
            if(Boolean(this.hallsocket))
            {
               this.hallsocket.removeSocketListener(855638016,this.onHallAchievementHandler);
               this.hallsocket.removeSocketListener(855638019,this.onSleepHandler);
               this.hallsocket = null;
            }
            if(Boolean(this.hallsocket2))
            {
               this.hallsocket2.removeSocketListener(855638019,this.onSleepHandler);
            }
            this.view.disport();
         }
      }
      
      private function onGetGameHallKeyHandler(event:ChannelEvent) : void
      {
         var getkeytype:int = 0;
         if(Boolean(event.getMessage().getBody()))
         {
            getkeytype = int(event.getMessage().getBody().getkeytype);
            GameData.instance.playerData.getkeyfromHallType = getkeytype;
         }
         else
         {
            GameData.instance.playerData.getkeyfromHallType = 0;
         }
         this.hasSend = true;
         sendMessage(MsgDoc.OP_CLIENT_GET_GAMEHALL_KEY.send,0,[GameData.instance.playerData.userId]);
      }
      
      private function onPlayDressBackHandler(event:ChannelEvent) : void
      {
         var obj:Object = event.getMessage().getBody();
         sendMessage(MsgDoc.OP_CLIENT_REQ_SELF_DRESS.send,obj.roomUserId,[1]);
      }
      
      private function onRelogInGameHall(event:MessageEvent) : void
      {
         new Message("gamehallrelogin").sendToChannel("gamehall");
      }
      
      private function onOpenExchangeViewHandler(event:ChannelEvent) : void
      {
         dispatch(EventConst.OPEN_MODULE,{
            "url":"assets/module/ScoreExchangeModule.swf",
            "xCoord":0,
            "yCoord":0
         });
      }
      
      private function onOpenScartcardView(evt:ChannelEvent) : void
      {
         this.dispatch(EventConst.OPEN_MODULE,{
            "url":"assets/module/ScratchCard.swf",
            "xCoord":0,
            "yCoord":0
         });
      }
      
      private function onPlayerUserIdHandler(event:ChannelEvent) : void
      {
         var obj:Object = {};
         obj.uid = GameData.instance.playerData.userId;
         new Message("playeruseridback",obj).sendToChannel("gamehall");
      }
      
      private function onLittleGameOverBack(event:MessageEvent) : void
      {
         var obj:Object = event.body;
         if(obj.hasOwnProperty("act"))
         {
            if(obj.act == 0)
            {
               this.sessionid = obj.result;
            }
         }
      }
      
      private function onStartHallGameHandler(event:ChannelEvent) : void
      {
         var gameid:int = int(event.getMessage().getBody().gameid);
         sendMessage(MsgDoc.OP_CLIENT_LITTLE_GAME.send,gameid,[0]);
      }
      
      private function onEndHallGameHandler(event:ChannelEvent) : void
      {
         var gameid:int = int(event.getMessage().getBody().gameid);
         sendMessage(MsgDoc.OP_CLIENT_LITTLE_GAME.send,gameid,[4,0,0,this.sessionid]);
      }
      
      private function get view() : GameHallView
      {
         return this.getViewComponent() as GameHallView;
      }
   }
}

