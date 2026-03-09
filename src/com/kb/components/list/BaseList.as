package com.kb.components.list
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.EventDispatcher;
   
   public class BaseList extends Sprite
   {
      
      protected var _dataSource:Array;
      
      private var listItems:Array;
      
      public var scroll_up:DisplayObject;
      
      public var scroll_down:DisplayObject;
      
      private var listStyle:ListStyle;
      
      private var clsItem:Class;
      
      public var scroll_bar:DisplayObject;
      
      public var dispatcher:EventDispatcher;
      
      private var scrollbar:ScrollBar;
      
      public var scroll_bg:DisplayObject;
      
      public function BaseList(classItem:Class, style:ListStyle, dispatcher:EventDispatcher = null)
      {
         super();
         if(classItem == null)
         {
            throw new Error("The definition of list item is null.");
         }
         if(style == null)
         {
            throw new Error("The list style is null.");
         }
         this.clsItem = classItem;
         this.listStyle = style;
         this.dispatcher = dispatcher;
         this.scrollbar = new ScrollBar(this.scroll_bg,this.scroll_up,this.scroll_down,this.scroll_bar);
         addChild(this.scrollbar);
         addEventListener(ScrollBar.SCROLL_CHANGED,this.onScrollChanged,false,0,true);
         this.listItems = new Array();
         this.onInitialized();
      }
      
      private function onScrollChanged(evt:BaseListEvent) : void
      {
         var item:BaseItem = null;
         var index:int = 0;
         var fromIndex:int = int(evt.data);
         var i:int = fromIndex;
         while(i < this._dataSource.length)
         {
            item = this.listItems[index] as BaseItem;
            if(item != null)
            {
               item.data = this._dataSource[i];
            }
            index++;
            i++;
         }
      }
      
      public function set dataSource(ds:Array) : void
      {
         var existedItem:BaseItem = null;
         var count:int = 0;
         var item:BaseItem = null;
         var i:int = 0;
         this.scrollbar.showScroolBar(false);
         if(ds == null || ds.length == 0)
         {
            return;
         }
         this._dataSource = ds;
         for each(existedItem in this.listItems)
         {
            if(contains(existedItem))
            {
               removeChild(existedItem);
            }
         }
         this.listItems = new Array();
         count = ds.length < this.listStyle.pageCount ? int(ds.length) : this.listStyle.pageCount;
         var yFrom:int = this.listStyle.item_beginY;
         while(i < count)
         {
            item = new this.clsItem() as BaseItem;
            item.baseList = this;
            item.x = this.listStyle.item_x;
            item.y = yFrom;
            item.data = this._dataSource[i];
            yFrom += item.height + this.listStyle.item_interval;
            addChild(item);
            this.listItems.push(item);
            i++;
         }
         if(ds.length > this.listStyle.pageCount)
         {
            this.scrollbar.setPageInfo(ds.length,this.listStyle.pageCount);
            this.scrollbar.showScroolBar(true);
            setChildIndex(this.scrollbar,numChildren - 1);
         }
      }
      
      public function disport() : void
      {
         var i:int = 0;
         removeChild(this.scrollbar);
         var l:int = this.numChildren;
         while(i < l)
         {
            this.removeChildAt(0);
            i++;
         }
      }
      
      public function get dataSource() : Array
      {
         return this._dataSource;
      }
      
      public function get selectedData() : Array
      {
         return new Array();
      }
      
      protected function onInitialized() : void
      {
      }
   }
}

