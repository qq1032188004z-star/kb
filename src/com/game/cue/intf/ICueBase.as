package com.game.cue.intf
{
   import flash.display.DisplayObjectContainer;
   
   public interface ICueBase
   {
      
      function build(param1:String, param2:DisplayObjectContainer = null, param3:Object = null) : void;
      
      function get params() : Object;
      
      function set params(param1:Object) : void;
      
      function disport() : void;
   }
}

