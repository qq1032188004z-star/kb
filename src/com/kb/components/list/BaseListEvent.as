package com.kb.components.list
{
   import flash.events.Event;
   
   public class BaseListEvent extends Event
   {
      
      private var _data:Object;
      
      public function BaseListEvent(type:String, data:Object = null)
      {
         super(type);
         this._data = data;
      }
      
      public function get data() : Object
      {
         return this._data;
      }
   }
}

