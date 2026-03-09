package org.engine.core
{
   import org.json.JSON;
   
   public class GridMap
   {
      
      public var grids:Array;
      
      public var width:int;
      
      public var height:int;
      
      public var tileSize:int;
      
      public var tileSize2:int;
      
      public function GridMap(w:int, h:int, s:int)
      {
         super();
         this.width = w;
         this.height = h;
         this.tileSize = s;
         this.tileSize2 = s / 2;
         this.grids = [];
      }
      
      public function initGrids(w:int, h:int, s:int) : void
      {
         var y:int = 0;
         var tile:Tile = null;
         this.width = w;
         this.height = h;
         this.tileSize = s;
         this.tileSize2 = s / 2;
         this.grids.length = 0;
         var xoffset:int = 0;
         var yoffset:int = 0;
         for(var x:int = 0; x < this.width; x++)
         {
            this.grids[x] = [];
            yoffset = 0;
            for(y = 0; y < this.height; y++)
            {
               tile = new Tile();
               tile.x = xoffset;
               tile.y = yoffset;
               tile.centerx = xoffset + this.tileSize2;
               tile.centery = yoffset + this.tileSize2;
               tile.xindex = x;
               tile.yindex = y;
               tile.tileSize2 = this.tileSize2;
               this.grids[x][y] = tile;
               yoffset += this.tileSize;
            }
            xoffset += this.tileSize;
         }
      }
      
      public function setBlocks(bitmapstr:String) : void
      {
         var rows:Array = null;
         var x:int = 0;
         var tile:Tile = null;
         var bitmap:Array = JSON.decode(bitmapstr);
         if(bitmap == null)
         {
            return;
         }
         for(var y:int = 0; y < bitmap.length; y++)
         {
            rows = bitmap[y] as Array;
            for(x = 0; x < rows.length; x++)
            {
               tile = this.getTileByIndex(x,y);
               if(tile != null)
               {
                  if(bitmap[y][x] == 1 || bitmap[y][x] == "1")
                  {
                     tile.walkable |= Tile.BLOCK;
                  }
                  else
                  {
                     tile.walkable &= ~Tile.BLOCK;
                  }
               }
            }
         }
      }
      
      public function getTileByIndex(xindex:int, yindex:int) : Tile
      {
         var tile:Tile = null;
         if(xindex < 0 || yindex < 0 || this.grids == null)
         {
            return null;
         }
         var gridlen:int = int(this.grids.length);
         if(xindex < gridlen)
         {
            if(yindex < this.grids[xindex].length)
            {
               tile = this.grids[xindex][yindex];
            }
            else
            {
               tile = this.grids[xindex][this.grids[xindex].length];
            }
         }
         else if(yindex < this.grids[gridlen - 1].length)
         {
            tile = this.grids[gridlen - 1][yindex];
         }
         else
         {
            tile = this.grids[gridlen - 1][this.grids[gridlen - 1].length];
         }
         return tile;
      }
      
      public function getTileByPos(x:Number, y:Number) : Tile
      {
         var xindex:int = Math.floor(x / this.tileSize);
         var yindex:int = Math.floor(y / this.tileSize);
         return this.getTileByIndex(xindex,yindex);
      }
      
      public function getIndexObjByPos(x:Number, y:Number) : Object
      {
         return {
            "xindex":Math.floor(x / this.tileSize),
            "yindex":Math.floor(y / this.tileSize)
         };
      }
      
      public function toBlockBitmap() : String
      {
         var x:int = 0;
         var tile:Tile = null;
         var res:String = "[\n";
         for(var y:int = 0; y < this.height; y++)
         {
            res += "[";
            for(x = 0; x < this.width; x++)
            {
               tile = this.getTileByIndex(x,y);
               if((tile.walkable & Tile.BLOCK) != 0)
               {
                  res += "1";
               }
               else
               {
                  res += "0";
               }
               if(x != this.width - 1)
               {
                  res += ",";
               }
            }
            if(y == this.height - 1)
            {
               res += "]\n";
            }
            else
            {
               res += "],\n";
            }
         }
         return res + "]\n";
      }
      
      public function enableSomePlace(indexList:Array) : void
      {
         var indexObj:Object = null;
         var tile:Tile = null;
         for each(indexObj in indexList)
         {
            tile = this.grids[indexObj.xindex][indexObj.yindex];
            if(tile != null)
            {
               tile.walkable = 0;
            }
         }
      }
      
      public function diableSomePlace(indexList:Array) : void
      {
         var indexObj:Object = null;
         var tile:Tile = null;
         for each(indexObj in indexList)
         {
            tile = this.grids[indexObj.xindex][indexObj.yindex];
            if(tile != null)
            {
               tile.walkable = 1;
            }
         }
      }
   }
}

