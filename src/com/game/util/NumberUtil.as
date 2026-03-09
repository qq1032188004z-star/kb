package com.game.util
{
   import com.game.Tools.RectButton;
   import com.game.newBase.BaseSprite;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.utils.Timer;
   
   public class NumberUtil extends BaseSprite
   {
      
      public var btnAdd:RectButton;
      
      public var btnSub:RectButton;
      
      public var txtNum:TextField;
      
      private var _value:int = 0;
      
      private var _min:int = 0;
      
      private var _max:int = 100;
      
      private var timer:Timer;
      
      private var step:int = 1;
      
      private var startDelay:int = 350;
      
      private var minDelay:int = 30;
      
      private var accel:Number = 0.86;
      
      private var currentDelay:int = 0;
      
      public function NumberUtil()
      {
         super();
      }
      
      public function init(skin:Sprite, min:int = 0, max:int = 100, defaultValue:int = 0) : void
      {
         this._min = min;
         this._max = max;
         this._value = defaultValue;
         super.initSkin(skin);
         this.updateUI();
      }
      
      override protected function initView() : void
      {
         super.initView();
         relateRectBtns("btnSub","btnAdd");
         relateTextFields("txtNum");
         this.txtNum.restrict = "0-9";
      }
      
      override protected function initEvent() : void
      {
         super.initEvent();
         this.timer = new Timer(this.startDelay);
         this.timer.addEventListener(TimerEvent.TIMER,this.onTimer);
         this.addButtonEvents(this.btnAdd,1);
         this.addButtonEvents(this.btnSub,-1);
         this.txtNum.addEventListener(Event.CHANGE,this.onTextChange);
         this.txtNum.addEventListener(FocusEvent.FOCUS_OUT,this.onTextFocusOut);
      }
      
      private function addButtonEvents(btn:Sprite, dir:int) : void
      {
         btn.addEventListener(MouseEvent.MOUSE_DOWN,function(e:MouseEvent):void
         {
            step = dir;
            changeValue(step);
            currentDelay = startDelay;
            timer.delay = currentDelay;
            timer.start();
            if(Boolean(stage))
            {
               stage.addEventListener(MouseEvent.MOUSE_UP,stopTimer);
            }
         });
         btn.addEventListener(MouseEvent.MOUSE_UP,this.stopTimer);
         btn.addEventListener(MouseEvent.MOUSE_OUT,this.stopTimer);
      }
      
      private function onTimer(e:TimerEvent) : void
      {
         this.changeValue(this.step);
         if(this.timer.running && this.currentDelay > this.minDelay)
         {
            this.currentDelay = Math.max(this.minDelay,int(this.currentDelay * this.accel));
            this.timer.delay = this.currentDelay;
         }
      }
      
      private function stopTimer(e:Event) : void
      {
         this.timer.stop();
         if(Boolean(stage))
         {
            stage.removeEventListener(MouseEvent.MOUSE_UP,this.stopTimer);
         }
      }
      
      private function changeValue(delta:int) : void
      {
         var old:int = this._value;
         this.value = this._value + delta;
         if(this._value == old && this.timer.running)
         {
            this.stopTimer(null);
         }
      }
      
      private function onTextChange(e:Event) : void
      {
         if(this.txtNum.text == "")
         {
            return;
         }
         var n:Number = parseInt(this.txtNum.text,10);
         if(isNaN(n))
         {
            return;
         }
         this.value = int(n);
      }
      
      private function onTextFocusOut(e:FocusEvent) : void
      {
         this.txtNum.text = this._value.toString();
      }
      
      private function updateUI() : void
      {
         this.txtNum.text = this._value.toString();
         this.btnAdd.setDisable(this._value >= this._max);
         this.btnSub.setDisable(this._value <= this._min);
         if(this.btnAdd.disable && this.step == 1 && this.timer.running)
         {
            this.stopTimer(null);
         }
         if(this.btnSub.disable && this.step == -1 && this.timer.running)
         {
            this.stopTimer(null);
         }
      }
      
      private function dispatchChange() : void
      {
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function set value(v:int) : void
      {
         v = Math.max(this._min,Math.min(this._max,v));
         if(this._value == v)
         {
            return;
         }
         this._value = v;
         this.updateUI();
         this.dispatchChange();
      }
      
      public function get value() : int
      {
         return this._value;
      }
      
      public function set min(v:int) : void
      {
         this._min = v;
         this.value = this._value;
         this.updateUI();
      }
      
      public function get min() : int
      {
         return this._min;
      }
      
      public function set max(v:int) : void
      {
         this._max = v;
         this.value = this._value;
         this.updateUI();
      }
      
      public function get max() : int
      {
         return this._max;
      }
      
      public function set holdStartDelay(ms:int) : void
      {
         this.startDelay = Math.max(1,ms);
      }
      
      public function set holdMinDelay(ms:int) : void
      {
         this.minDelay = Math.max(1,ms);
      }
      
      public function set holdAccel(a:Number) : void
      {
         this.accel = Math.max(0.1,Math.min(0.99,a));
      }
   }
}

