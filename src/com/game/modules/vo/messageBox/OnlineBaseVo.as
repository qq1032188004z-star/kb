package com.game.modules.vo.messageBox
{
   import com.game.locators.CacheData;
   import com.game.locators.GameData;
   import com.game.util.TimeTransform;
   
   public class OnlineBaseVo
   {
      
      public static const CD_STATE:int = 0;
      
      public static const SUPER_STATE:int = 2;
      
      public static const TIME_STATE:int = 1;
      
      public static const NEW_STATE:int = 3;
      
      public static const SERVER_CONTROL:int = 4;
      
      public static const UNSTART_ACT:int = 0;
      
      public static const START_ACT:int = 1;
      
      public static const OVER_ACT:int = 2;
      
      public static const ONLINE_STATE:int = -1;
      
      public static const OVER_STATE:int = 0;
      
      private var _callbacks:Array = [];
      
      private var _onlineIntroVo:OnlineIntoVo;
      
      private var _isActive:Boolean = true;
      
      private var _timePlus:int = 0;
      
      private var _playTime:int = -1;
      
      private var _isStart:int = 0;
      
      private var _isClose:Boolean = false;
      
      public function OnlineBaseVo()
      {
         super();
      }
      
      public function get isStart() : int
      {
         return this._isStart;
      }
      
      public function set timePlus($value:int) : void
      {
         this._timePlus = $value;
         this.initTimer();
      }
      
      public function get timePlus() : int
      {
         return this._timePlus;
      }
      
      public function set isClose($value:Boolean) : void
      {
         this._isClose = $value;
      }
      
      public function get isClose() : Boolean
      {
         return this._isClose;
      }
      
      public function set playTime($value:int) : void
      {
         this._playTime = $value;
      }
      
      public function doShow() : void
      {
         CacheData.instance.onlinelist.update();
      }
      
      public function get playTime() : int
      {
         return this._playTime;
      }
      
      public function get onlineIntroVo() : OnlineIntoVo
      {
         return this._onlineIntroVo;
      }
      
      public function set onlineIntroVo($value:OnlineIntoVo) : void
      {
         this._onlineIntroVo = $value;
         this.initTimer();
      }
      
      public function get isActive() : Boolean
      {
         return this._isActive && this._playTime != 0;
      }
      
      public function set isActive($value:Boolean) : void
      {
         this._isActive = $value;
      }
      
      public function get id() : int
      {
         return this.onlineIntroVo.actid;
      }
      
      public function addCallBack($function:Function, $priority:int = 0) : void
      {
         if($function != null && this._callbacks.indexOf($function) == -1)
         {
            if($priority == 0)
            {
               this._callbacks.push($function);
            }
            else
            {
               this._callbacks.splice(0,0,$function);
            }
            this.doTimer();
         }
      }
      
      public function delCallBack($function:Function) : void
      {
         var callback:Array = null;
         var index:int = this._callbacks.indexOf($function);
         if(index != -1)
         {
            callback = this._callbacks.splice(index,1);
            callback[0] = null;
            callback = null;
            this.doTimer();
         }
      }
      
      public function toString() : String
      {
         return TimeTransform.getInstance().transToTime(this._timePlus,1);
      }
      
      public function disport() : void
      {
         var callback:Function = null;
         CacheData.instance.onlineTimer.delOnline(this.doAction);
         if(Boolean(this._callbacks))
         {
            while(this._callbacks.length > 0)
            {
               callback = this._callbacks.shift() as Function;
               callback = null;
            }
            this._callbacks = null;
         }
      }
      
      private function initTimer() : void
      {
         switch(this.onlineIntroVo.type)
         {
            case CD_STATE:
               this.timeTypeOne();
               break;
            case TIME_STATE:
               this.timeTypeTwo();
               break;
            case SUPER_STATE:
               this.timeTypeOne();
               break;
            case SERVER_CONTROL:
               this.timeTypeOne();
         }
      }
      
      private function timeTypeOne() : void
      {
         if(this._timePlus > 0)
         {
            this.changeTimePlus();
         }
         this.doShow();
      }
      
      private function timeTypeTwo() : void
      {
         var systemTimes:int = 0;
         var timeList:Array = null;
         var i:int = 0;
         if(this.onlineIntroVo.timeList.length > 0)
         {
            systemTimes = GameData.instance.playerData.getMinutes();
            timeList = this.onlineIntroVo.timeList;
            for(i = 0; i < timeList.length; i++)
            {
               if(systemTimes < timeList[i])
               {
                  this._timePlus = timeList[i] - systemTimes;
                  if(int(i % 2) == 0)
                  {
                     this._isStart = UNSTART_ACT;
                  }
                  else
                  {
                     this._isStart = START_ACT;
                  }
                  this.playTime = ONLINE_STATE;
                  this.changeTimePlus();
                  CacheData.instance.onlinelist.setPlayState(this._onlineIntroVo.actid,true);
                  CacheData.instance.onlinelist.update();
                  break;
               }
               this._isStart = OVER_ACT;
               this.playTime = OVER_STATE;
               CacheData.instance.onlinelist.setPlayState(this._onlineIntroVo.actid,false);
               CacheData.instance.onlinelist.update();
            }
         }
         else
         {
            this._isStart = OVER_ACT;
            this.playTime = OVER_STATE;
         }
         this.doShow();
      }
      
      private function changeTimePlus() : void
      {
         if(this._timePlus > 0)
         {
            --this._timePlus;
            this._isActive = true;
            this.addCallBack(this.changeTimePlus,1);
         }
         else
         {
            this._timePlus = 0;
            this.delCallBack(this.changeTimePlus);
            this.initTimer();
         }
      }
      
      private function doTimer() : void
      {
         if(this._callbacks.length > 0)
         {
            CacheData.instance.onlineTimer.addOnline(this.doAction);
         }
         else
         {
            CacheData.instance.onlineTimer.delOnline(this.doAction);
         }
      }
      
      private function doAction() : void
      {
         var callback:Function = null;
         for each(callback in this._callbacks)
         {
            callback.apply();
         }
      }
   }
}

