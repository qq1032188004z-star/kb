package com.game.modules.view.chat
{
   import flash.events.Event;
   
   public class SnapShotEvent extends Event
   {
      
      public static const SAVE:String = "save";
      
      public static const CLOSE:String = "close";
      
      public var bitmapurl:String;
      
      public function SnapShotEvent(type:String, url:String = null)
      {
         super(type,false,false);
         this.bitmapurl = url;
      }
   }
}

