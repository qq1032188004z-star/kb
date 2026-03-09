package com.publiccomponent.ui
{
   import com.publiccomponent.URLUtil;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.utils.Dictionary;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class NameLabelLoader
   {
      
      private static var _instance:NameLabelLoader;
      
      private static const LOAD_DELAY:int = 64;
      
      private var materialDomains:Vector.<ApplicationDomain>;
      
      private var loadedUrls:Dictionary;
      
      private var loadQueue:Vector.<String>;
      
      private var callbackQueue:Vector.<LoadRequest>;
      
      private var loader:Loader;
      
      private var urlRequest:URLRequest;
      
      private var isLoading:Boolean = false;
      
      private var loadTimeoutId:int = -1;
      
      public function NameLabelLoader()
      {
         super();
         if(_instance != null)
         {
            throw new Error("NameLabelLoader is a singleton, use getInstance() instead");
         }
      }
      
      public static function getInstance() : NameLabelLoader
      {
         if(_instance == null)
         {
            _instance = new NameLabelLoader();
            _instance.initialize();
         }
         return _instance;
      }
      
      public static function get instance() : NameLabelLoader
      {
         return getInstance();
      }
      
      private function initialize() : void
      {
         this.materialDomains = new Vector.<ApplicationDomain>();
         this.loadedUrls = new Dictionary();
         this.loadQueue = new Vector.<String>();
         this.callbackQueue = new Vector.<LoadRequest>();
         this.loader = new Loader();
         this.urlRequest = new URLRequest();
         this.addLoaderListeners();
      }
      
      private function addLoaderListeners() : void
      {
         var info:* = this.loader.contentLoaderInfo;
         info.addEventListener(Event.COMPLETE,this.onLoadComplete);
         info.addEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
         info.addEventListener(ProgressEvent.PROGRESS,this.onLoadProgress);
      }
      
      public function load(url:String, callback:Function, className:String, returnClassName:Boolean = false) : void
      {
         if(callback == null || className == null)
         {
            trace("[NameLabelLoader] Invalid parameters");
            return;
         }
         var material:Object = this.getMaterialByClassName(className);
         if(material != null)
         {
            this.invokeCallback(callback,material,className,returnClassName);
            return;
         }
         var normalizedUrl:String = URLUtil.getSvnVer(url);
         var request:LoadRequest = new LoadRequest(normalizedUrl,callback,className,returnClassName);
         this.callbackQueue.push(request);
         if(!this.isUrlInQueue(normalizedUrl))
         {
            this.loadQueue.push(normalizedUrl);
         }
         this.scheduleNextLoad();
      }
      
      private function isUrlInQueue(url:String) : Boolean
      {
         return this.loadQueue.indexOf(url) != -1;
      }
      
      private function scheduleNextLoad() : void
      {
         if(this.loadQueue.length > 0 && !this.isLoading)
         {
            clearTimeout(this.loadTimeoutId);
            this.loadTimeoutId = setTimeout(this.startNextLoad,LOAD_DELAY);
         }
      }
      
      private function startNextLoad() : void
      {
         if(this.isLoading || this.loadQueue.length == 0)
         {
            return;
         }
         this.isLoading = true;
         this.urlRequest.url = this.loadQueue.shift();
         try
         {
            this.loader.load(this.urlRequest);
         }
         catch(error:Error)
         {
            trace("[NameLabelLoader] Load error:",error.message);
            handleLoadFailure();
         }
      }
      
      private function onLoadComplete(event:Event) : void
      {
         var domain:ApplicationDomain = event.currentTarget.applicationDomain;
         this.materialDomains.push(domain);
         this.loadedUrls[this.urlRequest.url] = true;
         this.processCallbacks(this.urlRequest.url,domain);
         this.handleLoadCompletion();
      }
      
      private function processCallbacks(completedUrl:String, domain:ApplicationDomain) : void
      {
         var request:LoadRequest = null;
         var material:Object = null;
         var remainingCallbacks:Vector.<LoadRequest> = new Vector.<LoadRequest>();
         for each(request in this.callbackQueue)
         {
            if(request.url == completedUrl)
            {
               material = this.createMaterialFromDomain(domain,request.className);
               this.invokeCallback(request.callback,material,request.className,request.returnClassName);
               request.dispose();
            }
            else
            {
               remainingCallbacks.push(request);
            }
         }
         this.callbackQueue = remainingCallbacks;
      }
      
      private function createMaterialFromDomain(domain:ApplicationDomain, className:String) : Object
      {
         var cls:Class = null;
         if(!domain || !className)
         {
            return null;
         }
         try
         {
            if(domain.hasDefinition(className))
            {
               cls = domain.getDefinition(className) as Class;
               return new cls();
            }
         }
         catch(error:Error)
         {
            trace("[NameLabelLoader] Error creating material:",error.message);
         }
         return null;
      }
      
      private function invokeCallback(callback:Function, material:Object, className:String, returnClassName:Boolean) : void
      {
         if(callback == null)
         {
            return;
         }
         try
         {
            if(returnClassName)
            {
               callback.call(null,material,className);
            }
            else
            {
               callback.call(null,material);
            }
         }
         catch(error:Error)
         {
            trace("[NameLabelLoader] Callback error:",error.message);
         }
      }
      
      private function onLoadError(event:IOErrorEvent) : void
      {
         trace("[NameLabelLoader] IO Error:",event.text);
         this.handleLoadFailure();
      }
      
      private function onLoadProgress(event:ProgressEvent) : void
      {
      }
      
      private function handleLoadFailure() : void
      {
         var request:LoadRequest = null;
         var failedUrl:String = this.urlRequest.url;
         var remainingCallbacks:Vector.<LoadRequest> = new Vector.<LoadRequest>();
         for each(request in this.callbackQueue)
         {
            if(request.url != failedUrl)
            {
               remainingCallbacks.push(request);
            }
            else
            {
               request.dispose();
            }
         }
         this.callbackQueue = remainingCallbacks;
         this.handleLoadCompletion();
      }
      
      private function handleLoadCompletion() : void
      {
         this.isLoading = false;
         this.scheduleNextLoad();
      }
      
      public function getMaterialByClassName(className:String) : Object
      {
         var domain:ApplicationDomain = null;
         var material:Object = null;
         if(!className || className == "")
         {
            return null;
         }
         for each(domain in this.materialDomains)
         {
            material = this.createMaterialFromDomain(domain,className);
            if(material != null)
            {
               return material;
            }
         }
         return null;
      }
      
      public function getMaterial(name:String) : Object
      {
         return this.getMaterialByClassName(name);
      }
      
      public function dispose() : void
      {
         var info:* = undefined;
         var request:LoadRequest = null;
         clearTimeout(this.loadTimeoutId);
         this.loadTimeoutId = -1;
         if(Boolean(this.loader) && Boolean(this.loader.contentLoaderInfo))
         {
            info = this.loader.contentLoaderInfo;
            info.removeEventListener(Event.COMPLETE,this.onLoadComplete);
            info.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
            info.removeEventListener(ProgressEvent.PROGRESS,this.onLoadProgress);
         }
         if(Boolean(this.callbackQueue))
         {
            for each(request in this.callbackQueue)
            {
               request.dispose();
            }
            this.callbackQueue = null;
         }
         this.materialDomains = null;
         this.loadedUrls = null;
         this.loadQueue = null;
         this.loader = null;
         this.urlRequest = null;
      }
   }
}

class LoadRequest
{
   
   public var url:String;
   
   public var callback:Function;
   
   public var className:String;
   
   public var returnClassName:Boolean;
   
   public function LoadRequest(url:String, callback:Function, className:String, returnClassName:Boolean)
   {
      super();
      this.url = url;
      this.callback = callback;
      this.className = className;
      this.returnClassName = returnClassName;
   }
   
   public function dispose() : void
   {
      this.callback = null;
      this.url = null;
      this.className = null;
   }
}
