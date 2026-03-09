package com.game.modules.view.task
{
   import flash.display.CapsStyle;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   
   public class FoundWayGame extends Sprite
   {
      
      private var loader:Loader;
      
      private var player:MovieClip;
      
      private var mc:MovieClip;
      
      private var playerIndex:int;
      
      private var stoneList:Array;
      
      private var scoreList:Array;
      
      private var stepList:Array;
      
      private var currentX:Number;
      
      private var currentY:Number;
      
      private var lastX:Number;
      
      private var lastY:Number;
      
      private var callback:Function;
      
      public function FoundWayGame()
      {
         super();
         this.loader = new Loader();
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoadComplete);
         this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
         this.loader.load(new URLRequest("assets/material/maze.swf"));
      }
      
      private function onLoadComplete(evt:Event) : void
      {
         evt.stopImmediatePropagation();
         var domain:ApplicationDomain = evt.target.applicationDomain as ApplicationDomain;
         var cls:Class = domain.getDefinition("player") as Class;
         this.player = new cls() as MovieClip;
         this.player.up.visible = false;
         this.player.right.visible = false;
         this.player.down.visible = false;
         this.player.left.visible = false;
         this.player.up.addEventListener(MouseEvent.CLICK,this.onMouseClickDirection);
         this.player.right.addEventListener(MouseEvent.CLICK,this.onMouseClickDirection);
         this.player.down.addEventListener(MouseEvent.CLICK,this.onMouseClickDirection);
         this.player.left.addEventListener(MouseEvent.CLICK,this.onMouseClickDirection);
         this.mc = this.loader.content as MovieClip;
         this.addChild(this.mc);
         this.mc.x = 0;
         this.mc.y = 0;
         this.mc.stop();
         this.releaseLoader();
         if(this.callback != null)
         {
            this.startGame();
         }
      }
      
      private function startGame() : void
      {
         this.mc.alert.visible = false;
         this.stoneList = [2,5,21,22,37];
         this.stepList = [];
         var i:int = 0;
         var len:int = 5;
         if(this.scoreList != null)
         {
            this.scoreList.length = 0;
            this.scoreList = null;
         }
         this.scoreList = new Array(5);
         for(i = 0; i < len; i++)
         {
            this.scoreList[i] = new Array(8);
         }
         var j:int = 0;
         var leng:int = 8;
         for(i = 0; i < len; i++)
         {
            for(j = 0; j < leng; j++)
            {
               this.scoreList[i][j] = 0;
            }
         }
         this.scoreList[0][1] = 1;
         this.scoreList[0][4] = 1;
         this.scoreList[2][0] = 1;
         this.scoreList[2][1] = 1;
         this.scoreList[3][6] = 1;
         this.registBtnEvent();
         this.initMap();
      }
      
      private function registBtnEvent() : void
      {
         this.mc.bg.lastStep.addEventListener(MouseEvent.CLICK,this.goBackToLastStep);
         this.mc.bg.cancelBtn.addEventListener(MouseEvent.CLICK,this.onMouseClickCancel);
      }
      
      private function releaseBtnEvent() : void
      {
         this.mc.bg.lastStep.removeEventListener(MouseEvent.CLICK,this.goBackToLastStep);
         this.mc.bg.cancelBtn.removeEventListener(MouseEvent.CLICK,this.onMouseClickCancel);
      }
      
      private function onLoadError(evt:IOErrorEvent) : void
      {
         evt.stopImmediatePropagation();
         this.disport();
      }
      
      private function releaseLoader() : void
      {
         if(this.loader == null)
         {
            return;
         }
         this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoadComplete);
         this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
         this.loader.unloadAndStop();
         this.loader = null;
      }
      
      private function initMap() : void
      {
         this.mc.bg.addChild(this.player);
         this.player.x = 80.5;
         this.player.y = 77.3;
         this.playerIndex = 1;
         this.scoreList[0][0] = 1;
         this.lastX = this.currentX = this.mc.bg.bgmc.x - 25 - this.player.ball.width;
         this.lastY = this.currentY = this.mc.bg.bgmc.y - 25 - this.player.ball.height;
         this.mc.bg.bgmc.graphics.moveTo(this.lastX,this.lastY);
         this.mc.bg.bgmc.graphics.lineStyle(10,16777113,1,false,"normal",CapsStyle.ROUND);
         this.player.ball.addEventListener(MouseEvent.CLICK,this.onMouseClickPlayer);
      }
      
      private function setPlayCoord(direction:int) : void
      {
         var row:int = this.playerIndex / 10 >> 0;
         var col:int = this.playerIndex % 10;
         var xCoord:int = 0;
         var yCoord:int = 0;
         switch(direction)
         {
            case 0:
               if(row == 0)
               {
                  return;
               }
               xCoord = 0;
               yCoord = -1;
               break;
            case 1:
               if(col == 8)
               {
                  return;
               }
               xCoord = 1;
               yCoord = 0;
               break;
            case 2:
               if(row == 4)
               {
                  return;
               }
               xCoord = 0;
               yCoord = 1;
               break;
            case 3:
               if(col == 1)
               {
                  return;
               }
               xCoord = -1;
               yCoord = 0;
         }
         this.pushStep(xCoord,yCoord);
         this.movePlayer(xCoord,yCoord,row,col,true);
         if(this.checkOver())
         {
            this.releaseBtnEvent();
            this.gameOver();
         }
      }
      
      private function checkOver() : Boolean
      {
         var i:int = 0;
         var len:int = int(this.scoreList.length);
         for(i = 0; i < len; i++)
         {
            if(this.scoreList[i].indexOf(0) != -1)
            {
               return false;
            }
         }
         return true;
      }
      
      private function movePlayer(xCoord:int, yCoord:int, row:int, col:int, flag:Boolean) : void
      {
         var temp:int = (row + yCoord) * 10 + (col + xCoord);
         if(this.stoneList.indexOf(temp) != -1)
         {
            return;
         }
         if(!flag)
         {
            this.scoreList[row][col - 1] -= 1;
         }
         this.player.x += xCoord * 52;
         this.player.y += yCoord * 52;
         row += yCoord;
         col += xCoord;
         if(flag)
         {
            this.scoreList[row][col - 1] += 1;
         }
         this.printLine(xCoord,yCoord,flag);
         this.playerIndex = row * 10 + col;
      }
      
      private function onMouseClickPlayer(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         this.player.up.visible = true;
         this.player.right.visible = true;
         this.player.down.visible = true;
         this.player.left.visible = true;
      }
      
      private function onMouseClickDirection(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         var str:String = evt.target.name;
         var dir:int = 0;
         if(str == "up")
         {
            dir = 0;
         }
         else if(str == "right")
         {
            dir = 1;
         }
         else if(str == "down")
         {
            dir = 2;
         }
         else if(str == "left")
         {
            dir = 3;
         }
         this.setPlayCoord(dir);
      }
      
      private function pushStep(xCoord:int, yCoord:int) : void
      {
         this.stepList.push({
            "xCoord":xCoord,
            "yCoord":yCoord
         });
      }
      
      private function popStep() : Object
      {
         var obj:Object = this.stepList.pop();
         obj.xCoord = -obj.xCoord;
         obj.yCoord = -obj.yCoord;
         return obj;
      }
      
      private function goBackToLastStep(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         if(this.stepList == null || this.stepList.length == 0)
         {
            return;
         }
         var obj:Object = this.popStep();
         var row:int = this.playerIndex / 10 >> 0;
         var col:int = this.playerIndex % 10;
         this.movePlayer(obj.xCoord,obj.yCoord,row,col,false);
      }
      
      private function onMouseClickCancel(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         this.releaseBtnEvent();
         this.mc.bg.bgmc.graphics.clear();
         this.disport();
      }
      
      private function printLine(xCoord:int, yCoord:int, flag:Boolean) : void
      {
         var i:int = 0;
         var len:int = 0;
         this.lastX = this.currentX;
         this.lastY = this.currentY;
         this.mc.bg.bgmc.graphics.moveTo(this.lastX,this.lastY);
         if(flag)
         {
            this.currentX = this.lastX + xCoord * 52;
            this.currentY = this.lastY + yCoord * 52;
            this.mc.bg.bgmc.graphics.lineTo(this.currentX,this.currentY);
         }
         else
         {
            this.mc.bg.bgmc.graphics.clear();
            i = 0;
            len = int(this.stepList.length);
            this.mc.bg.bgmc.graphics.lineStyle(10,16777113,1,false,"normal",CapsStyle.ROUND);
            this.lastX = this.currentX = this.mc.bg.bgmc.x - 25 - this.player.ball.width;
            this.lastY = this.currentY = this.mc.bg.bgmc.y - 25 - this.player.ball.height;
            this.mc.bg.bgmc.graphics.moveTo(this.lastX,this.lastY);
            for(i = 0; i < len; i++)
            {
               this.currentX = this.lastX + this.stepList[i].xCoord * 52;
               this.currentY = this.lastY + this.stepList[i].yCoord * 52;
               this.mc.bg.bgmc.graphics.lineTo(this.currentX,this.currentY);
               this.lastX = this.currentX;
               this.lastY = this.currentY;
               this.mc.bg.bgmc.graphics.moveTo(this.lastX,this.lastY);
            }
         }
      }
      
      private function gameOver() : void
      {
         this.mc.bg.removeChild(this.player);
         this.mc.bg.bgmc.graphics.clear();
         this.player.ball.removeEventListener(MouseEvent.CLICK,this.onMouseClickPlayer);
         if(this.noRepeatFilter())
         {
            this.disport(true);
         }
         else
         {
            this.mc.alert.restart.addEventListener(MouseEvent.CLICK,this.onMouseClickRestart);
            this.mc.alert.quit.addEventListener(MouseEvent.CLICK,this.onClickQuit);
            this.mc.alert.visible = true;
         }
      }
      
      private function noRepeatFilter() : Boolean
      {
         var tempArr:Array = null;
         var i:int = 0;
         var len:int = int(this.scoreList.length);
         for(i = 0; i < len; i++)
         {
            tempArr = (this.scoreList[i] as Array).filter(this.noRepeart);
            if(tempArr.length != this.scoreList[i].length)
            {
               return false;
            }
         }
         return true;
      }
      
      private function noRepeart(item:*, index:int, arr:Array) : Boolean
      {
         return item == 1 ? true : false;
      }
      
      private function onMouseClickRestart(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         this.mc.alert.restart.removeEventListener(MouseEvent.CLICK,this.onMouseClickRestart);
         this.mc.alert.quit.removeEventListener(MouseEvent.CLICK,this.onClickQuit);
         this.mc.alert.visible = false;
         this.startGame();
      }
      
      private function onClickQuit(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         this.releaseBtnEvent();
         this.disport();
      }
      
      public function setData(param:Object) : void
      {
         this.callback = param.callback;
         if(this.mc != null)
         {
            this.startGame();
         }
      }
      
      public function disport(flag:Boolean = false) : void
      {
         this.releaseLoader();
         if(this.mc != null)
         {
            if(Boolean(this.mc.bg.contains(this.player)))
            {
               this.mc.bg.removeChild(this.player);
            }
            this.mc.bg.bgmc.graphics.clear();
         }
         this.stepList = null;
         this.stoneList = null;
         this.scoreList = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
         if(this.callback != null)
         {
            if(!flag)
            {
               this.callback.apply(null,["closedialog"]);
            }
            else
            {
               this.callback.apply(null,[flag]);
            }
         }
         this.callback = null;
      }
   }
}

