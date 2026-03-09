package com.game.modules.view.magic
{
   import com.game.util.ColorUtil;
   import com.publiccomponent.list.ItemRender;
   import com.publiccomponent.ui.ToolTip;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.net.URLRequest;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol550")]
   public class MagicUseItem extends ItemRender
   {
      
      public var numTxt:TextField;
      
      public var keyTxt:TextField;
      
      public var bgClip:MovieClip;
      
      public var maskClip:MovieClip;
      
      private var loader:Loader;
      
      public function MagicUseItem()
      {
         super();
         this.buttonMode = true;
         this.numTxt.mouseEnabled = false;
         this.keyTxt.mouseEnabled = false;
         this.bgClip.mouseEnabled = false;
         this.bgClip.visible = false;
         this.bgClip.x += 5;
         this.bgClip.y += 10;
         this.keyTxt.x += 5;
         this.keyTxt.y += 10;
         this.keyTxt.visible = false;
         this.maskClip.gotoAndStop(this.maskClip.totalFrames);
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoveFromStage);
         this.loader = new Loader();
         addChildAt(this.loader,0);
      }
      
      override public function set data(params:Object) : void
      {
         if(params.num != -1 && params.num != 0)
         {
            this.numTxt.text = params.num + "";
         }
         if(params.num == 0 || params.state == 0)
         {
            this.loader.filters = ColorUtil.getColorMatrixFilterGray();
         }
         else if(params.num > 0 && params.state == 1)
         {
            this.loader.filters = [];
         }
         var url:String = "";
         if(params.type == 1)
         {
            this.bgClip.visible = true;
            this.keyTxt.visible = true;
            this.keyTxt.text = params.index;
            url = "assets/magic/action" + params.id + ".swf";
         }
         else
         {
            url = "assets/magic/change" + params.id + ".swf";
         }
         ToolTip.setDOInfo(this,params.tip);
         this.loader.load(new URLRequest(url));
         params.isInMask = false;
         super.data = params;
      }
      
      public function updateMagicNum() : void
      {
         if(super.data.num <= 0)
         {
            this.numTxt.text = "";
            return;
         }
         if(super.data.num > 0)
         {
            --super.data.num;
            this.numTxt.text = super.data.num + "";
         }
      }
      
      public function startCount() : void
      {
         this.buttonMode = false;
         super.data.isInMask = true;
         this.maskClip.addFrameScript(this.maskClip.totalFrames - 1,null);
         this.maskClip.addFrameScript(this.maskClip.totalFrames - 1,this.stopMask);
         this.maskClip.gotoAndPlay(1);
      }
      
      private function stopMask() : void
      {
         super.data.isInMask = false;
         this.buttonMode = true;
         this.maskClip.gotoAndStop(this.maskClip.totalFrames);
         this.maskClip.addFrameScript(this.maskClip.totalFrames - 1,null);
      }
      
      private function onRemoveFromStage(evt:Event) : void
      {
         this.maskClip.stop();
         this.maskClip.addFrameScript(this.maskClip.totalFrames - 1,null);
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

