package com.game.dohko.view.item
{
   import com.game.dohko.data.ToolManager;
   import com.game.util.ToolTipStringUtil;
   import com.publiccomponent.list.ItemRender;
   import com.publiccomponent.ui.ToolTip;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class ExchangeItemBase extends ItemRender
   {
      
      private var _mc:MovieClip;
      
      private var _ico:MovieClip;
      
      private var _data:Object;
      
      public function ExchangeItemBase()
      {
         super();
      }
      
      protected function set mc(mc:MovieClip) : void
      {
         this._mc = mc;
         this.addChild(this._mc);
      }
      
      override public function set data(params:Object) : void
      {
         this._data = params;
         this._ico = ToolManager.instance.getMcByName("ExchangeItem" + this._data.id);
         this._mc.container.addChild(this._ico);
         this._mc.priceTf.text = this._data.price;
         (this._mc.priceTf as TextField).mouseEnabled = false;
         var desc:String = "";
         if(this._data.itemId == 0)
         {
            desc = this._data.name + "*" + this._data.num;
         }
         else
         {
            desc = ToolTipStringUtil.toPackTipString(this._data.itemId);
         }
         ToolTip.BindDO(this._ico,desc);
      }
      
      protected function get mc() : MovieClip
      {
         return this._mc;
      }
   }
}

