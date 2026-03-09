package com.game.global
{
   import com.game.locators.GameData;
   import flash.display.StageQuality;
   import flash.external.ExternalInterface;
   import mx.utils.StringUtil;
   
   public class GlobalConfig
   {
      
      private static var _tokenTime:Number;
      
      public static var isClearPlayer:*;
      
      public static var roleType:int;
      
      private static var _configFoloder:String;
      
      private static var _czUserName:String;
      
      private static var _isClient:int;
      
      public static var is_show_restraint:int;
      
      public static var is_show_collect_auto_alert:int;
      
      public static var is_vip_auto_recover:int;
      
      private static var _userId:Number = 0;
      
      private static var _userName:String = "65665624";
      
      public static var count:int = 0;
      
      public static var _port:int = 22000;
      
      public static var hallport:int = 5999;
      
      public static var farmport:int = 8001;
      
      public static var swimport:int = 5019;
      
      public static var isDebug:Boolean = true;
      
      private static var _isCrossPlat:Boolean = false;
      
      private static var _server:String = "kbxy.wanwan4399.com";
      
      public static var farmserver:String = "kbljyx.wanwan4399.com";
      
      public static var hallserver:String = "kbljyx.wanwan4399.com";
      
      public static var farmFriendServer:String = "kbljyx.wanwan4399.com";
      
      public static var phpserver:String = "http://php.wanwan4399.com/";
      
      public static var takeoverPwd:String = "4399kabu";
      
      private static var _token:String = "";
      
      public static var userPass:String = "";
      
      public static var userEmail:String = "";
      
      private static var _COMBAT_GAP_TIME:int = 1;
      
      private static var _STAGE_QUALITY:int = 0;
      
      public static var otherObj:Object = {};
      
      public static const STAGE_QUALITY_ARY:Array = [StageQuality.HIGH,StageQuality.MEDIUM,StageQuality.LOW];
      
      public static var is_hide_beibei:int = 0;
      
      public static var pre_ani:int = 0;
      
      private static var _vipEndDate:Date = null;
      
      public function GlobalConfig()
      {
         super();
      }
      
      public static function getCurQuality() : String
      {
         return STAGE_QUALITY_ARY[_STAGE_QUALITY];
      }
      
      public static function get STAGE_QUALITY() : int
      {
         return _STAGE_QUALITY;
      }
      
      public static function set STAGE_QUALITY(value:int) : void
      {
         _STAGE_QUALITY = value;
      }
      
      public static function get COMBAT_GAP_TIME() : int
      {
         return _COMBAT_GAP_TIME;
      }
      
      public static function set COMBAT_GAP_TIME(value:int) : void
      {
         if(value == 0)
         {
            value = 1;
         }
         _COMBAT_GAP_TIME = value;
      }
      
      public static function get isClient() : Boolean
      {
         var str:String = null;
         if(_isClient == 0)
         {
            if(ExternalInterface.available)
            {
               str = ExternalInterface.call("showBrowserIdentity");
               if(str == "")
               {
                  _isClient = -1;
               }
               else
               {
                  _isClient = str.indexOf("4399.kbxy.air");
               }
            }
         }
         return _isClient != -1 && _isClient != 0;
      }
      
      public static function get czUserName() : String
      {
         var params:Object = null;
         if(_czUserName == null || _czUserName == "")
         {
            if(token == "" || token == null)
            {
               _czUserName = userName;
            }
            else
            {
               params = parseLoginStr(token);
               _czUserName = params["username"];
            }
         }
         return _czUserName;
      }
      
      public static function parseLoginStr(str:String) : Object
      {
         var nowArr:Array = null;
         if(!str)
         {
            return null;
         }
         var myobj:Object = new Object();
         var myarr:Array = str.split("&");
         for(var i:int = 0; i < myarr.length; i++)
         {
            nowArr = myarr[i].split("=");
            myobj[nowArr[0]] = decodeURIComponent(nowArr[1]);
         }
         return myobj;
      }
      
      public static function set configFolder(value:String) : void
      {
         _configFoloder = StringUtil.trim(value);
      }
      
      public static function getConfigFolder() : String
      {
         return _configFoloder;
      }
      
      public static function get isCrossPlat() : Boolean
      {
         return _isCrossPlat;
      }
      
      public static function set isCrossPlat(value:Boolean) : void
      {
         _isCrossPlat = value;
      }
      
      public static function get port() : int
      {
         return _port;
      }
      
      public static function set port(value:int) : void
      {
         _port = value;
      }
      
      public static function get token() : String
      {
         return _token;
      }
      
      public static function set token(value:String) : void
      {
         _token = value;
      }
      
      public static function get tokenTime() : Number
      {
         return _tokenTime;
      }
      
      public static function set tokenTime(value:Number) : void
      {
         _tokenTime = value;
      }
      
      public static function get userId() : Number
      {
         return _userId;
      }
      
      public static function set userId(value:Number) : void
      {
         _userId = value;
      }
      
      public static function get userName() : String
      {
         return _userName;
      }
      
      public static function set userName(value:String) : void
      {
         _userName = value;
      }
      
      public static function set curAllServer(value:String) : void
      {
         farmFriendServer = hallserver = farmserver = server = value;
      }
      
      public static function get server() : String
      {
         return _server;
      }
      
      public static function set server(value:String) : void
      {
         _server = value;
      }
      
      public static function get currVipYear() : int
      {
         return GameData.instance.playerData.getDate().getFullYear();
      }
      
      public static function get currVipStartStr() : String
      {
         return "20260101000000";
      }
      
      public static function get vipEndTimeStr() : String
      {
         return currVipYear + 1 + "12312359";
      }
      
      public static function get vipEndExchDate() : Date
      {
         if(!_vipEndDate)
         {
            _vipEndDate = new Date(vipEndTimeStr.substr(0,4),int(vipEndTimeStr.substr(4,2)) - 1,vipEndTimeStr.substr(6,2),vipEndTimeStr.substr(8,2),vipEndTimeStr.substr(10,2));
         }
         return _vipEndDate;
      }
      
      public static function get noExchVip() : Boolean
      {
         var vipDate:Date = new Date(GameData.instance.playerData.expiredTime * 1000);
         if(vipDate.valueOf() >= vipEndExchDate.valueOf())
         {
            return true;
         }
         return false;
      }
      
      public static function get remainExchVipMonth() : int
      {
         var vipDate:Date = new Date(GameData.instance.playerData.expiredTime * 1000);
         var remainYear:int = vipEndExchDate.getFullYear() - vipDate.getFullYear();
         var remainMonth:int = 12 - (vipDate.getMonth() + 1);
         var canMonth:int = remainYear * 12 + remainMonth;
         if(remainMonth == 0 && vipEndExchDate.getDate() > vipDate.getDate())
         {
            canMonth = remainYear * 12 + remainMonth + 1;
         }
         else
         {
            canMonth = remainYear * 12 + remainMonth;
         }
         return canMonth;
      }
   }
}

