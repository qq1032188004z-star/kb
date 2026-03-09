package com.game.modules.view.family
{
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.list.ItemRender;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLRequest;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol985")]
   public class FamilyBadgeItem extends ItemRender
   {
      
      public var packImg:MovieClip;
      
      public var yiClip:MovieClip;
      
      public var numTxt:TextField;
      
      public var bgClip:MovieClip;
      
      public var cdClip:MovieClip;
      
      private var loader:Loader;
      
      public function FamilyBadgeItem()
      {
         super();
         this.yiClip.mouseEnabled = false;
         this.yiClip.visible = false;
         this.packImg.gotoAndStop(1);
         this.numTxt.mouseEnabled = false;
         this.numTxt.visible = false;
         this.cdClip.stop();
         this.cdClip.visible = false;
         this.loader = new Loader();
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.on_Complete);
         this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.on_IOError);
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.on_removed);
      }
      
      override public function set data(params:Object) : void
      {
         var url:String = null;
         if(params.mid_id != null)
         {
            url = URLUtil.getSvnVer("assets/family/mid" + params.mid_id + ".swf");
         }
         else if(params.small_id != null)
         {
            url = URLUtil.getSvnVer("assets/family/small" + params.small_id + ".swf");
         }
         else if(params.color_id != null)
         {
            url = URLUtil.getSvnVer("assets/family/color" + params.color_id + ".swf");
         }
         this.loader.load(new URLRequest(url));
         this.buttonMode = true;
         super.data = params;
      }
      
      private function on_Complete(evt:Event) : void
      {
         this.packImg.width = 30;
         this.packImg.height = 30;
         this.packImg.x -= 20;
         this.packImg.y -= 20;
         this.bgClip = this.loader.content as MovieClip;
         this.addChild(this.bgClip);
         this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.on_Complete);
         this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.on_IOError);
         this.loader.unload();
      }
      
      private function on_IOError(evt:IOErrorEvent) : void
      {
         O.o("家族徽章加载失败~" + evt);
         this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.on_Complete);
         this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.on_IOError);
         this.loader.unload();
      }
      
      private function on_removed(evt:Event) : void
      {
         this.bgClip = null;
         this.numTxt = null;
         this.packImg = null;
         this.yiClip = null;
         this.loader.unload();
         this.loader = null;
         super.dispos();
         this.removeEventListener(Event.REMOVED_FROM_STAGE,this.on_removed);
      }
   }
}

