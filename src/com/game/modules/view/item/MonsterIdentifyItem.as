package com.game.modules.view.item
{
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.list.ItemRender;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLRequest;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol452")]
   public class MonsterIdentifyItem extends ItemRender
   {
      
      public var nameTxt:TextField;
      
      public var infoTxt:TextField;
      
      public var loader:Loader;
      
      public var bg:MovieClip;
      
      public function MonsterIdentifyItem()
      {
         super();
         this.bg.hpMc.gotoAndStop(1);
         this.bg.gotoAndStop(1);
         this.loader = new Loader();
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoveFromstage);
      }
      
      override public function set data(params:Object) : void
      {
         this.nameTxt.text = params.name;
         this.infoTxt.text = "LV." + params.level + "   " + params.hp + "/" + params.counthp;
         var qq:int = int(params.hp / params.strength * 100);
         var ww:int = Math.floor(qq);
         this.bg.hpMc.gotoAndStop(ww);
         try
         {
            this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.errorHandle);
            this.loader.load(new URLRequest(URLUtil.getSvnVer("assets/monsterimg/" + params.iid + ".swf")));
            this.loader.scaleX = 0.5;
            this.loader.x = -57;
            this.loader.y = -45;
            this.loader.scaleY = 0.5;
            this.buttonMode = true;
            addChild(this.loader);
         }
         catch(e:*)
         {
         }
         super.data = params;
      }
      
      private function errorHandle(evt:Event) : void
      {
         O.o("MonsterIdentifyItem - errorHandle");
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

