package com.publiccomponent
{
   import com.game.global.GlobalConfig;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   
   public class URLUtil
   {
      
      public static var verObject:Dictionary = new Dictionary();
      
      public static var gamever:Number = 16.097;
      
      public static var modsver:String = "?v=" + gamever + "" + 6;
      
      public static var gamehallweihu:String = "";
      
      private static var _version:String = "1";
      
      private static var _resVer:String = "1";
      
      private static var _startVer:String = "1";
      
      private static var pathSliceReg:RegExp = /\\/g;
      
      public function URLUtil()
      {
         super();
      }
      
      public static function get resVer() : String
      {
         return _resVer;
      }
      
      public static function get startVer() : String
      {
         return _startVer;
      }
      
      public static function initConfig(xml:XML) : void
      {
         _version = xml["version"];
         _resVer = xml["resVer"];
         _startVer = xml["startVer"];
      }
      
      public static function getGameURL() : String
      {
         if(O.debug)
         {
            return "MainGame.swf?v=" + Math.random();
         }
         return "MainGame.swf?v=" + _version;
      }
      
      public static function verxmlOver(data:ByteArray) : void
      {
         var tempArr:Array = null;
         var patchArr:Array = null;
         var key:String = null;
         var arys:Array = data.toString().split(",");
         var len:Number = arys.length;
         for(var i:int = 0; i < len; i++)
         {
            tempArr = arys[i].split("#");
            if(tempArr.length > 1)
            {
               patchArr = tempArr[1].split("+");
               for each(key in patchArr)
               {
                  if(key != "")
                  {
                     verObject[key] = tempArr[0];
                  }
               }
            }
         }
      }
      
      public static function getConfigVer(value:String) : String
      {
         if(verObject[value] != undefined)
         {
            value = verObject[value];
         }
         else
         {
            value = Math.random().toString();
         }
         return value;
      }
      
      public static function getSvnVer(value:String = "") : String
      {
         value = value.replace(pathSliceReg,"/");
         if(O.debug)
         {
            value = value + "?v=" + Math.random();
            if(value.substr(0,7) == "config/" && value.indexOf("config.xml") == -1)
            {
               value = GlobalConfig.getConfigFolder() + value;
            }
         }
         else if(value.indexOf("?") == -1)
         {
            if(verObject.hasOwnProperty(value))
            {
               value = value + "?v=" + verObject[value];
            }
            else
            {
               value += "?v=1";
            }
         }
         return value;
      }
      
      public static function getXMLURL() : String
      {
         return "data/data";
      }
      
      public static function getMaterialList() : Array
      {
         return [{
            "url":"assets/material/tool2.swf",
            "currentLabel":"加载素材"
         },{
            "url":"assets/material/chatface.swf",
            "currentLabel":"加载表情"
         },{
            "url":"assets/material/tool.swf",
            "currentLabel":"加载动作"
         }];
      }
   }
}

