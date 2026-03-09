package com.game.util
{
   import flash.utils.Dictionary;
   
   public class CacheUtil
   {
      
      public static var pool:Dictionary = new Dictionary(true);
      
      public function CacheUtil()
      {
         super();
      }
      
      public static function getObject(cls:Class) : Object
      {
         if(pool[cls] == null)
         {
            pool[cls] = new cls();
         }
         else if(!pool[cls].parent && Boolean(pool[cls].hasOwnProperty("getserverdata")))
         {
            pool[cls]["getserverdata"]();
         }
         return pool[cls];
      }
      
      public static function deleteObject(cls:Class) : void
      {
         if(Boolean(pool[cls]) && Boolean(pool[cls].hasOwnProperty("dispos")))
         {
            pool[cls]["dispos"]();
         }
         pool[cls] = null;
         delete pool[cls];
      }
      
      public static function getObjectByName(name:String, cls:Class) : Object
      {
         if(pool[name] == null)
         {
            pool[name] = new cls();
         }
         return pool[name];
      }
   }
}

