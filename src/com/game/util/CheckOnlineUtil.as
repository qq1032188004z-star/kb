package com.game.util
{
   import com.game.global.GlobalConfig;
   import com.game.locators.MsgDoc;
   import flash.events.EventDispatcher;
   import org.green.server.core.GreenSocket;
   import org.green.server.events.MsgEvent;
   import org.green.server.manager.SocketManager;
   
   public class CheckOnlineUtil extends EventDispatcher
   {
      
      public static var Instance:CheckOnlineUtil = new CheckOnlineUtil();
      
      private var socket:GreenSocket = SocketManager.getGreenSocket();
      
      private var checkUid:int = 0;
      
      private var onlineHandler:Function;
      
      private var notOnlineHandler:Function;
      
      private var callData:Object;
      
      public function CheckOnlineUtil()
      {
         super();
      }
      
      public function checkIsOnline(uid:int = 0, onlineCallback:Function = null, notOnlineCallback:Function = null, calldata:Object = null) : void
      {
         this.checkUid = uid;
         this.onlineHandler = onlineCallback;
         this.notOnlineHandler = notOnlineCallback;
         this.callData = calldata;
         this.socket.removeEventListener(MsgDoc.OP_CLIENT_REQ_FRIEND_ONLINES.back,this.onCheckOnlineBack);
         this.socket.addEventListener(MsgDoc.OP_CLIENT_REQ_FRIEND_ONLINES.back,this.onCheckOnlineBack);
         this.socket.sendCmd(MsgDoc.OP_CLIENT_REQ_FRIEND_ONLINES.send,GlobalConfig.userId,[1,uid]);
      }
      
      private function onCheckOnlineBack(evt:MsgEvent) : void
      {
         var uid:int = 0;
         if(this.checkUid == 0)
         {
            return;
         }
         evt.msg.body.position = 0;
         var num:int = evt.msg.body.readInt();
         var list:Array = [];
         var flag:int = 0;
         for(var i:int = 0; i < num; i++)
         {
            uid = evt.msg.body.readInt();
            list.push(uid);
            if(uid == this.checkUid)
            {
               flag = 1;
            }
         }
         if(flag == 1)
         {
            if(this.onlineHandler != null)
            {
               this.onlineHandler.apply(null,[this.callData]);
            }
         }
         else if(this.notOnlineHandler != null)
         {
            this.notOnlineHandler.apply(null,[this.callData]);
         }
         this.socket.removeEventListener(MsgDoc.OP_CLIENT_REQ_FRIEND_ONLINES.back,this.onCheckOnlineBack);
      }
   }
}

