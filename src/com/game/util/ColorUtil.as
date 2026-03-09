package com.game.util
{
   import flash.filters.BevelFilter;
   import flash.filters.BlurFilter;
   import flash.filters.ColorMatrixFilter;
   import flash.filters.ConvolutionFilter;
   import flash.filters.DisplacementMapFilter;
   import flash.filters.DropShadowFilter;
   import flash.filters.GlowFilter;
   import flash.filters.GradientBevelFilter;
   import flash.filters.GradientGlowFilter;
   
   public class ColorUtil
   {
      
      public function ColorUtil()
      {
         super();
      }
      
      public static function getTest() : Array
      {
         var f:GradientGlowFilter = new GradientGlowFilter(4,45,[16777215,16711680,16776960,52479],null,null,4,4,1,1,"inner",false);
         return [f];
      }
      
      public static function getColorMatrixFilterShine() : Array
      {
         var f:ColorMatrixFilter = new ColorMatrixFilter([1,0,0,0,35,0,1,0,0,35,0,0,1,0,35,0,0,0,1,0]);
         return [f];
      }
      
      public static function getColorMatrixFilterShine1() : Array
      {
         var f:ColorMatrixFilter = new ColorMatrixFilter([1,0,0,0,20,0,1,0,0,20,0,0,1,0,20,0,0,0,1,0]);
         return [f];
      }
      
      public static function getColorMatrixFilterGray() : Array
      {
         var f:ColorMatrixFilter = new ColorMatrixFilter([0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0,0,0,1,0]);
         return [f];
      }
      
      public static function getColorMatrixFilterDarkle() : Array
      {
         var f:ColorMatrixFilter = new ColorMatrixFilter([1,0,0,0,20,0,1,0,0,20,0,0,1,NaN,20,0,0,0,0.5,0]);
         return [f];
      }
      
      public static function getDisplacementMapFilter() : Array
      {
         var f:DisplacementMapFilter = new DisplacementMapFilter(null,null,0,0,0,0,"wrap",0,0);
         return [f];
      }
      
      public static function getGradientGlowFilter() : Array
      {
         var f:GradientGlowFilter = new GradientGlowFilter(4,45,[16777215,16711680,16776960,52479],[0.2,0.2,0.2,0.2,0.2],[0,63,126,255],4,4,1,1,"inner",false);
         return [f];
      }
      
      public static function getGradientBevelFilter() : Array
      {
         var f:GradientBevelFilter = new GradientBevelFilter(4,45,[11206400,65433,16724787],[1,0,0.5],[30,128,255],4,4,1,1,"inner",false);
         return [f];
      }
      
      public static function getDropShadowFilter() : Array
      {
         var f:DropShadowFilter = new DropShadowFilter(4,45,11206400,1,4,4,1,1,false,false,false);
         return [f];
      }
      
      public static function getConvolutionFilter() : Array
      {
         var f:ConvolutionFilter = new ConvolutionFilter(0,0,null,1,0,true,true,0,0);
         return [f];
      }
      
      public static function getBlurFilter() : Array
      {
         var f:BlurFilter = new BlurFilter(3,3,1);
         return [f];
      }
      
      public static function getBevelFilter() : Array
      {
         var f:BevelFilter = new BevelFilter(4,45,11206400,1,16777215,1,4,4,1,1,"inner",false);
         return [f];
      }
      
      public static function getGrowFilter() : Array
      {
         var f:GlowFilter = new GlowFilter(16711680,1,6,6,2,1,false,false);
         return [f];
      }
      
      public static function setGrowFilter(color:uint) : Array
      {
         var f:GlowFilter = new GlowFilter(color,1,6,6,2,1,false,false);
         return [f];
      }
      
      public static function getHaloFilter() : Array
      {
         var f:GradientGlowFilter = new GradientGlowFilter(15,45,[16711680,65280],[1,0],[0,360]);
         return [f];
      }
   }
}

