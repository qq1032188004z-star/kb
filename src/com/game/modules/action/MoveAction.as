package com.game.modules.action
{
   import caurina.transitions.Tweener;
   import com.channel.Message;
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.util.ScreenSprite;
   import com.publiccomponent.loading.MaterialLib;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   import org.engine.game.MoveSprite;
   
   public class MoveAction
   {
      
      private var gameSprite:MoveSprite;
      
      private var speed:Number;
      
      private var acceleration:Number;
      
      private var distance:Number;
      
      private var upCallBack:Function;
      
      private var fellDownCallBack:Function;
      
      private var extClip:MovieClip;
      
      private var degree:Number;
      
      private var shape:Shape;
      
      private var destX:Number;
      
      private var destY:Number;
      
      private var loader:Loader;
      
      private var tempX:Number;
      
      private var tempY:Number;
      
      private var flag:int;
      
      public function MoveAction()
      {
         super();
      }
      
      public function moveUp(gameSprite:MoveSprite, upCallBack:Function, distance:Number, speed:Number = 5, acceleration:Number = 1, extMaterName:String = null, xCoord:Number = 0, yCoord:Number = 0) : void
      {
         this.gameSprite = gameSprite;
         this.upCallBack = upCallBack;
         this.distance = distance;
         this.speed = speed;
         this.acceleration = acceleration;
         if(extMaterName != null)
         {
            this.extClip = MaterialLib.getInstance().getMaterial(extMaterName) as MovieClip;
            this.extClip.x = xCoord;
            this.extClip.y = yCoord;
            gameSprite.ui["addChildAt"](this.extClip,0);
         }
         gameSprite.ui.addEventListener(Event.ENTER_FRAME,this.enterFrameHandler);
      }
      
      public function moveDown(gameSprite:MoveSprite, upCallBack:Function, distance:Number, speed:Number = 5, acceleration:Number = 1, extMaterName:String = null, maskRect:Rectangle = null, xCoord:Number = 0, yCoord:Number = 0) : void
      {
         this.gameSprite = gameSprite;
         this.gameSprite["stop"](false);
         this.upCallBack = upCallBack;
         this.distance = distance;
         this.speed = speed;
         this.acceleration = acceleration;
         if(extMaterName != null)
         {
            this.extClip = MaterialLib.getInstance().getMaterial(extMaterName) as MovieClip;
            this.extClip.x = xCoord;
            this.extClip.y = yCoord;
            gameSprite.ui["addChildAt"](this.extClip,0);
         }
         if(maskRect != null)
         {
            this.shape = new Shape();
            this.shape.graphics.beginFill(16711680,1);
            this.shape.graphics.drawRect(maskRect.x,maskRect.y,maskRect.width,maskRect.height);
            this.shape.graphics.endFill();
            gameSprite.ui.mask = this.shape;
            gameSprite.ui.parent.addChild(this.shape);
         }
         gameSprite.ui.addEventListener(Event.ENTER_FRAME,this.enterFrameHandlerDown);
      }
      
      public function moveLeft(gameSprite:MoveSprite, upCallBack:Function, distance:Number, speed:Number = 5, acceleration:Number = 1, extMaterName:String = null, maskRect:Rectangle = null, xCoord:Number = 0, yCoord:Number = 0) : void
      {
         this.gameSprite = gameSprite;
         this.gameSprite["stop"]();
         this.upCallBack = upCallBack;
         this.distance = distance;
         this.speed = speed;
         this.acceleration = acceleration;
         this.loader = new Loader();
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.loadElephent);
         this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.errFunc);
         this.tempX = xCoord;
         this.tempY = yCoord;
         if(extMaterName != null)
         {
            this.loader.load(new URLRequest("assets/material/elephent.swf"));
         }
      }
      
      private function errFunc(evt:Event) : void
      {
         O.o("MoveAction错误");
      }
      
      private function loadElephent(evt:Event) : void
      {
         this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.loadElephent);
         this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.errFunc);
         this.extClip = this.loader.content as MovieClip;
         this.extClip.x = this.tempX;
         this.extClip.y = this.tempY;
         this.gameSprite.ui["addChildAt"](this.extClip,1);
         this.gameSprite.ui.addEventListener(Event.ENTER_FRAME,this.enterFrameHandlerLeft);
      }
      
      private function enterFrameHandlerLeft(evt:Event) : void
      {
         var moveSprite:MoveSprite = null;
         this.speed *= this.acceleration;
         this.gameSprite.x -= this.speed;
         for each(moveSprite in this.gameSprite.followers)
         {
            moveSprite.x -= this.speed;
         }
         this.distance -= Math.abs(this.speed);
         if(this.distance <= 0)
         {
            if(this.upCallBack != null)
            {
               this.upCallBack();
            }
            if(this.extClip != null)
            {
               this.extClip.stop();
               if(Boolean(this.extClip.parent))
               {
                  this.extClip.parent.removeChild(this.extClip);
                  this.extClip = null;
               }
            }
            if(this.gameSprite.ui != null)
            {
               this.gameSprite.ui.removeEventListener(Event.ENTER_FRAME,this.enterFrameHandlerLeft);
            }
         }
      }
      
      private function enterFrameHandlerDown(evt:Event) : void
      {
         var moveSprite:MoveSprite = null;
         this.speed *= this.acceleration;
         this.gameSprite.y += this.speed;
         this.distance -= Math.abs(this.speed);
         if(this.shape == null)
         {
            for each(moveSprite in this.gameSprite.followers)
            {
               moveSprite.y += this.speed;
            }
         }
         if(this.distance <= 0)
         {
            if(this.shape != null)
            {
               if(Boolean(this.shape.parent))
               {
                  this.shape.parent.removeChild(this.shape);
               }
            }
            this.shape = null;
            if(this.upCallBack != null)
            {
               this.upCallBack();
            }
            if(this.extClip != null)
            {
               this.extClip.stop();
               if(Boolean(this.extClip.parent))
               {
                  this.extClip.parent.removeChild(this.extClip);
                  this.extClip = null;
               }
            }
            if(this.gameSprite.ui != null)
            {
               this.gameSprite.ui.removeEventListener(Event.ENTER_FRAME,this.enterFrameHandlerDown);
            }
         }
      }
      
      private function enterFrameHandler(evt:Event) : void
      {
         var moveSprite:MoveSprite = null;
         this.speed *= this.acceleration;
         this.gameSprite.y -= this.speed;
         for each(moveSprite in this.gameSprite.followers)
         {
            moveSprite.y -= this.speed;
         }
         this.distance -= this.speed;
         if(this.distance <= 0)
         {
            if(this.upCallBack != null)
            {
               this.upCallBack();
            }
            if(this.extClip != null)
            {
               this.extClip.stop();
               if(Boolean(this.extClip.parent))
               {
                  this.extClip.parent.removeChild(this.extClip);
                  this.extClip = null;
               }
            }
            if(this.gameSprite.ui != null)
            {
               this.gameSprite.ui.removeEventListener(Event.ENTER_FRAME,this.enterFrameHandler);
            }
         }
      }
      
      public function fellDown(gameSprite:MoveSprite, fellDownCallBack:Function, rDegree:Number, speed:Number, distance:Number) : void
      {
         this.gameSprite = gameSprite;
         this.fellDownCallBack = fellDownCallBack;
         this.speed = speed;
         this.distance = distance;
         gameSprite["stop"]();
         gameSprite.ui.rotation = rDegree;
         gameSprite.ui.addEventListener(Event.ENTER_FRAME,this.fellDonwHandler);
      }
      
      private function fellDonwHandler(evt:Event) : void
      {
         if(Boolean(this.gameSprite))
         {
            this.gameSprite.y += this.speed / 2;
            this.distance -= this.speed;
            if(Boolean(this.gameSprite.ui))
            {
               this.gameSprite.ui.scaleX *= 0.8;
               this.gameSprite.ui.scaleY = this.gameSprite.ui.scaleX;
            }
         }
         if(this.distance <= 0)
         {
            if(this.gameSprite.ui != null)
            {
               this.gameSprite.ui.removeEventListener(Event.ENTER_FRAME,this.fellDonwHandler);
            }
            if(this.fellDownCallBack != null)
            {
               this.fellDownCallBack();
            }
         }
      }
      
      public function Drifting(gameSprite:MoveSprite, callBack:Function, frames:int, speed:Number, x0:Number, y0:Number, x1:Number, y1:Number) : void
      {
         this.gameSprite = gameSprite;
         this.upCallBack = callBack;
         this.distance = Math.abs(x1 - x0);
         this.speed = speed * (x1 - x0) / frames;
         this.degree = (y1 - y0) * Math.abs(this.speed) / Math.abs(x1 - x0);
         gameSprite.ui.addEventListener(Event.ENTER_FRAME,this.onDrifting);
      }
      
      private function onDrifting(evt:Event) : void
      {
         var moveSprite:MoveSprite = null;
         this.gameSprite.x += this.speed;
         this.gameSprite.y += this.degree;
         for each(moveSprite in this.gameSprite.followers)
         {
            moveSprite.y += this.degree;
            moveSprite.x += this.speed;
         }
         this.distance -= Math.abs(this.speed);
         if(this.distance <= 0)
         {
            if(this.gameSprite != null)
            {
               this.gameSprite.ui.removeEventListener(Event.ENTER_FRAME,this.onDrifting);
            }
            if(this.upCallBack != null)
            {
               this.upCallBack();
            }
         }
      }
      
      public function forceMoveTo(gameSprite:MoveSprite, xCoord:Number, yCoord:Number, params:int) : void
      {
         this.gameSprite = gameSprite;
         this.flag = params;
         if(this.flag == 0)
         {
            gameSprite["moveto"](xCoord,yCoord,this.onArrival);
         }
         else if(this.flag == 1111 || this.flag == 2222)
         {
            gameSprite["moveto"](xCoord,yCoord,this.onGetOnBoat);
         }
      }
      
      private function onArrival() : void
      {
         ScreenSprite.instance.show(true);
         new Message("sceneAIBack").sendToChannel("sceneAI");
      }
      
      private function onGetOnBoat() : void
      {
         ScreenSprite.instance.show(true);
         new Message("getOnBoatBack",this.flag).sendToChannel("sceneAI");
      }
      
      public function changeMove(gameSprite:MoveSprite, xCoord:Number, yCoord:Number, id:int) : void
      {
         ScreenSprite.instance.show(true);
         this.gameSprite = gameSprite;
         this.destX = xCoord;
         this.destY = yCoord;
         gameSprite["changeBody"](id,this.onBodyLoaded);
      }
      
      private function onBodyLoaded() : void
      {
         this.gameSprite.ui.scaleX = this.gameSprite.ui.scaleY = 0.5;
         this.gameSprite["showData"].moveFlag = 2;
         this.gameSprite.moveto(this.destX,this.destY,this.onArrivalDongHai,2);
      }
      
      private function onArrivalDongHai() : void
      {
         ApplicationFacade.getInstance().dispatch(EventConst.ENTERSCENE,40002);
         ApplicationFacade.getInstance().dispatch(EventConst.CLEARUI);
      }
      
      public function smashedOut(gameSprite:MoveSprite, xCoord:Number, yCoord:Number, stime:Number = 0.1) : void
      {
         this.gameSprite = gameSprite;
         Tweener.addTween(gameSprite.ui,{
            "x":xCoord,
            "y":yCoord,
            "time":stime,
            "onComplete":this.onSmashdout,
            "onCompleteParams":[gameSprite,xCoord,yCoord]
         });
      }
      
      private function onSmashdout(gameSprite:MoveSprite, xCoord:Number, yCoord:Number) : void
      {
         this.gameSprite.x = xCoord;
         this.gameSprite.y = yCoord;
      }
   }
}

