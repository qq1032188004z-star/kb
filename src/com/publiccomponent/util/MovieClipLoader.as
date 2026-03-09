package com.publiccomponent.util
{
   import com.publiccomponent.URLUtil;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.net.URLRequest;
   
   public class MovieClipLoader
   {
      
      public static var instance:MovieClipLoader = new MovieClipLoader();
      
      private var loader:Loader;
      
      private var callBack:Function;
      
      public function MovieClipLoader()
      {
         super();
         this.loader = new Loader();
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoadComplement);
      }
      
      public function load(url:String, callBack:Function) : void
      {
         this.callBack = callBack;
         this.loader.load(new URLRequest(URLUtil.getSvnVer(url)));
      }
      
      private function onLoadComplement(evt:Event) : void
      {
         this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoadComplement);
         if(this.callBack != null)
         {
            this.callBack.apply(null,[this.loader.content as MovieClip]);
         }
      }
   }
}

