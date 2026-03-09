package com.publiccomponent.util
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   
   public class SpeciaInfo
   {
      
      private var x:Number;
      
      private var y:Number;
      
      public var display:DisplayObject;
      
      public var speciaEffect:MovieClip;
      
      public function SpeciaInfo($display:DisplayObject, $speciaEffect:MovieClip)
      {
         super();
         this.display = $display;
         this.speciaEffect = $speciaEffect;
         this.initialize();
      }
      
      public function setPoint($x:Number, $y:Number) : void
      {
         this.x = $x;
         this.y = $y;
         this.speciaEffect.x = this.x;
         this.speciaEffect.y = this.y;
      }
      
      private function initialize() : void
      {
         if(Boolean(this.display.parent) && this.display.visible)
         {
            this.speciaEffect.visible = true;
            this.speciaEffect.mouseChildren = false;
            this.speciaEffect.mouseEnabled = false;
            this.setPoint(this.display.x + this.display.width / 2,this.display.y + this.display.height / 2);
            this.display.parent.addChild(this.speciaEffect);
         }
      }
      
      public function disport() : void
      {
         if(Boolean(this.speciaEffect))
         {
            this.speciaEffect.stop();
            if(Boolean(this.speciaEffect.parent))
            {
               this.speciaEffect.parent.removeChild(this.speciaEffect);
            }
            this.speciaEffect = null;
         }
      }
   }
}

