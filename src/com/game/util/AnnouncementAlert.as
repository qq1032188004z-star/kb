package com.game.util
{
   import com.game.modules.view.WindowLayer;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.utils.setTimeout;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol110")]
   public class AnnouncementAlert extends Sprite
   {
      
      public var msgTxt:TextField;
      
      public var bgClip:MovieClip;
      
      private var floatDistance:Number = 100;
      
      private var speed:Number = 3;
      
      public function AnnouncementAlert()
      {
         super();
      }
      
      public function show(parentObj:DisplayObjectContainer, x:Number, y:Number, msg:String, time:Number = 5000) : void
      {
         this.mouseChildren = false;
         this.mouseEnabled = false;
         this.floatDistance = this.floatDistance;
         this.speed = this.speed;
         this.msgTxt.htmlText = msg;
         this.x = x;
         this.y = y;
         if(parentObj != null)
         {
            parentObj.addChild(this);
         }
         else
         {
            WindowLayer.instance.addChild(this);
         }
         setTimeout(this.remove,time);
      }
      
      private function remove() : void
      {
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

