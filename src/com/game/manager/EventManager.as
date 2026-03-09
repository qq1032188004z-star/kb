package com.game.manager
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class EventManager
   {
      
      public function EventManager()
      {
         super();
      }
      
      public static function attachEventList(dispatcherList:Array, eventName:String, callBack:Function, useCapture:Boolean = false) : void
      {
         var dispatcher:EventDispatcher = null;
         for each(dispatcher in dispatcherList)
         {
            dispatcher.addEventListener(eventName,callBack,useCapture);
         }
      }
      
      public static function attachEvent(dispatcher:EventDispatcher, eventName:String, callBack:Function, useCapture:Boolean = false) : void
      {
         if(dispatcher != null && !dispatcher.hasEventListener(eventName))
         {
            dispatcher.addEventListener(eventName,callBack,useCapture);
         }
      }
      
      public static function removeEvent(dispatcher:EventDispatcher, eventName:String, callBack:Function) : void
      {
         if(dispatcher != null)
         {
            dispatcher.removeEventListener(eventName,callBack);
         }
      }
      
      public static function dispatch(dispatcher:EventDispatcher, evt:Event) : void
      {
         if(dispatcher != null)
         {
            dispatcher.dispatchEvent(evt);
         }
      }
   }
}

