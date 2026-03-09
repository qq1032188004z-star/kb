package com.game.icon
{
   import com.publiccomponent.URLUtil;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   import flash.utils.Dictionary;
   
   public class IconLoaderProxy
   {
      
      public var loaderMaxCount:int = 6;
      
      private var size:int = 0;
      
      private var _freeLoaderList:Array = [];
      
      private var _loaderCount:int = 0;
      
      private var _loaderWaitingList:Array = [];
      
      private var _resourceDic:Dictionary;
      
      private var _resourceWaitingDic:Dictionary;
      
      public function IconLoaderProxy()
      {
         super();
         this._resourceDic = new Dictionary();
         this._resourceWaitingDic = new Dictionary();
      }
      
      protected function formatPath(path:String) : String
      {
         return URLUtil.getSvnVer(path);
      }
      
      public function loadBitmap(bitmap:IconBitMap) : IconBitMap
      {
         var taskList:Array = null;
         var path:String = bitmap.iconPath;
         if(Boolean(this._resourceDic[path]))
         {
            bitmap.bitmapData = this._resourceDic[path];
         }
         else if(Boolean(this._resourceWaitingDic[path]))
         {
            taskList = this._resourceWaitingDic[path] as Array;
            taskList.push(bitmap);
         }
         else
         {
            taskList = [];
            taskList.push(bitmap);
            this._resourceWaitingDic[path] = taskList;
            this.load(path);
         }
         return bitmap;
      }
      
      private function getFreeLoader() : Loader
      {
         if(this._freeLoaderList.length > 0)
         {
            return this._freeLoaderList.pop();
         }
         if(this._loaderCount < this.loaderMaxCount)
         {
            ++this._loaderCount;
            return new Loader();
         }
         return null;
      }
      
      private function load(path:String) : void
      {
         if(path == null || path.length < 1)
         {
            return;
         }
         var loader:Loader = this.getFreeLoader();
         if(loader == null)
         {
            this._loaderWaitingList.push(path);
         }
         else
         {
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onTaskComplete);
            loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
            loader.name = path;
            loader.load(new URLRequest(this.formatPath(path)));
         }
      }
      
      public function cancelTask(icon:IconBitMap) : void
      {
         var index:int = 0;
         var list:Array = this._resourceWaitingDic[icon.iconPath] as Array;
         if(Boolean(list))
         {
            if(list.length == 1 && list[0] == icon)
            {
               delete this._resourceWaitingDic[icon.iconPath];
               index = int(this._loaderWaitingList.indexOf(icon.iconPath));
               if(index != -1)
               {
                  this._loaderWaitingList.splice(index,1);
               }
            }
         }
      }
      
      private function onTaskComplete(evt:Event) : void
      {
         var data:IconBitMapData = null;
         var bitmapList:Array = null;
         var bitmap:IconBitMap = null;
         var loader:Loader = evt.target.loader as Loader;
         var path:String = loader.name;
         if(this._resourceWaitingDic[path] != null)
         {
            data = this.getDisplayBitmapdata(loader);
            bitmapList = this._resourceWaitingDic[path];
            for each(bitmap in bitmapList)
            {
               if(bitmap.iconPath == path)
               {
                  bitmap.bitmapData = data;
               }
            }
            this._resourceDic[path] = data;
            ++this.size;
            delete this._resourceWaitingDic[path];
         }
         this.realseLoader(loader);
         this.nextTask();
      }
      
      private function realseLoader(loader:Loader) : void
      {
         if(Boolean(loader))
         {
            loader.unload();
            loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onTaskComplete);
            loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
            this._freeLoaderList.push(loader);
         }
      }
      
      private function onLoadError(evt:IOErrorEvent) : void
      {
         var loader:Loader = evt.target.loader as Loader;
         if(loader != null)
         {
            loader.unloadAndStop(false);
            loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onTaskComplete);
            loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
            this._freeLoaderList.push(loader);
         }
         this.nextTask();
      }
      
      private function nextTask() : void
      {
         if(this._loaderWaitingList.length > 0)
         {
            this.load(this._loaderWaitingList.shift());
         }
      }
      
      private function getDisplayBitmapdata(display:DisplayObject) : IconBitMapData
      {
         var drawRect:Rectangle = display.getRect(display);
         var matrix:Matrix = new Matrix();
         matrix.tx = -drawRect.x;
         matrix.ty = -drawRect.y;
         var data:IconBitMapData = new IconBitMapData(drawRect.width,drawRect.height,true,0);
         data._dx = drawRect.x;
         data._dy = drawRect.y;
         data.draw(display,matrix);
         return data;
      }
      
      public function realseCache() : void
      {
         var cacheItem:IconBitMapData = null;
         var key:String = null;
         for(key in this._resourceDic)
         {
            cacheItem = this._resourceDic[key] as IconBitMapData;
            if(Boolean(cacheItem) && cacheItem.canDispose())
            {
               cacheItem.dispose();
               delete this._resourceDic[key];
               --this.size;
            }
         }
         trace("icon 缓存资源释放结束，缓存还有",this.size,"个资源");
      }
   }
}

