package com.game.modules.view.item
{
   import com.game.util.NewTipManager;
   import com.publiccomponent.list.ItemRender;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.filters.ColorMatrixFilter;
   import flash.net.URLRequest;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol858")]
   public class BossItem extends ItemRender
   {
      
      public var packImg:MovieClip;
      
      public var yiClip:MovieClip;
      
      public var numTxt:TextField;
      
      public var bgClip:MovieClip;
      
      public var cdClip:MovieClip;
      
      private var loader:Loader;
      
      public function BossItem()
      {
         super();
         this.yiClip.visible = false;
         this.numTxt.visible = false;
         this.packImg.gotoAndStop(1);
         this.cdClip.stop();
         this.cdClip.visible = false;
         this.loader = new Loader();
         addChild(this.loader);
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoveFromStage);
         super.closeListener();
      }
      
      override public function set data(params:Object) : void
      {
         super.data = params;
         NewTipManager.getInstance().addToolTip(this,params.desc);
         this.loader.load(new URLRequest("assets/monsterimg/" + int(params.id) + ".swf"));
         if(params.flag == 1)
         {
            this.filters = null;
         }
         else
         {
            this.filters = [new ColorMatrixFilter([0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0])];
         }
      }
      
      private function onRemoveFromStage(evt:Event) : void
      {
         NewTipManager.getInstance().removeToolTip(this);
         this.removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemoveFromStage);
         if(Boolean(this.loader))
         {
            this.loader.unloadAndStop(false);
         }
         if(Boolean(this.loader.parent))
         {
            this.loader.parent.removeChild(this.loader);
         }
      }
   }
}

