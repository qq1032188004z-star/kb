package org.engine.path
{
   import com.game.global.GlobalConfig;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.getTimer;
   import org.engine.frame.FrameTimer;
   import org.engine.game.MoveSprite;
   
   public class PathRunner
   {
      
      private var path:AStarPath;
      
      private var runningIndex:int;
      
      private var destx:Number;
      
      private var desty:Number;
      
      private var vx:Number;
      
      private var vy:Number;
      
      private var next:int;
      
      private var ms:MoveSprite;
      
      private var onArrive:Function;
      
      private var node:Object;
      
      private var dx:Number;
      
      private var dy:Number;
      
      private var d:Number;
      
      private var lastTime:Number;
      
      private var rect:Rectangle = new Rectangle(435,285,100,50);
      
      private var bottom:Number;
      
      private var right:Number;
      
      private var msv:Number = 1;
      
      private var sx:Number = 0;
      
      private var sy:Number = 0;
      
      public function PathRunner()
      {
         super();
      }
      
      public function run(ms:MoveSprite, p:AStarPath, onArrive:Function = null) : void
      {
         this.lastTime = getTimer();
         this.ms = ms;
         this.path = p;
         this.onArrive = onArrive;
         this.initEaseData(ms);
         ms.onGo();
         if(ms != null)
         {
            FrameTimer.getInstance().addCallBack(this.realMove,1);
         }
      }
      
      public function initEaseData(ms:MoveSprite) : void
      {
         this.ms = ms;
         this.bottom = ms.scene.bottom;
         this.right = ms.scene.right;
      }
      
      public function stop() : void
      {
         FrameTimer.getInstance().removeCallBack(this.realMove,1);
      }
      
      public function getPreviousNode() : Object
      {
         if(this.path != null && this.path.nodes.length > 1)
         {
            if(this.next - 1 < 0)
            {
               return null;
            }
            return this.path.nodes[this.next - 1];
         }
         return null;
      }
      
      public function getNextNode() : Object
      {
         if(this.path != null && this.path.nodes.length > this.next + 2)
         {
            return this.path.nodes[this.next + 1];
         }
         return null;
      }
      
      public function getCurrentIndex() : int
      {
         return this.next;
      }
      
      public function getCurrentNode(index:int) : Object
      {
         if(this.path != null)
         {
            if(index < 0 || index >= this.path.nodes.length)
            {
               return null;
            }
            return this.path.nodes[index];
         }
         return null;
      }
      
      private function realMove() : void
      {
         if(this.runningIndex != this.path.astarIndex)
         {
            this.next = 0;
         }
         this.runningIndex = this.path.astarIndex;
         if(this.ms.x == this.destx && this.ms.y == this.desty || this.next == 0)
         {
            if(this.next >= this.path.points.length)
            {
               FrameTimer.getInstance().removeCallBack(this.realMove,1);
               this.ms.onStop();
               if(this.onArrive != null)
               {
                  this.onArrive();
               }
               return;
            }
            this.node = this.path.points[this.next];
            this.ms.beforeGo(this.node.x,this.node.y);
            ++this.next;
            this.destx = this.node.x;
            this.desty = this.node.y;
            this.dx = this.destx - this.ms.x;
            this.dy = this.desty - this.ms.y;
            this.d = Math.sqrt(this.dx * this.dx + this.dy * this.dy);
            if(this.d == 0)
            {
               ++this.next;
               return;
            }
            this.dx /= this.d;
            this.dy /= this.d;
            this.dx *= this.ms.speed;
            this.dy *= this.ms.speed;
            this.vx = this.dx;
            this.vy = this.dy;
         }
         if(Math.abs(this.ms.x - this.destx) < Math.abs(this.vx))
         {
            this.vx = this.destx - this.ms.x;
         }
         if(Math.abs(this.ms.y - this.desty) < Math.abs(this.vy))
         {
            this.vy = this.desty - this.ms.y;
         }
         this.ms.x += this.vx;
         this.ms.y += this.vy;
         if(GlobalConfig.userId == this.ms.sequenceID && this.ms.scene.isScroll)
         {
            this.scrollMap(Math.round(-this.vx) * this.msv,Math.round(-this.vy) * this.msv);
         }
      }
      
      public function scrollMap(svx:Number, svy:Number) : void
      {
         if(this.ms.ui == null || this.ms.ui.parent == null)
         {
            return;
         }
         var point:Point = this.ms.ui.parent.localToGlobal(new Point(int(this.ms.x),int(this.ms.y)));
         point.x *= this.msv;
         point.y *= this.msv;
         if(point.y < this.rect.top && svy > 0)
         {
            if(this.ms.scene.bg.y < 0)
            {
               if(svy > -this.ms.scene.bg.y)
               {
                  svy = -this.ms.scene.bg.y;
               }
               this.ms.scene.bg.y += svy;
               this.ms.ui.parent.y += svy;
            }
         }
         if(point.y > this.rect.bottom && svy < 0)
         {
            if(this.ms.scene.bg.y > -this.bottom)
            {
               if(svy < -this.bottom - this.ms.scene.bg.y)
               {
                  svy = -this.bottom - this.ms.scene.bg.y;
               }
               this.ms.scene.bg.y += svy;
               this.ms.ui.parent.y += svy;
            }
         }
         if(point.x < this.rect.left && svx > 0)
         {
            if(this.ms.scene.bg.x < 0)
            {
               if(svx > -this.ms.scene.bg.x)
               {
                  svx = -this.ms.scene.bg.x;
               }
               this.ms.scene.bg.x += svx;
               this.ms.ui.parent.x += svx;
            }
         }
         if(point.x > this.rect.right && svx < 0)
         {
            if(this.ms.scene.bg.x > -this.right)
            {
               if(svx < -this.right - this.ms.scene.bg.x)
               {
                  svx = -this.right - this.ms.scene.bg.x;
               }
               this.ms.scene.bg.x += svx;
               this.ms.ui.parent.x += svx;
            }
         }
         if(this.ms.scene.bg.x >= 0)
         {
            this.ms.scene.bg.x = 0;
            this.ms.ui.parent.x = 0;
         }
         if(this.ms.scene.bg.y <= -this.bottom)
         {
            this.ms.ui.parent.y = -this.bottom;
            this.ms.scene.bg.y = -this.bottom;
         }
         if(this.ms.scene.bg.x <= -this.right)
         {
            this.ms.scene.bg.x = -this.right;
            this.ms.ui.parent.x = -this.right;
         }
         if(this.ms.scene.bg.y >= 0)
         {
            this.ms.ui.parent.y = 0;
            this.ms.scene.bg.y = 0;
         }
      }
      
      public function scaleScroll(rx:Number, ry:Number, sv:Number) : void
      {
         var tx:Number = NaN;
         var ty:Number = NaN;
         var mx:Number = NaN;
         var my:Number = NaN;
         if(this.ms == null || this.ms.scene == null || this.ms.scene.bg == null)
         {
            return;
         }
         try
         {
            tx = (this.ms.scene.bg.width + this.ms.scene.bg.x) * sv - 970 - 1000 * (1 - sv);
            ty = (this.ms.scene.bg.height + this.ms.scene.bg.y) * sv - 570 - 600 * (1 - sv);
            if(tx < 0)
            {
               this.ms.scene.bg.x -= tx;
               this.ms.ui.parent.x -= tx;
               if(this.ms.scene.bg.x >= 0)
               {
                  this.ms.scene.bg.x = 0;
               }
               if(this.ms.ui.parent.x >= 0)
               {
                  this.ms.ui.parent.x = 0;
               }
            }
            if(ty < 0)
            {
               this.ms.scene.bg.y -= ty;
               this.ms.ui.parent.y -= ty;
               if(this.ms.scene.bg.y >= 0)
               {
                  this.ms.scene.bg.y = 0;
               }
               if(this.ms.ui.parent.y >= 0)
               {
                  this.ms.ui.parent.y = 0;
               }
            }
            mx = this.ms.x * sv - 970;
            my = this.ms.y * sv - 570;
            if(this.ms.scene.bg.x > -mx)
            {
               this.ms.scene.bg.x = -mx;
               this.ms.ui.parent.x = -mx;
            }
            if(this.ms.scene.bg.y > -my)
            {
               this.ms.scene.bg.y = -my;
               this.ms.ui.parent.y = -my;
            }
         }
         catch(e:*)
         {
         }
      }
      
      public function movescene(rx:Number, ry:Number) : void
      {
         if(this.ms == null || this.ms.scene == null || this.ms.scene.bg == null)
         {
            return;
         }
         try
         {
            this.ms.scene.bg.x = rx;
            this.ms.ui.parent.x = rx;
            this.ms.scene.bg.y = ry;
            this.ms.ui.parent.y = ry;
         }
         catch(e:*)
         {
         }
      }
   }
}

