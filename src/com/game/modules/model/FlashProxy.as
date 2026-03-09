package com.game.modules.model
{
   import com.channel.ChannelEvent;
   import com.channel.ChannelPool;
   import com.channel.Message;
   import com.core.model.Model;
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.locators.CacheData;
   import com.game.locators.GameData;
   import com.game.locators.MsgDoc;
   import com.game.modules.control.FlashControl;
   import com.game.modules.control.LittlegameControl;
   import com.game.modules.control.SceneAIGameControl;
   import com.game.modules.control.pop.PopControl;
   import com.game.modules.view.MapView;
   import com.game.modules.view.RankingListView;
   import com.game.modules.view.WindowLayer;
   import com.game.modules.view.achieve.AchieveRank;
   import com.game.modules.view.exchange.ExchangeView;
   import com.game.modules.view.family.FamilyCheckIn;
   import com.game.modules.view.family.FamilyInfoWrite;
   import com.game.modules.view.family.FamilyRank;
   import com.game.modules.view.family.FamilySn;
   import com.game.modules.view.gameexchange.EnterDoorView;
   import com.game.modules.view.gameexchange.GameExchange;
   import com.game.modules.view.job.JobView;
   import com.game.modules.view.kb_class.KB_Class_View;
   import com.game.modules.view.menology.MenologyView;
   import com.game.modules.view.monsteridentify.MonsterShowView;
   import com.game.modules.view.person.GamePerson;
   import com.game.modules.view.stgcopy.StgCopyRank;
   import com.game.modules.view.task.TaskView;
   import com.game.modules.view.wakeup.SelectSpiritView;
   import com.game.modules.view.wishwall.WishWallView;
   import com.game.util.FloatAlert;
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.alert.Alert;
   import com.xygame.module.battle.event.BattleEvent;
   import flash.geom.Point;
   import flash.utils.getQualifiedClassName;
   import flash.utils.getTimer;
   import org.engine.core.GameSprite;
   import org.green.server.manager.SocketManager;
   
   public class FlashProxy extends Model
   {
      
      public static const NAME:String = "FlashProxy";
      
      private var flashControl:FlashControl;
      
      private var gameType:int;
      
      private var gameTypeXYLIst:Array = [{
         "type":2,
         "x":100,
         "y":100
      },{
         "type":10,
         "x":100,
         "y":100
      }];
      
      private var lastTime:Number = 0;
      
      private var currentTime:Number;
      
      private var stopTime:int = 1000;
      
      private var rubbishStopTime:int = 1000;
      
      public function FlashProxy()
      {
         super(NAME);
         ApplicationFacade.getInstance().registerViewLogic(new FlashControl());
         ApplicationFacade.getInstance().registerViewLogic(new PopControl());
         this.initListen();
      }
      
      private function initListen() : void
      {
         ChannelPool.getChannel("bigmap").addChannelListener("onclickmap",this.onClickMap);
         ChannelPool.getChannel("onclickbuy").addChannelListener("buygoods",this.onBuyGoods);
         ChannelPool.getChannel("itemclick").addChannelListener("onclicktripod",this.onClickTripod);
         ChannelPool.getChannel("itemclick").addChannelListener("onclicklastsence",this.onClicklastsence);
         ChannelPool.getChannel("itemclick").addChannelListener("onclickdoor",this.onClickDoor);
         ChannelPool.getChannel("itemclick").addChannelListener("onclickElephent",this.onclickElephent);
         ChannelPool.getChannel("itemclick").addChannelListener("onclicknpc",this.onClickNpc);
         ChannelPool.getChannel("itemclick").addChannelListener("requestnpcstate",this.onRequestNPCState);
         ChannelPool.getChannel("itemclick").addChannelListener("onclickliandanlu",this.onClickLiandanlu);
         ChannelPool.getChannel("itemclick").addChannelListener("onclickdragon",this.onClickDragon);
         ChannelPool.getChannel("itemclick").addChannelListener("onsendqkmsg",this.onClickQuickMsg);
         ChannelPool.getChannel("onclickrole").addChannelListener("oncreaterole",this.onCreateRole);
         ChannelPool.getChannel("itemclick").addChannelListener("ongoumaidaoju",this.onClickGoumai);
         ChannelPool.getChannel("itemclick").addChannelListener("ongoumaicaijidaoju",this.onClickGoumaiCaiji);
         ChannelPool.getChannel("itemclick").addChannelListener("hunaxingzhaoshi",this.onClickSkillRecover);
         ChannelPool.getChannel("itemclick").addChannelListener("onwakeupskill",this.onWakeUpOpen);
         ChannelPool.getChannel("itemclick").addChannelListener("starthecheng",this.onStartHeCheng);
         ChannelPool.getChannel("itemclick").addChannelListener("gotoLiandanlu",this.gotoLiandanlu);
         ChannelPool.getChannel("itemclick").addChannelListener("onlingqu",this.onClickLingQu);
         ChannelPool.getChannel("itemclick").addChannelListener("onduihuan",this.onClickDuihuan);
         ChannelPool.getChannel("itemclick").addChannelListener("onclickxiangzi",this.onClickXiangzi);
         ChannelPool.getChannel("itemclick").addChannelListener("onhuodejinghun",this.huoDeJinghun);
         ChannelPool.getChannel("itemclick").addChannelListener("onclicktower",this.onClickTower);
         ChannelPool.getChannel("itemclick").addChannelListener("onleftcopy",this.onLeftCopy);
         ChannelPool.getChannel("itemclick").addChannelListener("onopenmonsterpanel",this.onOpenMonsterPanel);
         ChannelPool.getChannel("itemclick").addChannelListener("onclicktiger",this.onClickTiger);
         ChannelPool.getChannel("shakewindow").addChannelListener("onshakewindow",this.onShakeWindow);
         ChannelPool.getChannel("checkintoarea").addChannelListener("onintoarea",this.onIntoArea);
         ChannelPool.getChannel("itemclick").addChannelListener("npctask",this.onNPCTalk);
         ChannelPool.getChannel("itemclick").addChannelListener("removemyself",this.onRemoveMySelf);
         ChannelPool.getChannel("itemclick").addChannelListener("removeaboveme",this.onRemoveMasterAboveAI);
         ChannelPool.getChannel("itemclick").addChannelListener("onstartlittlegame",this.onStartLittleGame);
         ChannelPool.getChannel("itemclick").addChannelListener("playeffectnotebyai",this.playEffectNoteByAI);
         ChannelPool.getChannel("itemclick").addChannelListener("clickdailynpc",this.onClickDailyNPC);
         ChannelPool.getChannel("itemclick").addChannelListener("movestone",this.onMoveStone);
         ChannelPool.getChannel("sceneAI").addChannelListener("trigerAI",this.onTrigerAI);
         ChannelPool.getChannel("itemclick").addChannelListener("job",this.openJobView);
         ChannelPool.getChannel("fabao").addChannelListener("getfabao",this.onGetFabao);
         ChannelPool.getChannel("itemclick").addChannelListener("gotoYunzhandong",this.gotoYunzhandong);
         ChannelPool.getChannel("itemclick").addChannelListener("removeShade",this.removeShade);
         ChannelPool.getChannel("itemclick").addChannelListener("openranklist",this.openRankList);
         ChannelPool.getChannel("itemclick").addChannelListener("agreement",this.openAgreeMent);
         ChannelPool.getChannel("itemclick").addChannelListener("playaction",this.notifyPlayAction);
         ChannelPool.getChannel("itemclick").addChannelListener("opendialogview",this.openDialogView);
         ChannelPool.getChannel("itemclick").addChannelListener("oncheckMonster",this.onCheckMonster);
         ChannelPool.getChannel("itemclick").addChannelListener("onclickxuanwo",this.onRandomMonster);
         ChannelPool.getChannel("itemclick").addChannelListener("onclicknpcgo",this.onClickMonkey);
         ChannelPool.getChannel("itemclick").addChannelListener("onclickshuiliandong",this.onClickshuilianDong);
         ChannelPool.getChannel("SceneAIGame").addChannelListener("startsceneAiGame",this.startSceneAIGame);
         ChannelPool.getChannel("itemclick").addChannelListener("openMyTreasuresView",this.onOpenMyTreasueresView);
         ChannelPool.getChannel("ItemClick").addChannelListener("openwishwall",this.onOpenWishView);
         ChannelPool.getChannel("itemclick").addChannelListener("haslight",this.opChildrenslight);
         ChannelPool.getChannel("itemclick").addChannelListener("family_opration",this.onFamilyOperation);
         ChannelPool.getChannel("itemclick").addChannelListener("onGotoExchange",this.onGotoExchangeGame);
         ChannelPool.getChannel("itemclick").addChannelListener("onEnterGamehall",this.onEnterGamehall);
         ChannelPool.getChannel("itemclick").addChannelListener("enterToGame",this.onEnterToGame);
         ChannelPool.getChannel("itemclick").addChannelListener("openfamily",this.onOpenFamily);
         ChannelPool.getChannel("itemclick").addChannelListener("opendangan",this.openDangAn);
         ChannelPool.getChannel("itemclick").addChannelListener("openrubbish",this.openRubbish);
         ChannelPool.getChannel("itemclick").addChannelListener("familykaoqing",this.onFamilyCheckIn);
         ChannelPool.getChannel("itemclick").addChannelListener("openfamilyranklist",this.onFamilyRank);
         ChannelPool.getChannel("itemclick").addChannelListener("jiazugongxian",this.openFamilyContribution);
         ChannelPool.getChannel("itemclick").addChannelListener("lookmovie",this.onLookMovie);
         ChannelPool.getChannel("itemclick").addChannelListener("jiayuanshenshou",this.onJiayuanShenshou);
         ChannelPool.getChannel("itemclick").addChannelListener("openhuigu",this.onOpenHuiGu);
         ChannelPool.getChannel("itemclick").addChannelListener("startclassgame",this.onStartClassGame);
         ChannelPool.getChannel("itemclick").addChannelListener("onuseclickdailytaskmsg",this.onNeedUseClickDailyTaskMsg);
         ChannelPool.getChannel("itemclick").addChannelListener("startyaojiang",this.onStartYaoJiang);
         ChannelPool.getChannel("itemclick").addChannelListener("openrili",this.onOpenRiLi);
         ChannelPool.getChannel("itemclick").addChannelListener("liuyantiao",this.onOpenLiuyantiao);
         ChannelPool.getChannel("itemclick").addChannelListener("denglong",this.onDengLong);
         ChannelPool.getChannel("itemclick").addChannelListener("startdanjigame",this.onStartDanjiGame);
         ChannelPool.getChannel("datatrans").addChannelListener("fightbossc2s",this.onFightBossToServer);
         ChannelPool.getChannel("datatrans").addChannelListener("mojingluopanc2s",this.onMoJingLuoPanToServer);
         ChannelPool.getChannel("datatrans").addChannelListener("zhongqiudengjiac2s",this.onMidAutumnDay);
         ChannelPool.getChannel("datatrans").addChannelListener("classtexunc2s",this.onClassTexunToServer);
         ChannelPool.getChannel("datatrans").addChannelListener("alertmessage",this.alertHandler);
         ChannelPool.getChannel("datatrans").addChannelListener("awardalertmessage",this.awardalertHandler);
         ChannelPool.getChannel("itemclick").addChannelListener("shenshouShop",this.onShenshouShop);
         ChannelPool.getChannel("itemclick").addChannelListener("shenshouTool",this.onShenshouTool);
         ChannelPool.getChannel("itemclick").addChannelListener("openchengjiuranklist",this.onOpenChengJiuRankList);
         ChannelPool.getChannel("itemclick").addChannelListener("ongotonextlevel",this.onGotoNextLevel);
         ChannelPool.getChannel("itemclick").addChannelListener("openbaoxiang",this.openBaoxiang);
         ChannelPool.getChannel("itemclick").addChannelListener("opentanxianbang",this.openTanxianbang);
         ChannelPool.getChannel("itemclick").addChannelListener("openJishiPaiMai",this.openJiShiPai);
         ChannelPool.getChannel("itemclick").addChannelListener("openhomemsgview",this.openHomeMsgView);
         ChannelPool.getChannel("itemclick").addChannelListener("openscoreexchangeview",this.openScoreExchangeView);
         ChannelPool.getChannel("datatrans").addChannelListener("gettaskprogress",this.onGetTaskProgress);
         ChannelPool.getChannel("itemclick").addChannelListener("opengonggaoyi",this.openGonggaoyi);
         ChannelPool.getChannel("itemclick").addChannelListener("openfacechangeview",this.openFaceChangeView);
         ChannelPool.getChannel("itemclick").addChannelListener("openkabuworksview",this.openKabuWorksView);
         ChannelPool.getChannel("itemclick").addChannelListener("opensubmitview",this.openSubmitView);
         ChannelPool.getChannel("itemclick").addChannelListener("openRongYao",this.openBadgeModule);
         ChannelPool.getChannel("itemclick").addChannelListener("openjiajuzazhi",this.openJiaJuZaZhi);
         ChannelPool.getChannel("itemclick").addChannelListener("openshangcheng",this.openShangCheng);
         ChannelPool.getChannel("itemclick").addChannelListener("openModule",this.openModule);
         ChannelPool.getChannel("itemclick").addChannelListener("openSwfWindow",this.openSwfWindow);
         ChannelPool.getChannel("itemclick").addChannelListener("openWeedkenAward",this.onOpenWeedkenAward);
         ChannelPool.getChannel("itemclick").addChannelListener("showleidian",this.onShowLeiDian);
         ChannelPool.getChannel("itemclick").addChannelListener("onclickpeiyuai",this.openHuaXingYi);
         ChannelPool.getChannel("itemclick").addChannelListener("openBonesCaveDoor",this.onOpenBonesCaveDoor);
         ChannelPool.getChannel("itemclick").addChannelListener("openAwardLine",this.openAwardLineHandler);
         ChannelPool.getChannel("itemclick").addChannelListener("openArenaProject",this.openArenaProject);
         ChannelPool.getChannel("itemclick").addChannelListener("openVipRechageProject",this.openVipRechageProject);
         ChannelPool.getChannel("itemclick").addChannelListener("openProjectModule",this.openProjectModule);
         ChannelPool.getChannel("itemclick").addChannelListener("openlookforpartner",this.openLookForPartner);
         ChannelPool.getChannel("taskDialogComplete").addChannelListener("ontaskDialogComplete",this.ontaskDialogComplete);
      }
      
      private function ontaskDialogComplete(evt:ChannelEvent) : void
      {
         evt.stopImmediatePropagation();
         var params:Object = evt.getMessage().getBody();
         SocketManager.getGreenSocket().sendCmd(MsgDoc.OP_CLIENT_REQ_TASKTALK.send,TaskView.instance.currentNPCID,[params.dialogid]);
      }
      
      private function openLookForPartner(e:ChannelEvent) : void
      {
         e.stopImmediatePropagation();
         dispatch(EventConst.OPEN_MODULE,{
            "url":"assets/module/LookForPartner.swf",
            "xCoord":0,
            "yCoord":0
         });
      }
      
      private function openHuaXingYi(evt:ChannelEvent) : void
      {
         dispatch(EventConst.BOBSTATECLICK,{"url":"assets/cultivate/SpiritFormView.swf"});
      }
      
      private function openModule(evt:ChannelEvent) : void
      {
         var params:Object = evt.getMessage().getBody();
         this.dispatch(EventConst.OPEN_MODULE,{
            "url":params.url,
            "xCoord":0,
            "yCoord":0
         });
      }
      
      private function openSwfWindow(evt:ChannelEvent) : void
      {
         this.dispatch(EventConst.OPENSWFWINDOWS,evt.getMessage().getBody());
      }
      
      private function openShangCheng(evt:ChannelEvent) : void
      {
         dispatch(EventConst.BOBSTATECLICK,{"url":"assets/mall/MallUI.swf"});
      }
      
      private function openJiaJuZaZhi(evt:ChannelEvent) : void
      {
         this.dispatch(EventConst.OPEN_MODULE,{
            "url":"assets/module/HomeMagazineModule.swf",
            "xCoord":0,
            "yCoord":0
         });
      }
      
      private function openBadgeModule(evt:ChannelEvent) : void
      {
         GameData.instance.playerData.selfStageRecord = GameData.instance.playerData.houseId;
         dispatch(EventConst.BOBSTATECLICK,{"url":"assets/badge/BadgeView.swf"});
      }
      
      private function openSubmitView(evt:ChannelEvent) : void
      {
         this.dispatch(EventConst.OPEN_MODULE,{
            "url":"assets/module/SubmitPieceModuel.swf",
            "xCoord":0,
            "yCoord":0
         });
      }
      
      private function openKabuWorksView(evt:ChannelEvent) : void
      {
         dispatch(EventConst.BOBSTATECLICK,{"url":"assets/module/KabuWorks.swf"});
      }
      
      private function openFaceChangeView(evt:ChannelEvent) : void
      {
         this.dispatch(EventConst.OPEN_MODULE,{
            "url":"assets/module/FaceChangeModule.swf",
            "xCoord":240,
            "yCoord":0
         });
      }
      
      private function openGonggaoyi(evt:ChannelEvent) : void
      {
         dispatch(EventConst.BOBSTATECLICK,{"url":"assets/module/ActivityNotice.swf"});
      }
      
      private function openHomeMsgView(evt:ChannelEvent) : void
      {
         MapView.instance.masterPerson.moveto(714,306,this.openHomeMessage);
      }
      
      private function openHomeMessage() : void
      {
         this.dispatch(EventConst.OPEN_MODULE,{
            "url":"assets/module/HomeMessage.swf",
            "xCoord":0,
            "yCoord":0
         });
      }
      
      private function openScoreExchangeView(evt:ChannelEvent) : void
      {
         this.dispatch(EventConst.OPEN_MODULE,{
            "url":"assets/module/ScoreExchangeModule.swf",
            "xCoord":0,
            "yCoord":0
         });
      }
      
      private function openJiShiPai(evt:ChannelEvent) : void
      {
         var sendBody:Object = {
            "url":"assets/module/AuctionTimeProject.swf",
            "xCoord":0,
            "yCoord":0
         };
         dispatch(EventConst.OPEN_MODULE,sendBody);
      }
      
      private function openTanxianbang(evt:ChannelEvent) : void
      {
         dispatch(EventConst.OPEN_CACHE_VIEW,{
            "showX":0,
            "showY":0
         },null,getQualifiedClassName(StgCopyRank));
      }
      
      private function onGotoNextLevel(evt:ChannelEvent) : void
      {
         var param:Object = evt.getMessage().getBody();
         if(MapView.instance.masterPerson.moveto(evt.getMessage().getBody().steerX,evt.getMessage().getBody().steerY,this.startGotoNextlevel))
         {
            ApplicationFacade.getInstance().dispatch(EventConst.ROLEMOVE,{
               "newx":evt.getMessage().getBody().steerX,
               "newy":evt.getMessage().getBody().steerY,
               "path":null
            });
         }
      }
      
      private function startGotoNextlevel() : void
      {
         dispatch(EventConst.GOTONEXTLEVEL);
         if(GameData.instance.playerData.currentCopyLevel > 35 && GameData.instance.playerData.currentCopyType == 2)
         {
            new Alert().showOne("因常年无人到达此层，石门已失灵，目前不可进入。");
         }
      }
      
      private function openBaoxiang(evt:ChannelEvent) : void
      {
         var param:Object = evt.getMessage().getBody();
         if(MapView.instance.masterPerson.moveto(evt.getMessage().getBody().steerX,evt.getMessage().getBody().steerY,this.startOpenBaoxiang))
         {
            ApplicationFacade.getInstance().dispatch(EventConst.ROLEMOVE,{
               "newx":evt.getMessage().getBody().steerX,
               "newy":evt.getMessage().getBody().steerY,
               "path":null
            });
         }
      }
      
      private function startOpenBaoxiang() : void
      {
         ApplicationFacade.getInstance().dispatch(BattleEvent.npcClick,{"sid":0});
      }
      
      private function onOpenChengJiuRankList(evt:ChannelEvent) : void
      {
         dispatch(EventConst.OPEN_CACHE_VIEW,{
            "showX":0,
            "showY":0
         },null,getQualifiedClassName(AchieveRank));
      }
      
      private function onStartDanjiGame(evt:ChannelEvent) : void
      {
         dispatch(EventConst.OPENSWFWINDOWS,{
            "url":"assets/kbclass/singlegames/Schoolroom.swf",
            "xCoord":0,
            "yCoord":0
         });
      }
      
      private function onOpenRiLi(evt:ChannelEvent) : void
      {
         dispatch(EventConst.OPEN_CACHE_VIEW,{
            "showX":59.8,
            "showY":14.4
         },null,getQualifiedClassName(MenologyView));
      }
      
      private function onStartYaoJiang(evt:ChannelEvent) : void
      {
         if(evt.getMessage().getBody() is int)
         {
            this.dispatch(EventConst.ON_CLICK_YAOJIANGJI,2);
         }
         else
         {
            this.dispatch(EventConst.ON_CLICK_YAOJIANGJI,1);
         }
      }
      
      private function onStartClassGame(evt:ChannelEvent) : void
      {
         dispatch(EventConst.OPEN_CACHE_VIEW,{
            "showX":0,
            "showY":0
         },null,getQualifiedClassName(KB_Class_View));
      }
      
      private function onOpenHuiGu(evt:ChannelEvent) : void
      {
         dispatch(EventConst.BOBSTATECLICK,{
            "url":"assets/module/ShiBaoReview.swf",
            "xCoord":0,
            "yCoord":0
         });
      }
      
      private function onClickshuilianDong(evt:ChannelEvent) : void
      {
         dispatch(EventConst.ARRIVESHUILIANDONG,evt.getMessage().getBody());
      }
      
      private function removeShade(evt:ChannelEvent) : void
      {
         dispatch(EventConst.REMOVESHADE,evt.getMessage().getBody());
      }
      
      private function gotoYunzhandong(evt:ChannelEvent) : void
      {
         var obju:Object = evt.getMessage().getBody();
         dispatch(EventConst.ONGOTOYUNZHANDONG,evt.getMessage().getBody());
         GameData.instance.playerData.currentScenenId = obju.id;
      }
      
      private function gotoLiandanlu(evt:ChannelEvent) : void
      {
         var obju:Object = evt.getMessage().getBody();
         dispatch(EventConst.ONGOTOLIANDANFANG,evt.getMessage().getBody());
         GameData.instance.playerData.currentScenenId = obju.id;
      }
      
      private function onClickTower(evt:ChannelEvent) : void
      {
         dispatch(EventConst.QUERYCOPYPROGRESS,evt.getMessage().getBody());
      }
      
      private function onOpenMonsterPanel(evt:ChannelEvent) : void
      {
         dispatch(EventConst.BOBSTATECLICK,{
            "url":"assets/system/monsterPack/MonsterListModule.swf",
            "xCoord":0,
            "yCoord":0
         });
      }
      
      private function onLeftCopy(evt:ChannelEvent) : void
      {
         var obju:Object = evt.getMessage().getBody();
         dispatch(EventConst.ONLEFTCOPY,evt.getMessage().getBody());
      }
      
      private function onClickMap(evt:ChannelEvent) : void
      {
         var code:int = evt.getMessage().getBody() as int;
         GameData.instance.playerData.currentScenenId = code;
         dispatch(EventConst.ENTERSCENE,code);
         dispatch(EventConst.CLEARUI);
      }
      
      private function onClickQuickMsg(evt:ChannelEvent) : void
      {
         var msg:String = evt.getMessage().getBody().toString();
         dispatch(EventConst.SENDMSG,msg);
      }
      
      private function onBuyGoods(evt:ChannelEvent) : void
      {
         dispatch(EventConst.BUYGOODS,evt.getMessage().getBody());
      }
      
      private function onClickTripod(evt:ChannelEvent) : void
      {
         if(GameData.instance.playerData.userId == GameData.instance.playerData.houseId)
         {
            ApplicationFacade.getInstance().dispatch(EventConst.OPEN_MODULE,{
               "url":"assets/module/MonsterStorageModule.swf",
               "xCoord":0,
               "yCoord":0
            });
         }
      }
      
      private function onClicklastsence(evt:ChannelEvent) : void
      {
         var obj:Object = evt.getMessage().getBody();
         dispatch(EventConst.ONGOTOLASTSENCE,obj);
      }
      
      private function onClickDoor(evt:ChannelEvent) : void
      {
         var obj:Object = evt.getMessage().getBody();
         if(obj.hasOwnProperty("steerX"))
         {
            obj.steerX /= GameData.instance.scaleStep;
            obj.steerY /= GameData.instance.scaleStep;
         }
         dispatch(EventConst.ONCLICKDOOR,obj);
      }
      
      private function onclickElephent(evt:ChannelEvent) : void
      {
         var obj:Object = evt.getMessage().getBody();
         dispatch(EventConst.ONCLICKELEPHENT,obj);
      }
      
      private function onClickNpc(evt:ChannelEvent) : void
      {
         dispatch(EventConst.ONCLICKNPC,evt.getMessage().getBody());
      }
      
      private function onRequestNPCState(evt:ChannelEvent) : void
      {
         this.dispatch(EventConst.REQUESTNPCSTATE,evt.getMessage().getBody().id);
      }
      
      private function onClickNotNpc(evt:ChannelEvent) : void
      {
         dispatch(EventConst.ONCLICKNOTNPC,evt.getMessage().getBody());
      }
      
      public function onClickLiandanlu(evt:ChannelEvent) : void
      {
      }
      
      public function onClickDragon(evt:ChannelEvent) : void
      {
         dispatch(EventConst.ONCLICKDRAGON);
      }
      
      private function onClickGoumai(evt:ChannelEvent) : void
      {
         MapView.instance.masterPerson.moveto(489,248,this.openShowView);
      }
      
      private function openShowView() : void
      {
         if(getTimer() - this.stopTime < 1500)
         {
            return;
         }
         this.stopTime = getTimer();
         dispatch(EventConst.BOBSTATECLICK,{
            "url":"assets/material/shop.swf",
            "xCoord":130,
            "yCoord":0
         });
      }
      
      private function onClickGoumaiCaiji(evt:ChannelEvent) : void
      {
         MapView.instance.masterPerson.moveto(399,198,this.openCaiJiView);
      }
      
      private function openCaiJiView() : void
      {
         dispatch(EventConst.OPENSWFWINDOWS,{
            "url":"assets/material/caijishop.swf",
            "xCoord":130,
            "yCoord":0
         });
      }
      
      private function onCreateRole(evt:ChannelEvent) : void
      {
         dispatch(EventConst.CREATEROLE,evt.getMessage().getBody());
      }
      
      private function onStartHeCheng(evt:ChannelEvent) : void
      {
         if(GameData.instance.playerData.refineState)
         {
            new Alert().showSureOrCancel("确定停止炼制？",this.onRefineAlerClose);
            return;
         }
         dispatch(EventConst.BOBSTATECLICK,{
            "url":"assets/module/AlchemyModule.swf",
            "xCoord":0,
            "yCoord":0
         });
      }
      
      private function onRefineAlerClose(... rest) : void
      {
         if("确定" == rest[0])
         {
            GameData.instance.playerData.refineState = false;
            ApplicationFacade.getInstance().dispatch(EventConst.STOPREFINE);
         }
      }
      
      private function onClickLingQu(evt:ChannelEvent) : void
      {
         dispatch(EventConst.LINGQUPRIZE);
      }
      
      private function onClickDuihuan(evt:ChannelEvent) : void
      {
         dispatch(EventConst.OPEN_CACHE_VIEW,{
            "showX":0,
            "showY":20
         },null,getQualifiedClassName(ExchangeView));
      }
      
      private function huoDeJinghun(evt:ChannelEvent) : void
      {
         var param:int = evt.getMessage().getBody() as int;
         if(param == 4)
         {
            param = 1007;
         }
         if(param == 5)
         {
            param = 1010;
         }
         if(param == 2)
         {
            param = 1001;
         }
         if(param == 3)
         {
            param = 1004;
         }
         if(param == 6)
         {
            param = 1013;
         }
         dispatch(EventConst.LINGQUNEWHAND,param);
      }
      
      private function onClickXiangzi(evt:ChannelEvent) : void
      {
         if(ApplicationFacade.getInstance().retrieveViewLogic(LittlegameControl.NAME) == null)
         {
            ApplicationFacade.getInstance().registerViewLogic(new LittlegameControl());
         }
         dispatch(EventConst.LITTLE_GAME_START,1);
      }
      
      private function onClickGame4(evt:ChannelEvent) : void
      {
         if(ApplicationFacade.getInstance().retrieveViewLogic(LittlegameControl.NAME) == null)
         {
            ApplicationFacade.getInstance().registerViewLogic(new LittlegameControl());
         }
         dispatch(EventConst.LITTLE_GAME_START,4);
      }
      
      private function onClickSkillRecover(evt:ChannelEvent) : void
      {
         this.openSelectSpriteView();
      }
      
      private function onClickTiger(evt:ChannelEvent) : void
      {
         if(ApplicationFacade.getInstance().retrieveViewLogic(LittlegameControl.NAME) == null)
         {
            ApplicationFacade.getInstance().registerViewLogic(new LittlegameControl());
         }
         dispatch(EventConst.LITTLE_GAME_START,2);
      }
      
      private function onStartLittleGame(evt:ChannelEvent) : void
      {
         this.gameType = int(evt.getMessage().getBody().gameType);
         dispatch(EventConst.SHOW_LITTLE_GAME_START,int(evt.getMessage().getBody().gameType));
      }
      
      private function onShakeWindow(evt:ChannelEvent) : void
      {
         var i:int = 0;
         if(evt.getMessage().getBody() != null)
         {
            i = evt.getMessage().getBody() as int;
         }
         dispatch(EventConst.ONSHAKEWINDOW,i);
      }
      
      private function onIntoArea(evt:ChannelEvent) : void
      {
         dispatch(EventConst.CHECKINTOAREA,evt.getMessage().getBody());
      }
      
      private function onNPCTalk(evt:ChannelEvent) : void
      {
         dispatch(EventConst.ONNPCTALK,evt.getMessage().getBody().id);
      }
      
      private function onRemoveMySelf(evt:ChannelEvent) : void
      {
         dispatch(EventConst.REMOVEDYNAMICTASKNPC,evt.getMessage().getBody().id);
      }
      
      private function onRemoveMasterAboveAI(evt:ChannelEvent) : void
      {
         dispatch(EventConst.REMOVEMASTERABOVEAI,evt.getMessage().getBody().id);
      }
      
      private function playEffectNoteByAI(evt:ChannelEvent) : void
      {
         this.dispatch(EventConst.PLAYNPCEFFECTBYTASK,evt.getMessage().getBody());
      }
      
      private function onClickDailyNPC(evt:ChannelEvent) : void
      {
         this.dispatch(EventConst.DAILYTASKNPCCLICK,evt.getMessage().getBody());
      }
      
      private function onMoveStone(evt:ChannelEvent) : void
      {
         this.dispatch(EventConst.ONMOVESTONETORIGHTPLACE,evt.getMessage().getBody());
      }
      
      private function openJobView(evt:ChannelEvent) : void
      {
         var param:Object = evt.getMessage().getBody();
         if(MapView.instance.masterPerson.moveto(evt.getMessage().getBody().steerX,evt.getMessage().getBody().steerY,this.startopenJobView))
         {
            ApplicationFacade.getInstance().dispatch(EventConst.ROLEMOVE,{
               "newx":evt.getMessage().getBody().steerX,
               "newy":evt.getMessage().getBody().steerY,
               "path":null
            });
         }
      }
      
      private function startopenJobView() : void
      {
         dispatch(EventConst.OPEN_CACHE_VIEW,{
            "showX":200,
            "showY":110
         },null,getQualifiedClassName(JobView));
      }
      
      private function onTrigerAI(evt:ChannelEvent) : void
      {
         dispatch(EventConst.SCENEAREAAI,evt.getMessage().getBody());
      }
      
      private function onGetFabao(evt:ChannelEvent) : void
      {
         MapView.instance.masterPerson.moveto(285,173,this.getFaBao);
      }
      
      private function getFaBao() : void
      {
         dispatch(EventConst.GETFABAO);
      }
      
      private function onWakeUpOpen(event:ChannelEvent) : void
      {
         MapView.instance.masterPerson.moveto(726,284,this.openSelectSpriteView);
      }
      
      private function openSelectSpriteView() : void
      {
         this.dispatch(EventConst.OPEN_CACHE_VIEW,{
            "showX":0,
            "showY":0
         },null,getQualifiedClassName(SelectSpiritView));
      }
      
      private function openRankList(evt:ChannelEvent) : void
      {
         this.dispatch(EventConst.OPEN_CACHE_VIEW,{
            "showX":0,
            "showY":0
         },null,getQualifiedClassName(RankingListView));
      }
      
      private function openAgreeMent(evt:ChannelEvent) : void
      {
         var body:Object = evt.getMessage().getBody();
         if(body.index == 1)
         {
            new Alert().show("你还没同意游戏公约(∩_∩)");
         }
         else
         {
            dispatch(EventConst.OPENCREATEROLEVIEW);
         }
      }
      
      private function notifyPlayAction(evt:ChannelEvent) : void
      {
         var body:Object = evt.getMessage().getBody();
         this.dispatch(EventConst.SENDACTION,body);
      }
      
      private function openDialogView(evt:ChannelEvent) : void
      {
         this.dispatch(EventConst.FRESHMANGUIDETOTASK,evt.getMessage().getBody());
      }
      
      private function onCheckMonster(evt:ChannelEvent) : void
      {
         MapView.instance.masterPerson.moveto(268,442,this.openMonIdentify);
      }
      
      private function openMonIdentify() : void
      {
         this.dispatch(EventConst.OPEN_CACHE_VIEW,{
            "showX":0,
            "showY":0
         },null,getQualifiedClassName(MonsterShowView));
      }
      
      private function onRandomMonster(evt:ChannelEvent) : void
      {
         this.dispatch(EventConst.ARRIVEXUANWO,evt.getMessage().getBody());
      }
      
      private function onClickMonkey(evt:ChannelEvent) : void
      {
         var body:Object = evt.getMessage().getBody();
         MapView.instance.masterPerson.moveto(body.body.x,body.body.y,this.goNearAndDialog);
      }
      
      private function onGotoExchangeGame(evt:ChannelEvent) : void
      {
         MapView.instance.masterPerson.moveto(evt.getMessage().getBody().steerX,evt.getMessage().getBody().steerY,this.openGameExchangeView);
      }
      
      private function openGameExchangeView() : void
      {
         dispatch(EventConst.OPEN_CACHE_VIEW,{
            "showX":0,
            "showY":0
         },null,getQualifiedClassName(GameExchange));
      }
      
      private function onEnterGamehall(evt:ChannelEvent) : void
      {
         MapView.instance.masterPerson.moveto(evt.getMessage().getBody().steerX,evt.getMessage().getBody().steerY,this.startOpenGameHallView);
      }
      
      private function startOpenGameHallView() : void
      {
         if(URLUtil.gamehallweihu == "true")
         {
            new Alert().show("亲爱的小卡布，游戏大厅维护中哦~~请稍候再来~");
            return;
         }
         dispatch(EventConst.OPEN_CACHE_VIEW,{
            "showX":0,
            "showY":-5
         },null,getQualifiedClassName(EnterDoorView));
      }
      
      private function onEnterToGame(evt:ChannelEvent) : void
      {
         var gameId:int = -1;
         var roomId:int = -1;
         var tableId:int = -1;
         gameId = int(evt.getMessage().getBody().GameId);
         roomId = int(evt.getMessage().getBody().RoomId);
         tableId = int(evt.getMessage().getBody().TableId);
         GameData.instance.playerData.gamehalldata = {
            "GameId":gameId,
            "RoomId":roomId,
            "TableId":tableId,
            "invite":true
         };
         dispatch(EventConst.OPEN_CACHE_VIEW,{
            "enter":true,
            "showX":0,
            "showY":-5
         },null,getQualifiedClassName(EnterDoorView));
      }
      
      private function goNearAndDialog() : void
      {
         new Message("onclicknpc",{"id":301701}).sendToChannel("itemclick");
      }
      
      private function startSceneAIGame(evt:ChannelEvent) : void
      {
         if(ApplicationFacade.getInstance().retrieveViewLogic(SceneAIGameControl.NAME) == null)
         {
            ApplicationFacade.getInstance().registerViewLogic(new SceneAIGameControl(null));
         }
         dispatch(EventConst.STARTSCENEAIGAME,{"id":evt.getMessage().getBody().id});
      }
      
      private function onOpenMyTreasueresView(evt:ChannelEvent) : void
      {
         if(GameData.instance.playerData.houseId == GameData.instance.playerData.userId)
         {
            dispatch(EventConst.BOBSTATECLICK,{"url":"assets/home/MyTreasuresView.swf"});
         }
         else
         {
            new Alert().show("回自己的家园看看自己的宝藏吧");
         }
      }
      
      private function onOpenWishView(evt:ChannelEvent) : void
      {
         dispatch(EventConst.OPEN_CACHE_VIEW,{
            "showX":0,
            "showY":0
         },null,getQualifiedClassName(WishWallView));
      }
      
      private function opChildrenslight(evt:ChannelEvent) : void
      {
         var type:int = int(evt.getMessage().getBody().code);
         if(type == -2)
         {
            new Alert().showOne("哎呀...灯还亮着呢...稍微等一下吧...");
         }
         else if(type == 0)
         {
            new Alert().show("你已经激活了投影灯...^_^");
         }
         else if(type == 400101 || type == 400102 || type == 400103)
         {
            this.dispatch(EventConst.FRESHMANGUIDETOTASK,{
               "type":15,
               "coin":0,
               "exp":0,
               "cultivate":0,
               "itemCount":1,
               "item":[{
                  "itemType":1,
                  "itemID":type,
                  "itemNum":1
               }]
            });
         }
      }
      
      private function onFamilyOperation(evt:ChannelEvent) : void
      {
         if(evt.getMessage().getBody().hasOwnProperty("url"))
         {
            dispatch(EventConst.START_CREATE_FAMILY);
         }
         else if(evt.getMessage().getBody().hasOwnProperty("view"))
         {
            if(GameData.instance.playerData.family_id > 0)
            {
               return;
            }
            dispatch(EventConst.OPEN_CACHE_VIEW,{
               "showX":0,
               "showY":0
            },null,getQualifiedClassName(FamilyInfoWrite));
         }
      }
      
      private function onOpenFamily(evt:ChannelEvent) : void
      {
         dispatch(EventConst.OPENSWFWINDOWS,{
            "url":"assets/family/familyCreate.swf",
            "xCoord":130,
            "yCoord":0
         });
      }
      
      private function openDangAn(evt:ChannelEvent) : void
      {
         dispatch(EventConst.BOBSTATECLICK,{
            "url":"assets/module/FamilyFilesProject.swf",
            "moduleParams":{"flag":2}
         });
      }
      
      private function openRubbish(evt:ChannelEvent) : void
      {
         MapView.instance.masterPerson.moveto(774,212,this.openSureRubbish);
      }
      
      private function openSureRubbish() : void
      {
         if(getTimer() - this.rubbishStopTime < 1000)
         {
            return;
         }
         this.rubbishStopTime = getTimer();
         this.dispatch(EventConst.BOBSTATECLICK,{"url":"assets/system/rubbishRecycle/RubbishRecycle.swf"});
      }
      
      private function onFamilyCheckIn(evt:ChannelEvent) : void
      {
         if(GameData.instance.playerData.family_id == GameData.instance.playerData.family_base_id)
         {
            dispatch(EventConst.OPEN_CACHE_VIEW,{
               "showX":0,
               "showY":80
            },null,getQualifiedClassName(FamilyCheckIn));
         }
         else
         {
            new FloatAlert().show(WindowLayer.instance,300,400,"你不是该家族的成员哦！",5,300);
         }
      }
      
      private function onFamilyRank(evt:ChannelEvent) : void
      {
         dispatch(EventConst.OPEN_CACHE_VIEW,{
            "showX":0,
            "showY":0
         },null,getQualifiedClassName(FamilyRank));
      }
      
      private function openFamilyContribution(evt:ChannelEvent) : void
      {
         dispatch(EventConst.REQ_FAMILY_INFO,{
            "sn":FamilySn.FAMILYCONTRIBUTION_SN,
            "fid":GameData.instance.playerData.family_base_id
         });
      }
      
      private function onLookMovie(evt:ChannelEvent) : void
      {
         dispatch(EventConst.GETSINGLETASKINFO,{
            "callback":null,
            "taskId":6010005
         });
      }
      
      private function onJiayuanShenshou(event:ChannelEvent) : void
      {
         if(event.getMessage().getBody() != null)
         {
            dispatch(EventConst.ENTERSHENSHOU);
         }
         else
         {
            MapView.instance.masterPerson.moveto(100,343,this.enter_ShenShou);
         }
      }
      
      private function enter_ShenShou() : void
      {
         dispatch(EventConst.ENTERSHENSHOU,{
            "uid":GameData.instance.playerData.houseId,
            "uname":GameData.instance.playerData.houseName
         });
      }
      
      private function onNeedUseClickDailyTaskMsg(evt:ChannelEvent) : void
      {
         this.dispatch(EventConst.ACTIVE_TASK_BY_DAILY_TASK,{
            "type":evt.getMessage().getBody(),
            "taskID":0,
            "actionID":0
         });
      }
      
      private function onOpenLiuyantiao(evt:ChannelEvent) : void
      {
         dispatch(EventConst.OPENSWFWINDOWS,{
            "url":"assets/material/liuyantiao.swf",
            "xCoord":0,
            "yCoord":0
         });
      }
      
      private function onDengLong(evt:ChannelEvent) : void
      {
         var body:Object = evt.getMessage().getBody();
         body.param = 2;
         dispatch(EventConst.REQ_DENGLONG_INFO,body);
      }
      
      private function onFightBossToServer(evt:ChannelEvent) : void
      {
         var obj:Object = evt.getMessage().getBody();
         this.dispatch(EventConst.REQ_DENGLONG_INFO,{
            "param":obj.head,
            "id":obj.body
         });
      }
      
      private function onClassTexunToServer(evt:ChannelEvent) : void
      {
         var obj:Object = evt.getMessage().getBody();
         if(Boolean(obj.flag))
         {
            this.dispatch(EventConst.REQ_DENGLONG_INFO,{
               "param":obj.head,
               "id":obj.body
            });
         }
         else
         {
            this.dispatch(EventConst.GETSINGLETASKINFO,{
               "callback":null,
               "taskId":6010009
            });
         }
      }
      
      private function alertHandler(evt:ChannelEvent) : void
      {
         var alertcallback:Function = null;
         var obj:Object = evt.getMessage().getBody();
         if(obj.hasOwnProperty("callback"))
         {
            alertcallback = obj.callback;
         }
         switch(obj.type)
         {
            case 1:
               new Alert().show(obj.msg,alertcallback);
               break;
            case 2:
               new Alert().showOne(obj.msg,alertcallback);
               break;
            case 3:
               new Alert().showSureOrCancel(obj.msg,alertcallback);
               break;
            case 4:
               new FloatAlert().show(WindowLayer.instance,300,400,obj.msg,5,300);
         }
      }
      
      private function awardalertHandler(evt:ChannelEvent) : void
      {
         this.dispatch(EventConst.SHOW_AWARD_ALERT_BY_MATERIAL,evt.getMessage().getBody());
      }
      
      private function onShenshouShop(evt:ChannelEvent) : void
      {
         dispatch(EventConst.OPENSWFWINDOWS,{
            "url":"assets/shenshou/shenshoushopui.swf",
            "xCoord":230,
            "yCoord":50
         });
      }
      
      private function onShenshouTool(evt:ChannelEvent) : void
      {
         dispatch(EventConst.BUYSHENSHOUTOOLS,evt.getMessage().getBody());
      }
      
      private function onMoJingLuoPanToServer(evt:ChannelEvent) : void
      {
         this.dispatch(EventConst.SEND_PACKET_IN_MATERIAL,evt.getMessage().getBody());
      }
      
      private function onMidAutumnDay(evt:ChannelEvent) : void
      {
         var obj:Object = evt.getMessage().getBody();
         if(obj.flag == -10)
         {
            this.dispatch(EventConst.OPENSWFWINDOWS,{
               "url":"assets/active/midautumnactive.swf",
               "xCoord":0,
               "yCoord":0
            });
         }
         else
         {
            this.dispatch(EventConst.SEND_PACKET_IN_MID_AUTUMN,evt.getMessage().getBody());
         }
      }
      
      private function onGetTaskProgress(evt:ChannelEvent) : void
      {
         this.dispatch(EventConst.GETSINGLETASKINFO,{
            "callback":null,
            "taskId":evt.getMessage().getBody()
         });
      }
      
      private function onOpenWeedkenAward(evt:ChannelEvent) : void
      {
         dispatch(EventConst.GET_WEEDKEND_AWARD,1);
      }
      
      private function onShowLeiDian(evt:ChannelEvent) : void
      {
         var gamesprite:GameSprite = null;
         var ran:int = 0;
         var person:GamePerson = null;
         if(this.lastTime == 0)
         {
            this.lastTime = getTimer();
         }
         else
         {
            this.currentTime = getTimer();
            if((this.currentTime - this.lastTime) / 1000 < 3)
            {
               return;
            }
            this.lastTime = this.currentTime;
         }
         var list:Array = MapView.instance.scene.spriteList;
         var personList:Array = [];
         for each(gamesprite in list)
         {
            if(gamesprite is GamePerson)
            {
               personList.push(gamesprite);
            }
         }
         ran = Math.floor(Math.random() * personList.length);
         if(ran >= 0)
         {
            person = personList[ran] as GamePerson;
            this.dispatch(EventConst.YUNLEIXU_SHOWLEIDIAN,{"playerId":person.sequenceID});
         }
      }
      
      private function onOpenBonesCaveDoor(evt:ChannelEvent) : void
      {
         var point:Point = MapView.instance.masterPerson.ui.parent.localToGlobal(new Point(730,350));
         MapView.instance.masterPerson.moveto(point.x,point.y,this.onOpenCave);
      }
      
      private function onOpenCave() : void
      {
         this.dispatch(EventConst.OPEN_MODULE,{
            "url":"assets/copy/bones/BonesCaveDoor.swf",
            "xCoord":0,
            "yCoord":0
         });
      }
      
      private function openAwardLineHandler(e:ChannelEvent) : void
      {
      }
      
      private function openArenaProject(e:ChannelEvent) : void
      {
         if(CacheData.instance.isArenaEnd() > 0)
         {
            new FloatAlert().show(WindowLayer.instance,300,400,"本届封神之战已结束~",5,300);
         }
         else
         {
            this.dispatch(EventConst.BOBSTATECLICK,{"url":"assets/arena/ArenaProject.swf"});
         }
      }
      
      private function openVipRechageProject(e:ChannelEvent) : void
      {
         e.stopImmediatePropagation();
         dispatch(EventConst.BOBSTATECLICK,{"url":"assets/module/VipRechargeModule.swf"});
      }
      
      private function openProjectModule(e:ChannelEvent) : void
      {
         var moduleObj:Object = e.getMessage().getBody();
         dispatch(EventConst.OPEN_MODULE,moduleObj);
      }
   }
}

