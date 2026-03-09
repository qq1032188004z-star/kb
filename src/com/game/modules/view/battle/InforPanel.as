package com.game.modules.view.battle
{
   import com.game.facade.ApplicationFacade;
   import com.game.locators.GameData;
   import com.game.modules.control.battle.BattleControl;
   import com.game.modules.view.battle.item.ItemTip;
   import com.game.util.BitValueUtil;
   import com.xygame.module.battle.battleItem.BattleRole;
   import com.xygame.module.battle.data.SpiritData;
   import com.xygame.module.battle.event.BattleEvent;
   import flash.display.MovieClip;
   
   public class InforPanel extends BaseInfoPanel
   {
      
      private var _pAry:Array;
      
      private var _oAry:Array;
      
      private var _battleType:int;
      
      private var aa:int = 0;
      
      private var mediator:BattleControl = ApplicationFacade.getInstance().retrieveViewLogic(BattleControl.NAME) as BattleControl;
      
      private var playerHpShow:Boolean = true;
      
      private var playerLevelShow:Boolean = true;
      
      public var otherHpShow:Boolean = true;
      
      public var otherLevelShow:Boolean = true;
      
      private var _toolshowinfo:Boolean = false;
      
      public function InforPanel(mc:MovieClip)
      {
         super(mc);
      }
      
      public function set battleType(value:int) : void
      {
         this._battleType = value;
      }
      
      public function initAry(pAry:Array, oAry:Array) : void
      {
         this._pAry = pAry;
         this._oAry = oAry;
      }
      
      override protected function initOtherShowBool() : void
      {
         var battletype:int = 0;
         var sceneId:int = 0;
         if(GameData.instance.lookBattle == 1)
         {
            this.otherHpShow = true;
            this.otherLevelShow = true;
         }
         else
         {
            battletype = this.mediator.battleView.battleObject.battleType;
            sceneId = GameData.instance.playerData.sceneId;
            if(battletype != 1 && battletype != 8 && battletype != 9)
            {
               this.otherHpShow = false;
               this.otherLevelShow = false;
            }
            if(otherinfo.level > 100)
            {
               this.otherHpShow = false;
               this.otherLevelShow = false;
            }
            if(GameData.instance.playerData.copyScene > 1)
            {
               this.otherHpShow = false;
               this.otherLevelShow = false;
            }
            if(otherinfo.spiritid > 10000)
            {
               this.otherHpShow = BitValueUtil.getBitValue(otherinfo.showlp,1);
               this.otherLevelShow = BitValueUtil.getBitValue(otherinfo.showlp,2);
            }
            if(this.toolshowinfo)
            {
               this.otherHpShow = true;
            }
         }
         if(!this.otherHpShow)
         {
            otherHpNum.text = "???/???";
         }
         else
         {
            otherHpNum.text = otherinfo.hp + "/" + otherinfo.maxhp;
         }
         if(!this.otherLevelShow)
         {
            otherLevel.text = "Lv.???";
         }
         else
         {
            otherLevel.text = "Lv." + otherinfo.level;
         }
      }
      
      override protected function initPlayerShowBool() : void
      {
         if(playerinfo == null && !playerinfo.hasOwnProperty("spiritid"))
         {
            return;
         }
         if(playerinfo.spiritid > 10000)
         {
            this.playerLevelShow = false;
            this.playerHpShow = false;
         }
         else
         {
            this.playerLevelShow = true;
            this.playerHpShow = true;
         }
         if(!this.playerHpShow)
         {
            playerLevel.text = "Lv.???";
            playerHpNum.text = "???/???";
         }
         else
         {
            playerLevel.text = "Lv." + playerinfo.level;
            playerHpNum.text = playerinfo.hp + "/" + playerinfo.maxhp;
         }
      }
      
      public function setSpirits(playerarr:Array, otherarr:Array) : void
      {
         var i:int = 0;
         var hp:int = 0;
         var l:int = 0;
         var tempid:int = 0;
         if(inforPanelMc == null)
         {
            return;
         }
         l = int(this._pAry.length);
         for(i = 0; i < 6; i++)
         {
            hp = l > i ? this.getHP(this._pAry[i],playerarr) : 0;
            inforPanelMc["s" + (i + 1)].gotoAndStop(hp > 0 ? 7 : 1);
         }
         l = int(this._oAry.length);
         if(GameData.instance.lookBattle == 1)
         {
            switch(GameData.instance.newLookType)
            {
               case 1:
               case 2:
                  for(i = 0; i < 6; i++)
                  {
                     hp = l > i ? this.getHP(this._oAry[i],otherarr) : 0;
                     inforPanelMc["o" + (i + 1)].gotoAndStop(hp > 0 ? 7 : 1);
                  }
            }
         }
         else
         {
            tempid = SpiritData(otherarr[0].roleInfo).spiritid;
            if(10500 == tempid || 10504 <= tempid && 10509 >= tempid)
            {
               inforPanelMc["o1"].gotoAndStop(11);
            }
            else if(BattleEvent.NEW_PVP.indexOf(this._battleType) != -1)
            {
               l = int(otherarr.length);
               for(i = 0; i < 6; i++)
               {
                  hp = l > i ? int(otherarr[i].roleInfo.hp) : 1;
                  inforPanelMc["o" + (i + 1)].gotoAndStop(hp > 0 ? 7 : 1);
               }
            }
            else
            {
               for(i = 0; i < 6; i++)
               {
                  hp = l > i ? this.getHP(this._oAry[i],otherarr) : 0;
                  inforPanelMc["o" + (i + 1)].gotoAndStop(hp > 0 ? 7 : 1);
               }
            }
         }
      }
      
      private function getHP(uniqueid:int, ary:Array) : int
      {
         var role:BattleRole = null;
         for each(role in ary)
         {
            if(role.roleInfo.uniqueid == uniqueid)
            {
               return role.roleInfo.hp;
            }
         }
         return 0;
      }
      
      override public function destroy() : void
      {
         ItemTip.instance.hide();
         removeBuf();
         this.mediator = null;
         super.destroy();
      }
      
      public function get toolshowinfo() : Boolean
      {
         return this._toolshowinfo;
      }
      
      public function set toolshowinfo(value:Boolean) : void
      {
         this._toolshowinfo = value;
         if(this._toolshowinfo && otherHpNum && otherHpNum.text && otherinfo && Boolean(otherinfo.maxhp))
         {
            otherHpNum.text = otherinfo.hp + "/" + otherinfo.maxhp;
         }
      }
      
      override protected function countChange() : void
      {
         var p:int = 0;
         var tempvalue:int = 286331153;
         var tempElem:Array = [];
         if(!(this.mediator.battleView.battleObject.battleType == 1 && !this.mediator.battleView.battleObject.newbattle && (otherinfo.catchType == -1 || otherinfo.catchType == 1)))
         {
            tempvalue &= 286327057;
         }
         if(Boolean(playerBufArr))
         {
            for(p = 0; p < playerBufArr.length; p++)
            {
               switch(playerBufArr[p].bufid)
               {
                  case 1:
                     tempvalue &= 69905;
                     break;
                  case 12:
                     tempvalue &= 285282577;
                     break;
                  case 13:
                     tempvalue &= 0;
                     break;
                  case 14:
                     tempvalue &= 269553937;
                     break;
                  case 26:
                     tempvalue &= 0;
                     break;
                  case 27:
                     tempvalue &= 286261265;
                     break;
                  case 28:
                  case 75:
                     tempvalue &= 69649;
                     break;
                  case 31:
                  case 47:
                     tempvalue &= 0;
                     break;
                  case 90:
                     tempElem.push(15);
                     break;
                  case 93:
                     tempvalue &= 286331137;
               }
            }
         }
         this.mediator.battleView.setElemValue(tempElem);
         this.mediator.battleView.oprationValue = tempvalue;
      }
   }
}

