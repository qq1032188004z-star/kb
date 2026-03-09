package org.engine.event
{
   import flash.events.Event;
   import org.engine.core.Scene;
   
   public class LoaderEvent extends Event
   {
      
      public static const COMPLEMENT:String = "loadcomplement";
      
      public static const PROGRESS:String = "loadprogress";
      
      public static const ERROR:String = "loaderror";
      
      public var bytesLoaded:Number;
      
      public var bytesTotal:Number;
      
      public var scene:Scene;
      
      public function LoaderEvent(type:String)
      {
         super(type);
      }
   }
}

