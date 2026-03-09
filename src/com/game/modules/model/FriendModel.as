package com.game.modules.model
{
   import com.core.model.Model;
   import com.game.event.EventConst;
   import com.game.locators.GameData;
   import com.game.locators.MsgDoc;
   import com.game.modules.parse.MAAParse;
   import com.game.modules.view.WindowLayer;
   import com.game.modules.vo.NewsVo;
   import com.game.util.AwardAlert;
   import com.game.util.ChatUtil;
   import com.game.util.FloatAlert;
   import com.publiccomponent.alert.Alert;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import org.green.server.events.MsgEvent;
   import phpcon.PhpConnection;
   
   public class FriendModel extends Model
   {
      
      public static const NAME:String = "friendmodel";
      
      private var cid:Number;
      
      private var cName:String;
      
      private var totalFriends:int;
      
      private var agreeList:Array = [];
      
      private var agreeTid:int = 0;
      
      private var isShowAddFail:Boolean = true;
      
      private var isShowNumOut:Boolean = true;
      
      private var tid:int;
      
      public function FriendModel()
      {
         super(NAME);
      }
      
      override public function onRegister() : void
      {
         registerListener(MsgDoc.OP_CLIENT_GET_FRIENDLIST.back.toString(),this.onFriendListBack);
         registerListener(MsgDoc.OP_CLIENT_GET_BLACKLIST.back.toString(),this.onGetBlackListBack);
         registerListener(MsgDoc.OP_CLIENT_ASK_MAKE_FRIEND.back.toString(),this.addFriendBack);
         registerListener(MsgDoc.OP_WORLD_MAKE_FRIEND.back.toString(),this.makeFriendBack);
         registerListener(MsgDoc.OP_GETAWAY_FRIEND_COM.back.toString(),this.onNewFriendCome);
         registerListener(MsgDoc.OP_GATWAY_GET_BLACK_INFO.back.toString(),this.onNewBlackCome);
         registerListener(MsgDoc.OP_CLIENT_REQ_MASTER.back.toString(),this.onReqMasterBack);
         registerListener(MsgDoc.OP_CLIENT_REQ_APPRENTICE.back.toString(),this.onReqApprenticeBack);
         registerListener(MsgDoc.OP_GATEWAY_MASTER_OR_APPRENTICE.back.toString(),this.onMasterOrApprentice);
         registerListener(MsgDoc.OP_CLIENT_MAA_REQ_FINISH.back.toString(),this.on_MAA_Finish_Back);
         registerListener(MsgDoc.OP_CLIENT_MAA_REQ_DISTRIBUTE.back.toString(),this.on_MAA_Distribute_Back);
         registerListener(MsgDoc.OP_CLIENT_MAA_REQ_EXPEL.back.toString(),this.on_MAA_Expel_Back);
         registerListener(MsgDoc.OP_CLIENT_MAA_REQ_BREAK.back.toString(),this.on_MAA_Break_Back);
         registerListener(MsgDoc.OP_CLIENT_MAA_GOT_THANKS.back.toString(),this.on_MAA_Got_Thanks);
         registerListener(MsgDoc.OP_CLIENT_REQ_FRIEND_ONLINES.back.toString(),this.onOnlinesBack);
      }
      
      private function onFriendListBack(evt:MsgEvent) : void
      {
         var params:Object = null;
         O.traceSocket(evt);
         GameData.instance.friendsList = [];
         this.totalFriends = evt.msg.mParams;
         if(this.totalFriends == -2)
         {
            this.parseFu2Friends(evt);
            return;
         }
         var num:int = evt.msg.body.readInt();
         for(var i:int = 0; i < num; i++)
         {
            params = {};
            params.isOnline = evt.msg.body.readInt();
            params.userId = evt.msg.body.readInt();
            GameData.instance.playerData.tempfriends[String(params.userId)] = 1;
            if(params.userId <= 0)
            {
               if(this.totalFriends > 0)
               {
                  --this.totalFriends;
               }
            }
            else
            {
               params.roleType = evt.msg.body.readInt();
               params.sex = params.roleType & 1;
               params.vip = evt.msg.body.readInt();
               params.lastLoginTime = evt.msg.body.readInt();
               params.historyglory = evt.msg.body.readInt();
               params.familyId = evt.msg.body.readInt();
               params.maxMonsterLevel = evt.msg.body.readInt();
               if(params.userId > 0)
               {
                  params.userName = ChatUtil.onCheckStr(evt.msg.body.readUTF());
               }
               else
               {
                  params.userName = "匿名";
               }
               params.isBlack = 0;
               params.userBeiZhu = evt.msg.body.readUTF();
               GameData.instance.friendsList.push(params);
            }
         }
         GameData.instance.friendsList.sortOn("isOnline",Array.NUMERIC);
         GameData.instance.friendsList.reverse();
         dispatch(EventConst.GETFRIENDLISTBACK);
      }
      
      private function parseFu2Friends(evt:MsgEvent) : void
      {
         var params:Object = null;
         var num:int = evt.msg.body.readInt();
         for(var i:int = 0; i < num; i++)
         {
            params = {};
            params.isOnline = 0;
            params.userId = evt.msg.body.readUnsignedInt();
            GameData.instance.playerData.tempfriends[String(params.userId)] = 1;
            if(params.userId <= 0)
            {
               if(this.totalFriends > 0)
               {
                  --this.totalFriends;
               }
            }
            else
            {
               params.roleType = evt.msg.body.readInt();
               params.sex = params.roleType & 1;
               params.vip = 0;
               params.lastLoginTime = 0;
               params.historyglory = 0;
               params.familyId = 0;
               params.maxMonsterLevel = 0;
               if(params.userId > 0)
               {
                  params.userName = ChatUtil.onCheckStr(evt.msg.body.readUTF());
               }
               else
               {
                  params.userName = "匿名";
               }
               params.isBlack = 0;
               params.userBeiZhu = ChatUtil.onCheckStr(evt.msg.body.readUTF());
               GameData.instance.friendsList.push(params);
            }
         }
      }
      
      private function onOnlinesBack(evt:MsgEvent) : void
      {
         var item:Object = null;
         O.traceSocket(evt);
         evt.msg.body.position = 0;
         var num:int = evt.msg.body.readInt();
         var list:Array = [];
         for(var i:int = 0; i < num; i++)
         {
            list.push(evt.msg.body.readUnsignedInt());
         }
         for each(item in GameData.instance.friendsList)
         {
            if(list.indexOf(item.userId) != -1)
            {
               item.isOnline = 1;
            }
         }
         GameData.instance.friendsList.sortOn(["isOnline","userId"],[Array.DESCENDING,Array.NUMERIC]);
         dispatch(EventConst.GETFRIENDLISTBACK);
      }
      
      private function onGetBlackListBack(evt:MsgEvent) : void
      {
         var params:Object = null;
         O.traceSocket(evt);
         var num:int = evt.msg.mParams;
         var list:Array = [];
         for(var i:int = 0; i < num; i++)
         {
            params = {};
            params.userId = evt.msg.body.readUnsignedInt();
            GameData.instance.playerData.tempfriends[String(params.userId)] = 0;
            if(params.userId > 0)
            {
               params.roleType = evt.msg.body.readInt();
               params.sex = params.roleType & 1;
               if(params.userId > 0)
               {
                  params.userName = ChatUtil.onCheckStr(evt.msg.body.readUTF());
               }
               else
               {
                  params.userName = "";
               }
               params.isOnline = 0;
               params.isBlack = 1;
               list.push(params);
            }
         }
         dispatch(EventConst.GETBLACKFRIENDLISTBACK,list);
      }
      
      private function addFriendBack(evt:MsgEvent) : void
      {
         var roleType:int = 0;
         O.traceSocket(evt);
         this.cid = evt.msg.mParams;
         var fid:uint = uint(evt.msg.mParams);
         if(fid > 0)
         {
            this.cName = ChatUtil.onCheckStr(evt.msg.body.readUTF());
            roleType = evt.msg.body.readInt();
            dispatch(EventConst.ADDFRIENDMSG,{
               "uid":fid,
               "cName":this.cName,
               "type":roleType
            });
         }
         if(fid == -1)
         {
            new Alert().show("查无此人");
         }
         if(fid == -2)
         {
            new Alert().show("请求失败");
         }
         if(fid == -3)
         {
            fid = evt.msg.body.readUnsignedInt();
            this.cName = ChatUtil.onCheckStr(evt.msg.body.readUTF());
            dispatch(EventConst.OPENPERSONINFOVIEW,{
               "userId":fid,
               "isOnline":0,
               "source":0,
               "userName":this.cName,
               "sex":1
            });
         }
      }
      
      private function closeHandler(type:String, data:Object) : void
      {
         if(type == "接受")
         {
            dispatch(EventConst.ACCEPT_OR_REFUSE_FRIENDASK,{
               "type":1,
               "id":this.cid,
               "name":this.cName
            });
         }
         else
         {
            dispatch(EventConst.ACCEPT_OR_REFUSE_FRIENDASK,{
               "type":0,
               "id":this.cid,
               "name":this.cName
            });
         }
      }
      
      private function makeFriendBack(evt:MsgEvent) : void
      {
         O.traceSocket(evt);
         var params:Object = {};
         params.code = evt.msg.mParams;
         switch(params.code)
         {
            case 0:
               params.userId = evt.msg.body.readUnsignedInt();
               params.userName = evt.msg.body.readUTF();
               new Alert().show(ChatUtil.onCheckStr(params.userName) + "(" + params.userId + ")拒绝成为你的好友");
               break;
            case 1:
               params.userId = evt.msg.body.readUnsignedInt();
               params.userName = evt.msg.body.readUTF();
               evt.msg.body.readInt();
               params.acceptId = evt.msg.body.readInt();
               GameData.instance.playerData.tempfriends[String(params.userId)] = 1;
               if(params.acceptId != GameData.instance.playerData.userId)
               {
                  this.agreeList.push(ChatUtil.onCheckStr(params.userName) + "(" + params.userId + ")" + "同意加你为好友");
               }
               else
               {
                  this.agreeList.push("成功添加 " + ChatUtil.onCheckStr(params.userName) + "(" + params.userId + ")为好友");
               }
               this.showAgreeTips();
               dispatch("get_my_friends_list");
               break;
            case -3:
               if(this.isShowNumOut)
               {
                  new Alert().show("您当前的好友列表已满",this.onNumOutClose);
                  this.isShowNumOut = false;
               }
               break;
            case -4:
               if(this.isShowAddFail)
               {
                  new Alert().show("添加好友失败",this.onAddFailClose);
                  this.isShowAddFail = false;
               }
         }
      }
      
      private function onNumOutClose(... param) : void
      {
         this.isShowNumOut = true;
      }
      
      private function onAddFailClose(... param) : void
      {
         this.isShowAddFail = true;
      }
      
      private function showAgreeTips() : void
      {
         if(this.agreeTid == 0)
         {
            this.agreeTid = setInterval(this.onShowAgreeTips,500);
         }
      }
      
      private function onShowAgreeTips() : void
      {
         if(this.agreeList.length > 0)
         {
            new FloatAlert().show(WindowLayer.instance,300,400,this.agreeList.shift(),6,300);
         }
         else
         {
            clearInterval(this.agreeTid);
            this.agreeTid = 0;
         }
      }
      
      private function onNewFriendCome(evt:MsgEvent) : void
      {
         var params:Object = null;
         O.traceSocket(evt);
         clearInterval(this.tid);
         this.tid = setInterval(this.delayShow,1000);
         var num:int = evt.msg.body.readInt();
         for(var i:int = 0; i < num; i++)
         {
            params = {};
            params.isOnline = evt.msg.body.readInt();
            params.userId = evt.msg.body.readUnsignedInt();
            GameData.instance.playerData.tempfriends[String(params.userId)] = 1;
            if(params.userId <= 0)
            {
               O.o("错误的ID" + params.userId);
               if(this.totalFriends > 0)
               {
                  --this.totalFriends;
               }
            }
            else
            {
               params.roleType = evt.msg.body.readInt();
               params.sex = params.roleType & 1;
               params.vip = evt.msg.body.readInt();
               params.lastLoginTime = evt.msg.body.readInt();
               params.historyglory = evt.msg.body.readInt();
               params.familyId = evt.msg.body.readInt();
               params.maxMonsterLevel = evt.msg.body.readInt();
               if(params.userId > 0)
               {
                  params.userName = ChatUtil.onCheckStr(evt.msg.body.readUTF());
               }
               else
               {
                  params.userName = "匿名";
               }
               params.isBlack = 0;
               params.userBeiZhu = ChatUtil.onCheckStr(evt.msg.body.readUTF());
               GameData.instance.friendsList.push(params);
            }
         }
      }
      
      private function delayShow() : void
      {
         clearInterval(this.tid);
         GameData.instance.friendsList.sortOn("isOnline",Array.NUMERIC);
         GameData.instance.friendsList.reverse();
         dispatch(EventConst.GETFRIENDLISTBACK);
      }
      
      private function onNewBlackCome(evt:MsgEvent) : void
      {
         var params:Object = null;
         O.traceSocket(evt);
         var list:Array = [];
         var num:int = evt.msg.body.readInt();
         for(var i:int = 0; i < num; i++)
         {
            params = {};
            params.userId = evt.msg.body.readUnsignedInt();
            GameData.instance.playerData.tempfriends[String(params.userId)] = 0;
            if(params.userId > 0)
            {
               params.roleType = evt.msg.body.readInt();
               params.sex = params.roleType & 1;
               if(params.userId > 0)
               {
                  params.userName = ChatUtil.onCheckStr(evt.msg.body.readUTF());
               }
               else
               {
                  params.userName = "";
               }
               params.isOnline = 0;
               params.isBlack = 1;
               list.push(params);
            }
         }
         dispatch(EventConst.ONNEWBLACKCOME,list);
      }
      
      private function onReqMasterBack(evt:MsgEvent) : void
      {
         O.traceSocket(evt);
         new MAAParse().parse(evt.msg);
      }
      
      private function onReqApprenticeBack(evt:MsgEvent) : void
      {
         O.traceSocket(evt);
         new MAAParse().parse2(evt.msg);
      }
      
      private function onMasterOrApprentice(evt:MsgEvent) : void
      {
         O.traceSocket(evt);
         var params:Object = new MAAParse().parse1(evt.msg);
         var obj:NewsVo = new NewsVo();
         obj.data = params;
         obj.msg = params.msg;
         obj.linkMsg = params.linkMsg;
         obj.alertType = 1;
         obj.type = 6;
         obj.linkHanlder = this.onClickPersonMsgLink;
         obj.mytype = 1;
         GameData.instance.boxMessagesArray.push(obj);
         GameData.instance.showMessagesCome();
      }
      
      private function onClickPersonMsgLink(... rest) : void
      {
         var param:Object = rest[1];
         dispatch(EventConst.OPENPERSONINFOVIEW,{
            "userId":param.data.id,
            "isOnline":0,
            "source":0,
            "userName":param.data.name,
            "sex":1
         });
      }
      
      private function on_MAA_Finish_Back(evt:MsgEvent) : void
      {
         var count:int = 0;
         var idd:int = 0;
         var name:String = null;
         var id:int = 0;
         var money:int = 0;
         var exp:int = 0;
         var master:String = null;
         O.traceSocket(evt);
         var o:NewsVo = new NewsVo();
         var oo:NewsVo = new NewsVo();
         if(evt.msg.mParams == 1)
         {
            idd = evt.msg.body.readInt();
            name = evt.msg.body.readUTF();
            count = evt.msg.body.readInt();
            o.msg = "恭喜你的徒弟【" + ChatUtil.onCheckStr(name) + "】顺利出师!";
            o.alertType = 3;
            o.type = 6;
            GameData.instance.boxMessagesArray.push(o);
            PhpConnection.instance().insertMAAMessage(name,503);
         }
         else if(evt.msg.mParams == 2)
         {
            id = evt.msg.body.readInt();
            money = evt.msg.body.readInt();
            exp = evt.msg.body.readInt();
            count = evt.msg.body.readInt();
            if(money > 0)
            {
               new AwardAlert().showMoneyAward(money,WindowLayer.instance);
            }
            if(exp > 0)
            {
               new AwardAlert().showExpAward(exp,WindowLayer.instance);
            }
            o.msg = "恭喜你顺利出师!";
            o.alertType = 6;
            o.type = 6;
            GameData.instance.boxMessagesArray.push(o);
            dispatch(EventConst.MAA_REQ_LIST);
            master = PhpConnection.instance().messageList.shift() as String;
            if(master == null)
            {
               master = "师父";
            }
            PhpConnection.instance().insertMAAMessage(master,502);
         }
         switch(count)
         {
            case 1:
               if(evt.msg.mParams == 1)
               {
                  oo.msg = "获得荣誉【育人良师】";
                  oo.alertType = 6;
                  oo.type = 6;
                  GameData.instance.boxMessagesArray.push(oo);
               }
               else
               {
                  oo.msg = "获得荣誉【出类拔萃】";
                  oo.alertType = 6;
                  oo.type = 6;
                  GameData.instance.boxMessagesArray.push(oo);
               }
               break;
            case 2:
               if(evt.msg.mParams == 1)
               {
                  oo.msg = "获得荣誉【诲人不倦】";
                  oo.alertType = 6;
                  oo.type = 6;
                  GameData.instance.boxMessagesArray.push(oo);
               }
               else
               {
                  oo.msg = "获得荣誉【小有名气】";
                  oo.alertType = 6;
                  oo.type = 6;
                  GameData.instance.boxMessagesArray.push(oo);
               }
               break;
            case 3:
               if(evt.msg.mParams == 1)
               {
                  oo.msg = "获得荣誉【一代名师】";
                  oo.alertType = 6;
                  oo.type = 6;
                  GameData.instance.boxMessagesArray.push(oo);
               }
               else
               {
                  oo.msg = "获得荣誉【名声远播】";
                  oo.alertType = 6;
                  oo.type = 6;
                  GameData.instance.boxMessagesArray.push(oo);
               }
               break;
            case 5:
               oo.msg = "获得荣誉【桃李满天下】";
               oo.alertType = 6;
               oo.type = 6;
               GameData.instance.boxMessagesArray.push(oo);
               break;
            case 10:
               oo.msg = "获得荣誉【圣师传说】";
               oo.alertType = 6;
               oo.type = 6;
               GameData.instance.boxMessagesArray.push(oo);
         }
         GameData.instance.showMessagesCome();
      }
      
      private function on_MAA_Distribute_Back(evt:MsgEvent) : void
      {
         var params:Object = null;
         var flag:int = 0;
         O.traceSocket(evt);
         if(evt.msg.mParams == 1)
         {
            params = {};
            params.thanks0 = evt.msg.body.readInt();
            params.thanks1 = evt.msg.body.readInt();
            params.flag = evt.msg.body.readInt();
            params.name = evt.msg.body.readUTF();
            new Alert().showOne("【" + params.name + "】向你贡献了" + params.thanks0 + "点感恩值!");
            PhpConnection.instance().insertMAAMessage(params.name,201,params.thanks0);
         }
         else if(evt.msg.mParams == 2)
         {
            flag = evt.msg.body.readInt();
            if(flag == 1)
            {
               new FloatAlert().show(WindowLayer.instance,300,400,"分配感恩值成功!");
               dispatch(EventConst.MAA_REQ_LIST);
            }
            else if(flag == -1)
            {
               new FloatAlert().show(WindowLayer.instance,300,400,"分配失败，请按规则分配！");
            }
         }
      }
      
      private function on_MAA_Expel_Back(evt:MsgEvent) : void
      {
         var o:NewsVo = null;
         O.traceSocket(evt);
         var name:String = "";
         name = PhpConnection.instance().messageList.shift() as String;
         if(name == null)
         {
            name = "徒弟";
         }
         if(evt.msg.mParams == 1)
         {
            new Alert().showOne("成功与该徒弟解除了师徒关系");
            dispatch(EventConst.MAA_REQ_LIST);
            PhpConnection.instance().insertMAAMessage(name,404);
         }
         else if(evt.msg.mParams == -1)
         {
            new Alert().show("踢掉徒弟的时间不够");
         }
         else if(evt.msg.mParams == 2)
         {
            name = evt.msg.body.readUTF();
            o = new NewsVo();
            o.msg = "很遗憾，你的师父【" + ChatUtil.onCheckStr(name) + "】解除了与你的师徒关系，你将进入1天师徒冻结期。";
            o.alertType = 4;
            o.type = 6;
            GameData.instance.boxMessagesArray.push(o);
            PhpConnection.instance().insertMAAMessage(name,401);
         }
      }
      
      private function on_MAA_Break_Back(evt:MsgEvent) : void
      {
         var result:int = 0;
         var o:NewsVo = null;
         O.traceSocket(evt);
         var name:String = "";
         name = PhpConnection.instance().messageList.shift() as String;
         if(name == null)
         {
            name = "师父";
         }
         if(evt.msg.mParams == 1)
         {
            new Alert().show("成功与该师父解除了师徒关系");
            PhpConnection.instance().insertMAAMessage(name,403);
            dispatch(EventConst.MAA_REQ_LIST);
         }
         else if(evt.msg.mParams == -1)
         {
            new Alert().show("踢掉师父的时间不够");
         }
         else if(evt.msg.mParams == 2)
         {
            name = evt.msg.body.readUTF();
            result = evt.msg.body.readInt();
            o = new NewsVo();
            if(result == 1)
            {
               o.msg = "很遗憾，你的徒弟【" + ChatUtil.onCheckStr(name) + "】解除了与你的师徒关系。";
            }
            else
            {
               o.msg = "很遗憾，你的徒弟【" + ChatUtil.onCheckStr(name) + "】解除了与你的师徒关系，你将进入1天师徒冻结期。";
            }
            o.alertType = 4;
            o.type = 6;
            GameData.instance.boxMessagesArray.push(o);
            PhpConnection.instance().insertMAAMessage(name,402);
         }
         GameData.instance.showMessagesCome();
      }
      
      private function on_MAA_Got_Thanks(evt:MsgEvent) : void
      {
         O.traceSocket(evt);
         var curruntThanks:int = evt.msg.body.readInt();
         var thanks:int = evt.msg.body.readInt();
         var o:NewsVo = new NewsVo();
         o.type = 6;
         if(evt.msg.mParams == 1)
         {
            o.msg = "恭喜你获得了" + thanks + "点感恩值!";
            o.alertType = 6;
            GameData.instance.boxMessagesArray.push(o);
         }
         else if(evt.msg.mParams == 2)
         {
            o.msg = "已成功将" + thanks + "点感恩值分配给了你的师父!";
            o.alertType = 4;
            GameData.instance.boxMessagesArray.push(o);
         }
         GameData.instance.showMessagesCome();
      }
   }
}

