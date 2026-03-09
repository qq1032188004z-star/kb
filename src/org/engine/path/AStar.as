package org.engine.path
{
   import org.engine.core.GridMap;
   import org.engine.core.Tile;
   import org.engine.math.MapMath;
   
   public class AStar
   {
      
      public static var astarIndex:int = 1;
      
      public var astarpath:AStarPath;
      
      private var tile:Tile;
      
      private var open:Array = [];
      
      private var close:Array = [];
      
      private var startNode:Tile;
      
      private var destNode:Tile;
      
      private var dxIndex:int;
      
      private var dyIndex:int;
      
      private var mapWidth:int;
      
      private var mapHeight:int;
      
      private var grids:Array;
      
      private var minx:int;
      
      private var maxx:int;
      
      private var miny:int;
      
      private var maxy:int;
      
      private var d:Number;
      
      private var dx:int;
      
      private var dy:int;
      
      public function AStar()
      {
         super();
         this.astarpath = new AStarPath();
      }
      
      public function find(start:Tile, dest:Tile, map:GridMap, isLimite:Boolean = true) : Boolean
      {
         var x:int = 0;
         var y:int = 0;
         var nei:Tile = null;
         var g:Number = NaN;
         var h:Number = NaN;
         var f:Number = NaN;
         ++astarIndex;
         if(dest == null)
         {
            return false;
         }
         if(start == null)
         {
            return false;
         }
         if(isLimite)
         {
            if((dest.walkable & Tile.BLOCK) != 0)
            {
               return false;
            }
         }
         this.startNode = start;
         this.destNode = dest;
         this.open.length = 0;
         this.close.length = 0;
         this.grids = map.grids;
         dest.parent = null;
         this.dxIndex = dest.xindex;
         this.dyIndex = dest.yindex;
         this.mapWidth = map.width;
         this.mapHeight = map.height;
         start.g = 0;
         start.h = 0;
         start.f = start.g + start.h;
         start.astarIndex = astarIndex;
         start.parent = null;
         this.tile = start;
         while(this.tile != dest)
         {
            this.minx = MapMath.max(0,this.tile.xindex - 1);
            this.maxx = MapMath.min(this.tile.xindex + 1,this.mapWidth - 1);
            this.miny = MapMath.max(0,this.tile.yindex - 1);
            this.maxy = MapMath.min(this.tile.yindex + 1,this.mapHeight - 1);
            for(x = this.minx; x <= this.maxx; x++)
            {
               for(y = this.miny; y <= this.maxy; y++)
               {
                  nei = this.grids[x][y] as Tile;
                  if(isLimite)
                  {
                     if(nei == this.tile || (nei.walkable & Tile.BLOCK) != 0)
                     {
                        continue;
                     }
                  }
                  this.d = MapMath.SQRT2;
                  this.dx = this.tile.xindex - nei.xindex;
                  this.dy = this.tile.yindex - nei.yindex;
                  if(this.dx == 0 || this.dy == 0)
                  {
                     this.d = 1;
                  }
                  g = this.tile.g + this.d;
                  this.dx = this.dxIndex - nei.xindex;
                  this.dy = this.dyIndex - nei.yindex;
                  this.d = Math.sqrt(this.dx * this.dx + this.dy * this.dy);
                  h = this.d;
                  f = g + h;
                  if(nei.astarIndex == astarIndex)
                  {
                     if(nei.f > f)
                     {
                        nei.f = f;
                        nei.g = g;
                        nei.h = h;
                        nei.parent = this.tile;
                     }
                  }
                  else
                  {
                     nei.f = f;
                     nei.h = h;
                     nei.g = g;
                     nei.parent = this.tile;
                     nei.astarIndex = astarIndex;
                     this.open[this.open.length] = nei;
                  }
               }
            }
            this.close[this.close.length] = this.tile;
            if(this.open.length == 0)
            {
               return false;
            }
            this.open.sortOn("f",Array.NUMERIC);
            this.tile = this.open.shift() as Tile;
         }
         this.buildPath();
         return true;
      }
      
      private function buildPath() : void
      {
         ++astarIndex;
         this.astarpath.nodes.length = 0;
         var node:Tile = this.destNode;
         while(node != this.startNode)
         {
            this.astarpath.nodes.unshift(node);
            node.astarIndex = astarIndex;
            node = node.parent;
         }
         node.astarIndex = astarIndex;
         this.astarpath.nodes.unshift(node);
         this.astarpath.astarIndex = astarIndex;
         this.astarpath.startNode = this.startNode;
         this.astarpath.destNode = this.destNode;
      }
   }
}

