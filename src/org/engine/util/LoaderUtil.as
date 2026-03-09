package org.engine.util
{
   import flash.display.Loader;
   import flash.events.Event;
   import flash.net.URLRequest;
   
   public class LoaderUtil
   {
      
      private var loader:Loader;
      
      private var callBack:Function;
      
      public function LoaderUtil()
      {
         super();
      }
      
      public function load(url:String, callBack:Function) : void
      {
         this.callBack = callBack;
         this.loader = new Loader();
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoadComplement);
         this.loader.load(new URLRequest(url));
      }
      
      private function onLoadComplement(evt:Event) : void
      {
         this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoadComplement);
         this.loader.cacheAsBitmap = true;
         this.callBack.apply(null,[this.loader]);
      }
      
      public function dispos() : void
      {
         if(Boolean(this.loader))
         {
            this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoadComplement);
            this.loader.unload();
         }
         this.loader = null;
      }
   }
}

