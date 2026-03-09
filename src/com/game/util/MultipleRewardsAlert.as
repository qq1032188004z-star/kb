package com.game.util
{
   import com.game.util.item.MultipleRewardsItem;
   import com.game.util.rectUtils.scroll.RectScrollBox;
   import com.publiccomponent.ui.ToolTip;
   import flash.display.DisplayObjectContainer;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol100")]
   public class MultipleRewardsAlert extends Sprite
   {
      
      public var btnClose:SimpleButton;
      
      public var rightScrollBtn:Sprite;
      
      public var rightScrollBack:Sprite;
      
      public var spBox:Sprite;
      
      private var _box:RectScrollBox;
      
      private var _objData:Object;
      
      public function MultipleRewardsAlert(params:Object, parent:DisplayObjectContainer)
      {
         super();
         this._objData = params;
         this.initView();
         this.initEvent();
         parent.addChild(this);
      }
      
      protected function initView() : void
      {
         var ary:Array = null;
         this._box = new RectScrollBox(420,235,6,false,40);
         this._box.setGap(72,64);
         this._box.scrollBar.setScrollSkin(new Sprite(),new Sprite(),this.rightScrollBtn,this.rightScrollBack);
         var arr:Array = this._objData.itemList;
         for each(ary in arr)
         {
            this._box.addDisplayObj(new MultipleRewardsItem(ary));
         }
         ToolTip.showToolTip();
         this.spBox.addChild(this._box);
      }
      
      protected function initEvent() : void
      {
         this.btnClose.addEventListener(MouseEvent.CLICK,this.disport);
      }
      
      protected function removeEvent() : void
      {
         this.btnClose.removeEventListener(MouseEvent.CLICK,this.disport);
      }
      
      public function disport(event:MouseEvent) : void
      {
         this.removeEvent();
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

