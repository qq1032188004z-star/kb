package org.engine.game
{
   import com.game.global.GlobalConfig;
   import flash.geom.Point;
   import org.engine.core.GameSprite;
   import org.engine.core.GridMap;
   import org.engine.core.Tile;
   import org.engine.frame.FrameTimer;
   import org.engine.path.AStar;
   import org.engine.path.AStarPath;
   import org.engine.path.PathRunner;
   
   public class MoveSprite extends GameSprite
   {
      
      public var speed:Number = 5;
      
      public var astar:AStar = new AStar();
      
      public var runner:PathRunner = new PathRunner();
      
      private var onArrival:Function;
      
      private var destX:Number;
      
      private var destY:Number;
      
      public var scale:Number = 1;
      
      public var master:MoveSprite;
      
      public var followers:Array = [];
      
      public function MoveSprite()
      {
         super();
      }
      
      public function easeMoveTo(destX:Number, destY:Number, onArrive:Function = null) : void
      {
         if(Boolean(this.runner))
         {
            this.runner.initEaseData(this);
            this.onArrival = onArrive;
            this.onGo();
            this.destX = destX;
            this.destY = destY;
            if(this.ui != null)
            {
               FrameTimer.getInstance().addCallBack(this.enterFrameMove,1);
            }
            if(this.followers.length > 0)
            {
               this.follwerEaseMove(destX,destY);
            }
         }
      }
      
      private function enterFrameMove() : void
      {
         var dx:Number = this.destX - x;
         var dy:Number = this.destY - y;
         var ease:Number = 0.08;
         if(Math.abs(dx) < 2 && Math.abs(dy) < 2)
         {
            if(Boolean(this.onArrival))
            {
               this.onArrival();
            }
            this.onStop();
            FrameTimer.getInstance().removeCallBack(this.enterFrameMove,1);
         }
         if(Math.abs(dx) < 150 && Math.abs(dy) < 150)
         {
            ease = 0.15;
         }
         var fx:Number = dx * ease;
         var fy:Number = dy * ease;
         this.beforeGo(x + fx,y + fy);
         x += fx;
         y += fy;
         if(GlobalConfig.userId == this.sequenceID && this.scene.isScroll)
         {
            this.runner.scrollMap(Math.round(-fx),Math.round(-fy));
         }
      }
      
      public function stopEaseMove() : void
      {
         this.onStop();
         FrameTimer.getInstance().removeCallBack(this.enterFrameMove,1);
      }
      
      private function follwerEaseMove(destX:Number, destY:Number) : void
      {
         var ms:MoveSprite = null;
         var tempX:Number = 0;
         var tempY:Number = 0;
         if(destX >= this.x)
         {
            tempX = destX - 50;
            if(tempX <= 0)
            {
               tempX = 0;
            }
         }
         if(destX < this.x)
         {
            tempX = destX + 50;
            if(tempX > this.scene.bg.width)
            {
               tempX = Number(this.scene.bg.width);
            }
         }
         if(destY >= this.y)
         {
            tempY = destY - 50;
            if(tempY <= 0)
            {
               tempY = 0;
            }
         }
         if(destY < this.y)
         {
            tempY = destY + 50;
            if(tempY > this.scene.bg.height)
            {
               tempY = Number(this.scene.bg.height);
            }
         }
         for each(ms in this.followers)
         {
            ms.onGo();
            ms.easeMoveTo(tempX,tempY);
         }
      }
      
      public function moveto(destx:int, desty:int, onArrive:Function = null, moveFlag:int = 1) : Boolean
      {
         if(this.ui == null || this.ui.parent == null)
         {
            return false;
         }
         var point:Point = this.ui.parent.globalToLocal(new Point(destx,desty));
         destx = point.x;
         desty = point.y;
         var isLimite:Boolean = true;
         if(scene == null)
         {
            return false;
         }
         if(destx == this.x && desty == this.y)
         {
            return false;
         }
         if(moveFlag == 2)
         {
            this.easeMoveTo(destx,desty,onArrive);
            if(Boolean(this.runner))
            {
               this.runner.stop();
            }
            return true;
         }
         if(moveFlag == 3)
         {
            isLimite = false;
         }
         var map:GridMap = scene.map;
         var grids:Array = map.grids;
         var dest:Tile = scene.map.getTileByPos(destx,desty);
         var start:Tile = scene.map.getTileByPos(this.x,this.y);
         if(this.astar.find(start,dest,map,isLimite) == false)
         {
            return false;
         }
         this.astar.astarpath.startx = Math.floor(this.x);
         this.astar.astarpath.starty = Math.floor(this.y);
         this.astar.astarpath.destx = destx;
         this.astar.astarpath.desty = desty;
         this.astar.astarpath.toPoints();
         if(this.runner == null)
         {
            return false;
         }
         this.runner.run(this,this.astar.astarpath,onArrive);
         return true;
      }
      
      public function goto(path:AStarPath, onArrive:Function) : void
      {
         var nodelen:int = 0;
         var k:int = 0;
         var i:int = 0;
         var mm:MoveSprite = null;
         var j:int = 0;
         if(this.followers.length > 0)
         {
            nodelen = path.nodes.length - 1;
            k = -1;
            for(i = 0; i < this.followers.length; i++)
            {
               mm = this.followers[i];
               if(nodelen - i > 1)
               {
                  mm.astar.astarpath.nodes.length = 0;
                  for(j = 0; j < nodelen - 1 - i; j++)
                  {
                     mm.astar.astarpath.nodes.push(path.nodes[j]);
                  }
                  mm.astar.astarpath.destNode = path.nodes[nodelen - 1 - i - 1];
                  mm.astar.astarpath.destx = mm.astar.astarpath.destNode.centerx;
                  mm.astar.astarpath.desty = mm.astar.astarpath.destNode.centery;
                  mm.astar.astarpath.startNode = mm.getTile();
                  mm.astar.astarpath.startx = mm.x;
                  mm.astar.astarpath.starty = mm.y;
                  mm.astar.astarpath.toPoints();
                  ++mm.astar.astarpath.astarIndex;
                  mm.runner.run(mm,mm.astar.astarpath);
               }
               else
               {
                  ++mm.astar.astarpath.astarIndex;
                  mm.astar.astarpath.points.length = 0;
                  if(k == -1)
                  {
                     mm.astar.astarpath.points.push({
                        "x":this.x,
                        "y":this.y
                     });
                  }
                  else
                  {
                     mm.astar.astarpath.points.push({
                        "x":this.followers[k].x,
                        "y":this.followers[k].y
                     });
                  }
                  mm.runner.run(mm,mm.astar.astarpath);
                  k++;
               }
            }
         }
      }
      
      public function addFollower(ms:MoveSprite) : void
      {
         var index:int = int(this.followers.indexOf(ms));
         if(index == -1)
         {
            this.followers.push(ms);
            ms.master = this;
         }
      }
      
      override public function dispos() : void
      {
         FrameTimer.getInstance().removeCallBack(this.enterFrameMove,1);
         super.dispos();
      }
      
      public function removeFollower(ms:MoveSprite) : void
      {
         var index:int = int(this.followers.indexOf(ms));
         if(index < 0)
         {
            return;
         }
         this.followers.splice(index,1);
         ms.master = null;
      }
      
      public function follow(ms:MoveSprite) : void
      {
         ms.followers.push(this);
         this.master = ms;
      }
      
      public function onStop() : void
      {
      }
      
      public function onGo() : void
      {
      }
      
      protected function onTurnToRight() : void
      {
      }
      
      protected function onTurnToLeft() : void
      {
      }
      
      protected function onTurnToUp() : void
      {
      }
      
      protected function onTurnToDown() : void
      {
      }
      
      protected function onTurnToRightDown() : void
      {
      }
      
      protected function onTurnToRightUp() : void
      {
      }
      
      protected function onTurnToLeftDown() : void
      {
      }
      
      protected function onTurnToLeftUp() : void
      {
      }
      
      public function beforeGo(destx:Number, desty:Number) : void
      {
         var dx:Number = destx - x;
         var dy:Number = desty - y;
         var ang:Number = Math.atan2(dy,dx) * 180 / Math.PI;
         if(Math.abs(ang - 0) <= 20)
         {
            this.onTurnToRight();
         }
         else if(Math.abs(ang - 90) <= 20)
         {
            this.onTurnToDown();
         }
         else if(Math.abs(ang - 180) <= 20)
         {
            this.onTurnToLeft();
         }
         else if(Math.abs(ang - -180) <= 20)
         {
            this.onTurnToLeft();
         }
         else if(Math.abs(ang - -90) <= 20)
         {
            this.onTurnToUp();
         }
         else if(Math.abs(ang - 45) <= 25)
         {
            this.onTurnToRightDown();
         }
         else if(Math.abs(ang - -45) <= 25)
         {
            this.onTurnToRightUp();
         }
         else if(Math.abs(ang - 135) <= 25)
         {
            this.onTurnToLeftDown();
         }
         else if(Math.abs(ang - -135) <= 25)
         {
            this.onTurnToLeftUp();
         }
      }
   }
}

