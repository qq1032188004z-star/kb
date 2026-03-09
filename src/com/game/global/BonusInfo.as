package com.game.global
{
   import com.game.util.ToolTipStringUtil;
   
   public class BonusInfo
   {
      
      public var toolid:int;
      
      public var num:int;
      
      public var itemType:int;
      
      public function BonusInfo()
      {
         super();
      }
      
      public function get toolName() : String
      {
         if(this.itemType == ItemType.ITEM_TYPE_MONSTER)
         {
            return ToolTipStringUtil.getSpriteName(this.toolid);
         }
         return ToolTipStringUtil.getToolName(this.toolid);
      }
   }
}

