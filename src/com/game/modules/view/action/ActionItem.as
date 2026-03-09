package com.game.modules.view.action
{
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.list.ItemRender;
   import com.publiccomponent.ui.ToolTip;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.net.URLRequest;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol550")]
   public class ActionItem extends ItemRender
   {
      
      public var numTxt:TextField;
      
      private var loader:Loader;
      
      public var keyTxt:TextField;
      
      public var bgClip:MovieClip;
      
      public var maskClip:MovieClip;
      
      public function ActionItem()
      {
         super();
         this.keyTxt.visible = false;
         this.bgClip.visible = false;
         this.maskClip.stop();
         this.maskClip.visible = false;
         this.buttonMode = true;
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoveFromStage);
         this.loader = new Loader();
         addChild(this.loader);
      }
      
      override public function set data(params:Object) : void
      {
         super.data = params;
         var url:String = "";
         url = "assets/action/actionIcon" + params.id + ".swf";
         url = URLUtil.getSvnVer(url);
         ToolTip.setDOInfo(this,params.tip);
         this.loader.load(new URLRequest(url));
      }
      
      private function onRemoveFromStage(evt:Event) : void
      {
         ToolTip.LooseDO(this);
         this.removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemoveFromStage);
         if(Boolean(this.loader))
         {
            this.loader.filters = [];
            this.loader.unloadAndStop(false);
            if(Boolean(this.loader.parent))
            {
               this.loader.parent.removeChild(this.loader);
            }
         }
         this.loader = null;
         super.dispos();
      }
   }
}

