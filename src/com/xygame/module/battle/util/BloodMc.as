package com.xygame.module.battle.util
{
   import caurina.transitions.Tweener;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.system.ApplicationDomain;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class BloodMc extends Sprite
   {
      
      private static const DEFAULT_RIGHT_X:int = 680;
      
      private static const DEFAULT_LEFT_X:int = 180;
      
      private static const DEFAULT_Y:int = 150;
      
      private static const OFFSET_DAMAGE_X:int = 100;
      
      private static const OFFSET_DAMAGE_Y:int = 100;
      
      private static const OFFSET_HEAL_Y:int = 30;
      
      private static const SCALE_DAMAGE:Number = 1.5;
      
      private static const SCALE_HEAL:Number = 1.5;
      
      private static const SCALE_MISS:Number = 1.5;
      
      private static const ANIM_TIME_DAMAGE:Number = 0.08;
      
      private static const ANIM_TIME_HEAL:Number = 0.08;
      
      private static const ANIM_TIME_MISS:Number = 0.08;
      
      private static const DISPLAY_TIME:int = 800;
      
      private static const BG_PADDING:int = 80;
      
      private static const NUM_OFFSET_X:int = 5;
      
      private var _mcParent:Sprite;
      
      private var _mcbg:MovieClip;
      
      private var _numMc:Sprite;
      
      private var _timeoutId:int;
      
      private var _originalWidth:Number;
      
      private var _originalHeight:Number;
      
      private var _needMove:Boolean;
      
      public function BloodMc()
      {
         super();
      }
      
      public function show(value:int, parent:Sprite, isLeft:Boolean = true, showMiss:Boolean = true, isCritical:Boolean = false, isRestore:Boolean = false, offset:Point = null) : void
      {
         this._mcParent = parent;
         var config:DisplayConfig = this.createDisplayConfig(value,isLeft,showMiss,isCritical,isRestore,offset);
         this.buildDisplay(config);
         this.playAnimation(config);
      }
      
      public function dispose() : void
      {
         this.stopAnimation();
         this.clearTimeout();
         this.removeListeners();
         this.removeChi();
         this.removeFromParent();
         this._mcParent = null;
         this._mcbg = null;
         this._numMc = null;
      }
      
      private function createDisplayConfig(value:int, isLeft:Boolean, showMiss:Boolean, isCritical:Boolean, isRestore:Boolean, offset:Point) : DisplayConfig
      {
         var config:DisplayConfig = new DisplayConfig();
         config.value = value;
         config.isLeft = isLeft;
         config.showMiss = showMiss;
         config.isCritical = isCritical;
         config.isRestore = isRestore;
         this.calculatePosition(config,offset);
         this.calculateAnimation(config);
         return config;
      }
      
      private function calculatePosition(config:DisplayConfig, offset:Point) : void
      {
         var baseX:int = config.isLeft ? DEFAULT_LEFT_X : DEFAULT_RIGHT_X;
         var baseY:int = DEFAULT_Y;
         if(Boolean(offset))
         {
            baseX += config.isLeft ? offset.x : -offset.x;
            baseY += offset.y;
         }
         config.startX = baseX;
         config.startY = baseY;
         if(config.value < 0)
         {
            config.targetX = config.isLeft ? baseX + OFFSET_DAMAGE_X : baseX - OFFSET_DAMAGE_X;
            config.targetY = baseY - OFFSET_DAMAGE_Y;
         }
         else
         {
            config.targetX = baseX;
            config.targetY = baseY - OFFSET_HEAL_Y;
         }
      }
      
      private function calculateAnimation(config:DisplayConfig) : void
      {
         if(config.value < 0)
         {
            config.targetScale = SCALE_DAMAGE;
            config.animTime = ANIM_TIME_DAMAGE;
            config.needMove = false;
         }
         else
         {
            config.needMove = !config.showMiss;
            if(config.value == 0)
            {
               if(config.showMiss)
               {
                  config.animTime = ANIM_TIME_MISS;
                  config.targetScale = SCALE_MISS;
                  return;
               }
            }
            config.animTime = ANIM_TIME_HEAL;
            config.targetScale = SCALE_HEAL;
         }
      }
      
      private function buildDisplay(config:DisplayConfig) : void
      {
         if(config.isRestore)
         {
            this.buildRestoreDisplay(config);
         }
         else
         {
            this.buildNormalDisplay(config);
         }
         this.x = config.startX;
         this.y = config.startY;
         this._mcParent.addChild(this);
      }
      
      private function buildNormalDisplay(config:DisplayConfig) : void
      {
         if(config.value < 0)
         {
            this.buildDamageDisplay(config);
         }
         else
         {
            this.buildHealDisplay(config);
         }
      }
      
      private function buildDamageDisplay(config:DisplayConfig) : void
      {
         var bg:MovieClip = this.createBackground();
         bg.baoji.visible = config.isCritical;
         bg.visible = true;
         this._numMc = NumBuilder.build(config.value,1,true,config.showMiss);
         var scale:Number = (this._numMc.width + BG_PADDING) / this._originalWidth;
         bg.scaleX = scale;
         bg.scaleY = scale;
         this._numMc.x = bg.width * 0.5 - this._numMc.width * 0.7 + NUM_OFFSET_X;
         this._numMc.y = bg.height * 0.5 - this._numMc.height * 0.9;
         this.addChild(this._numMc);
      }
      
      private function buildHealDisplay(config:DisplayConfig) : void
      {
         this._numMc = NumBuilder.build(config.value,1,true,config.showMiss);
         this.addChild(this._numMc);
      }
      
      private function buildRestoreDisplay(config:DisplayConfig) : void
      {
         this._numMc = NumBuilder.buildBlue(config.value,1);
         this.addChild(this._numMc);
         config.needMove = true;
      }
      
      private function createBackground() : MovieClip
      {
         if(!this._mcbg)
         {
            this._mcbg = new (ApplicationDomain.currentDomain.getDefinition("bloodbg"))();
            this._originalWidth = this._mcbg.width;
            this._originalHeight = this._mcbg.height;
            this.addChild(this._mcbg);
         }
         return this._mcbg;
      }
      
      private function playAnimation(config:DisplayConfig) : void
      {
         this._needMove = config.needMove;
         Tweener.addTween(this,{
            "scaleX":config.targetScale,
            "scaleY":config.targetScale,
            "x":config.targetX,
            "y":config.targetY,
            "time":config.animTime,
            "transition":"easeInOutBack",
            "onComplete":this.onAnimationComplete
         });
      }
      
      private function onAnimationComplete() : void
      {
         if(this._needMove)
         {
            this.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         }
         this._timeoutId = setTimeout(this.onDisplayTimeout,DISPLAY_TIME);
      }
      
      private function onEnterFrame(event:Event) : void
      {
         --this.y;
         if(this.y < 0)
         {
            this.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         }
      }
      
      private function onDisplayTimeout() : void
      {
         this.visible = false;
         this.dispose();
      }
      
      private function stopAnimation() : void
      {
         Tweener.removeTweens(this);
      }
      
      private function clearTimeout() : void
      {
         if(this._timeoutId != 0)
         {
            clearTimeout(this._timeoutId);
            this._timeoutId = 0;
         }
      }
      
      private function removeListeners() : void
      {
         this.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      private function removeChi() : void
      {
         if(Boolean(this._mcbg))
         {
            this._mcbg.stop();
            if(this.contains(this._mcbg))
            {
               this.removeChild(this._mcbg);
            }
         }
         if(Boolean(this._numMc))
         {
            if(this.contains(this._numMc))
            {
               this.removeChild(this._numMc);
            }
            this.cleanupSprite(this._numMc);
         }
         while(this.numChildren > 0)
         {
            this.removeChildAt(0);
         }
      }
      
      private function removeFromParent() : void
      {
         if(Boolean(this._mcParent) && this._mcParent.contains(this))
         {
            this._mcParent.removeChild(this);
         }
      }
      
      private function cleanupSprite(sprite:Sprite) : void
      {
         var child:* = undefined;
         while(sprite.numChildren > 0)
         {
            child = sprite.getChildAt(0);
            if(child is MovieClip)
            {
               MovieClip(child).stop();
            }
            sprite.removeChildAt(0);
         }
      }
      
      protected function set numMc(value:Sprite) : void
      {
         this._numMc = value;
      }
      
      protected function stopAnimationInternal() : void
      {
         Tweener.removeTweens(this);
      }
      
      protected function clearTimeoutInternal() : void
      {
         if(this._timeoutId != 0)
         {
            clearTimeout(this._timeoutId);
            this._timeoutId = 0;
         }
      }
      
      protected function removeListenersInternal() : void
      {
         this.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      protected function clearAllChildren() : void
      {
         var child:* = undefined;
         if(Boolean(this._mcbg))
         {
            this._mcbg.stop();
            if(this._mcbg.hasOwnProperty("baoji"))
            {
               this._mcbg["baoji"].visible = false;
            }
            this._mcbg.visible = false;
         }
         if(Boolean(this._numMc))
         {
            this.cleanupNumMc();
         }
         while(this.numChildren > 0)
         {
            child = this.getChildAt(0);
            if(child is MovieClip)
            {
               MovieClip(child).stop();
            }
            this.removeChildAt(0);
         }
      }
      
      private function cleanupNumMc() : void
      {
         var child:* = undefined;
         while(this._numMc.numChildren > 0)
         {
            child = this._numMc.getChildAt(0);
            if(child is MovieClip)
            {
               MovieClip(child).stop();
            }
            this._numMc.removeChildAt(0);
         }
         this._numMc = null;
      }
      
      protected function resetInternal() : void
      {
         this._mcbg = null;
         this._numMc = null;
         this._needMove = false;
         this._originalWidth = 0;
         this._originalHeight = 0;
      }
      
      protected function get mcbg() : MovieClip
      {
         return this._mcbg;
      }
      
      protected function get numMc() : Sprite
      {
         return this._numMc;
      }
   }
}

class DisplayConfig
{
   
   public var value:int;
   
   public var isLeft:Boolean;
   
   public var showMiss:Boolean;
   
   public var isCritical:Boolean;
   
   public var isRestore:Boolean;
   
   public var startX:int;
   
   public var startY:int;
   
   public var targetX:int;
   
   public var targetY:int;
   
   public var targetScale:Number;
   
   public var animTime:Number;
   
   public var needMove:Boolean;
   
   public function DisplayConfig()
   {
      super();
   }
}
