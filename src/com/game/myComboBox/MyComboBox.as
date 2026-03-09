package com.game.myComboBox
{
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class MyComboBox extends Sprite
   {
      
      private var _dataprovider:Array = [];
      
      private var itemList:Array;
      
      private var itemCls:Class;
      
      private var dropClip:Sprite;
      
      private var dropClipHeight:Number;
      
      private var dropClipMaxHeight:Number = 200;
      
      private var dropClipMaxWidth:Number = 50;
      
      private var dropClipBlank:Number = 2;
      
      private var scrollBarBlank:Number = 10;
      
      private var scrollBar:ArchivesScrollBar;
      
      private var currentClip:Sprite;
      
      private var currentItem:ComboBoxItem;
      
      private var expendFlag:Boolean = false;
      
      private var currentSelectIndex:int;
      
      private var tfWidth:Number;
      
      private var tfName:String;
      
      private var bgName:String;
      
      private var btnName:String;
      
      private var _bgColor:uint;
      
      private var _bgAlpha:Number;
      
      private var bgShape:Shape;
      
      private var _currentChoose:String = "";
      
      private var _comboName:String = "";
      
      public function MyComboBox(cls:Class, itemWidth:Number, tfname:String, bgname:String, btnname:String, startindex:int = 0, maxheight:Number = 200, barblank:Number = 10, bgColor:uint = 8947848, bgAlpha:Number = 0)
      {
         super();
         this.itemList = [];
         this.tfWidth = itemWidth;
         this.tfName = tfname;
         this.bgName = bgname;
         this.btnName = btnname;
         this.dropClipMaxHeight = maxheight;
         this.scrollBarBlank = barblank;
         this._bgColor = bgColor;
         this._bgAlpha = bgAlpha;
         this.itemCls = cls;
         this.currentClip = new Sprite();
         this.addChild(this.currentClip);
         this.currentClip.x = 0;
         this.currentClip.y = 0;
      }
      
      public function set dataProvider(dat:Array) : void
      {
         var i:int = 0;
         var len:int = 0;
         var item:ComboBoxItem = null;
         var tmplist:Array = null;
         this._dataprovider = dat;
         if(Boolean(this._dataprovider) && this._dataprovider.length > 0)
         {
            i = 0;
            len = int(this._dataprovider.length);
            for(i = 0; i < len; i++)
            {
               if(i < this.itemList.length)
               {
                  item = this.itemList[i];
                  item.index = i;
                  if(this._dataprovider[i] != item.content)
                  {
                     item.content = this._dataprovider[i];
                  }
               }
               else
               {
                  item = new ComboBoxItem(this.itemCls,this.tfName,this.bgName,this.btnName,this._dataprovider[i],i,this.tfWidth);
                  this.itemList.push(item);
                  item.addEventListener(MouseEvent.CLICK,this.onClickItem);
               }
            }
            if(len < this.itemList.length)
            {
               tmplist = this.itemList.splice(len,this.itemList.length - len);
               for(i = 0; i < tmplist.length; i++)
               {
                  item = tmplist[i];
                  item.removeEventListener(MouseEvent.CLICK,this.onClickItem);
                  item.disport();
                  item = null;
               }
            }
            if(Boolean(this.dropClip))
            {
               for(i = 0; i < len; i++)
               {
                  item = this.itemList[i];
                  this.dropClip.addChild(item);
                  item.x = 0;
                  item.y = i * (item.height + this.dropClipBlank);
               }
               if(Boolean(this.scrollBar))
               {
                  this.scrollBar.resetScrollBtnPosition();
                  this.scrollBar.setTargetMask(this.dropClip);
               }
            }
            if(this.currentItem == null)
            {
               this.makeCurrentItem(0);
               this.dropClipMaxWidth = this.currentItem.width;
               this.currentClip.addEventListener(MouseEvent.CLICK,this.onClickCurrentItem);
            }
            else
            {
               this.makeCurrentItem(0);
            }
         }
      }
      
      public function get dataProvider() : Array
      {
         return this._dataprovider;
      }
      
      public function makeCurrentItem(index:int) : void
      {
         if(this.currentItem == null)
         {
            this.currentItem = new ComboBoxItem(this.itemCls,this.tfName,this.bgName,this.btnName,this._dataprovider[index],index,this.tfWidth);
            this.currentClip.addChild(this.currentItem);
            this.currentItem.x = 0;
            this.currentItem.y = 0;
         }
         else
         {
            this.currentItem.index = index;
            this.currentItem.content = this._dataprovider[index];
         }
         this.currentItem.showOrHideBtn(true);
         this.currentSelectIndex = index;
         this._currentChoose = this._dataprovider[this.currentSelectIndex];
      }
      
      public function get currentChoose() : String
      {
         return this._currentChoose;
      }
      
      public function get comboName() : String
      {
         return this._comboName;
      }
      
      public function set comboName(str:String) : void
      {
         this._comboName = str;
      }
      
      public function makeDropClip() : void
      {
         var i:int = 0;
         var len:int = 0;
         var item:ComboBoxItem = null;
         var showScrollBar:Boolean = false;
         if(this._dataprovider == null || this._dataprovider.length <= 0)
         {
            return;
         }
         this.expendFlag = true;
         if(this.dropClip == null)
         {
            this.dropClip = new Sprite();
            this.addChild(this.dropClip);
            this.dropClip.x = 0;
            this.dropClip.y = this.currentClip.height + this.dropClipBlank;
            i = 0;
            len = int(this._dataprovider.length);
            this.addEventListener(MouseEvent.ROLL_OUT,this.onMouseOutDropClip);
            for(i = 0; i < len; i++)
            {
               item = this.itemList[i];
               this.dropClip.addChild(item);
               item.x = 0;
               item.y = i * (item.height + this.dropClipBlank);
            }
            showScrollBar = this.dropClip.height > this.dropClipMaxHeight ? true : false;
            if(showScrollBar)
            {
               this.dropClipHeight = this.dropClipMaxHeight;
               this.scrollBar = new ArchivesScrollBar(new Rectangle(0,this.currentClip.height,this.dropClipMaxWidth,this.dropClipHeight),this.dropClip,"archupbtn","archdownbtn","archscrollbtn","archscbg");
               this.addChild(this.scrollBar);
               this.scrollBar.x = this.dropClipMaxWidth + this.scrollBarBlank;
               this.scrollBar.y = this.currentClip.height + this.dropClipBlank;
               this.scrollBar.updateScrollBarVisible();
            }
            else
            {
               this.dropClipHeight = this.dropClip.height;
            }
            this.bgShape = new Shape();
            this.bgShape.graphics.beginFill(this._bgColor,this._bgAlpha);
            this.bgShape.graphics.drawRect(0,0,this.width,this.currentClip.height + this.dropClipBlank + this.dropClipHeight);
            this.bgShape.graphics.endFill();
            this.addChildAt(this.bgShape,0);
         }
         this.dropClip.visible = true;
         if(Boolean(this.scrollBar))
         {
            this.scrollBar.resetScrollBtnPosition();
            this.scrollBar.visible = true;
         }
         this.bgShape.visible = true;
      }
      
      public function destroyDropClip(flag:Boolean = false) : void
      {
         var item:ComboBoxItem = null;
         if(this._dataprovider == null || this._dataprovider.length <= 0)
         {
            return;
         }
         this.expendFlag = false;
         if(flag)
         {
            this.removeEventListener(MouseEvent.ROLL_OUT,this.onMouseOutDropClip);
            if(Boolean(this.scrollBar))
            {
               this.scrollBar.dispos();
               this.removeChild(this.scrollBar);
               this.scrollBar = null;
            }
            if(Boolean(this.itemList) && this.itemList.length > 0)
            {
               for each(item in this.itemList)
               {
                  item.removeEventListener(MouseEvent.CLICK,this.onClickItem);
                  item.disport();
                  item = null;
               }
            }
            this.itemList = null;
            if(Boolean(this.currentItem))
            {
               this.currentItem.disport();
               this.currentItem = null;
            }
            if(Boolean(this.currentClip))
            {
               this.currentClip.removeEventListener(MouseEvent.CLICK,this.onClickCurrentItem);
               this.removeChild(this.currentClip);
               this.currentClip = null;
            }
            if(Boolean(this.dropClip))
            {
               this.removeChild(this.dropClip);
               this.dropClip = null;
            }
         }
         else
         {
            if(Boolean(this.dropClip))
            {
               this.dropClip.visible = false;
            }
            if(Boolean(this.scrollBar))
            {
               this.scrollBar.visible = false;
            }
            if(Boolean(this.bgShape))
            {
               this.bgShape.visible = false;
            }
         }
      }
      
      private function onClickCurrentItem(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         if(this.expendFlag)
         {
            this.destroyDropClip();
         }
         else if(Boolean(this._dataprovider) && this._dataprovider.length > 0)
         {
            this.makeDropClip();
         }
      }
      
      private function onClickItem(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         var item:ComboBoxItem = evt.currentTarget as ComboBoxItem;
         this.makeCurrentItem(item.index);
         this.destroyDropClip();
         this.dispatchEvent(new Event(Event.CHANGE));
      }
      
      private function onMouseOutDropClip(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         this.destroyDropClip();
      }
      
      public function disport() : void
      {
         this.destroyDropClip(true);
         this.expendFlag = false;
         this.currentSelectIndex = 0;
         this._dataprovider = null;
         this.dropClipBlank = 0;
         this.dropClipHeight = 0;
         this.dropClipMaxHeight = 0;
         this.dropClipMaxWidth = 0;
         this.tfWidth = 0;
         this.tfName = "";
         this.bgName = "";
         this.btnName = "";
         if(Boolean(this.bgShape))
         {
            this.removeChild(this.bgShape);
            this.bgShape = null;
         }
         this._currentChoose = "";
         this.currentSelectIndex = 0;
         this.itemCls = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
      
      public function get selectedIndex() : int
      {
         return this.currentSelectIndex;
      }
   }
}

