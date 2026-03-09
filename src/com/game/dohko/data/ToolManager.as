package com.game.dohko.data
{
   import com.publiccomponent.URLUtil;
   import flash.display.BitmapData;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   
   public class ToolManager
   {
      
      private static var _instance:ToolManager;
      
      private var _loader:Loader;
      
      private var _resUrl:String;
      
      private var _successCallBack:Function;
      
      private var _domain:ApplicationDomain;
      
      public function ToolManager(c:PrivateClass)
      {
         super();
         if(c != null)
         {
            this._loader = new Loader();
            this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onCompleteHandler);
            this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onIoErrorHandler);
            return;
         }
         throw new Error("请通过.instance获取实例");
      }
      
      public static function get instance() : ToolManager
      {
         if(_instance == null)
         {
            _instance = new ToolManager(new PrivateClass());
         }
         return _instance;
      }
      
      public static function destroyStatic() : void
      {
         if(Boolean(_instance))
         {
            _instance.dispos();
         }
         _instance = null;
      }
      
      private function onCompleteHandler(evt:Event) : void
      {
         this._domain = evt.currentTarget.applicationDomain as ApplicationDomain;
         if(this._successCallBack != null)
         {
            this._successCallBack();
         }
      }
      
      private function onIoErrorHandler(evt:IOErrorEvent) : void
      {
         this.dispos();
      }
      
      public function load(url:String, callBack:Function) : void
      {
         this._resUrl = URLUtil.getSvnVer(url);
         this._successCallBack = callBack;
         this._loader.load(new URLRequest(this._resUrl));
      }
      
      public function getMcByName(name:String) : MovieClip
      {
         var cls:Class = null;
         if(this._domain != null && this._domain.hasDefinition(name))
         {
            cls = this._domain.getDefinition(name) as Class;
            return new cls() as MovieClip;
         }
         return null;
      }
      
      public function getBitmapData(name:String) : BitmapData
      {
         var cls:Class = null;
         if(this._domain != null && this._domain.hasDefinition(name))
         {
            cls = this._domain.getDefinition(name) as Class;
            return new cls() as BitmapData;
         }
         return null;
      }
      
      private function dispos() : void
      {
         if(Boolean(this._loader))
         {
            this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onCompleteHandler);
            this._loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onIoErrorHandler);
            this._loader.unload();
         }
         this._loader = null;
         this._domain = null;
      }
   }
}

class PrivateClass
{
   
   public function PrivateClass()
   {
      super();
   }
}
