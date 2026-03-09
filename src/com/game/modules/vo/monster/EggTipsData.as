package com.game.modules.vo.monster
{
   import flash.display.DisplayObject;
   
   public class EggTipsData
   {
      
      public var target:DisplayObject;
      
      public var value:*;
      
      public var qName:String = "";
      
      public var tx:Number = 0;
      
      public var ty:Number = 0;
      
      public function EggTipsData($target:DisplayObject, $value:*, $qName:String = "")
      {
         super();
         this.target = $target;
         this.value = $value;
         this.qName = $qName;
      }
      
      public function disport() : void
      {
         this.target = null;
         this.value = null;
         this.tx = 0;
         this.ty = 0;
      }
   }
}

