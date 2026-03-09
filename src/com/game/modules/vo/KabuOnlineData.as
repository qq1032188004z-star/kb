package com.game.modules.vo
{
   import com.core.observer.MessageEvent;
   import com.game.locators.CacheData;
   import com.game.locators.MsgDoc;
   import com.game.modules.view.FaceView;
   import com.publiccomponent.tips.TipInfoLib;
   import com.publiccomponent.ui.ButtonEffect;
   import com.publiccomponent.util.ButtonEffectUtil;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.external.ExternalInterface;
   import org.green.server.core.GreenSocket;
   import org.green.server.manager.SocketManager;
   
   public class KabuOnlineData extends EventDispatcher
   {
      
      public static const KABUONLINE_INIT:String = "kabuOnline_init";
      
      public static const KABUONLINE_UPDATE_LEVEL:String = "kabuonline_update_level";
      
      public static const KABUONLINE_INIT_POWER:String = "kabuOnline_init_power";
      
      public static const KABUONLINE_GET_AWARD_BACK:String = "kabuOnline_get_award_back";
      
      public static const KABUONLINE_UPDATE_LOGIN:String = "kabuonline_update_login";
      
      public static const KABUONLINE_INIT_LOGIN:String = "kabuonline_init_login";
      
      private var _onlineTime:int;
      
      private var _onlineAwardState:Array;
      
      private var socket:GreenSocket;
      
      private var _doAction:Function;
      
      private var levelData:Object;
      
      private var times:Array = [600,1500,2400,3600,5400,7200];
      
      public var powerAwards:Array = [];
      
      private const PET_ID:int = 1;
      
      private var currentState:int = -1;
      
      private var currentTime:int;
      
      public function KabuOnlineData(target:IEventDispatcher = null)
      {
         super(target);
         this.socket = SocketManager.getGreenSocket();
      }
      
      public function setLevelData($value:Object) : void
      {
         this.levelData = $value;
         dispatchEvent(new MessageEvent(KABUONLINE_UPDATE_LEVEL));
      }
      
      public function getLevelData() : Object
      {
         return this.levelData;
      }
      
      public function updateLevel($awardIndex:int, $state:int = 0) : void
      {
         if(Boolean(this.levelData))
         {
            this.levelData.list[$awardIndex - 1] = $state;
            dispatchEvent(new MessageEvent(KABUONLINE_UPDATE_LEVEL));
         }
      }
      
      public function requestLevelInfo($params:int, $data:Array = null) : void
      {
         this.socket.sendCmd(MsgDoc.OP_CLIENT_MSG_LEVEL_INOF.send,$params,$data);
      }
      
      public function requestLoginInfo() : void
      {
         this.socket.sendCmd(MsgDoc.OP_CLIENT_ACTIVITY_QINGYANG_NEW.send,610,["open_ui"]);
      }
      
      public function requestGetLoginBonus(index:int) : void
      {
         this.socket.sendCmd(MsgDoc.OP_CLIENT_ACTIVITY_QINGYANG_NEW.send,610,["reward",index]);
      }
      
      public function requestInfo() : void
      {
         this.requestOnlinePower();
      }
      
      public function requestAwardOnline($index:int) : void
      {
         this.socket.sendCmd(MsgDoc.OP_CLIENT_ACTIVITY_QINGYANG_NEW.send,753,["online_reward",$index]);
         this.socket.sendCmd(MsgDoc.OP_CLIENT_MSG_KABUONLINE_AWARD.send,$index);
      }
      
      public function requestPowerAward($index:int) : void
      {
         this.socket.sendCmd(MsgDoc.OP_CLIENT_ACTIVITY_QINGYANG_NEW.send,753,["energy_reward",$index]);
      }
      
      public function getAwardBack($index:int) : void
      {
         dispatchEvent(new MessageEvent(KABUONLINE_GET_AWARD_BACK,$index));
         this.requestOnlinePower();
      }
      
      public function buyPet() : void
      {
         this.socket.sendCmd(MsgDoc.OP_CLIENT_ACTIVITY_QINGYANG_NEW.send,753,["buy_monster"]);
      }
      
      public function requestOnlinePower() : void
      {
         this.socket.sendCmd(MsgDoc.OP_CLIENT_ACTIVITY_QINGYANG_NEW.send,753,["open_ui"]);
      }
      
      public function get onlineTime() : int
      {
         return this._onlineTime;
      }
      
      public function get onlineAwardState() : Array
      {
         return this._onlineAwardState;
      }
      
      public function set doAction($doAction:Function) : void
      {
         this._doAction = $doAction;
      }
      
      public function doTimer() : void
      {
         if(this._onlineTime > 7200)
         {
            this._onlineTime = 7200;
            CacheData.instance.onlineTimer.delOnline(this.doTimer);
         }
         else
         {
            ++this._onlineTime;
         }
         this.responseDoAction();
         this.changeMessageView();
      }
      
      private function changeMessageView() : void
      {
         var i:int = 0;
         var time:int = 0;
         var tipObj:Object = null;
         var state:int = 0;
         var showTime:int = 0;
         var showTimeInEffect:int = 0;
         var index:int = -1;
         if(this.onlineTime >= 7200)
         {
            state = this.getState(this.onlineAwardState.length);
            if(state == 0)
            {
               ButtonEffectUtil.delEffect(FaceView.clip.getTopButton("awardClip"));
            }
         }
         else
         {
            for(i = 0; i < this.times.length; i++)
            {
               time = int(this.times[i]);
               if(this.onlineTime < time)
               {
                  index = i;
                  showTimeInEffect = time - this.onlineTime;
                  break;
               }
            }
            state = this.getState(index);
            if(state == 0)
            {
               state = 2;
               showTime = Math.ceil(showTime / 60);
            }
         }
         if(this.currentState != state || this.currentTime != showTime)
         {
            this.currentState = state;
            this.currentTime = showTime;
            tipObj = TipInfoLib.instance.getTipByName("awardClip");
            tipObj.place = 3;
            ButtonEffectUtil.delEffect(FaceView.clip.getTopButton("awardClip"));
            switch(this.currentState)
            {
               case 1:
                  tipObj.tips = "你有礼包可以领取哦！";
                  ButtonEffectUtil.registerEffect(FaceView.clip.getTopButton("awardClip"),ButtonEffect.EFFECT_AWARD1,false);
                  break;
               case 2:
                  tipObj.tips = "还有" + this.currentTime + "分钟就可以领取礼盒了哦！";
                  ButtonEffectUtil.registerEffect(FaceView.clip.getTopButton("awardClip"),ButtonEffect.EFFECT_TIMER,false,0,0,showTimeInEffect);
                  break;
               default:
                  tipObj.tips = "今日奖励已全部领取，请明天再来吧！";
                  ButtonEffectUtil.delEffect(FaceView.clip.getTopButton("awardClip"));
            }
            FaceView.clip.updataTips("awardClip",tipObj.tips);
         }
      }
      
      private function getState($length:int) : int
      {
         var state:int = 0;
         for(var j:int = 0; j < $length; j++)
         {
            if(int(this.onlineAwardState[j]) == 0 && this._onlineTime >= this.times[j])
            {
               state = 1;
               break;
            }
         }
         return state;
      }
      
      public function initializeOnline($onlineTime:int, $states:Array) : void
      {
         this._onlineTime = $onlineTime;
         this._onlineAwardState = $states;
         this.responseDoAction();
         CacheData.instance.onlineTimer.addOnline(this.doTimer);
         dispatchEvent(new MessageEvent(KABUONLINE_INIT));
         var length:int = 0;
         for(var i:int = 0; i < $states.length; i++)
         {
            if($states[i] == 0)
            {
               length++;
            }
         }
         if(ExternalInterface.available)
         {
            ExternalInterface.call("taskStateFunction",-1,length,-1,-1,-1);
         }
      }
      
      public function initializeOnlinePower($params:Object) : void
      {
         this.powerAwards = [$params.award1,$params.award2,$params.award3,$params.award4];
         dispatchEvent(new MessageEvent(KABUONLINE_INIT_POWER,$params));
      }
      
      private function responseDoAction() : void
      {
         if(this._doAction != null)
         {
            this._doAction.apply(null,null);
         }
      }
      
      public function initkabuOnlineLoginData(params:Object) : void
      {
         dispatchEvent(new MessageEvent(KABUONLINE_INIT_LOGIN,params));
      }
      
      public function updatekabuOnlineLoginData(params:Object) : void
      {
         dispatchEvent(new MessageEvent(KABUONLINE_UPDATE_LOGIN,params));
      }
   }
}

