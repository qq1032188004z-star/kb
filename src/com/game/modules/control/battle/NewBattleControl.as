package com.game.modules.control.battle
{
   import com.core.observer.MessageEvent;
   import com.core.view.ViewConLogic;
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.global.GlobalConfig;
   import com.game.locators.GameData;
   import com.game.modules.control.*;
   import com.game.modules.view.battle.item.LanguageItem;
   import com.publiccomponent.loading.Hloader;
   import com.publiccomponent.loading.XMLLocator;
   import com.xygame.module.battle.data.BattleData;
   import com.xygame.module.battle.data.BattleOpration;
   import com.xygame.module.battle.data.LevelUpData;
   import com.xygame.module.battle.data.SpiritData;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class NewBattleControl extends ViewConLogic
   {
      
      public static const NAME:String = "NEWBATTLECONTROL";
      
      private var effectloader:Hloader;
      
      private var battlebool:Boolean = false;
      
      private var effectbool:Boolean = false;
      
      private var mskillarr:Array = [[171],[6],[173],[8],[133]];
      
      private var mattrsarr:Array = [0,1,2,3,4];
      
      private var oskillarr:Array = [171];
      
      private var myspirtid:int = 1001;
      
      private var skillarr:Array = [[1,2]];
      
      private var flag:Boolean;
      
      private var step:int;
      
      private var pointmc:MovieClip;
      
      private var peffect:MovieClip;
      
      private var sayAttackmc:MovieClip;
      
      private var round:int;
      
      private var battleType:int;
      
      private var spiritname:String = "";
      
      private var say:String = "";
      
      private var say1:String = "<font color=\'#ffffff\' size=\'+7\'>哇呀呀！我要打败你！</font>";
      
      private var say2:String = "<font color=\'#ffffff\' size=\'+7\'>你这是自寻死路！</font>";
      
      private var say3:String = "";
      
      private var say4:String = "<font color=\'#ffffff\' size=\'+7\'>哈哈，我又恢复力量了！</font>";
      
      private var say5:String = "<font color=\'#ffffff\' size=\'+7\'>啊！不可能！！！</font>";
      
      private var delayTimer:Timer;
      
      private var timecount:int = 0;
      
      public function NewBattleControl()
      {
         super(NAME);
         this.loadeffect();
      }
      
      private function loadeffect() : void
      {
         if(Boolean(this.effectloader))
         {
            this.effectloader.removeEventListener(Event.COMPLETE,this.onEffectLoaderHandler);
            this.effectloader = null;
         }
         this.effectloader = new Hloader("assets/battle/neweffect.swf");
         this.effectloader.addEventListener(Event.COMPLETE,this.onEffectLoaderHandler);
      }
      
      private function onEffectLoaderHandler(event:Event) : void
      {
         this.effectloader.removeEventListener(Event.COMPLETE,this.onEffectLoaderHandler);
         this.effectbool = true;
         if(this.battlebool)
         {
            dispatch(EventConst.BATTLE_START,this.battledata());
         }
      }
      
      override public function listEvents() : Array
      {
         return [[EventConst.NEW_PLAYER_BATTLE,this.startNewBattle],[EventConst.SHOW_BATTLE_VIEW,this.showBattleView],[EventConst.ON_BATTLE_OP,this.battleRoundEnd]];
      }
      
      private function startNewBattle(event:MessageEvent) : void
      {
         this.myspirtid = int(event.body);
         if(this.myspirtid == 0)
         {
            this.myspirtid = 1001;
         }
         this.battlebool = true;
         if(this.effectbool)
         {
            dispatch(EventConst.BATTLE_START,this.battledata());
         }
         else
         {
            this.loadeffect();
         }
      }
      
      private function showBattleView(event:MessageEvent) : void
      {
         ApplicationFacade.getInstance().retrieveViewLogic(BattleControl.NAME).getViewComponent().battleViewMc.visible = false;
         LanguageItem.instance.say({
            "playersay":this.say1,
            "othersay":""
         },ApplicationFacade.getInstance().retrieveViewLogic(MapControl.NAME).getViewComponent().stage,275,200,true);
         this.startDelayTime();
      }
      
      private function battledata() : BattleData
      {
         var xml:XML = null;
         var skillobj:Object = null;
         var skillobj1:Object = null;
         var battledata:BattleData = new BattleData();
         var spiritdata:SpiritData = new SpiritData();
         spiritdata.state = 1;
         spiritdata.sid = 1000;
         spiritdata.groupType = 1;
         spiritdata.hp = 50;
         spiritdata.maxhp = 50;
         spiritdata.level = 5;
         spiritdata.elem = this.mattrsarr[int((this.myspirtid - 1000) / 3)];
         spiritdata.spiritid = this.myspirtid;
         spiritdata.uniqueid = 1;
         spiritdata.userid = GlobalConfig.userId;
         spiritdata.mySpirit = true;
         battledata.sid = spiritdata.sid;
         battledata.battleType = 1;
         var skillnum:int = int(this.mskillarr[int((this.myspirtid - 1000) / 3)].length);
         battledata.skillCount += skillnum;
         for(var j:int = 0; j < skillnum; j++)
         {
            skillobj = new Object();
            skillobj.skillid = this.mskillarr[int((this.myspirtid - 1000) / 3)][j];
            xml = XMLLocator.getInstance().skillitem(skillobj.skillid);
            if(int(xml.effect) > 0)
            {
               if(battledata.allSkillArr.indexOf(int(xml.effect)) == -1)
               {
                  battledata.allSkillArr.push(int(xml.effect));
               }
            }
            skillobj.time = 10;
            skillobj.maxtime = 10;
            spiritdata.skillArr.push(skillobj);
         }
         battledata.battleArr.push(spiritdata);
         battledata.mySpiritArr.push(spiritdata);
         var spiritdata1:SpiritData = new SpiritData();
         spiritdata1.state = 1;
         spiritdata1.sid = 1001;
         spiritdata1.groupType = 2;
         spiritdata1.hp = 50;
         spiritdata1.maxhp = 50;
         spiritdata1.level = 5;
         spiritdata1.elem = 0;
         spiritdata1.spiritid = 77;
         spiritdata1.uniqueid = 2;
         spiritdata1.userid = 10;
         battledata.sid = spiritdata1.sid;
         battledata.skillCount += skillnum;
         skillnum = int(this.oskillarr.length);
         for(j = 0; j < skillnum; j++)
         {
            skillobj1 = new Object();
            skillobj1.skillid = this.oskillarr[j];
            xml = XMLLocator.getInstance().getSkill(skillobj.skillid);
            if(int(xml.effect) > 0)
            {
               if(battledata.allSkillArr.indexOf(int(xml.effect)) == -1)
               {
                  battledata.allSkillArr.push(int(xml.effect));
               }
            }
            skillobj1.time = 10;
            skillobj1.maxtime = 10;
            spiritdata1.skillArr.push(skillobj1);
         }
         battledata.battleArr.push(spiritdata1);
         battledata.otherArr.push(spiritdata1);
         battledata.newbattle = true;
         return battledata;
      }
      
      private function battleRoundEnd(event:MessageEvent) : void
      {
         var battleopration:BattleOpration = null;
         var battleopration1:BattleOpration = null;
         var obj:Object = null;
         var tool:Object = null;
         var battleExp:Object = null;
         var goodid:int = 0;
         var type:int = 0;
         var spiritsExp:Array = null;
         var spo:LevelUpData = null;
         this.delPointTo();
         this.step = int(event.body);
         if(int(event.body) == 1)
         {
            this.delSayAttack();
            battleopration = new BattleOpration();
            battleopration.cmdtype = 0;
            if(battleopration.cmdtype == 0)
            {
               battleopration.haveBattle = 1;
               if(battleopration.haveBattle == 1)
               {
                  battleopration.atkid = 1000;
                  battleopration.skillid = this.mskillarr[int((this.myspirtid - 1000) / 3)][0];
                  battleopration.defid = 1001;
                  battleopration.miss = 0;
                  if(battleopration.miss == 0)
                  {
                     battleopration.brust = 0;
                     battleopration.atk_hp = 50;
                     battleopration.def_hp = 25;
                     battleopration.rebound_hp = 0;
                  }
               }
               battleopration.haveBuf = 0;
            }
            dispatch(EventConst.BATTLE_ROUND_END,{"battleRoundOpration":battleopration});
            battleopration1 = new BattleOpration();
            battleopration1.cmdtype = 0;
            if(battleopration1.cmdtype == 0)
            {
               battleopration1.haveBattle = 1;
               if(battleopration1.haveBattle == 1)
               {
                  battleopration1.atkid = 1001;
                  battleopration1.skillid = this.oskillarr[0];
                  battleopration1.defid = 1000;
                  battleopration1.miss = 0;
                  if(battleopration1.miss == 0)
                  {
                     battleopration1.brust = 0;
                     battleopration1.atk_hp = 25;
                     battleopration1.def_hp = 30;
                     battleopration1.rebound_hp = 0;
                  }
               }
               battleopration1.haveBuf = 0;
            }
            dispatch(EventConst.BATTLE_ROUND_END,{"battleRoundOpration":battleopration1});
            dispatch(EventConst.BATTLE_ROUND_START,-1);
         }
         else if(int(event.body) == 2)
         {
            this.say3 = "<font color=\'#ffffff\' size=\'+7\'>痛……痛死了！【" + GameData.instance.playerData.userName + "】，我快不行了！</font>";
            LanguageItem.instance.say({
               "playersay":this.say3,
               "othersay":""
            },ApplicationFacade.getInstance().retrieveViewLogic(MapControl.NAME).getViewComponent().stage,275,200,true);
            this.startDelayTime();
         }
         else if(int(event.body) == 3)
         {
            obj = {};
            tool = {};
            tool.id = 100008;
            tool.usableStatus = 208;
            tool.count = 10;
            obj.list = [];
            obj.list[0] = {};
            obj.list[0].goods = [];
            obj.list[0].goods.push(tool);
            dispatch(EventConst.BATTLE_TOOL_BACK,obj);
            dispatch(EventConst.BATTLE_ROUND_START,-1);
            this.addPointTo(280,433,0);
         }
         else if(int(event.body) == 4)
         {
            this.delSayAttack();
            battleopration = new BattleOpration();
            battleopration.cmdtype = 2;
            battleopration.atkid = 1;
            battleopration.itemid = 100008;
            battleopration.defid = 1000;
            battleopration.param0 = 20;
            battleopration.param1 = 0;
            dispatch(EventConst.BATTLE_ROUND_END,{"battleRoundOpration":battleopration});
         }
         else if(int(event.body) == 5)
         {
            this.delSayAttack();
            LanguageItem.instance.say({
               "playersay":this.say4,
               "othersay":""
            },ApplicationFacade.getInstance().retrieveViewLogic(MapControl.NAME).getViewComponent().stage,275,200,true);
            this.startDelayTime();
         }
         else if(int(event.body) == 6)
         {
            dispatch(EventConst.BATTLE_ROUND_START,-1);
            this.addPointTo(808,388,0);
            this.say = "【<font color=\'#ff0000\'>" + this.spiritname + "</font>】已经重新恢复体力了，快解决掉【<font color=\'#ff0000\'>大力铛</font>】吧！";
            this.addSayAttack(276,100,this.say);
         }
         else if(int(event.body) == 7)
         {
            this.addPointTo(280,433,-70);
         }
         else if(int(event.body) == 8)
         {
            this.delSayAttack();
            battleopration = new BattleOpration();
            battleopration.cmdtype = 0;
            if(battleopration.cmdtype == 0)
            {
               battleopration.haveBattle = 1;
               if(battleopration.haveBattle == 1)
               {
                  battleopration.atkid = 1000;
                  battleopration.skillid = this.mskillarr[int((this.myspirtid - 1000) / 3)][0];
                  battleopration.defid = 1001;
                  battleopration.miss = 0;
                  if(battleopration.miss == 0)
                  {
                     battleopration.brust = 0;
                     battleopration.atk_hp = 50;
                     battleopration.def_hp = 0;
                     battleopration.rebound_hp = 0;
                  }
               }
               battleopration.haveBuf = 0;
            }
            dispatch(EventConst.BATTLE_ROUND_END,{"battleRoundOpration":battleopration});
            this.startDelayTime(2000);
         }
         else if(int(event.body) == 9)
         {
            battleExp = {};
            battleExp.type = 1;
            battleExp.win = -2147483648;
            goodid = 0;
            type = 1;
            spiritsExp = [];
            spo = new LevelUpData();
            spo.type = type;
            if(type == 1)
            {
               spo.spiritid = this.myspirtid;
               spo.addexp = 10;
               spo.rate = 1;
               spo.realexp = 12;
               spo.expnow = 20;
               spo.level = 5;
               spo.currentHp = 50;
               spo.maxhp = 50;
            }
            spiritsExp.push(spo);
            battleExp.goods = [];
            battleExp.spiritsExp = spiritsExp;
            battleExp.saveExp = 0;
            dispatch(EventConst.BATTLE_NEWEXP_BACK,battleExp);
            this.disport();
         }
      }
      
      private function addPointTo(mx:int, my:int, xoffset:int) : void
      {
         var obj:Object = this.effectloader.contentLoaderInfo.applicationDomain.getDefinition("pointto");
         this.pointmc = new obj();
         this.pointmc.x = mx;
         this.pointmc.y = my;
         ApplicationFacade.getInstance().retrieveViewLogic(BattleControl.NAME).getViewComponent().addChild(this.pointmc);
      }
      
      private function delPointTo() : void
      {
         if(Boolean(this.pointmc) && Boolean(ApplicationFacade.getInstance().retrieveViewLogic(BattleControl.NAME).getViewComponent().contains(this.pointmc)))
         {
            ApplicationFacade.getInstance().retrieveViewLogic(BattleControl.NAME).getViewComponent().removeChild(this.pointmc);
            this.pointmc.stop();
            this.pointmc = null;
         }
         if(Boolean(this.peffect) && Boolean(ApplicationFacade.getInstance().retrieveViewLogic(BattleControl.NAME).getViewComponent().contains(this.peffect)))
         {
            ApplicationFacade.getInstance().retrieveViewLogic(BattleControl.NAME).getViewComponent().removeChild(this.peffect);
            this.peffect.stop();
            this.peffect = null;
         }
      }
      
      private function addSayAttack(mx:int, my:int, saywrods:String = "打他", offsety:int = 0) : void
      {
         var obj:Object = this.effectloader.contentLoaderInfo.applicationDomain.getDefinition("sayattack");
         this.sayAttackmc = new obj();
         this.sayAttackmc.txt.htmlText = saywrods;
         this.sayAttackmc.txt.y += offsety;
         this.sayAttackmc.x = mx;
         this.sayAttackmc.y = my;
         ApplicationFacade.getInstance().retrieveViewLogic(BattleControl.NAME).getViewComponent().addChild(this.sayAttackmc);
      }
      
      private function delSayAttack() : void
      {
         if(Boolean(this.sayAttackmc) && Boolean(ApplicationFacade.getInstance().retrieveViewLogic(BattleControl.NAME).getViewComponent().contains(this.sayAttackmc)))
         {
            ApplicationFacade.getInstance().retrieveViewLogic(BattleControl.NAME).getViewComponent().removeChild(this.sayAttackmc);
            this.sayAttackmc.stop();
            this.sayAttackmc = null;
         }
      }
      
      private function disport() : void
      {
         ApplicationFacade.getInstance().removeViewLogic(NewBattleControl.NAME);
         if(Boolean(this.effectloader))
         {
            this.effectloader.unload();
         }
         this.effectloader = null;
      }
      
      private function startDelayTime(value:int = 2000) : void
      {
         if(this.delayTimer != null)
         {
            this.delayTimer.stop();
            this.delayTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onDelayTimer);
            this.delayTimer = null;
         }
         this.delayTimer = new Timer(value,1);
         this.delayTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onDelayTimer);
         this.delayTimer.start();
      }
      
      private function onDelayTimer(event:TimerEvent) : void
      {
         var battleopration1:BattleOpration = null;
         this.stopDelayTimer();
         if(this.timecount == 0)
         {
            LanguageItem.instance.say({
               "playersay":"",
               "othersay":this.say2
            },ApplicationFacade.getInstance().retrieveViewLogic(MapControl.NAME).getViewComponent().stage,480,200,true);
            ++this.timecount;
            this.startDelayTime();
         }
         else if(this.timecount == 1)
         {
            dispatch(EventConst.BATTLE_ROUND_START,-1);
            this.delPointTo();
            this.addPointTo(280,433,-70);
            this.spiritname = ApplicationFacade.getInstance().retrieveViewLogic(BattleControl.NAME).getViewComponent().battleObject.mySpiritArr[0].name;
            this.say = "快使用技能攻击【<font color=\'#ff0000\'>大力铛</font>】!";
            this.addSayAttack(276,100,this.say,20);
            ApplicationFacade.getInstance().retrieveViewLogic(BattleControl.NAME).getViewComponent().battleViewMc.visible = true;
            this.stopDelayTimer();
            ++this.timecount;
         }
         else if(this.timecount == 2)
         {
            this.say = "【<font color=\'#ff0000\'>" + this.spiritname + "</font>】受伤了，快点使用【小型金创药】给【<font color=\'#ff0000\'>" + this.spiritname + "</font>】补充体力。";
            this.addSayAttack(276,100,this.say,5);
            this.delPointTo();
            this.addPointTo(927,382,-30);
            ++this.timecount;
            dispatch(EventConst.BATTLE_ROUND_START,-1);
         }
         else if(this.timecount == 3)
         {
            battleopration1 = new BattleOpration();
            battleopration1.cmdtype = 0;
            if(battleopration1.cmdtype == 0)
            {
               battleopration1.haveBattle = 1;
               if(battleopration1.haveBattle == 1)
               {
                  battleopration1.atkid = 1001;
                  battleopration1.skillid = this.oskillarr[0];
                  battleopration1.defid = 1000;
                  battleopration1.miss = 1;
               }
               battleopration1.haveBuf = 0;
            }
            dispatch(EventConst.BATTLE_ROUND_END,{"battleRoundOpration":battleopration1});
            ++this.timecount;
         }
         else if(this.timecount == 4)
         {
            LanguageItem.instance.say({
               "playersay":"",
               "othersay":this.say5
            },ApplicationFacade.getInstance().retrieveViewLogic(MapControl.NAME).getViewComponent().stage,550,150,true);
         }
      }
      
      private function stopDelayTimer() : void
      {
         if(this.delayTimer != null)
         {
            this.delayTimer.stop();
            this.delayTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onDelayTimer);
            this.delayTimer = null;
         }
      }
   }
}

