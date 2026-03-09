package com.game.myComboBox
{
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   
   public class ComboBoxItem extends Sprite
   {
      
      private var item:Sprite;
      
      private var _index:int = -1;
      
      private var _tfName:String;
      
      private var _bgName:String;
      
      private var _btnName:String;
      
      private var _width:Number;
      
      private var highlightFilter:GlowFilter = new GlowFilter(16776960,0.75,3,3,10);
      
      private var _content:String = "";
      
      public function ComboBoxItem(cls:Class, tfname:String, bgname:String, btnname:String, str:String, index:int, mywidth:Number)
      {
         super();
         this._bgName = bgname;
         this._btnName = btnname;
         this._tfName = tfname;
         this._width = mywidth;
         this.cacheAsBitmap = true;
         this.item = new cls() as Sprite;
         this.item.cacheAsBitmap = true;
         this.addChild(this.item);
         this.item.x = 0;
         this.item.y = 0;
         this._content = str;
         this.item[this._tfName].text = str;
         this._index = index;
         this.buttonMode = true;
         this.item.buttonMode = true;
         this.item[this._bgName].stop();
         this.item[this._btnName].visible = false;
         this.addEventListener(MouseEvent.ROLL_OVER,this.onMouseOver);
         this.addEventListener(MouseEvent.ROLL_OUT,this.onMouseOut);
         this.item[this._tfName].width = this._width;
         this.item[this._bgName].width = this._width + 36;
         this.item[this._btnName].x = this.item[this._bgName].width - 27;
      }
      
      public function get index() : int
      {
         return this._index;
      }
      
      public function set index(id:int) : void
      {
         this._index = id;
      }
      
      public function set content(str:String) : void
      {
         this._content = str;
         this.item[this._tfName].text = str;
      }
      
      public function get content() : String
      {
         return this._content;
      }
      
      private function onMouseOver(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         this.filters = [this.highlightFilter];
         this.item[this._bgName].gotoAndStop(2);
      }
      
      private function onMouseOut(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         this.filters = [];
         this.item[this._bgName].gotoAndStop(1);
      }
      
      public function showOrHideBtn(flag:Boolean) : void
      {
         this.item[this._btnName].visible = flag;
      }
      
      public function disport() : void
      {
         this._index = -1;
         this.removeEventListener(MouseEvent.ROLL_OVER,this.onMouseOver);
         this.removeEventListener(MouseEvent.ROLL_OUT,this.onMouseOut);
         this.filters = [];
         if(Boolean(this.item))
         {
            this.removeChild(this.item);
            this.item = null;
         }
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

