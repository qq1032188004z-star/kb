package com.game.manager.cursor
{
   import flash.events.Event;
   
   public class ViewEvent extends Event
   {
      
      private var data:Object;
      
      public function ViewEvent(type:String, data:Object = null)
      {
         super(type);
         this.data = data;
      }
      
      public function getData() : Object
      {
         return this.data;
      }
   }
}

