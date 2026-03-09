package com.game.modules.control.replace
{
   import flash.events.Event;
   
   public class ReplaceEvent extends Event
   {
      
      public static const REPLACEEVENT:String = "replaceevent";
      
      private var _params:Object;
      
      public function ReplaceEvent(type:String, data:Object = null)
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

