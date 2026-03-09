package com.game.modules.view.battle
{
   import com.core.observer.MessageEvent;
   import com.game.facade.ApplicationFacade;
   import com.game.locators.GameData;
   import com.game.modules.control.battle.BattleControl;
   import com.game.modules.view.battle.item.BattleSpirit;
   import com.game.modules.view.battle.item.SkillInfo;
   import com.game.util.ColorUtil;
   import com.xygame.module.battle.data.SpiritData;
   import com.xygame.module.battle.event.BattleEvent;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.getTimer;
   
   public class SpiritControlPanel extends Sprite
   {
      
      private static const SPIRIT_COUNT:int = 6;
      
      private static const SPIRIT_SPACING:int = 95;
      
      private static const SPIRIT_OFFSET_X:int = -5;
      
      private static const SPIRIT_OFFSET_Y:int = -30;
      
      private static const CLICK_INTERVAL:int = 2000;
      
      private static const SKILL_INFO_BASE_X:int = 240;
      
      private static const SKILL_INFO_BASE_Y:int = 285;
      
      private var spiritControlMc:MovieClip;
      
      private var _spiritList:Vector.<BattleSpirit>;
      
      private var mySpiritArr:Array;
      
      public var selectSpiritId:int;
      
      private var selectIndex:int = -1;
      
      private var lastSelectTime:int = -CLICK_INTERVAL;
      
      public var isNewRound:Boolean = false;
      
      public function SpiritControlPanel(mc:MovieClip)
      {
         this.spiritControlMc = mc;
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         var spirit:BattleSpirit = null;
         this._spiritList = new Vector.<BattleSpirit>(SPIRIT_COUNT,true);
         for(var i:int = 0; i < SPIRIT_COUNT; i++)
         {
            spirit = new BattleSpirit(i);
            spirit.x = SPIRIT_OFFSET_X + i * SPIRIT_SPACING;
            spirit.y = SPIRIT_OFFSET_Y;
            this.addSpiritListeners(spirit);
            this.spiritControlMc.addChild(spirit);
            this._spiritList[i] = spirit;
         }
      }
      
      private function addSpiritListeners(spirit:BattleSpirit) : void
      {
         spirit.addEventListener(MouseEvent.CLICK,this.onSelectSpiritBattle);
         spirit.addEventListener(MouseEvent.ROLL_OVER,this.onMouseOverSkill);
         spirit.addEventListener(MouseEvent.ROLL_OUT,this.onMouseOutSkill);
      }
      
      private function removeSpiritListeners(spirit:BattleSpirit) : void
      {
         spirit.removeEventListener(MouseEvent.CLICK,this.onSelectSpiritBattle);
         spirit.removeEventListener(MouseEvent.ROLL_OVER,this.onMouseOverSkill);
         spirit.removeEventListener(MouseEvent.ROLL_OUT,this.onMouseOutSkill);
      }
      
      public function newRound() : void
      {
         this.isNewRound = true;
      }
      
      public function setSpiritArr(value:Array) : void
      {
         this.mySpiritArr = value;
         this.updateSpiritsDisplay();
      }
      
      private function updateSpiritsDisplay() : void
      {
         var spirit:BattleSpirit = null;
         if(!this.mySpiritArr || !this._spiritList)
         {
            return;
         }
         var dataLength:int = int(this.mySpiritArr.length);
         for(var i:int = 0; i < SPIRIT_COUNT; i++)
         {
            spirit = this._spiritList[i];
            spirit.visible = i < dataLength;
            if(spirit.visible)
            {
               spirit.setData(this.mySpiritArr[i] as SpiritData);
            }
         }
      }
      
      public function attrInfo(defElem:int) : void
      {
         var spirit:BattleSpirit = null;
         if(!this._spiritList)
         {
            return;
         }
         for each(spirit in this._spiritList)
         {
            if(spirit.visible)
            {
               spirit.attrInfo(defElem);
            }
         }
      }
      
      private function onMouseOverSkill(event:MouseEvent) : void
      {
         var spiritIndex:int = this.getSpiritIndexFromEvent(event);
         if(!this.isValidSpiritIndex(spiritIndex))
         {
            return;
         }
         var showParent:DisplayObjectContainer = this.getBattleView();
         if(!showParent)
         {
            return;
         }
         var skillX:int = SKILL_INFO_BASE_X + (spiritIndex - 1) * 100;
         var skillY:int = SKILL_INFO_BASE_Y;
         SkillInfo.instance().setShow(this.mySpiritArr[spiritIndex].skillArr,showParent,skillX,skillY);
      }
      
      private function onMouseOutSkill(event:MouseEvent) : void
      {
         SkillInfo.instance().hide();
      }
      
      private function onSelectSpiritBattle(event:MouseEvent) : void
      {
         if(!this.isNewRound)
         {
            return;
         }
         var spiritIndex:int = this.getSpiritIndexFromEvent(event);
         if(!this.canSelectSpirit(spiritIndex))
         {
            return;
         }
         this.selectIndex = spiritIndex;
         this.selectSpiritId = this.mySpiritArr[this.selectIndex].uniqueid;
         this.lastSelectTime = getTimer();
         dispatchEvent(new MessageEvent(BattleEvent.SPIRIT_CONTROL_CLICK_EVENT,this.selectIndex));
      }
      
      private function canSelectSpirit(index:int) : Boolean
      {
         if(!this.isValidSpiritIndex(index))
         {
            return false;
         }
         if(index == this.selectIndex)
         {
            return false;
         }
         if(getTimer() - this.lastSelectTime <= CLICK_INTERVAL)
         {
            return false;
         }
         if(this.mySpiritArr[index].hp <= 0)
         {
            return false;
         }
         return true;
      }
      
      private function getSpiritIndexFromEvent(event:MouseEvent) : int
      {
         var name:String = event.currentTarget.name;
         return int(name.charAt(6));
      }
      
      private function isValidSpiritIndex(index:int) : Boolean
      {
         return Boolean(this.mySpiritArr) && index >= 0 && index < this.mySpiritArr.length;
      }
      
      private function getBattleView() : DisplayObjectContainer
      {
         var facade:ApplicationFacade = ApplicationFacade.getInstance();
         var control:* = facade.retrieveViewLogic(BattleControl.NAME);
         return control ? control.getViewComponent() as DisplayObjectContainer : null;
      }
      
      public function setfilters() : void
      {
         var spirit:BattleSpirit = null;
         if(!this._spiritList)
         {
            return;
         }
         var grayFilter:Array = ColorUtil.getColorMatrixFilterGray();
         for each(spirit in this._spiritList)
         {
            spirit.filters = grayFilter;
         }
      }
      
      public function removefilters() : void
      {
         var spirit:BattleSpirit = null;
         if(!this._spiritList || GameData.instance.playerData.isAutoBattle)
         {
            return;
         }
         for each(spirit in this._spiritList)
         {
            spirit.filters = [];
         }
      }
      
      override public function set visible(value:Boolean) : void
      {
         super.visible = value;
         if(Boolean(this.spiritControlMc))
         {
            this.spiritControlMc.visible = value;
         }
      }
      
      public function destroy() : void
      {
         this.destroySpirits();
         this.destroyMovieClip();
         this.clearData();
      }
      
      private function destroySpirits() : void
      {
         var spirit:BattleSpirit = null;
         if(!this._spiritList)
         {
            return;
         }
         for each(spirit in this._spiritList)
         {
            if(Boolean(spirit) && Boolean(spirit.parent))
            {
               spirit.parent.removeChild(spirit);
               this.removeSpiritListeners(spirit);
               spirit.destroy();
            }
         }
         this._spiritList = null;
      }
      
      private function destroyMovieClip() : void
      {
         var child:* = undefined;
         if(!this.spiritControlMc)
         {
            return;
         }
         while(this.spiritControlMc.numChildren > 0)
         {
            child = this.spiritControlMc.getChildAt(0);
            if(child is MovieClip)
            {
               MovieClip(child).stop();
            }
            this.spiritControlMc.removeChildAt(0);
         }
         this.spiritControlMc.stop();
         this.spiritControlMc = null;
      }
      
      private function clearData() : void
      {
         this.mySpiritArr = null;
         this.selectSpiritId = 0;
         this.selectIndex = -1;
         this.lastSelectTime = -CLICK_INTERVAL;
      }
   }
}

