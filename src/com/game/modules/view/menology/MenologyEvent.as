package com.game.modules.view.menology
{
   import flash.events.Event;
   
   public class MenologyEvent extends Event
   {
      
      public static const DUIHUAN:String = "duihuan";
      
      public static const ZHANBU:String = "zhanbu";
      
      public static const CHECKTIME:String = "checktime";
      
      public static const QIANDAO:String = "qiandao";
      
      public static const ZHANBUJIEGUO:String = "zhanbujieguo";
      
      private var _params:Object = {};
      
      public function MenologyEvent(type:String, data:Object = null)
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

