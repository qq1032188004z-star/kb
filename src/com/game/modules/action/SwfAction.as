package com.game.modules.action
{
   import com.publiccomponent.URLUtil;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLRequest;
   
   public class SwfAction
   {
      
      private var complementHandler:Function;
      
      private var specialAction:Function;
      
      private var specialFrame:int;
      
      private var data:Object;
      
      private var movieClip:MovieClip;
      
      private var xCoord:Number;
      
      private var yCoord:Number;
      
      private var parent:DisplayObjectContainer;
      
      private var loader:Loader;
      
      private var callback:Function = null;
      
      private var loadedcallback:Function = null;
      
      private var isRemove:Boolean;
      
      public function SwfAction(loadedcallback:Function = null)
      {
         super();
         this.loadedcallback = loadedcallback;
         this.loader = new Loader();
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoaded);
         this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onIoerror);
      }
      
      public function loadAndPlay(parent:DisplayObjectContainer, url:String, xCoord:Number, yCoord:Number, complement:Function = null, data:Object = null, specialAction:Function = null, specialFrame:int = 0, callback:Function = null, isRemove:Boolean = true) : void
      {
         this.parent = parent;
         this.xCoord = xCoord;
         this.yCoord = yCoord;
         this.complementHandler = complement;
         this.callback = callback;
         this.data = data;
         this.specialAction = specialAction;
         this.specialFrame = specialFrame;
         this.isRemove = isRemove;
         this.loader.load(new URLRequest(URLUtil.getSvnVer(url)));
      }
      
      private function onIoerror(e:IOErrorEvent) : void
      {
      }
      
      private function onLoaded(evt:Event) : void
      {
         this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoaded);
         if(this.loadedcallback is Function)
         {
            this.loadedcallback();
            this.loadedcallback = null;
         }
         this.movieClip = this.loader.content["getChildAt"](0) as MovieClip;
         this.movieClip.mouseEnabled = false;
         this.movieClip.mouseChildren = false;
         this.movieClip.x = this.xCoord;
         this.movieClip.y = this.yCoord;
         if(Boolean(this.parent))
         {
            this.parent.addChildAt(this.movieClip,this.parent.numChildren);
            if(this.specialFrame != 0)
            {
               this.movieClip.addFrameScript(this.specialFrame - 1,null);
               this.movieClip.addFrameScript(this.specialFrame - 1,this.onSpecial);
            }
            if(this.callback != null)
            {
               this.movieClip.addFrameScript(this.movieClip.totalFrames - 1,null);
               this.movieClip.addFrameScript(this.movieClip.totalFrames - 1,this.runCallBack);
            }
            else if(this.isRemove)
            {
               this.movieClip.addFrameScript(this.movieClip.totalFrames - 1,null);
               this.movieClip.addFrameScript(this.movieClip.totalFrames - 1,this.remove);
            }
            this.movieClip.gotoAndPlay(1);
         }
      }
      
      private function onSpecial() : void
      {
         if(Boolean(this.movieClip))
         {
            this.movieClip.addFrameScript(this.specialFrame - 1,null);
            if(this.specialAction != null)
            {
               this.specialAction(this.data);
            }
         }
      }
      
      private function runCallBack() : void
      {
         if(Boolean(this.movieClip))
         {
            this.movieClip.addFrameScript(this.movieClip.totalFrames - 1,null);
            if(this.callback != null)
            {
               this.callback(this.data);
               this.callback = null;
            }
         }
      }
      
      private function remove() : void
      {
         if(Boolean(this.movieClip))
         {
            this.movieClip.addFrameScript(this.movieClip.totalFrames - 1,null);
            if(this.specialFrame != 0)
            {
               this.movieClip.addFrameScript(this.specialFrame - 1,null);
            }
            this.movieClip.stop();
            if(Boolean(this.movieClip.parent))
            {
               this.movieClip.parent.removeChild(this.movieClip);
            }
            else
            {
               this.movieClip.visible = false;
            }
         }
         this.loader.unloadAndStop(false);
         if(this.complementHandler != null)
         {
            if(Boolean(this.data))
            {
               this.complementHandler(this.data);
            }
            else
            {
               this.complementHandler();
            }
         }
      }
      
      public function dispos() : void
      {
         if(Boolean(this.movieClip))
         {
            this.movieClip.addFrameScript(this.movieClip.totalFrames - 1,null);
            if(this.specialFrame != 0)
            {
               this.movieClip.addFrameScript(this.specialFrame - 1,null);
            }
            this.movieClip.stop();
            if(Boolean(this.movieClip.parent))
            {
               this.movieClip.parent.removeChild(this.movieClip);
            }
            else
            {
               this.movieClip.visible = false;
            }
         }
         if(Boolean(this.loader))
         {
            this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoaded);
            this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onIoerror);
            this.loader.unloadAndStop(false);
         }
         this.loadedcallback = null;
      }
   }
}

