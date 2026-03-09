package com.game.Tools
{
   import com.game.util.DisplayObjectMyUtil;
   import flash.display.InteractiveObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.utils.Timer;
   
   public class NumChangePanel extends Sprite
   {
      
      public const EVENT_NAME:String = "numChangeEvent";
      
      private var tfInput:TextField = null;
      
      private var btnNumMinus:InteractiveObject = null;
      
      private var btnNumPlus:InteractiveObject = null;
      
      private var timer:Timer = null;
      
      private var startTimer:Timer = null;
      
      private var type:int = 0;
      
      private var _max:int = 0;
      
      private var _min:int = 0;
      
      private var changeFunc:Function = null;
      
      private var _defaultValue:int;
      
      public function NumChangePanel(addInteractiveObj:InteractiveObject, minusInteractiveObj:InteractiveObject, inputPanel:TextField, max:int = 1, min:int = 0, changeFunc:Function = null, defaultValue:int = 1)
      {
         super();
         this.tfInput = inputPanel;
         this._defaultValue = defaultValue;
         this.tfInput.text = "" + this._defaultValue;
         this.tfInput.type = TextFieldType.INPUT;
         this.btnNumMinus = minusInteractiveObj;
         this.btnNumPlus = addInteractiveObj;
         this._max = max;
         this._min = min;
         this.changeFunc = changeFunc;
         this.addListener();
      }
      
      private function addListener() : void
      {
         this.btnNumMinus.addEventListener(MouseEvent.MOUSE_DOWN,this.onDownHandler,false,0,true);
         this.btnNumPlus.addEventListener(MouseEvent.MOUSE_DOWN,this.onDownHandler,false,0,true);
         this.tfInput.addEventListener(Event.CHANGE,this.onChangeHandler);
      }
      
      private function removeListener() : void
      {
         this.btnNumMinus.removeEventListener(MouseEvent.MOUSE_DOWN,this.onDownHandler);
         this.btnNumPlus.removeEventListener(MouseEvent.MOUSE_DOWN,this.onDownHandler);
         this.tfInput.removeEventListener(Event.CHANGE,this.onChangeHandler);
      }
      
      private function onDownHandler(e:MouseEvent) : void
      {
         var num:int;
         e.stopImmediatePropagation();
         num = int(this.tfInput.text);
         if(e.currentTarget == this.btnNumMinus)
         {
            if(num == this.min)
            {
               return;
            }
            this.type = 2;
         }
         else
         {
            if(num == this.max)
            {
               return;
            }
            this.type = 1;
         }
         this.addDownNum(this.type);
         if(Boolean(stage))
         {
            stage.addEventListener(MouseEvent.MOUSE_UP,this.onUpHandler,false,0,true);
            if(this.startTimer == null)
            {
               this.startTimer = new Timer(200,1);
               this.startTimer.addEventListener(TimerEvent.TIMER_COMPLETE,function(e:TimerEvent):void
               {
                  startLongPress(e.target as InteractiveObject);
               },false,0,true);
               this.startTimer.start();
            }
         }
      }
      
      private function startLongPress(btn:InteractiveObject) : void
      {
         if(this.timer == null)
         {
            this.timer = new Timer(200);
            this.timer.addEventListener(TimerEvent.TIMER,this.onTimerHandler,false,0,true);
            this.timer.start();
         }
      }
      
      private function onTimerHandler(e:TimerEvent) : void
      {
         this.addDownNum(this.type);
      }
      
      private function addDownNum(type:int) : void
      {
         var num:int = 0;
         if(this.tfInput.text == "")
         {
            this.tfInput.text = "" + this._defaultValue;
         }
         else
         {
            num = int(this.tfInput.text);
            if(type == 1)
            {
               if(num < this.max)
               {
                  num++;
               }
            }
            else if(num > this.min)
            {
               num--;
            }
            this.tfInput.text = num.toString();
         }
         this.triZero();
         this.changeState();
         this.tfInput.setSelection(this.tfInput.text.length,this.tfInput.text.length);
         if(this.changeFunc != null)
         {
            this.changeFunc.apply();
         }
      }
      
      private function onUpHandler(e:MouseEvent) : void
      {
         this.type = 0;
         if(Boolean(stage))
         {
            stage.removeEventListener(MouseEvent.MOUSE_UP,this.onUpHandler);
         }
         if(Boolean(this.timer))
         {
            this.timer.removeEventListener(TimerEvent.TIMER,this.onTimerHandler);
            this.timer.stop();
            this.timer = null;
         }
         if(Boolean(this.startTimer))
         {
            this.startTimer.removeEventListener(TimerEvent.TIMER,this.onTimerHandler);
            this.startTimer.stop();
            this.startTimer = null;
         }
      }
      
      private function onChangeHandler(e:Event) : void
      {
         this.triZero();
         var num:int = int(this.tfInput.text);
         num = num < this.min ? this.min : num;
         num = num > this.max ? this.max : num;
         this.tfInput.text = num + "";
         this.changeState();
         if(this.changeFunc != null)
         {
            this.changeFunc.apply();
         }
      }
      
      private function triZero() : void
      {
         var str:String = null;
         var i:int = 0;
         var char:String = null;
         var len:int = this.tfInput.text.length;
         if(len > 1)
         {
            str = this.tfInput.text;
            for(i = 0; i < len; i++)
            {
               char = str.charAt(i);
               if(int(char) != 0)
               {
                  break;
               }
               str = str.substr(i + 1,len);
               i--;
               len--;
            }
            this.tfInput.text = str == "" ? "0" : str;
         }
      }
      
      private function enableState() : void
      {
         var num:int = 0;
         if(this._max == this._min)
         {
            DisplayObjectMyUtil.setGray(this.btnNumMinus,false);
            DisplayObjectMyUtil.setGray(this.btnNumPlus,false);
            this.tfInput.mouseEnabled = false;
         }
         else
         {
            num = int(this.tfInput.text);
            if(num == this.max)
            {
               DisplayObjectMyUtil.setGray(this.btnNumPlus,false);
            }
            else
            {
               DisplayObjectMyUtil.setGray(this.btnNumPlus,true);
            }
            if(num == this.min)
            {
               DisplayObjectMyUtil.setGray(this.btnNumMinus,false);
            }
            else
            {
               DisplayObjectMyUtil.setGray(this.btnNumMinus,true);
            }
            this.tfInput.mouseEnabled = true;
         }
      }
      
      private function changeState() : void
      {
         var num:int = int(this.tfInput.text);
         if(num == this.max)
         {
            DisplayObjectMyUtil.setGray(this.btnNumPlus,false);
         }
         else
         {
            DisplayObjectMyUtil.setGray(this.btnNumPlus,true);
         }
         if(num == this.min)
         {
            DisplayObjectMyUtil.setGray(this.btnNumMinus,false);
         }
         else
         {
            DisplayObjectMyUtil.setGray(this.btnNumMinus,true);
         }
      }
      
      public function set max(value:int) : void
      {
         this._max = value;
         this.enableState();
      }
      
      public function get max() : int
      {
         return this._max;
      }
      
      public function set min(value:int) : void
      {
         this._min = value < 0 ? 0 : value;
         this.enableState();
      }
      
      public function get min() : int
      {
         return this._min;
      }
      
      public function get text() : String
      {
         return this.tfInput.text;
      }
      
      public function set text(value:String) : void
      {
         this.tfInput.text = value;
         this.changeState();
      }
      
      public function set startTime(value:int) : void
      {
         if(this.timer != null)
         {
            this.timer.delay = value;
         }
      }
   }
}

