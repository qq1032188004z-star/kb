package com.publiccomponent.util
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   
   public class SpeciaLib
   {
      
      private var specias:Array = [];
      
      public function SpeciaLib()
      {
         super();
      }
      
      private function initialize() : void
      {
      }
      
      public function registerSpeciaInfo($display:DisplayObject, $specia:MovieClip, $state:int = 1, $visible:Boolean = true, $xCoode:Number = 0, $yCoode:Number = 0) : void
      {
         var specia:SpeciaInfo = null;
         if(!this.hasSpecia($display))
         {
            $specia.gotoAndStop($state);
            if(!$visible && Boolean($specia.hasOwnProperty("light")))
            {
               if(Boolean($specia.light))
               {
                  $specia.light.stop();
                  $specia.removeChild($specia.light);
               }
            }
            specia = new SpeciaInfo($display,$specia);
            if($xCoode != 0 || $yCoode != 0)
            {
               specia.setPoint($xCoode,$yCoode);
            }
            this.specias.push(specia);
         }
      }
      
      public function hasSpecia($display:DisplayObject) : Boolean
      {
         var specia:SpeciaInfo = null;
         var bool:Boolean = false;
         for each(specia in this.specias)
         {
            if(specia.display == $display)
            {
               bool = true;
               break;
            }
         }
         return bool;
      }
      
      public function delSpecia($display:DisplayObject) : void
      {
         var info:SpeciaInfo = null;
         for(var i:int = 0; i < this.specias.length; i++)
         {
            info = this.specias[i];
            if(Boolean(info) && info.display == $display)
            {
               info.disport();
               info = null;
               trace("============移除特效 delSpecia============",$display.name);
               this.specias.splice(i,1);
               break;
            }
         }
      }
   }
}

