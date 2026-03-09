package com.game.modules.view.battle
{
   import com.game.locators.GameData;
   import com.game.util.ColorUtil;
   import com.game.util.DateUtil;
   import com.game.util.LuaObjUtil;
   import com.publiccomponent.loading.XMLLocator;
   import com.xygame.module.battle.event.BattleEvent;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.utils.Timer;
   
   public class BtnPanel extends MovieClip
   {
      
      private static const SIGN_BATTLE:int = 1;
      
      private static const SIGN_TOOL:int = 2;
      
      private static const SIGN_SPIRIT:int = 3;
      
      private static const SIGN_ESCAPE:int = 4;
      
      private static const SIGN_CATCH:int = 5;
      
      private static const SIGN_NEXT:int = 6;
      
      private static const FRAME_DISABLED:int = 1;
      
      private static const FRAME_NORMAL:int = 2;
      
      private static const FRAME_HOVER:int = 3;
      
      private static const FRAME_PRESSED:int = 4;
      
      private static const FRAME_SELECTED:int = 5;
      
      private var btnPanel_MC:MovieClip;
      
      private var battle_BTN:MovieClip;
      
      private var tool_BTN:MovieClip;
      
      private var spirit_BTN:MovieClip;
      
      private var escape_BTN:MovieClip;
      
      private var catch_BTN:MovieClip;
      
      private var nextBtn:MovieClip;
      
      private var txtEscape:TextField;
      
      public var signId:int = 0;
      
      public var canBattle:Boolean = false;
      
      public var escape:int = 1;
      
      public var oprationValue:int;
      
      private var _battleType:int;
      
      private var _changeValue:int;
      
      private var _timer:Timer;
      
      private var _isDownTimer:Boolean;
      
      public function BtnPanel(btnPanel_FC:MovieClip)
      {
         super();
         this.btnPanel_MC = btnPanel_FC;
         this.initComponents();
         this.initButtons();
         this.initTimer();
      }
      
      private function initComponents() : void
      {
         this.txtEscape = this.btnPanel_MC.txtEscape;
         this.battle_BTN = this.btnPanel_MC.battleBtn;
         this.tool_BTN = this.btnPanel_MC.toolBtn;
         this.spirit_BTN = this.btnPanel_MC.spiritsBtn;
         this.escape_BTN = this.btnPanel_MC.escapeBtn;
         this.catch_BTN = this.btnPanel_MC.catchBtn;
         this.nextBtn = this.btnPanel_MC.nextBtn;
         this.spirit_BTN.mouseChildren = false;
         this.nextBtn.visible = false;
         this.nextBtn.gotoAndStop(FRAME_DISABLED);
      }
      
      private function initButtons() : void
      {
         var btn:MovieClip = null;
         var buttons:Array = [this.battle_BTN,this.tool_BTN,this.spirit_BTN,this.escape_BTN,this.catch_BTN,this.nextBtn];
         for each(btn in buttons)
         {
            btn.buttonMode = true;
            if(btn != this.nextBtn)
            {
               btn.gotoAndStop(FRAME_NORMAL);
            }
         }
         this.addButtonListeners(this.battle_BTN,this.battleClick);
         this.addButtonListeners(this.tool_BTN,this.toolClick);
         this.addButtonListeners(this.spirit_BTN,this.spiritClick);
         this.addButtonListeners(this.escape_BTN,this.escapeClick);
         this.addButtonListeners(this.catch_BTN,this.catchClick);
         this.addNextButtonListeners();
      }
      
      private function addButtonListeners(btn:MovieClip, clickHandler:Function) : void
      {
         btn.addEventListener(MouseEvent.CLICK,clickHandler);
         btn.addEventListener(MouseEvent.ROLL_OVER,this.mouseOverHandler);
         btn.addEventListener(MouseEvent.ROLL_OUT,this.mouseOutHandler);
         btn.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
         btn.addEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
      }
      
      private function addNextButtonListeners() : void
      {
         this.nextBtn.addEventListener(MouseEvent.CLICK,this.nextBtnClick);
         this.nextBtn.addEventListener(MouseEvent.ROLL_OVER,this.mouseOverNext);
         this.nextBtn.addEventListener(MouseEvent.ROLL_OUT,this.mouseOutNext);
      }
      
      private function initTimer() : void
      {
         var xml:XML = XMLLocator.getInstance().getErrofInfo(910);
         this._timer = new Timer(1000,xml.time);
         this._timer.addEventListener(TimerEvent.TIMER,this.onTimer);
         this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerComplete);
      }
      
      private function battleClick(event:MouseEvent) : void
      {
         this.handleButtonClick(event,SIGN_BATTLE);
      }
      
      private function toolClick(event:MouseEvent) : void
      {
         this.handleButtonClick(event,SIGN_TOOL);
      }
      
      private function spiritClick(event:MouseEvent) : void
      {
         if(!this.canBattle || !(this.oprationValue & 0x10))
         {
            return;
         }
         this.handleButtonClick(event,SIGN_SPIRIT);
      }
      
      private function escapeClick(event:MouseEvent) : void
      {
         if(!this.canBattle || this._timer.running)
         {
            return;
         }
         this.handleButtonClick(event,SIGN_ESCAPE);
      }
      
      private function catchClick(event:MouseEvent) : void
      {
         this.handleButtonClick(event,SIGN_CATCH);
      }
      
      private function nextBtnClick(event:MouseEvent) : void
      {
         this.signId = SIGN_NEXT;
         this.nextBtn.visible = false;
         this.battle_BTN.visible = true;
         dispatchEvent(new Event(BattleEvent.PANEL_CLICK_EVENT));
      }
      
      private function handleButtonClick(event:MouseEvent, sign:int) : void
      {
         if(!this.canBattle)
         {
            return;
         }
         var btn:MovieClip = event.currentTarget as MovieClip;
         if(btn.currentFrame != FRAME_PRESSED || this.signId == sign)
         {
            return;
         }
         this.signId = sign;
         dispatchEvent(new Event(BattleEvent.PANEL_CLICK_EVENT));
         this.resetOtherButtons(btn);
         btn.gotoAndStop(FRAME_SELECTED);
      }
      
      private function mouseOverHandler(event:MouseEvent) : void
      {
         if(!this.canBattle)
         {
            return;
         }
         var btn:MovieClip = event.currentTarget as MovieClip;
         if(btn.currentFrame == FRAME_NORMAL)
         {
            btn.gotoAndStop(FRAME_HOVER);
         }
      }
      
      private function mouseOutHandler(event:MouseEvent) : void
      {
         var btn:MovieClip = event.currentTarget as MovieClip;
         if(btn.currentFrame != FRAME_DISABLED && btn.currentFrame != FRAME_SELECTED)
         {
            btn.gotoAndStop(FRAME_NORMAL);
         }
      }
      
      private function mouseDownHandler(event:MouseEvent) : void
      {
         if(!this.canBattle)
         {
            return;
         }
         var btn:MovieClip = event.currentTarget as MovieClip;
         if(btn.currentFrame == FRAME_HOVER || btn.currentFrame == FRAME_NORMAL)
         {
            btn.gotoAndStop(FRAME_SELECTED);
         }
      }
      
      private function mouseUpHandler(event:MouseEvent) : void
      {
         var btn:MovieClip = event.currentTarget as MovieClip;
         if(btn.currentFrame == FRAME_SELECTED)
         {
            btn.gotoAndStop(FRAME_PRESSED);
         }
      }
      
      private function mouseOverNext(event:MouseEvent) : void
      {
         event.currentTarget.gotoAndStop(FRAME_NORMAL);
      }
      
      private function mouseOutNext(event:MouseEvent) : void
      {
         event.currentTarget.gotoAndStop(FRAME_DISABLED);
      }
      
      private function resetOtherButtons(currentBtn:MovieClip) : void
      {
         var btn:MovieClip = null;
         var buttons:Array = [this.battle_BTN,this.tool_BTN,this.spirit_BTN,this.escape_BTN,this.catch_BTN];
         for each(btn in buttons)
         {
            if(btn != currentBtn && btn.currentFrame == FRAME_SELECTED)
            {
               btn.gotoAndStop(FRAME_NORMAL);
            }
         }
      }
      
      public function changeBtnState(value:int) : void
      {
         var hexStr:String = value.toString(16).split("").reverse().join("");
         this.battle_BTN.gotoAndStop(parseInt(hexStr.charAt(0)) || 1);
         this.tool_BTN.gotoAndStop(parseInt(hexStr.charAt(1)) || 1);
         this.spirit_BTN.gotoAndStop(parseInt(hexStr.charAt(2)) || 1);
         this.escape_BTN.gotoAndStop(parseInt(hexStr.charAt(3)) || 1);
         this.catch_BTN.gotoAndStop(parseInt(hexStr.charAt(4)) || 1);
      }
      
      public function changState(value:int, next:Boolean = false) : void
      {
         var shouldShowNext:Boolean = false;
         this._changeValue = value;
         this.updateButtonState(this.battle_BTN,(value & 0x10000000) != 0);
         this.updateButtonState(this.tool_BTN,(value & 0x010000) != 0);
         this.updateButtonState(this.catch_BTN,(value & 0x1000) != 0);
         this.updateButtonState(this.spirit_BTN,(value & 0x10) != 0);
         this.onEscapeState();
         if(next && !GameData.instance.playerData.isAutoBattle)
         {
            shouldShowNext = (value & 0x10011110) == 0;
            this.nextBtn.visible = shouldShowNext;
            this.battle_BTN.visible = !shouldShowNext;
            this.nextBtn.filters = [];
            this.battle_BTN.filters = [];
         }
         else if(GameData.instance.playerData.isAutoBattle)
         {
            this.nextBtn.filters = ColorUtil.getColorMatrixFilterGray();
            this.battle_BTN.filters = ColorUtil.getColorMatrixFilterGray();
         }
      }
      
      private function updateButtonState(btn:MovieClip, enabled:Boolean) : void
      {
         btn.gotoAndStop(enabled ? FRAME_NORMAL : FRAME_DISABLED);
         btn.filters = enabled ? [] : ColorUtil.getColorMatrixFilterGray();
      }
      
      private function onEscapeState() : void
      {
         var enabled:Boolean = false;
         if(!this._timer.running)
         {
            enabled = Boolean(this._changeValue & 0x0100 && this.escape == 1);
            this.updateButtonState(this.escape_BTN,enabled);
         }
      }
      
      private function onTimer(event:TimerEvent) : void
      {
         this.txtEscape.text = DateUtil.getCountdowTime3(this._timer.repeatCount - this._timer.currentCount);
      }
      
      private function onTimerComplete(event:TimerEvent) : void
      {
         this.txtEscape.text = "";
         this.onEscapeState();
      }
      
      public function timeDown() : void
      {
         if(this._isDownTimer)
         {
            this._isDownTimer = false;
            this._timer.start();
            this.escape_BTN.filters = ColorUtil.getColorMatrixFilterGray();
            this.onTimer(null);
         }
      }
      
      public function set battleType(value:int) : void
      {
         this._battleType = value;
         var xml:XML = XMLLocator.getInstance().getErrofInfo(910);
         var ary:Array = LuaObjUtil.getLuaObjArr(String(xml.combatID));
         if(ary.indexOf(this._battleType) != -1 && this.escape == 1)
         {
            this._isDownTimer = true;
         }
      }
      
      public function destroy() : void
      {
         this.destroyTimer();
         this.removeAllListeners();
         this.cleanupComponents();
      }
      
      private function destroyTimer() : void
      {
         if(Boolean(this._timer))
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
            this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerComplete);
            this._timer = null;
         }
      }
      
      private function removeAllListeners() : void
      {
         this.removeButtonListeners(this.battle_BTN,this.battleClick);
         this.removeButtonListeners(this.tool_BTN,this.toolClick);
         this.removeButtonListeners(this.spirit_BTN,this.spiritClick);
         this.removeButtonListeners(this.escape_BTN,this.escapeClick);
         this.removeButtonListeners(this.catch_BTN,this.catchClick);
         this.removeNextButtonListeners();
      }
      
      private function removeButtonListeners(btn:MovieClip, clickHandler:Function) : void
      {
         if(!btn)
         {
            return;
         }
         btn.removeEventListener(MouseEvent.CLICK,clickHandler);
         btn.removeEventListener(MouseEvent.ROLL_OVER,this.mouseOverHandler);
         btn.removeEventListener(MouseEvent.ROLL_OUT,this.mouseOutHandler);
         btn.removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
         btn.removeEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
      }
      
      private function removeNextButtonListeners() : void
      {
         if(!this.nextBtn)
         {
            return;
         }
         this.nextBtn.removeEventListener(MouseEvent.CLICK,this.nextBtnClick);
         this.nextBtn.removeEventListener(MouseEvent.ROLL_OVER,this.mouseOverNext);
         this.nextBtn.removeEventListener(MouseEvent.ROLL_OUT,this.mouseOutNext);
      }
      
      private function cleanupComponents() : void
      {
         if(Boolean(this.btnPanel_MC))
         {
            while(this.btnPanel_MC.numChildren > 0)
            {
               this.btnPanel_MC.removeChildAt(0);
            }
         }
         this.battle_BTN = null;
         this.tool_BTN = null;
         this.spirit_BTN = null;
         this.escape_BTN = null;
         this.catch_BTN = null;
         this.nextBtn = null;
         this.txtEscape = null;
         this.btnPanel_MC = null;
      }
   }
}

