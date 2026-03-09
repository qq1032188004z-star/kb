package com.game.modules.view.battle.other
{
   import com.publiccomponent.loading.XMLLocator;
   import com.publiccomponent.loading.data.SiteBuffTypeData;
   import com.xygame.module.battle.battleItem.BattleSiteBufIcon;
   import com.xygame.module.battle.data.BattleDefine;
   import flash.display.Sprite;
   
   public class BattleSiteView extends Sprite
   {
      
      private var _playIcon:BattleSiteBufIcon;
      
      private var _otherIcon:BattleSiteBufIcon;
      
      private var _monsterList:Array;
      
      private var _curSiteVO:SiteBuffTypeData;
      
      public function BattleSiteView()
      {
         super();
         this._playIcon = new BattleSiteBufIcon();
         this._playIcon.x = 250;
         this._playIcon.y = 50;
         addChild(this._playIcon);
         this._otherIcon = new BattleSiteBufIcon();
         this._otherIcon.x = 700;
         this._otherIcon.y = 50;
         addChild(this._otherIcon);
         this._monsterList = [0,0];
      }
      
      public function getCurSite() : SiteBuffTypeData
      {
         if(Boolean(this._curSiteVO))
         {
            return this._curSiteVO;
         }
         return null;
      }
      
      public function addSite(id:int) : void
      {
         if(this._curSiteVO == null || this._curSiteVO.id != id)
         {
            this._curSiteVO = XMLLocator.getInstance().getSiteInfo(id);
            this.updateView();
         }
      }
      
      public function removeSite(id:int) : void
      {
         if(Boolean(this._curSiteVO) && this._curSiteVO.id == id)
         {
            this._curSiteVO = null;
            this.updateView();
         }
      }
      
      public function updateMonster(id:int, index:int) : void
      {
         this._monsterList[index] = id;
         this.updateView();
      }
      
      public function dispose() : void
      {
         if(Boolean(this._otherIcon))
         {
            this._otherIcon.dispose();
            this._otherIcon = null;
         }
         if(Boolean(this._playIcon))
         {
            this._playIcon.dispose();
            this._playIcon = null;
         }
      }
      
      private function updateView() : void
      {
         this.updateIcon();
         BattleDefine.instance.setBufShowIndex(0,this._playIcon.visible ? 1 : 0);
         BattleDefine.instance.setBufShowIndex(1,this._otherIcon.visible ? 1 : 0);
      }
      
      private function updateIcon() : void
      {
         if(!this._curSiteVO)
         {
            this._playIcon.visible = false;
            this._otherIcon.visible = false;
            return;
         }
         var obj:Object = this._curSiteVO.monster_desc;
         this.updateSingleIcon(this._playIcon,obj,this._monsterList[0]);
         this.updateSingleIcon(this._otherIcon,obj,this._monsterList[1]);
      }
      
      private function updateSingleIcon(icon:BattleSiteBufIcon, obj:Object, monsterKey:String) : void
      {
         if(obj.hasOwnProperty(monsterKey))
         {
            icon.visible = true;
            icon.setSite(this._curSiteVO.id);
            icon.tipDesc = XMLLocator.getInstance().getSiteDesc(obj[monsterKey]).desc;
         }
         else
         {
            icon.visible = false;
         }
      }
   }
}

