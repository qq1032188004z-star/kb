package com.publiccomponent.smile
{
   import com.game.locators.GameData;
   import com.game.util.ColorUtil;
   import com.game.util.HtmlUtil;
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.events.ItemClickEvent;
   import com.publiccomponent.list.ItemRender;
   import com.publiccomponent.ui.ToolTip;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.IOErrorEvent;
   import flash.net.URLRequest;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol486")]
   public class ColumnItem extends ItemRender
   {
      
      public var itemIcon:MovieClip;
      
      public var timeText:TextField;
      
      public var showTxt:TextField;
      
      private var _overEvent:ItemClickEvent;
      
      private var _outEvent:ItemClickEvent;
      
      private var loader:Loader;
      
      public function ColumnItem()
      {
         super();
         this.timeText.mouseEnabled = false;
         this.showTxt.mouseEnabled = false;
         this.buttonMode = true;
      }
      
      override public function set data(params:Object) : void
      {
         var stateStr1:String = null;
         var stateStr:String = null;
         this.timeText.text = "";
         this.showTxt.text = "";
         if(params.type != 0)
         {
            if(params.type != 1)
            {
               if(params.type == 102 || params.type == 112 || params.type == 113)
               {
                  this.showTxt.text = params.itemNum;
               }
            }
         }
         this.loader = new Loader();
         this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onIoErrorHandler);
         this.loader.load(new URLRequest(URLUtil.getSvnVer("assets/tool/" + params.itemId + ".swf")));
         this.itemIcon.addChild(this.loader);
         var desc:String = "";
         desc += HtmlUtil.getHtmlText(12,"#000000","名称: ");
         desc += HtmlUtil.getHtmlText(12,"#000000",params.name) + "\n";
         desc += HtmlUtil.getHtmlText(12,"#000000","描述: ");
         desc += HtmlUtil.getHtmlText(12,"#000000",params.desc) + "\n";
         if(params.itemId == 103014 || params.itemId == GameData.instance.playerData.effectList.hasCollectId)
         {
            stateStr1 = Boolean(params.hasOwnProperty("itemSwitch")) && params.itemSwitch == 1 ? "开启状态，点击可使用" : "关闭状态，点击可使用";
            desc += HtmlUtil.getHtmlText(12,"#FF0000",stateStr1) + "\n";
         }
         else
         {
            stateStr = Boolean(params.hasOwnProperty("itemSwitch")) && params.itemSwitch == 1 ? "开启状态，点击可关闭" : "关闭状态，点击可开启";
            desc += HtmlUtil.getHtmlText(12,"#FF0000",stateStr) + "\n";
         }
         ToolTip.BindDO(this,desc);
         if(params.itemSwitch == 1)
         {
            this.filters = null;
         }
         else
         {
            this.filters = ColorUtil.getColorMatrixFilterGray();
         }
         super.data = params;
      }
      
      override public function dispos() : void
      {
         this.filters = null;
         ToolTip.LooseDO(this);
         if(Boolean(this.loader))
         {
            if(Boolean(this.itemIcon) && this.itemIcon.contains(this.loader))
            {
               this.itemIcon.removeChild(this.loader);
            }
            this.loader.close();
            this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onIoErrorHandler);
            this.loader["unloadAndStop"]();
            this.loader = null;
         }
         super.dispos();
      }
      
      private function onIoErrorHandler(e:IOErrorEvent) : void
      {
         trace("加载错误");
      }
   }
}

