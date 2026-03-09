package com.publiccomponent.events
{
   import flash.events.Event;
   
   public class InterfaceEvent extends Event
   {
      
      public static const FACECLIPCLICK:String = "faceclipclick";
      
      public static const FACECLIK:String = "faceclick";
      
      public static const FACESEND:String = "facesend";
      
      private var _params:Object;
      
      public function InterfaceEvent(type:String, data:Object = null)
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

