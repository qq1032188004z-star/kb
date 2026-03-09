package com.game.modules.view.replace
{
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.list.ItemRender;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLRequest;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol481")]
   public class ReplaceItem extends ItemRender
   {
      
      public var nameTxt:TextField;
      
      public var infoTxt:TextField;
      
      public var hpMc:MovieClip;
      
      public var loader:Loader;
      
      public var bg1:MovieClip;
      
      public var bg2:MovieClip;
      
      public var maskSpr:Sprite;
      
      public function ReplaceItem()
      {
         super();
         this.hpMc.stop();
         this.bg2.visible = false;
         this.loader = new Loader();
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoveFromstage);
      }
      
      override public function set data(params:Object) : void
      {
         this.nameTxt.text = params.name;
         this.infoTxt.text = "LV." + params.level + "   " + params.hp + "/" + params.counthp;
         var qq:int = int(params.hp / params.strength * 100);
         var ww:int = Math.floor(qq);
         this.hpMc.gotoAndStop(ww);
         try
         {
            this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.errorHandle);
            this.loader.load(new URLRequest(URLUtil.getSvnVer("assets/monsterimg/" + params.iid + ".swf")));
            this.loader.scaleX = 0.7;
            this.loader.x = 6;
            this.loader.y = 1;
            this.loader.scaleY = 0.7;
            this.buttonMode = true;
            addChild(this.loader);
            this.loader.mask = this.maskSpr;
         }
         catch(e:*)
         {
         }
         super.data = params;
      }
      
      private function errorHandle(evt:Event) : void
      {
         trace("error");
      }
      
      private function onRemoveFromstage(evt:Event) : void
      {
         this.removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemoveFromstage);
         this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.errorHandle);
         if(this.loader != null)
         {
            this.loader.unloadAndStop(false);
            this.removeChild(this.loader);
            this.loader = null;
         }
         super.dispos();
      }
   }
}

