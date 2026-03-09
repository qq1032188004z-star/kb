package com.game.modules.view.team
{
   import com.game.modules.vo.team.PlayerVo;
   import com.game.util.ColorUtil;
   import com.publiccomponent.ui.ToolTip;
   import flash.display.Sprite;
   
   public class TeamBaseItem extends Sprite
   {
      
      protected var _teamPlayerVo:PlayerVo;
      
      public function TeamBaseItem()
      {
         super();
      }
      
      public function get teamPlayerVo() : PlayerVo
      {
         return this._teamPlayerVo;
      }
      
      public function set teamPlayerVo(value:PlayerVo) : void
      {
         this._teamPlayerVo = value;
         this.setShow();
      }
      
      protected function setShow() : void
      {
      }
      
      public function updateSaveScene() : void
      {
         if(this.teamPlayerVo == null)
         {
            return;
         }
         if(this.teamPlayerVo.isSameScene)
         {
            this.filters = [];
            ToolTip.LooseDO(this);
         }
         else
         {
            this.filters = ColorUtil.getColorMatrixFilterGray();
            ToolTip.BindDO(this,"不在附近");
         }
      }
      
      public function clearAll() : void
      {
      }
      
      public function destroy() : void
      {
         ToolTip.LooseDO(this);
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

