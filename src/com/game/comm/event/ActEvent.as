package com.game.comm.event
{
   import flash.events.Event;
   
   public class ActEvent extends Event
   {
      
      private var _data:Object;
      
      public function ActEvent(type:String, data:Object = null)
      {
         this._data = data;
         super(type);
      }
      
      public function get data() : Object
      {
         return this._data;
      }
   }
}

