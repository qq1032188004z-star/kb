package com.game.util
{
   import flash.system.ApplicationDomain;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   
   public class PoolObject
   {
      
      private static var _instance:PoolObject;
      
      public var encrypeToolFun:Function;
      
      private var _poolDic:Dictionary;
      
      private var _app:ApplicationDomain;
      
      public function PoolObject()
      {
         super();
         this._poolDic = new Dictionary();
      }
      
      public static function get instance() : PoolObject
      {
         if(_instance == null)
         {
            _instance = new PoolObject();
         }
         return _instance;
      }
      
      public function encrypeTool(ba:ByteArray) : ByteArray
      {
         return this.encrypeToolFun(ba);
      }
      
      public function set appDomain(app:ApplicationDomain) : void
      {
         this._app = app;
      }
      
      public function get appDomain() : ApplicationDomain
      {
         return this._app;
      }
      
      public function getObjByClsPath(clsPath:String) : Object
      {
         var obj:Object = null;
         var cls:Class = null;
         try
         {
            cls = this._app.getDefinition(clsPath) as Class;
            obj = new cls();
         }
         catch(error:Error)
         {
            trace(error);
         }
         return obj;
      }
      
      public function pushObject(obj:Object) : void
      {
         var cls:Class = null;
         var objList:Array = null;
         try
         {
            cls = obj.constructor as Class;
            if(Boolean(cls))
            {
               objList = this.getObjListByCls(cls);
               objList.push(obj);
            }
         }
         catch(err:Error)
         {
            trace(err.message);
         }
      }
      
      private function getObjListByCls(cls:Class) : Array
      {
         if(!this._poolDic[cls])
         {
            this._poolDic[cls] = [];
         }
         return this._poolDic[cls];
      }
      
      public function getObjectByCls(cls:Class, params:Object = null) : Object
      {
         var objList:Array = this.getObjListByCls(cls);
         if(objList == null || objList.length == 0)
         {
            if(Boolean(params))
            {
               return new cls(params);
            }
            return new cls();
         }
         return objList.pop();
      }
      
      public function clearPool() : void
      {
         var objList:Array = null;
         var key:Object = null;
         for(key in this._poolDic)
         {
            objList = this._poolDic[key];
            if(Boolean(objList) && objList.length > 0)
            {
               this.releaseObjList(objList);
            }
            delete this._poolDic[key];
         }
      }
      
      private function releaseObjList(objList:Array) : void
      {
         var item:Object = null;
         var len:int = int(objList.length);
         while(len > 0)
         {
            item = objList.pop();
            if(item.hasOwnProperty("dispose"))
            {
               item["dispose"]();
            }
            item = null;
            len--;
         }
      }
      
      public function delObjListByCls(cls:Class) : void
      {
      }
   }
}

