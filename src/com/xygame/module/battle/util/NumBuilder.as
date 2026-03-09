package com.xygame.module.battle.util
{
   import flash.display.Sprite;
   import flash.system.ApplicationDomain;
   
   public class NumBuilder
   {
      
      private static var md:int = 5;
      
      public static var mcover:String = "mcoverplayer";
      
      public function NumBuilder()
      {
         super();
      }
      
      public static function buildBlue(value:int, scale:Number) : Sprite
      {
         var temp:Sprite = null;
         var index:String = null;
         var charobj:Object = null;
         var xoffset:int = 0;
         var num:Sprite = new Sprite();
         var plusObj:Object = ApplicationDomain.currentDomain.getDefinition("blueadd");
         var charColor:String = "";
         if(value > 0)
         {
            temp = new plusObj();
            num.addChild(temp);
            xoffset += temp.width + md;
            charColor = "blue";
         }
         var valueStr:String = value.toString();
         var i:int = 0;
         while(i < valueStr.length)
         {
            index = valueStr.charAt(i);
            index = charColor + index;
            charobj = ApplicationDomain.currentDomain.getDefinition(index);
            temp = new charobj();
            num.addChild(temp);
            temp.x = xoffset;
            xoffset += temp.width + md;
            i++;
         }
         num.scaleX = num.scaleY = scale;
         return num;
      }
      
      public static function build(value:int, scale:Number, sign:Boolean = true, miss:Boolean = true) : Sprite
      {
         var temp:Sprite = null;
         var mo:Object = null;
         var charobj1:Object = null;
         var index:String = null;
         var charobj:Object = null;
         var xoffset:int = 0;
         var num:Sprite = new Sprite();
         var plusObj:Object = ApplicationDomain.currentDomain.getDefinition("greenadd");
         var descObj:Object = ApplicationDomain.currentDomain.getDefinition("redjian");
         var charColor:String = "";
         if(value == 0 && miss)
         {
            mo = ApplicationDomain.currentDomain.getDefinition("miss");
            temp = new mo();
            num.addChild(temp);
            return num;
         }
         if(value == 0 && !miss)
         {
            temp = new descObj();
            num.addChild(temp);
            xoffset += temp.width + md;
            charobj1 = ApplicationDomain.currentDomain.getDefinition("red0");
            temp = new charobj1();
            temp.x = xoffset;
            num.addChild(temp);
            num.scaleX = num.scaleY = scale;
            return num;
         }
         if(sign == true)
         {
            if(value > 0)
            {
               temp = new plusObj();
               num.addChild(temp);
               xoffset += temp.width + md;
               charColor = "green";
            }
            else
            {
               temp = new descObj();
               num.addChild(temp);
               xoffset += temp.width + md;
               value = -value;
               charColor = "red";
            }
         }
         var valueStr:String = value.toString();
         var i:int = 0;
         while(i < valueStr.length)
         {
            index = valueStr.charAt(i);
            index = charColor + index;
            charobj = ApplicationDomain.currentDomain.getDefinition(index);
            temp = new charobj();
            num.addChild(temp);
            temp.x = xoffset;
            xoffset += temp.width + md;
            i++;
         }
         num.scaleX = num.scaleY = scale;
         return num;
      }
   }
}

