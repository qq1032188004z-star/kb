package com.publiccomponent.ui
{
   import com.publiccomponent.URLUtil;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLRequest;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol113")]
   public class FaceSprit extends Sprite
   {
      
      private static const ASSET_PATH_PREFIX:String = "assets/faceAmi/face";
      
      private static const ASSET_PATH_SUFFIX:String = ".swf";
      
      private static const DISPLAY_DURATION:int = 10000;
      
      private static const CLIP_OFFSET_X:Number = 2.5;
      
      private static const CLIP_OFFSET_Y:Number = 3.5;
      
      private var loader:Loader;
      
      private var faceClip:MovieClip;
      
      private var hideTimeoutId:int = -1;
      
      private var isLoading:Boolean = false;
      
      private var isDisposed:Boolean = false;
      
      public function FaceSprit(xCoord:int = 0, yCoord:int = 0)
      {
         super();
         this.initialize(xCoord,yCoord);
      }
      
      private function initialize(xCoord:int, yCoord:int) : void
      {
         this.x = xCoord;
         this.y = yCoord;
         this.visible = false;
         this.mouseEnabled = false;
         this.mouseChildren = false;
         this.loader = new Loader();
      }
      
      public function setFace(faceId:int) : void
      {
         if(this.isDisposed)
         {
            return;
         }
         this.cancelHideTimer();
         this.cleanupCurrentFace();
         this.visible = true;
         this.loadFaceAsset(faceId);
      }
      
      private function loadFaceAsset(faceId:int) : void
      {
         var assetUrl:String;
         var urlRequest:URLRequest;
         if(this.isLoading)
         {
            return;
         }
         assetUrl = this.buildAssetUrl(faceId);
         urlRequest = new URLRequest(assetUrl);
         this.addLoaderListeners();
         try
         {
            this.isLoading = true;
            this.loader.load(urlRequest);
         }
         catch(error:Error)
         {
            handleLoadError();
         }
      }
      
      private function buildAssetUrl(faceId:int) : String
      {
         var path:String = ASSET_PATH_PREFIX + faceId + ASSET_PATH_SUFFIX;
         return URLUtil.getSvnVer(path);
      }
      
      private function addLoaderListeners() : void
      {
         if(!this.loader || !this.loader.contentLoaderInfo)
         {
            return;
         }
         var loaderInfo:* = this.loader.contentLoaderInfo;
         loaderInfo.addEventListener(Event.COMPLETE,this.onLoadComplete);
         loaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
      }
      
      private function removeLoaderListeners() : void
      {
         if(!this.loader || !this.loader.contentLoaderInfo)
         {
            return;
         }
         var loaderInfo:* = this.loader.contentLoaderInfo;
         loaderInfo.removeEventListener(Event.COMPLETE,this.onLoadComplete);
         loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
      }
      
      private function onLoadComplete(event:Event) : void
      {
         this.isLoading = false;
         this.removeLoaderListeners();
         if(this.isDisposed)
         {
            return;
         }
         var content:MovieClip = this.loader.content as MovieClip;
         if(Boolean(content))
         {
            this.setupFaceClip(content);
            this.scheduleHide();
         }
         else
         {
            this.handleLoadError();
         }
      }
      
      private function setupFaceClip(content:MovieClip) : void
      {
         this.faceClip = content;
         this.faceClip.mouseEnabled = false;
         this.faceClip.x = CLIP_OFFSET_X;
         this.faceClip.y = CLIP_OFFSET_Y;
         this.faceClip.gotoAndPlay(1);
         addChild(this.faceClip);
      }
      
      private function onLoadError(event:IOErrorEvent) : void
      {
         this.handleLoadError();
      }
      
      private function handleLoadError() : void
      {
         this.isLoading = false;
         this.removeLoaderListeners();
         this.visible = false;
      }
      
      private function scheduleHide() : void
      {
         this.cancelHideTimer();
         this.hideTimeoutId = setTimeout(this.hide,DISPLAY_DURATION);
      }
      
      private function cancelHideTimer() : void
      {
         if(this.hideTimeoutId != -1)
         {
            clearTimeout(this.hideTimeoutId);
            this.hideTimeoutId = -1;
         }
      }
      
      public function clear() : void
      {
         this.hide();
      }
      
      private function hide() : void
      {
         this.cancelHideTimer();
         this.cleanupCurrentFace();
         this.removeFromParent();
      }
      
      private function cleanupCurrentFace() : void
      {
         if(this.faceClip != null)
         {
            if(this.contains(this.faceClip))
            {
               this.faceClip.stop();
               this.removeChild(this.faceClip);
            }
            this.faceClip = null;
         }
      }
      
      private function removeFromParent() : void
      {
         if(Boolean(this.parent) && this.parent.contains(this))
         {
            this.parent.removeChild(this);
         }
      }
      
      public function dispose() : void
      {
         if(this.isDisposed)
         {
            return;
         }
         this.isDisposed = true;
         this.cancelHideTimer();
         this.cleanupCurrentFace();
         this.cleanupLoader();
         this.removeFromParent();
      }
      
      private function cleanupLoader() : void
      {
         if(Boolean(this.loader))
         {
            this.removeLoaderListeners();
            this.loader.unloadAndStop();
            this.loader = null;
         }
      }
      
      public function dispos() : void
      {
         this.dispose();
      }
      
      public function get disposed() : Boolean
      {
         return this.isDisposed;
      }
   }
}

