package com.game.util
{
   import com.publiccomponent.ui.ToolTip;
   import flash.display.Bitmap;
   import flash.display.InteractiveObject;
   import flash.geom.Point;
   
   public class ComponetUtil
   {
      
      public function ComponetUtil()
      {
         super();
      }
      
      public static function enabledComponent(obj:InteractiveObject) : void
      {
         obj.filters = null;
         obj.mouseEnabled = true;
         ToolTip.LooseDO(obj);
      }
      
      public static function disabledComponent(obj:InteractiveObject) : void
      {
         obj.filters = ColorUtil.getColorMatrixFilterGray();
         obj.mouseEnabled = false;
      }
      
      public static function disabledWithTips(obj:InteractiveObject, msg:String) : void
      {
         obj.filters = ColorUtil.getColorMatrixFilterGray();
         if(Boolean(ToolTip.TestDOBinding(obj)))
         {
            ToolTip.setDOInfo(obj,msg);
         }
         else
         {
            ToolTip.BindDO(obj,msg);
         }
      }
      
      public static function isHoverBmp(bmp:Bitmap, xCoord:Number, yCoord:Number) : Boolean
      {
         var active:Boolean = false;
         if(bmp == null || bmp.bitmapData == null)
         {
            return false;
         }
         var localpos:Point = bmp.globalToLocal(new Point(xCoord,yCoord));
         var color:uint = bmp.bitmapData.getPixel32(localpos.x,localpos.y);
         color >>= 24;
         if(color > 50)
         {
            active = true;
         }
         return active;
      }
   }
}

