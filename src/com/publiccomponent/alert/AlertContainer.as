package com.publiccomponent.alert
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   
   public class AlertContainer extends Sprite
   {
      
      public static var instance:AlertContainer = new AlertContainer();
      
      private var xCoord:Number;
      
      private var yCoord:Number;
      
      public function AlertContainer()
      {
         super();
      }
      
      public function init(parent:DisplayObjectContainer, xCoord:Number, yCoord:Number) : void
      {
         parent.addChild(this);
         this.xCoord = xCoord;
         this.yCoord = yCoord;
      }
      
      public function addChildXY(child:DisplayObject) : void
      {
         child.x = this.xCoord;
         child.y = this.yCoord;
         this.addChild(child);
      }
      
      public function setX(xCoord:Number) : void
      {
      }
   }
}

