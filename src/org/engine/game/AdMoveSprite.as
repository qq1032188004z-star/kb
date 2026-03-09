package org.engine.game
{
   import flash.geom.Point;
   import org.engine.core.GridMap;
   import org.engine.core.Tile;
   import org.engine.frame.FrameTimer;
   
   public class AdMoveSprite extends MoveSprite
   {
      
      public var direction:int;
      
      public var dir:int;
      
      public function AdMoveSprite()
      {
         super();
      }
      
      public function isInMoveAbleMoveArea(isSpceial:Boolean = false) : Boolean
      {
         var destPoint:Point = this.ui.parent.globalToLocal(new Point(this.scene.config.@x,this.scene.config.@y));
         var map:GridMap = scene.map;
         if(destPoint.x > scene.bg.width || destPoint.y > scene.bg.height)
         {
            destPoint = new Point(this.scene.config.@x,this.scene.config.@y);
         }
         var dest:Tile = scene.map.getTileByPos(destPoint.x,destPoint.y);
         var start:Tile = scene.map.getTileByPos(this.x,this.y);
         if(isSpceial)
         {
            if(start.walkable == 1)
            {
               return false;
            }
            return true;
         }
         return astar.find(start,dest,map,true);
      }
      
      override public function onGo() : void
      {
         FrameTimer.getInstance().addCallBack(this.render);
      }
      
      override public function onStop() : void
      {
         FrameTimer.getInstance().removeCallBack(this.render);
      }
      
      override protected function onTurnToDown() : void
      {
         this.direction = 2;
         this.dir = 6;
      }
      
      override protected function onTurnToLeft() : void
      {
         this.direction = 0;
         this.dir = 4;
      }
      
      override protected function onTurnToLeftDown() : void
      {
         this.direction = 0;
         this.dir = 5;
      }
      
      override protected function onTurnToLeftUp() : void
      {
         this.direction = 3;
         this.dir = 3;
      }
      
      override protected function onTurnToRight() : void
      {
         this.direction = 2;
         this.dir = 0;
      }
      
      override protected function onTurnToRightDown() : void
      {
         this.direction = 2;
         this.dir = 7;
      }
      
      override protected function onTurnToRightUp() : void
      {
         this.direction = 1;
         this.dir = 1;
      }
      
      override protected function onTurnToUp() : void
      {
         this.direction = 1;
         this.dir = 2;
      }
      
      public function render() : void
      {
      }
   }
}

