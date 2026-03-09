package com.game.modules.view.item
{
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.list.ItemRender;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLRequest;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol340")]
   public class CinemaItem extends ItemRender
   {
      
      public var mc:MovieClip;
      
      private var Clip:MovieClip;
      
      private var loader:Loader;
      
      public function CinemaItem()
      {
         super();
         this.mc.mouseEnabled = false;
         this.loader = new Loader();
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.on_Complete);
         this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.on_IOError);
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.on_removed);
      }
      
      override public function set data(params:Object) : void
      {
         var url:String = null;
         url = URLUtil.getSvnVer("assets/films/" + params + ".swf");
         this.loader.load(new URLRequest(url));
         this.buttonMode = true;
         super.data = params;
      }
      
      private function on_Complete(evt:Event) : void
      {
         if(this.loader == null)
         {
            return;
         }
         this.Clip = this.loader.content as MovieClip;
         if(Boolean(this.Clip))
         {
            this.Clip.x = -75;
            this.Clip.y = -75;
            this.addChild(this.Clip);
         }
         this.loader.unloadAndStop(false);
         this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.on_Complete);
         this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.on_IOError);
      }
      
      private function on_IOError(evt:IOErrorEvent) : void
      {
         O.o("家族徽章加载失败~",evt);
         this.loader.unloadAndStop(false);
         this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.on_Complete);
         this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.on_IOError);
      }
      
      private function on_removed(evt:Event) : void
      {
         this.mc = null;
         if(this.Clip != null && this.contains(this.Clip))
         {
            this.removeChild(this.Clip);
         }
         this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.on_Complete);
         this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.on_IOError);
         this.loader.unload();
         this.loader = null;
         super.dispos();
         this.removeEventListener(Event.REMOVED_FROM_STAGE,this.on_removed);
      }
   }
}

