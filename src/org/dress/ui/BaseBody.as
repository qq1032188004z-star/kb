package org.dress.ui
{
   import flash.geom.Point;
   
   public class BaseBody extends BaseDecoration
   {
      
      public function BaseBody(rowCount:int = 4, decorationType:int = 2)
      {
         super(rowCount,decorationType);
      }
      
      public function isActive(xCoord:Number, yCoord:Number) : Boolean
      {
         var active:Boolean = false;
         if(this.bitmapData == null)
         {
            return false;
         }
         var localpos:Point = this.globalToLocal(new Point(xCoord,yCoord));
         var color:uint = this.bitmapData.getPixel32(localpos.x,localpos.y);
         color >>= 24;
         if(color != 0)
         {
            active = true;
         }
         return active;
      }
   }
}

