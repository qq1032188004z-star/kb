package org.dress.ui
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol369")]
   public class BaseAlphaObject extends MovieClip
   {
      
      public function BaseAlphaObject()
      {
         super();
         this.y = -101;
         this.x = -26;
      }
      
      public function dispos() : void
      {
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

