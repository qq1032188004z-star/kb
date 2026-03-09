package com.game.util
{
   import flash.display.FrameLabel;
   import flash.display.MovieClip;
   
   public class MovieClipUtil
   {
      
      public function MovieClipUtil()
      {
         super();
      }
      
      public static function stopMovieClip(targetMc:MovieClip) : void
      {
         var i:int = 0;
         var mc:MovieClip = null;
         targetMc.stop();
         var num:Number = targetMc.numChildren;
         for(i = num - 1; i >= 0; i--)
         {
            mc = targetMc.getChildAt(i) as MovieClip;
            if(Boolean(mc))
            {
               mc.stop();
               stopMovieClip(mc);
            }
         }
      }
      
      public static function stopMovieClipToStart(targetMc:MovieClip) : void
      {
         var i:int = 0;
         var mc:MovieClip = null;
         targetMc.gotoAndStop(1);
         var num:Number = targetMc.numChildren;
         for(i = num - 1; i >= 0; i--)
         {
            mc = targetMc.getChildAt(i) as MovieClip;
            if(Boolean(mc))
            {
               mc.gotoAndStop(1);
               stopMovieClip(mc);
            }
         }
      }
      
      public static function startMovieClip(targetMc:MovieClip) : void
      {
         var i:int = 0;
         var mc:MovieClip = null;
         targetMc.play();
         var num:Number = targetMc.numChildren;
         for(i = num - 1; i >= 0; i--)
         {
            mc = targetMc.getChildAt(i) as MovieClip;
            if(Boolean(mc))
            {
               mc.play();
               stopMovieClip(mc);
            }
         }
      }
      
      public static function startMovieClipFromStart(targetMc:MovieClip) : void
      {
         var i:int = 0;
         var mc:MovieClip = null;
         targetMc.gotoAndPlay(1);
         var num:Number = targetMc.numChildren;
         for(i = num - 1; i >= 0; i--)
         {
            mc = targetMc.getChildAt(i) as MovieClip;
            if(Boolean(mc))
            {
               mc.gotoAndPlay(1);
               startMovieClipFromStart(mc);
            }
         }
      }
      
      public static function isHaveFrameLable(targetMc:MovieClip, label:String) : Boolean
      {
         var num:uint = 0;
         var fLabel:FrameLabel = null;
         var i:int = 0;
         var arr:Array = targetMc.currentLabels;
         if(Boolean(arr) && Boolean(arr.length))
         {
            num = arr.length;
            for(i = 0; i < num; i++)
            {
               fLabel = arr[i] as FrameLabel;
               if(Boolean(fLabel) && fLabel.name == label)
               {
                  return true;
               }
            }
         }
         return false;
      }
   }
}

