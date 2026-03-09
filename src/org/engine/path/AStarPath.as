package org.engine.path
{
   import org.engine.core.Tile;
   
   public class AStarPath
   {
      
      public var nodes:Array = [];
      
      public var startNode:Tile;
      
      public var destNode:Tile;
      
      public var astarIndex:int;
      
      public var startx:Number;
      
      public var starty:Number;
      
      public var destx:Number;
      
      public var desty:Number;
      
      public var points:Array = [];
      
      public function AStarPath()
      {
         super();
      }
      
      public function toPoints() : void
      {
         var node:Tile = null;
         var nextNode:Tile = null;
         var xoffset:int = 0;
         var yoffset:int = 0;
         this.points.length = 0;
         if(this.startNode == this.destNode)
         {
            this.points.push({
               "x":this.destx,
               "y":this.desty
            });
            return;
         }
         for(var i:int = 0; i < this.nodes.length; i++)
         {
            node = this.nodes[i] as Tile;
            if(node == this.destNode)
            {
               this.points.push({
                  "x":this.destx,
                  "y":this.desty
               });
            }
            else
            {
               nextNode = this.nodes[i + 1] as Tile;
               if(nextNode.xindex != node.xindex)
               {
                  if(nextNode.yindex != node.yindex)
                  {
                     xoffset = 0;
                     yoffset = 0;
                     if(nextNode.xindex - node.xindex == 1)
                     {
                        xoffset = nextNode.tileSize2;
                     }
                     else
                     {
                        xoffset = -nextNode.tileSize2;
                     }
                     if(nextNode.yindex - node.yindex == 1)
                     {
                        yoffset = nextNode.tileSize2;
                     }
                     else
                     {
                        yoffset = -nextNode.tileSize2;
                     }
                     this.points.push({
                        "x":node.centerx + xoffset,
                        "y":node.centery + yoffset
                     });
                  }
               }
            }
         }
      }
      
      public function encode() : String
      {
         var str:String = this.astarIndex + ":";
         str += this.startx + "," + this.starty + "|";
         for(var i:int = 0; i < this.nodes.length; i++)
         {
            str += this.nodes[i].x;
            str += ",";
            str += this.nodes[i].y;
            if(i < this.nodes.length - 1)
            {
               str += "|";
            }
         }
         return str;
      }
      
      public function decode(str:String) : AStarPath
      {
         var token:Array = str.split(":");
         this.astarIndex = token[0];
         str = token[1];
         token = str.split("|");
         var xy:Array = token[0].split(",");
         this.startx = xy[0];
         this.starty = xy[1];
         this.points.length = 0;
         for(var i:int = 1; i < token.length; i++)
         {
            xy = token[i].split(",");
            this.points.push({
               "x":xy[0],
               "y":xy[1]
            });
         }
         return this;
      }
   }
}

