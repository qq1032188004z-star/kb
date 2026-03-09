package org.dress.ui
{
   public class BaseFace extends BaseDecoration
   {
      
      private var _curVisible:Boolean;
      
      public function BaseFace(rowCount:int = 4, decorationType:int = 6)
      {
         super(rowCount,decorationType);
      }
      
      override public function render(direction:int = 0, pointer:int = 0) : void
      {
         if(direction == 0 || direction == 2)
         {
            super.render(direction,pointer);
         }
      }
      
      override public function set visible(value:Boolean) : void
      {
         super.visible = value;
      }
   }
}

