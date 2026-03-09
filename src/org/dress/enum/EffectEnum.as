package org.dress.enum
{
   import com.game.util.LuaObjUtil;
   import com.publiccomponent.loading.XMLLocator;
   
   public class EffectEnum
   {
      
      private static var _BODY_ADD_TEXIAO:Array;
      
      private static var _HORSE_WITH_CLOTH:Array;
      
      public function EffectEnum()
      {
         super();
      }
      
      public static function get BODY_ADD_TEXIAO() : Array
      {
         if(_BODY_ADD_TEXIAO == null)
         {
            _BODY_ADD_TEXIAO = LuaObjUtil.getLuaObjArr(XMLLocator.getInstance().getTool(99999999).body);
         }
         return _BODY_ADD_TEXIAO;
      }
      
      public static function get HORSE_WITH_CLOTH() : Array
      {
         if(_HORSE_WITH_CLOTH == null)
         {
            _HORSE_WITH_CLOTH = LuaObjUtil.getLuaObjArr(XMLLocator.getInstance().getTool(99999999).horse_with_cloth);
         }
         return _HORSE_WITH_CLOTH;
      }
   }
}

