package com.game.modules.control.monster
{
   import flash.events.Event;
   
   public class MonsterListEvent extends Event
   {
      
      public static const GETMONSTERINLIST:String = "getmonsterintlist";
      
      public static const GETMONSTEROUTLIST:String = "getmonsteroutlist";
      
      public static const CUREALLMONSTER:String = "cureallmonster";
      
      public static const GCMONSTER:String = "gcmonster";
      
      public static const PUTINPACKET:String = "putinpacket";
      
      public static const RELEASEMONSTER:String = "releasemonster";
      
      public static const SETFIRST:String = "setfirst";
      
      public static const OPENPROPSVIEW:String = "openpropsview";
      
      public static const TRANSFERMONSTER:String = "transfermonster";
      
      public static const GETSYMMPAKAGELIST:String = "getSymmPakageList";
      
      public static const SYMM_WEAR_OR_OFF:String = "symm_wear_or_off";
      
      private var _params:Object = {};
      
      public function MonsterListEvent(type:String, data:Object = null)
      {
         super(type);
         this._params = data;
      }
      
      public function get params() : Object
      {
         return this._params;
      }
   }
}

