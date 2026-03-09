package com.game.Tools
{
   import com.game.util.NewTipManager;
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.loading.XMLLocator;
   import com.publiccomponent.loading.data.BufInfoTypeData;
   import com.publiccomponent.loading.data.SiteBuffTypeData;
   import com.publiccomponent.tips.ToolTipView;
   import flash.display.Bitmap;
   import flash.display.Loader;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   
   public class SiteBuffIcon extends Sprite
   {
      
      private var _tipView:ToolTipView;
      
      private var _data:SiteBuffTypeData;
      
      private var _loader:Loader;
      
      private var _bitmap:Bitmap;
      
      protected var _tipDesc:String;
      
      public function SiteBuffIcon()
      {
         super();
         this._loader = new Loader();
         this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoadComplete);
         addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOverBufIcon);
         addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOutBufIcon);
      }
      
      public function setSite(id:int) : void
      {
         var request:URLRequest = null;
         if(this._data == null || this._data.id != id)
         {
            this._data = XMLLocator.getInstance().getSiteInfo(id);
            if(this._data == null)
            {
               O.o("SiteBuff.xml没有配置！！！" + id);
               return;
            }
            request = new URLRequest(URLUtil.getSvnVer(this._data.s_url));
            this._loader.load(request);
         }
      }
      
      public function get data() : SiteBuffTypeData
      {
         return this._data;
      }
      
      protected function onMouseOverBufIcon(event:MouseEvent) : void
      {
      }
      
      public function get tipView() : ToolTipView
      {
         if(this._tipView == null)
         {
            this._tipView = new ToolTipView();
         }
         return this._tipView;
      }
      
      override public function set visible(value:Boolean) : void
      {
         super.visible = value;
         if(!value)
         {
            this.onMouseOutBufIcon(null);
         }
      }
      
      protected function onMouseOutBufIcon(event:MouseEvent) : void
      {
      }
      
      public function update(td:BufInfoTypeData) : void
      {
         if(this._loader == null || td == null)
         {
            return;
         }
         this._loader.load(new URLRequest(td.url));
      }
      
      private function onLoadComplete(event:Event) : void
      {
         this._bitmap = event.target.content as Bitmap;
         addChild(this._bitmap);
      }
      
      public function dispose() : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,this.onMouseOverBufIcon);
         removeEventListener(MouseEvent.MOUSE_OUT,this.onMouseOutBufIcon);
         if(Boolean(this._bitmap))
         {
            if(Boolean(this._bitmap.bitmapData))
            {
               this._bitmap.bitmapData.dispose();
            }
            this._bitmap = null;
         }
         if(Boolean(this._loader) && Boolean(this._loader.contentLoaderInfo))
         {
            this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoadComplete);
            if(Boolean(this._loader.loaderInfo))
            {
               this._loader.unloadAndStop(true);
            }
            else
            {
               this._loader.unload();
            }
         }
         while(numChildren > 0)
         {
            removeChildAt(0);
         }
      }
      
      public function set tipDesc(value:String) : void
      {
         this._tipDesc = value;
         this.tipView.setTipsInfo("名称：" + this._data.name + "\n" + "效果：" + this._tipDesc);
         NewTipManager.getInstance().addToolTip(this,this.tipView);
      }
   }
}

