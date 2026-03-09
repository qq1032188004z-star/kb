package com.game.dohko.view.item
{
   import com.game.dohko.data.ToolManager;
   import com.game.util.ToolTipStringUtil;
   import com.publiccomponent.list.ItemRender;
   import com.publiccomponent.ui.ToolTip;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class ResultAwardItemBase extends ItemRender
   {
      
      private var _mc:MovieClip;
      
      private var _ico:MovieClip;
      
      private var _data:Object;
      
      public function ResultAwardItemBase()
      {
         super();
      }
      
      protected function set mc(mc:MovieClip) : void
      {
         this._mc = mc;
         this.addChild(this._mc);
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoveFromStage);
      }
      
      protected function get mc() : MovieClip
      {
         return this._mc;
      }
      
      override public function set data(params:Object) : void
      {
         this._data = params;
         this._ico = ToolManager.instance.getMcByName("ResultAward" + this._data.index);
         this._mc.container.addChild(this._ico);
         this._mc.numTf.text = String(this._data.num);
         if(this._data.num == 1)
         {
            this._mc.numTf.visible = false;
         }
         var desc:String = "";
         if(this._data.itemId == 0)
         {
            desc = this._data.name + "*" + this._data.num;
         }
         else
         {
            desc = ToolTipStringUtil.toPackTipString(this._data.itemId);
         }
         ToolTip.BindDO(this._mc,desc);
      }
      
      private function onRemoveFromStage(evt:Event) : void
      {
         this.removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemoveFromStage);
         if(Boolean(this._mc))
         {
            ToolTip.LooseDO(this._mc);
         }
         if(Boolean(this._ico))
         {
            if(Boolean(this._ico.parent))
            {
               this._ico.parent.removeChild(this._ico);
            }
         }
         this._ico = null;
      }
   }
}

