package com.game.modules.control.shenshou
{
   import com.channel.ChannelEvent;
   import com.channel.ChannelPool;
   import com.channel.Message;
   import com.core.observer.MessageEvent;
   import com.core.view.ViewConLogic;
   import com.game.event.EventConst;
   import com.game.locators.GameData;
   import com.game.locators.MsgDoc;
   import com.game.manager.MouseManager;
   import com.game.modules.action.SwfAction;
   import com.game.modules.view.FaceView;
   import com.game.modules.view.MapView;
   import com.game.modules.view.WindowLayer;
   import com.game.modules.view.battle.AIMonster;
   import com.game.modules.view.shenshou.ShenshouView;
   import com.game.util.DelayShowUtil;
   import com.game.util.FloatAlert;
   import com.game.util.HtmlUtil;
   import com.game.util.IdName;
   import com.publiccomponent.alert.Alert;
   import com.publiccomponent.loading.XMLLocator;
   import com.publiccomponent.ui.ToolTip;
   import flash.events.MouseEvent;
   
   public class ShenshouViewControl extends ViewConLogic
   {
      
      public static const NAME:String = "SHENSHOUVIEWCONTROL";
      
      public static var ShenshouList:Array = [];
      
      private var havelizi:Boolean = false;
      
      private var deleteEgaoIndex:int = 0;
      
      private var maxlevel:Array = [0,80,120,200,360,570,830,1140,1500,1910,2370,2880,3440,4050,4710,5420,6180,6990,7850,8760,9720,10730,11790,12900,14060,15270,16530,17840,19200,20610,22070];
      
      private var changeShenShouList:Array = [];
      
      public function ShenshouViewControl(viewConment:Object)
      {
         super(NAME,viewConment);
         this.listenchannel();
      }
      
      override public function listEvents() : Array
      {
         return [[EventConst.SENDACTIONBACK,this.onSendActionBack],[EventConst.LEAVE_BY_BIGMAP,this.onLeaveByBigMap]];
      }
      
      override public function onRemove() : void
      {
         this.removeChannel();
         super.onRemove();
      }
      
      private function listenchannel() : void
      {
         FaceView.clip.visible = false;
         ChannelPool.getChannel("shenshou").addChannelListener("closeshenshou",this.onEnterSelfHandler);
         ChannelPool.getChannel("shenshou").addChannelListener("shenshoupacket",this.onShenShouPacket);
         ChannelPool.getChannel("shenshou").addChannelListener("showyaoguai",this.onShowYaoguai);
         ChannelPool.getChannel("shenshou").addChannelListener("shenshourizhi",this.onShenshouRizhi);
         ChannelPool.getChannel("shenshou").addChannelListener("liziguangxian",this.onLiziGuang);
         ChannelPool.getChannel("shenshou").addChannelListener("shenshoudaodan",this.onShenshouErgao);
         ChannelPool.getChannel("shenshou").addChannelListener("shenshoushouji",this.onShenshouShouji);
         ChannelPool.getChannel("shenshou").addChannelListener("shenshoufriend",this.onFriendsHandler);
         ChannelPool.getChannel("shenshou").addChannelListener("entershenshou",this.onEnterShenShou);
         ChannelPool.getChannel("shenshou").addChannelListener("shenshougrow",this.onShenshouGrow);
         ChannelPool.getChannel("shenshou").addChannelListener("shenshoufood",this.onShenshouFood);
         ChannelPool.getChannel("shenshou").addChannelListener("shouhuoeggs",this.onShouhuoEggs);
         ChannelPool.getChannel("shenshou").addChannelListener("fangsheng",this.onFangSheng);
         ChannelPool.getChannel("shenshou").addChannelListener("addshenshou",this.onAddShenshou);
         ChannelPool.getChannel("shenshou").addChannelListener("shenshoubaoxiang",this.onShenshoubaoxiang);
         ChannelPool.getChannel("shenshou").addChannelListener("sellxianshou",this.onSellXianShou);
         ChannelPool.getChannel("shenshou").addChannelListener("reqUplevel",this.onReqUplevel);
         ChannelPool.getChannel("shenshou").addChannelListener("LevelUpBack",this.onLevelUpBack);
         ChannelPool.getChannel("shenshou").addChannelListener("zhuan_hua",this.onReqZhuanhua);
         ChannelPool.getChannel("shenshou").addChannelListener("ReqZuoqiList",this.onReqZuoqiList);
         ChannelPool.getChannel("shenshou").addChannelListener("get_props",this.onReqMoJingFen);
         ChannelPool.getChannel("shenshou").addChannelListener("OpenBigMapView",this.onOpenBigMapView);
         ChannelPool.getChannel("shenshou").addChannelListener("goto1005",this.onGoto1005);
         ChannelPool.getChannel("shenshou").addChannelListener("shenshouUseTool",this.onShenshouUseTool);
         ChannelPool.getChannel("shenshou").addChannelListener("addShenshouStep",this.onAddShenshouStep);
         ChannelPool.getChannel("shenshou").addChannelListener("changeShenshouStep",this.onChangeShenshouStep);
         ChannelPool.getChannel("shenshou").addChannelListener("sellzuoqi",this.onSellZuoQi);
      }
      
      private function removeChannel() : void
      {
         var o:Object = null;
         try
         {
            while(ShenshouViewControl.ShenshouList.length > 0)
            {
               o = ShenshouViewControl.ShenshouList.shift();
               if(Boolean(o) && Boolean(o.hasOwnProperty("dispos")))
               {
                  o["dispos"]();
               }
            }
         }
         catch(e:*)
         {
            O.o("清理神兽园" + e);
         }
         MouseManager.getInstance().setCursor("");
         ChannelPool.getChannel("shenshou").removeListener("closeshenshou",this.onEnterSelfHandler);
         ChannelPool.getChannel("shenshou").removeListener("shenshoupacket",this.onShenShouPacket);
         ChannelPool.getChannel("shenshou").removeListener("showyaoguai",this.onShowYaoguai);
         ChannelPool.getChannel("shenshou").removeListener("shenshourizhi",this.onShenshouRizhi);
         ChannelPool.getChannel("shenshou").removeListener("liziguangxian",this.onLiziGuang);
         ChannelPool.getChannel("shenshou").removeListener("shenshoudaodan",this.onShenshouErgao);
         ChannelPool.getChannel("shenshou").removeListener("shenshoushouji",this.onShenshouShouji);
         ChannelPool.getChannel("shenshou").removeListener("shenshoufriend",this.onFriendsHandler);
         ChannelPool.getChannel("shenshou").removeListener("entershenshou",this.onEnterShenShou);
         ChannelPool.getChannel("shenshou").removeListener("shenshougrow",this.onShenshouGrow);
         ChannelPool.getChannel("shenshou").removeListener("shenshoufood",this.onShenshouFood);
         ChannelPool.getChannel("shenshou").removeListener("shouhuoeggs",this.onShouhuoEggs);
         ChannelPool.getChannel("shenshou").removeListener("fangsheng",this.onFangSheng);
         ChannelPool.getChannel("shenshou").removeListener("addshenshou",this.onAddShenshou);
         ChannelPool.getChannel("shenshou").removeListener("shenshoubaoxiang",this.onShenshoubaoxiang);
         ChannelPool.getChannel("shenshou").removeListener("sellxianshou",this.onSellXianShou);
         ChannelPool.getChannel("shenshou").removeListener("reqUplevel",this.onReqUplevel);
         ChannelPool.getChannel("shenshou").removeListener("LevelUpBack",this.onLevelUpBack);
         ChannelPool.getChannel("shenshou").removeListener("zhuan_hua",this.onReqZhuanhua);
         ChannelPool.getChannel("shenshou").removeListener("ReqZuoqiList",this.onReqZuoqiList);
         ChannelPool.getChannel("shenshou").removeListener("get_props",this.onReqMoJingFen);
         ChannelPool.getChannel("shenshou").removeListener("OpenBigMapView",this.onOpenBigMapView);
         ChannelPool.getChannel("shenshou").removeListener("goto1005",this.onGoto1005);
         ChannelPool.getChannel("shenshou").removeListener("shenshouUseTool",this.onShenshouUseTool);
         ChannelPool.getChannel("shenshou").removeListener("addShenshouStep",this.onAddShenshouStep);
         ChannelPool.getChannel("shenshou").removeListener("sellzuoqi",this.onSellZuoQi);
         ToolTip.LooseDO(MapView.instance.scene.bg["getChildAt"](0)["control"]["paizi"]["expbar"]);
         ToolTip.LooseDO(MapView.instance.scene.bg["getChildAt"](0)["control"]["paizi"]["txt1"]);
         ToolTip.LooseDO(MapView.instance.scene.bg["getChildAt"](0)["control"]["paizi"]["txt2"]);
         ToolTip.LooseDO(MapView.instance.scene.bg["getChildAt"](0)["control"]["paizi"]["upbtn"]);
         MapView.instance.scene.bg["getChildAt"](0)["control"]["jiayuan"].removeEventListener(MouseEvent.CLICK,this.onClickJiayuanHandler);
         MapView.instance.scene.bg["getChildAt"](0)["control"]["foodbtn"].removeEventListener(MouseEvent.CLICK,this.onClickFoodBtnHandler);
      }
      
      private function onCloseShenshou(event:ChannelEvent) : void
      {
         this.view.disport();
         if(event != null && GameData.instance.playerData.shenshouBackId == 1002)
         {
            dispatch(EventConst.REQ_ENTER_ROOM,{
               "userId":GameData.instance.playerData.userId,
               "userName":GameData.instance.playerData.userName,
               "houseId":GameData.instance.playerData.userId
            });
            FaceView.clip.visible = true;
         }
         else if(event != null)
         {
            sendMessage(MsgDoc.OP_CLIENT_LEFT_SHENSHOU.send,GameData.instance.playerData.serverId);
            GameData.instance.playerData.currentScenenId = GameData.instance.playerData.shenshouBackId;
            FaceView.clip.visible = true;
         }
         if(DelayShowUtil.instance.playerControl)
         {
            FaceView.clip.topMiddleClip.clearClip.gotoAndStop(1);
         }
         else
         {
            FaceView.clip.topMiddleClip.clearClip.gotoAndStop(2);
         }
      }
      
      private function onEnterSelfHandler(event:ChannelEvent) : void
      {
         this.onCloseShenshou(null);
         GameData.instance.playerData.shenshouyuan_id = GameData.instance.playerData.userId;
         GameData.instance.playerData.shenshouyuan_name = GameData.instance.playerData.userName;
         sendMessage(MsgDoc.OP_CLIENT_CAN_ENTER_SHENSHOU.send,GameData.instance.playerData.shenshouyuan_id);
      }
      
      private function onShenShouPacket(event:ChannelEvent) : void
      {
         sendMessage(MsgDoc.OP_CLIENT_SHENSHOU_PACKET.send,int(event.getMessage().getBody()));
      }
      
      private function onShowYaoguai(event:ChannelEvent) : void
      {
         new Message("onopenmonsterpanel").sendToChannel("itemclick");
      }
      
      private function onShenshouRizhi(event:ChannelEvent) : void
      {
         sendMessage(MsgDoc.OP_CLIENT_SHENSHOU_RIZHI.send,1);
      }
      
      private function onLiziGuang(event:ChannelEvent) : void
      {
         this.deleteEgaoIndex = 0;
         if(!this.havelizi)
         {
            this.havelizi = true;
            MouseManager.getInstance().setCursor("CursorTool2001");
         }
         else
         {
            this.havelizi = false;
            MouseManager.getInstance().setCursor("");
         }
      }
      
      private function onSendActionBack(event:MessageEvent) : void
      {
         this.havelizi = false;
         if(this.deleteEgaoIndex != 0)
         {
            sendMessage(MsgDoc.OP_CLIENT_SHENSHOU_ERGAO.send,2,[this.deleteEgaoIndex]);
         }
         this.deleteEgaoIndex = 0;
         MouseManager.getInstance().setCursor("");
         new Message("shenshouliziback").sendToChannel("shenshou");
      }
      
      private function onShenshouErgao(event:ChannelEvent) : void
      {
         this.deleteEgaoIndex = 0;
         var body:Object = event.getMessage().getBody();
         if(body.type == 1)
         {
            sendMessage(MsgDoc.OP_CLIENT_SHENSHOU_ERGAO.send,1);
         }
         else if(body.type == 2)
         {
            if(MouseManager.getInstance().cursorName == "CursorTool2001" && Boolean(body.hasOwnProperty("index")))
            {
               this.sendAction("CursorTool2001",this.view.stage.mouseX,this.view.stage.mouseY,body.index);
            }
         }
         else if(body.type == 3)
         {
            new SwfAction().loadAndPlay(this.view,"assets/shenshou/saoba.swf",this.view.mouseX - 80,this.view.mouseY - 80,this.oncleanRubblish,body.index);
         }
      }
      
      private function sendAction(str:String, destx:Number, desty:Number, index:int) : void
      {
         var params:Object = {};
         params.actionid = int(str.slice(13,str.length));
         params.destx = destx;
         params.desty = desty;
         dispatch(EventConst.SENDACTION,params);
         MouseManager.getInstance().setCursor("");
         this.deleteEgaoIndex = index;
      }
      
      private function oncleanRubblish(value:Object) : void
      {
         sendMessage(MsgDoc.OP_CLIENT_SHENSHOU_ERGAO.send,2,[int(value)]);
      }
      
      private function onShenshouShouji(event:ChannelEvent) : void
      {
         sendMessage(MsgDoc.OP_CLIENT_SHENSHOU_SHOUJI.send);
      }
      
      private function onFriendsHandler(event:ChannelEvent) : void
      {
         var obj:Object = null;
         var len:int = 0;
         var p:int = 0;
         if(GameData.instance.shenshoufriends.length == 0)
         {
            sendMessage(MsgDoc.OP_CLIENT_SHENSHOU_FRIENDS.send,0,[1]);
         }
         else
         {
            obj = {};
            GameData.instance.shenshoufriends.sortOn("userId",Array.NUMERIC);
            GameData.instance.shenshoufriends.sortOn("feedlevel",Array.NUMERIC);
            GameData.instance.shenshoufriends.reverse();
            GameData.instance.playerData.shenshoudata.shenshou_rank = 0;
            len = int(GameData.instance.shenshoufriends.length);
            for(p = 0; p < len; p++)
            {
               if(GameData.instance.playerData.shenshoupeiyulevel >= GameData.instance.shenshoufriends[p].feedlevel)
               {
                  if(GameData.instance.playerData.shenshoudata.shenshou_rank == 0)
                  {
                     GameData.instance.playerData.shenshoudata.shenshou_rank = p + 1;
                     GameData.instance.shenshoufriends[p].shenshou_rank = p + 2;
                  }
                  else
                  {
                     GameData.instance.shenshoufriends[p].shenshou_rank = p + 2;
                  }
               }
               else
               {
                  GameData.instance.shenshoufriends[p].shenshou_rank = p + 1;
               }
            }
            obj.userid = GameData.instance.playerData.userId;
            obj.lists = GameData.instance.shenshoufriends.concat();
            obj.userdata = GameData.instance.playerData;
            obj.myself = Boolean(GameData.instance.playerData.shenshouyuan_id == GameData.instance.playerData.userId);
            new Message("friendsdata",obj).sendToChannel("shenshou");
         }
      }
      
      private function onEnterShenShou(event:ChannelEvent) : void
      {
         var obj:Object = null;
         var uid:uint = uint(event.getMessage().getBody().userId);
         var lists:Array = GameData.instance.shenshoufriends.concat();
         var isFriend:Boolean = false;
         for each(obj in lists)
         {
            if(uid == obj.userId)
            {
               isFriend = true;
               break;
            }
         }
         if(isFriend || uid == uint(GameData.instance.playerData.userId))
         {
            this.onCloseShenshou(null);
            if(event.getMessage().getBody() != null)
            {
               GameData.instance.playerData.shenshouyuan_id = event.getMessage().getBody().userId;
               GameData.instance.playerData.shenshouyuan_name = event.getMessage().getBody().userName;
            }
            sendMessage(MsgDoc.OP_CLIENT_CAN_ENTER_SHENSHOU.send,GameData.instance.playerData.shenshouyuan_id);
         }
         else
         {
            new FloatAlert().show(MapView.instance.stage,285,400,"无法进入非好友的神兽园哦！",5,300);
         }
      }
      
      private function onShenshouGrow(event:ChannelEvent) : void
      {
         O.o("养殖" + event.getMessage().getBody());
         sendMessage(MsgDoc.OP_CLIENT_SHENSHOU_GROW.send,int(event.getMessage().getBody()));
      }
      
      private function onShenshouFood(event:ChannelEvent) : void
      {
         new Alert().showSureOrCancel("确定要往这里添加神明果吗？",this.foodOrNot,event.getMessage().getBody());
      }
      
      private function foodOrNot(str:String, data:Object) : void
      {
         if(str == "确定")
         {
            sendMessage(MsgDoc.OP_CLIENT_SHENSHOU_FOOD.send,300030,[int(data)]);
         }
      }
      
      private function onShouhuoEggs(event:ChannelEvent) : void
      {
         sendMessage(MsgDoc.OP_CLIENT_SHENSHOU_SHOUHUO.send,int(event.getMessage().getBody()));
      }
      
      private function onFangSheng(event:ChannelEvent) : void
      {
         new Alert().showSureOrCancel("确定放生？",this.onAlertFunction,event.getMessage().getBody());
      }
      
      private function onAlertFunction(str:String, data:Object) : void
      {
         if(str == "确定")
         {
            sendMessage(MsgDoc.OP_CLIENT_SHENSHOU_FANGSHENG.send,int(data));
         }
      }
      
      private function onAddShenshou(event:ChannelEvent) : void
      {
         var obj:Object = null;
         var i:int = 0;
         var userid2:uint = 0;
         var userid1:uint = 0;
         var ao:Object = null;
         var monster1:AIMonster = null;
         ShenshouViewControl.ShenshouList = [];
         if(Boolean(GameData.instance.playerData.shenshoudata))
         {
            obj = GameData.instance.playerData.shenshoudata;
            if(GameData.instance.playerData.currentScenenId == 1013)
            {
               if(Boolean(MapView.instance.scene.bg["getChildAt"](0).hasOwnProperty("control")))
               {
                  userid1 = uint(GameData.instance.playerData.userId);
                  MapView.instance.scene.bg["getChildAt"](0)["control"]["paizi"]["expbar"].gotoAndStop(int(obj.growExp / this.maxlevel[obj.growLevel] * 100));
                  MapView.instance.scene.bg["getChildAt"](0)["control"]["paizi"]["txt1"].text = "" + obj.yuanLevel;
                  MapView.instance.scene.bg["getChildAt"](0)["control"]["paizi"]["txt2"].text = "" + obj.growLevel;
                  MapView.instance.scene.bg["getChildAt"](0)["control"]["paizi"]["txt3"].text = "" + GameData.instance.playerData.coin;
                  MapView.instance.scene.bg["getChildAt"](0)["control"]["jiayuan"].addEventListener(MouseEvent.CLICK,this.onClickJiayuanHandler);
                  MapView.instance.scene.bg["getChildAt"](0)["control"]["foodbtn"].addEventListener(MouseEvent.CLICK,this.onClickFoodBtnHandler);
                  if(userid1 == GameData.instance.playerData.shenshoudata.userid)
                  {
                     MapView.instance.scene.bg["getChildAt"](0)["control"]["paizi"]["upbtn"].addEventListener(MouseEvent.CLICK,this.onClickLevelUpHandler,false,0,true);
                  }
                  else
                  {
                     MapView.instance.scene.bg["getChildAt"](0)["control"]["paizi"]["txt3"].visible = false;
                  }
                  ToolTip.setDOInfo(MapView.instance.scene.bg["getChildAt"](0)["control"]["paizi"]["expbar"],HtmlUtil.getHtmlText(14,"000000","培育经验:" + obj.growExp + "/" + this.maxlevel[obj.growLevel]));
                  ToolTip.setDOInfo(MapView.instance.scene.bg["getChildAt"](0)["control"]["paizi"]["txt1"],HtmlUtil.getHtmlText(14,"000000","神兽园等级:" + obj.yuanLevel));
                  ToolTip.setDOInfo(MapView.instance.scene.bg["getChildAt"](0)["control"]["paizi"]["txt2"],HtmlUtil.getHtmlText(14,"000000","培育等级:" + obj.growLevel));
                  ToolTip.setDOInfo(MapView.instance.scene.bg["getChildAt"](0)["control"]["paizi"]["upbtn"],HtmlUtil.getHtmlText(14,"000000","升级神兽园"));
               }
               for(i = 0; i < obj.eggslists.length; i++)
               {
                  if(obj.eggslists[i].eggstep != 0)
                  {
                     ao = {};
                     ao.index = obj.eggslists[i].index;
                     ao.iid = String(obj.eggslists[i].eggid) + obj.eggslists[i].eggstep;
                     ao.eggid = obj.eggslists[i].eggid;
                     ao.eggtime = obj.eggslists[i].eggtime;
                     ao.eggstep = obj.eggslists[i].eggstep;
                     ao.eggrate = obj.eggslists[i].eggrate;
                     ao.eggmood = obj.eggslists[i].eggmood;
                     ao.x = 300 + Math.random() * 120;
                     ao.y = 300 + Math.random() * 50;
                     ao.labelName = "" + obj.eggslists[i].labelName;
                     ao.monsterflag = 2;
                     ao.iscontinuemove = 0;
                     monster1 = new AIMonster(ao);
                     monster1.name = IdName.monster(ao.index);
                     MapView.instance.addGameSprite(monster1);
                     ShenshouViewControl.ShenshouList.push(monster1);
                  }
               }
               obj.userId = GameData.instance.playerData.userId;
               obj.userName = GameData.instance.playerData.userName;
               obj.roleType = GameData.instance.playerData.roleType;
               obj.roomlevel = obj.yuanLevel;
               obj.feedlevel = obj.growLevel;
               obj.cloths = "0:" + GameData.instance.playerData.hatId + "|1:" + GameData.instance.playerData.clothId + "|2:" + GameData.instance.playerData.footId + "|3:" + GameData.instance.playerData.weaponId + "|4:" + GameData.instance.playerData.glassId + "|7:" + GameData.instance.playerData.faceId + "|8:" + GameData.instance.playerData.wingId + "|";
               userid2 = uint(GameData.instance.playerData.userId);
               obj.selfshenshou = userid2 == GameData.instance.playerData.shenshoudata.userid ? true : false;
               new Message("addshenshouback",obj).sendToChannel("shenshou");
               if(obj.selfshenshou == true && obj.foods == 0)
               {
                  new FloatAlert().show(WindowLayer.instance,300,400,"食物储备器空空的，快去添加神明果吧。",4,400);
               }
            }
         }
         sendMessage(MsgDoc.OP_CLIENT_SHENSHOU_BAOXIANG.send);
      }
      
      private function onShenshoubaoxiang(event:MouseEvent) : void
      {
         sendMessage(MsgDoc.OP_CLIENT_SHENSHOU_BAOXIANG.send);
      }
      
      private function onClickLevelUpHandler(event:MouseEvent) : void
      {
         var userid:uint = uint(GameData.instance.playerData.userId);
         if(userid != GameData.instance.playerData.shenshoudata.userid)
         {
            new FloatAlert().show(this.view.stage,300,350,"不能帮别人升级神兽园哦。",5,300);
            return;
         }
         new Message("openUpLevel",GameData.instance.playerData.shenshoudata.yuanLevel).sendToChannel("shenshou");
      }
      
      private function onReqUplevel(evt:ChannelEvent) : void
      {
         sendMessage(MsgDoc.OP_CLIENT_SHENSHOU_LEVELUP.send,1);
      }
      
      private function onLevelUpBack(evt:ChannelEvent) : void
      {
         GameData.instance.playerData.coin -= int(evt.getMessage().getBody());
         ++GameData.instance.playerData.shenshoudata.yuanLevel;
         if(Boolean(MapView.instance.scene.bg["getChildAt"](0).hasOwnProperty("control")))
         {
            ToolTip.LooseDO(MapView.instance.scene.bg["getChildAt"](0)["control"]["paizi"]["txt1"]);
            ToolTip.setDOInfo(MapView.instance.scene.bg["getChildAt"](0)["control"]["paizi"]["txt1"],HtmlUtil.getHtmlText(14,"000000","神兽园等级:" + GameData.instance.playerData.shenshoudata.yuanLevel));
            MapView.instance.scene.bg["getChildAt"](0)["control"]["paizi"]["txt1"].text = "" + GameData.instance.playerData.shenshoudata.yuanLevel;
            MapView.instance.scene.bg["getChildAt"](0)["control"]["paizi"]["txt3"].text = "" + GameData.instance.playerData.coin;
         }
      }
      
      private function onClickFoodBtnHandler(event:MouseEvent) : void
      {
         sendMessage(MsgDoc.OP_CLIENT_SHENSHOU_TCOUNTS.send,300030,[1]);
      }
      
      private function onClickJiayuanHandler(event:MouseEvent) : void
      {
         MapView.instance.masterPerson.moveto(60,200,this.goHome);
      }
      
      private function goHome() : void
      {
         this.onCloseShenshou(null);
         sendMessage(MsgDoc.OP_CLIENT_LEFT_SHENSHOU.send,GameData.instance.playerData.serverId);
         GameData.instance.playerData.currentScenenId = 1004;
         dispatch(EventConst.ENTERSCENE,1004);
         FaceView.clip.visible = true;
      }
      
      public function reqSceneGoods() : void
      {
         sendMessage(MsgDoc.OP_CLIENT_SHENSHOU_THINGS.send,1);
      }
      
      private function onSellXianShou(event:ChannelEvent) : void
      {
         sendMessage(MsgDoc.OP_CLIENT_SHENSHOU_SELFOUT.send,event.getMessage().getBody().id,[event.getMessage().getBody().count]);
      }
      
      private function onSellZuoQi(evt:ChannelEvent) : void
      {
         this.sendMessage(MsgDoc.OP_CLIENT_SHENSHOU_SELL_ZUOQI.send,evt.getMessage().getBody().flag,[evt.getMessage().getBody().id]);
      }
      
      private function onReqZhuanhua(evt:ChannelEvent) : void
      {
         var body:Object = evt.getMessage().getBody();
         if(body.mojingfen == 0)
         {
            new FloatAlert().show(this.view.stage,300,400,"神兽转化需要一个魔晶粉哦！",5,250);
         }
         else
         {
            sendMessage(MsgDoc.OP_CLIENT_REQ_ZHUANHUA.send,body.id,[body.mojingfen]);
         }
      }
      
      private function onReqZuoqiList(evt:ChannelEvent) : void
      {
         sendMessage(MsgDoc.OP_CLIENT_REQ_ZUOQILIST.send);
      }
      
      private function onReqMoJingFen(evt:ChannelEvent) : void
      {
         sendMessage(MsgDoc.OP_CLIENT_REQ_PACKAGE_DATA.send,16777345);
      }
      
      private function onOpenBigMapView(evt:ChannelEvent) : void
      {
         dispatch("bobstateclick",{
            "url":"assets/map/BigMapView.swf",
            "xCoord":0,
            "yCoord":0
         });
      }
      
      private function onLeaveByBigMap(evt:MessageEvent) : void
      {
         this.onCloseShenshou(null);
         sendMessage(MsgDoc.OP_CLIENT_LEFT_SHENSHOU.send,GameData.instance.playerData.serverId);
         FaceView.clip.visible = true;
      }
      
      private function onGoto1005(evt:ChannelEvent) : void
      {
         this.onCloseShenshou(null);
         sendMessage(MsgDoc.OP_CLIENT_LEFT_SHENSHOU.send,GameData.instance.playerData.serverId);
         GameData.instance.playerData.currentScenenId = 1005;
         dispatch(EventConst.ENTERSCENE,1005);
         FaceView.clip.visible = true;
      }
      
      private function onShenshouUseTool(evt:ChannelEvent) : void
      {
         var obj:Object = evt.getMessage().getBody();
         sendMessage(MsgDoc.OP_CLIENT_SHENSHOU_USE_TOOLS.send,int(obj.param),[int(obj.id)]);
      }
      
      private function onAddShenshouStep(evt:ChannelEvent) : void
      {
         var ao:Object = evt.getMessage().getBody();
         this.changeShenShouList.push(ao);
         this.reqSceneGoods();
      }
      
      private function onChangeShenshouStep(evt:ChannelEvent) : void
      {
         var ao:Object = null;
         var monster:AIMonster = null;
         var obj:Object = null;
         var eggs:Object = null;
         var j:int = 0;
         var monster1:AIMonster = null;
         var iii:int = 0;
         for(var i:int = 0; i < this.changeShenShouList.length; i++)
         {
            ao = this.changeShenShouList[i];
            for each(monster in ShenshouViewControl.ShenshouList)
            {
               if(monster.name == IdName.monster(ao.index))
               {
                  monster.dispos();
                  iii = int(ShenshouViewControl.ShenshouList.indexOf(monster));
                  ShenshouViewControl.ShenshouList.splice(iii,1);
                  break;
               }
            }
            obj = GameData.instance.playerData.shenshoudata;
            for(j = 0; j < obj.eggslists.length; j++)
            {
               if(ao.index == obj.eggslists[j].index && obj.eggslists[j].eggstep != 0)
               {
                  eggs = obj.eggslists[j];
               }
            }
            if(Boolean(eggs))
            {
               ao.iid = String(eggs.eggid) + eggs.eggstep;
               ao.eggid = eggs.eggid;
               ao.eggtime = eggs.eggtime;
               ao.eggstep = eggs.eggstep;
               ao.eggrate = eggs.eggrate;
               ao.eggmood = eggs.eggmood;
               ao.labelName = "" + eggs.labelName;
            }
            else
            {
               ao.iid = String(ao.eggid) + ao.eggstep;
               if(ao.eggstep < 3 && ao.eggstep > 0)
               {
                  ao.labelName = String(XMLLocator.getInstance().getTool(ao.eggid + 1).name);
               }
               else
               {
                  ao.labelName = String(XMLLocator.getInstance().getTool(ao.eggid).name);
               }
            }
            ao.x = 300 + Math.random() * 120;
            ao.y = 300 + Math.random() * 50;
            ao.monsterflag = 2;
            ao.iscontinuemove = 0;
            monster1 = new AIMonster(ao);
            monster1.name = IdName.monster(ao.index);
            MapView.instance.addGameSprite(monster1);
            ShenshouViewControl.ShenshouList.push(monster1);
         }
         this.changeShenShouList = [];
      }
      
      public function get view() : ShenshouView
      {
         return this.getViewComponent() as ShenshouView;
      }
   }
}

