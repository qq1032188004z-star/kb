package com.game.modules.vo
{
   import com.core.observer.MessageEvent;
   import com.game.locators.EventDefine;
   import com.game.locators.GameData;
   import com.game.modules.view.MapView;
   import com.game.modules.vo.arena.ArenaVo;
   import com.game.modules.vo.team.TeamVo;
   import flash.utils.Dictionary;
   
   public class PlayerData extends ShowData
   {
      
      public const shibaoReviewNum:int = 158;
      
      public var shibaoPage:int = 1;
      
      public var showSpiritLevelUp:Boolean = true;
      
      public var arenaVo:ArenaVo;
      
      public var isAutoBattle:Boolean;
      
      public var selectplayer:int;
      
      public var giantId:int;
      
      public var isInFishState:Boolean;
      
      public var maxLevel:int;
      
      public var isAcceptInvite:Boolean;
      
      public var canChangeName:Boolean;
      
      public var ableName:Boolean = true;
      
      public var isRefuseUnfamilyChat:Boolean;
      
      public var isImprison:Boolean;
      
      public var isSleep:Boolean;
      
      public var magicStatus:int = 0;
      
      public var isInWarCraft:Boolean = false;
      
      public var isAcceptWarcraftInvite:Boolean;
      
      public var familyWarcraftWarId:int;
      
      public var isInCrazyRecordRoom:Boolean;
      
      public var isInMazeIsland:Boolean;
      
      public var isNoClearModel:Boolean;
      
      private var _isNewHand:int;
      
      public var hasGetBeiBei:int;
      
      public var hasLogin:Boolean;
      
      public var playerInWanyaoCopyData:Object;
      
      public var serverId:int;
      
      public var sid:int;
      
      public var enterSid:int;
      
      public var serverName:String;
      
      public var onlineNumber:String;
      
      public var lastsid:int;
      
      public var totalServerNum:int;
      
      private var _currentScenenId:int;
      
      public var isInscene:Boolean;
      
      public var dailyTask:Object;
      
      public var playerSurplus:int;
      
      public var playswfStatus:Boolean;
      
      public var systemTimes:Number;
      
      public var onlineTime:int;
      
      public var armsArr:Array = [];
      
      public var toolArr:Array = [];
      
      public var goodArr:Array = [];
      
      public var presuresArr:Array = [];
      
      public var zuoqiArr:Array = [];
      
      public var collectStatus:int;
      
      public var friendList:Array;
      
      public var packMonsters:Array;
      
      public var isHasEnterScene:Boolean;
      
      public var getkeyfromHallType:int;
      
      public var selfStageRecord:int;
      
      public var bigBattleTimes:int = 20;
      
      public var doubleExpTimes:int = 0;
      
      public var magiclearnarr:Dictionary = new Dictionary(false);
      
      public var friendinvitedic:Dictionary = new Dictionary(false);
      
      public var gamehalldata:Object = {};
      
      public var currentCopyLevel:int;
      
      private var _lastcopylevel:int = 1;
      
      public var maxcopylevel:int;
      
      public var copyScene:int;
      
      public var sceneType:int = 0;
      
      public var passCopy:Boolean;
      
      public var leitaidata:Object = {
         "sBobName":"",
         "sBobAtker":0,
         "sBobDefer":0,
         "sBobTimes":0,
         "shaveperson":0,
         "dBobName":"",
         "dBobAtker":0,
         "dBobDefer":0,
         "dBobTimes":0,
         "dhaveperson":0
      };
      
      public var houhuayuanID:int;
      
      public var smallHouseID:int;
      
      public var currentCopyType:Number;
      
      public var msgCache:Dictionary = new Dictionary();
      
      public var isOpening:Dictionary = new Dictionary();
      
      public var isFriendViewOpen:Boolean;
      
      public var fmsgCache:Dictionary = new Dictionary();
      
      public var fisOpening:Dictionary = new Dictionary();
      
      public var familyMsgCache:Array = new Array();
      
      public var familyisOpen:Boolean;
      
      public var followerList:Array = [];
      
      public var addFriendMsgList:Array = [];
      
      public var benevolentEveryDay:int;
      
      public var toGetBenevolent:Boolean = false;
      
      public var active_status:int = 0;
      
      public var family_id:int = -1;
      
      public var family_level:int = -1;
      
      public var family_war_state:int = 0;
      
      public var create_flag:Boolean = false;
      
      public var family_info:Object;
      
      public var family_base_id:int = -1;
      
      private var _family_base_name:String = "";
      
      public var family_leader_id:int = -1;
      
      public var family_base_star:int = 1;
      
      public var family_map_star:int = 1;
      
      public var magicstate:int = 0;
      
      public var family_msg_forbid:Boolean;
      
      public var renqizhi:int;
      
      public var ernieNum:int;
      
      public var isDance:Boolean = false;
      
      public var pos:int;
      
      public var isGetAward:Boolean = false;
      
      public var isVipTimeUp:Boolean;
      
      public var tempfriends:Object = {};
      
      public var activeTmpData:Object = {};
      
      public var isReciveSprite:Boolean;
      
      public var formType:int;
      
      public var myTeamData:TeamVo;
      
      public var invitePlayer:Object;
      
      public var fireMosueCurse:String = "";
      
      public var fireCurrentPerson:int = 0;
      
      public var fireType:int = 1;
      
      public var step:int = -1;
      
      public var taskStatus:uint = 0;
      
      public var imageData:Object;
      
      public var isInGardon:Boolean = false;
      
      public var godWealthCount:int = 0;
      
      public var effectList:EffectListVo = new EffectListVo();
      
      private var _newvalue:Dictionary = new Dictionary(false);
      
      public var araamapId:int = 0;
      
      public var dailyTaskInGameHall:int = 0;
      
      public var inviteType:int = 0;
      
      public var vipRecharge:Object;
      
      public var shenshouBackId:int;
      
      public var shenshoudata:Object;
      
      public var shenshouyuan_id:int = 0;
      
      public var shenshouyuan_name:String = "";
      
      public var shenshouyuanlevel:int = 0;
      
      public var shenshoupeiyulevel:int = 0;
      
      public var shenshouIndex:int = 0;
      
      public var enterFarmFlag:Boolean;
      
      public var firstMallFlag:int;
      
      public var warInviteList:Array = [];
      
      private var _state11:int;
      
      private var _totalParam:int;
      
      private var _todayparam:int;
      
      private var _autoCombatCnt:int;
      
      public function PlayerData()
      {
         super();
      }
      
      public function get isNewHand() : int
      {
         return this._isNewHand;
      }
      
      public function set isNewHand(value:int) : void
      {
         this._isNewHand = value;
      }
      
      public function set currentScenenId(value:int) : void
      {
         if(MapView.instance.isLoader)
         {
            return;
         }
         this._currentScenenId = value;
         GameData.instance.dispatchEvent(new MessageEvent(EventDefine.CURRENT_SCENEN_CHANGE));
      }
      
      public function get currentScenenId() : int
      {
         return this._currentScenenId;
      }
      
      public function get lastcopylevel() : int
      {
         return this._lastcopylevel;
      }
      
      public function set lastcopylevel(value:int) : void
      {
         this._lastcopylevel = value;
      }
      
      public function get newvalue() : Dictionary
      {
         return this._newvalue;
      }
      
      public function set newvalue(value:Dictionary) : void
      {
         this._newvalue = value;
      }
      
      public function isHaveFmsg() : Boolean
      {
         var result:Boolean = false;
         var key:String = null;
         var cache:Array = null;
         for(key in this.fmsgCache)
         {
            cache = this.fmsgCache[key] as Array;
            if(cache.length != 0)
            {
               result = true;
               break;
            }
         }
         if(result)
         {
            return result;
         }
         if(this.familyMsgCache.length > 0)
         {
            result = true;
         }
         return result;
      }
      
      public function getLatestFmsg() : Object
      {
         var key:String = null;
         var cache:Array = null;
         var result:Array = [];
         for(key in this.fmsgCache)
         {
            cache = this.fmsgCache[key] as Array;
            if(cache.length != 0)
            {
               result = cache;
            }
         }
         return result[result.length - 1];
      }
      
      public function set family_base_name(value:String) : void
      {
         this._family_base_name = value;
      }
      
      public function get family_base_name() : String
      {
         return this._family_base_name;
      }
      
      public function getFamilyWarInvite() : Object
      {
         return this.warInviteList.shift();
      }
      
      public function updatePackList(list:Array) : void
      {
         var j:int = 0;
         var len:int = 0;
         if(list == [] || list == null)
         {
            return;
         }
         len = int(list.length);
         for(len = list.length - 1; len >= 0; len--)
         {
            if(list[len] == null || list[len].count == 0)
            {
               list.splice(len,1);
            }
         }
         var i:int = 0;
         len = int(list.length);
         while(i < len)
         {
            for(j = 1 + i; j < list.length; j++)
            {
               if(list[i].id == list[j].id)
               {
                  list[i].count += list[j].count;
                  list.splice(j,1);
               }
            }
            i++;
         }
      }
      
      public function getDate() : Date
      {
         return new Date(this.systemTimes * 1000);
      }
      
      public function getMinutes() : int
      {
         var date:Date = this.getDate();
         date.setHours(0,0,0,0);
         return this.systemTimes - int(date.getTime() / 1000);
      }
      
      public function get totalParam() : int
      {
         return this._totalParam;
      }
      
      public function set totalParam(value:int) : void
      {
         this._totalParam = value;
      }
      
      public function get todayparam() : int
      {
         return this._todayparam;
      }
      
      public function set todayparam(value:int) : void
      {
         this._todayparam = value;
      }
      
      public function get state11() : int
      {
         return this._state11;
      }
      
      public function set state11(value:int) : void
      {
         this._state11 = value;
      }
      
      public function get autoCombatCnt() : int
      {
         return this._autoCombatCnt;
      }
      
      public function set autoCombatCnt(value:int) : void
      {
         this._autoCombatCnt = value;
      }
   }
}

