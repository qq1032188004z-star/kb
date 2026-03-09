package com.publiccomponent.loading
{
   import com.publiccomponent.URLUtil;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.system.LoaderContext;
   
   public class Hload extends EventDispatcher implements HIload
   {
      
      public var timeline:int;
      
      public var loadMaxTimes:int = 3;
      
      public var loadcontext:LoaderContext;
      
      public var timerecoder:int;
      
      public var loadtimes:int = 0;
      
      public var extendsver:String = "";
      
      private var _url:String;
      
      public var loaderbytes:int;
      
      private var _loadinfo:Object;
      
      public function Hload(target:IEventDispatcher = null)
      {
         super(target);
      }
      
      public function checkLoadCondiction() : void
      {
      }
      
      public function set loadinfo(value:Object) : void
      {
         this._loadinfo = value;
      }
      
      public function needReload() : Boolean
      {
         if(this.timerecoder < this.loaderbytes)
         {
            this.timerecoder = this.loaderbytes;
            return false;
         }
         return true;
      }
      
      public function get loadinfo() : Object
      {
         return this._loadinfo;
      }
      
      public function set url(value:String) : void
      {
         this._url = URLUtil.getSvnVer(value);
         this.exeload();
      }
      
      public function reload() : void
      {
      }
      
      public function get url() : String
      {
         return this._url;
      }
      
      public function exeload() : void
      {
      }
   }
}

