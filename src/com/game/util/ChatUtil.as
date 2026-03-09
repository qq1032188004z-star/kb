package com.game.util
{
   import com.game.manager.AlertManager;
   import com.publiccomponent.alert.Alert;
   import com.publiccomponent.loading.XMLLocator;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import flash.net.URLVariables;
   import flash.utils.ByteArray;
   
   public class ChatUtil
   {
      
      private static var _checkCon:String;
      
      private static var _checkCallback:Function;
      
      private static var _checkCancelback:Function;
      
      private static var _checkOther:Object;
      
      private static var _cancelStr:String;
      
      private static var nameXML:XML;
      
      private static var chatXML:XML;
      
      public function ChatUtil()
      {
         super();
      }
      
      public static function onCompanyCheck(str:String, callBack:Function, otherObj:Object = null, cancelBack:Function = null, cancelStr:String = null, isNC:Boolean = false) : void
      {
         _checkCon = str;
         _checkCallback = callBack;
         _checkCancelback = cancelBack;
         _checkOther = otherObj;
         if(cancelStr == null)
         {
            _cancelStr = "含有违规字符，请重新编辑";
         }
         else
         {
            _cancelStr = cancelStr;
         }
         var checkURL:String = "http://sy.4399xpdl.com/pub/remote/audit-v4.php";
         var checkREQ2:URLRequest = new URLRequest(checkURL);
         var variables:URLVariables = new URLVariables();
         variables.decode("content=" + changMark(str) + "&forumsId=" + (isNC ? "kabu-nc" : "kabu"));
         checkREQ2.data = variables;
         checkREQ2.method = URLRequestMethod.POST;
         var checkLoader2:URLLoader = new URLLoader();
         checkLoader2.dataFormat = URLLoaderDataFormat.BINARY;
         checkLoader2.addEventListener(Event.COMPLETE,onCheckCompleteHandler);
         checkLoader2.addEventListener(IOErrorEvent.IO_ERROR,onIOErrorHandler);
         checkLoader2.load(checkREQ2);
      }
      
      public static function onCheckStr(str:String) : String
      {
         if(Boolean(str) && str.indexOf("院士") != -1)
         {
            return "违规昵称";
         }
         return str;
      }
      
      public static function onCheckBan(str:String) : Boolean
      {
         if(Boolean(str) && str.indexOf("违规") != -1)
         {
            return true;
         }
         return false;
      }
      
      public static function isOpenChange() : Boolean
      {
         if(nameXML == null)
         {
            nameXML = XMLLocator.getInstance().getErrofInfo(904);
         }
         if(DateUtil.isServerTimeBetween(String(nameXML.starT),String(nameXML.endT)))
         {
            AlertManager.instance.addTipAlert({
               "tip":nameXML.desc,
               "type":1
            });
            return false;
         }
         return true;
      }
      
      public static function isOpenChat() : Boolean
      {
         if(chatXML == null)
         {
            chatXML = XMLLocator.getInstance().getErrofInfo(905);
         }
         if(DateUtil.isServerTimeBetween(String(chatXML.starT),String(chatXML.endT)))
         {
            AlertManager.instance.addTipAlert({
               "tip":chatXML.desc,
               "type":1
            });
            return false;
         }
         return true;
      }
      
      private static function changMark(str:String) : String
      {
         var tempChar:String = null;
         var arr:Array = null;
         var j:int = 0;
         var newStr:String = str;
         var limitStr:String = "#&+";
         var len:int = limitStr.length;
         for(var i:int = 0; i < len; i++)
         {
            tempChar = limitStr.charAt(i);
            arr = newStr.split(tempChar);
            for(j = 0; j < arr.length; j++)
            {
               newStr = newStr.replace(tempChar,"");
            }
         }
         return newStr;
      }
      
      private static function onIOErrorHandler(e:IOErrorEvent) : void
      {
         var loader:URLLoader = e.target as URLLoader;
         loader.removeEventListener(Event.COMPLETE,onCheckCompleteHandler);
         loader.removeEventListener(IOErrorEvent.IO_ERROR,onIOErrorHandler);
         checkResultOver(true);
      }
      
      private static function onCheckCompleteHandler(event:Event) : void
      {
         var loader:URLLoader = event.target as URLLoader;
         loader.removeEventListener(Event.COMPLETE,onCheckCompleteHandler);
         loader.removeEventListener(IOErrorEvent.IO_ERROR,onIOErrorHandler);
         var relData:ByteArray = loader.data as ByteArray;
         var relStr:String = relData.readUTFBytes(relData.length);
         var checkObj:Object = JSON.parse(relStr);
         if(Boolean(checkObj) && checkObj.hasOwnProperty("from"))
         {
            switch(checkObj["from"])
            {
               case "audit":
                  onCheckLoaded2Handler(checkObj["result"]);
                  break;
               case "webgame":
                  onCheckLoadedHandler(checkObj["result"]);
            }
         }
      }
      
      private static function onCheckLoaded2Handler(checkObj:Object) : void
      {
         var result:Object = null;
         var censor_result:Object = null;
         if(checkObj && checkObj.hasOwnProperty("code") && checkObj["code"] == 100)
         {
            if(checkObj.hasOwnProperty("result"))
            {
               result = checkObj["result"];
               if(result.hasOwnProperty("censor_result"))
               {
                  censor_result = result["censor_result"];
                  if(censor_result.hasOwnProperty("level"))
                  {
                     switch(censor_result["level"])
                     {
                        case 0:
                           checkResultOver(false);
                           return;
                        case 1:
                           if(censor_result.hasOwnProperty("content"))
                           {
                              _checkCon = censor_result["content"];
                              checkResultOver(false);
                           }
                           else
                           {
                              checkResultOver(true);
                           }
                           return;
                        case 2:
                           checkResultOver(true);
                           return;
                     }
                  }
               }
               if(result.hasOwnProperty("riskType") && result["riskType"] == 0)
               {
                  checkResultOver(false);
                  return;
               }
            }
         }
         checkResultOver(true);
      }
      
      private static function onCheckLoadedHandler(checkObj:Object) : void
      {
         var tempChar:String = null;
         var pattern:RegExp = null;
         var bannedStr:String = getBannedStr(checkObj);
         var len:int = bannedStr.length;
         for(var i:int = 0; i < len; i++)
         {
            tempChar = bannedStr.charAt(i);
            pattern = new RegExp(tempChar,"g");
            _checkCon = _checkCon != null ? _checkCon.replace(pattern,"*") : "*";
         }
         checkResultOver(false);
      }
      
      private static function getBannedStr(checkObj:Object) : String
      {
         var key:String = null;
         var tempObj:Object = null;
         var tempStr:String = null;
         var len:int = 0;
         var i:int = 0;
         var tempChar:String = null;
         var strBanned:String = "";
         for(key in checkObj)
         {
            tempObj = checkObj[key];
            tempStr = tempObj["maskWord"];
            len = tempStr.length;
            for(i = 0; i < len; i++)
            {
               tempChar = tempStr.charAt(i);
               if(strBanned.indexOf(tempChar) == -1)
               {
                  strBanned += tempChar;
               }
            }
         }
         return strBanned;
      }
      
      private static function checkResultOver(isShield:Boolean) : void
      {
         var con:String = _checkCon;
         _checkCon = null;
         if(isShield)
         {
            new Alert().show(_cancelStr);
            if(_checkCancelback != null)
            {
               _checkCancelback.apply(null,[con,_checkOther]);
            }
         }
         else
         {
            _checkCallback.apply(null,[con,_checkOther]);
         }
      }
      
      public static function cutSpaceStr(str:String) : String
      {
         if(str == null)
         {
            return "";
         }
         return str.replace(/\\n/g,"\n");
      }
   }
}

