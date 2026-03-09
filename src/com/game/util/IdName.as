package com.game.util
{
   public class IdName
   {
      
      public function IdName()
      {
         super();
      }
      
      public static function stone(id:int) : String
      {
         return "stone" + id;
      }
      
      public static function npc(id:int) : String
      {
         return "npc" + id;
      }
      
      public static function build(id:int) : String
      {
         return "build" + id;
      }
      
      public static function pet(userid:int) : String
      {
         return "pet" + userid;
      }
      
      public static function fabao(userid:int) : String
      {
         return "fabao" + userid;
      }
      
      public static function monster(id:int) : String
      {
         return "monster" + id;
      }
      
      public static function specialArea(id:int) : String
      {
         return "specialArea" + id;
      }
      
      public static function sceneAI(id:int) : String
      {
         return "sceneai" + id;
      }
      
      public static function id(name:String) : int
      {
         var value:int = 0;
         var i:int = 0;
         var l:int = name.length;
         for(i = 0; i < l; i++)
         {
            if(int(name.charAt(i)) > 0)
            {
               value = int(name.substring(i,name.length));
               break;
            }
         }
         return value;
      }
      
      public static function name(name:String) : String
      {
         var reg:RegExp = null;
         var i:int = 0;
         var str:String = "";
         try
         {
            reg = /[0-9]/;
            i = int(name.search(reg));
            str = name.substr(0,i);
            return str.toLowerCase();
         }
         catch(e:*)
         {
            O.o("IdName.name()方法出错");
         }
         return str;
      }
   }
}

