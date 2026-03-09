package com.game.modules.view.battle
{
   import com.core.observer.MessageEvent;
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.global.GlobalConfig;
   import com.game.locators.GameData;
   import com.game.modules.control.battle.BattleControl;
   import com.game.modules.control.battle.BattleSayWords;
   import com.game.modules.view.battle.item.BattleDisplay;
   import com.game.modules.view.battle.item.LanguageItem;
   import com.game.modules.view.battle.other.BattleSiteView;
   import com.game.modules.view.battle.pool.BattleBloodMcPool;
   import com.game.modules.view.battle.pop.WinPetView;
   import com.game.util.BitValueUtil;
   import com.greensock.TweenLite;
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.alert.Alert;
   import com.publiccomponent.loading.XMLLocator;
   import com.publiccomponent.loading.data.SiteBuffTypeData;
   import com.util.SkillEffectDictory;
   import com.xygame.module.battle.battleItem.BattleRole;
   import com.xygame.module.battle.battleItem.BattleRoleEvent;
   import com.xygame.module.battle.battleItem.BufIcon;
   import com.xygame.module.battle.data.*;
   import com.xygame.module.battle.event.BattleEvent;
   import com.xygame.module.battle.util.*;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   import flash.utils.Timer;
   import flash.utils.clearInterval;
   import flash.utils.clearTimeout;
   import flash.utils.setInterval;
   import flash.utils.setTimeout;
   import sound.SoundManager;
   
   public class BattleView extends Sprite
   {
      
      private var battleControl:BattleControlPanel;
      
      private var spiritControl:SpiritControlPanel;
      
      public var toolControl:ToolControlPanel;
      
      private var btnControl:BtnPanel;
      
      public var spiritsInfoPanel:InforPanel;
      
      private var _skillLook:BattleDisplay;
      
      private var effectview:EffectView;
      
      public var battleViewMc:MovieClip;
      
      private var rolesCreateFinish:Boolean = false;
      
      private var _battleObject:BattleData;
      
      public var playerRole:BattleRole;
      
      public var otherRole:BattleRole;
      
      private var battleStatePanel:StatePanel;
      
      private var countTime:MovieClip;
      
      private var playerRoleArr:Array = [];
      
      private var otherRoleArr:Array = [];
      
      private var currentBufArr:Array = [];
      
      private var chufaBuf:Array = [];
      
      private var starBuf:Array = [];
      
      private var delBuf:Array = [];
      
      private var sourceLoader:BattleSourceLoader;
      
      private var ischangSprite:Boolean = true;
      
      private var isotherChangeSprite:Boolean = false;
      
      public var gameOver:Boolean;
      
      public var saylanguage:BattleSayWords;
      
      private var enterCount:int;
      
      private var dealbateinfo:Object;
      
      private var clearbattle:Boolean = false;
      
      private var bgbool:Boolean = false;
      
      private var effectloaded:Boolean = false;
      
      private var backgroupBitMapData:BitmapData;
      
      private var _winpet:WinPetView;
      
      private var _mcLoadTip:MovieClip;
      
      public var initValue:int = 286331153;
      
      public var myPlayOver:Boolean = true;
      
      public var escap:Boolean = false;
      
      public var playtype:int = 1;
      
      private var preskill:int = 0;
      
      private var _checkTips:Sprite;
      
      private var _checkTime:uint;
      
      private var _checkNum:int;
      
      private var _bitmaps:Vector.<Bitmap>;
      
      private var _siteLoad:Loader;
      
      private var _loadTime:Timer;
      
      public var pn:String = "";
      
      public var on:String = "";
      
      private var _oprationValue:int = 286331153;
      
      private var _siteView:BattleSiteView;
      
      private var _siteData:Array;
      
      private var battleRoleNum:int;
      
      private var _loadMaxNum:int;
      
      private var _newData:SpiritData;
      
      private var f:ColorMatrixFilter = new ColorMatrixFilter([-1,0,0,0,0,0,-1,0,0,0,0,0,-1,0,0,0,0,0,1,0]);
      
      private var needbloodeffect:Boolean = false;
      
      private const DEALADD_BLOOD_1:Array = [2,9,17,24,29,33,34,59,95];
      
      private const DEALADD_BLOOD_2:Array = [36,37,46,45,62,BufData.SITE_RECOVER_ID];
      
      private var _canOpration:Boolean = true;
      
      private var battleRoundEndInfo:Array = [];
      
      private var _canPlayNextOpration:Boolean = true;
      
      private var boobj:BattleOpration;
      
      private var bloodTool:Object = {
         100005:1,
         100006:1,
         100007:1,
         100008:1,
         100031:1,
         100034:1,
         100179:1,
         100180:1,
         100523:1,
         100758:1
      };
      
      private var usePPtoolbool:Boolean = false;
      
      public var puzhuovalue:int = 0;
      
      private var mytimer:Timer;
      
      private var _canBattle:Boolean = false;
      
      public var playerwin:Boolean = false;
      
      public var otherwin:Boolean = false;
      
      public var otherrun:Boolean = false;
      
      private var _rTi:Timer;
      
      private var _lTi:Timer;
      
      private const MOVE_Y:int = 30;
      
      public function BattleView()
      {
         super();
         this.addChild(BattleViewManager.getInstance().monView);
         this.addChild(BattleViewManager.getInstance().conView);
         this.addChild(BattleViewManager.getInstance().tipView);
         this._rTi = new Timer(300,1);
         this._lTi = new Timer(300,1);
         this._loadTime = new Timer(2000,1);
         this._loadTime.addEventListener(TimerEvent.TIMER_COMPLETE,this.onLoadComplete);
         this._siteData = [];
         this.opaqueBackground = 16711680;
         this.addEventListener(Event.ADDED_TO_STAGE,this.onAddToStageHandler);
      }
      
      public function setElemValue(value:Array) : void
      {
         if(Boolean(this.btnControl))
         {
            this.battleControl.elemValue = value;
         }
      }
      
      public function get oprationValue() : int
      {
         return this._oprationValue;
      }
      
      public function set oprationValue(value:int) : void
      {
         if(Boolean(this.btnControl))
         {
            this.btnControl.oprationValue = value;
         }
         this._oprationValue = value;
      }
      
      public function newRound() : void
      {
         this._canOpration = true;
         if(Boolean(this.battleControl))
         {
            this.battleControl.changingSpirit == 0;
         }
         if(Boolean(this.spiritControl))
         {
            this.spiritControl.newRound();
         }
         if(Boolean(this.btnControl))
         {
            this.btnControl.timeDown();
         }
         if(Boolean(this.effectview))
         {
            this.effectview.newRound();
         }
         if(Boolean(this._skillLook))
         {
            this._skillLook.newRound();
         }
      }
      
      private function onAddToStageHandler(event:Event) : void
      {
         if(GameData.instance.lookBattle != 1)
         {
            this.playerRole.visible = false;
            this._siteView.updateMonster(0,0);
            this.effectview.addeffect(SkillEffectDictory.instance.getEffect("enterEffect"),null);
         }
      }
      
      private function onEnterEffectOver(event:Event) : void
      {
         this.playerRole.visible = true;
         this.playerRole.spiritEnter();
         this._siteView.updateMonster(this.playerRole.roleInfo.spiritid,0);
      }
      
      public function set bgBitMapData(value:BitmapData) : void
      {
         var sourceRect:Rectangle = null;
         var colortran:ColorTransform = null;
         if(this.backgroupBitMapData == null)
         {
            if(Boolean(value))
            {
               this.backgroupBitMapData = value;
               sourceRect = new Rectangle(0,0,this.backgroupBitMapData.width,this.backgroupBitMapData.height);
               colortran = new ColorTransform(0.2,0.2,0.3,1,1,1,1,0);
               this.backgroupBitMapData.colorTransform(sourceRect,colortran);
            }
            this.saylanguage = new BattleSayWords();
         }
      }
      
      public function set battleObject(value:BattleData) : void
      {
         this.bgbool = false;
         this.rolesCreateFinish = false;
         this.effectloaded = false;
         this.enterCount = 0;
         this._battleObject = value;
         this.getxmldata();
         this.sourceLoader = new BattleSourceLoader();
         this.sourceLoader.addEventListener(BattleSourceLoader.sourceOk,this.onBgComp,false,0,true);
         if(GameData.instance.lookBattle == 1)
         {
            if(GameData.instance.newLookType != 2)
            {
               this.sourceLoader.battleBgUrl = URLUtil.getSvnVer("assets/battle/battlebg/look4.swf");
            }
         }
         this.sourceLoader.loaderSource();
         this.loadBattleEffect();
      }
      
      private function getxmldata() : void
      {
         SpiritXmlData.instance.spiritXmlData(this.recexmldata);
      }
      
      private function recexmldata(... arg) : void
      {
         this.loadBattleRole();
      }
      
      private function onBgComp(event:Event) : void
      {
         this.sourceLoader.removeEventListener(BattleSourceLoader.sourceOk,this.onBgComp);
         this.battleViewMc = this.sourceLoader.battleBg;
         this.bgbool = true;
         this.initBattle();
      }
      
      public function get battleObject() : BattleData
      {
         return this._battleObject;
      }
      
      private function initBattle() : void
      {
         if(this.bgbool && this.rolesCreateFinish && this.effectloaded)
         {
            this.initBattleView();
         }
      }
      
      public function initBattleView() : void
      {
         var combatBG:Bitmap = null;
         if(this.battleViewMc == null)
         {
            if(Boolean(this.sourceLoader))
            {
               this.sourceLoader.destroy();
            }
            this.sourceLoader = new BattleSourceLoader();
            this.sourceLoader.addEventListener(BattleSourceLoader.sourceOk,this.onBgComp,false,0,true);
            if(GameData.instance.lookBattle == 1)
            {
               if(GameData.instance.newLookType != 2)
               {
                  this.sourceLoader.battleBgUrl = URLUtil.getSvnVer("assets/battle/battlebg/look4.swf");
               }
            }
            this.sourceLoader.loaderSource();
            return;
         }
         BattleBloodMcPool.instance.prewarm(10);
         this._bitmaps = new Vector.<Bitmap>();
         if(Boolean(this.backgroupBitMapData))
         {
            combatBG = new Bitmap(this.backgroupBitMapData);
            BattleViewManager.getInstance().monView.addChild(combatBG);
            this.addBitmap(combatBG);
         }
         var siteBG:Bitmap = new Bitmap();
         BattleViewManager.getInstance().monView.addChild(siteBG);
         this.addBitmap(siteBG);
         BattleViewManager.getInstance().conView.addChild(this.battleViewMc);
         this.initBaseView();
         if(GameData.instance.lookBattle == 1)
         {
            switch(GameData.instance.newLookType)
            {
               case 2:
                  this.init4View();
                  break;
               default:
                  this.initLook();
            }
         }
         else
         {
            this.init4View();
         }
         this.spiritsInfoPanel.initAry(this._battleObject.pAry,this._battleObject.oAry);
         this.addBattleRole();
         this.startShow();
      }
      
      private function addBitmap(bmp:Bitmap) : Bitmap
      {
         this._bitmaps.push(bmp);
         return bmp;
      }
      
      private function initBaseView() : void
      {
         this.battleStatePanel = new StatePanel(this.battleViewMc["statePanel_mc"]);
         this.spiritsInfoPanel = new InforPanel(this.battleViewMc["spiritInfo"]);
         this.spiritsInfoPanel.battleType = this.battleObject.battleType;
         this.countTime = this.battleViewMc["countTime"];
         this.countTime.visible = false;
         this.countTime.gotoAndStop(1);
         this.battleViewMc.visible = false;
         this._siteView = new BattleSiteView();
         this.battleViewMc.addChild(this._siteView);
      }
      
      private function init4View() : void
      {
         this._mcLoadTip = this.battleViewMc["mcLoadTip"];
         this.isPlayLoad(false);
         var sp:SpiritData = this.battleObject.getShowDisplay();
         if(sp != null)
         {
            this._skillLook = new BattleDisplay(sp);
            this._skillLook.visible = false;
            BattleViewManager.getInstance().tipView.addChild(this._skillLook);
         }
         this.btnControl = new BtnPanel(this.battleViewMc["btnControlmc"]);
         if(GameData.instance.newLookType == 2)
         {
            this.battleViewMc["toolsbar"].visible = false;
            this.battleViewMc["cancelAutoBtn"].visible = false;
            this.btnControl.changState(0,false);
            this.battleViewMc["btnOutLook"].visible = true;
            this.battleViewMc["btnOutLook"].addEventListener(MouseEvent.CLICK,this.onClickLeaveBtnHandler);
            this.battleControl = new BattleControlPanel(this.battleViewMc["skillsbar"]);
         }
         else
         {
            this.battleViewMc["btnOutLook"].visible = false;
            this.battleControl = new BattleControlPanel(this.battleViewMc["skillsbar"]);
            this.spiritControl = new SpiritControlPanel(this.battleViewMc["spiritbar"]);
            this.toolControl = new ToolControlPanel(this.battleViewMc["toolsbar"]);
            this.btnControl.addEventListener(BattleEvent.PANEL_CLICK_EVENT,this.onBtnControlClick);
            this.battleControl.addEventListener(BattleEvent.BATTLE_CONTROL_CLICK_EVENT,this.onBattleControlClick);
            this.spiritControl.addEventListener(BattleEvent.SPIRIT_CONTROL_CLICK_EVENT,this.onSpiritControlClick);
            this.spiritsInfoPanel.addEventListener(BattleEvent.SPIRIT_CONTROL_CLICK_EVENT,this.onSpiritControlClick);
            this.toolControl.addEventListener(BattleEvent.BATTLE_USE_TOOL,this.onBattleUseToolClick);
            this.toolControl.battleType = this.battleObject.battleType;
            this.btnControl.escape = this.battleObject.escape;
            this.btnControl.battleType = this.battleObject.battleType;
            if(this.battleViewMc.hasOwnProperty("cancelAutoBtn"))
            {
               this.battleViewMc["cancelAutoBtn"].addEventListener(MouseEvent.CLICK,this.onClickCancelAutoBattle);
               if(GameData.instance.playerData.isAutoBattle)
               {
                  this.battleViewMc["cancelAutoBtn"].visible = true;
               }
               else
               {
                  this.battleViewMc["cancelAutoBtn"].visible = false;
               }
            }
         }
      }
      
      private function initLook() : void
      {
         var obj:Object = null;
         var i:int = 0;
         var playerList:Object = null;
         if(this.battleViewMc.hasOwnProperty("leaveBtn"))
         {
            this.battleViewMc["leaveBtn"].addEventListener(MouseEvent.CLICK,this.onClickLeaveBtnHandler);
         }
         if(GameData.instance.newLookType == 1)
         {
            obj = GlobalConfig.otherObj["Act703"];
            if(Boolean(obj))
            {
               this.battleViewMc["sBobName"].text = GlobalConfig.otherObj["Act703"]["sn2"]["name"];
               this.battleViewMc["sdBobName"].text = GlobalConfig.otherObj["Act703"]["sn1"]["name"];
               if(GlobalConfig.otherObj["Act703"]["sn2"]["isMaster"] == 1)
               {
                  this.battleViewMc["skillsbar"].gotoAndStop(1);
               }
               else if(GlobalConfig.otherObj["Act703"]["sn1"]["isMaster"] == 1)
               {
                  this.battleViewMc["skillsbar"].gotoAndStop(2);
               }
               else
               {
                  this.battleViewMc["skillsbar"].gotoAndStop(3);
               }
            }
         }
         else if(Boolean(this.battleViewMc.hasOwnProperty("sBobName")) && Boolean(GameData.instance.playerData.leitaidata))
         {
            for(i = 0; i < GameData.instance.playerLists.length; i++)
            {
               playerList = GameData.instance.playerLists[i];
               if(GameData.instance.playerLists[i].userId == this.playerRole.roleInfo.userid)
               {
                  this.pn = GameData.instance.playerLists[i].userName;
               }
               if(GameData.instance.playerLists[i].userId == this.otherRole.roleInfo.userid)
               {
                  this.on = GameData.instance.playerLists[i].userName;
               }
            }
            if(this.pn == "")
            {
               this.pn = GameData.instance.lookDname;
            }
            if(this.on == "")
            {
               this.on = GameData.instance.lookAname;
            }
            this.battleViewMc["sBobName"].text = "" + this.pn;
            this.battleViewMc["sdBobName"].text = "" + this.on;
         }
      }
      
      private function onClickLeaveBtnHandler(_arg1:MouseEvent) : void
      {
         new BattleAlert(this,"\t 你是否确定要提前退出本次观战？",true,true,false,this.onLeaveClich);
      }
      
      private function onLeaveClich(key:String) : void
      {
         if(key == "ok")
         {
            dispatchEvent(new Event(BattleEvent.LEAVE_BATTLE_CLICK));
         }
      }
      
      public function isPlayLoad(flag:Boolean) : void
      {
         if(!this._mcLoadTip)
         {
            return;
         }
         this._mcLoadTip.visible = flag;
         if(flag)
         {
            this._mcLoadTip.play();
         }
         else
         {
            if(Boolean(this._loadTime))
            {
               this._loadTime.stop();
            }
            this._mcLoadTip.gotoAndStop(1);
         }
      }
      
      private function onBtnControlClick(event:Event) : void
      {
         var op:Object = null;
         if(this.gameOver)
         {
            return;
         }
         if(this.btnControl.signId == 2 || this.btnControl.signId == 5)
         {
            this.showControlBar(256);
            dispatchEvent(new BattleEvent(BattleEvent.requestBattlTool));
         }
         else if(this.btnControl.signId == 1)
         {
            this.showControlBar(1);
            this.battleControl.setSkillArr(this.playerRole.roleInfo.skillArr);
            if(this._battleObject.newbattle && ApplicationFacade.getInstance().retrieveViewLogic(BattleControl.NAME)["step"] == 6)
            {
               dispatchEvent(new BattleEvent(BattleEvent.battleOpration,{"param":-1}));
            }
         }
         else if(this.btnControl.signId == 3)
         {
            this.showControlBar(16);
            this.spiritControl.setSpiritArr(this.battleObject.mySpiritArr);
         }
         else if(this.btnControl.signId == 4)
         {
            switch(this.battleObject.battleType)
            {
               case 0:
               case 1:
               case 2:
               case 7:
               case 8:
               case 9:
               case 12:
                  new BattleAlert(this,"\t  现在要逃离此次战斗吗？",true,true,false,this.onEscapHandler);
                  break;
               case 3:
               case 6:
                  new BattleAlert(this,"<font color=\'#000000\' size=\'16\'>跟其他玩家PK是不能逃跑!</font>");
                  break;
               case 4:
                  new BattleAlert(this,"<font color=\'#000000\' size=\'16\'>擂台战斗不能逃跑!</font>");
                  break;
               case 5:
                  new BattleAlert(this,"<font color=\'#000000\' size=\'16\'>大乱斗不能逃跑!</font>");
                  break;
               default:
                  new BattleAlert(this,"<p align=\'center\'>你确定要逃跑吗?<br>(逃跑后本场比赛按失败处理)</p>",true,true,false,this.onEscapHandler);
            }
         }
         else if(this.btnControl.signId == 6)
         {
            op = {};
            op.param = 0;
            op.target = this.otherRole.roleInfo.sid;
            op.skillId = 0;
            dispatchEvent(new BattleEvent(BattleEvent.battleOpration,op));
         }
         if(this._battleObject.newbattle && ApplicationFacade.getInstance().retrieveViewLogic(BattleControl.NAME)["step"] == 5)
         {
            dispatchEvent(new BattleEvent(BattleEvent.battleOpration,{"param":-1}));
         }
      }
      
      public function onEscapHandler(str:String) : void
      {
         if(str == "ok" && this.canBattle)
         {
            this.escap = true;
            dispatchEvent(new BattleEvent(BattleEvent.battleOpration,{
               "param":3,
               "escap":true
            }));
            this.playerRole.spiritOut();
            this._siteView.updateMonster(0,0);
         }
         else
         {
            this.btnControl.signId = 0;
         }
      }
      
      public function battleToolBack(obj:Object) : void
      {
         this.toolCanUse();
         this.showControlBar(256);
         this.toolControl.toolData(obj,this.btnControl.signId);
      }
      
      private function onBattleControlClick(event:Event) : void
      {
         SoundManager.instance.magicAtk(1);
         var obj:Object = {};
         obj.param = 0;
         obj.target = this.otherRole.roleInfo.sid;
         obj.skillId = this.battleControl.skillId;
         var xml:XML = XMLLocator.getInstance().getSkill(obj.skillId);
         if(Boolean(xml) && int(xml.range) == 2)
         {
            obj.target = this.playerRole.roleInfo.sid;
         }
         else
         {
            obj.target = this.otherRole.roleInfo.sid;
         }
         if(this.canBattle && this.playerRole.roleInfo.hp > 0)
         {
            this.canBattle = false;
            dispatchEvent(new BattleEvent(BattleEvent.battleOpration,obj));
            this.preskill = obj.skillId;
            this.countTime.gotoAndStop(11);
         }
         if(!this.canBattle || this.gameOver)
         {
            this.btnControl.changState(0,false);
         }
      }
      
      private function onSpiritControlClick(event:MessageEvent) : void
      {
         var obj:Object = {};
         obj.param = 1;
         obj.spiritid = this.battleObject.mySpiritArr[int(event.body)].uniqueid;
         obj.state = this.battleObject.mySpiritArr[int(event.body)].state;
         if(this.playerRole.roleInfo.hp <= 0)
         {
            this.countTime.gotoAndStop(11);
            this.showControlBar(16);
            this.spiritControl.setfilters();
            dispatchEvent(new BattleEvent(BattleEvent.battleOpration,obj));
         }
         else if(this.canBattle && this.oprationValue & this.initValue & 1 && obj.state != 1)
         {
            if(this.playerRole.roleInfo.hp > 0)
            {
               this.canBattle = false;
               this.countTime.gotoAndStop(11);
            }
            dispatchEvent(new BattleEvent(BattleEvent.battleOpration,obj));
         }
      }
      
      public function showBattleSkill() : void
      {
         this.showControlBar(1);
         if(Boolean(this.battleControl))
         {
            this.battleControl.setSkillArr(this.playerRole.roleInfo.skillArr);
         }
      }
      
      public function showControlBar(value:int) : void
      {
         if(Boolean(this.battleControl))
         {
            this.battleControl.visible = Boolean(value & 1);
         }
         if(Boolean(this.spiritControl))
         {
            this.spiritControl.visible = Boolean(value & 0x10);
         }
         if(Boolean(this.toolControl))
         {
            this.toolControl.visible = Boolean(value & 0x0100);
         }
      }
      
      private function onBattleUseToolClick(event:Event) : void
      {
         var sid:int = 0;
         if(!this.canBattle || !(this.oprationValue & this.initValue & 0x010000))
         {
            return;
         }
         this.canBattle = false;
         var po:int = this.toolControl.position;
         var pc:int = this.toolControl.packcode;
         var tooluse:int = BitValueUtil.getBitValue(XMLLocator.getInstance().tooldic[this.toolControl.toolid].useState,24) ? 2 : 1;
         if(tooluse == 2)
         {
            sid = this.otherRole.roleInfo.sid;
         }
         else if(tooluse == 1)
         {
            sid = this.playerRole.roleInfo.sid;
         }
         dispatchEvent(new BattleEvent(BattleEvent.battleOpration,{
            "param":2,
            "position":po,
            "packcode":pc,
            "sid":sid
         }));
      }
      
      private function onClickCancelAutoBattle(event:MouseEvent) : void
      {
         this.battleViewMc["cancelAutoBtn"].visible = false;
         dispatchEvent(new BattleEvent(BattleEvent.cancelAutoBattle));
         GameData.instance.playerData.isAutoBattle = false;
         this.btnControl.signId = 0;
         this.btnControl.changState(this.oprationValue & this.initValue,true);
         this.battleControl.updataFilters();
         this.spiritControl.removefilters();
         this.toolControl.removefilters();
      }
      
      private function loadBattleRole(... arg) : void
      {
         var data:SpiritData = null;
         this.battleRoleNum = 0;
         this._loadMaxNum = 0;
         var l:int = int(this.battleObject.battleArr.length);
         for(var b:int = 0; b < l; b++)
         {
            data = this.battleObject.battleArr[b];
            if(Boolean(data) && data.spiritid != 0)
            {
               ++this._loadMaxNum;
               this.singleLoad(this.battleObject.battleArr[b],true);
            }
         }
      }
      
      public function addNewSpirit(data:SpiritData) : void
      {
         this._newData = data;
      }
      
      private function singleLoad(data:SpiritData, isInit:Boolean) : void
      {
         var url:String = null;
         var br:BattleRole = null;
         var xml:XML = SpiritXmlData.spirititem(data.spiritid.toString());
         if(Boolean(xml))
         {
            data.url = xml.url;
            url = String(xml.url);
            data.srcid = url.substring(6,url.length - 3);
            data.name = xml.name;
            data.frame = xml.frame;
            data.sframe = xml.sframe;
            data.aframe = xml.aframe;
            data.catchType = xml.catchType;
            if(Boolean(xml.hasOwnProperty("showlp")))
            {
               data.showlp = xml.showlp;
            }
            br = new BattleRole(data);
            br.isInit = isInit;
            if(!isInit)
            {
               this._loadTime.reset();
               this._loadTime.start();
            }
            br.addEventListener(BattleRoleEvent.battleRoleOK,this.onBattleRoleOk);
         }
         else
         {
            O.o("BattleView/loadBattleRole()","未找到精灵" + data.spiritid + "的配置");
         }
      }
      
      private function removeRoleListeners(role:BattleRole, isOther:Boolean = true) : void
      {
         if(!role)
         {
            return;
         }
         role.removeEventListener(BattleRoleEvent.canOpration,this.onCanOpration);
         role.removeEventListener(BattleRoleEvent.changeRoleInfo,this.changeBattleRoleInfo);
         role.removeEventListener(BattleRoleEvent.bloodMcPlay,this.bloodEffect);
         role.removeEventListener(BattleRoleEvent.OPEN_SITE,this.onOpenSite);
         if(isOther)
         {
            role.removeEventListener(BattleRoleEvent.addBattleEffect,this.onOtherBeEffect);
         }
         else
         {
            role.removeEventListener(BattleRoleEvent.addBattleEffect,this.onPlayerBeEffect);
         }
         role.removeEventListener(BattleRoleEvent.enterSceneOver,this.onEnterSceneOver);
      }
      
      public function onBattleRoleOk(event:BattleRoleEvent) : void
      {
         var role:BattleRole = null;
         var targetArr:Array = null;
         var targetRoleRef:Object = null;
         var value:int = 0;
         this.isPlayLoad(false);
         event.battleRole.removeEventListener(BattleRoleEvent.battleRoleOK,this.onBattleRoleOk);
         if(this.clearbattle)
         {
            return;
         }
         role = event.battleRole;
         var roleInfo:SpiritData = role.roleInfo;
         if(this.isPlayerRole(roleInfo))
         {
            targetArr = this.playerRoleArr;
            targetRoleRef = {"ref":"playerRole"};
         }
         else
         {
            targetArr = this.otherRoleArr;
            targetRoleRef = {"ref":"otherRole"};
         }
         targetArr.push(role);
         if(roleInfo.state == 1)
         {
            this[targetRoleRef.ref] = role;
         }
         if(event.battleRole.isInit)
         {
            ++this.battleRoleNum;
            if(this.battleRoleNum == this._loadMaxNum)
            {
               if(this.playerRole != null && this.otherRole != null)
               {
                  this.rolesCreateFinish = true;
                  this.initBattle();
               }
            }
            value = this.battleRoleNum / this._loadMaxNum * 100;
            ApplicationFacade.getInstance().dispatch(EventConst.LOAD_BATTLE_SOURCE,value);
         }
         else
         {
            this.canOpration = true;
            this.dealChangeSpirit();
            this._newData = null;
         }
      }
      
      private function isPlayerRole(roleInfo:SpiritData) : Boolean
      {
         if(GameData.instance.lookBattle == 1)
         {
            if(GameData.instance.newLookType == 2)
            {
               return roleInfo.userid == BattleLookList.ins.playerInfo["player"]["id"];
            }
            return roleInfo.groupType == 1;
         }
         return roleInfo.userid == GlobalConfig.userId;
      }
      
      private function loadBattleEffect() : void
      {
         SkillEffectDictory.instance.effectIdArr = this.battleObject.allSkillArr;
         SkillEffectDictory.instance.addEventListener(SkillEffectDictory.SKILLEFFECTOK,this.onSkillEffectOk);
         SkillEffectDictory.instance.addEventListener(SkillEffectDictory.LOADPROGRESS,this.onSkillEffectProgress);
         SkillEffectDictory.instance.loadDefaultEffect();
      }
      
      private function onSkillEffectProgress(event:Event) : void
      {
         var value:int = 0;
         if(Boolean(this.battleObject))
         {
            value = (SkillEffectDictory.instance.countnum / (this.battleObject.allSkillArr.length + 5) * 0.5 + 0.5) * 100;
            ApplicationFacade.getInstance().dispatch(EventConst.LOAD_BATTLE_SOURCE,value);
         }
      }
      
      private function onSkillEffectOk(event:Event) : void
      {
         this.effectloaded = true;
         this.initBattle();
      }
      
      private function addBattleRole(enterOver:Boolean = false) : void
      {
         if(this.rolesCreateFinish && Boolean(this.battleViewMc))
         {
            if(!BattleViewManager.getInstance().monView.contains(this.playerRole))
            {
               this.playerRole.x = 970;
               if(!this.playerRole.hasEventListener(BattleRoleEvent.canOpration))
               {
                  this.playerRole.addEventListener(BattleRoleEvent.canOpration,this.onCanOpration);
                  this.playerRole.addEventListener(BattleRoleEvent.changeRoleInfo,this.changeBattleRoleInfo);
                  this.playerRole.addEventListener(BattleRoleEvent.bloodMcPlay,this.bloodEffect);
                  this.playerRole.addEventListener(BattleRoleEvent.OPEN_SITE,this.onOpenSite);
                  this.playerRole.addEventListener(BattleRoleEvent.addBattleEffect,this.onPlayerBeEffect);
                  this.playerRole.addEventListener(BattleRoleEvent.enterSceneOver,this.onEnterSceneOver);
               }
               this.spiritsInfoPanel.delAllBuf(this.playerRole.roleInfo.sid);
               this.playerRole.mouseChildren = false;
               this.playerRole.mouseEnabled = false;
               BattleViewManager.getInstance().monView.addChild(this.playerRole);
               if(GameData.instance.lookBattle != 1)
               {
                  if(this.battleControl.changingSpirit == 1)
                  {
                     this.playerRole.spiritEnter(enterOver);
                  }
                  this.battleControl.spiritId = this.playerRole.roleInfo.spiritid;
               }
               else
               {
                  this.playerRole.spiritEnter(enterOver);
               }
            }
            if(!BattleViewManager.getInstance().monView.contains(this.otherRole))
            {
               if(!this.otherRole.hasEventListener(BattleRoleEvent.canOpration))
               {
                  this.otherRole.addEventListener(BattleRoleEvent.canOpration,this.onCanOpration);
                  this.otherRole.addEventListener(BattleRoleEvent.changeRoleInfo,this.changeBattleRoleInfo);
                  this.otherRole.addEventListener(BattleRoleEvent.bloodMcPlay,this.bloodEffect);
                  this.otherRole.addEventListener(BattleRoleEvent.OPEN_SITE,this.onOpenSite);
                  this.otherRole.addEventListener(BattleRoleEvent.addBattleEffect,this.onOtherBeEffect);
                  this.otherRole.addEventListener(BattleRoleEvent.enterSceneOver,this.onEnterSceneOver);
               }
               this.spiritsInfoPanel.delAllBuf(this.otherRole.roleInfo.sid);
               if(GameData.instance.lookBattle != 1)
               {
                  if(this.otherRole.roleInfo.spiritid == 10065)
                  {
                     this.otherRole.filters = [this.f];
                  }
               }
               this.otherRole.mouseChildren = false;
               this.otherRole.mouseEnabled = false;
               BattleViewManager.getInstance().monView.addChild(this.otherRole);
               this.otherRole.spiritEnter(enterOver);
            }
            this.spiritsInfoPanel.setResult(this.playerRole.roleInfo,this.otherRole.roleInfo);
            this.spiritsInfoPanel.setSpirits(this.playerRoleArr,this.otherRoleArr);
            if(GameData.instance.lookBattle != 1)
            {
               if(!(this.isotherChangeSprite && this.playerRole.roleInfo.hp <= 0))
               {
                  this.showBattleSkill();
                  if(this.ischangSprite || GameData.instance.playerData.isAutoBattle)
                  {
                     this.btnControl.changState(0,false);
                     this.battleControl.setfilters(null);
                     this.btnControl.signId = 1;
                  }
                  else
                  {
                     this.btnControl.changState(this.oprationValue & this.initValue,true);
                  }
               }
            }
            else
            {
               switch(GameData.instance.newLookType)
               {
                  case 2:
                     this.showBattleSkill();
               }
            }
         }
         if(this.effectview == null)
         {
            this.effectview = new EffectView();
            BattleViewManager.getInstance().monView.addChild(this.effectview);
            this.effectview.addEventListener(EffectView.CATCHEFFECTOVER,this.onCatchOverHandler);
            this.effectview.addEventListener(EffectView.ENTEREFFECTOVER,this.onEnterEffectOver);
            this.effectview.addEventListener(EffectView.EFFECTPLAYOVER,this.onEffectOver);
            this.effectview.addEventListener(EffectView.SPIRITDIEOUT,this.onSpiritDieOut);
            this.effectview.addEventListener(EffectView.SPIRITLIVEOUT,this.onSpiritLiveOut);
         }
         BattleViewManager.getInstance().monView.setChildIndex(this.effectview,BattleViewManager.getInstance().monView.numChildren - 1);
         this.spiritsInfoPanel.attrInfo(SpiritXmlData.instance.attrInfo(this.playerRole.roleInfo.elem,this.otherRole.roleInfo.elem));
         this._siteView.updateMonster(this.playerRole.roleInfo.spiritid,0);
         this._siteView.updateMonster(this.otherRole.roleInfo.spiritid,1);
         if(GameData.instance.lookBattle != 1)
         {
            this.spiritControl.attrInfo(this.otherRole.roleInfo.elem);
         }
      }
      
      private function onCatchOverHandler(event:Event) : void
      {
         var xml:XML = null;
         if(this.puzhuovalue == 1 && this.boobj.catchData && GameData.instance.lookBattle == 0)
         {
            dispatchEvent(new MessageEvent(BattleEvent.catchover,this.boobj.catchData));
            xml = SpiritXmlData.spirititem(this.boobj.catchData.spiritId.toString());
            this.boobj.catchData.spiritName = xml.name;
            this.boobj.catchData.spiritInfo = xml.introduce;
            this.boobj.catchData.spiritAttr = xml.elem;
            this._winpet = new WinPetView(this.boobj.catchData);
            this._winpet.addEventListener(Event.CLOSE,this.sucessPuzhuo);
            this._winpet.show(this,260);
         }
         else
         {
            this.otherRole.spiritEnter(true);
            this.puzhuovalue = 0;
            this.canOpration = true;
         }
         this.onEffectToAction();
      }
      
      private function onEnterSceneOver(event:MessageEvent) : void
      {
         ++this.enterCount;
         if(this.ischangSprite && event.body["sid"] == this.playerRole.roleInfo.sid)
         {
            this.ischangSprite = false;
         }
         if(this.isotherChangeSprite && event.body["sid"] == this.otherRole.roleInfo.sid)
         {
            this.isotherChangeSprite = false;
         }
         if(this.enterCount == 2)
         {
            if(Boolean(this._skillLook))
            {
               this._skillLook.visible = true;
            }
            this.battleViewMc.visible = true;
            dispatchEvent(new BattleEvent(BattleEvent.spiritsEnterOver));
         }
         if(GameData.instance.lookBattle == 1)
         {
            return;
         }
         if(this.enterCount > 1 && Boolean(this.battleControl))
         {
            if(!(this.isotherChangeSprite && this.playerRole.roleInfo.hp <= 0))
            {
               this.battleControl.changingSpirit = 0;
               if(!this.ischangSprite && this.playerRole && this.playerRole.roleInfo && event.currentTarget.roleInfo.uniqueid == this.playerRole.roleInfo.uniqueid || this.battleRoundEndInfo.length == 0)
               {
                  this.battleControl.oprationValue = this.oprationValue & this.initValue;
                  this.showCountTime(10);
               }
               else
               {
                  this.onBattleOprationStart();
               }
            }
            else
            {
               this.battleControl.changingSpirit = 0;
               this.myPlayOver = true;
               this.canOpration = true;
               this.onBattleOprationStart();
            }
         }
      }
      
      private function onOpenSite(event:BattleRoleEvent) : void
      {
         this.checkOpenSite();
      }
      
      private function onPlayerBeEffect(event:BattleRoleEvent) : void
      {
         var saywords:String = null;
         if(this.boobj && !this.effectview.playingEffect && !this._canOpration)
         {
            if(int(Math.random() * 10) < 3 && !this._battleObject.newbattle)
            {
               saywords = "<font color=\'#ffffff\' size=\'+7\'>" + this.saylanguage["say" + (int(Math.random() * 8) + 1)] + "</font>";
               LanguageItem.instance.say({
                  "playersay":saywords,
                  "othersay":""
               },this,300,130);
            }
            if(this.boobj.range == 0)
            {
               this.effectview.addeffect(null,SkillEffectDictory.instance.getEffect(this.boobj.effect));
            }
         }
      }
      
      private function onOtherBeEffect(event:BattleRoleEvent) : void
      {
         var saywords:String = null;
         if(this.boobj && !this.effectview.playingEffect && !this._canOpration)
         {
            if(int(Math.random() * 10) < 3 && !this._battleObject.newbattle)
            {
               saywords = "<font color=\'#ffffff\' size=\'+7\'>" + this.saylanguage["say" + (int(Math.random() * 8) + 1)] + "</font>";
               LanguageItem.instance.say({
                  "playersay":"",
                  "othersay":saywords
               },this,400,130);
            }
            if(this.boobj.range == 0)
            {
               this.effectview.addeffect(SkillEffectDictory.instance.getEffect(this.boobj.effect),null);
            }
         }
      }
      
      private function onEffectOver(event:Event) : void
      {
         this.onEffectToAction();
      }
      
      private function onActionToEffect() : void
      {
         if(Boolean(this.effectview) && this.effectview.playingEffect)
         {
            this.effectview.operationAfterEffect = true;
         }
         else
         {
            this.onPlayNextOpration();
         }
      }
      
      private function onEffectToAction() : void
      {
         if(Boolean(this.effectview))
         {
            if(this._canOpration && this.effectview.operationAfterEffect)
            {
               this.effectview.operationAfterEffect = false;
               this.onPlayNextOpration();
            }
            else if(this.usePPtoolbool)
            {
               this.usePPtoolbool = false;
               this.onPlayNextOpration();
            }
         }
      }
      
      public function clearCheck() : void
      {
         if(Boolean(this._checkTips))
         {
            if(Boolean(this._checkTips.parent))
            {
               this._checkTips.parent.removeChild(this._checkTips);
            }
         }
         if(this._checkTime != 0)
         {
            clearInterval(this._checkTime);
            this._checkTime = 0;
         }
      }
      
      public function showCheck() : void
      {
         if(this._checkTips == null)
         {
            this._checkTips = this.sourceLoader.getInstanceByBattleClass("checkTips") as Sprite;
         }
         this.battleViewMc.addChildAt(this._checkTips,this.battleViewMc.numChildren);
         this._checkNum = 120;
         this._checkTips["txtTime"]["text"] = this._checkNum + "s";
         this._checkTime = setInterval(function():void
         {
            --_checkNum;
            _checkTips["txtTime"]["text"] = _checkNum + "s";
            if(_checkNum == 0)
            {
               clearCheck();
            }
         },1000);
      }
      
      private function changeBattleRoleInfo(event:BattleRoleEvent) : void
      {
         var buf:Object = null;
         if(Boolean(this.dealbateinfo))
         {
            this.battleStatePanel.getStateData(this.dealbateinfo);
            this.dealbateinfo = null;
         }
         if(event != null && this.needbloodeffect)
         {
            this.bloodEffect(null);
         }
         for(var i:int = 0; i < this.currentBufArr.length; i++)
         {
            buf = this.currentBufArr[i];
            switch(buf.add_or_remove)
            {
               case BufData.BUF_TYPE_0:
                  this.spiritsInfoPanel.delBuf(buf);
                  break;
               case BufData.BUF_TYPE_1:
                  this.spiritsInfoPanel.addBuf(buf);
                  break;
               case BufData.BUF_TYPE_2:
                  this.spiritsInfoPanel.addBuf(buf);
                  if(this.DEALADD_BLOOD_1.indexOf(buf.bufid) != -1)
                  {
                     this.dealaddBlood(buf.defid,-buf.param1,false,new Point(100,86),2);
                  }
                  else if(this.DEALADD_BLOOD_2.indexOf(buf.bufid) != -1)
                  {
                     this.dealaddBlood(buf.defid,buf.param1,false,new Point(100,86));
                  }
            }
            if(this.currentBufArr.length == 0 && this.battleRoundEndInfo.length == 0 && this._canOpration)
            {
               this.onActionToEffect();
            }
         }
         this.currentBufArr.length = 0;
      }
      
      public function updateCode(str:String) : void
      {
         if(Boolean(this.boobj) && this.boobj.catchData)
         {
            this.boobj.catchData.CaptureCode = str;
         }
         if(Boolean(this._winpet))
         {
            this._winpet.updateCode(str);
         }
      }
      
      private function sucessPuzhuo(str:*) : void
      {
         this.puzhuovalue = 0;
         if(Boolean(this._winpet))
         {
            this._winpet = null;
         }
         if(!this.gameOver)
         {
            dispatchEvent(new BattleEvent(BattleEvent.battlePlayOver));
         }
      }
      
      private function bloodEffect(event:Event) : void
      {
         var ao:Object = null;
         var m:int = 0;
         var s:int = 0;
         this.needbloodeffect = false;
         var value:int = this.spiritsInfoPanel.playerHpChange(this.playerRole.roleInfo);
         var needmiss:Boolean = this.boobj.miss == 2 ? false : true;
         if(value != 100000000 && value != 0)
         {
            this.showBlood(value,this.effectview,true,needmiss,Boolean(this.boobj.brust));
         }
         var temp:int = this.spiritsInfoPanel.otherHpChange(this.otherRole.roleInfo);
         if(temp != 100000000 && temp != 0)
         {
            this.showBlood(temp,this.effectview,false,needmiss,Boolean(this.boobj.brust));
         }
         if(this.boobj.miss > 0 && event == null)
         {
            if(this.boobj.atkid == this.playerRole.roleInfo.sid)
            {
               this.showBlood(0,this.effectview,this.boobj.range == 2,needmiss,Boolean(this.boobj.brust));
            }
            else
            {
               this.showBlood(0,this.effectview,this.boobj.range != 2,needmiss,Boolean(this.boobj.brust));
            }
         }
         if(this.boobj.skillid == 529 || this.boobj.skillid == 723)
         {
            this.spiritsInfoPanel.delBadBuf(this.boobj.defid == this.playerRole.roleInfo.sid);
         }
         this.limitChange();
         this.spiritsInfoPanel.addblood(this.playerRole.roleInfo.hp,this.otherRole.roleInfo.hp);
         while(this.boobj.appendArr.length > 0)
         {
            ao = this.boobj.appendArr.shift();
            if(Boolean(ao.paramkey) && ao.paramkey == 1)
            {
               if(this.playerRole.roleInfo.sid == this.boobj.defid)
               {
                  for(m = 0; m < this.battleObject.mySpiritArr.length; m++)
                  {
                     if(this.battleObject.mySpiritArr[m].uniqueid == this.playerRole.roleInfo.uniqueid)
                     {
                        for(s = 0; s < this.battleObject.mySpiritArr[m].skillArr.length; s++)
                        {
                           if(ao.hasOwnProperty("skillid"))
                           {
                              if(this.battleObject.mySpiritArr[m].skillArr[s].skillid == ao.skillid)
                              {
                                 this.battleObject.mySpiritArr[m].skillArr[s].time -= ao.paramval;
                                 if(this.battleObject.mySpiritArr[m].skillArr[s].time < 0)
                                 {
                                    this.battleObject.mySpiritArr[m].skillArr[s].time = 0;
                                    break;
                                 }
                              }
                           }
                           else
                           {
                              this.battleObject.mySpiritArr[m].skillArr[s].time -= ao.paramval;
                              if(this.battleObject.mySpiritArr[m].skillArr[s].time < 0)
                              {
                                 this.battleObject.mySpiritArr[m].skillArr[s].time = 0;
                              }
                           }
                        }
                        this.playerRole.roleInfo.skillArr = this.battleObject.mySpiritArr[m].skillArr;
                        this.showBattleSkill();
                        break;
                     }
                  }
               }
               else if(Boolean(this._skillLook) && this.otherRole.roleInfo.sid == this.boobj.defid)
               {
                  for(m = 0; m < this.battleObject.otherArr.length; m++)
                  {
                     if(this.battleObject.otherArr[m].uniqueid == this.otherRole.roleInfo.uniqueid)
                     {
                        for(s = 0; s < this.battleObject.otherArr[m].skillArr.length; s++)
                        {
                           if(ao.hasOwnProperty("skillid"))
                           {
                              if(this.battleObject.otherArr[m].skillArr[s].skillid == ao.skillid)
                              {
                                 this.battleObject.otherArr[m].skillArr[s].time -= ao.paramval;
                                 if(this.battleObject.otherArr[m].skillArr[s].time < 0)
                                 {
                                    this.battleObject.otherArr[m].skillArr[s].time = 0;
                                    break;
                                 }
                              }
                           }
                           else
                           {
                              this.battleObject.otherArr[m].skillArr[s].time -= ao.paramval;
                              if(this.battleObject.otherArr[m].skillArr[s].time < 0)
                              {
                                 this.battleObject.otherArr[m].skillArr[s].time = 0;
                              }
                           }
                        }
                        this._skillLook.update(this._skillLook.curInfo.skillArr);
                        break;
                     }
                  }
               }
               if(Boolean(this.dealbateinfo))
               {
                  this.dealbateinfo.appendtxt = ",对方技能次数减少" + ao.paramval + "。";
               }
            }
            else if(Boolean(ao.paramkey) && ao.paramkey == 2)
            {
               if(Boolean(this.dealbateinfo))
               {
                  this.dealbateinfo.appendtxt = ",秒杀对方";
               }
            }
         }
      }
      
      public function battlebufs(obj:Object) : void
      {
         while(Boolean(obj.bufs) && obj.bufs.length > 0)
         {
            this.spiritsInfoPanel.addBuf(obj.bufs.shift());
         }
      }
      
      public function battleBufBlood(obj:Object) : void
      {
         var name:String = null;
         if(Boolean(this.otherRole) && Boolean(this.playerRole))
         {
            if(obj.defid == this.playerRole.roleInfo.sid)
            {
               name = this.playerRole.roleInfo.name;
               this.dealaddBlood(this.playerRole.roleInfo.sid,-int(obj.param1),false,null,2);
            }
            else
            {
               name = this.otherRole.roleInfo.name;
               this.dealaddBlood(this.otherRole.roleInfo.sid,-int(obj.param1),false,null,2);
            }
            this.battleStatePanel.getCounterattackDesc(obj.defid == this.playerRole.roleInfo.sid,name,obj.param1,obj);
         }
      }
      
      public function battleBufRecover(obj:Object) : void
      {
         var name:String = null;
         if(Boolean(this.otherRole) && Boolean(this.playerRole))
         {
            if(obj.defid == this.playerRole.roleInfo.sid)
            {
               name = this.playerRole.roleInfo.name;
               this.dealaddBlood(this.playerRole.roleInfo.sid,obj.param1,false,null,2);
            }
            else
            {
               name = this.otherRole.roleInfo.name;
               this.dealaddBlood(this.otherRole.roleInfo.sid,obj.param1,false,null,2);
            }
            this.battleStatePanel.getCounterattackDesc(obj.defid == this.playerRole.roleInfo.sid,name,obj.param1,obj);
         }
      }
      
      public function battleBuf(buf:BufData) : void
      {
         if(this.chufaBuf == null)
         {
            this.chufaBuf = [];
         }
         if(BufData.ROUND_START_ADD.indexOf(buf.bufid) != -1)
         {
            if(this.starBuf.length < 1)
            {
               this.starBuf.push([]);
            }
            this.starBuf[this.starBuf.length - 1].push(buf);
         }
         else
         {
            this.chufaBuf.push(buf);
         }
         if(this._canOpration && this.battleRoundEndInfo.length == 0)
         {
            this.dealBattleBuf();
         }
      }
      
      public function battleBufDis(obj:Object) : void
      {
         this.delBuf.push(obj);
         if(this._canOpration && this.battleRoundEndInfo.length == 0)
         {
            while(this.delBuf.length > 0)
            {
               obj = this.delBuf.shift();
               this.spiritsInfoPanel.delBuf(obj);
            }
         }
      }
      
      private function dealStartBattleBuf() : void
      {
         this.triggerBuf(this.starBuf[0]);
         this.onPlayNextOpration();
      }
      
      private function dealBattleBuf(value:Boolean = false) : void
      {
         var obj:Object = null;
         this.triggerBuf(this.chufaBuf);
         while(this.delBuf.length > 0)
         {
            obj = this.delBuf.shift();
            this.spiritsInfoPanel.delBuf(obj);
         }
         if(value)
         {
            this.onPlayNextOpration();
         }
      }
      
      private function triggerBuf(ary:Array) : void
      {
         var obj:Object = null;
         if(!ary || ary.length == 0)
         {
            return;
         }
         var len:int = int(ary.length);
         for(var i:int = 0; i < len; i++)
         {
            obj = ary[i];
            switch(obj.add_or_remove)
            {
               case BufData.BUF_TYPE_1:
                  this.spiritsInfoPanel.addBuf(obj);
                  break;
               case BufData.BUF_TYPE_2:
                  this.handleBloodBuf(obj);
                  break;
               case BufData.BUF_TYPE_3:
                  this.handlePPChange(obj,-int(obj.param1));
                  break;
               case BufData.BUF_TYPE_6:
                  this.handlePPChange(obj,obj.param1);
            }
            this.spiritsInfoPanel.addBuf(obj);
         }
         ary.length = 0;
      }
      
      private function handleBloodBuf(obj:Object) : void
      {
         var targetSid:int = 0;
         if(this.DEALADD_BLOOD_1.indexOf(obj.bufid) != -1)
         {
            this.dealaddBlood(obj.defid,-int(obj.param1),false,null,2);
            if(obj.bufid == 33 && this.otherRole && Boolean(this.playerRole))
            {
               targetSid = obj.defid == this.playerRole.roleInfo.sid ? this.otherRole.roleInfo.sid : this.playerRole.roleInfo.sid;
               this.dealaddBlood(targetSid,obj.param2);
            }
         }
         else if(this.DEALADD_BLOOD_2.indexOf(obj.bufid) != -1)
         {
            this.dealaddBlood(obj.defid,obj.param1);
         }
      }
      
      private function handlePPChange(obj:Object, delta:int) : void
      {
         var skills:Array = null;
         var j:int = 0;
         if(!this.playerRole || this.playerRole.roleInfo.sid != obj.defid)
         {
            return;
         }
         var spirits:Array = this.battleObject.mySpiritArr;
         var uid:int = this.playerRole.roleInfo.uniqueid;
         for(var i:int = 0; i < spirits.length; i++)
         {
            if(spirits[i].uniqueid == uid)
            {
               skills = spirits[i].skillArr;
               for(j = 0; j < skills.length; j++)
               {
                  skills[j].time += delta;
                  if(skills[j].time < 0)
                  {
                     skills[j].time = 0;
                  }
                  if(skills[j].time > skills[j].maxtime)
                  {
                     skills[j].time = skills[j].maxtime;
                  }
               }
               this.playerRole.roleInfo.skillArr = skills;
               this.showBattleSkill();
               return;
            }
         }
      }
      
      private function startShow() : void
      {
         if(this.battleViewMc && this.playerRole && this.otherRole && !this.clearbattle)
         {
            this.allSourceOk();
         }
      }
      
      private function allSourceOk() : void
      {
         dispatchEvent(new BattleEvent(BattleEvent.showBattle));
         if(GameData.instance.lookBattle != 1)
         {
            if(this._battleObject && !this._battleObject.newbattle && Boolean(this.countTime))
            {
               this.countTime.gotoAndStop(12);
               this.countTime.visible = true;
            }
            if(Boolean(this.btnControl))
            {
               this.btnControl.changState(0,false);
            }
            if(Boolean(this.battleControl))
            {
               this.battleControl.setfilters(null);
            }
         }
         else if(GameData.instance.newLookType != 2)
         {
            this.startTime(10);
         }
      }
      
      private function onCanOpration(event:BattleRoleEvent) : void
      {
         var body:Object = event.data;
         if(body && body.hasOwnProperty("key") && body["key"] == BattleRoleEvent.enterSceneOver)
         {
            if(this.isotherChangeSprite || this.ischangSprite)
            {
               return;
            }
         }
         this.canOpration = true;
         this.onActionToEffect();
      }
      
      public function get canOpration() : Boolean
      {
         return this._canOpration;
      }
      
      public function set canOpration(value:Boolean) : void
      {
         this._canOpration = value;
      }
      
      public function set battleRoundOpration(value:BattleOpration) : void
      {
         var obj:Object = null;
         var batedata:Object = null;
         while(this.battleRoundEndInfo.length > 3)
         {
            obj = this.battleRoundEndInfo.shift();
            if(obj.skillid != 0)
            {
               if(this.playerRole.roleInfo.sid == obj.atkid)
               {
                  this.playerRole.roleInfo.hp = obj.atk_hp;
               }
               if(this.playerRole.roleInfo.sid == obj.defid)
               {
                  this.playerRole.roleInfo.hp = obj.def_hp;
               }
               if(this.otherRole.roleInfo.sid == obj.atkid)
               {
                  this.otherRole.roleInfo.hp = obj.atk_hp;
               }
               if(this.otherRole.roleInfo.sid == obj.defid)
               {
                  this.otherRole.roleInfo.hp = obj.def_hp;
               }
               this.spiritsInfoPanel.setResult(this.playerRole.roleInfo,this.otherRole.roleInfo);
            }
            batedata = {};
            batedata.skillid = obj.skillid;
            batedata.defid = obj.defid;
            batedata.brust = obj.brust;
            batedata.miss = obj.miss;
            batedata.bufArr = obj.bufArr;
            batedata.isM = this.playerRole.roleInfo.sid == obj.atkid ? true : false;
            batedata.atkid = Boolean(batedata.isM) ? this.playerRole.roleInfo.name : this.otherRole.roleInfo.name;
            batedata.defid = batedata.defid == this.playerRole.roleInfo.sid ? this.playerRole.roleInfo.name : this.otherRole.roleInfo.name;
            this.battleStatePanel.getStateData(batedata);
         }
         this.battleRoundEndInfo.push(value);
         this.starBuf.push([]);
         this.onBattleOprationStart();
      }
      
      public function get canPlayNextOpration() : Boolean
      {
         return this._canPlayNextOpration;
      }
      
      public function onBattleOprationStart() : void
      {
         if(this._canOpration && this.effectview && !this.effectview.playingEffect)
         {
            if(this.battleRoundEndInfo.length == 0)
            {
               this.showCountTime(10);
               return;
            }
            this.myPlayOver = false;
            this.boobj = this.battleRoundEndInfo.shift();
            this.stopTime();
            switch(this.boobj.cmdtype)
            {
               case 0:
                  this.dealBattle();
                  break;
               case 1:
                  if(GameData.instance.lookBattle != 1)
                  {
                     this.battleControl.changingSpirit = 1;
                  }
                  this.dealChangeSpirit();
                  break;
               case 2:
                  this.dealToolUse();
                  break;
               case 3:
                  dispatchEvent(new BattleEvent(BattleEvent.battlePlayOver));
                  break;
               default:
                  this.myPlayOver = true;
            }
         }
      }
      
      private function dealBattle() : void
      {
         var xml:XML = null;
         var ps:int = 0;
         var s:int = 0;
         var skill:Object = null;
         this.canBattle = false;
         if(Boolean(this.boobj) && this.boobj.haveBattle == 1)
         {
            if(this.boobj.skillid == 0)
            {
               this.onPlayNextOpration();
               return;
            }
            this.canOpration = false;
            this.dealbateinfo = {};
            xml = XMLLocator.getInstance().getSkill(this.boobj.skillid);
            this.boobj.skilltype = xml.skilltype;
            this.boobj.range = xml.range;
            this.boobj.effect = xml.effect;
            this.playerRole.roleInfo.skillId = this.boobj.skillid;
            this.otherRole.roleInfo.skillId = this.boobj.skillid;
            this.currentBufArr = this.currentBufArr.concat(this.boobj.bufArr);
            this.dealbateinfo.skillSid = this.boobj.atkid;
            if(this.playerRole.roleInfo.sid == this.boobj.atkid)
            {
               if(this.boobj.range == 2)
               {
                  this.playerRole.selfSkill();
                  this.effectview.addeffect(null,SkillEffectDictory.instance.getEffect(this.boobj.effect));
               }
               else if(this.boobj.skilltype == 0)
               {
                  this.playerRole.spiritPhyBattle(this.otherRole,this.boobj.miss);
               }
               else
               {
                  this.playerRole.spiritSkiBattle(this.otherRole,this.boobj.miss);
               }
               if(BattleViewManager.getInstance().monView.getChildIndex(this.playerRole) < BattleViewManager.getInstance().monView.getChildIndex(this.otherRole))
               {
                  BattleViewManager.getInstance().monView.swapChildren(this.playerRole,this.otherRole);
               }
               ps = this.preskill == 0 ? this.boobj.skillid : this.preskill;
               for(s = 0; s < this.playerRole.roleInfo.skillArr.length; s++)
               {
                  if(this.playerRole.roleInfo.skillArr[s].skillid == ps)
                  {
                     if(this.playerRole.roleInfo.skillArr[s].time > 0)
                     {
                        --this.playerRole.roleInfo.skillArr[s].time;
                        if(this.checkPPBuf(true) && this.playerRole.roleInfo.skillArr[s].time > 0)
                        {
                           --this.playerRole.roleInfo.skillArr[s].time;
                        }
                        if(GameData.instance.lookBattle != 1 || GameData.instance.newLookType == 2)
                        {
                           this.battleControl.changeSkillTime(this.playerRole.roleInfo.skillArr);
                        }
                     }
                  }
               }
               this.preskill = 0;
               this.dealbateinfo.isM = true;
               this.dealbateinfo.atkid = this.playerRole.roleInfo.name;
               this.dealbateinfo.defid = this.boobj.range == 2 ? this.playerRole.roleInfo.name : this.otherRole.roleInfo.name;
            }
            else if(this.otherRole.roleInfo.sid == this.boobj.atkid)
            {
               if(this.boobj.range == 2)
               {
                  this.otherRole.selfSkill();
                  this.effectview.addeffect(SkillEffectDictory.instance.getEffect(this.boobj.effect),null);
               }
               else if(this.boobj.skilltype == 0)
               {
                  this.otherRole.spiritPhyBattle(this.playerRole,this.boobj.miss);
               }
               else
               {
                  this.otherRole.spiritSkiBattle(this.playerRole,this.boobj.miss);
               }
               if(BattleViewManager.getInstance().monView.getChildIndex(this.otherRole) < BattleViewManager.getInstance().monView.getChildIndex(this.playerRole))
               {
                  BattleViewManager.getInstance().monView.swapChildren(this.otherRole,this.playerRole);
               }
               if(Boolean(this._skillLook))
               {
                  for each(skill in this._skillLook.curInfo.skillArr)
                  {
                     if(skill.skillid == this.boobj.skillid)
                     {
                        if(skill.time > 0)
                        {
                           --skill.time;
                           if(this.checkPPBuf(false) && skill.time > 0)
                           {
                              --skill.time;
                           }
                        }
                     }
                  }
                  this._skillLook.update(this._skillLook.curInfo.skillArr);
               }
               this.dealbateinfo.isM = false;
               this.dealbateinfo.atkid = this.otherRole.roleInfo.name;
               this.dealbateinfo.defid = this.boobj.range == 2 ? this.otherRole.roleInfo.name : this.playerRole.roleInfo.name;
            }
            else
            {
               this.canOpration = true;
            }
            if(this.boobj.miss == 0)
            {
               if(this.playerRole.roleInfo.sid == this.boobj.atkid)
               {
                  this.playerRole.roleInfo.hp = this.boobj.atk_hp;
               }
               if(this.playerRole.roleInfo.sid == this.boobj.defid)
               {
                  this.playerRole.roleInfo.hp = this.boobj.def_hp;
               }
               if(this.otherRole.roleInfo.sid == this.boobj.atkid)
               {
                  this.otherRole.roleInfo.hp = this.boobj.atk_hp;
               }
               if(this.otherRole.roleInfo.sid == this.boobj.defid)
               {
                  this.otherRole.roleInfo.hp = this.boobj.def_hp;
               }
            }
            this.needbloodeffect = true;
            this.dealbateinfo.mhp = this.spiritsInfoPanel.playerHpChange(this.playerRole.roleInfo);
            this.dealbateinfo.ohp = this.spiritsInfoPanel.otherHpChange(this.otherRole.roleInfo);
            this.dealbateinfo.skillid = this.boobj.skillid;
            this.dealbateinfo.brust = this.boobj.brust;
            this.dealbateinfo.miss = this.boobj.miss;
            this.dealbateinfo.bufArr = this.boobj.bufArr;
         }
      }
      
      private function checkPPBuf(isPlayer:Boolean) : Boolean
      {
         var bufIcon:BufIcon = null;
         var ary:Vector.<BufIcon> = this.spiritsInfoPanel.getBuf(isPlayer);
         if(Boolean(ary))
         {
            for each(bufIcon in ary)
            {
               if(bufIcon.bufid == 76)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      private function toolCanUse() : void
      {
         this.toolControl.canTool = Boolean(this.oprationValue & this.initValue & 0x010000);
         this.toolControl.catchType = this.otherRole.roleInfo.catchType;
      }
      
      private function dealToolUse() : void
      {
         var un:String = null;
         var m:int = 0;
         var s:int = 0;
         var success:Boolean = true;
         if(Boolean(this.bloodTool[this.boobj.itemid]))
         {
            this.dealaddBlood(this.boobj.defid,this.boobj.param0,true);
            un = this.boobj.defid == this.playerRole.roleInfo.sid ? this.playerRole.roleInfo.name : this.otherRole.roleInfo.name;
            this.battleStatePanel.getUseToolInfo({
               "sid":un,
               "toolid":this.boobj.itemid
            });
         }
         else if(BitValueUtil.getToolBitValue(this.boobj.itemid,6))
         {
            this.canOpration = false;
            if(this.boobj.param0 == 2)
            {
               success = false;
               new BattleAlert(this,"\t\t<font color=\'#000000\' size=\'16\'>你的妖怪背包和仓库装不下妖怪了!</font>");
            }
            if(this.boobj.param0 == 1)
            {
               this.puzhuovalue = 1;
               this.effectview.successCatchEffect();
            }
            else
            {
               this.puzhuovalue = 2;
               this.effectview.failCatchEffect();
            }
         }
         else if(this.boobj.itemid == 100011 || this.boobj.itemid == 100010 || this.boobj.itemid == 100012 || this.boobj.itemid == 100009 || this.boobj.itemid == 100181)
         {
            if(this.boobj.atkid == this.playerRole.roleInfo.sid)
            {
               for(m = 0; m < this.battleObject.mySpiritArr.length; m++)
               {
                  if(this.battleObject.mySpiritArr[m].uniqueid == this.playerRole.roleInfo.uniqueid)
                  {
                     for(s = 0; s < this.battleObject.mySpiritArr[m].skillArr.length; s++)
                     {
                        this.battleObject.mySpiritArr[m].skillArr[s].time += this.boobj.param0;
                        if(this.boobj.itemid == 100009 || this.battleObject.mySpiritArr[m].skillArr[s].time > this.battleObject.mySpiritArr[m].skillArr[s].maxtime)
                        {
                           this.battleObject.mySpiritArr[m].skillArr[s].time = this.battleObject.mySpiritArr[m].skillArr[s].maxtime;
                        }
                     }
                     this.playerRole.roleInfo.skillArr = this.battleObject.mySpiritArr[m].skillArr;
                     this.showBattleSkill();
                     this.showBlood(this.boobj.param0,this.effectview,true,false,false,true);
                     this.effectview.addBlueEffect(true);
                     break;
                  }
               }
               this.usePPtoolbool = true;
               this.battleStatePanel.getUseToolInfo({
                  "sid":this.playerRole.roleInfo.name,
                  "toolid":this.boobj.itemid
               });
            }
            else if(this.boobj.atkid == this.otherRole.roleInfo.sid)
            {
               this.usePPtoolbool = true;
               this.showBlood(this.boobj.param0,this.effectview,false,false,false,true);
               this.effectview.addBlueEffect(false);
               this.battleStatePanel.getUseToolInfo({
                  "sid":this.otherRole.roleInfo.name,
                  "toolid":this.boobj.itemid
               });
            }
         }
         else if(this.boobj.atkid == this.playerRole.roleInfo.sid && this.boobj.itemid == 100224)
         {
            if(this.boobj.param0 == 1)
            {
               this.spiritsInfoPanel.toolshowinfo = true;
            }
            else
            {
               success = false;
               new BattleAlert(this,"<font color=\'#000000\' size=\'16\'>不能使用这个道具!</font>");
            }
         }
         if(this.boobj.atkid == this.playerRole.roleInfo.sid && GameData.instance.lookBattle != 1)
         {
            this.toolCanUse();
            this.toolControl.useToolBack(this.boobj.itemid,this.boobj.param0,success);
         }
         this.myPlayOver = true;
      }
      
      private function onSpiritDieOut(event:Event) : void
      {
         this.otherRole.spiritOut(true);
         this._siteView.updateMonster(0,1);
      }
      
      private function onSpiritLiveOut(event:Event) : void
      {
         this.otherRole.spiritOut(false);
         this._siteView.updateMonster(0,1);
      }
      
      private function dealaddBlood(sid:int, bloodvalue:int, haveeffect:Boolean = false, op:Point = null, compBrust:int = 0) : void
      {
         var needBrust:Boolean = false;
         var needmiss:Boolean = this.boobj == null || this.boobj.miss == 2 ? false : true;
         switch(compBrust)
         {
            case 1:
               needBrust = true;
               break;
            case 2:
               needBrust = false;
               break;
            default:
               needBrust = this.boobj == null || this.boobj.brust == 0 ? false : true;
         }
         if(sid == this.playerRole.roleInfo.sid)
         {
            if(bloodvalue > 0)
            {
               this.playerRole.addBlood();
            }
            if(Math.abs(bloodvalue) != 0 || needmiss)
            {
               this.showBlood(bloodvalue,this.effectview,true,needmiss,needBrust,false,op);
            }
            this.playerRole.roleInfo.hp += bloodvalue;
            if(haveeffect)
            {
               this.effectview.addBloodEffect(true);
            }
         }
         else
         {
            if(bloodvalue > 0)
            {
               this.otherRole.addBlood();
            }
            if(Math.abs(bloodvalue) != 0 || needmiss)
            {
               this.showBlood(bloodvalue,this.effectview,false,needmiss,needBrust,false,op);
            }
            if(haveeffect)
            {
               this.effectview.addBloodEffect();
            }
            this.otherRole.roleInfo.hp += bloodvalue;
         }
         this.limitChange();
         this.spiritsInfoPanel.addblood(this.playerRole.roleInfo.hp,this.otherRole.roleInfo.hp);
      }
      
      private function dealChangeSpirit() : void
      {
         var i:int = 0;
         var b:Boolean = false;
         this.canOpration = false;
         if(this.playerRole.roleInfo.sid == this.boobj.sid)
         {
            if(this.playerRole.roleInfo.hp > 0)
            {
               this.stopTime();
               this.ischangSprite = true;
            }
            else
            {
               this.ischangSprite = false;
               this.showCountTime(10);
            }
            if(Boolean(this.playerRole.parent))
            {
               this.playerRole.parent.removeChild(this.playerRole);
            }
            for(i = 0; i < this.playerRoleArr.length; i++)
            {
               if(this.playerRoleArr[i].roleInfo.uniqueid == this.boobj.uniqueid)
               {
                  this.playerRole.roleInfo.state = 0;
                  this.playerRole.roleInfo.bufArr = [];
                  this.playerRoleArr[i].roleInfo.state = 1;
                  this.playerRole = null;
                  this.playerRole = this.playerRoleArr[i];
                  b = true;
                  break;
               }
            }
         }
         else if(this.otherRole.roleInfo.sid == this.boobj.sid)
         {
            this.isotherChangeSprite = true;
            if(Boolean(this.otherRole) && Boolean(this.otherRole.parent))
            {
               this.otherRole.parent.removeChild(this.otherRole);
            }
            for(i = 0; i < this.otherRoleArr.length; i++)
            {
               if(this.otherRoleArr[i].roleInfo.uniqueid == this.boobj.uniqueid)
               {
                  this.otherRole = null;
                  this.otherRole = this.otherRoleArr[i];
                  b = true;
                  break;
               }
            }
         }
         if(b)
         {
            this.addBattleRole(true);
         }
         else if(Boolean(this._newData))
         {
            this.singleLoad(this._newData,false);
         }
      }
      
      private function onPlayNextOpration() : void
      {
         var over:Function;
         var hp:int = 0;
         var i:int = 0;
         var temptid:int = 0;
         if(this._canPlayNextOpration && this._canOpration)
         {
            this._canPlayNextOpration = false;
            this.checkOpenSite();
            if(Boolean(this.starBuf) && this.starBuf.length > 0)
            {
               if(this.starBuf[0].length > 0)
               {
                  this._canPlayNextOpration = true;
                  this.dealStartBattleBuf();
                  return;
               }
               this.starBuf.shift();
            }
            if(this.battleRoundEndInfo.length > 0)
            {
               this.onBattleOprationStart();
            }
            else
            {
               if(this.delBuf && this.delBuf.length > 0 || this.chufaBuf && this.chufaBuf.length > 0)
               {
                  this._canPlayNextOpration = true;
                  this.dealBattleBuf(true);
                  if(this.battleRoundEndInfo.length == 0)
                  {
                     this.checkSite();
                  }
                  return;
               }
               if(this.battleRoundEndInfo.length == 0)
               {
                  hp = 0;
                  for(i = 0; i < this.battleObject.mySpiritArr.length; i++)
                  {
                     hp += this.battleObject.mySpiritArr[i].hp;
                  }
                  if(hp <= 0 || this.otherRole && this.otherRole.roleInfo.hp <= 0)
                  {
                     over = function():void
                     {
                        clearTimeout(temptid);
                        if(Boolean(playerRole) && Boolean(otherRole))
                        {
                           battlefinish();
                        }
                     };
                     temptid = int(setTimeout(over,800));
                  }
                  else if(this.puzhuovalue == 0)
                  {
                     this.myPlayOver = true;
                     dispatchEvent(new BattleEvent(BattleEvent.battlePlayOver));
                  }
                  this.checkSite();
               }
            }
            this._canPlayNextOpration = true;
         }
      }
      
      private function checkOpenSite() : void
      {
         var addSite:Object = null;
         var td:SiteBuffTypeData = null;
         if(this._siteData.length > 0)
         {
            if(this.boobj && this.boobj["cmdtype"] == 0 && this._siteData[0]["params"] == BufData.COMBAT_SITE_ADD)
            {
               if(this.boobj["atkid"] == this._siteData[0]["sn"])
               {
                  addSite = this._siteData.shift();
                  td = this._siteView.getCurSite();
                  if(td == null || td.id != addSite["id"])
                  {
                     this._siteView.addSite(addSite["id"]);
                     if(this._siteView.getCurSite() != null)
                     {
                        this.loadSiteBG(this._siteView.getCurSite());
                     }
                     this.spiritsInfoPanel.updateBuf();
                  }
                  this.battleStatePanel.getSiteData(addSite);
               }
            }
         }
      }
      
      private function checkSite() : void
      {
         var site:Object = null;
         var errorIndex:int = 0;
         while(this._siteData.length > 0 && errorIndex < 20)
         {
            site = this._siteData.shift();
            switch(site["params"])
            {
               case BufData.COMBAT_SITE_MD:
                  this.battleStatePanel.getSiteData(site);
                  break;
               case BufData.COMBAT_SITE_DEL:
                  this.battleStatePanel.getSiteData(site);
                  this._siteView.removeSite(site["id"]);
                  this.spiritsInfoPanel.updateBuf();
                  TweenLite.to(this._bitmaps[1],1,{"alpha":0});
            }
            errorIndex++;
         }
         if(errorIndex >= 20)
         {
            this._siteData = [];
         }
      }
      
      public function canalerwin() : Boolean
      {
         if(Boolean(this.playerRole) && Boolean(this.otherRole))
         {
            if(this.battleRoundEndInfo.length == 0 && this.currentBufArr.length == 0 && this.chufaBuf.length == 0 && (this.playerRole.mclabel() || this.otherRole.mclabel()) && this.puzhuovalue != 1)
            {
               return true;
            }
            return false;
         }
         return false;
      }
      
      private function startTime(value:int) : void
      {
         this.stopTime();
         if(Boolean(this.countTime))
         {
            this.countTime.visible = true;
         }
         this.mytimer = new Timer(1000,value);
         this.mytimer.addEventListener(TimerEvent.TIMER,this.onTime);
         this.mytimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimeComp);
         this.mytimer.start();
      }
      
      public function stopTime() : void
      {
         if(Boolean(this.mytimer))
         {
            if(Boolean(this.countTime))
            {
               this.countTime.visible = false;
            }
            this.mytimer.removeEventListener(TimerEvent.TIMER,this.onTime);
            this.mytimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTimeComp);
            this.mytimer.stop();
            this.mytimer = null;
         }
      }
      
      private function onTime(event:TimerEvent) : void
      {
         if(Boolean(this.countTime))
         {
            if(this.countTime.currentFrame < 11)
            {
               this.countTime.nextFrame();
            }
         }
         if(this.countTime.currentFrame == 10)
         {
            if(GameData.instance.lookBattle != 1)
            {
               this.canBattle = false;
               if(!this.canBattle || this.gameOver)
               {
                  this.btnControl.changState(0,false);
               }
               this.battleControl.setfilters(null);
               this.spiritControl.setfilters();
            }
         }
      }
      
      private function onTimeComp(event:TimerEvent) : void
      {
         if(Boolean(this.countTime))
         {
            this.countTime.gotoAndStop(11);
         }
         this.canBattle = false;
         this.stopTime();
         this.preskill = 0;
      }
      
      public function get canBattle() : Boolean
      {
         return this._canBattle;
      }
      
      public function set canBattle(value:Boolean) : void
      {
         if(GameData.instance.newLookType != 2)
         {
            if(Boolean(this.battleControl))
            {
               this.btnControl.canBattle = value;
               this.battleControl.canBattle = value;
               this.toolControl.canBattle = value;
            }
            this._canBattle = value;
         }
      }
      
      public function showCountTime(value:Object) : void
      {
         this.startTime(int(value));
         this.countTime.visible = true;
         this.countTime.gotoAndStop(Math.min(1,10 - int(value)));
         if(Boolean(this.otherRole) && this.otherRole.roleInfo.hp > 0)
         {
            this.canBattle = true;
            if(!GameData.instance.playerData.isAutoBattle && GameData.instance.lookBattle != 1)
            {
               this.btnControl.signId = 0;
               this.btnControl.changState(this.oprationValue & this.initValue,true);
               this.battleControl.updataFilters();
               this.spiritControl.removefilters();
               this.toolControl.removefilters();
            }
         }
      }
      
      public function setBattleSkillFilters() : void
      {
         if(GameData.instance.lookBattle != 1)
         {
            if(this.playerRole.roleInfo.hp > 0 && !GameData.instance.playerData.isAutoBattle)
            {
               this.battleControl.oprationValue = this.oprationValue & this.initValue;
               this.battleControl.updataFilters();
            }
         }
         if(this.playerRole.roleInfo.hp == 0)
         {
            this.playerRole.spiritFail(false);
         }
         if(this.otherRole.roleInfo.hp == 0)
         {
            this.otherRole.spiritFail(false);
         }
         if(this.playerRole.roleInfo.hp <= 0)
         {
            if(!GameData.instance.playerData.isAutoBattle)
            {
               this.showControlBar(16);
            }
            this.spiritControl.setSpiritArr(this.battleObject.mySpiritArr);
            if(GameData.instance.playerData.isAutoBattle)
            {
               ApplicationFacade.getInstance().dispatch(EventConst.AUTOBATTLE_SPIRIT_DIE);
            }
         }
         if(!this.gameOver && !GameData.instance.playerData.isAutoBattle)
         {
            this.btnControl.changState(this.oprationValue & this.initValue,true);
         }
      }
      
      public function spiritname(id:int) : String
      {
         return String(SpiritXmlData.spirititem(id.toString()).name);
      }
      
      public function killMonsterId() : int
      {
         if(Boolean(this.otherRole) && Boolean(this.otherRole.roleInfo))
         {
            return this.otherRole.roleInfo.spiritid;
         }
         return 0;
      }
      
      public function battlefinish() : void
      {
         try
         {
            if(this._canOpration && Boolean(this.playerRole))
            {
               if(this.playerwin && !this.otherrun)
               {
                  this.playerRole.spiritWin();
                  if(this.puzhuovalue != 1 && Boolean(this.otherRole))
                  {
                     this.otherRole.spiritFail();
                  }
                  this.playerwin = this.otherwin = false;
               }
               else if(this.otherwin && !this.otherrun)
               {
                  this.playerRole.spiritFail(false);
                  if(Boolean(this.otherRole))
                  {
                     this.otherRole.spiritWin();
                  }
                  this.playerwin = this.otherwin = false;
               }
               else if(this.otherrun && Boolean(this.otherRole))
               {
                  this.otherRole.spiritOut(true,false);
                  this._siteView.updateMonster(0,1);
               }
            }
         }
         catch(e:*)
         {
            new Alert().show("请联系客服，错误:" + playerRole + otherRole + "!");
         }
         this.myPlayOver = true;
         dispatchEvent(new BattleEvent(BattleEvent.battlePlayOver));
      }
      
      public function updateSite(obj:Object) : void
      {
         switch(obj.params)
         {
            case BufData.COMBAT_SITE_ADD:
               this._siteData.push(obj);
               break;
            case BufData.COMBAT_SITE_MD:
               this._siteData.push(obj);
               break;
            case BufData.COMBAT_SITE_DEL:
               this._siteData.push(obj);
         }
      }
      
      private function loadSiteBG(td:SiteBuffTypeData) : void
      {
         if(this._siteLoad == null)
         {
            this._siteLoad = new Loader();
            this._siteLoad.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onSiteComplete);
         }
         var request:URLRequest = new URLRequest(td.bg_url);
         this._siteLoad.load(request);
      }
      
      private function onSiteComplete(event:Event) : void
      {
         var bit:Bitmap = event.target.content as Bitmap;
         this._bitmaps[1].bitmapData = bit.bitmapData;
         this._bitmaps[1].alpha = 0;
         TweenLite.to(this._bitmaps[1],1,{"alpha":1});
      }
      
      private function limitChange() : void
      {
         if(this.playerRole.roleInfo.hp > this.playerRole.roleInfo.maxhp)
         {
            this.playerRole.roleInfo.hp = this.playerRole.roleInfo.maxhp;
         }
         if(this.playerRole.roleInfo.hp < 0)
         {
            this.playerRole.roleInfo.hp = 0;
         }
         if(this.otherRole.roleInfo.hp > this.otherRole.roleInfo.maxhp)
         {
            this.otherRole.roleInfo.hp = this.otherRole.roleInfo.maxhp;
         }
         if(this.otherRole.roleInfo.hp < 0)
         {
            this.otherRole.roleInfo.hp = 0;
         }
      }
      
      private function disposeBitmaps() : void
      {
         var bmp:Bitmap = null;
         for each(bmp in this._bitmaps)
         {
            if(Boolean(bmp) && Boolean(bmp.bitmapData))
            {
               bmp.bitmapData.dispose();
            }
         }
         this._bitmaps.length = 0;
      }
      
      public function destroy() : void
      {
         var i:int = 0;
         BattleBloodMcPool.instance.clear();
         this.disposeBitmaps();
         if(Boolean(this._siteView))
         {
            this._siteView.dispose();
            this._siteView = null;
         }
         if(Boolean(this._skillLook))
         {
            this._skillLook.disose();
            this._skillLook = null;
         }
         if(Boolean(this._loadTime))
         {
            this._loadTime.stop();
            this._loadTime.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onLoadComplete);
         }
         this.clearbattle = true;
         this.removeEventListener(Event.ADDED_TO_STAGE,this.onAddToStageHandler);
         if(Boolean(this.effectview))
         {
            this.effectview.removeEventListener(EffectView.CATCHEFFECTOVER,this.onCatchOverHandler);
            this.effectview.removeEventListener(EffectView.ENTEREFFECTOVER,this.onEnterEffectOver);
            this.effectview.removeEventListener(EffectView.EFFECTPLAYOVER,this.onEffectOver);
            this.effectview.removeEventListener(EffectView.SPIRITDIEOUT,this.onSpiritDieOut);
            this.effectview.removeEventListener(EffectView.SPIRITLIVEOUT,this.onSpiritLiveOut);
            if(BattleViewManager.getInstance().monView.contains(this.effectview))
            {
               BattleViewManager.getInstance().monView.removeChild(this.effectview);
            }
            this.effectview.destroy();
            this.effectview = null;
         }
         SkillEffectDictory.instance.removeEventListener(SkillEffectDictory.SKILLEFFECTOK,this.onSkillEffectOk);
         SkillEffectDictory.instance.removeEventListener(SkillEffectDictory.LOADPROGRESS,this.onSkillEffectProgress);
         if(Boolean(this.spiritsInfoPanel))
         {
            if(this.spiritsInfoPanel.hasEventListener(BattleEvent.BATTLE_CONTROL_CLICK_EVENT))
            {
               this.spiritsInfoPanel.removeEventListener(BattleEvent.BATTLE_CONTROL_CLICK_EVENT,this.onSpiritControlClick);
            }
            this.spiritsInfoPanel.destroy();
            this.spiritsInfoPanel = null;
         }
         if(Boolean(this.battleStatePanel))
         {
            this.battleStatePanel.destroy();
            this.battleStatePanel = null;
         }
         if(Boolean(this.spiritControl))
         {
            if(this.spiritControl.hasEventListener(BattleEvent.SPIRIT_CONTROL_CLICK_EVENT))
            {
               this.spiritControl.removeEventListener(BattleEvent.SPIRIT_CONTROL_CLICK_EVENT,this.onSpiritControlClick);
            }
            this.spiritControl.destroy();
            this.spiritControl = null;
         }
         if(Boolean(this.toolControl))
         {
            if(this.toolControl.hasEventListener(BattleEvent.BATTLE_USE_TOOL))
            {
               this.toolControl.removeEventListener(BattleEvent.BATTLE_USE_TOOL,this.onBattleUseToolClick);
            }
            this.toolControl.destroy();
            this.toolControl = null;
         }
         if(Boolean(this.battleControl))
         {
            if(this.battleControl.hasEventListener(BattleEvent.BATTLE_CONTROL_CLICK_EVENT))
            {
               this.battleControl.removeEventListener(BattleEvent.BATTLE_CONTROL_CLICK_EVENT,this.onBattleControlClick);
            }
            this.battleControl.destroy();
            this.battleControl = null;
         }
         if(Boolean(this.btnControl))
         {
            if(this.btnControl.hasEventListener(BattleEvent.PANEL_CLICK_EVENT))
            {
               this.btnControl.removeEventListener(BattleEvent.PANEL_CLICK_EVENT,this.onBtnControlClick);
            }
            this.btnControl.destroy();
            this.btnControl = null;
         }
         if(Boolean(this.battleViewMc) && Boolean(this.battleViewMc.hasOwnProperty("cancelAutoBtn")))
         {
            this.battleViewMc["cancelAutoBtn"].removeEventListener(MouseEvent.CLICK,this.onClickCancelAutoBattle);
         }
         while(Boolean(this.battleViewMc) && this.battleViewMc.numChildren > 0)
         {
            if(this.battleViewMc.getChildAt(0) is MovieClip)
            {
               MovieClip(this.battleViewMc.getChildAt(0)).stop();
            }
            this.battleViewMc.removeChildAt(0);
         }
         if(Boolean(this.battleViewMc))
         {
            this.battleViewMc.stop();
            this.battleViewMc = null;
         }
         if(Boolean(this.sourceLoader))
         {
            this.sourceLoader.removeEventListener(BattleSourceLoader.sourceOk,this.onBgComp);
            this.sourceLoader.destroy();
         }
         this.sourceLoader = null;
         this.removeRoleListeners(this.playerRole);
         this.playerRole.destroy();
         this.playerRole = null;
         this.removeRoleListeners(this.otherRole,true);
         this.otherRole.destroy();
         this.otherRole = null;
         this._battleObject = null;
         if(Boolean(this.playerRoleArr))
         {
            for(i = 0; i < this.playerRoleArr.length; i++)
            {
               this.playerRoleArr[i].destroy();
               this.playerRoleArr[i] = null;
            }
         }
         this.playerRoleArr = null;
         if(Boolean(this.otherRoleArr))
         {
            for(i = 0; i < this.otherRoleArr.length; i++)
            {
               this.otherRoleArr[i].destroy();
               this.otherRoleArr[i] = null;
            }
            this.otherRoleArr = null;
         }
         while(this.numChildren > 0)
         {
            this.removeChildAt(0);
         }
         SkillEffectDictory.instance.disport();
         SkillEffectDictory.instance.effectIdArr = [];
         BattleViewManager.getInstance().ClearView();
      }
      
      private function showBlood(value:int, mcparent:Sprite, left:Boolean = true, miss:Boolean = true, brust:Boolean = false, blue:Boolean = false, op:Point = null) : void
      {
         if(left)
         {
            if(this._lTi.running)
            {
               if(Boolean(op))
               {
                  op.y += this.MOVE_Y;
               }
               else
               {
                  op = new Point(0,this.MOVE_Y);
               }
            }
            this._lTi.start();
         }
         else
         {
            if(this._rTi.running)
            {
               if(Boolean(op))
               {
                  op.y += this.MOVE_Y;
               }
               else
               {
                  op = new Point(0,this.MOVE_Y);
               }
            }
            this._rTi.start();
         }
         var blood:NewBloodMc = BattleBloodMcPool.instance.get();
         blood.showWithRecycle(value,mcparent,left,miss,brust,blue,op,this.onBloodRecycle);
      }
      
      private function onBloodRecycle(blood:NewBloodMc) : void
      {
         BattleBloodMcPool.instance.recycle(blood);
      }
      
      private function onLoadComplete(event:TimerEvent) : void
      {
         this.isPlayLoad(true);
      }
   }
}

