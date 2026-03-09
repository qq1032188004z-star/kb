package com.xygame.module.battle.event
{
   import com.core.observer.MessageEvent;
   import com.game.locators.EventDefine;
   import com.game.locators.GameData;
   import flash.events.Event;
   
   public class BattleEvent extends Event
   {
      
      public static const battlePlayOver:String = "battleplayover";
      
      public static const battleOpration:String = "battleoprationop";
      
      public static const requestBigBattle:String = "requestBigBattle";
      
      public static const spiritsEnterOver:String = "spiritsEnterOver";
      
      public static const LEAVE_BATTLE_CLICK:String = "leavebattleclick";
      
      public static const littleGameOver:String = "littlegameover";
      
      public static const showBattle:String = "showBattle";
      
      public static const pkotheropration:String = "pkotheropration";
      
      public static const canOpration:String = "canopration";
      
      public static const removeBattle:String = "removeBattle";
      
      public static const cancelAutoBattle:String = "cancelautobattle";
      
      public static const npcClick:String = "npcClick";
      
      public static const showBeforeBattle:String = "showBeforebattle";
      
      public static const requestBattlTool:String = "requestsBattletool";
      
      public static const startBattle:String = "startBattle";
      
      public static const requestBobBattle:String = "requestBobBattle";
      
      public static const catchover:String = "CATCH_OVER";
      
      public static const PANEL_CLICK_EVENT:String = "PANEL_CLICK_EVENT";
      
      public static const BATTLE_CONTROL_CLICK_EVENT:String = "BATTLE_CONTROL_CLICK_EVENT";
      
      public static const SPIRIT_CONTROL_CLICK_EVENT:String = "SPIRIT_CONTROL_CLICK_EVENT";
      
      public static const BATTLE_USE_TOOL:String = "BATTLE_USE_TOOL";
      
      public static const STATE_CHANGED:String = "stateChanged";
      
      public static const ALL_LOADED:String = "allLoaded";
      
      public static const ROUND_START:String = "roundStart";
      
      public static const ROUND_END:String = "roundEnd";
      
      public static const BATTLE_FINISHED:String = "battleFinished";
      
      public static const BATTLE_ESCAPED:String = "battleEscaped";
      
      public static const BG_LOADED:String = "bgLoaded";
      
      public static const ROLES_LOADED:String = "rolesLoaded";
      
      public static const EFFECTS_LOADED:String = "effectsLoaded";
      
      public static const LOAD_PROGRESS:String = "loadProgress";
      
      public static const ROLE_SWITCHED:String = "roleSwitched";
      
      public static const ROLE_ENTERED:String = "roleEntered";
      
      public static const ROLE_EXITED:String = "roleExited";
      
      public static const ROLE_HP_CHANGED:String = "roleHPChanged";
      
      public static const ROLE_DIED:String = "roleDied";
      
      public static const OPERATION_COMPLETE:String = "operationComplete";
      
      public static const ALL_OPERATIONS_COMPLETE:String = "allOperationsComplete";
      
      public static const SKILL_CAST:String = "skillCast";
      
      public static const SKILL_HIT:String = "skillHit";
      
      public static const SKILL_MISS:String = "skillMiss";
      
      public static const EFFECT_COMPLETE:String = "effectComplete";
      
      public static const CATCH_EFFECT_COMPLETE:String = "catchEffectComplete";
      
      public static const BLOOD_EFFECT_COMPLETE:String = "bloodEffectComplete";
      
      public static const ENTER_EFFECT_COMPLETE:String = "enterEffectComplete";
      
      public static const TOOL_USED:String = "toolUsed";
      
      public static const TOOL_USE_SUCCESS:String = "toolUseSuccess";
      
      public static const TOOL_USE_FAILED:String = "toolUseFailed";
      
      public static const COUNT_DOWN_TICK:String = "countDownTick";
      
      public static const COUNT_DOWN_COMPLETE:String = "countDownComplete";
      
      public static const BUFF_ADDED:String = "buffAdded";
      
      public static const BUFF_REMOVED:String = "buffRemoved";
      
      public static const BUFF_TRIGGERED:String = "buffTriggered";
      
      public static const BUFF_ACTIVATED:String = "buffActivated";
      
      public static const SITE_OPENED:String = "siteOpened";
      
      public static const SITE_CLOSED:String = "siteClosed";
      
      public static const SITE_UPDATED:String = "siteUpdated";
      
      public static const UI_UPDATE:String = "uiUpdate";
      
      public static const CONTROL_BAR_SHOW:String = "controlBarShow";
      
      public static const CONTROL_BAR_HIDE:String = "controlBarHide";
      
      public static const NEW_PVP:Array = [17,18,19];
      
      private static var _newLookRound:int = 0;
      
      private static var _isStopLook:Boolean = false;
      
      public static var isFristRound:Boolean = true;
      
      private var _battleInfo:Object;
      
      private var _data:Object;
      
      public function BattleEvent(type:String, batInfo:Object = null, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         if(batInfo != null)
         {
            this._battleInfo = batInfo;
         }
         if(data != null)
         {
            this._data = data;
         }
      }
      
      public static function get newLookRound() : int
      {
         return _newLookRound;
      }
      
      public static function set newLookRound(value:int) : void
      {
         if(value != _newLookRound)
         {
            BattleEvent.isStopLook = false;
            trace("[BattleEvent] 新回合开始:",value);
            GameData.instance.dispatchEvent(new MessageEvent(EventDefine.LOOK_BATTLE));
         }
         _newLookRound = value;
      }
      
      public static function get isStopLook() : Boolean
      {
         return _isStopLook;
      }
      
      public static function set isStopLook(value:Boolean) : void
      {
         _isStopLook = value;
         if(_isStopLook)
         {
            trace("[BattleEvent] ======================================== 停止观战");
         }
         else
         {
            trace("[BattleEvent] ---------------------------------------- 继续观战");
         }
      }
      
      public static function initNewLook() : void
      {
         _newLookRound = 0;
         _isStopLook = false;
         isFristRound = true;
         trace("[BattleEvent] 初始化新观战");
      }
      
      public static function reset() : void
      {
         _newLookRound = 0;
         _isStopLook = false;
         isFristRound = true;
      }
      
      public function get battleInfo() : Object
      {
         return this._battleInfo;
      }
      
      public function set battleInfo(value:Object) : void
      {
         this._battleInfo = value;
      }
      
      public function get data() : Object
      {
         return this._data;
      }
      
      public function set data(value:Object) : void
      {
         this._data = value;
      }
      
      override public function clone() : Event
      {
         return new BattleEvent(type,this._battleInfo,this._data,bubbles,cancelable);
      }
      
      override public function toString() : String
      {
         return formatToString("BattleEvent","type","battleInfo","data","bubbles","cancelable");
      }
   }
}

