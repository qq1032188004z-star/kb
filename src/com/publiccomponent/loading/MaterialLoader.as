package com.publiccomponent.loading
{
   import com.publiccomponent.URLUtil;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.utils.ByteArray;
   import org.zip.FZip;
   
   public class MaterialLoader extends EventDispatcher
   {
      
      private var processBack3:Function;
      
      private var lib:MaterialLib;
      
      private var successBack:Function;
      
      private var loader:Loader;
      
      private var url2:String;
      
      private var ioerrorBack2:Function;
      
      private var urlList:Array = [];
      
      private var showTxt:String;
      
      private var loadCount:int;
      
      private var urlLoader:URLLoader;
      
      private var successBack2:Function;
      
      private var successBack3:Function;
      
      private var url:String;
      
      private var fzipURL:String;
      
      private var fzip:FZip;
      
      private var processBack2:Function;
      
      private var processBack:Function;
      
      private var loader2:Loader;
      
      public function MaterialLoader()
      {
         super();
         this.lib = MaterialLib.getInstance();
         this.loader = new Loader();
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoadComplement);
         this.loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.onProgress);
         this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onerror);
      }
      
      private function onProgress2(evt:ProgressEvent) : void
      {
         if(this.processBack2 != null)
         {
            this.processBack2.apply(null,[this.showTxt,evt.bytesLoaded,evt.bytesTotal]);
         }
      }
      
      private function onProgress3(evt:ProgressEvent) : void
      {
         if(this.processBack3 != null)
         {
            this.processBack3.apply(null,[this.showTxt,evt.bytesLoaded,evt.bytesTotal]);
         }
      }
      
      public function onerror(e:IOErrorEvent) : void
      {
         trace(e);
      }
      
      public function close() : void
      {
      }
      
      private function onLoadedMain(evt:Event) : void
      {
         evt = evt;
         GreenLoading.loading.visible = false;
         this.urlLoader.removeEventListener(ProgressEvent.PROGRESS,this.onProgress2);
         this.urlLoader.removeEventListener(Event.COMPLETE,this.onLoadedMain);
         var buf:* = this.urlLoader.data as ByteArray;
         try
         {
            buf.uncompress();
         }
         catch(e:Error)
         {
         }
         buf.position = 0;
         this.loader2 = new Loader();
         this.loader2.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onModuleReady);
         var lc:* = new LoaderContext(false,ApplicationDomain.currentDomain);
         this.loader2.loadBytes(buf,lc);
      }
      
      private function onProgress(evt:ProgressEvent) : void
      {
         if(this.processBack != null)
         {
            this.processBack.apply(null,[this.showTxt,evt.bytesLoaded,evt.bytesTotal]);
         }
      }
      
      private function onModuleReady(evt:Event) : void
      {
         GreenLoading.loading.visible = false;
         this.loader2.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onModuleReady);
         this.loader2.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,this.onProgress2);
         this.loader2.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.ioLoadError);
         if(this.successBack2 != null)
         {
            this.successBack2.apply(null,[this.loader2]);
         }
      }
      
      public function loadSWF(urlList:Array, successBack:Function, processBack:Function) : void
      {
         this.loadCount = 5;
         this.urlList = urlList;
         this.successBack = successBack;
         this.processBack = processBack;
         this.load();
      }
      
      public function loadMain(showTxt:String, url:String, successBack:Function, processBack:Function) : void
      {
         this.url2 = url;
         this.loadCount = 5;
         this.showTxt = showTxt;
         this.successBack2 = successBack;
         this.processBack2 = processBack;
         this.urlLoader = new URLLoader();
         this.urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
         this.urlLoader.addEventListener(ProgressEvent.PROGRESS,this.onProgress2);
         this.urlLoader.addEventListener(Event.COMPLETE,this.onLoadedMain);
         this.urlLoader.load(new URLRequest(url));
      }
      
      private function ioLoadError(evt:IOErrorEvent) : void
      {
         if(this.loadCount > 0)
         {
            --this.loadCount;
            this.loader.load(new URLRequest(this.url2));
         }
         else if(this.ioerrorBack2 != null)
         {
            this.ioerrorBack2();
         }
      }
      
      public function loadXML(showTxt:String, url:String, successBack:Function, processBack:Function) : void
      {
         this.fzipURL = url;
         this.loadCount = 5;
         this.showTxt = showTxt;
         this.successBack3 = successBack;
         this.processBack3 = processBack;
         this.fzip = new FZip();
         this.fzip.addEventListener(Event.COMPLETE,this.onFileLoaded);
         this.fzip.addEventListener(ProgressEvent.PROGRESS,this.onProgress3);
         this.fzip.load(new URLRequest(this.fzipURL));
      }
      
      public function unLoaderSwf() : void
      {
         if(Boolean(this.loader2))
         {
            this.loader2.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onModuleReady);
            this.loader2.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,this.onProgress2);
            this.loader2.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.ioLoadError);
         }
         this.loader2 = null;
      }
      
      private function onFileLoaded(evt:Event) : void
      {
         GreenLoading.loading.visible = false;
         this.fzip.removeEventListener(Event.COMPLETE,this.onFileLoaded);
         this.fzip.removeEventListener(ProgressEvent.PROGRESS,this.onProgress3);
         this.anlysisZip();
      }
      
      private function load() : void
      {
         var params:Object = null;
         if(this.urlList.length != 0)
         {
            params = this.urlList.shift() as Object;
            this.url = URLUtil.getSvnVer(params.url);
            this.showTxt = params.currentLabel;
            this.loader.load(new URLRequest(this.url));
         }
         else
         {
            if(this.successBack != null)
            {
               this.successBack.apply();
            }
            GreenLoading.loading.visible = false;
         }
      }
      
      private function onLoadComplement(evt:Event) : void
      {
         this.lib.push(this.url,evt.currentTarget.applicationDomain);
         this.loader.unload();
         this.load();
      }
      
      public function loadModule(showTxt:String, url:String, successBack:Function, processBack:Function, ioErrorCallBack:Function = null) : void
      {
         this.url2 = url;
         this.loadCount = 5;
         this.showTxt = showTxt;
         this.successBack2 = successBack;
         this.processBack2 = processBack;
         this.ioerrorBack2 = ioErrorCallBack;
         this.loader2 = new Loader();
         this.loader2.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onModuleReady);
         this.loader2.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.onProgress2);
         this.loader2.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.ioLoadError);
         this.loader2.load(new URLRequest(this.url2));
      }
      
      private function anlysisZip() : void
      {
         XMLLocator.getInstance().bufInfo = new XML(this.fzip.getFileByName("bufInfo.xml").getContentAsString());
         XMLLocator.getInstance().siteBuff = new XML(this.fzip.getFileByName("siteBuff.xml").getContentAsString());
         XMLLocator.getInstance().siteBuffDesc = new XML(this.fzip.getFileByName("siteBuff_desc.xml").getContentAsString());
         XMLLocator.getInstance().dailyTask = new XML(this.fzip.getFileByName("dailytask.xml").getContentAsString());
         XMLLocator.getInstance().errorInfo = new XML(this.fzip.getFileByName("errorInfo.xml").getContentAsString());
         XMLLocator.getInstance().map = new XML(this.fzip.getFileByName("map.xml").getContentAsString());
         XMLLocator.getInstance().npc = new XML(this.fzip.getFileByName("npc.xml").getContentAsString());
         XMLLocator.getInstance().npcdialog = new XML(this.fzip.getFileByName("npcdialog.xml").getContentAsString());
         XMLLocator.getInstance().npctransform = new XML(this.fzip.getFileByName("npctransform.xml").getContentAsString());
         XMLLocator.getInstance().skill = new XML(this.fzip.getFileByName("skill.xml").getContentAsString());
         XMLLocator.getInstance().sprite = new XML(this.fzip.getFileByName("sprite.xml").getContentAsString());
         XMLLocator.getInstance().taskInfo = new XML(this.fzip.getFileByName("taskinfo.xml").getContentAsString());
         XMLLocator.getInstance().tool = new XML(this.fzip.getFileByName("tool.xml").getContentAsString());
         XMLLocator.getInstance().nature = new XML(this.fzip.getFileByName("monsternature.xml").getContentAsString());
         this.successBack3.apply();
         this.fzip.close();
      }
   }
}

