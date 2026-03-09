package com.game.modules.vo
{
   import com.game.locators.EventDefine;
   import com.game.locators.GameData;
   import com.game.util.ChatUtil;
   import com.game.util.HtmlUtil;
   import flash.events.Event;
   
   public class ShowData
   {
      
      public var spriteType:int = 0;
      
      public var moveFlag:int;
      
      public var houseName:String;
      
      public var houseId:int;
      
      public var isAccept:int;
      
      public var userBeiZhu:String = "";
      
      public var teamId:int;
      
      public var playerState:int;
      
      private var _playerStatus:int;
      
      public var source:int;
      
      public var body:Object;
      
      public var isNearyBy:int;
      
      public var lastSceneId:int;
      
      private var _sceneId:int;
      
      public var nextSceneId:int;
      
      public var timeleft:int;
      
      public var isOnline:int;
      
      public var isBlack:int;
      
      public var vip:int;
      
      public var oldx:int;
      
      public var oldy:int;
      
      public var newx:int;
      
      public var newy:int;
      
      public var actFoodDiskStatus:int;
      
      public var taskArchivesVersionInfo:ActivityVo;
      
      public var x:int;
      
      public var y:int;
      
      private var _userId:int;
      
      public var uid:String;
      
      private var _userName:String;
      
      private var _coin:int;
      
      private var _x_coin:int;
      
      private var _vipCoin:int;
      
      public var titleIndex:int = 0;
      
      private var _sex:int;
      
      public var isFriend:int;
      
      public var historyValue:int;
      
      public var kabuLevle:int;
      
      public var signTime:int;
      
      public var monsterNum:int;
      
      public var monsterMaxLevel:int;
      
      public var bossrecord:String;
      
      public var challengrecordVictory:int;
      
      public var challengrecordFail:int;
      
      public var babelrecordVictory:int;
      
      public var babelrecordFail:int;
      
      public var littlegameScore:int;
      
      public var littlegameRcore:int;
      
      public var haveOpenVip:int;
      
      public var isVip:Boolean = false;
      
      public var vipLevel:int = 0;
      
      public var vipScore:int = 0;
      
      public var expiredTime:int;
      
      public var timeNow:int;
      
      public var firstopen:int;
      
      public var lastopenTime:int;
      
      public var weekReward:int;
      
      public var dayReward:int;
      
      public var bobOwner:int = 0;
      
      public var refineState:Boolean;
      
      public var roleType:int;
      
      private var _isShowFamily:Boolean = false;
      
      public var familyId:int = 0;
      
      public var familyName:String;
      
      public var familyAllName:String;
      
      public var bodyID:int;
      
      public var isInChange:int;
      
      public var hatId:int;
      
      public var clothId:int;
      
      public var weaponId:int;
      
      public var footId:int;
      
      public var wingId:int;
      
      public var glassId:int;
      
      public var leftWeapon:int;
      
      public var taozhuangId:int;
      
      public var backgroundId:int;
      
      public var collectState:int;
      
      public var horseID:int;
      
      public var horseIndex:int;
      
      public var horseSpeed:int = 100;
      
      public var petId:int;
      
      public var ringid:int;
      
      public var necklaceid:int;
      
      public var faceId:int;
      
      public var mstate:int;
      
      public var msid:int;
      
      public var mid:int;
      
      public var mstateCount:int;
      
      public var mname:String;
      
      public var hasLinHorse:Boolean;
      
      public var nameBorderId:int;
      
      public var trump:int;
      
      public var state:int = 1;
      
      public var isInHouse:Boolean;
      
      public var isInFamily:Boolean;
      
      public var isInCangBaoGe:Boolean;
      
      public var trumpstate:int;
      
      public var trumpmaster:int;
      
      public var trumpAppearance:int;
      
      public var isSupertrump:Boolean;
      
      public var color:int;
      
      public var chorse:int;
      
      public var canCangCoin:Boolean = true;
      
      public function ShowData()
      {
         super();
      }
      
      public function get playerStatus() : int
      {
         return this._playerStatus;
      }
      
      public function set playerStatus(value:int) : void
      {
         this._playerStatus = value;
      }
      
      public function get userId() : int
      {
         return this._userId;
      }
      
      public function set userId(value:int) : void
      {
         this._userId = value;
      }
      
      public function get userName() : String
      {
         return this._userName;
      }
      
      public function set userName(value:String) : void
      {
         this._userName = ChatUtil.onCheckStr(value);
      }
      
      public function get sex() : int
      {
         if(Boolean(this.roleType))
         {
            return this.roleType & 1;
         }
         return this._sex;
      }
      
      public function set sex(v:int) : void
      {
         this._sex = v;
      }
      
      public function get userNamehtml() : String
      {
         return HtmlUtil.getRealHtmlStr(this._userName);
      }
      
      public function setShowFamily($value:int) : void
      {
         if($value == 0)
         {
            this._isShowFamily = false;
         }
         else
         {
            this._isShowFamily = true;
         }
      }
      
      public function get isShowFamily() : Boolean
      {
         return this._isShowFamily;
      }
      
      public function getLeftTime() : String
      {
         var hours:int = 0;
         var minutes:int = 0;
         if(this.timeleft <= 0)
         {
            return "";
         }
         hours = this.timeleft / 3600000;
         minutes = this.timeleft % 3600000;
         minutes /= 60000;
         return "没有htmlUtil";
      }
      
      public function set coin(value:int) : void
      {
         if(value < 0)
         {
            value = 0;
         }
         if(this.canCangCoin)
         {
            this.canCangCoin = false;
            this._coin = value;
            GameData.instance.dispatchEvent(new Event("coinupdate"));
         }
      }
      
      public function get coin() : int
      {
         return this._coin;
      }
      
      public function set x_coin(value:int) : void
      {
         this._x_coin = value;
         GameData.instance.dispatchEvent(new Event(EventDefine.X_COIN_UPDATE));
      }
      
      public function get vipCoin() : int
      {
         return this._vipCoin;
      }
      
      public function set vipCoin(value:int) : void
      {
         this._vipCoin = value;
         GameData.instance.dispatchEvent(new Event(EventDefine.VIP_COIN_UPDATE));
      }
      
      public function get x_coin() : int
      {
         return this._x_coin;
      }
      
      public function updateDress(params:Object) : void
      {
         this.clothId = params.clothId;
         this.faceId = params.faceId;
         this.footId = params.footId;
         this.glassId = params.glassId;
         this.hatId = params.hatId;
         this.weaponId = params.weaponId;
         this.leftWeapon = params.leftWeapon;
         this.wingId = params.wingId;
         this.taozhuangId = params.taozhuangId;
         this.backgroundId = params.backgroundId;
      }
      
      public function cloneDress() : Object
      {
         var obj:Object = {};
         obj.roleType = this.roleType;
         obj.clothId = this.clothId;
         obj.faceId = this.faceId;
         obj.footId = this.footId;
         obj.glassId = this.glassId;
         obj.hatId = this.hatId;
         obj.weaponId = this.weaponId;
         obj.leftWeapon = this.leftWeapon;
         obj.wingId = this.wingId;
         obj.taozhuangId = this.taozhuangId;
         return obj;
      }
      
      public function setHorseParams(sp:int, id:int, index:int) : void
      {
         this.horseSpeed = sp;
         this.horseID = id;
         this.horseIndex = index;
      }
      
      public function get initFaceId() : int
      {
         var sexx:int = 0;
         if(this.faceId == 0)
         {
            sexx = this.roleType & 1;
            if(sexx >= 1 || sexx < 0)
            {
               sexx = 1;
            }
            sexx *= 10;
            this.faceId = 1000 + sexx + 7;
         }
         return this.faceId;
      }
      
      public function get sceneId() : int
      {
         return this._sceneId;
      }
      
      public function set sceneId(value:int) : void
      {
         this._sceneId = value;
      }
   }
}

