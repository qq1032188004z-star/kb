package com.game.dohko.util
{
   import flash.display.DisplayObject;
   import flash.filters.BitmapFilter;
   import flash.filters.BitmapFilterQuality;
   import flash.filters.ColorMatrixFilter;
   import flash.filters.GlowFilter;
   
   public class FilterUtil
   {
      
      public function FilterUtil()
      {
         super();
      }
      
      public static function getContrastFilter(_arg1:Number) : ColorMatrixFilter
      {
         var _local2:Number = _arg1 * 11;
         var _local3:Number = 63.5 - _arg1 * 698.5;
         var _local4:Array = [_local2,0,0,0,_local3,0,_local2,0,0,_local3,0,0,_local2,0,_local3,0,0,0,1,0];
         return new ColorMatrixFilter(_local4);
      }
      
      public static function setGrey(obj:DisplayObject) : void
      {
         obj.filters = [new ColorMatrixFilter([0.4,0.4,0.4,0,0,0.4,0.4,0.4,0,0,0.4,0.4,0.4,0,0,0,0,0,1,0])];
      }
      
      public static function getWhilteBlankFilters() : Array
      {
         var matrix:Array = new Array();
         matrix = matrix.concat([255,255,255,0,0]);
         matrix = matrix.concat([255,255,255,0,0]);
         matrix = matrix.concat([255,255,255,0,0]);
         matrix = matrix.concat([0,0,0,1,0]);
         var blank:ColorMatrixFilter = new ColorMatrixFilter(matrix);
         return [blank];
      }
      
      public static function getGrayFilter($colorRate:Number = 0.4) : BitmapFilter
      {
         var matrix:Array = new Array();
         matrix = matrix.concat([$colorRate,$colorRate,$colorRate,0,0]);
         matrix = matrix.concat([$colorRate,$colorRate,$colorRate,0,0]);
         matrix = matrix.concat([$colorRate,$colorRate,$colorRate,0,0]);
         matrix = matrix.concat([0,0,0,1,0]);
         return new ColorMatrixFilter(matrix);
      }
      
      public static function filtersGray($dis:DisplayObject) : void
      {
         var matrix:Array = new Array();
         matrix = matrix.concat([0.3086,0.6094,0.082,0,0]);
         matrix = matrix.concat([0.3086,0.6094,0.082,0,0]);
         matrix = matrix.concat([0.3086,0.6094,0.082,0,0]);
         matrix = matrix.concat([0,0,0,1,0]);
         var gray:ColorMatrixFilter = new ColorMatrixFilter(matrix);
         var filtersArray:Array = new Array(gray);
         $dis.filters = filtersArray;
      }
      
      public static function filtersCancel($dis:DisplayObject) : void
      {
         $dis.filters = [];
      }
      
      public static function externalLight($dis:DisplayObject, $fitcolor:uint = 16777215, $alpha:Number = 1, $blurx:Number = 5, $blury:Number = 5, $strength:Number = 5, $inner:Boolean = false, $knockout:Boolean = false) : void
      {
         var glow:GlowFilter = new GlowFilter();
         glow.color = $fitcolor;
         glow.alpha = $alpha;
         glow.blurX = $blurx;
         glow.blurY = $blury;
         glow.strength = $strength;
         glow.quality = BitmapFilterQuality.HIGH;
         glow.inner = $inner;
         glow.knockout = $knockout;
         $dis.filters = [glow];
      }
      
      public static function getRedGlowFilter() : BitmapFilter
      {
         var color:Number = 16711680;
         var alpha:Number = 0.8;
         var blurX:Number = 20;
         var blurY:Number = 20;
         var strength:Number = 2;
         var inner:Boolean = false;
         var knockout:Boolean = false;
         var quality:Number = BitmapFilterQuality.HIGH;
         return new GlowFilter(color,alpha,blurX,blurY,strength,quality,inner,knockout);
      }
      
      public static function createSaturationFilter(n:Number) : ColorMatrixFilter
      {
         return new ColorMatrixFilter([0.3086 * (1 - n) + n,0.6094 * (1 - n),0.082 * (1 - n),0,0,0.3086 * (1 - n),0.6094 * (1 - n) + n,0.082 * (1 - n),0,0,0.3086 * (1 - n),0.6094 * (1 - n),0.082 * (1 - n) + n,0,0,0,0,0,1,0]);
      }
      
      public static function createContrastFilter(n:Number) : ColorMatrixFilter
      {
         return new ColorMatrixFilter([n,0,0,0,128 * (1 - n),0,n,0,0,128 * (1 - n),0,0,n,0,128 * (1 - n),0,0,0,1,0]);
      }
      
      public static function createBrightnessFilter(n:Number) : ColorMatrixFilter
      {
         return new ColorMatrixFilter([1,0,0,0,n,0,1,0,0,n,0,0,1,0,n,0,0,0,1,0]);
      }
   }
}

