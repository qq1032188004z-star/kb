package com.game.modules.model
{
   import com.channel.Message;
   import com.core.model.Model;
   import com.game.event.EventConst;
   import com.game.global.ItemType;
   import com.game.locators.GameData;
   import com.game.locators.MsgDoc;
   import com.game.manager.AlertManager;
   import com.game.modules.control.shenshou.ShenshouViewControl;
   import com.game.modules.view.MapView;
   import com.game.modules.view.battle.AIMonster;
   import com.game.util.ChatUtil;
   import com.game.util.HtmlUtil;
   import com.game.util.IdName;
   import com.publiccomponent.alert.Alert;
   import com.publiccomponent.loading.XMLLocator;
   import com.publiccomponent.ui.ToolTip;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import org.green.server.events.MsgEvent;
   
   public class ShenShouModel extends Model
   {
      
      private static const maxlevel:Array = [0,80,120,200,360,570,830,1140,1500,1910,2370,2880,3440,4050,4710,5420,6180,6990,7850,8760,9720,10730,11790,12900,14060,15270,16530,17840,19200,20610,22070];
      
      private var leftTime:int;
      
      private var hours:int;
      
      private var minutes:int;
      
      private var tid:int;
      
      private var ratearr:Array = [{
         "id":600001,
         "rate":20
      },{
         "id":600044,
         "rate":40
      },{
         "id":600004,
         "rate":25
      },{
         "id":600007,
         "rate":22
      },{
         "id":600016,
         "rate":13
      },{
         "id":600022,
         "rate":18
      },{
         "id":600087,
         "rate":25
      }];
      
      private var timearr:Array = ["","730|730|820","768|768|864","576|576|648","537|537|605","615|615|690","1152|1152|1296","1305|1305|1468","1382|1382|1555"];
      
      private var counttime:int;
      
      private var friendpackcount:int;
      
      public function ShenShouModel(modelName:String = null)
      {
         super(modelName);
      }
      
      override public function onRegister() : void
      {
         registerListener(MsgDoc.OP_CLIENT_CAN_ENTER_SHENSHOU.back.toString(),this.onCanEnterShenshou);
         registerListener(MsgDoc.OP_CLIENT_SHENSHOU_PACKET.back.toString(),this.onShenShouPack);
         registerListener(MsgDoc.OP_CLIENT_SHENSHOU_RIZHI.back.toString(),this.onShenShourizhiBack);
         registerListener(MsgDoc.OP_CLIENT_SHENSHOU_SHOUJI.back.toString(),this.onShenshouCollect);
         registerListener(MsgDoc.OP_CLIENT_SHENSHOU_ERGAO.back.toString(),this.onShenshouErGao);
         registerListener(MsgDoc.OP_CLIENT_SHENSHOU_THINGS.back.toString(),this.onShenshouThingsBack);
         registerListener(MsgDoc.OP_CLIENT_SHENSHOU_SHOUHUO.back.toString(),this.onShenshouShouhuo);
         registerListener(MsgDoc.OP_CLIENT_SHENSHOU_FOOD.back.toString(),this.onShenshouFoodBack);
         registerListener(MsgDoc.OP_CLIENT_SHENSHOU_GROW.back.toString(),this.onShenshouGrowBack);
         registerListener(MsgDoc.OP_CLIENT_SHENSHOU_LEVELUP.back.toString(),this.onShenshouLevelUp);
         registerListener(MsgDoc.OP_CLIENT_SHENSHOU_TCOUNTS.back.toString(),this.onShenshouTCount);
         registerListener(MsgDoc.OP_CLIENT_SHENSHOU_FANGSHENG.back.toString(),this.onFangshengBack);
         registerListener(MsgDoc.OP_CLIENT_SHENSHOU_FRIENDS.back.toString(),this.onShenshouFriends);
         registerListener(MsgDoc.OP_CLIENT_SHENSHOU_BAOXIANG.back.toString(),this.onBaoXiangBack);
         registerListener(MsgDoc.OP_CLIENT_SHENSHOU_SELFOUT.back.toString(),this.onShenshouSELL);
         registerListener(MsgDoc.OP_CLIENT_REQ_ZHUANHUA.back.toString(),this.onZhuanhuaBack);
         registerListener(MsgDoc.OP_CLIENT_REQ_ZUOQILIST.back.toString(),this.onZuoqiListBack);
         registerListener(MsgDoc.OP_CLIENT_REQ_HORSE_STATE.back.toString(),this.onReqStateBack);
         registerListener(MsgDoc.OP_CLIENT_SHENSHOU_BUY_TOOLS.back.toString(),this.onBuyToolsBack);
         registerListener(MsgDoc.OP_CLIENT_SHENSHOU_USE_TOOLS.back.toString(),this.onUseToolsBack);
         registerListener(MsgDoc.OP_CLIENT_SHENSHOU_SELL_ZUOQI.back.toString(),this.onSellZuoQiBack);
      }
      
      override public function onRemove() : void
      {
         clearInterval(this.tid);
      }
      
      private function onCanEnterShenshou(event:MsgEvent) : void
      {
         O.traceSocket(event);
         if(event.msg.mParams == 1)
         {
            if(GameData.instance.playerData.enterFarmFlag)
            {
               dispatch(EventConst.ENTERSCENE,1018);
            }
            else
            {
               dispatch(EventConst.ENTERSCENE,1013);
            }
            dispatch(EventConst.CLEARUI);
         }
         else
         {
            new Alert().showOne("是否能进入神兽园" + event.msg.mParams);
         }
         clearInterval(this.tid);
         GameData.instance.playerData.enterFarmFlag = false;
      }
      
      private function onShenShouPack(event:MsgEvent) : void
      {
         var result:Array = null;
         var i:int = 0;
         var obj:Object = null;
         var temp:Array = null;
         var j:int = 0;
         var goods:Object = null;
         var xml:XML = null;
         O.traceSocket(event);
         var params:Object = {};
         params.type = event.msg.mParams;
         if(params.type == 5)
         {
            params = event.msg.body;
            dispatch(EventConst.S_RUBBISH_SHENSHOULIST,params);
         }
         else
         {
            params.isocode = event.msg.body.readInt();
            params.packcount = event.msg.body.readInt();
            result = [];
            for(i = 0; i < params.packcount; i++)
            {
               obj = {};
               obj.packcode = event.msg.body.readInt();
               obj.packid = event.msg.body.readInt();
               obj.count = event.msg.body.readInt();
               temp = [];
               for(j = 0; j < obj.count; j++)
               {
                  goods = {};
                  goods.packcode = obj.packcode;
                  goods.packid = obj.packid;
                  goods.position = event.msg.body.readInt();
                  goods.id = event.msg.body.readInt();
                  xml = XMLLocator.getInstance().getTool(goods.id);
                  goods.name = xml.name;
                  goods.price = xml.saleprice;
                  goods.decs = xml.desc;
                  if(goods.id > 0)
                  {
                     goods.count = event.msg.body.readInt();
                     temp.push(goods);
                  }
               }
               temp.sortOn("id",Array.NUMERIC);
               obj.goods = temp;
               result.push(obj);
            }
            params.lists = result;
            new Message("shenshoupacketdata",params).sendToChannel("shenshou");
         }
      }
      
      private function onShenShourizhiBack(event:MsgEvent) : void
      {
         var o:Object = null;
         var xml:XML = null;
         O.traceSocket(event);
         var obj:Object = {};
         obj.type = event.msg.mParams;
         obj.lists = [];
         obj.lists.length = event.msg.body.readInt();
         var l:int = int(obj.lists.length);
         for(var i:int = 0; i < l; i++)
         {
            o = {};
            o.code = event.msg.body.readInt();
            o.opUid = event.msg.body.readUTF();
            o.date = event.msg.body.readInt();
            o.param1 = event.msg.body.readInt();
            o.param2 = event.msg.body.readInt();
            if(o.code == 6 || o.code == 7)
            {
               try
               {
                  xml = XMLLocator.getInstance().getTool(o.param1);
                  o._name = xml.name;
               }
               catch(e:*)
               {
               }
            }
            obj.lists[i] = o;
         }
         new Message("rizhidata",obj).sendToChannel("shenshou");
      }
      
      private function onShenshouCollect(event:MsgEvent) : void
      {
         var o:Object = null;
         O.traceSocket(event);
         var obj:Object = {};
         obj.num = event.msg.body.readInt();
         obj.lists = [];
         for(var i:int = 0; i < obj.num; i++)
         {
            o = {};
            o.id = event.msg.body.readInt();
            obj.lists.push(o);
         }
         new Message("collectdata",obj).sendToChannel("shenshou");
      }
      
      private function onShenshouErGao(event:MsgEvent) : void
      {
         var len:int = 0;
         var i:int = 0;
         O.traceSocket(event);
         var obj:Object = {};
         obj.type = event.msg.mParams;
         obj.success = event.msg.body.readInt();
         if(obj.success == 1)
         {
            obj.index = event.msg.body.readInt();
            if(obj.type == 1)
            {
               AlertManager.instance.showTipAlert({
                  "systemid":1039,
                  "flag":1
               });
               this.AddPeiyuExpHandler(obj.exp);
               new Message("addyaoyaoback",obj).sendToChannel("shenshou");
            }
            else if(obj.type == 2)
            {
               obj.exp = event.msg.body.readInt();
               obj.goods = event.msg.body.readInt();
               if(obj.goods != 0)
               {
                  obj.count = event.msg.body.readInt();
                  AlertManager.instance.showAwardAlert({
                     "toolid":obj.goods,
                     "num":obj.count
                  });
               }
               if(GameData.instance.playerData.userId != GameData.instance.playerData.shenshouyuan_id)
               {
                  obj.infriends = 1;
               }
               this.AddPeiyuExpHandler(obj.exp);
               new Message("addyaoyaoback",obj).sendToChannel("shenshou");
               len = int(GameData.instance.playerData.shenshoudata.elists.length);
               for(i = 0; i < len; i++)
               {
                  if(GameData.instance.playerData.shenshoudata.elists[i].index == obj.index)
                  {
                     GameData.instance.playerData.shenshoudata.elists.splice(i,1);
                     break;
                  }
               }
            }
         }
         else
         {
            AlertManager.instance.showTipAlert({
               "systemid":1039,
               "flag":obj.success,
               "replace":obj.success,
               "defaultTip":true
            });
         }
      }
      
      private function onShenshouThingsBack(event:MsgEvent) : void
      {
         var i:int = 0;
         var e:Object = null;
         var o:Object = null;
         var userid:uint = 0;
         O.traceSocket(event);
         var params:int = event.msg.mParams;
         event.msg.body.position = 0;
         if(params == 2)
         {
            GameData.instance.playerData.shenshouyuanlevel = event.msg.body.readInt();
            GameData.instance.playerData.shenshoupeiyulevel = event.msg.body.readInt();
         }
         var obj:Object = {};
         obj.userid = event.msg.body.readUnsignedInt();
         obj.growLevel = event.msg.body.readInt();
         obj.growExp = event.msg.body.readInt();
         obj.yuanLevel = event.msg.body.readInt();
         obj.foods = event.msg.body.readInt();
         obj.foodx = event.msg.body.readInt();
         obj.foody = event.msg.body.readInt();
         obj.ecount = event.msg.body.readInt();
         obj.elists = [];
         for(i = 0; i < obj.ecount; i++)
         {
            e = {};
            e.index = event.msg.body.readInt();
            e.type = event.msg.body.readInt();
            obj.elists.push(e);
         }
         obj.eggscount = event.msg.body.readInt();
         obj.eggslists = [];
         for(i = 0; i < obj.eggscount; i++)
         {
            o = {};
            o.index = event.msg.body.readInt();
            o.eggid = event.msg.body.readInt();
            o.eggstep = event.msg.body.readInt();
            o.eggtime = event.msg.body.readInt();
            o.eggrate = event.msg.body.readInt();
            o.eggmood = event.msg.body.readInt();
            if(o.eggstep < 3 && o.eggstep > 0)
            {
               o.labelName = XMLLocator.getInstance().getTool(o.eggid + 1).name;
            }
            else
            {
               o.labelName = XMLLocator.getInstance().getTool(o.eggid).name;
            }
            userid = uint(GameData.instance.playerData.userId);
            o.selfshenshou = Boolean(obj.userid == userid);
            obj.eggslists.push(o);
            O.o(o.labelName + "--时间：" + o.eggtime);
         }
         GameData.instance.playerData.shenshoudata = obj;
         if(params == 2)
         {
            this.tid = setInterval(this.loopDuce,60000);
         }
         if(params == 1)
         {
            new Message("changeShenshouStep",null).sendToChannel("shenshou");
         }
      }
      
      private function onShenshouTCount(event:MsgEvent) : void
      {
         var obj:Object = null;
         O.traceSocket(event);
         var flag:int = event.msg.body.readInt();
         event.msg.body.position = 0;
         if(flag == 1)
         {
            GameData.instance.playerData.shenshoudata.shenmingcount = event.msg.mParams;
            obj = GameData.instance.playerData.shenshoudata;
            new Message("showfoodview",obj).sendToChannel("shenshou");
         }
      }
      
      private function onFangshengBack(event:MsgEvent) : void
      {
         var monster:AIMonster = null;
         var iii:int = 0;
         O.traceSocket(event);
         var obj:Object = {};
         obj.index = event.msg.mParams;
         var temp:Array = GameData.instance.playerData.shenshoudata.eggslists;
         for(var i:int = 0; i < temp.length; i++)
         {
            if(temp[i].index == obj.index)
            {
               obj.eggid = temp[i].eggid;
            }
         }
         new Message("fangshengback",obj).sendToChannel("shenshou");
         for each(monster in ShenshouViewControl.ShenshouList)
         {
            if(monster.name == IdName.monster(obj.index))
            {
               monster.dispos();
               iii = int(ShenshouViewControl.ShenshouList.indexOf(monster));
               ShenshouViewControl.ShenshouList.splice(iii,1);
               break;
            }
         }
         this.delShenshou(obj);
      }
      
      private function onShenshouShouhuo(event:MsgEvent) : void
      {
         var params:Object = null;
         var monster:AIMonster = null;
         var iii:int = 0;
         O.traceSocket(event);
         var obj:Object = {};
         obj.index = event.msg.mParams;
         obj.exp = event.msg.body.readInt();
         this.AddPeiyuExpHandler(obj.exp);
         for each(monster in ShenshouViewControl.ShenshouList)
         {
            if(monster.name == IdName.monster(obj.index))
            {
               params = monster.data;
               monster.dispos();
               iii = int(ShenshouViewControl.ShenshouList.indexOf(monster));
               ShenshouViewControl.ShenshouList.splice(iii,1);
               break;
            }
         }
         this.delShenshou(obj);
         new Message("shouhuoback",params).sendToChannel("shenshou");
      }
      
      private function delShenshou(value:Object) : void
      {
         var i:int = 0;
         var l:int = int(GameData.instance.playerData.shenshoudata.eggslists.length);
         for(i = 0; i < l; i++)
         {
            if(Boolean(GameData.instance.playerData.shenshoudata.eggslists[i]) && GameData.instance.playerData.shenshoudata.eggslists[i].index == value.index)
            {
               GameData.instance.playerData.shenshoudata.eggslists.splice(i,1);
            }
         }
      }
      
      private function AddPeiyuExpHandler(exp:int) : void
      {
         var level:int = 0;
         var current:int = 0;
         if(GameData.instance.playerData.userId == GameData.instance.playerData.shenshouyuan_id)
         {
            if(GameData.instance.playerData.currentScenenId == 1013 && Boolean(MapView.instance.scene.bg["getChildAt"](0).hasOwnProperty("control")))
            {
               this.setNewExp(exp);
               level = int(GameData.instance.playerData.shenshoudata.growLevel);
               current = int(GameData.instance.playerData.shenshoudata.growExp);
               MapView.instance.scene.bg["getChildAt"](0)["control"]["paizi"]["txt2"].text = "" + level;
               MapView.instance.scene.bg["getChildAt"](0)["control"]["paizi"]["expbar"].gotoAndStop(int(100 * current / maxlevel[level]));
               ToolTip.setDOInfo(MapView.instance.scene.bg["getChildAt"](0)["control"]["paizi"]["txt2"],HtmlUtil.getHtmlText(14,"000000","培育等级:" + level));
               ToolTip.setDOInfo(MapView.instance.scene.bg["getChildAt"](0)["control"]["paizi"]["expbar"],HtmlUtil.getHtmlText(14,"000000","培育经验:" + current + "/" + maxlevel[level]));
            }
         }
      }
      
      private function setNewExp(exp:int) : void
      {
         var level:int = int(GameData.instance.playerData.shenshoudata.growLevel);
         var current:int = int(GameData.instance.playerData.shenshoudata.growExp);
         var count:int = exp + current - maxlevel[level];
         if(count >= 0)
         {
            ++GameData.instance.playerData.shenshoudata.growLevel;
            GameData.instance.playerData.shenshoudata.growExp = count;
            this.setNewExp(0);
         }
         else
         {
            GameData.instance.playerData.shenshoudata.growExp = exp + current;
         }
      }
      
      private function onShenshouFoodBack(event:MsgEvent) : void
      {
         O.traceSocket(event);
         event.msg.mParams;
         GameData.instance.playerData.shenshoudata.foods = event.msg.body.readInt();
         GameData.instance.playerData.shenshoudata.shenmingcount = event.msg.body.readInt();
         O.o("数量" + GameData.instance.playerData.shenshoudata.shenmingcount + "数量" + GameData.instance.playerData.shenshoudata.foods);
         var obj:Object = GameData.instance.playerData.shenshoudata;
      }
      
      private function onShenshouGrowBack(event:MsgEvent) : void
      {
         var ao:Object = null;
         var obj:Object = null;
         O.traceSocket(event);
         if(event.msg.mParams == 1)
         {
            ao = {};
            ao.type = event.msg.mParams;
            ao.eggid = event.msg.body.readInt();
            ao.index = event.msg.body.readInt();
            ao.eggstep = event.msg.body.readInt();
            ao.eggtime = event.msg.body.readInt();
            ao.eggrate = 100;
            ao.eggmood = 0;
            for each(obj in this.ratearr)
            {
               if(ao.eggid == obj.id)
               {
                  ao.eggrate = obj.rate;
               }
            }
            ao.labelName = "" + XMLLocator.getInstance().getTool(ao.eggid).name;
            ao.monsterflag = 2;
            ao.iscontinuemove = 0;
            ao.selfshenshou = true;
            new Message("fuhuadandan",ao).sendToChannel("shenshou");
            GameData.instance.playerData.shenshoudata.eggslists.push(ao);
         }
         else
         {
            AlertManager.instance.showTipAlert({
               "systemid":1040,
               "flag":event.msg.mParams,
               "replace":event.msg.mParams,
               "defaultTip":true
            });
         }
      }
      
      private function onShenshouLevelUp(event:MsgEvent) : void
      {
         O.traceSocket(event);
         var obj:Object = {};
         obj.type = event.msg.mParams;
         if(obj.type == 1)
         {
            new Message("levelupback",GameData.instance.playerData.shenshoudata.yuanLevel).sendToChannel("shenshou");
         }
         else
         {
            AlertManager.instance.showTipAlert({
               "systemid":1041,
               "flag":obj.type,
               "replace":obj.type,
               "defaultTip":true
            });
         }
      }
      
      private function loopDuce() : void
      {
         var i:int = 0;
         var hasFood:Boolean = false;
         try
         {
            hasFood = Boolean(GameData.instance.playerData.shenshoudata) && Boolean(GameData.instance.playerData.shenshoudata.foods);
            if(hasFood)
            {
               new Message("timeChange").sendToChannel("shenshou");
               O.o("时间-1分钟！！！！！！！！！！！！！！");
            }
            ++this.counttime;
            if(this.counttime == 60)
            {
               if(Boolean(GameData.instance.playerData.shenshoudata) && Boolean(GameData.instance.playerData.shenshoudata.foods))
               {
                  --GameData.instance.playerData.shenshoudata.foods;
               }
               this.counttime = 0;
            }
         }
         catch(e:*)
         {
            O.o("【Error ShenShouModel】" + e);
         }
      }
      
      private function onShenshouFriends(event:MsgEvent) : void
      {
         var i:int = 0;
         var len:int = 0;
         var p:int = 0;
         var o:Object = null;
         ++this.friendpackcount;
         var obj:Object = {};
         obj.userid = event.msg.mParams;
         event.msg.body.position = 0;
         var state:int = event.msg.body.readInt();
         O.o("收到服务端消息",O.getMsgHeadInfo(event));
         if(state == 1)
         {
            obj.myself = Boolean(GameData.instance.playerData.shenshouyuan_id == GameData.instance.playerData.userId);
            obj.lists = [];
            obj.friendcount = event.msg.body.readInt();
            for(i = 0; i < obj.friendcount; i++)
            {
               o = {};
               o.userId = event.msg.body.readUnsignedInt();
               if(o.userId == 0)
               {
                  o = null;
               }
               else
               {
                  o.userName = ChatUtil.onCheckStr(event.msg.body.readUTF());
                  o.vip = event.msg.body.readInt();
                  o.roleType = event.msg.body.readInt();
                  o.sex = o.roleType & 1;
                  o.cloths = event.msg.body.readUTF();
                  o.roomlevel = event.msg.body.readInt();
                  o.feedlevel = event.msg.body.readInt();
                  o.makelevel = event.msg.body.readInt();
                  obj.lists.push(o);
               }
            }
            GameData.instance.shenshoufriends = obj.lists;
            GameData.instance.shenshoufriends.sortOn("userId",Array.NUMERIC);
            GameData.instance.shenshoufriends.sortOn("feedlevel",Array.NUMERIC);
            GameData.instance.shenshoufriends.reverse();
            if(!GameData.instance.playerData.shenshoudata)
            {
               GameData.instance.playerData.shenshoudata = {};
            }
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
            obj.userdata = GameData.instance.playerData;
            obj.lists = GameData.instance.shenshoufriends.concat();
            new Message("friendsdata",obj).sendToChannel("shenshou");
         }
      }
      
      private function onBaoXiangBack(event:MsgEvent) : void
      {
         O.traceSocket(event);
         var obj:Object = {};
         obj.param = event.msg.mParams;
         if(obj.param == 2)
         {
            obj.goodid = event.msg.body.readInt();
            obj.goodnum = event.msg.body.readInt();
            AlertManager.instance.showAwardAlert({
               "toolid":obj.goodid,
               "num":obj.goodnum,
               "arrows":false,
               "stage":MapView.instance.stage
            });
         }
      }
      
      private function onShenshouSELL(event:MsgEvent) : void
      {
         var tempFlag:int = 0;
         O.traceSocket(event);
         if(event.msg.mParams > 0)
         {
            GameData.instance.playerData.coin += event.msg.mParams;
            AlertManager.instance.showTipAlert({
               "systemid":1042,
               "flag":1,
               "replace":event.msg.mParams
            });
         }
         else
         {
            AlertManager.instance.showTipAlert({
               "systemid":1042,
               "flag":event.msg.mParams,
               "defaultTip":true
            });
         }
      }
      
      private function onZhuanhuaBack(evt:MsgEvent) : void
      {
         var xml:XML = null;
         var flag:int = 0;
         O.traceSocket(evt);
         var obj:Object = {};
         if(evt.msg.mParams == 1)
         {
            flag = evt.msg.body.readInt();
            if(flag == 1)
            {
               obj.id = evt.msg.body.readInt();
               obj.iid = evt.msg.body.readInt();
               obj.hp = evt.msg.body.readInt();
               obj.sp = evt.msg.body.readInt();
               obj.qmd = evt.msg.body.readInt();
               xml = XMLLocator.getInstance().getTool(obj.iid);
               if(xml != null)
               {
                  obj.name = xml.name;
                  obj.decs = xml.decs;
                  obj.count = 1;
                  obj.packid = ItemType.zuoqiType;
                  GameData.instance.playerData.zuoqiArr.push(obj);
                  AlertManager.instance.showAwardAlert({"toolid":obj.iid});
               }
            }
            else if(flag == 2)
            {
               obj.iid = evt.msg.body.readInt();
               AlertManager.instance.showAwardAlert({"monsterid":obj.iid});
            }
         }
         else
         {
            AlertManager.instance.showTipAlert({
               "systemid":1043,
               "flag":evt.msg.mParams,
               "replace":evt.msg.mParams,
               "defaultTip":true
            });
         }
      }
      
      private function onZuoqiListBack(evt:MsgEvent) : void
      {
         var zuo:Object = null;
         var i:int = 0;
         var xml:XML = null;
         O.traceSocket(evt);
         GameData.instance.playerData.horseIndex = evt.msg.mParams;
         var ostime:int = evt.msg.body.readInt();
         var sellflag:int = evt.msg.body.readInt();
         var mcount:int = evt.msg.body.readInt();
         var flag:int = evt.msg.body.readInt();
         var count:int = evt.msg.body.readInt();
         var list:Array = [];
         for(i = 0; i < count; i++)
         {
            zuo = {};
            zuo.id = evt.msg.body.readInt();
            zuo.iid = evt.msg.body.readInt();
            zuo.zuoId = zuo.iid;
            zuo.date = evt.msg.body.readInt();
            zuo.hp = evt.msg.body.readInt();
            zuo.jhp = evt.msg.body.readInt();
            zuo.sp = evt.msg.body.readInt();
            zuo.qmd = evt.msg.body.readInt();
            zuo.cssj = evt.msg.body.readInt();
            xml = XMLLocator.getInstance().getTool(zuo.iid);
            if(xml != null)
            {
               zuo.price = xml.saleprice;
               zuo.name = String(xml.name);
               zuo.decs = String(xml.decs);
               zuo.sortValue = int(xml.sortValue);
            }
            else
            {
               zuo.name = "";
               zuo.decs = "";
            }
            zuo.count = 1;
            zuo.packid = ItemType.zuoqiType;
            zuo.isuse = 1;
            if(zuo.id == GameData.instance.playerData.horseIndex)
            {
               zuo.isuse = 2;
            }
            list.push(zuo);
         }
         if(count != -1)
         {
            GameData.instance.playerData.zuoqiArr = list;
         }
         if(flag == 0 && mcount > 0)
         {
            AlertManager.instance.showTipAlert({
               "systemid":1047,
               "flag":1,
               "replace":mcount
            });
         }
         if(sellflag != 0)
         {
            GameData.instance.playerData.coin += int(sellflag);
            AlertManager.instance.showTipAlert({
               "systemid":1047,
               "flag":-1000,
               "replace":sellflag
            });
         }
         dispatch(EventConst.ZUOQILIST_BACK,{
            "count":count,
            "flag":flag,
            "ostime":ostime,
            "sellflag":sellflag
         });
         new Message("zuoqisellinformation",{
            "ostime":ostime,
            "sellflag":sellflag
         }).sendToChannel("shenshou");
      }
      
      private function onReqStateBack(evt:MsgEvent) : void
      {
         O.traceSocket(evt);
         var zuo:Object = {};
         zuo.id = evt.msg.body.readInt();
         zuo.iid = evt.msg.body.readInt();
         zuo.date = evt.msg.body.readInt();
         zuo.hp = evt.msg.body.readInt();
         zuo.jhp = evt.msg.body.readInt();
         zuo.sp = evt.msg.body.readInt();
         zuo.qmd = evt.msg.body.readInt();
         var xml:XML = XMLLocator.getInstance().getTool(zuo.iid);
         if(xml != null)
         {
            zuo.name = xml.name;
            zuo.decs = xml.decs;
         }
         else
         {
            zuo.name = "未知";
            zuo.decs = "未知";
         }
         zuo.count = 1;
         zuo.packid = ItemType.zuoqiType;
         zuo.isuse = 1;
         if(zuo.id == GameData.instance.playerData.horseIndex)
         {
            zuo.isuse = 2;
         }
         dispatch(EventConst.ZUOQISTATE_BACK,zuo);
      }
      
      private function onBuyToolsBack(evt:MsgEvent) : void
      {
         var xml:XML = null;
         O.traceSocket(evt);
         var tool:Object = {};
         if(evt.msg.mParams > 0)
         {
            tool.id = evt.msg.body.readInt();
            tool.count = evt.msg.body.readInt();
            AlertManager.instance.showTipAlert({
               "systemid":1044,
               "flag":1
            });
            xml = XMLLocator.getInstance().getTool(tool.id);
            if(xml == null)
            {
               return;
            }
            if(GameData.instance.playerData.isVip)
            {
               GameData.instance.playerData.coin -= int(xml.price * tool.count * 0.8);
            }
            else
            {
               GameData.instance.playerData.coin -= xml.price * tool.count;
            }
         }
         else
         {
            AlertManager.instance.showTipAlert({
               "systemid":1044,
               "flag":evt.msg.mParams,
               "replace":evt.msg.mParams,
               "defaultTip":true
            });
         }
      }
      
      private function onUseToolsBack(evt:MsgEvent) : void
      {
         var param:Object = null;
         O.traceSocket(evt);
         if(evt.msg.mParams == 1)
         {
            AlertManager.instance.showTipAlert({
               "systemid":1045,
               "flag":1
            });
            param = {};
            param.tool = evt.msg.body.readInt();
            param.index = evt.msg.body.readInt();
            param.iid = evt.msg.body.readInt();
            param.step = evt.msg.body.readInt();
            param.time = evt.msg.body.readInt();
            param.rate = evt.msg.body.readInt();
            param.mode = evt.msg.body.readInt();
            new Message("UseToolBack",param).sendToChannel("shenshou");
         }
         else if(evt.msg.mParams == -1)
         {
            AlertManager.instance.showTipAlert({
               "systemid":1045,
               "flag":-1
            });
         }
      }
      
      private function onSellZuoQiBack(evt:MsgEvent) : void
      {
         var money:int = 0;
         O.traceSocket(evt);
         var param:int = evt.msg.mParams;
         if(param == 3)
         {
            money = evt.msg.body.readInt();
            GameData.instance.playerData.coin += money;
            AlertManager.instance.showTipAlert({
               "systemid":1046,
               "flag":3,
               "replace":money
            });
         }
         else
         {
            AlertManager.instance.showTipAlert({
               "systemid":1046,
               "flag":param,
               "replace":param,
               "defaultTip":true
            });
         }
      }
   }
}

