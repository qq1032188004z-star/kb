package com.game.modules.view.battle.item
{
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.system.ApplicationDomain;
   import flash.text.TextField;
   import flash.utils.Timer;
   
   public class LanguageItem extends Sprite
   {
      
      private static var _instance:LanguageItem;
      
      private var playertxt:TextField;
      
      private var othertxt:TextField;
      
      private var bg:MovieClip;
      
      private var obg:MovieClip;
      
      private var playerstr:String;
      
      private var otherstr:String;
      
      private var showparent:DisplayObjectContainer;
      
      private var delayTimer:Timer;
      
      public function LanguageItem()
      {
         super();
         this.init();
      }
      
      public static function get instance() : LanguageItem
      {
         if(_instance == null)
         {
            _instance = new LanguageItem();
         }
         return _instance;
      }
      
      private function init() : void
      {
         var obj:Object = ApplicationDomain.currentDomain.getDefinition("languageTip");
         this.bg = new obj();
         this.playertxt = new TextField();
         this.othertxt = new TextField();
         this.playertxt.y = 10;
         this.playertxt.x += 10;
         this.othertxt.y = 10;
         this.othertxt.x += 10;
         this.playertxt.selectable = false;
         this.othertxt.selectable = false;
         var oobj:Object = ApplicationDomain.currentDomain.getDefinition("olanguageTip");
         this.obg = new oobj();
         this.addChild(this.bg);
         this.addChild(this.obg);
         this.addChild(this.playertxt);
         this.addChild(this.othertxt);
      }
      
      public function say(info:Object, parent:DisplayObjectContainer, x:int, y:int, othersay:Boolean = false) : void
      {
         this.showparent = parent;
         this.playerstr = info.playersay + "";
         this.otherstr = info.othersay + "";
         LanguageItem.instance.x = x;
         LanguageItem.instance.y = y;
         if(this.playerstr == "" && this.otherstr == "")
         {
            return;
         }
         if(this.playerstr != "")
         {
            this.bg.visible = true;
            this.playertxt.visible = true;
            this.playertxt.htmlText = this.playerstr;
            this.playertxt.width = this.playertxt.textWidth;
            this.bg.width = this.playertxt.width + 20;
         }
         else
         {
            this.bg.visible = false;
            this.playertxt.visible = false;
         }
         if(this.otherstr != "")
         {
            this.obg.visible = true;
            this.othertxt.visible = true;
            this.othertxt.htmlText = this.otherstr;
            this.othertxt.width = this.othertxt.textWidth;
            this.obg.width = this.othertxt.width + 20;
         }
         else
         {
            this.obg.visible = false;
            this.othertxt.visible = false;
         }
         this.showparent.addChild(LanguageItem.instance);
         LanguageItem.instance.startDelayTime();
      }
      
      public function hide() : void
      {
         if(Boolean(this.showparent) && this.showparent.contains(LanguageItem.instance))
         {
            this.showparent.removeChild(LanguageItem.instance);
         }
         this.showparent = null;
      }
      
      private function startDelayTime() : void
      {
         if(this.delayTimer != null)
         {
            this.delayTimer.stop();
            this.delayTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onDelayTimer);
            this.delayTimer = null;
         }
         this.delayTimer = new Timer(1500,1);
         this.delayTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onDelayTimer);
         this.delayTimer.start();
      }
      
      private function onDelayTimer(event:TimerEvent) : void
      {
         this.hide();
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
   }
}

