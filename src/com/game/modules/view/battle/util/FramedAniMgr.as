package com.game.modules.view.battle.util
{
   import flash.display.DisplayObject;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class FramedAniMgr extends EventDispatcher
   {
      
      private static var mainInstance:FramedAniMgr;
      
      public static const RENDER_FRAME:String = "renderFrame";
      
      private static var renderFrameEvent:Event = new Event(RENDER_FRAME);
      
      private var __aniBuffer:Vector.<IFramedAnimation> = new Vector.<IFramedAnimation>();
      
      private var _stage:Stage;
      
      private var _aniList:Vector.<IFramedAnimation> = new Vector.<IFramedAnimation>();
      
      private var _pause:Boolean;
      
      private var _haveUpdateFNCatcher:Boolean;
      
      private var _listenedStageEnterFrame:Boolean;
      
      public function FramedAniMgr()
      {
         super();
      }
      
      public static function getMainInstance() : FramedAniMgr
      {
         if(!mainInstance)
         {
            mainInstance = new FramedAniMgr();
         }
         return mainInstance;
      }
      
      public static function set stage(value:Stage) : void
      {
         getMainInstance().stage = value;
      }
      
      public static function registerFramedAni(ani:IFramedAnimation, unregisterWhenRemoved:Boolean = true) : void
      {
         getMainInstance().registerFramedAni(ani,unregisterWhenRemoved);
      }
      
      public static function unregisterFramedAni(ani:IFramedAnimation) : void
      {
         getMainInstance().unregisterFramedAni(ani);
      }
      
      public static function setUpdateFNCacher(catchFN:Function) : void
      {
         getMainInstance().setUpdateFNCacher(catchFN);
      }
      
      public static function pause() : void
      {
         getMainInstance().pause();
      }
      
      public static function resume() : void
      {
         getMainInstance().resume();
      }
      
      public function set stage(value:Stage) : void
      {
         this._stage = value;
      }
      
      public function registerFramedAni(ani:IFramedAnimation, unregisterWhenRemoved:Boolean = true) : void
      {
         if(this._aniList == null)
         {
            this._aniList = new Vector.<IFramedAnimation>();
            this.__aniBuffer = new Vector.<IFramedAnimation>();
         }
         if(this._aniList.indexOf(ani) != -1)
         {
            return;
         }
         this._aniList.push(ani);
         if(ani is DisplayObject)
         {
            if(unregisterWhenRemoved)
            {
               (ani as DisplayObject).addEventListener(Event.REMOVED_FROM_STAGE,this.onAniRemoved);
            }
            else
            {
               (ani as DisplayObject).removeEventListener(Event.REMOVED_FROM_STAGE,this.onAniRemoved);
            }
         }
         this.checkStageFrameRender();
      }
      
      public function unregisterFramedAni(ani:IFramedAnimation) : void
      {
         var idx:int = 0;
         if(Boolean(this._aniList))
         {
            idx = int(this._aniList.indexOf(ani));
            if(idx != -1)
            {
               this._aniList.splice(idx,1);
            }
         }
         ani.removeEventListener(Event.REMOVED_FROM_STAGE,this.onAniRemoved);
         this.checkStageFrameRender();
      }
      
      public function setUpdateFNCacher(catchFN:Function) : void
      {
         this._haveUpdateFNCatcher = false;
         if(catchFN != null)
         {
            this._haveUpdateFNCatcher = true;
            catchFN(this.onStageEnterFrame);
         }
         this.checkStageFrameRender();
      }
      
      public function pause() : void
      {
         this._pause = true;
      }
      
      public function resume() : void
      {
         this._pause = false;
      }
      
      private function onAniRemoved(event:Event) : void
      {
         var ani:DisplayObject = event.target as DisplayObject;
         this.unregisterFramedAni(ani as IFramedAnimation);
      }
      
      private function checkStageFrameRender() : void
      {
         var render:Boolean = false;
         var key:String = null;
         var _loc3_:int = 0;
         var _loc4_:* = this._aniList;
         for(key in _loc4_)
         {
            render = true;
         }
         if(render)
         {
            render = !this._haveUpdateFNCatcher;
         }
         if(render)
         {
            if(!Boolean(this._stage))
            {
               throw new Error("stage have not setted!");
            }
            if(!this._listenedStageEnterFrame)
            {
               this._stage.addEventListener(Event.ENTER_FRAME,this.onStageEnterFrame);
               this._listenedStageEnterFrame = true;
            }
         }
         else if(Boolean(this._stage))
         {
            if(this._listenedStageEnterFrame)
            {
               this._stage.removeEventListener(Event.ENTER_FRAME,this.onStageEnterFrame);
               this._listenedStageEnterFrame = false;
            }
         }
      }
      
      private function onStageEnterFrame(event:Event = null) : void
      {
         var i:int = 0;
         var L:int = 0;
         if(!this._pause)
         {
            L = int(this._aniList.length);
            for(i = L - 1; i > -1; i--)
            {
               if(!this._aniList[i].paused)
               {
                  this.__aniBuffer.push(this._aniList[i]);
               }
            }
            L = int(this.__aniBuffer.length);
            for(i = L - 1; i > -1; i--)
            {
               this.__aniBuffer[i].updateFrameFN.call();
            }
            this.__aniBuffer.length = 0;
            dispatchEvent(renderFrameEvent);
         }
      }
   }
}

