package com.game.modules.view.battle
{
   import com.game.facade.ApplicationFacade;
   import com.game.locators.GameData;
   import com.game.modules.view.battle.item.BattleSkillItem;
   import com.game.modules.view.battle.item.ItemTip;
   import com.publiccomponent.loading.XMLLocator;
   import com.xygame.module.battle.event.BattleEvent;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.getTimer;
   
   public class BattleControlPanel extends Sprite
   {
      
      private var battleControlMc:MovieClip;
      
      private var skillArr:Array;
      
      private var _skillList:Vector.<BattleSkillItem>;
      
      private var _oprationValue:int = 286331153;
      
      private var spiritMc:MovieClip;
      
      public var skillId:int;
      
      public var spiritId:int;
      
      public var canBattle:Boolean = false;
      
      public var changingSpirit:int = 2;
      
      private var nh2b:* = ApplicationFacade.getInstance().retrieveViewLogic("NewHandBattle2Control");
      
      private var _elemValue:Array = [];
      
      private var mc:Object;
      
      private var canUseSkill:Boolean;
      
      private var out:Boolean;
      
      public var selectId:int;
      
      private var st:int = -1600;
      
      public function BattleControlPanel(mc:MovieClip)
      {
         super();
         this.battleControlMc = mc;
      }
      
      public function get oprationValue() : int
      {
         if(GameData.instance.isLogPlay())
         {
            return 268435456;
         }
         return this._oprationValue;
      }
      
      public function set oprationValue(value:int) : void
      {
         this._oprationValue = value;
      }
      
      private function initShow() : void
      {
         var item:BattleSkillItem = null;
         var i:int = 0;
         var xml:XML = null;
         if(this._skillList == null)
         {
            this._skillList = new Vector.<BattleSkillItem>();
            for(i = 0; i < 4; i++)
            {
               item = new BattleSkillItem(i);
               item.addEventListener(MouseEvent.CLICK,this.onSkillClick);
               item.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOverSkill);
               item.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOutSkill);
               this.battleControlMc["skill" + i].addChild(item);
               this._skillList.push(item);
            }
         }
         for(var s:int = 0; s < this._skillList.length; s++)
         {
            item = this._skillList[s];
            item.visible = s < this.skillArr.length;
            if(item.visible)
            {
               xml = XMLLocator.getInstance().getSkill(this.skillArr[s].skillid);
               if(xml == null)
               {
                  return;
               }
               item.setData(xml,this.skillArr[s].time,this.skillArr[s].maxtime,this.spiritId >= 10000);
               item.isBeUsed(!(this.skillArr[s].time == 0 || !this.skillCanBeElem(int(xml.elem)) || !this.skillCanBeUse(int(xml.skilltype),this.skillArr[s].time)));
            }
         }
      }
      
      public function setfilters(value:*) : void
      {
         for(var i:int = 0; i < this.skillArr.length; i++)
         {
            if(i < 4)
            {
               if(value == null)
               {
                  this._skillList[i].isBeUsed(false);
               }
               else if(!this.skillCanBeUse(int(this.skillArr[i].skilltype),this.skillArr[i].time) || !this.skillCanBeElem(int(this.skillArr[i].elem)))
               {
                  this._skillList[i].isBeUsed(false);
               }
               else
               {
                  this._skillList[i].isBeUsed(true);
               }
            }
         }
      }
      
      private function onMouseOverSkill(event:MouseEvent) : void
      {
         if(!this.canBattle)
         {
            return;
         }
         var skillItem:BattleSkillItem = event.currentTarget as BattleSkillItem;
         var xml:XML = skillItem.getCurXML();
         var x:int = 180 + skillItem.index * 135 + 70;
         var y:int = 350 + 35;
         var name:String = xml.name + "";
         var desc:String = "<font color=\'#660000\'>类型:" + String(xml.type) + "</font>\n" + "<font color=\'#FFFFFF\'>作用:" + String(xml.desc) + "</font>";
         var contain:DisplayObjectContainer = this.parent;
         ItemTip.instance.show({
            "toolname":name,
            "tooldesc":desc
         },contain,x,y);
         var time:int = int(this.skillArr[skillItem.index].time);
         this.updateCanUseSkill(xml,time);
         this.out = true;
      }
      
      private function skillCanBeUse(type:int, time:int) : Boolean
      {
         if(!(this.oprationValue & 0x10000000))
         {
            return false;
         }
         if(time <= 0)
         {
            return false;
         }
         if(!(type == 0 && this.oprationValue & 0x100000) && !(type == 1 && this.oprationValue & 0x01000000))
         {
            return false;
         }
         return true;
      }
      
      private function skillCanBeElem(elem:int) : Boolean
      {
         return this.elemValue.indexOf(elem) == -1;
      }
      
      private function onMouseOutSkill(event:MouseEvent) : void
      {
         ItemTip.instance.hide();
         this.out = false;
      }
      
      private function onSkillClick(event:MouseEvent) : void
      {
         var skillItem:BattleSkillItem = event.currentTarget as BattleSkillItem;
         var skillid:int = int(this.skillArr[skillItem.index].skillid);
         var time:int = int(this.skillArr[skillItem.index].time);
         var xml:XML = XMLLocator.getInstance().getSkill(skillid);
         this.updateCanUseSkill(xml,time);
         var lt:int = getTimer();
         if(!this.canBattle || this.changingSpirit != 0 && !this.nh2b || lt - this.st < 1500)
         {
            return;
         }
         if(this.canUseSkill && Boolean(this.oprationValue & 0x10000000))
         {
            this.selectId = skillItem.index;
            this.skillId = this.skillArr[skillItem.index].skillid;
            if(this.skillArr[skillItem.index].time > 0)
            {
               this.dispatchEvent(new Event(BattleEvent.BATTLE_CONTROL_CLICK_EVENT));
               this._oprationValue = this.oprationValue & 0x01111111;
               this.setfilters(null);
            }
         }
         this.st = lt;
      }
      
      private function updateCanUseSkill(xml:XML, time:int) : void
      {
         if(this.skillCanBeUse(int(xml.skilltype),time) && this.skillCanBeElem(int(xml.elem)))
         {
            this.canUseSkill = true;
         }
         else
         {
            this.canUseSkill = false;
         }
      }
      
      public function setSkillArr(arr:Array) : void
      {
         this.skillArr = arr;
         this.initShow();
      }
      
      public function changeSkillTime(arr:Array) : void
      {
         var s:int = 0;
         this.skillArr = arr;
         if(this.spiritId < 10000)
         {
            for(s = 0; s < 4; s++)
            {
               if(s < this.skillArr.length)
               {
                  if(Boolean(this._skillList[s]))
                  {
                     this._skillList[s].updatePP(this.skillArr[s].time,this.skillArr[s].maxtime);
                  }
               }
            }
         }
      }
      
      public function updataFilters() : void
      {
         var skillNum:int = 0;
         var xml:XML = null;
         var i:int = 0;
         if(Boolean(this.skillArr))
         {
            skillNum = int(this.skillArr.length);
            if(skillNum < 1)
            {
               return;
            }
            for(i = 0; i < skillNum; i++)
            {
               xml = XMLLocator.getInstance().getSkill(this.skillArr[i].skillid);
               if(Boolean(xml) && Boolean(this._skillList[i]))
               {
                  if(!(this.oprationValue & 0x10000000))
                  {
                     this._skillList[i].isBeUsed(false);
                  }
                  else if(xml && int(xml.skilltype) == 0 && !(this.oprationValue & 0x100000))
                  {
                     this._skillList[i].isBeUsed(false);
                  }
                  else if(xml && int(xml.skilltype) == 1 && !(this.oprationValue & 0x01000000))
                  {
                     this._skillList[i].isBeUsed(false);
                  }
                  else if(Boolean(xml) && this.elemValue.indexOf(int(xml.elem)) != -1)
                  {
                     this._skillList[i].isBeUsed(false);
                  }
                  else if(this.skillArr[i].time > 0)
                  {
                     this._skillList[i].isBeUsed(true);
                  }
               }
            }
            if(Boolean(this._skillList[this.selectId]) && Boolean(this.skillArr[this.selectId]))
            {
               this._skillList[this.selectId].updatePP(this.skillArr[this.selectId].time,this.skillArr[this.selectId].maxtime);
               if(this._skillList[this.selectId].filters != [] && this.out)
               {
                  this.canUseSkill = true;
               }
            }
         }
      }
      
      public function destroy() : void
      {
         var item:BattleSkillItem = null;
         this.nh2b = null;
         ItemTip.instance.hide();
         this.skillArr = null;
         while(this.battleControlMc.numChildren > 0)
         {
            if(this.battleControlMc.getChildAt(0) is MovieClip)
            {
               MovieClip(this.battleControlMc.getChildAt(0)).stop();
            }
            this.battleControlMc.removeChildAt(0);
         }
         if(Boolean(this._skillList))
         {
            for each(item in this._skillList)
            {
               item.removeEventListener(MouseEvent.CLICK,this.onSkillClick);
               item.removeEventListener(MouseEvent.MOUSE_OVER,this.onMouseOverSkill);
               item.removeEventListener(MouseEvent.MOUSE_OUT,this.onMouseOutSkill);
               item.dispose();
            }
         }
         this.battleControlMc.stop();
         this.battleControlMc = null;
      }
      
      override public function set visible(value:Boolean) : void
      {
         super.visible = value;
         this.battleControlMc.visible = value;
      }
      
      public function get elemValue() : Array
      {
         return this._elemValue;
      }
      
      public function set elemValue(value:Array) : void
      {
         this._elemValue = value;
      }
   }
}

