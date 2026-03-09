package com.game.modules.view.person
{
   import com.game.modules.control.task.TaskEvent;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   
   public interface INPC
   {
      
      function parseTalkList() : void;
      
      function load(param1:Boolean = false) : void;
      
      function onLoadComplete(param1:Event) : void;
      
      function onLoadError(param1:IOErrorEvent) : void;
      
      function requestState() : void;
      
      function updateState(param1:int) : void;
      
      function playEffect(param1:Function = null) : void;
      
      function sendAction(param1:String, param2:Number, param3:Number) : void;
      
      function onUseAction(param1:TaskEvent) : void;
      
      function initEvents() : void;
      
      function releaseEvents() : void;
   }
}

