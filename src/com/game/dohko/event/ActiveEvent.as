package com.game.dohko.event
{
   import flash.events.Event;
   
   public class ActiveEvent extends Event
   {
      
      public var data:Object;
      
      public function ActiveEvent(type:String, param:Object = null, bubbles:Boolean = false)
      {
         this.data = param;
         super(type,bubbles,false);
      }
   }
}

