package com.game.modules.control.pop
{
   import com.core.observer.MessageEvent;
   import com.core.view.ViewConLogic;
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.global.GlobalConfig;
   import com.game.locators.GameData;
   import com.game.locators.MsgDoc;
   import com.game.modules.control.FaceControl;
   import com.game.modules.control.MapControl;
   import com.game.modules.control.battle.BattleControl;
   import com.game.modules.control.task.TaskEvent;
   import com.game.modules.control.task.util.TaskUtils;
   import com.game.modules.view.FaceView;
   import com.game.modules.view.MapView;
   import com.game.modules.view.battle.pvp.PvpView;
   import com.game.modules.view.battle.pvp.PvpWait;
   import com.game.modules.view.pop.CloseServer;
   import com.game.modules.view.pop.PopView;
   import com.game.modules.view.pop.ShowCheckView;
   import com.game.modules.view.pop.SurplusView;
   import com.game.modules.vo.NewsVo;
   import com.game.util.BitValueUtil;
   import com.game.util.FloatAlert;
   import com.game.util.ReConnectStatus;
   import com.game.util.SceneSoundManager;
   import com.game.util.ScreenSprite;
   import com.game.util.ToolTipStringUtil;
   import com.publiccomponent.alert.Alert;
   import com.publiccomponent.loading.XMLLocator;
   import com.xygame.module.battle.util.BattleAlert;
   import flash.events.Event;
   import flash.external.ExternalInterface;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import org.green.server.manager.SocketManager;
   
   public class PopControl extends ViewConLogic
   {
      
      public static const NAME:String = "popControl";
      
      private var mapcontrol:MapControl;
      
      private var _popview:PopView;
      
      private var pvpwait:PvpWait;
      
      private var floatarr:Array = [];
      
      private var contant:int;
      
      private var tempid:int;
      
      private var tempname:String = "";
      
      private var sex:int;
      
      private var timestate:Boolean = false;
      
      private var ttid:int = 0;
      
      public function PopControl(viewComponent:Object = null)
      {
         super(NAME,viewComponent);
      }
      
      override public function listEvents() : Array
      {
         return [[EventConst.ONSHOWALERT,this.onNomalAlert],[EventConst.PLAYERSTATUSCHANGE,this.onPlayerStatusChange],[EventConst.REQUES_BATTLE_WITH,this.onRequesBattleWith],[EventConst.BATTLE_START,this.onStartBattle],[EventConst.BATTLE_CHECK,this.onShowBattleCheck],[EventConst.BATTLE_MD5_SELECT,this.onBattleMD5Select],[EventConst.ADD_FLOAT_ARR,this.onAddFloatArr]];
      }
      
      public function get popview() : PopView
      {
         if(this._popview == null)
         {
            this._popview = new PopView();
         }
         return this._popview;
      }
      
      public function set popview(value:*) : void
      {
         this._popview = value;
      }
      
      private function removePopview() : void
      {
         if(this.popview)
         {
            if(Boolean(this.popview.parent) && Boolean(this.popview.parent.contains(this.popview)))
            {
               this.popview.parent.removeChild(this.popview);
            }
            this.popview = null;
         }
      }
      
      private function onNomalAlert(event:MessageEvent) : void
      {
         var xml:XML = null;
         var csi:int = 0;
         var itemxml:XML = null;
         var vo:NewsVo = null;
         var i:int = 0;
         var vo13:NewsVo = null;
         var vo13bool:Boolean = false;
         var vo1:NewsVo = null;
         var o:NewsVo = null;
         var no:NewsVo = null;
         this.clearAlert();
         this.popview.type = 0;
         if(Boolean(this.popview.parent) && Boolean(this.popview.parent.contains(this.popview)))
         {
            this.popview.parent.removeChild(this.popview);
         }
         if(event.body == null)
         {
            return;
         }
         var type:int = int(event.body.type);
         var desc:String = "";
         var useState:int = 0;
         if(event.body.hasOwnProperty("contant"))
         {
            this.contant = event.body.contant;
            xml = XMLLocator.getInstance().getErrofInfo(this.contant);
            if(Boolean(xml))
            {
               desc = String(xml.desc);
               if(Boolean(event.body.hasOwnProperty("itemid")) && desc.indexOf("itemname") != -1)
               {
                  desc = desc.replace("itemname",ToolTipStringUtil.getToolName(event.body.itemid));
               }
            }
            switch(this.contant)
            {
               case 49:
                  if(Boolean(event.body.itemid) && int(event.body.itemid) != 0)
                  {
                     itemxml = XMLLocator.getInstance().tooldic[int(event.body.itemid)];
                     if(Boolean(itemxml))
                     {
                        useState = int(itemxml.useState);
                        if(BitValueUtil.getBitValue(useState,10))
                        {
                           desc = "藏宝箱中【" + itemxml.name + "】已达上限啦";
                           type = 10;
                        }
                        else
                        {
                           desc = "您背包中【" + itemxml.name + "】已达上限啦";
                        }
                     }
                  }
                  break;
               case 50:
                  csi = GameData.instance.playerData.currentScenenId;
                  if(GameData.instance.playerData.isAutoBattle)
                  {
                     dispatch(EventConst.ENTERSCENE,60001);
                     this.contant = 0;
                  }
                  if(csi != 50001 && csi != 50002 && Boolean(csi))
                  {
                     return;
                  }
                  break;
               default:
                  if(this.contant > 12 && this.contant < 18)
                  {
                     ApplicationFacade.getInstance().retrieveViewLogic(FaceControl.NAME).getViewComponent().topClip.hideVSClip();
                  }
            }
         }
         switch(type)
         {
            case 3:
               vo = new NewsVo();
               vo.alertType = 3;
               vo.msg = desc + "";
               vo.type = 7;
               GameData.instance.boxVipMessages.push(vo);
               GameData.instance.showMessagesCome();
               break;
            case 4:
               ScreenSprite.instance.hide();
               break;
            case 5:
               switch(this.contant)
               {
                  case 1:
                     new Alert().showVip("接受任务需要vip" + event.body.level + "级！");
                     break;
                  case 2:
                     new Alert().showVip("使用道具需要vip" + event.body.level + "级！");
                     break;
                  case 3:
                     new Alert().showVip("购买物品需要vip" + event.body.level + "级！");
                     break;
                  case 4:
                     new Alert().showVip("装备物品需要vip" + event.body.level + "级！");
                     break;
                  case 5:
                     new Alert().showVip("进入场景需要vip" + event.body.level + "级！");
                     break;
                  case 6:
                     new Alert().showVip("该坐骑需要vip" + event.body.level + "级才能用哦！");
                     break;
                  case 7:
                     new Alert().showVip("法术使用需要vip" + event.body.level + "级！");
               }
               break;
            case 10:
               this.floatarr.push(desc);
               if(!this.timestate)
               {
                  this.timestate = true;
                  this.doFloadtAlert();
               }
               break;
            case 12:
               if(desc != "")
               {
                  vo1 = new NewsVo();
                  vo1.alertType = 3;
                  vo1.msg = desc + "" + event.body.temp1 + "历练!";
                  vo1.type = 5;
                  GameData.instance.boxVipMessages.push(vo1);
                  GameData.instance.showMessagesCome();
               }
               break;
            case 13:
               i = 0;
               vo13 = new NewsVo();
               vo13.alertType = 3;
               vo13.type = 5;
               vo13bool = false;
               while(Boolean(event.body["key" + i]))
               {
                  xml = XMLLocator.getInstance().getErrofInfo(event.body["key" + i]);
                  if(Boolean(xml))
                  {
                     vo13.msg += xml.desc + "";
                  }
                  if(Boolean(event.body["value" + i]))
                  {
                     vo13.msg += event.body["value" + i];
                  }
                  i++;
                  vo13bool = true;
               }
               if(vo13bool)
               {
                  GameData.instance.boxMessagesArray.push(vo13);
                  GameData.instance.showMessagesCome();
               }
               break;
            case 15:
               if(desc != "")
               {
                  new Alert().showOne(desc,this.alertFunction);
               }
               break;
            default:
               this.disportPvpWait();
               switch(this.contant)
               {
                  case 17:
                     o = new NewsVo();
                     o.alertType = 3;
                     o.msg = "对方取消了战斗";
                     o.type = 3;
                     GameData.instance.boxMessagesArray.push(o);
                     GameData.instance.showMessagesCome();
                     break;
                  case 105:
                  case 106:
                  case 187:
                  case 188:
                  case 192:
                     no = new NewsVo();
                     no.alertType = 3;
                     no.msg = desc;
                     no.type = 3;
                     GameData.instance.boxMessagesArray.push(no);
                     GameData.instance.showMessagesCome();
                     break;
                  default:
                     FaceView.clip.addChild(this.popview);
                     if(event.body.hasOwnProperty("username"))
                     {
                        desc = event.body.username + desc;
                     }
                     if(!GameData.instance.playerData.isInWarCraft && desc != "")
                     {
                        new Alert().showOne(desc,this.alertFunction,{"useState":useState});
                     }
                     else if(this.popview && this.popview.parent && Boolean(this.popview.parent.contains(this.popview)))
                     {
                        this.popview.parent.removeChild(this.popview);
                     }
               }
               xml = null;
               TaskUtils.getInstance().dispatchEvent(TaskEvent.SHOW_OR_HIDE_BOTTOM,true);
               this.dispatch(EventConst.BATTLE_CAN_NOT_BE_STARTED);
         }
      }
      
      private function alertFunction(... rest) : void
      {
         if(this.popview && Boolean(this.popview.parent))
         {
            if(this.popview.parent.contains(this.popview))
            {
               this.popview.parent.removeChild(this.popview);
               this.popview.type = 0;
               this.mapcontrol = null;
            }
         }
         if(this.contant == 50)
         {
            dispatch(EventConst.ENTERSCENE,60001);
            this.contant = 0;
         }
         else if(this.contant == 150 || this.contant == 191)
         {
            SocketManager.getGreenSocket().close();
            if(ExternalInterface.available)
            {
               ExternalInterface.call("closeshow");
               if(GlobalConfig.isClient)
               {
                  navigateToURL(new URLRequest("javascript:window.parent.location.href=\'http://enter.wanwan4399.com/bin-debug/KBgameindex.html\'"),"_self");
               }
               else
               {
                  navigateToURL(new URLRequest("javascript:window.parent.location.href=\'http://www.4399.com/flash/48399.htm\'"),"_self");
               }
            }
         }
      }
      
      private function clearAlert() : void
      {
         var mv:* = ApplicationFacade.getInstance().retrieveViewLogic(MapControl.NAME).getViewComponent().stage;
         for(var i:int = 0; i < mv.numChildren; i++)
         {
            if(mv.getChildAt(i) is BattleAlert)
            {
               mv.getChildAt(i).close();
               i--;
            }
         }
      }
      
      private function onPlayerStatusChange(event:MessageEvent) : void
      {
         if(int(event.body.type) == 0)
         {
            return;
         }
         switch(GameData.instance.playerData.playerStatus)
         {
            case 0:
               this.mapcontrol = ApplicationFacade.getInstance().retrieveViewLogic(MapControl.NAME) as MapControl;
               this.mapcontrol.getViewComponent().stage.addChild(this.popview);
               new SurplusView("",this.alertFunction,2).show(this.popview,250,120);
               break;
            case 1:
               this.mapcontrol = ApplicationFacade.getInstance().retrieveViewLogic(MapControl.NAME) as MapControl;
               this.mapcontrol.getViewComponent().stage.addChild(this.popview);
               new SurplusView("",this.alertFunction,7).show(this.popview,250,120);
               if(ExternalInterface.available)
               {
                  ExternalInterface.call("timesFunction",3);
                  ExternalInterface.call("taskStateFunction",int(event.body.statetime) / 60,-1,-1,-1,-1);
               }
               break;
            case 2:
               this.mapcontrol = ApplicationFacade.getInstance().retrieveViewLogic(MapControl.NAME) as MapControl;
               this.mapcontrol.getViewComponent().stage.addChild(this.popview);
               new SurplusView("",this.alertFunction,4).show(this.popview,250,120);
               break;
            case 3:
               this.mapcontrol = ApplicationFacade.getInstance().retrieveViewLogic(MapControl.NAME) as MapControl;
               this.mapcontrol.getViewComponent().stage.addChild(this.popview);
               if(int(event.body.statetime) != 18000)
               {
                  new SurplusView("",this.alertFunction,1).show(this.popview,250,120);
               }
               else
               {
                  new SurplusView("",this.alertFunction,6).show(this.popview,250,120);
               }
               ExternalInterface.call("taskStateFunction",int(event.body.statetime) / 60,-1,-1,-1,-1);
               break;
            case 4:
            case 8:
               ReConnectStatus.instance.CLOSS_SERVER = true;
               this.mapcontrol = ApplicationFacade.getInstance().retrieveViewLogic(MapControl.NAME) as MapControl;
               dispatch(EventConst.TEMLEAVE_VISIBLE,{
                  "uid":GameData.instance.playerData.userId,
                  "type":0
               });
               this.mapcontrol.getViewComponent().stage.addChild(this.popview);
               SceneSoundManager.getInstance().stop();
               new CloseServer().show(this.popview,0,0);
               SocketManager.getGreenSocket().close();
               break;
            case 5:
               this.mapcontrol = ApplicationFacade.getInstance().retrieveViewLogic(MapControl.NAME) as MapControl;
               this.mapcontrol.getViewComponent().stage.addChild(this.popview);
               new SurplusView("",this.alertFunction,3).show(this.popview,250,120);
         }
      }
      
      private function onRequesBattleWith(event:MessageEvent) : void
      {
         var pvpview:PvpView = null;
         if(GameData.instance.playerData.playerStatus == 2 || GameData.instance.playerData.playerSurplus == 0)
         {
            new Alert().showOne("今天你已经在西游世界冒险很久了哦，休息休息，养好精神明天再来战斗吧O(∩_∩)O~");
            this.dispatch(EventConst.BATTLE_CAN_NOT_BE_STARTED);
            return;
         }
         this.mapcontrol = ApplicationFacade.getInstance().retrieveViewLogic(MapControl.NAME) as MapControl;
         this.mapcontrol.getViewComponent().stage.addChild(this.popview);
         this.tempid = int(event.body.userId);
         this.tempname = event.body.userName;
         this.sex = event.body.sex;
         if(Boolean(event.body.hasOwnProperty("choose")) && event.body.choose == 1)
         {
            this.onSinglePvpHandler(null);
         }
         else if(Boolean(event.body.hasOwnProperty("choose")) && event.body.choose == 2)
         {
            this.onMultiPvpHandler(null);
         }
         else
         {
            pvpview = new PvpView();
            pvpview.show(this.popview);
            pvpview.addEventListener(PvpView.SINGLE,this.onSinglePvpHandler);
            pvpview.addEventListener(PvpView.MULTI,this.onMultiPvpHandler);
            pvpview.addEventListener(Event.CLOSE,this.onClosePvpHandler);
         }
      }
      
      private function onSinglePvpHandler(event:Event) : void
      {
         sendMessage(MsgDoc.OP_CLIENT_BATTLE_WITH.send,0,[this.tempid,0]);
         this.showPvpWait(1);
      }
      
      private function onMultiPvpHandler(event:Event) : void
      {
         sendMessage(MsgDoc.OP_CLIENT_BATTLE_WITH.send,0,[this.tempid,1]);
         this.showPvpWait(2);
      }
      
      private function onClosePvpHandler(event:Event) : void
      {
         this.disport();
      }
      
      private function showPvpWait(type:int) : void
      {
         this.mapcontrol = ApplicationFacade.getInstance().retrieveViewLogic(MapControl.NAME) as MapControl;
         this.mapcontrol.getViewComponent().stage.addChild(this.popview);
         this.pvpwait = new PvpWait(this.tempname,this.sex,type);
         this.pvpwait.show(this.popview);
         this.pvpwait.addEventListener(Event.CLOSE,this.onClosePvpWait);
      }
      
      private function disportPvpWait() : void
      {
         if(Boolean(this.pvpwait))
         {
            if(Boolean(this.pvpwait.parent) && this.pvpwait.parent.contains(this.pvpwait))
            {
               this.pvpwait.parent.removeChild(this.pvpwait);
            }
            this.pvpwait.disport();
         }
         this.pvpwait = null;
         this.disport();
      }
      
      private function onStartBattle(event:MessageEvent) : void
      {
         this.disportPvpWait();
         this.disport();
      }
      
      private function onClosePvpWait(event:Event) : void
      {
         sendMessage(MsgDoc.OP_CLIENT_BATTLE_WITH.send,3,[this.tempid,1]);
         this.disport();
      }
      
      private function disport() : void
      {
         if(this.mapcontrol == null)
         {
            return;
         }
         if(Boolean(this.mapcontrol) && Boolean(this.mapcontrol.getViewComponent().stage.contains(this.popview)))
         {
            this.mapcontrol.getViewComponent().stage.removeChild(this.popview);
         }
         this.mapcontrol = null;
      }
      
      private function onShowBattleCheck(event:MessageEvent) : void
      {
         var bc:BattleControl = ApplicationFacade.getInstance().retrieveViewLogic(BattleControl.NAME) as BattleControl;
         if(bc.battleView == null)
         {
            this.mapcontrol = ApplicationFacade.getInstance().retrieveViewLogic(MapControl.NAME) as MapControl;
            this.mapcontrol.getViewComponent().stage.addChild(this.popview);
            SceneSoundManager.getInstance().stop();
            new ShowCheckView(this.alertFunction,event.body).show(this.popview,0,0);
         }
         bc = null;
      }
      
      private function onBattleMD5Select(event:MessageEvent) : void
      {
         sendMessage(MsgDoc.OP_CLIENT_BATTLE_MD5.send,int(event.body));
      }
      
      private function onAddFloatArr(event:MessageEvent) : void
      {
         this.floatarr = this.floatarr.concat(event.body);
         if(!this.timestate)
         {
            this.timestate = true;
            this.doFloadtAlert();
         }
      }
      
      private function doFloadtAlert() : void
      {
         var xml:XML = null;
         var s:String = null;
         if(this.floatarr.length > 0)
         {
            clearTimeout(this.ttid);
            this.ttid = setTimeout(this.doFloadtAlert,1500);
         }
         else
         {
            this.timestate = false;
         }
         if(this.floatarr.length > 0)
         {
            this.timestate = true;
            s = this.floatarr.shift() as String;
            new FloatAlert().show(MapView.instance.stage,300,400,s,5,300);
         }
      }
   }
}

