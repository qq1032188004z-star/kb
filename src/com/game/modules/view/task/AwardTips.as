package com.game.modules.view.task
{
   import caurina.transitions.Tweener;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   
   public class AwardTips extends Sprite
   {
      
      public function AwardTips()
      {
         super();
      }
      
      public static function showMsg(container:DisplayObjectContainer, xCoord:Number, yCoord:Number, type:String, num:int, speed:Number, distance:Number, fontSize:int, fontColor:uint) : void
      {
         var tips:AwardTipsItem = new AwardTipsItem();
         tips.showAward(type,num,fontSize,fontColor);
         playEffect(container,tips,xCoord,yCoord,speed,distance);
      }
      
      public static function showGoodMsg(container:DisplayObjectContainer, xCoord:Number, yCoord:Number, goodID:int, goodNum:int, speed:Number, distance:Number, fontSize:int, fontColor:uint) : void
      {
         var tips:AwardTipsItem = new AwardTipsItem();
         tips.showGoodAward(goodID,goodNum,fontSize,fontColor);
         playEffect(container,tips,xCoord,yCoord,speed,distance);
      }
      
      private static function playEffect(container:DisplayObjectContainer, tips:AwardTipsItem, xCoord:Number, yCoord:Number, speed:Number, distance:Number) : void
      {
         var t:Number;
         container.addChild(tips);
         tips.x = xCoord;
         tips.y = yCoord;
         t = distance / speed;
         clearTips(t,tips);
         Tweener.addTween(tips,{
            "x":xCoord,
            "y":yCoord - distance,
            "alpha":0,
            "transition":"easeInOutBack",
            "time":t,
            "onComplete":function():void
            {
               tips.disport();
            }
         });
      }
      
      private static function clearTips(num:int, tip:AwardTipsItem) : void
      {
         var interval:uint = 0;
         interval = setInterval(function():void
         {
            if(Boolean(tip))
            {
               tip.disport();
            }
            clearInterval(interval);
         },num * 1000);
      }
   }
}

