package com.publiccomponent.ui
{
   import flash.display.Sprite;
   import flash.filters.GlowFilter;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol372")]
   public class Label extends Sprite
   {
      
      private var glow:GlowFilter;
      
      public var labelTxt:TextField;
      
      public function Label(x:Number = 0, y:Number = 0, txtColor:uint = 16777215, fitcolor:uint = 16777215, filter:Boolean = true)
      {
         super();
         this.mouseEnabled = false;
         this.labelTxt.mouseWheelEnabled = false;
         this.labelTxt.defaultTextFormat = new TextFormat("宋体",12,16777215);
         this.x = x;
         this.y = y;
         this.labelTxt.textColor = txtColor;
         this.cacheAsBitmap = true;
         if(filter)
         {
            this.glow = new GlowFilter(0,1,2,2,100,1,false,false);
            this.labelTxt.filters = [this.glow];
         }
      }
      
      public function dispos() : void
      {
         if(this.parent != null)
         {
            if(this.parent.contains(this))
            {
               this.parent.removeChild(this);
            }
         }
      }
   }
}

