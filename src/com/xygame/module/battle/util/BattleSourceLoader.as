package com.xygame.module.battle.util
{
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.loading.Hloader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.TimerEvent;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.utils.Timer;
   
   public class BattleSourceLoader extends EventDispatcher
   {
      
      public static const sourceOk:String = "battlesourceok";
      
      private var delayTimer:Timer;
      
      public var classIconLoader:Hloader;
      
      public var battleBgLoader:Hloader;
      
      private var _battleApp:ApplicationDomain;
      
      public var battleBgUrl:String = URLUtil.getSvnVer("assets/battle/battlebg/4.swf");
      
      private var classIconBool:Boolean = false;
      
      public var battleBg:MovieClip;
      
      private var classIconUrl:String = URLUtil.getSvnVer("assets/battle/battlebg/skillIcon.swf");
      
      private var battleBgBool:Boolean = false;
      
      public var lc:LoaderContext = new LoaderContext(false,ApplicationDomain.currentDomain);
      
      public function BattleSourceLoader(target:IEventDispatcher = null)
      {
         super(target);
      }
      
      private function onDelayTimer(event:TimerEvent) : void
      {
         this.loaderSource();
      }
      
      public function destroy() : void
      {
         var _local1:* = undefined;
         if(Boolean(this.battleBg))
         {
            this.battleBg.stop();
         }
         this.battleBg = null;
         if(Boolean(this.battleBgLoader))
         {
            _local1 = this.battleBgLoader;
            _local1["unloadAndStop"](true);
         }
         this.battleBgLoader = null;
         if(Boolean(this.classIconLoader))
         {
            _local1 = this.classIconLoader;
            _local1["unloadAndStop"](true);
            this.classIconLoader = null;
         }
      }
      
      private function loadBg() : void
      {
         this.battleBgLoader = new Hloader(this.battleBgUrl,null,this.lc);
         this.battleBgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onBgLoaderComp,false,0,true);
      }
      
      private function loadClassIcon() : void
      {
         this.classIconLoader = new Hloader(this.classIconUrl,null,this.lc);
         this.classIconLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onClassIconComp,false,0,true);
      }
      
      public function loaderSource() : void
      {
         this.startDelayTime();
         if(!ApplicationDomain.currentDomain.hasDefinition("skillmc"))
         {
            this.classIconBool = false;
            this.loadClassIcon();
         }
         else
         {
            this.classIconBool = true;
         }
         if(this.battleBg == null)
         {
            this.loadBg();
            this.battleBgBool = false;
         }
      }
      
      private function onClassIconComp(event:Event) : void
      {
         this.classIconLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onClassIconComp);
         this.classIconBool = true;
         this.sourceLoaderComp();
      }
      
      private function onBgLoaderComp(event:Event) : void
      {
         if(Boolean(this.battleBgLoader))
         {
            this.battleBgLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onBgLoaderComp);
            this.battleBg = this.battleBgLoader.content as MovieClip;
            this.battleBgBool = true;
            this._battleApp = event.currentTarget.applicationDomain;
            this.sourceLoaderComp();
         }
      }
      
      public function getInstanceByBattleClass(className:String) : Object
      {
         return new (this._battleApp.getDefinition(className) as Class)();
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
      
      private function startDelayTime() : void
      {
         if(this.delayTimer != null)
         {
            this.delayTimer.stop();
            this.delayTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onDelayTimer);
            this.delayTimer = null;
         }
         this.delayTimer = new Timer(10000,1);
         this.delayTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onDelayTimer,false,0,true);
         this.delayTimer.start();
      }
      
      private function sourceLoaderComp() : void
      {
         if(this.battleBgBool && this.classIconBool)
         {
            this.stopDelayTimer();
            this.dispatchEvent(new Event(BattleSourceLoader.sourceOk));
         }
      }
   }
}

