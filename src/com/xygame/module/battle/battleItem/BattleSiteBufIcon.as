package com.xygame.module.battle.battleItem
{
   import com.game.Tools.SiteBuffIcon;
   import com.game.modules.view.battle.BattleViewManager;
   import com.game.modules.view.battle.item.ItemTip;
   import flash.events.MouseEvent;
   
   public class BattleSiteBufIcon extends SiteBuffIcon
   {
      
      public function BattleSiteBufIcon()
      {
         super();
      }
      
      override protected function onMouseOverBufIcon(event:MouseEvent) : void
      {
         if(Boolean(_tipDesc))
         {
            ItemTip.instance.show({
               "toolname":_tipDesc,
               "tooldesc":""
            },BattleViewManager.getInstance().tipView,this.x + 5,this.y + 8);
         }
      }
      
      override public function set tipDesc(value:String) : void
      {
         _tipDesc = value;
      }
      
      override protected function onMouseOutBufIcon(event:MouseEvent) : void
      {
         ItemTip.instance.hide();
      }
   }
}

