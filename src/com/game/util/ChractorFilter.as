package com.game.util
{
   import com.game.global.FilterString;
   import com.game.global.GlobalConfig;
   
   public class ChractorFilter
   {
      
      private static var regEXPnameable:RegExp;
      
      private static var regEXPtrim:RegExp = /\s/g;
      
      private static var regEXPchinese:RegExp = /[^一-龥]/g;
      
      private static var checknamestring:String = "";
      
      private static var regEXPspace:RegExp = /([ ]{1})/g;
      
      public function ChractorFilter()
      {
         super();
      }
      
      public static function filter(value:String, perint:String) : String
      {
         return value;
      }
      
      public static function filterRename(value:String, perint:String) : String
      {
         if(value == null)
         {
            return "";
         }
         return value;
      }
      
      public static function filterqiang(value:String, perint:String) : String
      {
         if(!test(value))
         {
            return value;
         }
         value = replaceNoChinese(value);
         if(value == null)
         {
            return "";
         }
         return value;
      }
      
      public static function test(value:String) : Boolean
      {
         return false;
      }
      
      public static function allSpace(msg:String) : Boolean
      {
         if(msg.length == 0)
         {
            return true;
         }
         for(var i:int = 0; i < msg.length; i++)
         {
            if(msg.charAt(i) != " ")
            {
               return false;
            }
         }
         return true;
      }
      
      public static function allSpaceAndHuanhang(msg:String) : Boolean
      {
         if(msg.length == 0)
         {
            return true;
         }
         for(var i:int = 0; i < msg.length; i++)
         {
            if(msg.charAt(i) != " " && msg.charAt(i) != "\r")
            {
               return false;
            }
         }
         return true;
      }
      
      public static function removeSpceialChar(msg:String) : String
      {
         return msg.replace(regEXPtrim,"");
      }
      
      public static function countMsgLength(msg:String) : Number
      {
         var tempmsg:String = removeSpceialChar(msg);
         return msg.length;
      }
      
      public static function replaceNoChinese(value:String) : String
      {
         var result:String = value;
         result = result.replace(regEXPchinese,"");
         if(result == "")
         {
            result = "*";
         }
         return result;
      }
      
      public static function replaceHtml(value:String) : String
      {
         var result:String = value;
         var regXp:RegExp = new RegExp("<(S*?)[^>]*>.*?|<.*? />","g");
         return result.replace(regXp,"");
      }
      
      public static function checkReName1(msg:String) : Boolean
      {
         var checkMsg:String = msg;
         if(test(checkMsg))
         {
            return true;
         }
         checkMsg = removeSpceialChar(checkMsg);
         checkMsg = replaceNoChinese(checkMsg);
         var regExp:RegExp = new RegExp(FilterString.filterChars,"g");
         return regExp.test(checkMsg);
      }
      
      public static function checkReName(msg:String) : Boolean
      {
         if(test(msg))
         {
            return true;
         }
         msg = removeSpceialChar(msg);
         msg = replaceNoChinese(msg);
         var regExp:RegExp = new RegExp(FilterString.filterChars,"g");
         return regExp.test(msg);
      }
      
      public static function ableName(value:String) : Boolean
      {
         var specialIDList:Array = [225311528,378177008];
         if(checknamestring == "" || regEXPnameable == null)
         {
            checknamestring = FilterString.filterChars;
            regEXPnameable = new RegExp(new XMLList(checknamestring),"g");
         }
         var tempname:String = value;
         tempname = tempname.replace(regEXPspace,"");
         if(specialIDList.indexOf(GlobalConfig.userId) == -1)
         {
            tempname = tempname.replace(regEXPnameable,"*");
         }
         if(tempname.indexOf("*") != -1)
         {
            return false;
         }
         tempname = ChractorFilter.filterRename(tempname,"*");
         tempname = removeSpceialChar(tempname);
         if(tempname.indexOf("*") != -1)
         {
            return false;
         }
         if(tempname == "")
         {
            return false;
         }
         return true;
      }
   }
}

