package org.engine.map
{
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.system.LoaderContext;
   import flash.utils.ByteArray;
   import org.engine.core.Scene;
   import org.engine.event.LoaderEvent;
   
   public class MapLoader extends EventDispatcher
   {
      
      private var loaderContext:LoaderContext;
      
      private var tileSize:Number;
      
      private var mapIO:MapIO;
      
      private var scene:Scene;
      
      private var path:String;
      
      private var _isLoader:Boolean;
      
      private var baloader:Loader;
      
      public function MapLoader(mapWidth:Number = 970, mapHeight:Number = 570, tileSize:Number = 20)
      {
         super();
         this.loaderContext = new LoaderContext(false);
         this.tileSize = tileSize;
         this.mapIO = new MapIO();
      }
      
      public function load(url:String) : void
      {
         if(this._isLoader)
         {
            return;
         }
         this.scene = new Scene();
         this.mapIO.loadZip(url,this.onComplement,this.porgressBack,this.parseError);
         this._isLoader = true;
      }
      
      public function porgressBack(loaded:Number, total:Number) : void
      {
         var e:LoaderEvent = new LoaderEvent(LoaderEvent.PROGRESS);
         e.bytesLoaded = loaded;
         e.bytesTotal = total;
         this.dispatchEvent(e);
      }
      
      private function onComplement(msg:String) : void
      {
         var e:LoaderEvent = null;
         var ba:ByteArray = null;
         var xml:XML = null;
         this._isLoader = false;
         if(this.mapIO.getFileCount() == 0)
         {
            e = new LoaderEvent(LoaderEvent.ERROR);
            e.scene = this.scene;
            this.dispatchEvent(e);
         }
         else
         {
            ba = this.mapIO.getFileByName("config.xml");
            xml = new XML(ba.readUTFBytes(ba.bytesAvailable));
            this.path = xml.path;
            if(xml != null)
            {
               this.scene.config = xml;
            }
            this.initbg();
         }
      }
      
      private function parseError() : void
      {
         this._isLoader = false;
         var evt:LoaderEvent = new LoaderEvent(LoaderEvent.ERROR);
         throw new Error(this.mapIO.url + "  Fzip解析出错");
      }
      
      private function initbg() : void
      {
         var ba:ByteArray = this.mapIO.getFileByName("bg.swf");
         this.baloader = new Loader();
         this.baloader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoadedBg);
         this.baloader.loadBytes(ba,this.loaderContext);
      }
      
      private function onLoadedBg(e:Event) : void
      {
         e.target.removeEventListener(Event.COMPLETE,this.onLoadedBg);
         var loader:Loader = e.target.loader as Loader;
         var w:int = 0;
         var h:int = 0;
         if(this.scene.config != null && this.scene.config.@isBig == 1)
         {
            this.scene.isScroll = true;
            w = Math.ceil(loader.width / this.tileSize);
            h = Math.ceil(loader.height / this.tileSize);
         }
         else
         {
            w = Math.ceil(970 / this.tileSize);
            h = Math.ceil(570 / this.tileSize);
         }
         this.scene.bg = loader;
         this.scene.changeGridSize(w,h,this.tileSize);
         this.scene.setBlocks(this.path);
         var evt:LoaderEvent = new LoaderEvent(LoaderEvent.COMPLEMENT);
         evt.scene = this.scene;
         this.dispatchEvent(evt);
      }
      
      public function get isLoader() : Boolean
      {
         return this._isLoader;
      }
   }
}

