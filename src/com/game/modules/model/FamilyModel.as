package com.game.modules.model
{
   import com.core.model.Model;
   import com.game.comm.AlertUtil;
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.locators.GameData;
   import com.game.locators.MsgDoc;
   import com.game.manager.AlertManager;
   import com.game.modules.control.family.FamilyControl;
   import com.game.modules.view.MapView;
   import com.game.modules.view.WindowLayer;
   import com.game.modules.view.family.FamilyCheckIn;
   import com.game.modules.view.family.FamilyContribution;
   import com.game.modules.vo.NewsVo;
   import com.game.util.CacheUtil;
   import com.game.util.ChatUtil;
   import com.game.util.FloatAlert;
   import com.game.util.HtmlUtil;
   import com.publiccomponent.alert.Alert;
   import org.green.server.events.MsgEvent;
   
   public class FamilyModel extends Model
   {
      
      public static const NAME:String = "familymodel";
      
      public function FamilyModel()
      {
         super(NAME);
         ApplicationFacade.getInstance().registerViewLogic(new FamilyControl());
      }
      
      override public function onRegister() : void
      {
         registerListener(MsgDoc.OP_GATEWAY_FAMILY_STATE.back.toString(),this.on_StateBack);
         registerListener(MsgDoc.OP_CLIENT_REQ_CREATE_FAMILY.back.toString(),this.on_CreateBack);
         registerListener(MsgDoc.OP_GATEWAY_FAMILY_JOIN.back.toString(),this.on_OthersJoin);
         registerListener(MsgDoc.OP_GATEWAY_FAMILY_LEADER.back.toString(),this.on_LeaderHandler);
         registerListener(MsgDoc.OP_CLIENT_REQ_JOININ_FAMILY.back.toString(),this.on_JoinInBack);
         registerListener(MsgDoc.OP_CLIENT_REQ_FAMILY_INFO.back.toString(),this.on_FamilyInfoBack);
         registerListener(MsgDoc.OP_CLIENT_INVITE_JOIN_FAMILY.back.toString(),this.on_InviteJoinBack);
         registerListener(MsgDoc.OP_CLIENT_REQ_EXIT_FAMILY.back.toString(),this.on_ExitFamilyBack);
         registerListener(MsgDoc.OP_CLIENT_REQ_TRANS_LEADER.back.toString(),this.on_TransLeaderBack);
         registerListener(MsgDoc.OP_CLIENT_REQ_FAMILY_MEMBERS.back.toString(),this.on_MembersBack);
         registerListener(MsgDoc.OP_CLIENT_REQ_CHANGE_NOTICE.back.toString(),this.on_ChangeNoticeBack);
         registerListener(MsgDoc.OP_CLIENT_REQ_CHANGE_INFO.back.toString(),this.on_ChangeIofoBack);
         registerListener(MsgDoc.OP_CLIENT_REQ_CHANGE_LEVEL.back.toString(),this.on_ChangeLevelBack);
         registerListener(MsgDoc.OP_CLIENT_REQ_FIRE_MEMBER.back.toString(),this.on_FireMemberBack);
         registerListener(MsgDoc.OP_GATEWAY_FAMILY_FIRED.back.toString(),this.on_FamilyFired);
         registerListener(MsgDoc.OP_CLIENT_REQ_ENTER_FAMILY_BASE.back.toString(),this.on_EnterBaseBack);
         registerListener(MsgDoc.OP_CLIENT_REQPLAYER_STATE.back.toString(),this.on_PlayerStateBack);
         registerListener(MsgDoc.OP_CLIENT_REQ_FAMILY_CHECK_IN.back.toString(),this.on_CheckInBack);
         registerListener(MsgDoc.OP_GATEWAY_FAMILY_SUIT.back.toString(),this.on_SuitBack);
         registerListener(MsgDoc.OP_CLIENT_REQ_FAMILY_CONTRIBUTION.back.toString(),this.on_ContributionBack);
         registerListener(MsgDoc.OP_CLIENT_REQ_FAMILY_TASK_HELP_PINZHI.back.toString(),this.taskHelpPinZhiBack);
         registerListener(MsgDoc.OP_CLIENT_REQ_FAMILY_TASK_PINZHI.back.toString(),this.taskUpdatePinZhiBack);
         registerListener(MsgDoc.OP_GATEWAY_FAMILY_STAR_TIPS.back.toString(),this.on_FamilyStarTips);
         registerListener(MsgDoc.OP_GATEWAY_FAMILY_STAR_TIPS.back.toString(),this.on_FamilyStarTips);
         registerListener(MsgDoc.OP_CLIENT_REQ_FAMILY_RENAME.back.toString(),this.on_FamilyRename);
      }
      
      private function on_FamilyRename(evt:MsgEvent) : void
      {
         var familyName:String = null;
         O.traceSocket(evt);
         var data:Object = {};
         data.param = evt.msg.mParams;
         var code:int = evt.msg.body.readInt();
         switch(code)
         {
            case 0:
               AlertManager.instance.addTipAlert({
                  "tip":"家族名修改成功",
                  "type":1
               });
               familyName = evt.msg.body.readUTF();
               dispatch(EventConst.RECORD_FAMILY_RENAME,{"familyName":familyName});
               break;
            case 1:
               AlertUtil.showNoCopperView();
               break;
            case 2:
               AlertManager.instance.addTipAlert({
                  "tip":"未加入任何家族",
                  "type":1
               });
               break;
            case 3:
               AlertManager.instance.addTipAlert({
                  "tip":"家族名出含有违规字符，请重新编辑",
                  "type":1
               });
               break;
            case 4:
               AlertManager.instance.addTipAlert({
                  "tip":"没有权限",
                  "type":1
               });
               break;
            case 5:
               AlertManager.instance.addTipAlert({
                  "tip":"该家族名称已被使用！",
                  "type":1
               });
         }
      }
      
      private function on_StateBack(evt:MsgEvent) : void
      {
         var uid:int = 0;
         var familyStar:int = 0;
         try
         {
            GameData.instance.playerData.family_id = evt.msg.body.readInt();
            uid = evt.msg.body.readInt();
            GameData.instance.playerData.family_level = evt.msg.body.readInt();
            GameData.instance.playerData.family_war_state = evt.msg.body.readInt();
            familyStar = evt.msg.body.readInt();
            GameData.instance.playerData.familyAllName = evt.msg.body.readUTF();
            GameData.instance.playerData.familyName = evt.msg.body.readUTF();
            MapView.instance.masterPerson.updateFlagName(GameData.instance.playerData.familyName);
         }
         catch(e:*)
         {
         }
      }
      
      private function on_CreateBack(evt:MsgEvent) : void
      {
         O.traceSocket(evt);
         if(evt.msg.mParams == 0)
         {
            GameData.instance.playerData.create_flag = true;
            dispatch(EventConst.OPENSWFWINDOWS,{
               "url":"assets/family/familyTreaty.swf",
               "xCoord":130,
               "yCoord":0
            });
         }
         else if(evt.msg.mParams == 1)
         {
            try
            {
               GameData.instance.playerData.family_id = evt.msg.body.readInt();
               GameData.instance.playerData.family_level = 1;
               GameData.instance.playerData.create_flag = false;
               GameData.instance.playerData.coin -= 10000;
               dispatch(EventConst.ERQ_CREATE_FAMILY_BACK);
               AlertManager.instance.showTipAlert({
                  "systemid":1026,
                  "flag":1
               });
            }
            catch(e:*)
            {
               O.o("\n\n\n请求创建家族返回: " + e + "\n\n\n");
            }
         }
         else
         {
            if(evt.msg.mParams == -6)
            {
               evt.msg.mParams = -4;
            }
            AlertManager.instance.showTipAlert({
               "systemid":1026,
               "flag":evt.msg.mParams
            });
         }
      }
      
      private function on_OthersJoin(evt:MsgEvent) : void
      {
         var count:int = 0;
         var user:Object = null;
         var i:int = 0;
         var b:Boolean = false;
         var bl:int = 0;
         var tv:NewsVo = null;
         var n:int = 0;
         var o:NewsVo = null;
         try
         {
            O.traceSocket(evt);
            count = evt.msg.body.readInt();
            if(GameData.instance.boxMessagesArray.length >= count && count > 1)
            {
               return;
            }
            for(i = 0; i < count; i++)
            {
               user = {};
               user.f_id = evt.msg.body.readUTF();
               user.uid = evt.msg.body.readInt();
               user.uname = ChatUtil.onCheckStr(evt.msg.body.readUTF());
               user.sex = evt.msg.body.readInt();
               user.pnum = evt.msg.body.readInt();
               user.lnum = evt.msg.body.readInt();
               user.familyAdd = 1;
               b = true;
               bl = int(GameData.instance.boxMessagesArray.length);
               for(n = 0; n < bl; n++)
               {
                  tv = GameData.instance.boxMessagesArray[n];
                  if(tv.type == 2 && tv.ao && Boolean(tv.ao.l) && tv.ao.l[2] == user.uid)
                  {
                     b = false;
                     break;
                  }
               }
               if(b)
               {
                  o = new NewsVo();
                  o.data = user;
                  o.msg = HtmlUtil.getHtmlText(13,"#ff0000","<a href=\"event:\">【" + ChatUtil.onCheckStr(user.uname) + "】</a><br>") + "申请加入家族，你同意吗？";
                  o.linkHanlder = this.othersJoinLinkHandler;
                  o.alertType = 1;
                  o.type = 2;
                  o.ao = {
                     "s":1185283,
                     "m":0,
                     "l":[0,String(user.f_id),int(user.uid),String(user.uname),int(user.sex),int(user.pnum),int(user.lnum)]
                  };
                  o.ro = {
                     "s":1185283,
                     "m":0,
                     "l":[1,String(user.f_id),int(user.uid),String(user.uname),int(user.sex),int(user.pnum),int(user.lnum)]
                  };
                  GameData.instance.boxMessagesArray.push(o);
                  GameData.instance.showMessagesCome();
               }
               O.o("第【" + (i + 1) + "】个   " + user.uid + "  " + user.uname);
            }
         }
         catch(e:*)
         {
            O.o("\n\n\n有人要加入我的家族: " + e + "\n\n\n");
         }
      }
      
      private function othersJoinLinkHandler(... rest) : void
      {
         var vo:NewsVo = rest[1] as NewsVo;
         var obj:Object = {
            "userId":vo.ao.l[2],
            "isOnline":1,
            "source":0,
            "userName":vo.ao.l[3],
            "sex":1
         };
         dispatch(EventConst.OPENPERSONINFOVIEW,obj);
      }
      
      private function on_LeaderHandler(evt:MsgEvent) : void
      {
         var uid:int = 0;
         var uname:String = null;
         var familyId:int = 0;
         var familyName:String = null;
         var flag:int = 0;
         var o:NewsVo = null;
         var po:NewsVo = null;
         try
         {
            O.traceSocket(evt);
            uid = evt.msg.body.readInt();
            uname = ChatUtil.onCheckStr(evt.msg.body.readUTF());
            familyId = evt.msg.body.readInt();
            familyName = evt.msg.body.readUTF();
            flag = evt.msg.body.readInt();
            o = new NewsVo();
            if(flag == 1)
            {
               GameData.instance.playerData.family_id = familyId;
               GameData.instance.playerData.family_level = 5;
               o.msg = "【" + uname + "(" + uid + ")" + "】同意让你加入家族!";
               o.alertType = 3;
               o.type = 2;
               GameData.instance.boxMessagesArray.push(o);
               po = new NewsVo();
               po.msg = "恭喜你成为了【" + familyName + "】家族的一员！";
               po.alertType = 3;
               po.type = 2;
               GameData.instance.boxMessagesArray.push(po);
            }
            else if(flag == 0)
            {
               o.msg = "【" + uname + "】拒绝了你的加入家族请求。";
               o.alertType = 3;
               o.type = 2;
               GameData.instance.boxMessagesArray.push(o);
            }
            else if(flag == 2)
            {
               o.msg = "对方已经是本家族成员。";
               o.alertType = 3;
               o.type = 2;
               GameData.instance.boxMessagesArray.push(o);
            }
            else if(flag == 3)
            {
               o.msg = "对方已经加入了其他家族。";
               o.alertType = 3;
               o.type = 2;
               GameData.instance.boxMessagesArray.push(o);
            }
            else if(flag == 4)
            {
               o.msg = "家族已满员，无法再加入成员。";
               o.alertType = 3;
               o.type = 2;
               GameData.instance.boxMessagesArray.push(o);
            }
            GameData.instance.showMessagesCome();
         }
         catch(e:*)
         {
            O.o("\n\n\n族长对你加入家族的申请处理: " + e + "\n\n\n");
         }
      }
      
      private function on_JoinInBack(evt:MsgEvent) : void
      {
         var flag:int = 0;
         var familyId:int = 0;
         var familyName:String = null;
         var o:NewsVo = null;
         try
         {
            O.traceSocket(evt);
            flag = evt.msg.body.readInt();
            familyId = evt.msg.body.readInt();
            familyName = evt.msg.body.readUTF();
            if(flag == 0)
            {
               GameData.instance.playerData.family_id = familyId;
               GameData.instance.playerData.family_level = 5;
               o = new NewsVo();
               o.alertType = 3;
               o.type = 2;
               o.msg = "恭喜你成为了【" + familyName + "】家族的一员！";
               GameData.instance.boxMessagesArray.push(o);
               GameData.instance.showMessagesCome();
            }
            else
            {
               AlertManager.instance.showTipAlert({
                  "systemid":1027,
                  "flag":flag,
                  "defaultTip":true
               });
            }
         }
         catch(e:*)
         {
            O.o("\n\n\n请求加入某个家族返回: " + e + "\n\n\n");
         }
      }
      
      private function on_FamilyInfoBack(evt:MsgEvent) : void
      {
         var body:Object = null;
         if(evt.msg.mParams == -1)
         {
            new FloatAlert().show(WindowLayer.instance,300,400,"该家族已经不存在了！",5,300);
            dispatch(EventConst.REQ_FAMILY_INFO_FAILED);
            return;
         }
         try
         {
            body = {};
            body.sn = evt.msg.body.readInt();
            body.f_number = evt.msg.body.readInt();
            if(body.f_number > 0)
            {
               body.f_name = evt.msg.body.readUTF();
               body.notice = evt.msg.body.readUTF();
               body.setting = evt.msg.body.readInt();
               body.midid = evt.msg.body.readInt();
               body.smallid = evt.msg.body.readInt();
               body.midcolor = evt.msg.body.readInt();
               body.circolor = evt.msg.body.readInt();
               body._name = evt.msg.body.readUTF();
               body.f_leaderId = evt.msg.body.readInt();
               body.f_leader = ChatUtil.onCheckStr(evt.msg.body.readUTF());
               body.f_members = evt.msg.body.readInt();
               body.f_monsters = evt.msg.body.readInt();
               body.f_upLevels = evt.msg.body.readInt();
               body.badge_id = evt.msg.body.readInt();
               if(body.badge_id > 0)
               {
                  body.midid = body.badge_id;
                  body.smallid = body.badge_id;
               }
               body.trans_time = evt.msg.body.readInt();
               body.trans_id = evt.msg.body.readInt();
               body.trans_name = ChatUtil.onCheckStr(evt.msg.body.readUTF());
               body.f_shili = evt.msg.body.readInt();
               body.star_level = evt.msg.body.readInt();
               body.contribute = evt.msg.body.readInt();
               body.preserve = evt.msg.body.readInt();
               body.exitFamilyTimes = evt.msg.body.readInt();
               body.showX = 0;
               body.showY = 0;
               O.o(body.f_number + " 成员数量 " + body.f_members + " 宠物数量" + body.f_monsters);
            }
            dispatch(EventConst.REQ_FAMILY_INFO_BACK,body);
            O.o(GameData.instance.playerData.family_id.toString());
            if(GameData.instance.playerData.family_id == body.f_number)
            {
               GameData.instance.playerData.family_leader_id = body.f_leaderId;
            }
            if(body.sn == 6666)
            {
               GameData.instance.playerData.familyAllName = body.f_name;
               GameData.instance.playerData.familyName = body._name;
               if(Boolean(MapView.instance.masterPerson))
               {
                  MapView.instance.masterPerson.updateFlagName(body._name);
               }
            }
         }
         catch(e:*)
         {
            O.o("\n\n\n获取家族信息返回: " + e + "\n\n\n");
         }
      }
      
      public function on_InviteJoinBack(evt:MsgEvent) : void
      {
         var params:Object;
         var o:NewsVo = null;
         O.traceSocket(evt);
         params = {};
         params.familyId = evt.msg.mParams;
         try
         {
            o = new NewsVo();
            params.uid = evt.msg.body.readInt();
            params.uname = ChatUtil.onCheckStr(evt.msg.body.readUTF());
            params.familyInvite = 1;
            o.msg = "【" + params.uname + "】" + "邀请你加入TA的家族，你同意吗？";
            o.mytype = 2;
            o.alertType = 1;
            o.type = 2;
            o.ao = {
               "s":1185282,
               "m":0,
               "l":[int(params.familyId)]
            };
            GameData.instance.boxMessagesArray.push(o);
            GameData.instance.showMessagesCome();
         }
         catch(e:*)
         {
            O.o("\n\n\n被邀请加入家族返回: " + e + "\n\n\n");
         }
      }
      
      private function on_ExitFamilyBack(evt:MsgEvent) : void
      {
         var flag:int = 0;
         try
         {
            O.traceSocket(evt);
            flag = evt.msg.body.readInt();
            if(flag == 0)
            {
               if(GameData.instance.playerData.family_base_id == GameData.instance.playerData.family_id)
               {
                  this.getOutOfMyFamily();
               }
               GameData.instance.playerData.familyId = 0;
               GameData.instance.playerData.family_id = 0;
               GameData.instance.playerData.family_level = 0;
            }
            AlertManager.instance.showTipAlert({
               "systemid":1028,
               "flag":flag,
               "defaultTip":true
            });
            dispatch(EventConst.FAMILY_EXIT_BACK,{"flag":flag});
         }
         catch(e:*)
         {
            O.o("\n\n\n请求退出家族返回: " + e + "\n\n\n");
         }
      }
      
      private function on_TransLeaderBack(evt:MsgEvent) : void
      {
         var option:int = 0;
         var flag:int = 0;
         try
         {
            O.traceSocket(evt);
            option = evt.msg.body.readInt();
            flag = evt.msg.body.readInt();
            if(option == 0)
            {
               if(flag != -1)
               {
                  dispatch(EventConst.FAMILY_TRANS_BACK);
                  flag = -1000;
               }
               AlertManager.instance.showTipAlert({
                  "systemid":1029,
                  "flag":0,
                  "params":flag
               });
            }
            else
            {
               if(flag != -1)
               {
                  flag = -1000;
               }
               AlertManager.instance.showTipAlert({
                  "systemid":1029,
                  "flag":-1000,
                  "params":flag
               });
            }
         }
         catch(e:*)
         {
            O.o("\n\n\n请求转移族长返回: " + e + "\n\n\n");
         }
      }
      
      private function on_MembersBack(evt:MsgEvent) : void
      {
         var version:int = 0;
         var count:int = 0;
         var list:Array = null;
         var user:Object = null;
         var i:int = 0;
         var abc:Object = null;
         var j:int = 0;
         if(evt.msg.mParams == -1)
         {
            return;
         }
         try
         {
            O.traceSocket(evt);
            version = evt.msg.body.readInt();
            if(version == 2 || version == 4 || version == 5)
            {
               return;
            }
            count = evt.msg.body.readInt();
            list = [];
            if(version == 0 || version == 3)
            {
               if(count >= 0)
               {
                  for(i = 0; i < count; i++)
                  {
                     user = {};
                     user.uid = evt.msg.body.readInt();
                     user.uname = ChatUtil.onCheckStr(evt.msg.body.readUTF());
                     user.level = evt.msg.body.readInt();
                     user.sex = evt.msg.body.readInt();
                     user.contribute = evt.msg.body.readInt();
                     user.topLevel = evt.msg.body.readInt();
                     user.isOnline = evt.msg.body.readInt();
                     user.devote = evt.msg.body.readInt();
                     if(version == 3)
                     {
                        user.token = evt.msg.body.readInt();
                     }
                     list.push(user);
                  }
                  list.sortOn("level",Array.NUMERIC);
               }
               else
               {
                  list = null;
                  new Alert().show("返回列表失败");
               }
               dispatch(EventConst.FAMILY_MEMBERS_BACK,list);
            }
            else if(version == 1)
            {
               if(count >= 0)
               {
                  for(j = 0; j < count; j++)
                  {
                     user = {};
                     user.uid = evt.msg.body.readInt();
                     user.uname = ChatUtil.onCheckStr(evt.msg.body.readUTF());
                     user.level = evt.msg.body.readInt();
                     user.sex = evt.msg.body.readInt();
                     user.contribute = evt.msg.body.readInt();
                     user.topLevel = evt.msg.body.readInt();
                     user.isOnline = evt.msg.body.readInt();
                     user.time = evt.msg.body.readInt();
                     user.record = evt.msg.body.readInt();
                     user.times = evt.msg.body.readInt();
                     list.push(user);
                  }
                  list.sortOn("level",Array.NUMERIC);
               }
               else
               {
                  list = null;
                  new Alert().show("返回列表失败");
               }
               abc = {};
               abc.list = list;
               abc.showX = 0;
               abc.showY = 100;
               dispatch(EventConst.FAMILY_CHECK_LIST_BACK,abc);
            }
         }
         catch(e:*)
         {
            O.o("\n\n\n请求家族成员列表返回: " + e + "\n\n\n");
         }
      }
      
      private function on_ChangeNoticeBack(evt:MsgEvent) : void
      {
         var flag:int = 0;
         try
         {
            O.traceSocket(evt);
            flag = evt.msg.body.readInt();
            AlertManager.instance.showTipAlert({
               "systemid":1030,
               "flag":flag,
               "defaultTip":true
            });
         }
         catch(e:*)
         {
            O.o("\n\n\n请求修改家族公告返回: " + e + "\n\n\n");
         }
      }
      
      private function on_ChangeIofoBack(evt:MsgEvent) : void
      {
         O.traceSocket(evt);
         if(evt.msg.mParams == 0 || evt.msg.mParams == -1)
         {
            AlertManager.instance.showTipAlert({
               "systemid":1031,
               "flag":evt.msg.mParams
            });
         }
         dispatch(EventConst.RECORD_CHANGE_INFO_BACK);
      }
      
      private function on_ChangeLevelBack(evt:MsgEvent) : void
      {
         var flag:int = 0;
         try
         {
            O.traceSocket(evt);
            flag = evt.msg.body.readInt();
            if(flag == 0)
            {
               dispatch(EventConst.RECORD_CHANGE_RANK_BACK);
            }
            AlertManager.instance.showTipAlert({
               "systemid":1032,
               "flag":flag
            });
         }
         catch(e:*)
         {
            O.o("\n\n\n请求修改族员等级返回: " + e + "\n\n\n");
         }
      }
      
      private function on_FireMemberBack(evt:MsgEvent) : void
      {
         var flag:int = 0;
         try
         {
            O.traceSocket(evt);
            flag = evt.msg.body.readInt();
            if(flag == 0)
            {
               new FloatAlert().show(WindowLayer.instance.stage,300,400,"开除成功。",5,300);
               dispatch(EventConst.RECORD_FIRE_SUCCESS_BACK);
            }
         }
         catch(e:*)
         {
            O.o("\n\n\n请求开除族员返回: " + e + "\n\n\n");
         }
      }
      
      private function on_FamilyFired(evt:MsgEvent) : void
      {
         O.traceSocket(evt);
         if(GameData.instance.playerData.family_base_id == GameData.instance.playerData.family_id)
         {
            this.getOutOfMyFamily();
         }
         var o:NewsVo = new NewsVo();
         o.msg = "抱歉！你被请出了家族。";
         o.alertType = 4;
         o.type = 2;
         GameData.instance.boxMessagesArray.push(o);
         GameData.instance.showMessagesCome();
         GameData.instance.playerData.family_id = 0;
         GameData.instance.playerData.family_level = 0;
      }
      
      private function getOutOfMyFamily() : void
      {
         var tempFlag:int = 0;
         var map:Array = [1051,1052,1053,1054];
         var id:int = GameData.instance.playerData.currentScenenId;
         if(map.indexOf(id) != -1)
         {
            tempFlag = -1;
         }
         else if(id == 1055)
         {
            tempFlag = -2;
         }
         AlertManager.instance.showTipAlert({
            "systemid":1038,
            "flag":tempFlag,
            "callback":this.getOutHandler
         });
      }
      
      private function getOutHandler(... rest) : void
      {
         dispatch(EventConst.ENTERSCENE,1004);
      }
      
      private function on_EnterBaseBack(event:MsgEvent) : void
      {
         var star:int = 0;
         O.traceSocket(event);
         if(event.msg.mParams == 1)
         {
            star = event.msg.body.readInt();
            GameData.instance.playerData.family_base_star = star;
            if(star >= 9)
            {
               GameData.instance.playerData.family_map_star = 4;
            }
            else if(star >= 7)
            {
               GameData.instance.playerData.family_map_star = 3;
            }
            else if(star >= 4)
            {
               GameData.instance.playerData.family_map_star = 2;
            }
            else
            {
               GameData.instance.playerData.family_map_star = 1;
            }
            dispatch(EventConst.ENTER_FAMILY_BASE_BACK);
            dispatch(EventConst.BATTLE_COUNTER);
            GameData.instance.playerData.isInFamily = true;
         }
         else
         {
            AlertManager.instance.showTipAlert({
               "systemid":1033,
               "flag":event.msg.mParams
            });
         }
      }
      
      private function on_LeaveBaseBack(event:MsgEvent) : void
      {
      }
      
      private function on_PlayerStateBack(evt:MsgEvent) : void
      {
         O.traceSocket(evt);
         var obj:Object = {};
         obj.uid = evt.msg.body.readInt();
         obj.roleType = evt.msg.body.readInt();
         obj.isOnline = evt.msg.body.readInt();
         dispatch(EventConst.REQ_PLAYER_STATE_BACK,obj);
      }
      
      private function on_CheckInBack(event:MsgEvent) : void
      {
         O.traceSocket(event);
         if(event.msg.mParams == -1 || event.msg.mParams == -2)
         {
            AlertManager.instance.showTipAlert({
               "systemid":1034,
               "flag":event.msg.mParams
            });
            if(CacheUtil.pool[FamilyCheckIn] != null)
            {
               CacheUtil.pool[FamilyCheckIn]["disport"]();
            }
         }
         else if(event.msg.mParams == 1)
         {
            if(CacheUtil.pool[FamilyCheckIn] != null)
            {
               CacheUtil.pool[FamilyCheckIn]["onChecking"]();
            }
         }
      }
      
      private function on_SuitBack(evt:MsgEvent) : void
      {
         O.traceSocket(evt);
         GameData.instance.playerData.hasLinHorse = true;
      }
      
      private function on_ContributionBack(evt:MsgEvent) : void
      {
         var result:int = 0;
         var res:int = 0;
         var re:int = 0;
         O.traceSocket(evt);
         var params:Object = {};
         if(evt.msg.mParams == 0)
         {
            params.fid = evt.msg.body.readInt();
            params.num0 = evt.msg.body.readInt();
            params.num1 = evt.msg.body.readInt();
            params.num2 = evt.msg.body.readInt();
            params.num3 = evt.msg.body.readInt();
            params.num4 = evt.msg.body.readInt();
            params.num5 = evt.msg.body.readInt();
            params.todayNum = evt.msg.body.readInt();
            params.todayTimes = evt.msg.body.readInt();
            params.totalTimes = evt.msg.body.readInt();
            params.pboxstate = evt.msg.body.readInt();
            params.mboxstate = evt.msg.body.readInt();
            params.hboxstate = evt.msg.body.readInt();
            if(CacheUtil.pool[FamilyContribution] != null)
            {
               CacheUtil.pool[FamilyContribution]["initBox"](params);
            }
         }
         else if(evt.msg.mParams == 1)
         {
            result = evt.msg.body.readInt();
            if(result == 0)
            {
               if(CacheUtil.pool[FamilyContribution] != null)
               {
                  CacheUtil.pool[FamilyContribution]["lingjiangBack"](1);
               }
            }
            AlertManager.instance.showTipAlert({
               "systemid":1035,
               "flag":1,
               "params":result
            });
         }
         else if(evt.msg.mParams == 2)
         {
            res = evt.msg.body.readInt();
            if(res == 0)
            {
               if(CacheUtil.pool[FamilyContribution] != null)
               {
                  CacheUtil.pool[FamilyContribution]["lingjiangBack"](2);
               }
               AlertManager.instance.showAwardAlertList([{"exp":2000},{"money":300}]);
            }
            AlertManager.instance.showTipAlert({
               "systemid":1035,
               "flag":2,
               "params":res
            });
         }
         else if(evt.msg.mParams == 3)
         {
            re = evt.msg.body.readInt();
            if(re == 0)
            {
               if(CacheUtil.pool[FamilyContribution] != null)
               {
                  CacheUtil.pool[FamilyContribution]["checkContributionOption"]();
               }
               new FloatAlert().show(WindowLayer.instance.stage,300,400,"宝箱奖励领取成功",5,300);
            }
            else if(re == -1)
            {
               new FloatAlert().show(WindowLayer.instance.stage,300,400,"很抱歉，请先进入家族基地",5,300);
            }
            else if(re == -2)
            {
               new FloatAlert().show(WindowLayer.instance.stage,300,400,"很抱歉，领取条件不满足",5,300);
            }
            else if(re == -3)
            {
               new FloatAlert().show(WindowLayer.instance.stage,300,400,"很抱歉，您已领取过此宝箱",5,300);
            }
         }
      }
      
      private function taskHelpPinZhiBack(evt:MsgEvent) : void
      {
         var o:NewsVo = null;
         O.traceSocket(evt);
         var data:Object = {};
         data.errorCode = evt.msg.body.readInt();
         if(data.errorCode == 0)
         {
            data.uid = evt.msg.body.readInt();
            data.name = ChatUtil.onCheckStr(evt.msg.body.readUTF());
            data.tid = evt.msg.body.readInt();
            if(data.tid == GameData.instance.playerData.userId)
            {
               o = new NewsVo();
               o.data = data;
               o.msg = "【" + data.name + "】请求你帮忙刷新家族试炼任务品质。";
               o.alertType = 1;
               o.type = 2;
               o.ao = {
                  "s":MsgDoc.OP_CLIENT_REQ_FAMILY_TASK_PINZHI.send,
                  "m":0,
                  "l":[data.uid]
               };
               GameData.instance.boxMessagesArray.push(o);
               GameData.instance.showMessagesCome();
            }
         }
         else
         {
            AlertManager.instance.showTipAlert({
               "systemid":1036,
               "flag":data.errorCode
            });
         }
      }
      
      private function taskUpdatePinZhiBack(evt:MsgEvent) : void
      {
         var list:Array = null;
         var i:int = 0;
         var person:Object = null;
         O.traceSocket(evt);
         var data:Object = {};
         data.errorCode = evt.msg.body.readInt();
         switch(data.errorCode)
         {
            case 0:
               new FloatAlert().show(WindowLayer.instance.stage,300,400,"刷新品质成功!",5,300);
               data.num = evt.msg.body.readInt();
               list = [];
               for(i = 0; i < data.num; i++)
               {
                  person = {};
                  person.uid = evt.msg.body.readInt();
                  person.name = ChatUtil.onCheckStr(evt.msg.body.readUTF());
                  person.yunshi = evt.msg.body.readInt();
                  person.status = evt.msg.body.readInt();
                  person.helptimes = evt.msg.body.readInt();
                  person.refreshtimes = evt.msg.body.readInt();
                  person.online = evt.msg.body.readInt();
                  list.push(person);
               }
               data.list = list;
               dispatch(EventConst.UPDATE_PINZHI_SUCCESS,data);
               break;
            default:
               AlertManager.instance.showTipAlert({
                  "systemid":1037,
                  "flag":data.errorCode,
                  "replace":data.errorCode,
                  "defaultTip":true
               });
         }
      }
      
      private function on_FamilyStarTips(evt:MsgEvent) : void
      {
         var o:NewsVo = null;
         O.traceSocket(evt);
         var data:Object = {};
         data.errorCode = evt.msg.body.readInt();
         switch(data.errorCode)
         {
            case 1:
               data.starLevel = evt.msg.body.readInt();
               o = new NewsVo();
               o.data = data;
               o.msg = "恭喜你当前所在家族的星级提升为" + data.starLevel + "星。";
               o.alertType = 3;
               o.type = 2;
               break;
            case 2:
               o = new NewsVo();
               o.data = data;
               o.msg = "很遗憾你当前所在家族的星级降低了一级。";
               o.alertType = 3;
               o.type = 2;
               break;
            case 3:
               data.name = ChatUtil.onCheckStr(evt.msg.body.readUTF());
               o = new NewsVo();
               o.data = data;
               o.msg = "【" + data.name + "】退出家族。";
               o.alertType = 3;
               o.type = 2;
         }
         if(Boolean(o))
         {
            GameData.instance.boxMessagesArray.push(o);
            GameData.instance.showMessagesCome();
         }
      }
   }
}

