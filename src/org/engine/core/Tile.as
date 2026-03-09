package org.engine.core
{
   import flash.display.Sprite;
   
   public class Tile
   {
      
      public static const BLOCK:uint = 1;
      
      public var x:int;
      
      public var y:int;
      
      public var centerx:int;
      
      public var centery:int;
      
      public var minx:int;
      
      public var maxx:int;
      
      public var miny:int;
      
      public var maxy:int;
      
      public var xindex:int;
      
      public var yindex:int;
      
      public var walkable:uint;
      
      public var astarIndex:int;
      
      public var parent:Tile;
      
      public var f:Number;
      
      public var g:Number;
      
      public var h:Number;
      
      public var tileSize2:int;
      
      public var ui:Sprite;
      
      public var flag:uint;
      
      public function Tile()
      {
         super();
      }
   }
}

