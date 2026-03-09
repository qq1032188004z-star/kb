package com.game.modules.model
{
   import com.core.model.Model;
   import com.core.observer.MessageEvent;
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.global.GlobalConfig;
   import com.game.locators.EventDefine;
   import com.game.locators.GameData;
   import com.game.locators.MsgDoc;
   import com.game.manager.AlertManager;
   import com.game.modules.control.battle.BattleControl;
   import com.game.modules.vo.WinPetVo;
   import com.game.util.BitValueUtil;
   import com.publiccomponent.alert.AlertContainer;
   import com.publiccomponent.loading.XMLLocator;
   import com.xygame.module.battle.data.BattleData;
   import com.xygame.module.battle.data.BattleDefine;
   import com.xygame.module.battle.data.BattleLookList;
   import com.xygame.module.battle.data.BattleOpration;
   import com.xygame.module.battle.data.BufData;
   import com.xygame.module.battle.data.LevelUpData;
   import com.xygame.module.battle.data.SpiritData;
   import com.xygame.module.battle.event.BattleEvent;
   import org.green.server.data.ByteArray;
   import org.green.server.data.MsgPacket;
   import org.green.server.data.MsgUtil;
   import org.green.server.events.MsgEvent;
   
   public class BattleModel extends Model
   {
      
      public static const NAME:String = "battleModel";
      
      public function BattleModel(modelName:String = null)
      {
         super(NAME);
         ApplicationFacade.getInstance().registerViewLogic(new BattleControl());
      }
      
      override public function onRegister() : void
      {
         registerListener(MsgDoc.OP_GATEWAY_BATTLE_ROUND_START.back.toString(),this.onBattleRoundStart);
         registerListener(MsgDoc.OP_GATEWAY_BATTLE_ROUND_RESULE.back.toString(),this.onBattleRoundResultParse);
         registerListener(MsgDoc.OP_GATEWAY_BATTLE_START.back.toString(),this.onBattleStartParse);
         registerListener(MsgDoc.OP_GATEWAY_BATTLE_BUF.back.toString(),this.onBattleBuf);
         registerListener(MsgDoc.OP_GATEWAY_BATTLE_BUF_DIS.back.toString(),this.onBattleBufDis);
         registerListener(MsgDoc.OP_GATEWAY_CHANGE_SPIRIT_ROUND.back.toString(),this.onChangSpiritRound);
         registerListener(MsgDoc.OP_GATEWAY_SPIRIT_LEVEL_UP.back.toString(),this.onSpiritLevelUp);
         registerListener(MsgDoc.OP_CLIENT_REQ_ON_SKILL.back.toString(),this.receiveNewOldSkill);
         registerListener(MsgDoc.OP_GATEWAY_BATTLE_NEWEXP.back.toString(),this.receiveNewBattleExp);
         registerListener(MsgDoc.OP_CLIENT_BATTLE_WITH.back.toString(),this.onBeBattleWith);
         registerListener(MsgDoc.OP_GATEWAY_BATTLE_END.back.toString(),this.onBattleEnd);
         registerListener(MsgDoc.OP_GATEWAY_BATTLE_BUFS.back.toString(),this.onBattleBufsBack);
         registerListener(MsgDoc.OP_CLIENT_BATTLE_MD5.back.toString(),this.onBattleMD5Checnk);
         registerListener(MsgDoc.OP_GATEWARE_MD5_FAIL.back.toString(),this.onBattleMD5Fail);
         registerListener(MsgDoc.OP_GATEWAY_BATTLE_FSPK.back.toString(),this.onBattleFSPKback);
         registerListener(MsgDoc.OP_GATEWAY_COMBAT_SITE_OPTION.back.toString(),this.onSiteOptionback);
         registerListener(MsgDoc.OP_GATEWAY_COMBAT_SITE_EFFECT.back.toString(),this.onSiteEffectback);
         GameData.instance.addEventListener(EventDefine.LOOK_BATTLE,this.onLookBattle);
      }
      
      private function onLookBattle(event:MessageEvent = null) : void
      {
         if(BattleEvent.isStopLook)
         {
            return;
         }
         var ba:ByteArray = BattleLookList.ins.getNewData();
         if(ba == null)
         {
            if(BattleLookList.ins.battleEnd != null)
            {
               dispatch(EventConst.BATTLE_END,BattleLookList.ins.battleEnd);
            }
            return;
         }
         ba.position = 0;
         var magic:int = ba.readShort();
         var msg:MsgPacket = MsgUtil.createMsgPacket(ba,magic);
         var eve:MsgEvent = new MsgEvent(msg.mOpcode,msg);
         switch(msg.mOpcode)
         {
            case MsgDoc.OP_GATEWAY_BATTLE_ROUND_START.back:
               this.onBattleRoundStart(eve);
               BattleEvent.isStopLook = BattleLookList.ins.getLookLen() > 0;
               if(BattleEvent.isFristRound)
               {
                  BattleEvent.isFristRound = false;
                  ++BattleEvent.newLookRound;
               }
               break;
            case MsgDoc.OP_GATEWAY_BATTLE_ROUND_RESULE.back:
               this.onBattleRoundResultParse(eve);
               this.onLookBattle();
               break;
            case MsgDoc.OP_GATEWAY_BATTLE_START.back:
               this.onBattleStartParse(eve);
               BattleEvent.isFristRound = true;
               break;
            case MsgDoc.OP_GATEWAY_BATTLE_BUF.back:
               this.onBattleBuf(eve);
               this.onLookBattle();
               break;
            case MsgDoc.OP_GATEWAY_BATTLE_BUF_DIS.back:
               this.onBattleBufDis(eve);
               this.onLookBattle();
               break;
            case MsgDoc.OP_GATEWAY_CHANGE_SPIRIT_ROUND.back:
               this.onChangSpiritRound(eve);
               BattleEvent.isStopLook = BattleLookList.ins.getLookLen() > 0;
               break;
            case MsgDoc.OP_GATEWAY_BATTLE_END.back:
               this.onBattleEnd(eve);
               break;
            case MsgDoc.OP_GATEWAY_BATTLE_BUFS.back:
               this.onBattleBufsBack(eve);
               this.onLookBattle();
               break;
            case MsgDoc.OP_GATEWAY_COMBAT_SITE_OPTION.back:
               this.onSiteOptionback(eve);
               this.onLookBattle();
               break;
            case MsgDoc.OP_GATEWAY_COMBAT_SITE_EFFECT.back:
               this.onSiteEffectback(eve);
               this.onLookBattle();
         }
      }
      
      private function onBattleRoundStart(event:MsgEvent) : void
      {
         O.traceSocketBysend(event);
         dispatch(EventConst.BATTLE_ROUND_START,event.msg.mParams);
      }
      
      private function onBattleStartParse(event:MsgEvent) : void
      {
         var xml:XML = null;
         var state:int = 0;
         var spiritdata:SpiritData = null;
         var skillnum:int = 0;
         var j:int = 0;
         var mNum:int = 0;
         var i:int = 0;
         var skillobj:Object = null;
         BattleDefine.instance.initData();
         var msgpack:MsgPacket = event.msg;
         var battledata:BattleData = new BattleData();
         battledata.initPosint();
         var index:int = 0;
         if(msgpack.mParams >= 0)
         {
            state = msgpack.body.readInt();
            if(state != -1)
            {
               O.initCombatLog();
            }
            for(; state != -1; state = msgpack.body.readInt())
            {
               spiritdata = new SpiritData();
               if(state == 2)
               {
                  spiritdata.state = 1;
               }
               else
               {
                  spiritdata.state = state;
               }
               spiritdata.sid = msgpack.body.readInt();
               spiritdata.groupType = msgpack.body.readInt();
               spiritdata.hp = msgpack.body.readInt();
               spiritdata.maxhp = msgpack.body.readInt();
               spiritdata.level = msgpack.body.readInt();
               spiritdata.elem = msgpack.body.readInt();
               spiritdata.spiritid = msgpack.body.readInt();
               spiritdata.uniqueid = msgpack.body.readInt();
               spiritdata.userid = msgpack.body.readInt();
               skillnum = msgpack.body.readInt();
               battledata.skillCount += skillnum;
               for(j = 0; j < skillnum; j++)
               {
                  skillobj = new Object();
                  skillobj.skillid = msgpack.body.readInt();
                  xml = XMLLocator.getInstance().getSkill(skillobj.skillid);
                  if(xml && int(xml.effect) != 0 && battledata.allSkillArr.indexOf(int(xml.effect)) == -1)
                  {
                     battledata.allSkillArr[index] = int(xml.effect);
                     index++;
                  }
                  skillobj.xml = xml;
                  skillobj.time = msgpack.body.readInt();
                  skillobj.maxtime = msgpack.body.readInt();
                  spiritdata.skillArr.push(skillobj);
               }
               battledata.addBattle(spiritdata);
               if(GameData.instance.lookBattle != 1)
               {
                  if(GlobalConfig.userId == spiritdata.userid)
                  {
                     spiritdata.mySpirit = true;
                     battledata.sid = spiritdata.sid;
                     battledata.mySpiritArr.push(spiritdata);
                  }
                  else
                  {
                     battledata.otherArr.push(spiritdata);
                     if(state == 2)
                     {
                        mNum = msgpack.body.readInt();
                        for(i = 1; i < mNum; i++)
                        {
                           battledata.otherArr.push(new BattleData());
                        }
                     }
                  }
                  continue;
               }
               switch(GameData.instance.newLookType)
               {
                  case 2:
                     if(spiritdata.userid == BattleLookList.ins.playerInfo["player"]["id"])
                     {
                        spiritdata.mySpirit = true;
                        battledata.mySpiritArr.push(spiritdata);
                     }
                     else
                     {
                        battledata.otherArr.push(spiritdata);
                     }
                     break;
                  default:
                     if(spiritdata.groupType == 1)
                     {
                        spiritdata.mySpirit = true;
                        battledata.mySpiritArr.push(spiritdata);
                        if(skillnum == 0)
                        {
                           mNum = msgpack.body.readInt();
                           for(i = 1; i < mNum; i++)
                           {
                              battledata.mySpiritArr.push(new BattleData());
                           }
                        }
                     }
                     else
                     {
                        battledata.otherArr.push(spiritdata);
                        if(skillnum == 0)
                        {
                           mNum = msgpack.body.readInt();
                           for(i = 1; i < mNum; i++)
                           {
                              battledata.otherArr.push(new BattleData());
                           }
                        }
                     }
               }
            }
            battledata.battleType = msgpack.mParams;
            battledata.escape = msgpack.body.readInt();
         }
         if(event.msg.mParams >= 0)
         {
            dispatch(EventConst.BATTLE_START,battledata);
         }
         O.traceSocketBysend(event);
      }
      
      private function onBattleRoundResultParse(event:MsgEvent) : void
      {
         var msgpack:MsgPacket = null;
         var battleopration:BattleOpration = null;
         var sta:int = 0;
         var v:int = 0;
         var info:Object = null;
         var bufobj:BufData = null;
         var ao0:Object = null;
         var ao1:Object = null;
         var ao2:Object = null;
         var spiritdata:SpiritData = null;
         var skillnum:int = 0;
         var j:int = 0;
         var skillobj:Object = null;
         var pet:WinPetVo = null;
         O.traceSocketBysend(event);
         msgpack = event.msg;
         msgpack.body.position = 0;
         battleopration = new BattleOpration();
         battleopration.cmdtype = msgpack.mParams;
         switch(battleopration.cmdtype)
         {
            case 0:
               battleopration.haveBattle = msgpack.body.readInt();
               if(battleopration.haveBattle == 1)
               {
                  battleopration.atkid = msgpack.body.readInt();
                  battleopration.skillid = msgpack.body.readInt();
                  battleopration.defid = msgpack.body.readInt();
                  battleopration.miss = msgpack.body.readInt();
                  if(battleopration.miss == 0)
                  {
                     battleopration.brust = msgpack.body.readInt();
                     battleopration.atk_hp = msgpack.body.readInt();
                     battleopration.def_hp = msgpack.body.readInt();
                     battleopration.rebound_hp = msgpack.body.readInt();
                  }
               }
               battleopration.haveBuf = msgpack.body.readInt();
               while(battleopration.haveBuf != 0)
               {
                  bufobj = new BufData();
                  bufobj.bufid = battleopration.haveBuf;
                  bufobj.add_or_remove = msgpack.body.readInt();
                  switch(bufobj.add_or_remove)
                  {
                     case BufData.BUF_TYPE_0:
                        bufobj.defid = msgpack.body.readInt();
                        break;
                     case BufData.BUF_TYPE_1:
                        bufobj.atkid = msgpack.body.readInt();
                        bufobj.defid = msgpack.body.readInt();
                        bufobj.round = msgpack.body.readInt();
                        bufobj.param1 = msgpack.body.readInt();
                        bufobj.param2 = msgpack.body.readInt();
                        break;
                     case BufData.BUF_TYPE_2:
                        bufobj.atkid = msgpack.body.readInt();
                        bufobj.defid = msgpack.body.readInt();
                        bufobj.param1 = msgpack.body.readInt();
                        bufobj.param2 = msgpack.body.readInt();
                        break;
                     case BufData.BUF_TYPE_3:
                        ao0 = {};
                        ao0.paramkey = bufobj.bufid;
                        ao0.paramval = msgpack.body.readInt();
                        battleopration.appendArr.push(ao0);
                        break;
                     case BufData.BUF_TYPE_4:
                        ao1 = {};
                        ao1.paramkey = bufobj.bufid;
                        ao1.skillid = msgpack.body.readInt();
                        ao1.paramval = msgpack.body.readInt();
                        battleopration.appendArr.push(ao1);
                        break;
                     case BufData.BUF_TYPE_6:
                        ao2 = {};
                        ao2.paramkey = bufobj.bufid;
                        ao2.paramval = msgpack.body.readInt();
                        battleopration.appendArr.push(ao2);
                  }
                  battleopration.haveBuf = msgpack.body.readInt();
                  if(bufobj.add_or_remove != BufData.BUF_TYPE_3 && bufobj.add_or_remove != BufData.BUF_TYPE_6)
                  {
                     battleopration.bufArr.push(bufobj);
                  }
               }
               break;
            case 1:
               battleopration.sid = msgpack.body.readInt();
               battleopration.uniqueid = msgpack.body.readInt();
               sta = msgpack.body.readInt();
               if(sta == 1 && GameData.instance.lookBattle != 1)
               {
                  spiritdata = new SpiritData();
                  spiritdata.state = msgpack.body.readInt();
                  spiritdata.sid = msgpack.body.readInt();
                  spiritdata.groupType = msgpack.body.readInt();
                  spiritdata.hp = msgpack.body.readInt();
                  spiritdata.maxhp = msgpack.body.readInt();
                  spiritdata.level = msgpack.body.readInt();
                  spiritdata.elem = msgpack.body.readInt();
                  spiritdata.spiritid = msgpack.body.readInt();
                  spiritdata.uniqueid = msgpack.body.readInt();
                  spiritdata.userid = msgpack.body.readInt();
                  skillnum = msgpack.body.readInt();
                  for(j = 0; j < skillnum; j++)
                  {
                     skillobj = new Object();
                     skillobj.skillid = msgpack.body.readInt();
                     skillobj.time = msgpack.body.readInt();
                     skillobj.maxtime = msgpack.body.readInt();
                     spiritdata.skillArr.push(skillobj);
                  }
                  dispatch(EventConst.BATTLE_MONSTER_INFO,spiritdata);
               }
               break;
            case 2:
               battleopration.atkid = msgpack.body.readInt();
               battleopration.itemid = msgpack.body.readInt();
               battleopration.defid = msgpack.body.readInt();
               battleopration.param0 = msgpack.body.readInt();
               battleopration.param1 = msgpack.body.readInt();
               v = battleopration.itemid;
               info = GlobalConfig.otherObj["MainBattleInfo"];
               if(Boolean(info))
               {
                  if(info.hasOwnProperty("battleType"))
                  {
                     switch(info["battleType"])
                     {
                        case 17:
                           dispatch(EventConst.BATTLE_USE_PROPS,{"sid":battleopration.atkid});
                     }
                  }
               }
               if(BitValueUtil.getToolBitValue(v,6) && battleopration.param0 == 1)
               {
                  pet = new WinPetVo();
                  pet.spiritId = msgpack.body.readInt();
                  pet.spiritType = msgpack.body.readInt();
                  pet.spiritHp = msgpack.body.readInt();
                  pet.spiritAtk = msgpack.body.readInt();
                  pet.spiritDef = msgpack.body.readInt();
                  pet.spiritMagAtk = msgpack.body.readInt();
                  pet.spiritMagDef = msgpack.body.readInt();
                  pet.spiritSpeed = msgpack.body.readInt();
                  pet.spiritLevel = msgpack.body.readInt();
                  pet.spiritsid = msgpack.body.readInt();
                  pet.spiritPackid = msgpack.body.readInt();
                  pet.spiritsex = msgpack.body.readInt();
                  pet.attackGeniusValue = msgpack.body.readInt();
                  pet.defenceGeniusValue = msgpack.body.readInt();
                  pet.magicGeniusValue = msgpack.body.readInt();
                  pet.resistanceGeniusValue = msgpack.body.readInt();
                  pet.hpGeniusValue = msgpack.body.readInt();
                  pet.speedGeniusValue = msgpack.body.readInt();
                  battleopration.catchData = pet;
               }
               break;
            case 3:
               battleopration.atkid = msgpack.body.readInt();
               battleopration.avail = msgpack.body.readInt();
               break;
            case 4:
               break;
            case 5:
               switch(msgpack.body.readInt())
               {
                  case 1:
                     AlertManager.instance.addTipAlert({
                        "tip":"该场战斗不能使用培元金丹",
                        "type":1,
                        "stage":AlertContainer.instance.stage
                     });
                     return;
                  case 2:
                     AlertManager.instance.addTipAlert({
                        "tip":"你已使用6次药剂，无法再使用",
                        "type":1,
                        "stage":AlertContainer.instance.stage
                     });
                     return;
                  default:
                     return;
               }
         }
         dispatch(EventConst.BATTLE_ROUND_END,{"battleRoundOpration":battleopration});
      }
      
      private function onSpiritLevelUp(event:MsgEvent) : void
      {
         var nobj:Object = null;
         var ocount:int = 0;
         var osi:int = 0;
         var oobj:Object = null;
         O.traceSocket(event);
         var msgpack:MsgPacket = event.msg;
         msgpack.body.position = 0;
         var lvd:LevelUpData = new LevelUpData();
         lvd.type = 2;
         lvd.uniqueid = msgpack.body.readInt();
         lvd.spiritid = msgpack.body.readInt();
         lvd.realexp = msgpack.body.readInt();
         lvd.olevel = msgpack.body.readInt();
         lvd.omaxhp = msgpack.body.readInt();
         lvd.ospeed = msgpack.body.readInt();
         lvd.oattack = msgpack.body.readInt();
         lvd.odefack = msgpack.body.readInt();
         lvd.omagicatk = msgpack.body.readInt();
         lvd.omagicdef = msgpack.body.readInt();
         lvd.level = msgpack.body.readInt();
         lvd.maxhp = msgpack.body.readInt();
         lvd.speed = msgpack.body.readInt();
         lvd.attack = msgpack.body.readInt();
         lvd.defack = msgpack.body.readInt();
         lvd.magicatk = msgpack.body.readInt();
         lvd.magicdef = msgpack.body.readInt();
         var skillid:int = msgpack.body.readInt();
         while(skillid != 0)
         {
            nobj = new Object();
            nobj.skillid = skillid;
            lvd.skillarr.push(nobj);
            skillid = msgpack.body.readInt();
         }
         if(lvd.skillarr.length > 0)
         {
            lvd.key = msgpack.body.readInt();
            ocount = msgpack.body.readInt();
            for(osi = 0; osi < ocount; osi++)
            {
               oobj = new Object();
               oobj.skillid = msgpack.body.readInt();
               oobj.time = msgpack.body.readInt();
               lvd.oldskill.push(oobj);
            }
            lvd.mod = msgpack.body.readInt();
            lvd.attr = msgpack.body.readInt();
         }
         if(GameData.instance.playerData.showSpiritLevelUp)
         {
            this.dispatch(EventConst.SPIRIT_LEVEL_UP,lvd);
         }
         else
         {
            dispatch("DelayOrCancelLevelUpView",lvd);
         }
      }
      
      private function receiveNewOldSkill(event:MsgEvent) : void
      {
         var osd:LevelUpData = null;
         var nsd:LevelUpData = null;
         var osid:int = 0;
         var nsid:int = 0;
         var nskill:XML = null;
         var nobj:Object = null;
         var oobj:Object = null;
         var skill:XML = null;
         O.traceSocket(event);
         var msgpack:MsgPacket = event.msg;
         var skillsData:Object = {};
         if(msgpack.mParams == 1)
         {
            skillsData.key = msgpack.body.readInt();
            osd = new LevelUpData();
            nsd = new LevelUpData();
            osid = msgpack.body.readInt();
            while(osid > 0)
            {
               oobj = {};
               oobj.skillid = osid;
               oobj.skillnum = msgpack.body.readInt();
               skill = XMLLocator.getInstance().getSkill(oobj.skillid);
               if(skill != null)
               {
                  oobj.skillname = skill.name;
                  oobj.power = skill.power;
                  oobj.desc = skill.desc;
                  oobj.skillmaxnum = skill.count;
                  oobj.type = skill.type;
               }
               oobj.canclick = true;
               osd.skillarr.push(oobj);
               osid = msgpack.body.readInt();
            }
            skillsData.osd = osd;
            while(msgpack.body.bytesAvailable > 0)
            {
               nsid = msgpack.body.readInt();
               if(nsid > 0)
               {
                  nobj = new Object();
                  nobj.skillid = nsid;
                  nskill = XMLLocator.getInstance().getSkill(nobj.skillid);
                  if(nskill != null)
                  {
                     nobj.skillname = nskill.name;
                     nobj.power = nskill.power;
                     nobj.desc = nskill.desc;
                     nobj.skillnum = nobj.skillmaxnum = nskill.count;
                     nobj.type = nskill.type;
                  }
                  nsd.skillarr.push(nobj);
                  nobj.canclick = true;
               }
            }
         }
         skillsData.nsd = nsd;
         dispatch(EventConst.REQ_NEW_OLD_SKILL_BACK,skillsData);
      }
      
      private function receiveNewBattleExp(event:MsgEvent) : void
      {
         var obj:Object = null;
         var lo:Object = null;
         var spo:LevelUpData = null;
         var skillflag:int = 0;
         var nobj:Object = null;
         var ocount:int = 0;
         var i:int = 0;
         var sobj:Object = null;
         O.traceSocket(event);
         var msgpack:MsgPacket = event.msg;
         var battleExp:Object = {};
         battleExp.type = msgpack.mParams;
         battleExp.win = msgpack.body.readUnsignedInt();
         battleExp.totalexp = 0;
         GameData.instance.dispatchEvent(new MessageEvent(EventDefine.COMBAT_OVER,Boolean(battleExp.win & 0x80000000)));
         var goods:Array = [];
         var goodid:int = msgpack.body.readInt();
         while(goodid != 0)
         {
            obj = {};
            obj.itemid = goodid;
            obj.itemnum = msgpack.body.readInt();
            goods.push(obj);
            goodid = msgpack.body.readInt();
         }
         var learnPowers:Array = [];
         var spiritid:int = msgpack.body.readInt();
         while(spiritid != 0)
         {
            lo = {};
            lo.spiritid = spiritid;
            lo.uniqueid = msgpack.body.readInt();
            lo.atkvalue = msgpack.body.readInt();
            lo.defvalue = msgpack.body.readInt();
            lo.magicatk = msgpack.body.readInt();
            lo.magicdef = msgpack.body.readInt();
            lo.strenght = msgpack.body.readInt();
            lo.speed = msgpack.body.readInt();
            spiritid = msgpack.body.readInt();
            learnPowers.push(lo);
         }
         var type:int = msgpack.body.readInt();
         var spiritsExp:Array = [];
         while(type > 0)
         {
            spo = new LevelUpData();
            spo.type = type;
            if(type == 1)
            {
               spo.spiritid = msgpack.body.readInt();
               spo.addexp = msgpack.body.readInt();
               spo.rate = msgpack.body.readInt();
               spo.realexp = msgpack.body.readInt();
               battleExp.totalexp += spo.realexp;
               spo.expnow = msgpack.body.readInt();
               spo.currentHp = msgpack.body.readInt();
               spo.maxhp = msgpack.body.readInt();
               spo.level = msgpack.body.readInt();
            }
            else if(type == 2)
            {
               spo.uniqueid = msgpack.body.readInt();
               spo.spiritid = msgpack.body.readInt();
               spo.realexp = msgpack.body.readInt();
               battleExp.totalexp += spo.realexp;
               spo.olevel = msgpack.body.readInt();
               spo.omaxhp = msgpack.body.readInt();
               spo.ospeed = msgpack.body.readInt();
               spo.oattack = msgpack.body.readInt();
               spo.odefack = msgpack.body.readInt();
               spo.omagicatk = msgpack.body.readInt();
               spo.omagicdef = msgpack.body.readInt();
               spo.level = msgpack.body.readInt();
               spo.maxhp = msgpack.body.readInt();
               spo.speed = msgpack.body.readInt();
               spo.attack = msgpack.body.readInt();
               spo.defack = msgpack.body.readInt();
               spo.magicatk = msgpack.body.readInt();
               spo.magicdef = msgpack.body.readInt();
               spo.expnow = msgpack.body.readInt();
               spo.currentHp = spo.maxhp;
               skillflag = msgpack.body.readInt();
               while(skillflag > 0)
               {
                  nobj = {};
                  nobj.skillid = skillflag;
                  spo.skillarr.push(nobj);
                  skillflag = msgpack.body.readInt();
               }
               if(spo.skillarr.length > 0)
               {
                  spo.key = msgpack.body.readInt();
                  ocount = msgpack.body.readInt();
                  for(i = 0; i < ocount; i++)
                  {
                     sobj = {};
                     sobj.skillid = msgpack.body.readInt();
                     sobj.time = msgpack.body.readInt();
                     spo.oldskill.push(sobj);
                  }
                  spo.mod = msgpack.body.readInt();
                  spo.attr = msgpack.body.readInt();
               }
            }
            spiritsExp.push(spo);
            type = msgpack.body.readInt();
         }
         battleExp.goods = goods;
         battleExp.spiritsExp = spiritsExp;
         battleExp.saveExp = msgpack.body.readInt();
         dispatch(EventConst.BATTLE_NEWEXP_BACK,battleExp);
         switch(event.msg.mParams)
         {
            case 4:
               if(event.msg.mParams == 4 && event.msg.userdata.win == 0)
               {
                  dispatch(EventConst.OUT_BOB_BACK);
               }
               else if(event.msg.mParams == 4 && event.msg.userdata.win != 0)
               {
                  dispatch(EventConst.BATTLE_BOB_WIN);
               }
         }
      }
      
      private function onBeBattleWith(event:MsgEvent) : void
      {
         O.traceSocket(event);
         dispatch(EventConst.BE_REQUES_BATTLE,event.msg);
      }
      
      private function onBattleBuf(event:MsgEvent) : void
      {
         O.traceSocketBysend(event);
         var msgpack:MsgPacket = event.msg;
         var buf:BufData = new BufData();
         buf.add_or_remove = msgpack.body.readInt();
         buf.bufid = msgpack.body.readInt();
         buf.defid = msgpack.body.readInt();
         buf.param1 = msgpack.body.readInt();
         buf.param2 = msgpack.body.readInt();
         switch(buf.add_or_remove)
         {
            case BufData.BUF_TYPE_4:
               dispatch(EventConst.BATTLE_BUF_BLOOD,buf);
               break;
            case BufData.BUF_TYPE_5:
               dispatch(EventConst.BATTLE_BUF_RECOVER,buf);
               break;
            default:
               dispatch(EventConst.BATTLE_BUF,buf);
         }
      }
      
      private function onBattleBufDis(event:MsgEvent) : void
      {
         O.traceSocketBysend(event);
         var msgpack:MsgPacket = event.msg;
         var buf:BufData = new BufData();
         buf.bufid = msgpack.body.readInt();
         buf.defid = msgpack.body.readInt();
         dispatch(EventConst.BATTLE_BUF_DIS,buf);
      }
      
      private function onBattleEnd(event:MsgEvent) : void
      {
         var num:int = 0;
         var i:int = 0;
         var o:Object = null;
         O.traceSocketBysend(event);
         var obj:Object = new Object();
         obj.param = event.msg.mParams;
         if(obj.param == 1)
         {
            num = event.msg.body.readInt();
            obj.arr = new Array();
            for(i = 0; i < num; i++)
            {
               o = {};
               o.sid = event.msg.body.readInt();
               o.res = event.msg.body.readInt();
               obj.arr.push(o);
            }
         }
         if(GameData.instance.lookBattle == 1)
         {
            if(GameData.instance.newLookType == 2)
            {
               BattleLookList.ins.battleEnd = obj;
            }
         }
         else
         {
            dispatch(EventConst.BATTLE_END,obj);
         }
      }
      
      private function onChangSpiritRound(event:MsgEvent) : void
      {
         var sid:int = 0;
         O.traceSocketBysend(event);
         var needChangeNum:int = event.msg.mParams;
         for(var i:int = 0; i < needChangeNum; i++)
         {
            sid = event.msg.body.readInt();
         }
         var waitTime:int = event.msg.body.readInt();
         dispatch(EventConst.BATTLE_ROUND_START,waitTime);
      }
      
      private function onBattleBufsBack(event:MsgEvent) : void
      {
         var buf:BufData = null;
         O.traceSocketBysend(event);
         var buffs:Array = [];
         event.msg.body.position = 0;
         var sid:int = event.msg.body.readInt();
         while(sid != -1 && sid < 1000)
         {
            buf = new BufData();
            buf.defid = sid;
            buf.bufid = event.msg.body.readInt();
            buf.param1 = event.msg.body.readInt();
            buf.param2 = event.msg.body.readInt();
            sid = event.msg.body.readInt();
            buffs.push(buf);
         }
         dispatch(EventConst.BATTLE_BUFS,{"bufs":buffs});
      }
      
      private function onBattleMD5Checnk(event:MsgEvent) : void
      {
         O.traceSocket(event);
         var md5s:Object = {};
         md5s.lists = [];
         md5s.lists.push(event.msg.body.readUTF());
         md5s.lists.push(event.msg.body.readUTF());
         md5s.lists.push(event.msg.body.readUTF());
         md5s.lists.push(event.msg.body.readUTF());
         md5s.type = event.msg.mParams;
         dispatch(EventConst.BATTLE_CHECK,md5s);
      }
      
      private function onBattleMD5Fail(event:MsgEvent) : void
      {
         O.traceSocket(event);
         dispatch(EventConst.ENTERSCENE,1004);
      }
      
      private function onBattleFSPKback(event:MsgEvent) : void
      {
         O.traceSocket(event);
         var obj:Object = {};
         obj.params = event.msg.mParams;
         obj.win = event.msg.body.readInt();
         if(obj.win >= 0)
         {
            obj.xianli = event.msg.body.readInt();
            obj.zhangong = event.msg.body.readInt();
         }
         dispatch(EventConst.BATTLE_FSPK,obj);
      }
      
      private function onSiteOptionback(event:MsgEvent) : void
      {
         O.traceSocket(event,"",0,2);
         var obj:Object = {};
         obj.params = event.msg.mParams;
         event.msg.body.position = 0;
         switch(event.msg.mParams)
         {
            case BufData.COMBAT_SITE_ADD:
               obj["sn"] = event.msg.body.readInt();
               obj["id"] = event.msg.body.readInt();
               obj["round"] = event.msg.body.readInt();
               break;
            case BufData.COMBAT_SITE_MD:
               obj["id"] = event.msg.body.readInt();
               obj["round"] = event.msg.body.readInt();
               break;
            case BufData.COMBAT_SITE_DEL:
               obj["id"] = event.msg.body.readInt();
         }
         dispatch(EventConst.BATTLE_SITE,obj);
      }
      
      private function onSiteEffectback(event:MsgEvent) : void
      {
         var site_id:int = 0;
         O.traceSocket(event,"",0,2);
         var obj:BufData = new BufData();
         switch(event.msg.mParams)
         {
            case 1:
               obj.add_or_remove = BufData.BUF_TYPE_2;
               obj.bufid = BufData.SITE_RECOVER_ID;
               site_id = event.msg.body.readInt();
               obj.defid = event.msg.body.readInt();
               obj.param1 = event.msg.body.readInt();
               obj.param2 = 0;
               dispatch(EventConst.BATTLE_BUF,obj);
         }
      }
   }
}

