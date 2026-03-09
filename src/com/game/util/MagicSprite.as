package com.game.util
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class MagicSprite extends Sprite
   {
      
      public static var instance:MagicSprite = new MagicSprite();
      
      public function MagicSprite()
      {
         super();
         this.mouseEnabled = false;
      }
      
      public function clean() : void
      {
         var obj:DisplayObject = null;
         while(this.numChildren > 0)
         {
            try
            {
               obj = this.getChildAt(0) as DisplayObject;
               if(obj is MovieClip)
               {
                  obj["stop"]();
               }
               this.removeChild(obj);
               obj = null;
            }
            catch(e:*)
            {
            }
         }
      }
   }
}

