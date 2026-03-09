package org.dress.ui
{
   public class BasePet extends BaseDecoration
   {
      
      private var petId:int;
      
      private var xOffset:Number = 0;
      
      private var yOffset:Number = 0;
      
      private var tempMy:MyBitmapData;
      
      public function BasePet(rowCount:int = 4, decorationType:int = 7)
      {
         super(rowCount,decorationType);
      }
      
      public function setPetId(value:int) : void
      {
         this.petId = value;
      }
      
      override public function render(direction:int = 0, pointer:int = 0) : void
      {
         if(direction == 2)
         {
            direction = 0;
            this.scaleX = -1;
         }
         else if(direction == 3)
         {
            direction = 1;
            this.scaleX = -1;
         }
         else
         {
            this.scaleX = 1;
         }
         if(Boolean(decorationVo) && decorationVo.bitmapDataArr[direction] != null)
         {
            this.tempMy = decorationVo.bitmapDataArr[direction][pointer];
            if(this.tempMy != null)
            {
               if(this.scaleX == -1)
               {
                  this.x = -this.tempMy.x + 55 + this.xOffset;
               }
               else
               {
                  this.x = -(decorationVo.pWidth - this.tempMy.x) + 55 + this.xOffset;
               }
               this.y = -(decorationVo.pHeight - this.tempMy.y) + 40 + this.yOffset;
               bitmapData = this.tempMy.bit_data;
            }
         }
      }
   }
}

