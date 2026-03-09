package com.game.locators
{
   import com.game.modules.vo.AutoCollectData;
   import com.game.modules.vo.AutoLookForPresuresData;
   import com.game.modules.vo.PlayerData;
   import com.game.modules.vo.ShowData;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   
   public class GameData extends EventDispatcher
   {
      
      private static var _instance:GameData;
      
      public static const cantCopySceneList:Array = [200007];
      
      public var playerData:PlayerData;
      
      public var friendData:ShowData;
      
      public var autoLookForPresuresData:AutoLookForPresuresData;
      
      public var autoCollectData:AutoCollectData;
      
      public var cantClickPerson:Boolean = false;
      
      public var shenshoufriends:Array = [];
      
      public var playerLists:Array = [];
      
      public var tasklistInited:Boolean = false;
      
      public var littlegameplayerid:int;
      
      public var littlegameplayername:String;
      
      public var littlegameplayerScore:int;
      
      public var littlegamePkId:int;
      
      private var _friendsList:Array = [];
      
      public var firstEnterScene:Boolean = true;
      
      public var gameSound:Number = 1;
      
      private var _lookBattle:int = 0;
      
      private var _newLookType:int;
      
      public var lookAname:String = "";
      
      public var lookDname:String = "";
      
      public var disableUIIcon:Boolean = true;
      
      private var _scaleStep:Number = 1;
      
      public var badgeData:Dictionary = new Dictionary();
      
      public var boxMessagesArray:Array = [];
      
      public var boxVipMessages:Array = [];
      
      public var userIdTemp:int;
      
      public var isFromRecordPage:Boolean;
      
      private var _battleNoList:Array;
      
      private var _battleItemNum:int;
      
      public function GameData()
      {
         super();
         if(Boolean(_instance))
         {
            throw "GAMEDATA 数据只能被实例化一次";
         }
      }
      
      public static function get instance() : GameData
      {
         if(_instance == null)
         {
            _instance = new GameData();
         }
         if(_instance.playerData == null)
         {
            _instance.playerData = new PlayerData();
         }
         if(_instance.friendData == null)
         {
            _instance.friendData = new ShowData();
         }
         if(_instance.autoLookForPresuresData == null)
         {
            _instance.autoLookForPresuresData = new AutoLookForPresuresData();
         }
         if(_instance.autoCollectData == null)
         {
            _instance.autoCollectData = new AutoCollectData();
         }
         return _instance;
      }
      
      public function get friendsList() : Array
      {
         return this._friendsList;
      }
      
      public function set friendsList(value:Array) : void
      {
         this._friendsList = value;
      }
      
      public function set scaleStep(value:Number) : void
      {
         this._scaleStep = value;
         this.dispatchEvent(new Event("changmapscale"));
      }
      
      public function get lookBattle() : int
      {
         return this._lookBattle;
      }
      
      public function set lookBattle(value:int) : void
      {
         this._lookBattle = value;
      }
      
      public function get scaleStep() : Number
      {
         return this._scaleStep;
      }
      
      public function closeMainMusic() : void
      {
      }
      
      public function openMainMusic() : void
      {
      }
      
      public function showMessagesCome() : void
      {
         this.dispatchEvent(new Event("boxMessageschange"));
      }
      
      public function me() : Boolean
      {
         if(this.playerData.userId == this.friendData.userId)
         {
            return true;
         }
         return false;
      }
      
      public function getPlayerShowDataByUserid(value:int) : ShowData
      {
         var data:ShowData = null;
         var i:int = 0;
         var len:int = int(this.playerLists.length);
         for(i = 0; i < len; i++)
         {
            data = this.playerLists[i];
            if(data.userId == value)
            {
               return data;
            }
         }
         return null;
      }
      
      public function get isCantCopyScene() : Boolean
      {
         return cantCopySceneList.indexOf(this.playerData.currentScenenId) >= 0;
      }
      
      public function get newLookType() : int
      {
         return this._newLookType;
      }
      
      public function set newLookType(value:int) : void
      {
         this._newLookType = value;
      }
      
      public function initNewLook(type:int) : void
      {
         this._lookBattle = 1;
         this.newLookType = type;
      }
      
      public function get battleNoList() : Array
      {
         return this._battleNoList;
      }
      
      public function set battleNoList(value:Array) : void
      {
         this._battleNoList = value;
      }
      
      public function get battleItemNum() : int
      {
         return this._battleItemNum;
      }
      
      public function set battleItemNum(value:int) : void
      {
         this._battleItemNum = value;
      }
      
      public function isLogPlay() : Boolean
      {
         return this.lookBattle == 1 && this.newLookType == 2;
      }
   }
}

