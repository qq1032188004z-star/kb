package com.game.util
{
   import flash.display.Sprite;
   import flash.system.ApplicationDomain;
   
   public class StaticMethod
   {
      
      public function StaticMethod()
      {
         super();
      }
      
      public static function creatImageText(sc:ApplicationDomain, parentC:Sprite, textAlign:String = "center", namePrefix:String = "num_", horizontalGap:int = -2) : ImageFont
      {
         var imageText:ImageFont = new ImageFont();
         imageText.align = textAlign;
         imageText.resource = sc;
         imageText.namePrefix = namePrefix;
         imageText.horizontalGap = horizontalGap;
         parentC.addChild(imageText);
         imageText.text = "0";
         return imageText;
      }
   }
}

