package com.game.modules.view.exchange
{
   import com.game.util.ColorUtil;
   import com.game.util.HtmlUtil;
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.list.ItemRender;
   import com.publiccomponent.ui.ToolTip;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.net.URLRequest;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol985")]
   public class ExchangeItem extends ItemRender
   {
      
      public var packImg:MovieClip;
      
      public var numTxt:TextField;
      
      public var bgClip:MovieClip;
      
      public var yiClip:MovieClip;
      
      public var cdClip:MovieClip;
      
      private var loader:Loader;
      
      public var params:Object = {};
      
      public function ExchangeItem()
      {
         super();
         if(this.yiClip != null)
         {
            this.yiClip.visible = false;
         }
         this.packImg.gotoAndStop(1);
         this.cdClip.stop();
         this.cdClip.visible = false;
         this.loader = new Loader();
         this.numTxt.text = "";
         addChild(this.loader);
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoveFromStage);
      }
      
      private function onRemoveFromStage(evt:Event) : void
      {
         this.removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemoveFromStage);
         this.loader.unload();
         this.removeChild(this.loader);
      }
      
      public function setCount(count:int) : void
      {
         if(count == 0)
         {
            this.filters = ColorUtil.getColorMatrixFilterGray();
            data.id = 0;
         }
         else
         {
            this.filters = [];
            data.count = count;
         }
      }
      
      override public function set data(params:Object) : void
      {
         if(params == null)
         {
            return;
         }
         this.params = params;
         super.data = params;
         var url:String = URLUtil.getSvnVer("assets/tool/" + params.id + ".swf");
         this.loader.load(new URLRequest(url));
         this.setToolTip();
      }
      
      private function setToolTip() : void
      {
         var desc:String = "";
         if(data != null && data.name != null)
         {
            desc += HtmlUtil.getHtmlText(12,"#FF0000","名称: ");
            desc += HtmlUtil.getHtmlText(12,"#000000",data.name + "") + "\n";
            desc += HtmlUtil.getHtmlText(12,"#000000",data.desc + "") + "\n";
            desc += HtmlUtil.getHtmlText(12,"#FF0000","剩余个数: ");
            desc += HtmlUtil.getHtmlText(12,"#000000",data.count) + "\n";
         }
         ToolTip.BindDO(this.loader,desc);
      }
      
      public function setScale() : void
      {
         this.loader.scaleX = 1.6;
         this.loader.scaleY = 1.6;
         this.loader.x = -18;
         this.loader.y = -35;
      }
   }
}

