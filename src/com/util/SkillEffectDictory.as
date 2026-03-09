package com.util
{
   import com.publiccomponent.loading.Hloader;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.TimerEvent;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   
   public class SkillEffectDictory extends EventDispatcher
   {
      
      private static var _instance:SkillEffectDictory;
      
      public static const SKILLEFFECTOK:String = "skilleffectok";
      
      public static const LOADPROGRESS:String = "loadprogress";
      
      public var effectDictionary:Dictionary = new Dictionary();
      
      public var effectIdArr:Array = [19,146,23,44,51,56,127,128,49,30,31,25,26,79,131];
      
      public var failCatchLoader:Hloader;
      
      public var successCatchLoader:Hloader;
      
      public var spiritEnterLoader:Hloader;
      
      private var failBool:Boolean;
      
      private var spiritBool:Boolean;
      
      private var successBool:Boolean;
      
      public var addBloodLoader:Hloader;
      
      private var bloodBool:Boolean;
      
      public var addBlueLoader:Hloader;
      
      private var blueBool:Boolean;
      
      private var canupload:Boolean = false;
      
      public var countnum:int;
      
      private var maxCountNum:int;
      
      private var delayTimer:Timer;
      
      public function SkillEffectDictory()
      {
         super();
      }
      
      public static function get instance() : SkillEffectDictory
      {
         if(_instance == null)
         {
            _instance = new SkillEffectDictory();
         }
         return _instance;
      }
      
      public function loadDefaultEffect() : void
      {
         var i:int = 0;
         this.countnum = 0;
         this.maxCountNum = 0;
         this.canupload = false;
         if(!this.failBool)
         {
            ++this.maxCountNum;
            this.failCatchLoader = new Hloader("assets/battle/battleEffect/catchfail.swf");
            this.failCatchLoader.addEventListener(Event.COMPLETE,this.onFailCatchHandler);
         }
         if(!this.bloodBool)
         {
            ++this.maxCountNum;
            this.addBloodLoader = new Hloader("assets/battle/battleEffect/bloodEffect.swf");
            this.addBloodLoader.addEventListener(Event.COMPLETE,this.onBloodHandler);
         }
         if(!this.blueBool)
         {
            ++this.maxCountNum;
            this.addBlueLoader = new Hloader("assets/battle/battleEffect/blueEffect.swf");
            this.addBlueLoader.addEventListener(Event.COMPLETE,this.onBlueHandler);
         }
         if(!this.spiritBool)
         {
            ++this.maxCountNum;
            this.spiritEnterLoader = new Hloader("assets/battle/battleEffect/spiritentereffect.swf");
            this.spiritEnterLoader.loader.name = "enterEffect";
            this.spiritEnterLoader.addEventListener(Event.COMPLETE,this.onEnterSceneHandler);
         }
         if(!this.successBool)
         {
            ++this.maxCountNum;
            this.successCatchLoader = new Hloader("assets/battle/battleEffect/catchsuccess.swf");
            this.successCatchLoader.addEventListener(Event.COMPLETE,this.onSuccessEffectHandler);
         }
         this.maxCountNum += this.effectIdArr.length;
         var l:int = int(this.effectIdArr.length);
         for(i = 0; i < l; i++)
         {
            this.addBeforehandEffect(this.effectIdArr[i]);
         }
         this.check();
      }
      
      public function addBeforehandEffect(id:int) : void
      {
         if(id > 0 && !this.effectDictionary.hasOwnProperty(id.toString()))
         {
            this.loadEffect(id);
         }
         else
         {
            ++this.countnum;
         }
         this.check();
      }
      
      private function loadEffect(effectID:int) : void
      {
         var loader:Hloader = new Hloader("assets/battle/battleEffect/effect" + effectID);
         loader.addEventListener(Event.COMPLETE,this.onLoadComplete);
         loader.addEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
         loader.loader.name = effectID.toString();
      }
      
      public function addEffect(id:int) : void
      {
         var temploader:Hloader = null;
         if(this.effectDictionary[id] == undefined)
         {
            temploader = new Hloader("assets/battle/battleEffect/effect" + id);
            temploader.addEventListener(Event.COMPLETE,this.onEffectLoadComp);
            temploader.addEventListener(IOErrorEvent.IO_ERROR,this.onEffectLoadError);
            temploader.loader.name = id.toString();
         }
      }
      
      private function onEffectLoadComp(event:Event) : void
      {
         event.target.loader.removeEventListener(Event.COMPLETE,this.onEffectLoadComp);
         event.target.loader.removeEventListener(IOErrorEvent.IO_ERROR,this.onEffectLoadError);
         event.target.loader.removeEventListener(Event.UNLOAD,this.onUploadHandler);
         var effectid:int = int(event.target.loader.name);
         this.effectDictionary[effectid] = event.target.loader;
      }
      
      private function onEffectLoadError(event:IOErrorEvent) : void
      {
         event.target.loader.removeEventListener(Event.COMPLETE,this.onEffectLoadComp);
         event.target.loader.removeEventListener(IOErrorEvent.IO_ERROR,this.onEffectLoadError);
         event.target.loader.removeEventListener(Event.UNLOAD,this.onUploadHandler);
         O.o("加载出错。。。【发生在skilleffectDictory】",event);
         this.effectDictionary[int(event.target.loader.name)] = "";
      }
      
      private function onUploadHandler(event:Event) : void
      {
         if(!this.canupload)
         {
            this.loadDefaultEffect();
         }
      }
      
      private function onEnterSceneHandler(event:Event) : void
      {
         event.target.loader.removeEventListener(Event.COMPLETE,this.onEnterSceneHandler);
         event.target.loader.removeEventListener(Event.UNLOAD,this.onUploadHandler);
         ++this.countnum;
         this.effectDictionary["enterEffect"] = event.target.loader;
         this.spiritBool = true;
         this.check();
      }
      
      private function onBloodHandler(event:Event) : void
      {
         event.target.loader.removeEventListener(Event.COMPLETE,this.onBloodHandler);
         event.target.loader.removeEventListener(Event.UNLOAD,this.onUploadHandler);
         ++this.countnum;
         this.effectDictionary["bloodEffect"] = event.target.loader;
         this.bloodBool = true;
         this.check();
      }
      
      private function onBlueHandler(event:Event) : void
      {
         event.target.loader.removeEventListener(Event.COMPLETE,this.onBlueHandler);
         event.target.loader.removeEventListener(Event.UNLOAD,this.onUploadHandler);
         ++this.countnum;
         this.effectDictionary["blueEffect"] = event.target.loader;
         this.blueBool = true;
         this.check();
      }
      
      private function onFailCatchHandler(event:Event) : void
      {
         event.target.loader.removeEventListener(Event.COMPLETE,this.onFailCatchHandler);
         event.target.loader.removeEventListener(Event.UNLOAD,this.onUploadHandler);
         ++this.countnum;
         this.effectDictionary["failEffect"] = event.target.loader;
         this.failBool = true;
         this.check();
      }
      
      private function onSuccessEffectHandler(event:Event) : void
      {
         event.target.loader.removeEventListener(Event.COMPLETE,this.onSuccessEffectHandler);
         event.target.loader.removeEventListener(Event.UNLOAD,this.onUploadHandler);
         ++this.countnum;
         this.effectDictionary["successEffect"] = event.target.loader;
         this.successBool = true;
         this.check();
      }
      
      private function onLoadComplete(event:Event) : void
      {
         event.target.loader.removeEventListener(Event.COMPLETE,this.onLoadComplete);
         event.target.loader.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
         event.target.loader.removeEventListener(Event.UNLOAD,this.onUploadHandler);
         ++this.countnum;
         var effectid:int = int(event.target.loader.name);
         this.effectDictionary[effectid] = event.target.loader;
         this.check();
      }
      
      private function onLoadError(event:IOErrorEvent) : void
      {
         event.target.loader.removeEventListener(Event.COMPLETE,this.onLoadComplete);
         event.target.loader.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
         event.target.loader.removeEventListener(Event.UNLOAD,this.onUploadHandler);
         ++this.countnum;
         O.o("加载出错。。。【发生在skilleffectDictory】",event);
         this.effectDictionary[int(event.target.loader.name)] = "";
         this.check();
      }
      
      private function check() : void
      {
         dispatchEvent(new Event(LOADPROGRESS));
         if(!this.failBool || !this.spiritBool || !this.successBool)
         {
            return;
         }
         if(this.maxCountNum > this.countnum)
         {
            return;
         }
         this.stopDelayTimer();
         dispatchEvent(new Event(SkillEffectDictory.SKILLEFFECTOK));
      }
      
      public function getEffect(id:*) : Loader
      {
         if(this.effectDictionary[id] == "")
         {
            return null;
         }
         return this.effectDictionary[id];
      }
      
      private function startDelayTime() : void
      {
         if(this.delayTimer != null)
         {
            this.delayTimer.stop();
            this.delayTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onDelayTimer);
            this.delayTimer = null;
         }
         this.delayTimer = new Timer(60000,1);
         this.delayTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onDelayTimer);
         this.delayTimer.start();
      }
      
      private function onDelayTimer(event:TimerEvent) : void
      {
         this.loadDefaultEffect();
      }
      
      private function stopDelayTimer() : void
      {
         if(this.delayTimer != null)
         {
            this.delayTimer.stop();
            this.delayTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onDelayTimer);
            this.delayTimer = null;
         }
      }
      
      public function disport() : void
      {
         this.canupload = true;
         for(var i:int = 0; i < this.effectIdArr.length; i++)
         {
            if(Boolean(this.effectDictionary[this.effectIdArr[i]] as Loader))
            {
               this.effectDictionary[this.effectIdArr[i]].unload();
               delete this.effectDictionary[this.effectIdArr[i]];
            }
         }
      }
   }
}

