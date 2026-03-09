package com.game.modules.view.battle
{
   import com.game.global.GlobalConfig;
   import com.game.modules.view.battle.util.FramedAnimation;
   import com.kb.util.Handler;
   import com.util.SkillEffectDictory;
   import com.xygame.module.battle.util.Rotation180;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.geom.Matrix;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   
   public class EffectView extends Sprite
   {
      
      public static const EFFECTPLAYOVER:String = "effectplayerover";
      
      public static const ENTEREFFECTOVER:String = "entereffectover";
      
      public static const CATCHEFFECTOVER:String = "catcheffectover";
      
      public static const CATCHFAILOVER:String = "catchfailover";
      
      public static const SPIRITLIVEOUT:String = "spiritliveout";
      
      public static const SPIRITDIEOUT:String = "spiritdieout";
      
      private static const PLAYER_EFFECT_X:Number = 970;
      
      private static const LEFT_EFFECT_X:Number = -10;
      
      private static const RIGHT_EFFECT_X:Number = 520;
      
      private static const CENTER_X:Number = 510;
      
      private static const EFFECT_Y:Number = 50;
      
      private static const FRAME_RATE:int = 24;
      
      private static const SHAKE_EXTENT:int = 15;
      
      private static const SHAKE_INTERVAL:int = 10;
      
      private static const SHAKE_COUNT:int = 12;
      
      private var _playerEffect:Loader;
      
      private var _otherEffect:Loader;
      
      private var _playerMc:*;
      
      private var _otherMc:*;
      
      private var _playerPlaying:Boolean = false;
      
      private var _otherPlaying:Boolean = false;
      
      private var _playingEffect:Boolean = false;
      
      public var operationAfterEffect:Boolean = false;
      
      private var _effectDic:Dictionary;
      
      private var _failMc:MovieClip;
      
      private var _successMc:MovieClip;
      
      private var _failMcY:Number;
      
      private var _laddbloodEffectMc:MovieClip;
      
      private var _raddbloodEffectMc:MovieClip;
      
      private var _laddbloodEffectFA:FramedAnimation;
      
      private var _raddbloodEffectFA:FramedAnimation;
      
      private var _laddblueEffectMc:MovieClip;
      
      private var _raddblueEffectMc:MovieClip;
      
      private var _laddblueEffectFA:FramedAnimation;
      
      private var _raddblueEffectFA:FramedAnimation;
      
      private var _shakeCounter:int;
      
      private var _shakeIndex:int;
      
      private var _tempMatrix:Matrix;
      
      private var _originalMatrix:Matrix;
      
      private var _shakeObject:DisplayObject;
      
      private var _shakeTimer:Timer;
      
      public function EffectView()
      {
         super();
         this._effectDic = new Dictionary();
      }
      
      public function newRound() : void
      {
         this._playerPlaying = false;
         this._otherPlaying = false;
         this.playingEffect = false;
         this.operationAfterEffect = false;
      }
      
      public function addeffect(playerLoader:Loader, otherLoader:Loader) : void
      {
         try
         {
            if(Boolean(playerLoader))
            {
               this.addPlayerEffect(playerLoader);
            }
            else
            {
               this._playerPlaying = false;
            }
            if(Boolean(otherLoader))
            {
               this.addOtherEffect(otherLoader);
            }
            else
            {
               this._otherPlaying = false;
            }
            this.playingEffect = this._playerPlaying || this._otherPlaying;
         }
         catch(e:Error)
         {
            O.o("[EffectView] 添加特效异常:",e.message);
            playingEffect = false;
         }
      }
      
      private function addPlayerEffect(loader:Loader) : void
      {
         if(this._playerMc && this.contains(this._playerMc))
         {
            return;
         }
         this._playerEffect = loader;
         var effectName:String = loader.name;
         var cacheKey:String = "player_" + effectName;
         if(Boolean(this._effectDic[cacheKey]))
         {
            this._playerMc = this._effectDic[cacheKey];
         }
         else
         {
            this._playerMc = this.createEffect(loader,effectName,true);
            this._effectDic[cacheKey] = this._playerMc;
         }
         if(effectName != "enterEffect")
         {
            this._playerMc.x = PLAYER_EFFECT_X;
         }
         this._playerPlaying = true;
         addChild(this._playerMc);
         this.playEffect(this._playerMc,this.onPlayerEffectComplete);
      }
      
      private function addOtherEffect(loader:Loader) : void
      {
         if(this._otherMc && this.contains(this._otherMc))
         {
            return;
         }
         this._otherEffect = loader;
         var effectName:String = loader.name;
         var cacheKey:String = "other_" + effectName;
         if(Boolean(this._effectDic[cacheKey]))
         {
            this._otherMc = this._effectDic[cacheKey];
         }
         else
         {
            this._otherMc = this.createEffect(loader,effectName,false);
            this._effectDic[cacheKey] = this._otherMc;
         }
         this._otherPlaying = true;
         addChild(this._otherMc);
         this.playEffect(this._otherMc,this.onOtherEffectComplete);
      }
      
      private function createEffect(loader:Loader, effectName:String, isPlayer:Boolean) : *
      {
         var effect:* = undefined;
         var className:String = effectName == "enterEffect" ? "enterEffect" : "effect" + effectName;
         var EffectClass:Object = loader.contentLoaderInfo.applicationDomain.getDefinition(className);
         if(GlobalConfig.COMBAT_GAP_TIME == 1)
         {
            effect = new EffectClass();
            effect.name = className;
            if(isPlayer && effectName != "enterEffect")
            {
               effect = Rotation180.rotationX180(effect);
            }
         }
         else
         {
            effect = FramedAnimation.createAnimationFromMoveClip(new EffectClass() as MovieClip,FramedAnimation.SOURCE_TYPE_MIX_CLIP);
            effect.name = className;
            effect.frameRate = FRAME_RATE;
            if(isPlayer && effectName != "enterEffect")
            {
               effect.scaleX = -1;
            }
         }
         return effect;
      }
      
      private function playEffect(effect:*, completeHandler:Function) : void
      {
         if(effect is FramedAnimation)
         {
            effect.currentFrame = 1;
            effect.setFrameHandler(effect.totalFrames - 1,new Handler(null,completeHandler),true);
            effect.play();
         }
         else if(effect is MovieClip)
         {
            effect.gotoAndStop(1);
            effect.addEventListener(Event.FRAME_CONSTRUCTED,function(e:Event):void
            {
               effect.removeEventListener(Event.FRAME_CONSTRUCTED,arguments.callee);
               effect.addFrameScript(effect.totalFrames - 1,completeHandler);
               effect.play();
            });
         }
      }
      
      private function stopEffect(effect:*) : void
      {
         if(!effect)
         {
            return;
         }
         if(effect is MovieClip)
         {
            effect.gotoAndStop(1);
            effect.addFrameScript(effect.totalFrames - 1,null);
         }
         else if(effect is FramedAnimation)
         {
            effect.currentFrame = 1;
            effect.setFrameHandler(effect.totalFrames - 1,null);
         }
         effect.stop();
         if(Boolean(effect.parent))
         {
            effect.parent.removeChild(effect);
         }
      }
      
      private function onPlayerEffectComplete(... arg) : void
      {
         var isEnterEffect:Boolean = this._playerMc && this._playerMc.name == "enterEffect";
         this.stopEffect(this._playerMc);
         this._playerMc = null;
         this._playerPlaying = false;
         if(isEnterEffect)
         {
            this.playingEffect = false;
            dispatchEvent(new Event(ENTEREFFECTOVER));
         }
         else
         {
            this.checkAllEffectsComplete();
         }
      }
      
      private function onOtherEffectComplete(... arg) : void
      {
         this.stopEffect(this._otherMc);
         this._otherMc = null;
         this._otherPlaying = false;
         this.checkAllEffectsComplete();
      }
      
      private function checkAllEffectsComplete() : void
      {
         if(!this._playerPlaying && !this._otherPlaying)
         {
            this.playingEffect = false;
            this._playerEffect = null;
            this._otherEffect = null;
            dispatchEvent(new Event(EFFECTPLAYOVER));
         }
      }
      
      public function failCatchEffect() : void
      {
         var FailClass:Object = null;
         if(!this._failMc)
         {
            FailClass = SkillEffectDictory.instance.failCatchLoader.loader.contentLoaderInfo.applicationDomain.getDefinition("failEffect");
            this._failMc = new FailClass();
            this._failMcY = this._failMc.y;
         }
         this._failMc.gotoAndPlay(1);
         this._failMc.x = CENTER_X;
         this._failMc.y = this._failMcY - 80;
         addChild(this._failMc);
         this.playingEffect = true;
         addEventListener(Event.ENTER_FRAME,this.onCatchFailFrame);
      }
      
      private function onCatchFailFrame(event:Event) : void
      {
         if(!this._failMc)
         {
            removeEventListener(Event.ENTER_FRAME,this.onCatchFailFrame);
            this.playingEffect = false;
            return;
         }
         var currentFrame:int = this._failMc.currentFrame;
         var totalFrames:int = this._failMc.totalFrames;
         if(currentFrame == int(totalFrames / 2))
         {
            dispatchEvent(new Event(SPIRITLIVEOUT));
         }
         else if(currentFrame == totalFrames)
         {
            removeEventListener(Event.ENTER_FRAME,this.onCatchFailFrame);
            this.stopEffect(this._failMc);
            dispatchEvent(new Event(CATCHEFFECTOVER));
            this.playingEffect = false;
         }
      }
      
      public function successCatchEffect() : void
      {
         var SuccessClass:Object = null;
         if(!this._successMc)
         {
            SuccessClass = SkillEffectDictory.instance.successCatchLoader.contentLoaderInfo.applicationDomain.getDefinition("successEffect");
            this._successMc = new SuccessClass();
         }
         this._successMc.gotoAndPlay(1);
         this._successMc.x = CENTER_X;
         this._successMc.y -= 60;
         addChild(this._successMc);
         this.playingEffect = true;
         addEventListener(Event.ENTER_FRAME,this.onCatchSuccessFrame);
      }
      
      private function onCatchSuccessFrame(event:Event) : void
      {
         if(!this._successMc)
         {
            removeEventListener(Event.ENTER_FRAME,this.onCatchSuccessFrame);
            this.playingEffect = false;
            return;
         }
         var currentFrame:int = this._successMc.currentFrame;
         var totalFrames:int = this._successMc.totalFrames;
         if(currentFrame == int(totalFrames / 2))
         {
            dispatchEvent(new Event(SPIRITDIEOUT));
         }
         else if(currentFrame == totalFrames)
         {
            removeEventListener(Event.ENTER_FRAME,this.onCatchSuccessFrame);
            this.stopEffect(this._successMc);
            dispatchEvent(new Event(CATCHEFFECTOVER));
            this.playingEffect = false;
         }
      }
      
      public function addBloodEffect(left:Boolean = false) : void
      {
         var mc:MovieClip = null;
         var handler:Function = null;
         var fa:FramedAnimation = null;
         var faHandler:Function = null;
         this.playingEffect = true;
         if(GlobalConfig.COMBAT_GAP_TIME == 1)
         {
            mc = left ? this.laddbloodEffectMc : this.raddbloodEffectMc;
            handler = left ? this.onLaddBloodEffectMcComplete : this.onRaddBloodEffectMcComplete;
            mc.gotoAndPlay(1);
            mc.addFrameScript(mc.totalFrames - 1,handler);
            addChild(mc);
         }
         else
         {
            fa = left ? this.laddbloodEffectFA : this.raddbloodEffectFA;
            faHandler = left ? this.onLaddBloodEffectFAComplete : this.onRaddBloodEffectFAComplete;
            fa.currentFrame = 1;
            fa.play();
            fa.setFrameHandler(fa.totalFrames - 1,new Handler(null,faHandler),true);
            addChild(fa);
         }
      }
      
      public function get laddbloodEffectMc() : MovieClip
      {
         if(!this._laddbloodEffectMc)
         {
            this._laddbloodEffectMc = this.createBloodEffect(LEFT_EFFECT_X,EFFECT_Y);
         }
         return this._laddbloodEffectMc;
      }
      
      public function get raddbloodEffectMc() : MovieClip
      {
         if(!this._raddbloodEffectMc)
         {
            this._raddbloodEffectMc = this.createBloodEffect(RIGHT_EFFECT_X,EFFECT_Y);
         }
         return this._raddbloodEffectMc;
      }
      
      public function get laddbloodEffectFA() : FramedAnimation
      {
         if(!this._laddbloodEffectFA)
         {
            this._laddbloodEffectFA = this.createBloodEffectFA(LEFT_EFFECT_X,EFFECT_Y);
         }
         return this._laddbloodEffectFA;
      }
      
      public function get raddbloodEffectFA() : FramedAnimation
      {
         if(!this._raddbloodEffectFA)
         {
            this._raddbloodEffectFA = this.createBloodEffectFA(RIGHT_EFFECT_X,EFFECT_Y);
         }
         return this._raddbloodEffectFA;
      }
      
      private function createBloodEffect(x:Number, y:Number) : MovieClip
      {
         var mc:MovieClip = null;
         var EffectClass:Object = SkillEffectDictory.instance.addBloodLoader.contentLoaderInfo.applicationDomain.getDefinition("addbloodEffect");
         mc = new EffectClass();
         mc.x = x;
         mc.y = y;
         return mc;
      }
      
      private function createBloodEffectFA(x:Number, y:Number) : FramedAnimation
      {
         var mc:MovieClip = this.createBloodEffect(x,y);
         var fa:FramedAnimation = FramedAnimation.createAnimationFromMoveClip(mc,FramedAnimation.SOURCE_TYPE_MIX_CLIP,mc.scaleX,mc.scaleY);
         fa.x = x;
         fa.y = y;
         fa.frameRate = FRAME_RATE;
         return fa;
      }
      
      private function onLaddBloodEffectMcComplete() : void
      {
         this.cleanupEffect(this._laddbloodEffectMc);
      }
      
      private function onRaddBloodEffectMcComplete() : void
      {
         this.cleanupEffect(this._raddbloodEffectMc);
      }
      
      private function onLaddBloodEffectFAComplete(... arg) : void
      {
         this.cleanupEffect(this._laddbloodEffectFA);
      }
      
      private function onRaddBloodEffectFAComplete(... arg) : void
      {
         this.cleanupEffect(this._raddbloodEffectFA);
      }
      
      public function addBlueEffect(left:Boolean = false) : void
      {
         var mc:MovieClip = null;
         var handler:Function = null;
         var fa:FramedAnimation = null;
         var faHandler:Function = null;
         this.playingEffect = true;
         if(GlobalConfig.COMBAT_GAP_TIME == 1)
         {
            mc = left ? this.laddblueEffectMc : this.raddblueEffectMc;
            handler = left ? this.onLaddBlueEffectMcComplete : this.onRaddBlueEffectMcComplete;
            mc.gotoAndPlay(1);
            mc.addFrameScript(mc.totalFrames - 1,handler);
            addChild(mc);
         }
         else
         {
            fa = left ? this.laddblueEffectFA : this.raddblueEffectFA;
            faHandler = left ? this.onLaddBlueEffectFAComplete : this.onRaddBlueEffectFAComplete;
            fa.currentFrame = 1;
            fa.play();
            fa.setFrameHandler(fa.totalFrames - 1,new Handler(null,faHandler),true);
            addChild(fa);
         }
      }
      
      public function get laddblueEffectMc() : MovieClip
      {
         if(!this._laddblueEffectMc)
         {
            this._laddblueEffectMc = this.createBlueEffect(LEFT_EFFECT_X,EFFECT_Y);
         }
         return this._laddblueEffectMc;
      }
      
      public function get raddblueEffectMc() : MovieClip
      {
         if(!this._raddblueEffectMc)
         {
            this._raddblueEffectMc = this.createBlueEffect(RIGHT_EFFECT_X,EFFECT_Y);
         }
         return this._raddblueEffectMc;
      }
      
      public function get laddblueEffectFA() : FramedAnimation
      {
         if(!this._laddblueEffectFA)
         {
            this._laddblueEffectFA = this.createBlueEffectFA(LEFT_EFFECT_X,EFFECT_Y);
         }
         return this._laddblueEffectFA;
      }
      
      public function get raddblueEffectFA() : FramedAnimation
      {
         if(!this._raddblueEffectFA)
         {
            this._raddblueEffectFA = this.createBlueEffectFA(RIGHT_EFFECT_X,EFFECT_Y);
         }
         return this._raddblueEffectFA;
      }
      
      private function createBlueEffect(x:Number, y:Number) : MovieClip
      {
         var EffectClass:Object = SkillEffectDictory.instance.addBlueLoader.contentLoaderInfo.applicationDomain.getDefinition("addblueEffect");
         var mc:MovieClip = new EffectClass();
         mc.x = x;
         mc.y = y;
         return mc;
      }
      
      private function createBlueEffectFA(x:Number, y:Number) : FramedAnimation
      {
         var mc:MovieClip = this.createBlueEffect(x,y);
         var fa:FramedAnimation = FramedAnimation.createAnimationFromMoveClip(mc,FramedAnimation.SOURCE_TYPE_MIX_CLIP,mc.scaleX,mc.scaleY);
         fa.x = x;
         fa.y = y;
         fa.frameRate = FRAME_RATE;
         return fa;
      }
      
      private function onLaddBlueEffectMcComplete() : void
      {
         this.cleanupEffect(this._laddblueEffectMc);
      }
      
      private function onRaddBlueEffectMcComplete() : void
      {
         this.cleanupEffect(this._raddblueEffectMc);
      }
      
      private function onLaddBlueEffectFAComplete(... arg) : void
      {
         this.cleanupEffect(this._laddblueEffectFA);
      }
      
      private function onRaddBlueEffectFAComplete(... arg) : void
      {
         this.cleanupEffect(this._raddblueEffectFA);
      }
      
      private function cleanupEffect(effect:*) : void
      {
         if(!effect)
         {
            return;
         }
         if(effect is MovieClip)
         {
            effect.addFrameScript(effect.totalFrames - 1,null);
            effect.stop();
         }
         else if(effect is FramedAnimation)
         {
            effect.currentFrame = 1;
            effect.stop();
         }
         if(Boolean(effect.parent))
         {
            effect.parent.removeChild(effect);
         }
         this.playingEffect = false;
         this.checkAllEffectsComplete();
      }
      
      public function shakeWindow(shakeObj:DisplayObject) : void
      {
         this._shakeIndex = 0;
         this._shakeCounter = SHAKE_COUNT;
         this._shakeObject = shakeObj;
         this._originalMatrix = this._shakeObject.transform.matrix;
         this.startShakeTimer();
      }
      
      private function startShakeTimer() : void
      {
         this.stopShakeTimer();
         this._shakeTimer = new Timer(SHAKE_INTERVAL);
         this._shakeTimer.addEventListener(TimerEvent.TIMER,this.onShakeTimer);
         this._shakeTimer.start();
      }
      
      private function stopShakeTimer() : void
      {
         if(Boolean(this._shakeTimer))
         {
            this._shakeTimer.stop();
            this._shakeTimer.removeEventListener(TimerEvent.TIMER,this.onShakeTimer);
            this._shakeTimer = null;
         }
      }
      
      private function onShakeTimer(event:TimerEvent) : void
      {
         var extent:int = this._shakeIndex % 2 == 0 ? SHAKE_EXTENT : int(-SHAKE_EXTENT);
         this._tempMatrix = this._shakeObject.transform.matrix;
         this._tempMatrix.translate(extent,extent);
         this._shakeObject.transform.matrix = this._tempMatrix;
         ++this._shakeIndex;
         if(this._shakeIndex >= this._shakeCounter)
         {
            this.stopShakeTimer();
            this._shakeObject.transform.matrix = this._originalMatrix;
         }
      }
      
      public function clearAllEffect() : void
      {
      }
      
      public function destroy() : void
      {
         var key:String = null;
         var obj:DisplayObjectContainer = null;
         this.stopEffect(this._playerMc);
         this.stopEffect(this._otherMc);
         this._playerMc = null;
         this._otherMc = null;
         this._playerEffect = null;
         this._otherEffect = null;
         if(Boolean(this._effectDic))
         {
            for(key in this._effectDic)
            {
               obj = this._effectDic[key];
               if(Boolean(obj) && Boolean(obj.parent))
               {
                  obj.parent.removeChild(obj);
               }
               delete this._effectDic[key];
            }
            this._effectDic = null;
         }
         this._laddbloodEffectMc = null;
         this._raddbloodEffectMc = null;
         this._laddbloodEffectFA = null;
         this._raddbloodEffectFA = null;
         this._laddblueEffectMc = null;
         this._raddblueEffectMc = null;
         this._laddblueEffectFA = null;
         this._raddblueEffectFA = null;
         this._successMc = null;
         this._failMc = null;
         removeEventListener(Event.ENTER_FRAME,this.onCatchSuccessFrame);
         removeEventListener(Event.ENTER_FRAME,this.onCatchFailFrame);
         this.stopShakeTimer();
         while(numChildren > 0)
         {
            removeChildAt(0);
         }
      }
      
      public function get playingEffect() : Boolean
      {
         return this._playingEffect;
      }
      
      public function set playingEffect(value:Boolean) : void
      {
         this._playingEffect = value;
      }
   }
}

