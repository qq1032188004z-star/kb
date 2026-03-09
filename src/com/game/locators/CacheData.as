package com.game.locators
{
   import com.game.modules.vo.KabuOnlineData;
   import com.game.modules.vo.list.MonsterIntroList;
   import com.game.modules.vo.list.MonsterStorageList;
   import com.game.modules.vo.list.OnlineIntroList;
   import com.game.modules.vo.list.OnlineList;
   import com.game.modules.vo.list.OnlineTimerList;
   import com.game.modules.vo.list.TitleList;
   import com.publiccomponent.URLUtil;
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   
   public class CacheData extends EventDispatcher
   {
      
      private static var _instance:CacheData;
      
      private var _monsterIntroList:MonsterIntroList;
      
      public var storageList:MonsterStorageList;
      
      public var collectList:MonsterStorageList;
      
      public var freeList:MonsterStorageList;
      
      public var storageTotalLen:int;
      
      public var storageCurrentLen:int;
      
      public var screenChat:Boolean = true;
      
      public var topLimitOpenList:Dictionary = new Dictionary();
      
      public var openState:int;
      
      private var _onlineIntros:OnlineIntroList;
      
      private var _onlinelist:OnlineList;
      
      private var _onlineTimer:OnlineTimerList;
      
      private var _titleList:TitleList;
      
      private var _kabuOnline:KabuOnlineData;
      
      public var sceneName:String = "";
      
      public var scenceHorseLimited:int = 0;
      
      public var scenceHorseTips:int = 0;
      
      public var isSummerFirst:Boolean = true;
      
      public var _inScenes:Boolean;
      
      private var urldic:Object = {};
      
      public var _beSetTimeout:Boolean;
      
      public var closeTime:Number = 0;
      
      public var wareHouseFaceId:int;
      
      public var charmRankType:int = 1;
      
      public var eamilNum:int = 0;
      
      public var noEamilList:Object = [];
      
      public var isPlayWeeklyActAmi:Boolean;
      
      public var isPlayBraveEffect:Boolean = true;
      
      public var isPlayEffDailyCompassEffect:Boolean = true;
      
      public var isPlayEffArena:Boolean = true;
      
      public var newHandSpriteId:int;
      
      public var isEnterSceneByCopy:Boolean = true;
      
      public var openboxscene:int = 0;
      
      public var perishEvilScene:int = 0;
      
      public var isOpenAct668BoxView:Boolean = false;
      
      public var boxMapByAct668:Array = [];
      
      public var digNumByAct668:int;
      
      public var isEscortModelOpen:Boolean = false;
      
      public var isClickBenYuanBtn:Boolean = false;
      
      public var isPlayAniBenYuan:Boolean = false;
      
      public var isNewBrave:int = 0;
      
      public var treasureSceneId:int;
      
      public var treasureRestHuntTime:int;
      
      public var palyerStateDic:Dictionary = new Dictionary();
      
      public var uiEffectDic:Dictionary = new Dictionary();
      
      private var _eamilData:Object = {};
      
      public function CacheData()
      {
         super();
         this.topLimitOpenList = new Dictionary();
         var ary:Array = [0,0,900,0,460,120,160,1000,500,50];
         for(var i:int = 0; i < ary.length; i++)
         {
            this.topLimitOpenList[i] = {
               "curLen":0,
               "maxLen":ary[i]
            };
         }
      }
      
      public static function get instance() : CacheData
      {
         if(_instance == null)
         {
            _instance = new CacheData();
         }
         return _instance;
      }
      
      public function get monsterIntroList() : MonsterIntroList
      {
         if(this._monsterIntroList == null)
         {
            this._monsterIntroList = new MonsterIntroList();
         }
         return this._monsterIntroList;
      }
      
      public function get titleList() : TitleList
      {
         if(this._titleList == null)
         {
            this._titleList = new TitleList();
            this._titleList.initialize();
         }
         return this._titleList;
      }
      
      public function get kabuOnline() : KabuOnlineData
      {
         if(this._kabuOnline == null)
         {
            this._kabuOnline = new KabuOnlineData();
         }
         return this._kabuOnline;
      }
      
      public function get onlineIntros() : OnlineIntroList
      {
         if(this._onlineIntros == null)
         {
            this._onlineIntros = new OnlineIntroList(this.onlinelist.build);
         }
         return this._onlineIntros;
      }
      
      public function get onlinelist() : OnlineList
      {
         if(this._onlinelist == null)
         {
            this._onlinelist = new OnlineList();
         }
         return this._onlinelist;
      }
      
      public function get onlineTimer() : OnlineTimerList
      {
         if(this._onlineTimer == null)
         {
            this._onlineTimer = new OnlineTimerList();
         }
         return this._onlineTimer;
      }
      
      public function formatUrl(url:String) : String
      {
         var len:int = 0;
         var nowTime:Number = NaN;
         var i:int = 0;
         var version:Array = this.urldic[url] as Array;
         if(Boolean(version) && version.length > 0)
         {
            len = int(version.length);
            nowTime = GameData.instance.playerData.systemTimes;
            for(i = 0; i < len; i++)
            {
               if(nowTime >= version[i][0] && nowTime < version[i][1])
               {
                  return URLUtil.getSvnVer(url + version[i][0]);
               }
            }
         }
         return URLUtil.getSvnVer(url);
      }
      
      public function get payUrl() : String
      {
         return "https://cz.4399.com/kbxy/?je=10&union=80006&uid=" + GameData.instance.playerData.userId;
      }
      
      public function isArenaEnd() : int
      {
         var endDate:Date = new Date(2018,2,16,23);
         var date2:Date = new Date(1409500800 * 1000);
         var time:int = endDate.time / 1000;
         return GameData.instance.playerData.systemTimes - time;
      }
      
      public function get dataString() : String
      {
         var d:Date = null;
         if(d == null)
         {
            d = new Date();
         }
         if(d.time > 1391007600000 && d.time < 1391698800000)
         {
            return "20140129";
         }
         if(d.time > 1391698800000 && d.time < 1392303600000)
         {
            return "20140206";
         }
         return "";
      }
      
      public function addEmail(emailInfo:Object) : void
      {
         if(!this._eamilData)
         {
            this._eamilData = {};
         }
         if(Boolean(emailInfo) && emailInfo.id > 0)
         {
            this._eamilData[emailInfo.id] = emailInfo;
         }
         this.noReadEmailList();
      }
      
      public function deleteEmail(idArr:Array) : void
      {
         if(!idArr || idArr.length <= 0)
         {
            return;
         }
         if(!this._eamilData)
         {
            this._eamilData = {};
         }
         for(var i:int = 0; i < idArr.length; i++)
         {
            delete this._eamilData[idArr[i]];
         }
         this.noReadEmailList();
      }
      
      public function updateEmail(data:Object) : void
      {
         if(!data)
         {
            return;
         }
         if(!this._eamilData)
         {
            this._eamilData = {};
         }
         var emailInfo:Object = this._eamilData[data.id];
         if(Boolean(emailInfo))
         {
            emailInfo["status"] = data["status"];
         }
         this.noReadEmailList();
      }
      
      public function noReadEmailList() : Array
      {
         var emailInfo:Object = null;
         var emailId:String = null;
         var noList:Array = [];
         for(emailId in this._eamilData)
         {
            emailInfo = this._eamilData[emailId];
            if(emailInfo.status == 0)
            {
               noList.push(emailInfo.id);
            }
         }
         this.eamilNum = noList.length;
         return noList;
      }
      
      public function get showNewEmailNum() : int
      {
         var noList:Array = this.noReadEmailList();
         var newNum:int = 0;
         for(var i:int = 0; i < noList.length; i++)
         {
            if(this.noEamilList.indexOf(noList[i]) <= -1)
            {
               newNum++;
            }
         }
         return newNum;
      }
   }
}

