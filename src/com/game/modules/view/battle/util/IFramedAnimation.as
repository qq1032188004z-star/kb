package com.game.modules.view.battle.util
{
   import flash.events.IEventDispatcher;
   
   public interface IFramedAnimation extends IEventDispatcher
   {
      
      function set updateFrameFN(param1:Function) : void;
      
      function get updateFrameFN() : Function;
      
      function set frameRate(param1:int) : void;
      
      function get frameRate() : int;
      
      function get paused() : Boolean;
   }
}

