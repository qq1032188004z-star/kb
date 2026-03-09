package com.game.modules.archives.base
{
   import com.publiccomponent.URLUtil;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.net.URLRequest;
   import flash.utils.getTimer;
   
   public class BaseLoader extends Loader
   {
      
      public static const TOTAL_COUNT:int = 5;
      
      private var _currentCount:int;
      
      private var _url:String = "";
      
      private var _completeCallback:Function;
      
      private var _errorCallback:Function;
      
      private var _progressCallback:Function;
      
      private var _byteLoaded:uint;
      
      private var _byteTotal:uint;
      
      public function BaseLoader()
      {
         super();
         this.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoadComplete);
         this.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
         this.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.onLoadProgress);
      }
      
      public function addListener(type:String, callback:Function) : void
      {
         switch(type)
         {
            case Event.COMPLETE:
               this._completeCallback = null;
               this._completeCallback = callback;
               break;
            case IOErrorEvent.IO_ERROR:
               this._errorCallback = null;
               this._errorCallback = callback;
               break;
            case ProgressEvent.PROGRESS:
               this._progressCallback = null;
               this._progressCallback = callback;
         }
      }
      
      public function reload(url:String, broken:Boolean = false) : void
      {
         if(url == this._url && !broken)
         {
            if(this._completeCallback != null)
            {
               this._completeCallback.apply();
            }
            return;
         }
         this._url = url;
         var str:String = URLUtil.getSvnVer(url);
         if(broken)
         {
            str += getTimer() + "";
         }
         this.unloadAndStop();
         load(new URLRequest(str));
      }
      
      private function onLoadComplete(evt:Event) : void
      {
         evt.stopImmediatePropagation();
         if(this.contentLoaderInfo.bytesLoaded < this.contentLoaderInfo.bytesTotal)
         {
            --this._currentCount;
            if(this._currentCount == 0)
            {
               this.applyCallback(2);
            }
            else
            {
               this.reload(this._url,true);
            }
            return;
         }
         this.applyCallback(1);
      }
      
      private function onLoadError(evt:IOErrorEvent) : void
      {
         evt.stopImmediatePropagation();
         --this._currentCount;
         if(this._currentCount > 0)
         {
            this.reload(this._url,true);
         }
         else
         {
            this.applyCallback(2);
         }
      }
      
      private function onLoadProgress(evt:ProgressEvent) : void
      {
         evt.stopImmediatePropagation();
         this._byteLoaded = this.contentLoaderInfo.bytesLoaded;
         this._byteTotal = this.contentLoaderInfo.bytesTotal;
         this.applyCallback(3);
      }
      
      private function releaseCallback() : void
      {
         this._completeCallback = null;
         this._errorCallback = null;
         this._progressCallback = null;
      }
      
      private function applyCallback(type:int) : void
      {
         switch(type)
         {
            case 1:
               if(this._completeCallback != null)
               {
                  this._completeCallback.apply();
               }
               break;
            case 2:
               if(this._errorCallback != null)
               {
                  this._errorCallback.apply();
               }
               break;
            case 3:
               if(this._progressCallback != null)
               {
                  this._progressCallback.apply();
               }
         }
      }
      
      public function get byteLoaded() : uint
      {
         return this._byteLoaded;
      }
      
      public function get byteTotal() : uint
      {
         return this._byteTotal;
      }
      
      public function releaseLoader() : void
      {
         unloadAndStop();
      }
      
      public function disport() : void
      {
         unloadAndStop();
         this.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoadComplete);
         this.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,this.onLoadProgress);
         this.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
         this.releaseCallback();
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

