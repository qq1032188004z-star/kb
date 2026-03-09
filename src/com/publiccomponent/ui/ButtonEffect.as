package com.publiccomponent.ui
{
   import com.game.modules.view.FaceView;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   
   public class ButtonEffect extends Sprite
   {
      
      public static const EFFECT_LIGHT:int = 1;
      
      public static const EFFECT_AWARD1:int = 2;
      
      public static const EFFECT_LOTTERY:int = 3;
      
      public static const EFFECT_EMAIL:int = 4;
      
      public static const EFFECT_NEW:int = 5;
      
      public static const EFFECT_LOTTERY2:int = 6;
      
      public static const EFFECT_WEEKLY:int = 7;
      
      public static const EFFECT_WEEKLY_NEW:int = 8;
      
      public static const EFFECT_TIMER:int = 9;
      
      public static const EFFECT_BRAVER_AWARD:int = 10;
      
      public static const EFFECT_BRAVER:int = 11;
      
      private var _effectMc:MovieClip;
      
      private var _effectType:int;
      
      private var _btn:DisplayObject;
      
      private var _lightVisible:Boolean;
      
      private var _time:int;
      
      private var _tid:uint;
      
      public function ButtonEffect(effectType:int, btn:DisplayObject, lightVisible:Boolean = true, time:int = 0)
      {
         super();
         this._effectType = effectType;
         this._effectMc = FaceView.clip.getBtnEffect(effectType);
         this._btn = btn;
         this._lightVisible = lightVisible;
         this._time = time;
         this.initialize();
      }
      
      private function initialize() : void
      {
         if(this._btn && this._btn.parent && this._btn.visible && this._btn is TopButton)
         {
            this._effectMc.visible = true;
            this._effectMc.mouseChildren = false;
            this._effectMc.mouseEnabled = false;
            this.setPoint(this._btn.width / 2,this._btn.height / 2);
            (this._btn as TopButton).addChild(this._effectMc);
            if(!this._lightVisible && Boolean(this._effectMc.hasOwnProperty("light")))
            {
               if(Boolean(this._effectMc.light))
               {
                  this._effectMc.light.stop();
                  this._effectMc.removeChild(this._effectMc.light);
               }
            }
            if(this._effectType == EFFECT_TIMER && this._time > 0 && Boolean(this._effectMc.hasOwnProperty("timeMc")))
            {
               this._effectMc.timeMc.visible = true;
               this._tid = setInterval(this.setTime,1000);
            }
            else if(this._effectMc.hasOwnProperty("timeMc"))
            {
               this._effectMc.timeMc.visible = false;
            }
         }
      }
      
      private function setTime() : void
      {
         var min:int = 0;
         var sec:int = 0;
         var min1:int = 0;
         var min2:int = 0;
         var sec1:int = 0;
         var sec2:int = 0;
         --this._time;
         if(this._time > 0)
         {
            min = Math.floor(this._time / 60);
            sec = this._time % 60;
            min1 = Math.floor(min / 10);
            min2 = min % 10;
            sec1 = Math.floor((this._time - 60 * min) / 10);
            sec2 = (this._time - 60 * min) % 10;
            this._effectMc.timeMc.min1.gotoAndStop(min1 + 1);
            this._effectMc.timeMc.min2.gotoAndStop(min2 + 1);
            this._effectMc.timeMc.sec1.gotoAndStop(sec1 + 1);
            this._effectMc.timeMc.sec2.gotoAndStop(sec2 + 1);
         }
         else
         {
            clearInterval(this._tid);
            this._effectMc.timeMc.visible = false;
         }
      }
      
      public function setPoint(x:Number, y:Number) : void
      {
         this.x = x;
         this.y = y;
         this._effectMc.x = this.x;
         this._effectMc.y = this.y;
      }
      
      public function get btn() : DisplayObject
      {
         return this._btn;
      }
      
      public function disport() : void
      {
         if(Boolean(this._effectMc))
         {
            this._effectMc.stop();
            if(Boolean(this._effectMc.parent))
            {
               this._effectMc.parent.removeChild(this._effectMc);
            }
            this._effectMc = null;
         }
         if(this._effectType == EFFECT_TIMER)
         {
            clearInterval(this._tid);
         }
      }
   }
}

