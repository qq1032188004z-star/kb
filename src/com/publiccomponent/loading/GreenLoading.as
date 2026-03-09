package com.publiccomponent.loading
{
   import flash.display.DisplayObjectContainer;
   
   public class GreenLoading
   {
      
      public static var loading:Loading = new Loading();
      
      public function GreenLoading()
      {
         super();
      }
      
      public static function registerParent(parent:DisplayObjectContainer, xCoord:Number = 0, yCoord:Number = 0) : void
      {
         loading.x = xCoord;
         loading.y = yCoord;
         parent.addChild(loading);
      }
   }
}

