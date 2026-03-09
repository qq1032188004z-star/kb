package com.game.modules.control
{
   import com.channel.Message;
   import com.core.observer.MessageEvent;
   import com.core.view.ViewConLogic;
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.global.GlobalConfig;
   import com.game.locators.CacheData;
   import com.game.locators.GameData;
   import com.game.locators.GlobalAPI;
   import com.game.locators.MsgDoc;
   import com.game.manager.EventManager;
   import com.game.manager.MouseManager;
   import com.game.modules.ai.SpecialAreaManager;
   import com.game.modules.view.EvolutionBattleEnd;
   import com.game.modules.view.FaceView;
   import com.game.modules.view.MapView;
   import com.game.modules.view.PackView;
   import com.game.modules.view.SystemSetting;
   import com.game.modules.view.WindowLayer;
   import com.game.modules.view.action.ActionView;
   import com.game.modules.view.chat.MutilChatView;
   import com.game.modules.view.family.FamilyJoinIn;
   import com.game.modules.view.magic.MagicView;
   import com.game.modules.view.proposal.ProposalView;
   import com.game.modules.view.task.TaskView;
   import com.game.modules.view.team.TeamNotScene;
   import com.game.modules.vo.BossRemarkData;
   import com.game.util.ChatUtil;
   import com.game.util.ChractorFilter;
   import com.game.util.DelayShowUtil;
   import com.game.util.FloatAlert;
   import com.game.util.FriendAlert;
   import com.game.util.GameDynamicUI;
   import com.game.util.GamePersonControl;
   import com.game.util.SceneSoundManager;
   import com.game.util.ShareLocalUtil;
   import com.kb.util.CommonDefine;
   import com.publiccomponent.alert.Alert;
   import com.publiccomponent.events.InterfaceEvent;
   import com.publiccomponent.events.ItemClickEvent;
   import com.publiccomponent.ui.ButtonEffect;
   import com.publiccomponent.ui.InterFaceUI;
   import com.publiccomponent.ui.TopButton;
   import com.publiccomponent.util.ButtonEffectUtil;
   import com.xygame.module.battle.util.BattleAlert;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.utils.Dictionary;
   import flash.utils.clearInterval;
   import flash.utils.getQualifiedClassName;
   import flash.utils.getTimer;
   import flash.utils.setInterval;
   import flash.utils.setTimeout;
   import mx.utils.StringUtil;
   import org.dress.util.MaterialCache;
   import org.green.server.data.MsgPacket;
   
   public class FaceControl extends ViewConLogic
   {
      
      public static const NAME:String = "facemediator";
      
      private var cid:int;
      
      private var type:int;
      
      private var lastClickTime:Number = 0;
      
      private var isTemLeave:Boolean = true;
      
      private var rightUpClipOneId:int;
      
      private var hasClickArena:Boolean = false;
      
      private var iconstate:Dictionary = new Dictionary(false);
      
      private var battleArr:Array = [];
      
      private var otherid:int;
      
      private var myid:int;
      
      private var pktype:int;
      
      private var roletype:int;
      
      private var pkname:String;
      
      private var magicStopTime:int = 1000;
      
      public function FaceControl(viewCompoenent:Object)
      {
         super(NAME,viewCompoenent);
         this.initEvent();
      }
      
      private function initEvent() : void
      {
         EventManager.attachEvent(this.view,InterfaceEvent.FACECLIPCLICK,this.onFaceClick);
         EventManager.attachEvent(this.view.smile,ItemClickEvent.ITEMCLICKEVENT,this.sendFace);
         EventManager.attachEvent(this.view,MouseEvent.ROLL_OVER,this.onRollOver);
         EventManager.attachEvent(this.view,MouseEvent.ROLL_OUT,this.onRollOut);
         EventManager.attachEvent(this.view.bottomClip,Event.COMPLETE,this.timeUp);
         GameData.instance.addEventListener("boxMessageschange",this.boxMessagesChange);
         EventManager.attachEvent(this.view.middleClip,EventConst.EFFECT_REQUEST_CHANGE_STATE,this.onEffectChangeHandler);
         ButtonEffectUtil.registerEffect(this.view.getTopButton("phonePlayBtn"),ButtonEffect.EFFECT_AWARD1,true);
         ButtonEffectUtil.registerEffect(this.view.getTopButton("yearVipMc"),ButtonEffect.EFFECT_WEEKLY,true);
         FaceView.clip.topClip.hideBtnByName("PineappleShopBtn");
      }
      
      private function onCompanyCheckHandler(con:String, other:Object) : void
      {
         sendMessage(MsgDoc.OP_CLIENT_CHAT.send,0,[1,0,con]);
         this.view.sendChatMsg();
      }
      
      private function onRollOver(evt:MouseEvent) : void
      {
         MouseManager.getInstance().hideCursor();
      }
      
      private function onRollOut(evt:MouseEvent) : void
      {
         MouseManager.getInstance().showCursor();
      }
      
      public function get view() : InterFaceUI
      {
         return this.getViewComponent() as InterFaceUI;
      }
      
      public function boxMessagesChange(event:Event) : void
      {
         if(Boolean(FaceView.clip) && Boolean(FaceView.clip.bottomClip))
         {
            FaceView.clip.bottomClip.setNewsTipApply(GameData.instance.boxMessagesArray.length + GameData.instance.boxVipMessages.length);
         }
      }
      
      override public function listEvents() : Array
      {
         return [[EventConst.NEWEMAILCOME,this.onNewEmailCome],[EventConst.BE_REQUES_BATTLE,this.onBeRequesBattle],[EventConst.CHATWITHFRIEND,this.onChatWithFriend],[EventConst.MAKEFRIENDBACK,this.onMakeFriendBack],[EventConst.ONGETRIGHTUPCLIPBACK,this.onGetRightUpClipBack],[EventConst.SENDPRIMSGBACK,this.onSendMsgBack],[EventConst.FAMILYPRIMSGBACK,this.onFamilyMsgBack],[EventConst.ACCEPT_OR_REFUSE_FRIENDASK,this.refuseOrAccept],[EventConst.FACEUIOPERATE,this.faceUIOperate],[EventConst.CHANGESCENENAME,this.changeSceneName],[EventConst.PLAYERSTATUSCHANGE,this.playerStateChange],[EventConst.ADDFRIENDMSG,this.onAddFriendMsg],[EventConst.WARCRAFT_INVITE,this.onWarcraftInvite],[EventConst.START_CREATE_FAMILY,this.onStartCreateFamily],[EventConst.ENTERSHENSHOU,this.onEnterShenshou],[EventConst.MUTILCHATBACK,this.onChatBack],[EventConst.TEAM_OPEN_MESSAGE_VIEW,this.onTeamOpenMessage],[EventConst.TEAM_CLOSE_MESSAGE_VIEW,this.onTeamCloseMessage],[EventConst.SHOW_PERSON_PAPERHORSE,this.onShowPersonPaperhorse]
         ,[EventConst.GETCHATDRESSBACK,this.getChatDressBack],[EventConst.EFFECT_SHOW,this.onEffectShowHandler],[EventConst.EFFECT_STATEBACK,this.onEffectTip],[EventConst.SEND_USER_TO_FAMILY_BASE,this.onEnterFamilyBase],[EventConst.VERYDAY_SHOWEFFECT,this.onVeryDayShowEffect],[EventConst.FRIENDMSGEMPTY,this.onFriendMsgEmpty],[EventConst.DAILYCOMPASS_UPDATE,this.onDailyCompassUpdate],[EventConst.EVOLUTION_BATTLE_END,this.onEvolutionBattleEnd],[EventConst.ACHIEVEMENT_NOTIFY_AWARD,this.onAchievementNotifyAward],[EventConst.BOSSREMARK_NOTIFY_INFO,this.onBossRemarkNotifyInfo],[EventConst.BOSSREMARK_NOTIFY_DEAD,this.onBossRemarkNotifyDead],[EventConst.PHONE_PLAY_BONUS,this.onPhonePlayNotifyAward]];
      }
      
      private function onFriendMsgEmpty(evt:MessageEvent) : void
      {
         this.view.bottomClip.setFriendClickType(1);
      }
      
      private function onDailyCompassUpdate(evt:MessageEvent) : void
      {
         var params:Object = evt.body;
         var dailyCompass:int = int(params.dailyCompass);
         ButtonEffectUtil.registerEffect(this.view.getTopButton("dailyCompass"),ButtonEffect.EFFECT_AWARD1,true);
      }
      
      private function onEvolutionBattleEnd(evt:MessageEvent) : void
      {
         var params:Object = evt.body;
         params.showX = 0;
         params.showY = 0;
         dispatch(EventConst.OPEN_CACHE_VIEW,params,null,getQualifiedClassName(EvolutionBattleEnd));
      }
      
      private function onAchievementNotifyAward(evt:MessageEvent) : void
      {
         ButtonEffectUtil.registerEffect(this.view.getTopButton("achieveBtn"),ButtonEffect.EFFECT_AWARD1,true);
      }
      
      private function onBossRemarkNotifyInfo(evt:MessageEvent) : void
      {
         var params:Object = evt.body;
         var isOpen:Boolean = params.open == 1;
         var isBossDead:Boolean = params.bossHp <= 0;
         clearInterval(BossRemarkData.instance.tid);
         ButtonEffectUtil.delEffect(this.view.getTopButton("bossWarBtn"));
         BossRemarkData.instance.isEffBtn = false;
         if(isOpen && !isBossDead)
         {
            ButtonEffectUtil.registerEffect(this.view.getTopButton("bossWarBtn"),ButtonEffect.EFFECT_LIGHT,true);
            BossRemarkData.instance.isEffBtn = true;
         }
         else if(!isOpen)
         {
            BossRemarkData.instance.tid = setInterval(this.onBossRemarkInterval,1000);
         }
      }
      
      private function onBossRemarkInterval() : void
      {
         var date:Date = new Date();
         date.setTime(GameData.instance.playerData.systemTimes * 1000);
         var hour:int = date.hours;
         if(hour >= 15)
         {
            if(!BossRemarkData.instance.isEffBtn)
            {
               clearInterval(BossRemarkData.instance.tid);
               ButtonEffectUtil.registerEffect(this.view.getTopButton("bossWarBtn"),ButtonEffect.EFFECT_LIGHT,true);
            }
         }
      }
      
      private function onBossRemarkNotifyDead(evt:MessageEvent) : void
      {
         var isEffBtn:Boolean = false;
         var params:Object = evt.body;
         var isBossDead:Boolean = params.bossHp <= 0;
         if(isBossDead)
         {
            clearInterval(BossRemarkData.instance.tid);
            ButtonEffectUtil.delEffect(this.view.getTopButton("bossWarBtn"));
         }
         else if(!BossRemarkData.instance.isEffBtn)
         {
            clearInterval(BossRemarkData.instance.tid);
            ButtonEffectUtil.registerEffect(this.view.getTopButton("bossWarBtn"),ButtonEffect.EFFECT_LIGHT,true);
         }
         BossRemarkData.instance.isEffBtn = isEffBtn;
      }
      
      private function onStartCreateFamily(evt:MessageEvent) : void
      {
         if(GameData.instance.playerData.create_flag)
         {
            dispatch(EventConst.OPENSWFWINDOWS,{
               "url":"assets/family/familyTreaty.swf",
               "xCoord":130,
               "yCoord":0
            });
         }
         else if(GameData.instance.playerData.family_id > 0)
         {
            new FloatAlert().show(this.view,350,400,"必须离开现在的家族，才能创建家族哦！",5,300);
         }
         else if(GameData.instance.playerData.coin < 1000)
         {
            new FloatAlert().show(this.view,350,400,"你身上的铜钱不够支付创建家族的费用哦！",5,300);
         }
         else
         {
            sendMessage(MsgDoc.OP_CLIENT_REQ_CREATE_FAMILY.send,0,[]);
         }
      }
      
      private function refuseOrAccept(evt:MessageEvent) : void
      {
         var params:Object = evt.body;
         var uid:uint = uint(params.id);
         sendMessage(MsgDoc.OP_CLIENT_AGREE_MAKE_FRIEND.send,uid,[params.type,params.name,params.roleType]);
      }
      
      private function onGetRightUpClipBack(event:MessageEvent) : void
      {
         var params:Object = event.body;
         if(params.type != 1)
         {
            if(params.type != 2)
            {
               if(params.type == 4)
               {
                  if(params.taskId != 0)
                  {
                     if(GameData.instance.playerData.isNewHand > 8)
                     {
                     }
                  }
               }
               else if(params.type != 5)
               {
                  if(params.type != 6)
                  {
                     if(params.type == 7)
                     {
                        this.view.topClip.showNewShiBao();
                     }
                  }
               }
            }
         }
         if(params.type < 10)
         {
            this.iconstate[params.type] == params.taskId;
         }
      }
      
      private function onBeRequesBattle(event:MessageEvent) : void
      {
         var onBattleAlertNo:Function;
         var tempid:int = 0;
         var ba:BattleAlert = null;
         var msg:MsgPacket = event.body as MsgPacket;
         if(msg.mParams == 4)
         {
            this.myid = msg.body.readInt();
            this.otherid = msg.body.readInt();
            this.pktype = msg.body.readInt();
            this.roletype = msg.body.readInt();
            try
            {
               this.pkname = msg.body.readUTF();
            }
            catch(e:*)
            {
            }
            this.view.topClip.showVSClip();
            EventManager.attachEvent(this.view.getTopButton("vsBtn"),MouseEvent.CLICK,this.onClickVsBtn);
         }
         else if(msg.mParams == 0)
         {
            onBattleAlertNo = function(event:Event):void
            {
               sendMessage(MsgDoc.OP_CLIENT_BATTLE_WITH.send,3,[tempid,1]);
            };
            tempid = msg.body.readInt();
            ba = new BattleAlert(this,"<font color=\'#993300\' size=\'24\'>等待对方回应！</font>",true,false,false);
            ba.addEventListener(BattleAlert.battleAlertNo,onBattleAlertNo);
         }
      }
      
      private function onClickVsBtn(event:MouseEvent) : void
      {
         var tempname:String;
         var obj:Object;
         var linkClickHandler:Function = null;
         var onCloseAlert:Function = null;
         linkClickHandler = function(... rest):void
         {
            if(rest.length > 1)
            {
               dispatch(EventConst.OPENPERSONINFOVIEW,rest[1]);
            }
         };
         onCloseAlert = function(... rest):void
         {
            if(rest[0] == "接受")
            {
               sendMessage(MsgDoc.OP_CLIENT_BATTLE_WITH.send,2,[otherid,pktype]);
            }
            if(rest[0] == "拒绝")
            {
               sendMessage(MsgDoc.OP_CLIENT_BATTLE_WITH.send,1,[otherid,pktype]);
            }
         };
         if(GameData.instance.playerData.giantId == GameData.instance.playerData.userId || GameData.instance.playerData.isNewHand == 7)
         {
            return;
         }
         this.view.topClip.hideVSClip();
         tempname = Boolean(this.pkname) && this.pkname.length > 2 ? this.pkname : this.otherid.toString();
         obj = {
            "userId":this.otherid,
            "isOnline":1,
            "source":1,
            "userName":this.pkname,
            "sex":this.roletype & 1
         };
         new Alert().showAcceptOrRefuse("<a href=\'event:" + tempname + "\'>" + tempname + "</a>" + "邀请你战斗\n<font color=\'#ff0000\'>对战模式:" + (this.pktype == 1 ? "多妖怪" : "单妖怪") + "</font>",onCloseAlert,obj,linkClickHandler);
      }
      
      private function onFaceClick(evt:InterfaceEvent) : void
      {
         if(GameData.instance.playerData.giantId == GameData.instance.playerData.userId || GameData.instance.playerData.isNewHand == 7)
         {
            return;
         }
         MouseManager.getInstance().setCursor("");
         var code:String = evt.params.code;
         if(code == "areamapbtn")
         {
            code = "bigMapBtn";
         }
         if(evt.params.hasOwnProperty("jump"))
         {
            if(this.isNewPlayer())
            {
               return;
            }
            this.hideRedPoint(evt.params);
            this.openModule(evt.params.jump);
         }
         else if(Boolean(evt.params.hasOwnProperty("targetScene")) && evt.params["targetScene"] > 0)
         {
            dispatch(EventConst.ENTERSCENE,evt.params["targetScene"]);
         }
         else if(this.hasOwnProperty("onClick" + code))
         {
            this["onClick" + code](evt);
         }
         else
         {
            trace("找不到该方法:",code);
         }
      }
      
      private function hideRedPoint(data:Object) : void
      {
         if(!data)
         {
            return;
         }
         var code:String = data["code"];
         if(Boolean(code))
         {
            FaceView.clip.topClip.showRedPointByName("PassBtn");
         }
      }
      
      public function openModule($url:String, $x:int = 0, $y:int = 0) : void
      {
         dispatch(EventConst.BOBSTATECLICK,{
            "url":$url,
            "xCoord":$x,
            "yCoord":$y
         });
      }
      
      public function onClickachieveBtn(evt:InterfaceEvent) : void
      {
         ApplicationFacade.getInstance().dispatch(EventConst.OPEN_CACHE_VIEW,{
            "showX":0,
            "showY":0
         },null,"com.game.modules.view.achieve.AchieveView");
         ButtonEffectUtil.delEffect(this.view.getTopButton("achieveBtn"));
      }
      
      public function onClickbigMapBtn(evt:InterfaceEvent) : void
      {
         var name:String = evt.params.code;
         if(GameData.instance.playerData.isNewHand < 8)
         {
            SpecialAreaManager.instance.removeNewHandMask();
         }
         if(GameData.instance.playerData.refineState)
         {
            new Alert().showSureOrCancel("确定停止炼制？",this.onRefineAlerClose);
            return;
         }
         sendMessage(MsgDoc.OP_CLIENT_GETMAGICINDEX.send);
         if(name == "areamapbtn" && GameData.instance.playerData.araamapId != 0)
         {
            GlobalAPI.openCountryMap(GameData.instance.playerData.araamapId);
         }
         else
         {
            this.openModule("assets/map/BigMapView.swf");
         }
      }
      
      public function onClickmagicBtn(evt:InterfaceEvent) : void
      {
         if(getTimer() - this.magicStopTime < 1000)
         {
            return;
         }
         this.magicStopTime = getTimer();
         GameDynamicUI.removeUI("jiantou");
         if(GameData.instance.playerData.currentScenenId == 2003 && TaskView.instance.currentDialogID == 200100504)
         {
            this.dispatch(EventConst.ADDDYNAMICUIONMAINUI,{
               "type":1,
               "container":21108,
               "x":280,
               "y":-140,
               "uiname":"jiantou"
            });
         }
         dispatch(EventConst.OPEN_CACHE_VIEW,{
            "showX":170,
            "showY":385
         },null,getQualifiedClassName(MagicView));
      }
      
      public function onClicksendBtn(evt:InterfaceEvent) : void
      {
         if(ChractorFilter.allSpace(evt.params.msg))
         {
            new Alert().showOne("请输入聊天内容！");
            return;
         }
         var tempClickTime:Number = getTimer();
         if(tempClickTime - this.lastClickTime < 1500)
         {
            this.lastClickTime = tempClickTime;
            return;
         }
         this.lastClickTime = tempClickTime;
         var msg:String = evt.params.msg;
         if(ChatUtil.isOpenChat())
         {
            msg = StringUtil.trim(msg);
            ChatUtil.onCompanyCheck(msg,this.onCompanyCheckHandler);
         }
      }
      
      public function onClickquickBtn(evt:InterfaceEvent) : void
      {
         this.dispatch(EventConst.SENDQUICKMSG);
      }
      
      public function onClickhouseBtn(evt:InterfaceEvent) : void
      {
         if(this.view.bottomClip.homebtn.visible == false)
         {
            this.view.bottomClip.showHouse();
            sendMessage(MsgDoc.OP_CLIENT_ACTIVITY_QINGYANG.send,52,[7]);
            if(GameData.instance.shenshoufriends.length == 0)
            {
               sendMessage(MsgDoc.OP_CLIENT_SHENSHOU_FRIENDS.send,0,[1]);
            }
         }
         else
         {
            this.view.bottomClip.hideHouse();
         }
      }
      
      public function onClickpackBtn(evt:InterfaceEvent) : void
      {
         if(GameData.instance.playerData.isNewHand <= 4)
         {
            SpecialAreaManager.instance.removeNewHandMask();
         }
         if(GameData.instance.playerData.isNewHand < 8 && GameData.instance.playerData.isNewHand != 3)
         {
            return;
         }
         dispatch(EventConst.OPEN_CACHE_VIEW,{
            "showX":0,
            "showY":0
         },null,getQualifiedClassName(PackView));
      }
      
      public function onClickpetBtn(evt:InterfaceEvent) : void
      {
         new Message("onopenmonsterpanel").sendToChannel("itemclick");
      }
      
      public function onClickfriendClikBtn(evt:InterfaceEvent) : void
      {
         if(this.isNewPlayer())
         {
            return;
         }
         this.view.bottomClip.stopMsgTip();
         this.view.bottomClip.hideFriend();
         if(!GameData.instance.playerData.isFriendViewOpen)
         {
            this.openModule("assets/friend/FriendsView.swf",560,80);
         }
      }
      
      public function onClickfamilyBtn(evt:InterfaceEvent) : void
      {
         if(this.isNewPlayer())
         {
            return;
         }
         if(GameData.instance.playerData.family_id > 0)
         {
            this.view.bottomClip.chatClip.visible = this.view.bottomClip.chatClip.visible == true ? false : true;
            if(GameData.instance.playerData.family_msg_forbid)
            {
               this.view.bottomClip.chatClip.gotoAndStop(2);
            }
            else
            {
               this.view.bottomClip.chatClip.gotoAndStop(1);
            }
         }
         else
         {
            this.view.bottomClip.chatClip.visible = false;
         }
         this.view.bottomClip.fTip2.visible = false;
         if(GameData.instance.playerData.isHaveFmsg())
         {
            this.view.bottomClip.showFamilyMsg();
         }
         else
         {
            this.view.bottomClip.hideFamilyMsg();
         }
         if(GameData.instance.playerData.family_id > 0)
         {
            this.view.bottomClip.hideJoinFamily();
            if(this.view.bottomClip.familyBtn2.visible)
            {
               this.view.bottomClip.hideFamilyBase();
            }
            else
            {
               this.view.bottomClip.showFamilyBase();
            }
         }
         else
         {
            this.view.bottomClip.hideFamilyBase();
            if(this.view.bottomClip.familyBtn1.visible)
            {
               this.view.bottomClip.hideJoinFamily();
            }
            else
            {
               this.view.bottomClip.showJoinFamily();
            }
         }
         if(!this.view.bottomClip.familyBtn1.visible && !this.view.bottomClip.familyBtn2.visible)
         {
            this.view.bottomClip.hideFamilyMsg();
         }
      }
      
      public function onClickfamilyBtn1(evt:InterfaceEvent) : void
      {
         this.view.bottomClip.chatClip.visible = false;
         if(this.isNewPlayer())
         {
            return;
         }
         this.view.bottomClip.hideFamilyMsg();
         if(GameData.instance.playerData.family_id <= 0)
         {
            this.view.bottomClip.hideJoinFamily();
            dispatch(EventConst.OPEN_CACHE_VIEW,{
               "showX":0,
               "showY":0
            },null,getQualifiedClassName(FamilyJoinIn));
         }
         else
         {
            new FloatAlert().show(this.view,350,400,"你已经是加入了家族！",5,300);
         }
      }
      
      public function onClickbtnCreateFamily(evt:InterfaceEvent) : void
      {
         this.view.bottomClip.chatClip.visible = false;
         if(this.isNewPlayer())
         {
            return;
         }
         this.view.bottomClip.hideFamilyMsg();
         if(GameData.instance.playerData.family_id <= 0)
         {
            this.view.bottomClip.hideJoinFamily();
            dispatch(EventConst.OPENSWFWINDOWS,{
               "url":"assets/family/familyCreate.swf",
               "xCoord":150,
               "yCoord":30
            });
         }
         else
         {
            new FloatAlert().show(this.view,350,400,"你已经是加入了家族！",5,300);
         }
      }
      
      public function onClickfamilyBtn2(evt:InterfaceEvent) : void
      {
         var onLeaveBobToFamily:Function;
         if(Boolean(GameData.instance.playerData.bobOwner))
         {
            onLeaveBobToFamily = function(... rest):void
            {
               if(rest[0] == "确定")
               {
                  dispatch(EventConst.LEAVEBOB_DIRECTION);
                  onEnterFamilyBase();
               }
            };
            new Alert().showSureOrCancel("是否离开擂台？",onLeaveBobToFamily);
         }
         else
         {
            this.onEnterFamilyBase();
         }
      }
      
      public function onClickfamilyBtn3(evt:InterfaceEvent) : void
      {
         this.view.bottomClip.chatClip.visible = false;
         this.view.bottomClip.hideFamilyMsg();
         this.view.bottomClip.hideJoinFamily();
         this.view.bottomClip.hideFamilyBase();
         if(GameData.instance.playerData.familyMsgCache.length > 0 && !GameData.instance.playerData.familyisOpen)
         {
            dispatch(EventConst.OPEN_CACHE_VIEW,{
               "showX":10,
               "showY":-10
            },null,getQualifiedClassName(MutilChatView));
         }
         else
         {
            dispatch(EventConst.CHATWITHFRIEND,GameData.instance.playerData.getLatestFmsg());
         }
      }
      
      public function onClickchatClip(evt:InterfaceEvent) : void
      {
         this.view.bottomClip.hideFamilyMsg();
         this.view.bottomClip.hideJoinFamily();
         this.view.bottomClip.hideFamilyBase();
         this.view.bottomClip.chatClip.visible = false;
         dispatch(EventConst.OPEN_CACHE_VIEW,{
            "showX":10,
            "showY":-10
         },null,getQualifiedClassName(MutilChatView));
      }
      
      public function onClickemailClip(evt:InterfaceEvent) : void
      {
         dispatch(EventConst.BOBSTATECLICK,{
            "url":"assets/email/EmailView.swf",
            "mouseright":true
         });
      }
      
      public function onClickdailyTaskClip(evt:InterfaceEvent) : void
      {
         if(this.isNewPlayer())
         {
            return;
         }
         this.openModule("assets/module/DailyTaskModule2.swf");
      }
      
      public function onClickweekBtn(evt:InterfaceEvent) : void
      {
         if(this.isNewPlayer())
         {
            return;
         }
         if(GameData.instance.playerData.benevolentEveryDay == 0)
         {
            this.dispatch(EventConst.GETSINGLETASKINFO,{
               "callback":null,
               "taskId":6005001
            });
            GameData.instance.playerData.toGetBenevolent = true;
         }
         this.openModule("assets/activity/201412/Activity20141225YearPetMaster/Active20141225YearPetMaster.swf");
      }
      
      public function onClicktaskBtn(evt:InterfaceEvent) : void
      {
         if(GameData.instance.playerData.isNewHand < 8)
         {
            SpecialAreaManager.instance.removeNewHandMask();
         }
         if(!GameData.instance.tasklistInited)
         {
            new FloatAlert().show(this.view.stage,380,400,"Aha!~获取任务信息失败,再尝试一下",5,200);
            this.sendMessage(MsgDoc.OP_CLIENT_REQ_USERTASKLIST.send);
         }
         else
         {
            this.openModule("assets/module/TaskArchivesVersion3.swf");
         }
      }
      
      public function onClickvoiceClip(evt:InterfaceEvent) : void
      {
         if(SceneSoundManager.getInstance().globalSound == 0)
         {
            SceneSoundManager.getInstance().openSound();
         }
         else
         {
            SceneSoundManager.getInstance().closeSound();
         }
      }
      
      public function onClickfamilyBattleBtn(evt:InterfaceEvent) : void
      {
         var body:Object = GameData.instance.playerData.getFamilyWarInvite();
         this.view.topClip.hideFamilyBattleBtn();
         if(body != null)
         {
            if(body.hasOwnProperty("teamId"))
            {
               new Alert().showSureOrCancel("【苍炼岛战场】家族战场正在召唤你，赶快加入战斗吧！",this.isAcceptWarcraft,body);
            }
         }
      }
      
      public function onClickclearClip(evt:InterfaceEvent) : void
      {
         if(GameData.instance.playerData.sceneId == 1028)
         {
            new Alert().showOne("这里不可以屏蔽人(⊙o⊙)哦");
            return;
         }
         DelayShowUtil.instance.playerControl = !DelayShowUtil.instance.playerControl;
         if(GameData.instance.playerData.currentScenenId == 1004 && GameData.instance.playerData.active_status == 1)
         {
            GameDynamicUI.removeUI("texiao2");
            this.dispatch(EventConst.MASTERISOUTSPECIALAREA,{
               "npcid":12001,
               "dialogID":600600201
            });
            GameData.instance.playerData.active_status = 0;
         }
         if(MaterialCache.instance.hasOwnProperty("realseCache"))
         {
            MaterialCache.instance["realseCache"]();
         }
      }
      
      public function onClicksettingBtn(evt:InterfaceEvent) : void
      {
         FaceView.clip.bottomClip.systemClip.visible = false;
         dispatch(EventConst.OPEN_CACHE_VIEW,{
            "showX":210,
            "showY":57
         },null,getQualifiedClassName(SystemSetting));
      }
      
      public function onClickbbsBtn(evt:InterfaceEvent) : void
      {
         FaceView.clip.bottomClip.systemClip.visible = false;
         navigateToURL(new URLRequest("http://my.4399.com/space-mtag-tagid-79936.html"),"_blank");
      }
      
      public function onClickhelpBtn(evt:InterfaceEvent) : void
      {
         FaceView.clip.bottomClip.systemClip.visible = false;
         this.openModule("assets/login/helpbook.swf",130);
      }
      
      public function onClickbugBtn(evt:InterfaceEvent) : void
      {
         FaceView.clip.bottomClip.systemClip.visible = false;
         var n:int = GameData.instance.playerData.isNewHand;
         if(n == 1 || n == 2 || n == 3)
         {
            new Alert().showOne("亲爱的小卡布,不要这么着急哦！乖乖做完新手指引先吧(*^__^*)");
         }
         else
         {
            dispatch(EventConst.OPEN_CACHE_VIEW,{
               "showX":200,
               "showY":50
            },null,getQualifiedClassName(ProposalView));
         }
      }
      
      public function onClickactionBtn(evt:InterfaceEvent) : void
      {
         if(GameData.instance.playerData.isDance)
         {
            new FloatAlert().show(this.view.stage,320,350,"在垫子上时是不能使用其他动作的哦！");
         }
         else
         {
            dispatch(EventConst.OPEN_CACHE_VIEW,{
               "showX":174,
               "showY":422
            },null,getQualifiedClassName(ActionView));
         }
      }
      
      public function onClickawardClip(evt:InterfaceEvent) : void
      {
         this.view.onRollOutHandler(null);
         this.openModule("assets/system/kabuOnlineAward/KabuOnlineAwardModule.swf");
      }
      
      public function onClicksevenTreasureBtn(evt:InterfaceEvent) : void
      {
         this.view.onRollOutHandler(null);
         this.openModule("assets/system/sevenTreasure/SevenTreasure.swf");
      }
      
      public function onClickdailyCompass(evt:InterfaceEvent) : void
      {
         ButtonEffectUtil.delEffect(this.view.getTopButton("dailyCompass"));
         if(GameData.instance.playerData.isNewHand != 9)
         {
            return;
         }
         GameData.instance.playerData.toGetBenevolent = false;
         this.openModule("assets/module/DailyCompass2_0.swf");
      }
      
      private function isNewPlayer() : Boolean
      {
         if(GameData.instance.playerData.isNewHand < 9)
         {
            new Alert().show("你还没有做完新手指引哦！~");
            return true;
         }
         return false;
      }
      
      public function onClickhomebtn(evt:InterfaceEvent) : void
      {
         this.view.bottomClip.hideHouse();
         if(this.isNewPlayer())
         {
            return;
         }
         if(Boolean(GameData.instance.playerData.bobOwner))
         {
            new Alert().showSureOrCancel("是否离开擂台？",this.onCloseBobHandler);
            return;
         }
         if(GameData.instance.playerData.refineState)
         {
            new Alert().showSureOrCancel("确定停止炼制？",this.onRefineAlerClose);
            return;
         }
         GameData.instance.playerData.isInCrazyRecordRoom = false;
         this.dispatch(EventConst.MAKE_CRAZY_RECORD_SCENE_LIST,false);
         this.reqEnterHome();
      }
      
      public function onClickshenshoubtn(evt:InterfaceEvent) : void
      {
         this.view.bottomClip.hideHouse();
         this.dispatch(EventConst.ENTERSHENSHOU);
      }
      
      public function onClickheavenFuruiBtn(evt:InterfaceEvent) : void
      {
         if(this.isNewPlayer())
         {
            return;
         }
         this.openModule("assets/system/HeavenFurui/HeavenFurui.swf");
      }
      
      public function onClickbadgeBtn(evt:InterfaceEvent) : void
      {
         GameData.instance.playerData.selfStageRecord = GameData.instance.playerData.userId;
         this.openModule("assets/badge/BadgeView.swf");
      }
      
      public function onClickshopBtn(evt:InterfaceEvent) : void
      {
         if(this.isNewPlayer())
         {
            return;
         }
         this.openModule("assets/mall/MallUI.swf");
      }
      
      public function onClicknewMsgClip(evt:InterfaceEvent) : void
      {
         this.openModule("assets/module/NewsModule.swf");
      }
      
      public function onClickvipweekBtn(evt:InterfaceEvent) : void
      {
         if(this.isNewPlayer())
         {
            return;
         }
         if(GameData.instance.playerData.benevolentEveryDay == 0)
         {
            this.dispatch(EventConst.GETSINGLETASKINFO,{
               "callback":null,
               "taskId":6005001
            });
            GameData.instance.playerData.toGetBenevolent = true;
         }
         this.openModule("assets/vip/VIPShiBao.swf");
      }
      
      public function onClickteamBtn(evt:InterfaceEvent) : void
      {
         if(this.isNewPlayer())
         {
            return;
         }
         if(TeamNotScene.hitScene(GameData.instance.playerData.sceneId))
         {
            new FloatAlert().show(WindowLayer.instance,350,250,"所处场景不能打开队伍列表！");
         }
         else if(!ApplicationFacade.getInstance().hasViewLogic("teamface_control"))
         {
            this.dispatch(EventConst.BOBSTATECLICK,{
               "url":"assets/module/TeamFaceView.swf",
               "xCoord":0,
               "yCoord":0,
               "params":{"type":1}
            });
         }
         this.view.bottomClip.hideFriend();
      }
      
      public function onClickfriendClick(evt:InterfaceEvent) : void
      {
         if(this.view.bottomClip.fTip.visible)
         {
            this.view.bottomClip.stopMsgTip();
            if(!GameData.instance.playerData.isFriendViewOpen)
            {
               this.openModule("assets/friend/FriendsView.swf",600,120);
            }
         }
         else if(this.view.bottomClip.friendClikBtn.visible == true)
         {
            this.view.bottomClip.hideFriend();
         }
         else
         {
            this.view.bottomClip.hideFriendApplyTips();
            this.view.bottomClip.showFriend();
         }
      }
      
      public function onClickfaceBtn(evt:InterfaceEvent) : void
      {
         this.view.smile.visible = this.view.smile.visible == true ? false : true;
      }
      
      public function onClickautobattleBtn(evt:InterfaceEvent) : void
      {
         this.openModule("assets/module/AutoBattleProject.swf");
      }
      
      public function onClickhandbookBtn(evt:InterfaceEvent) : void
      {
         if(this.isNewPlayer())
         {
            return;
         }
         this.openModule("assets/handbook/view/HandbookView.swf");
      }
      
      public function onClickkabuguideBtn(evt:InterfaceEvent) : void
      {
         this.openModule("assets/module/KabuGuideModule.swf");
      }
      
      public function onClickweeklyActivityMc(evt:InterfaceEvent) : void
      {
         ButtonEffectUtil.delEffect(this.view.getTopButton("weeklyActivityMc"));
         if(GameData.instance.playerData.newvalue[18] == 0)
         {
            GameData.instance.playerData.newvalue[18] = 1;
            sendMessage(MsgDoc.OP_GATEWAY_FIRSTTIME.send,18);
         }
         if(this.isNewPlayer())
         {
            return;
         }
         ShareLocalUtil.instance.setWeeklyActivityFlag();
         this.openModule("assets/weekly/WeeklyActivities.swf");
      }
      
      public function onClickpresureBtn(evt:InterfaceEvent) : void
      {
         ButtonEffectUtil.delEffect(this.view.getTopButton("presureBtn"));
         sendMessage(MsgDoc.OP_CLIENT_ACTIVITY_QINGYANG.send,224,[3,1]);
         this.openModule("assets/module/LookForPresures.swf");
      }
      
      public function onClickpreviewBtn(evt:InterfaceEvent) : void
      {
         this.openModule("assets/activity/zkz25/ActPreview/ActPreviewEntrance.swf");
      }
      
      public function onClickbtnPer(evt:InterfaceEvent) : void
      {
         ApplicationFacade.getInstance().dispatch(EventConst.BOBSTATECLICK,{"url":"assets/activity/202508/Act692/Act692Entrance.swf"});
      }
      
      public function onClickfamilyFilesBtn(evt:InterfaceEvent) : void
      {
         dispatch(EventConst.BOBSTATECLICK,{
            "url":"assets/module/FamilyFilesProject.swf",
            "moduleParams":{"flag":1}
         });
         this.view.bottomClip.hideFamilyMsg();
         this.view.bottomClip.hideJoinFamily();
         this.view.bottomClip.hideFamilyBase();
         this.view.bottomClip.chatClip.visible = false;
      }
      
      public function onClickfincaBtn(evt:InterfaceEvent) : void
      {
         this.view.bottomClip.hideHouse();
         GameData.instance.playerData.enterFarmFlag = true;
         dispatch(EventConst.ENTERSHENSHOU);
      }
      
      public function onClickregressBtn(evt:InterfaceEvent) : void
      {
         if(this.isNewPlayer())
         {
            return;
         }
         this.openModule("assets/system/regression/Active20140127Regression.swf");
      }
      
      public function onClicktipsMc(evt:InterfaceEvent) : void
      {
         if(this.isNewPlayer())
         {
            return;
         }
         this.openModule("assets/friend/FriendApplyManager.swf");
      }
      
      public function onClickmentorBtn(evt:InterfaceEvent) : void
      {
         this.openModule("assets/maa/MasterAndApprentice.swf");
         this.view.bottomClip.hideFriend();
      }
      
      public function onClicknewsclip(evt:InterfaceEvent) : void
      {
         sendMessage(MsgDoc.OP_CLIENT_ACTIVITY_QINGYANG.send,10000,[0]);
         this.openModule("assets/module/OnlineBox.swf");
      }
      
      public function onClicksystemBtn(evt:InterfaceEvent) : void
      {
         FaceView.clip.bottomClip.systemClip.visible = FaceView.clip.bottomClip.systemClip.visible == true ? false : true;
      }
      
      private function onClasiumActiviytSureHandler(str:String, data:Object = null) : void
      {
         if(str == "确定")
         {
            dispatch(EventConst.SENDUSERTOOTHERSCENE,10002);
         }
      }
      
      public function onClickfreshManAwardBtn(evt:InterfaceEvent) : void
      {
         this.openModule("assets/system/newHand/gift/NewPlayerSignAward.swf");
      }
      
      public function onClickbraveBtn(evt:InterfaceEvent) : void
      {
         this.openModule("assets/system/newHand/brave/NewHandBraveRoad.swf");
      }
      
      public function onClickperishEvil(evt:InterfaceEvent) : void
      {
         this.openModule("assets/dailyactive/perishevil/perishEvilModuleUI.swf");
      }
      
      public function onClicktowerBtn(evt:InterfaceEvent) : void
      {
         this.openModule("assets/dailyactive/findtowertreasure/FindTowerTreasureUI.swf");
      }
      
      public function onClickphonePlayBtn(evt:InterfaceEvent) : void
      {
         this.openModule("assets/activity/202408/PhonePlay/PhonePlayEntrance.swf");
      }
      
      private function addFriendCloseHandler(type:String, data:Object) : void
      {
         if(type == "接受")
         {
            dispatch(EventConst.ACCEPT_OR_REFUSE_FRIENDASK,{
               "type":1,
               "id":data.uid,
               "name":data.cName,
               "roleType":data.type
            });
         }
         else
         {
            dispatch(EventConst.ACCEPT_OR_REFUSE_FRIENDASK,{
               "type":0,
               "id":data.uid,
               "name":data.cName
            });
         }
      }
      
      private function addFriendLinkHandler(... rest) : void
      {
         var obj:Object = {
            "userId":rest[1].uid,
            "isOnline":1,
            "source":0,
            "userName":rest[1].cName,
            "sex":1
         };
         dispatch(EventConst.OPENPERSONINFOVIEW,obj);
      }
      
      private function onSuerLeaveTeam(... rest) : void
      {
         if("确定" == rest[0])
         {
            dispatch(EventConst.TEAM_KILL_PLAYER);
            dispatch(EventConst.TEAM_CLOSE_MESSAGE_VIEW);
            GameData.instance.playerData.myTeamData.disport();
            GameData.instance.playerData.myTeamData = null;
            this.onFaceClick(rest[1]);
         }
      }
      
      private function isAcceptWarcraft(type:String, data:Object) : void
      {
         if(type == "确定")
         {
            if(GamePersonControl.instance.isInNoWarScene())
            {
               GameData.instance.playerData.isAcceptWarcraftInvite = true;
               GameData.instance.playerData.familyWarcraftWarId = data.id;
               GameData.instance.playerData.teamId = data.teamId;
               dispatch(EventConst.CLEARUI);
               dispatch(EventConst.OPEN_MODULE,{
                  "url":"assets/module/WarCraftProject.swf",
                  "xCoord":0,
                  "yCoord":0
               });
               this.view.topClip.hideFamilyBattleBtn();
            }
            else
            {
               new FloatAlert().show(this.view.stage,320,350,"不能在这里进入战场(⊙o⊙)哦");
               sendMessage(MsgDoc.OP_CLIENT_REFUSE_WARCRAFT_INVITE.send);
            }
         }
         else
         {
            sendMessage(MsgDoc.OP_CLIENT_REFUSE_WARCRAFT_INVITE.send);
         }
      }
      
      private function onRefineAlerClose(... rest) : void
      {
         if("确定" == rest[0])
         {
            GameData.instance.playerData.refineState = false;
            ApplicationFacade.getInstance().dispatch(EventConst.STOPREFINE);
         }
      }
      
      private function closeHandler2(... rest) : void
      {
         GameData.instance.playerData.currentScenenId = 1008;
         dispatch(EventConst.ENTERSCENE,1008);
         dispatch(EventConst.CLEARUI);
      }
      
      private function onCloseBobHandler(... rest) : void
      {
         if("确定" == rest[0])
         {
            this.reqEnterHome();
         }
      }
      
      private function reqEnterHome() : void
      {
         if(Boolean(MapView.instance.stage))
         {
            GameDynamicUI.addUI(MapView.instance.stage,200,200,"loading");
         }
         dispatch(EventConst.REQ_ENTER_ROOM,{
            "userId":GlobalConfig.userId,
            "userName":GameData.instance.playerData.userName,
            "houseId":GlobalConfig.userId
         });
      }
      
      private function sendFace(evt:ItemClickEvent) : void
      {
         sendMessage(MsgDoc.OP_CLIENT_CHAT.send,0,[1,1,evt.params + ""]);
      }
      
      private function onChatWithFriend(evt:MessageEvent) : void
      {
         this.type = 2;
         this.cid = evt.body.userId;
         this.view.bottomClip.stopMsgTip();
         this.view.bottomClip.hideFriend();
      }
      
      private function onNewEmailCome(evt:MessageEvent) : void
      {
         this.view.showNewEmail(CacheData.instance.showNewEmailNum);
      }
      
      private function onMakeFriendBack(event:MessageEvent) : void
      {
         var code:int = int(event.body.code);
         if(code > 0)
         {
            new FriendAlert().showAddFriendOk(event.body.username + CommonDefine.ACCEPT_ASK_FRIEND,this.view.stage);
         }
         if(code == 0)
         {
            new FriendAlert().showRefuseAddFriend(event.body.username + CommonDefine.REFUSE_ASK_FRIEND,this.view.stage);
         }
         if(code == -1)
         {
            new FriendAlert().showRefuseAddFriend(event.body.username + CommonDefine.USER_NOT_IN_THIS_SCENE,this.view.stage);
         }
      }
      
      private function onClickRightUpClipOne(evt:MouseEvent) : void
      {
         if(evt != null && evt.target["mouseEnabled"] == false)
         {
            return;
         }
         this.dispatch(EventConst.ONCLICKRUCLIPONE,this.rightUpClipOneId);
      }
      
      private function onSendMsgBack(evt:MessageEvent) : void
      {
         var params:Object = evt.body;
         params.shakeFlag = 1;
         params.isOnline = 1;
         var cache:Array = [];
         if(GameData.instance.playerData.msgCache[params.from_id] == null)
         {
            GameData.instance.playerData.msgCache[params.from_id] = cache;
         }
         else
         {
            cache = GameData.instance.playerData.msgCache[params.from_id];
         }
         if(GameData.instance.playerData.isOpening[params.from_id] != null)
         {
            if(GameData.instance.playerData.isOpening[params.from_id] == false)
            {
               cache.push(params);
               if(GameData.instance.playerData.isFriendViewOpen == false)
               {
                  if(GameData.instance.playerData.isInWarCraft)
                  {
                     dispatch(EventConst.SHOW_FRIENDMSG_IN_WARCRAFT);
                  }
               }
               this.view.bottomClip.addChatFriend(params);
               if(this.view.bottomClip.hasChatDress(params.from_id))
               {
                  this.view.bottomClip.addChatFriendDress(null);
               }
               else
               {
                  sendMessage(MsgDoc.OP_CLIENT_GET_CHAT_DRESS.send,int(params.from_id));
               }
            }
         }
         else
         {
            GameData.instance.playerData.isOpening[params.from_id] = false;
            cache.push(params);
            if(GameData.instance.playerData.isFriendViewOpen == false)
            {
               if(GameData.instance.playerData.isInWarCraft)
               {
                  dispatch(EventConst.SHOW_FRIENDMSG_IN_WARCRAFT);
               }
            }
            this.view.bottomClip.addChatFriend(params);
            if(this.view.bottomClip.hasChatDress(params.from_id))
            {
               this.view.bottomClip.addChatFriendDress(null);
            }
            else
            {
               sendMessage(MsgDoc.OP_CLIENT_GET_CHAT_DRESS.send,int(params.from_id));
            }
         }
      }
      
      private function getChatDressBack(evt:MessageEvent) : void
      {
         this.view.bottomClip.addChatFriendDress(evt.body);
      }
      
      private function onFamilyMsgBack(evt:MessageEvent) : void
      {
         var params:Object = evt.body;
         var cache:Array = [];
         if(GameData.instance.playerData.fmsgCache[params.from_id] == null)
         {
            GameData.instance.playerData.fmsgCache[params.from_id] = cache;
         }
         else
         {
            cache = GameData.instance.playerData.fmsgCache[params.from_id];
         }
         if(GameData.instance.playerData.fisOpening[params.from_id] != null)
         {
            if(GameData.instance.playerData.fisOpening[params.from_id] == false)
            {
               cache.push(params);
               this.view.bottomClip.fTip2.visible = true;
            }
         }
         else
         {
            GameData.instance.playerData.fisOpening[params.from_id] = false;
            cache.push(params);
            this.view.bottomClip.fTip2.visible = true;
         }
      }
      
      private function faceUIOperate(evt:MessageEvent) : void
      {
         var params:Object = evt.body;
         switch(params.code)
         {
            case 3:
               this.view.bottomClip.enableMask();
               this.view.topMiddleClip.enableMask();
               break;
            case 4:
               this.view.bottomClip.disableMask();
               this.view.topMiddleClip.disableMask();
               break;
            case 5:
               this.view.bottomClip.enableUIByName(params.name);
               break;
            case 6:
               this.view.bottomClip.disableUIByName(params.name);
               break;
            case 9:
               this.view.topClip.disableUIByName(params.name);
               break;
            case 10:
               this.view.topClip.enableUIByName(params.name);
               break;
            case 11:
               this.view.controlNewHand(params.newhand);
               this.onVeryDayShowEffect();
               break;
            case 12:
               this.view.topMiddleClip.visible = true;
               break;
            case 13:
               this.view.topMiddleClip.visible = false;
               break;
            case 14:
               this.view.topMiddleClip.clearClipEnabled(true);
               break;
            case 15:
               this.view.topMiddleClip.clearClipEnabled(false);
         }
      }
      
      private function changeSceneName(evt:MessageEvent) : void
      {
         this.view.topMiddleClip.placeTxt.text = evt.body.name;
      }
      
      private function playerStateChange(evt:MessageEvent) : void
      {
         var date:Date = null;
         if(CacheData.instance.closeTime == 0)
         {
            date = new Date(GameData.instance.playerData.systemTimes * 1000);
            if(date.day == 4)
            {
               date.hours = 22;
            }
            else
            {
               date.hours = 23;
            }
            date.minutes = 0;
            date.seconds = 0;
            CacheData.instance.closeTime = date.getTime() / 1000;
         }
         var lefttime:Number = CacheData.instance.closeTime - GameData.instance.playerData.systemTimes;
         if(lefttime >= 300 && lefttime < 600 && CacheData.instance._beSetTimeout == false)
         {
            CacheData.instance._beSetTimeout = true;
            if(lefttime < 305)
            {
               setTimeout(this.showDeadLineAlert,7000);
            }
            else
            {
               setTimeout(this.showDeadLineAlert,(lefttime - 300) * 1000);
            }
         }
         if(GameData.instance.playerData.playerStatus == 7)
         {
            return;
         }
         this.view.bottomClip.showTime(GameData.instance.playerData.playerSurplus);
         this.view.checkIsInActiveTime();
      }
      
      private function showDeadLineAlert() : void
      {
         dispatch(EventConst.OPEN_MODULE,{
            "url":"assets/system/deadlineAlert/DeadLineAlert.swf",
            "xCoord":0,
            "yCoord":0
         });
      }
      
      private function timeUp(evt:Event) : void
      {
         GameData.instance.playerData.playerStatus = 2;
      }
      
      private function onWarcraftInvite(evt:MessageEvent) : void
      {
         if(evt.body.hasOwnProperty("teamId"))
         {
            GameData.instance.playerData.warInviteList.push(evt.body);
            this.view.topClip.showFamilyBattleBtn();
            return;
         }
      }
      
      private function onAddFriendMsg(evt:MessageEvent) : void
      {
         var obj:Object = null;
         for each(obj in GameData.instance.playerData.addFriendMsgList)
         {
            if(obj.uid == evt.body.uid)
            {
               return;
            }
         }
         GameData.instance.playerData.addFriendMsgList.push(evt.body);
         this.view.bottomClip.setFriendClickType(2);
      }
      
      private function onEnterShenshou(event:MessageEvent) : void
      {
         if(GameData.instance.playerData.isInCrazyRecordRoom)
         {
            new Alert().show("现在不能进神兽园哦！~");
            return;
         }
         if(event.body == null)
         {
            GameData.instance.playerData.shenshouyuan_id = GameData.instance.playerData.userId;
            GameData.instance.playerData.shenshouyuan_name = GameData.instance.playerData.userName;
         }
         else
         {
            GameData.instance.playerData.shenshouyuan_id = event.body.uid;
            GameData.instance.playerData.shenshouyuan_name = event.body.uname;
         }
         sendMessage(MsgDoc.OP_CLIENT_CAN_ENTER_SHENSHOU.send,GameData.instance.playerData.shenshouyuan_id);
      }
      
      private function onEnterFamilyBase(evt:MessageEvent = null) : void
      {
         this.view.bottomClip.chatClip.visible = false;
         this.view.bottomClip.hideFamilyMsg();
         if(GameData.instance.playerData.family_id > 0)
         {
            this.view.bottomClip.hideFamilyBase();
            dispatch(EventConst.ENTER_FAMILY_BASE,GameData.instance.playerData.family_id);
         }
         else
         {
            new FloatAlert().show(MapView.instance.stage,350,400,"你还没有加入家族哦！",5,300);
         }
      }
      
      private function onChatBack(evt:MessageEvent) : void
      {
         var params:Object = evt.body;
         if(!GameData.instance.playerData.familyisOpen)
         {
            GameData.instance.playerData.familyMsgCache.push(evt.body);
            if(!GameData.instance.playerData.family_msg_forbid)
            {
               this.view.bottomClip.fTip2.visible = true;
            }
         }
      }
      
      private function onTeamOpenMessage(evt:MessageEvent) : void
      {
         FaceView.addTeamMessageView();
      }
      
      private function onTeamCloseMessage(evt:MessageEvent) : void
      {
         FaceView.remoeTeamMessageView();
      }
      
      private function onShowPersonPaperhorse(evt:MessageEvent) : void
      {
         FaceView.addPaperHorse();
      }
      
      private function onEffectShowHandler(e:MessageEvent) : void
      {
         this.view.setEffectList(GameData.instance.playerData.effectList.effectList,GameData.instance.playerData.effectList.isOpen);
         this.onEffectTip();
      }
      
      private function onEffectTip(e:MessageEvent = null) : void
      {
         var systemNum:int = 0;
         if(GameData.instance.playerData.playerStatus == 3)
         {
            systemNum = 2;
         }
         var totalExp:int = GameData.instance.playerData.effectList.getTotalExpNum() + systemNum;
         if(totalExp == 0)
         {
            totalExp = 1;
         }
         var name:String = "EXP" + totalExp;
         var desc:String = "当前历练:" + totalExp + "倍";
         var totalCul:int = GameData.instance.playerData.effectList.getTotalCulNum();
         if(totalCul == 0)
         {
            totalCul = 1;
         }
         desc += " 当前修为:" + totalCul + "倍";
         this.view.setEffectTip(name,desc);
      }
      
      private function isPassDate() : Boolean
      {
         var time:Number = Number(new Date(2012,9,5).getTime());
         return GameData.instance.playerData.systemTimes > int(time / 1000);
      }
      
      private function onVeryDayShowEffect(e:MessageEvent = null) : void
      {
         var key:* = undefined;
         if(GameData.instance.playerData.isNewHand > 8)
         {
            for(key in GameData.instance.playerData.newvalue)
            {
               if(key == 2 && GameData.instance.playerData.newvalue[key] == 1)
               {
                  ButtonEffectUtil.registerEffect(this.view.getTopButton("dailyTaskClip"),ButtonEffect.EFFECT_LOTTERY,false);
               }
               else if(key == 5 && GameData.instance.playerData.newvalue[key] == 1)
               {
                  ButtonEffectUtil.registerEffect(this.view.getTopButton("awardClip"),ButtonEffect.EFFECT_LIGHT,false);
               }
               else if(key == 17)
               {
                  if(GameData.instance.playerData.newvalue[key] == 1)
                  {
                     new Alert().show("你的背包已满，请放生部分妖怪后重新登录并领取签到妖怪哦！");
                  }
                  else if(GameData.instance.playerData.newvalue[key] != 0)
                  {
                     new Alert().show("你忘记领取11月1日签到的妖怪啦！我们已经帮你领取了，快去背包或者妖怪仓库查看吧！");
                  }
               }
               else if(key == 18)
               {
                  if(GameData.instance.playerData.newvalue[key] == 0)
                  {
                     CacheData.instance.isPlayWeeklyActAmi = true;
                     ButtonEffectUtil.registerEffect(this.view.getTopButton("weeklyActivityMc"),ButtonEffect.EFFECT_WEEKLY_NEW,true);
                  }
                  else
                  {
                     ButtonEffectUtil.registerEffect(this.view.getTopButton("weeklyActivityMc"),ButtonEffect.EFFECT_WEEKLY,true);
                     CacheData.instance.isPlayWeeklyActAmi = false;
                  }
               }
            }
         }
         if(Boolean(this.iconstate[11]) && this.iconstate[11] == 0)
         {
            ButtonEffectUtil.registerEffect(this.view.getTopButton("awardClip"),ButtonEffect.EFFECT_AWARD1,false);
         }
      }
      
      private function onEffectChangeHandler(e:MessageEvent) : void
      {
         var data:Object = e.body;
         var state:int = data.itemSwitch == 1 ? 2 : 1;
         sendMessage(MsgDoc.OP_CLIENT_EFFECT_BACK.send,2,[data.type,state]);
      }
      
      public function onClickpeerlessBtn(event:InterfaceEvent) : void
      {
         if(this.isNewPlayer())
         {
            return;
         }
         this.openModule("assets/activity/activityPeerless/ActivityPeerless.swf");
      }
      
      private function onPhonePlayNotifyAward(evt:MessageEvent) : void
      {
         var ary:Array = evt.body as Array;
         if(ary[0] == 2 || ary[1] != 0)
         {
            ButtonEffectUtil.delEffect(this.view.getTopButton("phonePlayBtn"));
         }
      }
      
      public function onClickcompensationBtn(event:InterfaceEvent) : void
      {
         if(this.isNewPlayer())
         {
            return;
         }
         this.openModule("assets/activity/202408/Act402/Act402Entrance.swf");
      }
      
      public function onClickcompensationBtn2(event:InterfaceEvent) : void
      {
         if(this.isNewPlayer())
         {
            return;
         }
         this.openModule("assets/activity/202412/Act410/Act410Entrance.swf");
      }
      
      public function onClickBossGloryBtn(event:InterfaceEvent) : void
      {
         if(this.isNewPlayer())
         {
            return;
         }
         this.openModule("assets/activity/202411/ActBossGlory/ActBossGloryEntrance.swf");
      }
      
      public function onClickyearVipMc(evt:InterfaceEvent) : void
      {
         ButtonEffectUtil.delEffect(this.view.getTopButton("yearVipMc"));
         if(this.isNewPlayer())
         {
            return;
         }
         this.openModule("assets/activity/zrk2025/Act601/Act601Entrance.swf");
      }
      
      public function onClickvipDoubleWeal(evt:InterfaceEvent) : void
      {
         ButtonEffectUtil.delEffect(this.view.getTopButton("yearVipMc"));
         if(this.isNewPlayer())
         {
            return;
         }
         this.openModule("assets/activity/djj2024/Act603/Act603Entrance.swf");
      }
      
      public function onClickgiveMaxBtn(evt:InterfaceEvent) : void
      {
         if(this.isNewPlayer())
         {
            return;
         }
         this.openModule("assets/activity/201310/onlineAward1031/Active20131031OnlineAward.swf");
      }
      
      public function onClickbenyuanBtn(evt:InterfaceEvent) : void
      {
         if(this.isNewPlayer())
         {
            return;
         }
         CacheData.instance.isClickBenYuanBtn = true;
         dispatch(EventConst.ENTERSCENE,6004);
      }
      
      public function onClickescortGoodsBtn(evt:InterfaceEvent) : void
      {
         var btn:TopButton = null;
         if(this.isNewPlayer())
         {
            return;
         }
         dispatch(EventConst.ENTERSCENE,22008);
         btn = FaceView.clip.topClip.getButtonByName("escortGoodsBtn");
         if(btn.getRedPointVisible)
         {
            GlobalConfig.otherObj["ACT_672_zy"] = 1;
         }
         else
         {
            GlobalConfig.otherObj["ACT_672_zy"] = 0;
         }
      }
   }
}

