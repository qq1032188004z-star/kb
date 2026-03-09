package org.engine.core
{
   import flash.display.DisplayObjectContainer;
   
   public class Viewport
   {
      
      public var container:DisplayObjectContainer;
      
      public var width:Number;
      
      public var height:Number;
      
      public function Viewport(width:Number, height:Number)
      {
         super();
         this.width = width;
         this.height = height;
      }
   }
}

