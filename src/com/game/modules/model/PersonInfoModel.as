package com.game.modules.model
{
   import com.core.model.Model;
   import com.core.observer.MessageEvent;
   import com.game.event.EventConst;
   import com.game.locators.CacheData;
   import com.game.locators.GameData;
   import com.game.locators.MsgDoc;
   import com.game.modules.view.MapView;
   import com.game.modules.vo.NewsVo;
   import com.game.util.ChatUtil;
   import com.game.util.FloatAlert;
   import com.game.util.HtmlUtil;
   import com.publiccomponent.alert.Alert;
   import flash.utils.setTimeout;
   import org.green.server.events.MsgEvent;
   
   public class PersonInfoModel extends Model
   {
      
      public static const NAME:String = "personinfomodel";
      
      private var _timeNum:int;
      
      private var _num:int;
      
      private var _params:Object;
      
      private var _code:int;
      
      public function PersonInfoModel(modelName:String = "")
      {
         super(NAME);
      }
      
      override public function onRegister() : void
      {
         registerListener(MsgDoc.OP_CLIENT_REQ_SELF_DRESS.back.toString(),this.onPlayerDressBack);
         registerListener(MsgDoc.OP_CLIENT_REQ_PLAYERINFO.back.toString(),this.onPlayerInfoBack);
         registerListener(MsgDoc.OP_CLIENT_CHECK_POSITION.back.toString(),this.onCheckPositionBack);
         registerListener(MsgDoc.OP_CLIENT_DELETE_FRIEND.back.toString(),this.onDelFriendBack);
         registerListener(MsgDoc.OP_CLIENT_ADD_BLACK.back.toString(),this.onAddBlackBack);
         registerListener(MsgDoc.OP_CLIENT_INVITE_ENTER_ROOM.back.toString(),this.onInviteFriendBack);
         registerListener(MsgDoc.OP_CLIENT_INVITE_ENTER_ROOM_RES.back.toString(),this.onInviteEnterRoomBack);
         registerListener(MsgDoc.OP_CLIENT_SHOWTITLE.back.toString(),this.onShowTitleBack);
         registerListener(MsgDoc.OP_CLIENT_SET_FRIEND_NAME.back.toString(),this.onChangeBeiZhuBack);
         registerListener(MsgDoc.OP_CLIENT_REQ_VIP_INFO.back.toString(),this.reqVipInfoBack);
         registerListener(MsgDoc.OP_CLIENT_REQ_BADGE_DATA.back.toString(),this.onReqBadgeDataBack);
         registerListener(MsgDoc.OP_CLIENT_GET_A_BADGE.back.toString(),this.onGetABadgeBack);
      }
      
      private function onPlayerDressBack(event:MsgEvent) : void
      {
         O.traceSocket(event);
         var code:uint = uint(event.msg.mParams);
         var params:Object = {};
         if(code > 0)
         {
            params.userId = event.msg.body.readUnsignedInt();
            if(params.userId == -1)
            {
               dispatch(EventConst.GETPERSONINFOFAIL);
            }
            else
            {
               params.userName = ChatUtil.onCheckStr(event.msg.body.readUTF());
               params.roleType = event.msg.body.readInt();
               params.sex = params.roleType & Math.pow(2,0);
               params.hatId = event.msg.body.readInt();
               params.clothId = event.msg.body.readInt();
               params.weaponId = event.msg.body.readInt();
               params.footId = event.msg.body.readInt();
               params.faceId = event.msg.body.readInt();
               params.wingId = event.msg.body.readInt();
               params.glassId = event.msg.body.readInt();
               params.leftWeapon = event.msg.body.readInt();
               params.taozhuangId = event.msg.body.readInt();
               params.backgroundId = event.msg.body.readInt();
               params.isAccept = event.msg.body.readInt();
               params.horseId = event.msg.body.readInt();
               params.isOnline = event.msg.body.readInt();
               params.historyValue = event.msg.body.readInt();
               params.kabuLevel = event.msg.body.readInt();
               params.signTime = event.msg.body.readInt();
               params.maxLevel = event.msg.body.readInt();
               params.isFriend = event.msg.body.readInt();
               params.familyId = event.msg.body.readInt();
               if(event.msg.body.bytesAvailable > 0)
               {
                  params.littlegameRcore = event.msg.body.readInt();
               }
               params.userBeiZhu = event.msg.body.readUTF();
               dispatch(EventConst.GETPERSONDRESSBACK,params);
               GameData.instance.dispatchEvent(new MessageEvent("getusernameback",[params.userName,uint(params.userId)]));
               if(params.isFriend == 1)
               {
                  GameData.instance.playerData.tempfriends[String(params.userId)] = 1;
               }
            }
         }
      }
      
      private function onPlayerInfoBack(evt:MsgEvent) : void
      {
         var params:Object = null;
         var holyList:Array = null;
         var holy:Object = null;
         var i:int = 0;
         O.traceSocket(evt);
         var code:uint = uint(evt.msg.mParams);
         if(code > 0)
         {
            params = {};
            params.reg_time = evt.msg.body.readInt();
            params.title = evt.msg.body.readInt();
            params.level = evt.msg.body.readInt();
            params.exp = evt.msg.body.readInt();
            params.spirit_num = evt.msg.body.readInt();
            params.max_spirit_level = evt.msg.body.readInt();
            if(params.max_spirit_level > 100)
            {
               params.max_spirit_level = 100;
            }
            params.leiDa = evt.msg.body.readUTF();
            params.boss = evt.msg.body.readUTF();
            params.arena_vc = evt.msg.body.readInt();
            if(evt.msg.body.bytesAvailable > 0)
            {
               params.liandan = evt.msg.body.readInt();
               params.achievepoint = evt.msg.body.readInt();
            }
            params.littlegameRcore = evt.msg.body.readInt();
            params.historyValue = evt.msg.body.readInt();
            params.arena_vcs = evt.msg.body.readInt();
            params.maxTalent = evt.msg.body.readInt();
            params.bestTalentCount = evt.msg.body.readInt();
            params.holyScore = evt.msg.body.readInt();
            params.holyIndex = evt.msg.body.readInt();
            holyList = [];
            for(i = 0; i < params.holyIndex; i++)
            {
               holy = new Object();
               holy.holySingleValue = evt.msg.body.readInt();
               holy.holyMulValue = evt.msg.body.readInt();
               holy.holySingleWin = evt.msg.body.readInt();
               holy.holyMulWin = evt.msg.body.readInt();
               holy.holySingleLose = evt.msg.body.readInt();
               holy.holyMulLose = evt.msg.body.readInt();
               holy.singleRank = evt.msg.body.readInt();
               holy.multiRank = evt.msg.body.readInt();
               holy.singleAdore = evt.msg.body.readInt();
               holy.multiAdore = evt.msg.body.readInt();
               holy.singleFlower = evt.msg.body.readInt();
               holy.multiFlower = evt.msg.body.readInt();
               holyList.push(holy);
            }
            params.holyList = holyList;
            dispatch(EventConst.GETPERSONINFOBACK,params);
         }
      }
      
      private function reqVipInfoBack(evt:MsgEvent) : void
      {
         O.traceSocket(evt);
         var params:Object = {};
         var uid:uint = uint(evt.msg.mParams);
         params.userId = uid;
         params.isopenvip = evt.msg.body.readInt();
         params.vipScore = evt.msg.body.readInt();
         params.vipLevel = evt.msg.body.readInt();
         params.expiretime = evt.msg.body.readInt();
         params.currentTime = evt.msg.body.readInt();
         params.isSuperVip = evt.msg.body.readInt();
         dispatch(EventConst.REQ_VIPINFO_BACK,params);
      }
      
      private function onCheckPositionBack(evt:MsgEvent) : void
      {
         O.traceSocket(evt);
         var params:Object = {};
         if(evt.msg.mParams > 0)
         {
            params.userName = evt.msg.body.readUTF();
            params.serverId = evt.msg.body.readInt();
            params.sceneId = evt.msg.body.readInt();
            dispatch(EventConst.CHECKPOSITIONBACK,params);
         }
      }
      
      private function onDelFriendBack(evt:MsgEvent) : void
      {
         O.traceSocket(evt);
         var params:Object = {};
         params.userId = uint(evt.msg.mParams);
         if(GameData.instance.playerData.isInWarCraft)
         {
            return;
         }
         if(params.userId > 0)
         {
            params.userName = evt.msg.body.readUTF();
            params.refuseId = evt.msg.body.readInt();
            if(params.refuseId != GameData.instance.playerData.userId)
            {
               new Alert().showSureLink(HtmlUtil.getHtmlText(15,"#ff0000","【<a href=\"event:\">" + ChatUtil.onCheckStr(params.userName) + "】(" + params.userId + ")</a><br>") + "和你解除了好友关系!",null,params,this.delLinkHanlder);
            }
            dispatch(EventConst.DELETEFRIENDBACK,params.userId);
         }
      }
      
      private function delLinkHanlder(... rest) : void
      {
         var obj:Object = {
            "userId":rest[1].userId,
            "isOnline":1,
            "source":0,
            "userName":rest[1].userName,
            "sex":1
         };
         dispatch(EventConst.OPENPERSONINFOVIEW,obj);
      }
      
      private function onInviteFriendBack(evt:MsgEvent) : void
      {
         var obj:NewsVo = null;
         O.traceSocket(evt);
         var params:Object = {};
         params.userId = uint(evt.msg.mParams);
         if(params.userId > 0)
         {
            params.userName = evt.msg.body.readUTF();
            obj = new NewsVo();
            obj.data = params;
            obj.ao = {
               "s":1184002,
               "m":params.userId,
               "l":[params.userName]
            };
            obj.ro = {
               "s":1184056,
               "m":0,
               "l":[params.userId,params.userName]
            };
            obj.type = 4;
            obj.mytype = 1;
            obj.alertType = 1;
            obj.msg = params.userName + "(" + params.userId + ")" + "邀请你进入TA的家园";
            GameData.instance.boxMessagesArray.push(obj);
         }
         GameData.instance.showMessagesCome();
      }
      
      private function onInviteEnterRoomBack(evt:MsgEvent) : void
      {
         O.traceSocket(evt);
         this._params = {};
         this._code = evt.msg.mParams;
         this._params.userId = evt.msg.body.readUnsignedInt();
         this._params.userName = evt.msg.body.readUTF();
         ++this._num;
         if(this._timeNum == 0)
         {
            this._timeNum = setTimeout(function():void
            {
               if(_num == 1)
               {
                  if(GameData.instance.playerData.isInWarCraft)
                  {
                     return;
                  }
                  if(_code == 0)
                  {
                     new Alert().show(_params.userName + "(" + _params.userId + ")拒绝了你的请求");
                  }
                  else
                  {
                     new Alert().show(_params.userName + "(" + _params.userId + ")接收了你的请求");
                  }
               }
               _timeNum = 0;
               _num = 0;
            },1000);
         }
      }
      
      private function onShowTitleBack(evt:MsgEvent) : void
      {
         var titleList:Array = null;
         var i:int = 0;
         var itemid:int = 0;
         O.traceSocket(evt);
         var obj:Object = {};
         if(evt.msg.mParams == 0)
         {
            obj.nowtitle = evt.msg.body.readInt();
            obj.len = evt.msg.body.readInt();
            titleList = [];
            for(i = 0; i < obj.len; i++)
            {
               itemid = evt.msg.body.readInt();
               CacheData.instance.titleList.updateObtain(itemid,1);
               titleList.push(itemid);
            }
            this.dispatch(EventConst.SHOWTITLEBACK);
         }
         else
         {
            obj.id = evt.msg.mParams;
            obj.current = evt.msg.body.readInt();
            obj.total = evt.msg.body.readInt();
            obj.endTime = evt.msg.body.readInt();
            CacheData.instance.titleList.updateAwardState(obj);
         }
      }
      
      private function onChangeBeiZhuBack(evt:MsgEvent) : void
      {
         O.traceSocket(evt);
         var code:int = evt.msg.body.readInt();
         if(code == 0)
         {
            new FloatAlert().show(MapView.instance.stage,320,300,"恭喜你修改成功");
            dispatch(EventConst.MODYFY_BEZHU_BACK);
         }
         else
         {
            new FloatAlert().show(MapView.instance.stage,320,300,"修改失败。。。");
         }
      }
      
      private function onAddBlackBack(evt:MsgEvent) : void
      {
         O.traceSocket(evt);
         if(GameData.instance.playerData.isInWarCraft)
         {
            return;
         }
         if(evt.msg.mParams < 0)
         {
            new Alert().show("添加黑名单失败!");
         }
         else
         {
            new Alert().show("添加黑名单成功!");
         }
      }
      
      private function onReqBadgeDataBack(evt:MsgEvent) : void
      {
         var j:int = 0;
         O.traceSocket(evt);
         evt.msg.body.position = 0;
         var params:Object = {};
         params.userId = evt.msg.mParams;
         params.num = evt.msg.body.readInt();
         params.badgeList = [];
         var badge:Object = {};
         var map:Object = {};
         if(params.num != 1)
         {
            badge = {};
            badge.badgeId = 9000;
            badge.count = 6;
            badge.mapList = [{
               "key":0,
               "value":0
            },{
               "key":1,
               "value":0
            },{
               "key":2,
               "value":0
            },{
               "key":3,
               "value":0
            },{
               "key":4,
               "value":0
            },{
               "key":5,
               "value":0
            }];
            params.badgeList.push(badge);
            dispatch(EventConst.GET_BADGE_DATA_BACK,params);
            return;
         }
         for(var i:int = 0; i < params.num; i++)
         {
            badge = {};
            badge.badgeId = evt.msg.body.readInt();
            badge.count = evt.msg.body.readInt();
            badge.mapList = [];
            for(j = 0; j < badge.count; j++)
            {
               map = {};
               map.key = evt.msg.body.readInt();
               map.value = evt.msg.body.readInt();
               badge.mapList.push(map);
            }
            params.badgeList.push(badge);
         }
         dispatch(EventConst.GET_BADGE_DATA_BACK,params);
      }
      
      private function onGetABadgeBack(evt:MsgEvent) : void
      {
         O.traceSocket(evt);
         var badgeId:int = evt.msg.mParams;
         dispatch(EventConst.PLAYBADGEMOVIE,badgeId);
      }
   }
}

