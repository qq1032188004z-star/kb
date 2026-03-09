package com.game.modules.model
{
   import com.core.model.Model;
   import com.game.event.EventConst;
   import com.game.global.GlobalConfig;
   import com.game.locators.MsgDoc;
   import org.green.server.events.MsgEvent;
   
   public class ChatModel extends Model
   {
      
      public static const NAME:String = "chatmodel";
      
      public function ChatModel()
      {
         super(NAME);
      }
      
      override public function onRegister() : void
      {
         registerListener(MsgDoc.OP_CLIENT_GET_CHAT_DRESS.back.toString(),this.getChatDressBack);
         registerListener(MsgDoc.OP_CLIENT_CHAT.back.toString(),this.onChatBack);
         registerListener(MsgDoc.OP_CLIENT_FAMILY_CHAT.back.toString(),this.onMutilChatBack);
      }
      
      private function getChatDressBack(evt:MsgEvent) : void
      {
         O.traceSocket(evt);
         var params:Object = {};
         params.userId = evt.msg.body.readUnsignedInt();
         if(params.userId > 0)
         {
            params.roleType = evt.msg.body.readInt();
            params.hatId = evt.msg.body.readInt();
            params.clothId = evt.msg.body.readInt();
            params.weaponId = evt.msg.body.readInt();
            params.footId = evt.msg.body.readInt();
            params.faceId = evt.msg.body.readInt();
            params.wingId = evt.msg.body.readInt();
            params.glassId = evt.msg.body.readInt();
            params.leftWeapon = evt.msg.body.readInt();
            params.taozhuangId = evt.msg.body.readInt();
            this.dispatch(EventConst.GETCHATDRESSBACK,params);
         }
      }
      
      private function onChatBack(event:MsgEvent) : void
      {
         O.traceSocket(event);
         var params:Object = {};
         params.id = event.msg.mParams;
         params.type = event.msg.body.readInt();
         if(params.type == 0)
         {
            params.flag = event.msg.body.readInt();
            params.from_id = event.msg.body.readInt();
            params.from_name = event.msg.body.readUTF();
            params.content = event.msg.body.readUTF();
         }
         else if(params.type == 3)
         {
            params.flag = event.msg.body.readInt();
            params.from_id = event.msg.body.readInt();
            params.from_name = event.msg.body.readUTF();
            params.content = event.msg.body.readUTF();
            params.roleType = event.msg.body.readInt();
            params.isBlack = 0;
            params.isOnline = 1;
            params.vip = 0;
            params.family = 0;
            params.userName = params.from_name;
            params.userId = params.from_id;
         }
         else
         {
            params.flag = event.msg.body.readInt();
            params.content = event.msg.body.readUTF();
         }
         if(params.type == 0)
         {
            dispatch(EventConst.SENDPRIMSGBACK,params);
         }
         else if(params.type == 3)
         {
            dispatch(EventConst.FAMILYPRIMSGBACK,params);
         }
         else
         {
            dispatch(EventConst.SENDPUBLICKMSGBACK,params);
         }
      }
      
      private function onMutilChatBack(evt:MsgEvent) : void
      {
         O.traceSocket(evt);
         var result:Object = {};
         if(evt.msg.body != null)
         {
            try
            {
               result.uid = evt.msg.body.readInt();
               result.userName = evt.msg.body.readUTF();
               result.msg = evt.msg.body.readUTF();
            }
            catch(e:*)
            {
            }
         }
         if(result.uid == GlobalConfig.userId)
         {
            return;
         }
         dispatch(EventConst.MUTILCHATBACK,result);
      }
   }
}

