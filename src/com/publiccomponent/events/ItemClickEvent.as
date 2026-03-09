package com.publiccomponent.events
{
   import flash.events.Event;
   
   public class ItemClickEvent extends Event
   {
      
      public static const ITEMCLICKEVENT:String = "itemclickevent";
      
      private var _params:Object = {};
      
      public function ItemClickEvent(type:String, data:Object = null)
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

