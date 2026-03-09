package com.xygame.module.battle.battleItem
{
   import com.core.observer.MessageEvent;
   import com.game.global.GlobalConfig;
   import com.game.modules.view.battle.util.FramedAnimation;
   import com.game.util.DisplayObjectMyUtil;
   import com.game.util.MovieClipUtil;
   import com.kb.util.Handler;
   import com.publiccomponent.loading.Hloader;
   import com.xygame.module.battle.data.SpiritData;
   import com.xygame.module.battle.util.Rotation180;
   import com.xygame.module.battle.vo.CombatRoleStatus;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.utils.Dictionary;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   
   public class BattleRole extends Sprite
   {
      
      private var effectFinish:Boolean = false;
      
      private var mc:MovieClip;
      
      private var testSpiritId:String = "1";
      
      private var _roleInfo:SpiritData;
      
      private var changeout:Boolean;
      
      private var otherRole:BattleRole;
      
      private var mcloader:Hloader;
      
      private var enterbool:Boolean;
      
      private var roledie:Boolean;
      
      private var dieout:Boolean;
      
      private var failEnd:Boolean = false;
      
      private var attackFinish:Boolean = false;
      
      private var miss:int;
      
      private var _status:String;
      
      private var skinContainer:Sprite;
      
      private var mcDic:Dictionary;
      
      private var statusMc:FramedAnimation;
      
      private var _framedList:Dictionary = new Dictionary();
      
      private var waiOther:String;
      
      public var isInit:Boolean;
      
      private var _overTurn:Boolean;
      
      private var _waiting:Boolean;
      
      private var _waitingNum:int;
      
      private var _waitingForLabel:String;
      
      private var _checkInterval:uint;
      
      public function BattleRole(value:SpiritData)
      {
         this.roleInfo = value;
         if(Boolean(this.roleInfo))
         {
            this.loaderMc();
         }
         super();
      }
      
      public function spiritWait() : void
      {
         this.status = CombatRoleStatus.WAI;
      }
      
      public function set roleInfo(value:SpiritData) : void
      {
         this._roleInfo = value;
      }
      
      private function loaderMc() : void
      {
         this.waiOther = "";
         if(this.roleInfo.url == "NULL" || this.roleInfo.url.length < 5)
         {
            this.roleInfo.url = "spirit" + this.testSpiritId + "src";
         }
         else
         {
            this.roleInfo.url = "assets/battle/battleRole/" + this.roleInfo.url;
         }
         this.skinContainer = new Sprite();
         addChild(this.skinContainer);
         this.overTurn = this.roleInfo.mySpirit;
         this.mcloader = new Hloader(this.roleInfo.url);
         this.mcloader.addEventListener(Event.COMPLETE,this.onMcLoaderComp);
         this.mcloader.addEventListener(IOErrorEvent.IO_ERROR,this.onIoErrorHandler);
      }
      
      public function spiritMiss(bool:Boolean = true) : void
      {
         this.status = CombatRoleStatus.MIS;
         if(bool)
         {
            dispatchEvent(new BattleRoleEvent(BattleRoleEvent.addBattleEffect));
         }
         dispatchEvent(new BattleRoleEvent(BattleRoleEvent.changeRoleInfo));
      }
      
      public function spiritOut(dieout:Boolean = true, changeout:Boolean = false) : void
      {
         this.status = CombatRoleStatus.OTF;
         this.dieout = dieout;
         this.changeout = changeout;
      }
      
      private function onIoErrorHandler(e:IOErrorEvent) : void
      {
         this.mcloader.removeEventListener(IOErrorEvent.IO_ERROR,this.onIoErrorHandler);
         this.mcloader.url = this.roleInfo.url = "assets/battle/battleRole/spirit" + this.testSpiritId + "src";
      }
      
      public function spiritPhyBattle(otherRole:BattleRole, miss:int) : void
      {
         this.attackFinish = false;
         this.effectFinish = false;
         this.status = CombatRoleStatus.ATT;
         this.otherRole = otherRole;
         this.miss = miss;
      }
      
      public function spiritWin() : void
      {
         this.status = CombatRoleStatus.WAI;
      }
      
      public function spiritFail(bool:Boolean = true) : void
      {
         if(!this.roledie)
         {
            this.status = CombatRoleStatus.DEA;
            if(bool)
            {
               dispatchEvent(new BattleRoleEvent(BattleRoleEvent.addBattleEffect));
            }
            dispatchEvent(new BattleRoleEvent(BattleRoleEvent.changeRoleInfo));
            this.roledie = true;
         }
      }
      
      public function selfAction() : void
      {
         this.status = CombatRoleStatus.PER;
      }
      
      private function onMcPlayFinish(str:String = "") : void
      {
         dispatchEvent(new BattleRoleEvent(BattleRoleEvent.canOpration,null,null,{"key":str}));
      }
      
      public function spiritBeAttack(bool:Boolean = true) : void
      {
         this.status = CombatRoleStatus.UDA;
         if(bool)
         {
            dispatchEvent(new BattleRoleEvent(BattleRoleEvent.addBattleEffect));
         }
         dispatchEvent(new BattleRoleEvent(BattleRoleEvent.changeRoleInfo));
      }
      
      public function spiritSkiBattle(otherRole:BattleRole, miss:int) : void
      {
         this.attackFinish = false;
         this.effectFinish = false;
         this.status = CombatRoleStatus.MGS;
         this.otherRole = otherRole;
         this.miss = miss;
      }
      
      public function spiritBeBDAttack() : void
      {
         this.status = CombatRoleStatus.BTD;
      }
      
      public function mclabel() : Boolean
      {
         if(this.failEnd)
         {
            return true;
         }
         return false;
      }
      
      public function get roleInfo() : SpiritData
      {
         return this._roleInfo;
      }
      
      private function initMc() : void
      {
         var classTmp:Object = null;
         classTmp = this.mcloader.contentLoaderInfo.applicationDomain.getDefinition("spirit" + this.roleInfo.srcid + "mc");
         if(this.mc == null && classTmp != null)
         {
            this.mc = new classTmp();
            this.mcloader.unload();
            this.mcloader = null;
            this.mcDic = new Dictionary();
            if(GlobalConfig.COMBAT_GAP_TIME == 1)
            {
               if(this.roleInfo.mySpirit)
               {
                  this.mc = Rotation180.rotationX180(this.mc);
               }
               addChild(this.mc);
            }
            if(Boolean(this._status))
            {
               this.status = this._status;
            }
            else
            {
               this.status = CombatRoleStatus.SPA;
            }
            this.dispatchEvent(new BattleRoleEvent(BattleRoleEvent.battleRoleOK,null,this));
         }
      }
      
      public function set overTurn(value:Boolean) : void
      {
         this._overTurn = value;
         if(value)
         {
            this.skinContainer.scaleX = -1;
         }
         else
         {
            this.skinContainer.scaleX = 1;
         }
      }
      
      private function initFA() : void
      {
         var tempMC:MovieClip = null;
         var fa:FramedAnimation = null;
         var total:int = 0;
         var frame:int = 0;
         this.mc.gotoAndStop(this._status);
         var obj:Object = this.mc.getChildAt(0);
         if(Boolean(obj))
         {
            tempMC = this.mc.removeChildAt(this.mc.numChildren - 1) as MovieClip;
            if(Boolean(tempMC))
            {
               fa = FramedAnimation.createAnimationFromMoveClip(tempMC,FramedAnimation.SOURCE_TYPE_MIX_CLIP,tempMC.scaleX,tempMC.scaleY);
               fa.frameRate = 24;
               fa.currentFrame = 1;
               this._framedList[this._status] = fa;
               this.mcDic[fa] = this._status;
               if(CombatRoleStatus.FRAME_LABLE.indexOf(this._status) > -1)
               {
                  total = fa.totalFrames - 2;
                  frame = 1;
                  switch(this._status)
                  {
                     case CombatRoleStatus.ATT:
                        frame = this.roleInfo.frame > total ? total : this.roleInfo.frame;
                        break;
                     case CombatRoleStatus.MGS:
                        frame = this.roleInfo.sframe > total ? total : this.roleInfo.sframe;
                        break;
                     case CombatRoleStatus.MGF:
                        frame = this.roleInfo.aframe > total ? total : this.roleInfo.aframe;
                  }
                  fa.setFrameHandler(frame,new Handler(null,this.onMcFrame));
               }
               fa.setFrameHandler(fa.totalFrames - 1,new Handler(null,this.onMcComplete));
               this.playFAAni(this._status);
            }
         }
         else
         {
            this._waiting = true;
            this._waitingNum = 1;
            this._waitingForLabel = this._status;
            if(this._checkInterval != 0)
            {
               clearInterval(this._checkInterval);
            }
            this._checkInterval = setInterval(this.checkForChildInterval,21);
         }
      }
      
      private function checkForChildInterval() : void
      {
         var child:DisplayObject = null;
         if(Boolean(this.mc))
         {
            if(this._waiting && this.mc.currentLabel === this._waitingForLabel)
            {
               ++this._waitingNum;
               if(this.mc.numChildren > 0)
               {
                  child = this.mc.getChildAt(0);
                  if(Boolean(child))
                  {
                     clearInterval(this._checkInterval);
                     this._checkInterval = 0;
                     this.initFA();
                  }
               }
            }
         }
         else
         {
            clearInterval(this._checkInterval);
            this._checkInterval = 0;
         }
      }
      
      private function initMC() : void
      {
         var tempMC:MovieClip = null;
         var total:int = 0;
         var frame:int = 0;
         this.mc.gotoAndStop(this._status);
         var obj:Object = this.mc.getChildAt(0);
         if(Boolean(obj))
         {
            tempMC = this.mc.getChildAt(0) as MovieClip;
            if(Boolean(tempMC))
            {
               if(CombatRoleStatus.FRAME_LABLE.indexOf(this._status) > -1)
               {
                  total = tempMC.totalFrames - 2;
                  frame = 1;
                  switch(this._status)
                  {
                     case CombatRoleStatus.ATT:
                        frame = this.roleInfo.frame > total ? total : this.roleInfo.frame;
                        break;
                     case CombatRoleStatus.MGS:
                        frame = this.roleInfo.sframe > total ? total : this.roleInfo.sframe;
                        break;
                     case CombatRoleStatus.MGF:
                        frame = this.roleInfo.aframe > total ? total : this.roleInfo.aframe;
                  }
                  tempMC.addFrameScript(frame,this.onMcFrame);
               }
               tempMC.addFrameScript(tempMC.totalFrames - 1,this.onMcComplete);
               tempMC.gotoAndPlay(1);
            }
         }
         else
         {
            this._waiting = true;
            this._waitingNum = 1;
            this._waitingForLabel = this._status;
            if(this._checkInterval != 0)
            {
               clearInterval(this._checkInterval);
            }
            this._checkInterval = setInterval(this.mcCheckForChildInterval,21);
         }
      }
      
      private function mcCheckForChildInterval() : void
      {
         var child:DisplayObject = null;
         if(Boolean(this.mc))
         {
            if(this._waiting && this.mc.currentLabel === this._waitingForLabel)
            {
               ++this._waitingNum;
               if(this.mc.numChildren > 0)
               {
                  child = this.mc.getChildAt(0);
                  if(Boolean(child))
                  {
                     clearInterval(this._checkInterval);
                     this._checkInterval = 0;
                     this.initMC();
                  }
               }
            }
         }
         else
         {
            clearInterval(this._checkInterval);
            this._checkInterval = 0;
         }
      }
      
      public function set status(value:String) : void
      {
         if(this._status != value)
         {
            this._status = value;
            if(this._status == CombatRoleStatus.SPA)
            {
               return;
            }
            if(GlobalConfig.COMBAT_GAP_TIME == 1)
            {
               this.initMC();
            }
            else if(this._framedList.hasOwnProperty(this._status))
            {
               this.playFAAni(value);
            }
            else
            {
               this.initFA();
            }
         }
      }
      
      private function playFAAni(value:String) : void
      {
         if(Boolean(this.statusMc))
         {
            this.statusMc.currentFrame = 1;
            this.statusMc.stop();
            this.statusMc.parent.removeChild(this.statusMc);
         }
         this.statusMc = this._framedList[value];
         this.skinContainer.addChild(this.statusMc);
         this.statusMc.play();
      }
      
      public function puzhuo() : void
      {
         this.status = CombatRoleStatus.WAI;
         this.waiOther = "puzhuo";
      }
      
      public function addBlood() : void
      {
         this.status = CombatRoleStatus.WAI;
         this.waiOther = "addBlood";
      }
      
      public function selfSkill() : void
      {
         this.status = CombatRoleStatus.OWK;
      }
      
      public function spiritEnter(value:Boolean = false) : void
      {
         this.failEnd = false;
         this.status = CombatRoleStatus.STF;
         this.enterbool = value;
      }
      
      private function onMcLoaderComp(event:Event) : void
      {
         this.mcloader.removeEventListener(Event.COMPLETE,this.onMcLoaderComp);
         this.mcloader.removeEventListener(IOErrorEvent.IO_ERROR,this.onIoErrorHandler);
         this.initMc();
      }
      
      public function destroy() : void
      {
         this.roleInfo = null;
         if(Boolean(this.mcDic))
         {
            this.mcDic = new Dictionary();
         }
         if(Boolean(this._framedList))
         {
            this.clearDictionarySafely(this._framedList);
         }
         if(Boolean(this.statusMc))
         {
            this.statusMc = null;
         }
         if(Boolean(this.otherRole))
         {
            this.otherRole = null;
         }
         if(Boolean(this.mc))
         {
            MovieClipUtil.stopMovieClip(this.mc);
            DisplayObjectMyUtil.removeObject(this.mc);
            this.mc = null;
         }
      }
      
      private function clearDictionarySafely(dict:Dictionary) : void
      {
         var key:Object = null;
         var mc:DisplayObjectContainer = null;
         for(key in dict)
         {
            mc = dict[key];
            if(Boolean(mc.parent))
            {
               mc.parent.removeChild(mc);
            }
            delete dict[key];
         }
      }
      
      private function onMcFrame(p:Object = null, r:Object = null) : void
      {
         var completedStatus:String = null;
         if(GlobalConfig.COMBAT_GAP_TIME != 1)
         {
            completedStatus = this.mcDic[this.statusMc];
         }
         else
         {
            completedStatus = this._status;
         }
         if(completedStatus == this._status)
         {
            switch(completedStatus)
            {
               case CombatRoleStatus.ATT:
               case CombatRoleStatus.MGF:
                  if(Boolean(this.otherRole))
                  {
                     if(this.otherRole.roleInfo.hp > 0)
                     {
                        switch(this.miss)
                        {
                           case 0:
                              this.otherRole.spiritBeAttack(completedStatus == CombatRoleStatus.ATT);
                              break;
                           case 1:
                           case 2:
                              this.otherRole.spiritMiss(completedStatus == CombatRoleStatus.ATT);
                        }
                     }
                     else
                     {
                        this.otherRole.spiritFail(completedStatus == CombatRoleStatus.ATT);
                     }
                  }
                  dispatchEvent(new BattleRoleEvent(BattleRoleEvent.OPEN_SITE));
                  dispatchEvent(new BattleRoleEvent(BattleRoleEvent.bloodMcPlay));
                  break;
               case CombatRoleStatus.MGS:
                  this.otherRole.dispatchEvent(new BattleRoleEvent(BattleRoleEvent.addBattleEffect));
            }
         }
      }
      
      private function onMcComplete(p:Object = null, r:Object = null) : void
      {
         var completedStatus:String = null;
         if(GlobalConfig.COMBAT_GAP_TIME != 1)
         {
            completedStatus = this.mcDic[this.statusMc];
         }
         else
         {
            completedStatus = this._status;
         }
         if(completedStatus == this._status)
         {
            switch(completedStatus)
            {
               case CombatRoleStatus.WAI:
                  if(this.waiOther != null && this.waiOther != "")
                  {
                     switch(this.waiOther)
                     {
                        case "addBlood":
                        case "puzhuo":
                           this.waiOther = "";
                           this.onMcPlayFinish();
                     }
                  }
                  break;
               case CombatRoleStatus.MGS:
                  this.status = CombatRoleStatus.MGF;
                  break;
               case CombatRoleStatus.MGF:
                  this.status = CombatRoleStatus.MGE;
                  break;
               case CombatRoleStatus.ATT:
               case CombatRoleStatus.MGE:
                  this.attackFinish = true;
                  this.otherRole = null;
                  if(this.roleInfo.hp < 1)
                  {
                     this.spiritFail(false);
                  }
                  else
                  {
                     this.spiritWait();
                  }
                  this.onMcPlayFinish();
                  break;
               case CombatRoleStatus.STF:
                  trace("STF_END");
                  this.spiritWait();
                  dispatchEvent(new MessageEvent(BattleRoleEvent.enterSceneOver,{"sid":this.roleInfo.sid}));
                  if(this.enterbool)
                  {
                     this.onMcPlayFinish(BattleRoleEvent.enterSceneOver);
                  }
                  break;
               case CombatRoleStatus.UDA:
               case CombatRoleStatus.MIS:
                  this.spiritWait();
                  break;
               case CombatRoleStatus.OWK:
                  if(this.roleInfo.hp < 1)
                  {
                     this.spiritFail();
                  }
                  else
                  {
                     this.spiritWait();
                  }
                  dispatchEvent(new BattleRoleEvent(BattleRoleEvent.changeRoleInfo));
                  this.onMcPlayFinish();
                  break;
               case CombatRoleStatus.OTF:
                  this.onAnimationEnd();
                  if(this.dieout)
                  {
                     this.failEnd = true;
                     this.onMcPlayFinish();
                  }
                  else if(this.changeout)
                  {
                     this.onMcPlayFinish();
                  }
                  break;
               case CombatRoleStatus.DEA:
                  this.onAnimationEnd();
                  this.failEnd = true;
                  this.onMcPlayFinish();
            }
         }
      }
      
      private function onAnimationEnd() : void
      {
         var tempMC:MovieClip = null;
         if(GlobalConfig.COMBAT_GAP_TIME == 1)
         {
            tempMC = this.mc.getChildAt(0) as MovieClip;
            tempMC.gotoAndStop(tempMC.totalFrames);
         }
         else if(Boolean(this.statusMc))
         {
            this.statusMc.currentFrame = this.statusMc.totalFrames;
            this.statusMc.stop();
         }
      }
   }
}

