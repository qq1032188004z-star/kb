package com.game.util
{
   public class HtmlUtil
   {
      
      private static var fontReg:RegExp = /<font/g;
      
      private static var myLt:RegExp = /</g;
      
      private static var myRt:RegExp = /\>/g;
      
      public function HtmlUtil()
      {
         super();
      }
      
      public static function getHtmlText(fontSize:int, fontColor:String, string:String) : String
      {
         if(!fontReg.test(string))
         {
            return "<font size=\'" + fontSize + "\' color=\'" + fontColor + "\'>" + string + "</font>";
         }
         return string;
      }
      
      public static function getLinkHtmlString(linkStr:String, colorStr:String, nameStr:String) : String
      {
         return "<u><a href=\"event:" + linkStr + "\"><font color=\'" + colorStr + "\'>" + nameStr + "</font></a></u>";
      }
      
      public static function getHtmlStrong(str:String) : String
      {
         return "<b>" + str + "</b>";
      }
      
      public static function getRealHtmlStr(str:String) : String
      {
         if(str == null)
         {
            return "";
         }
         str = str.replace(myLt,"&lt;");
         return str.replace(myRt,"&gt;");
      }
   }
}

