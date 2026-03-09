package com.game.modules.action
{
   import flash.geom.Rectangle;
   import org.engine.core.GameSprite;
   import org.engine.game.MoveSprite;
   
   public class GameSpriteAction
   {
      
      private static var _instance:GameSpriteAction;
      
      public function GameSpriteAction()
      {
         super();
      }
      
      public static function get instance() : GameSpriteAction
      {
         if(_instance == null)
         {
            _instance = new GameSpriteAction();
         }
         return _instance;
      }
      
      public function checkSpecialArea(gameSprite:GameSprite) : void
      {
         SpecialAreaAction.instance.checkPosition(gameSprite);
      }
      
      public function moveUp(gameSprite:MoveSprite, upCallBack:Function, distance:Number, speed:Number = 5, acceleration:Number = 1, extMaterName:String = null, xCoord:Number = 0, yCoord:Number = 0) : void
      {
         var moveAction:MoveAction = new MoveAction();
         moveAction.moveUp(gameSprite,upCallBack,distance,speed,acceleration,extMaterName,xCoord,yCoord);
      }
      
      public function moveDown(gameSprite:MoveSprite, upCallBack:Function, distance:Number, speed:Number = 5, acceleration:Number = 1, extMaterName:String = null, maskRect:Rectangle = null, xCoord:Number = 0, yCoord:Number = 0) : void
      {
         var moveAction:MoveAction = new MoveAction();
         moveAction.moveDown(gameSprite,upCallBack,distance,speed,acceleration,extMaterName,maskRect,xCoord,yCoord);
      }
      
      public function moveLeft(gameSprite:MoveSprite, upCallBack:Function, distance:Number, speed:Number = 5, acceleration:Number = 1, extMaterName:String = null, maskRect:Rectangle = null, xCoord:Number = 0, yCoord:Number = 0) : void
      {
         var moveAction:MoveAction = new MoveAction();
         moveAction.moveLeft(gameSprite,upCallBack,distance,speed,acceleration,extMaterName,maskRect,xCoord,yCoord);
      }
      
      public function fellDown(gameSprite:MoveSprite, fellDownCallBack:Function, rDegree:Number, speed:Number, distance:Number) : void
      {
         var moveAction:MoveAction = new MoveAction();
         moveAction.fellDown(gameSprite,fellDownCallBack,rDegree,speed,distance);
      }
      
      public function forceMoveTo(gameSprite:MoveSprite, xCoord:Number, yCoord:Number, params:int) : void
      {
         var moveAction:MoveAction = new MoveAction();
         moveAction.forceMoveTo(gameSprite,xCoord,yCoord,params);
      }
      
      public function forceDrifting(gameSprite:MoveSprite, callBack:Function, frames:int, speed:Number, x0:Number, y0:Number, x1:Number, y1:Number) : void
      {
         var moveAction:MoveAction = new MoveAction();
         moveAction.Drifting(gameSprite,callBack,frames,speed,x0,y0,x1,y1);
      }
      
      public function changeAndMove(gameSprite:MoveSprite, xCoord:Number, yCoord:Number, id:int) : void
      {
         var moveAction:MoveAction = new MoveAction();
         moveAction.changeMove(gameSprite,xCoord,yCoord,-3);
      }
      
      public function smashedOut(gameSprite:MoveSprite, xCoord:Number, yCoord:Number, stime:Number = 0.1) : void
      {
         var moveAction:MoveAction = new MoveAction();
         moveAction.smashedOut(gameSprite,xCoord,yCoord,stime);
      }
   }
}

