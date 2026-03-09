package com.publiccomponent.util
{
   public class RegExpUtil
   {
      
      public static var instance:RegExpUtil = new RegExpUtil();
      
      private var reg:RegExp;
      
      public function RegExpUtil()
      {
         super();
      }
      
      public function replaceSpecialWord(str:String) : String
      {
         this.reg = /[^\w一-龥]/g;
         if(str != null)
         {
            return str.replace(this.reg,"");
         }
         return "";
      }
   }
}

