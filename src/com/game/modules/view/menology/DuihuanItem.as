package com.game.modules.view.menology
{
   import com.game.util.HtmlUtil;
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.list.ItemRender;
   import com.publiccomponent.loading.XMLLocator;
   import com.publiccomponent.ui.ToolTip;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.net.URLRequest;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol441")]
   public class DuihuanItem extends ItemRender
   {
      
      private var loader:Loader;
      
      public function DuihuanItem()
      {
         super();
         this.buttonMode = false;
         this.loader = new Loader();
         addChild(this.loader);
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoveFromStage);
      }
      
      override public function set data(params:Object) : void
      {
         var url:String = URLUtil.getSvnVer("assets/tool/" + int(params) + ".swf");
         if(int(params) == 151)
         {
            url = URLUtil.getSvnVer("assets/monsterimg/" + int(params) + ".swf");
         }
         try
         {
            this.loader.unload();
            this.loader.load(new URLRequest(url));
         }
         catch(e:*)
         {
         }
         this.setToolTip(int(params));
         super.data = params;
      }
      
      private function onRemoveFromStage(evt:Event) : void
      {
         ToolTip.removeToolTip();
         this.removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemoveFromStage);
         this.loader.unloadAndStop(false);
         this.removeChild(this.loader);
         this.loader = null;
         super.dispos();
      }
      
      private function setToolTip(idx:int) : void
      {
         var xml:XML = null;
         var desc:String = "";
         if(idx == 151)
         {
            xml = XMLLocator.getInstance().getSprited(idx);
            if(xml != null)
            {
               desc += HtmlUtil.getHtmlText(12,"#FF0000","名称: ");
               desc += HtmlUtil.getHtmlText(12,"#000000",xml.name) + "\n";
               desc += HtmlUtil.getHtmlText(12,"#000000",xml.desc) + "\n";
            }
         }
         else
         {
            xml = XMLLocator.getInstance().getTool(idx);
            desc += HtmlUtil.getHtmlText(12,"#FF0000","名称: ");
            desc += HtmlUtil.getHtmlText(12,"#000000",xml.name) + "\n";
            desc += HtmlUtil.getHtmlText(12,"#000000",xml.desc) + "\n";
         }
         ToolTip.BindDO(this,desc);
      }
   }
}

