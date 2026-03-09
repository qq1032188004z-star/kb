package com.publiccomponent.list
{
   import flash.display.Sprite;
   
   public class CustomTileList extends Sprite
   {
      
      private var _columnCount:int = 3;
      
      private var _rowCount:int = 3;
      
      private var _itemWidth:int = 100;
      
      private var _itemHeight:int = 80;
      
      private var _dataProvider:Array;
      
      private var _hgap:int = 5;
      
      private var _vgap:int = 5;
      
      private var _itemRender:Class;
      
      private var _selected:Object;
      
      private var itemRenderList:Array;
      
      public function CustomTileList(xCoord:Number = 0, yCoord:Number = 0)
      {
         super();
         this._dataProvider = [];
         this.x = xCoord;
         this.y = yCoord;
      }
      
      public function build(pColumnCount:int = 3, pRowCount:int = 3, pItemWidth:int = 100, pItemHeight:int = 80, pHgap:int = 5, pVgap:int = 5, pItemRender:Class = null) : void
      {
         this.columnCount = pColumnCount;
         this.rowCount = pRowCount;
         this.itemWidth = pItemWidth;
         this.itemHeight = pItemHeight;
         this.hgap = pHgap;
         this.vgap = pVgap;
         this.itemRender = pItemRender;
         this.createRender();
      }
      
      private function createRender() : void
      {
         var j:int = 0;
         var item:ItemRender = null;
         if(this._itemRender == null)
         {
            return;
         }
         this.itemRenderList = [];
         for(var i:int = 0; i < this.rowCount; i++)
         {
            for(j = 0; j < this.columnCount; j++)
            {
               item = new this._itemRender() as ItemRender;
               item.x = j * this.itemWidth + this.hgap * j;
               item.y = i * this.itemHeight + this.vgap * i;
               item.width = this.itemWidth == -1 ? item.width : this.itemWidth;
               item.height = this.itemHeight == -1 ? item.height : this.itemHeight;
               addChild(item);
               this.itemRenderList.push(item);
            }
         }
      }
      
      public function set selected(params:Object) : void
      {
         this._selected = params;
         this.updateItem(this._selected);
      }
      
      public function get selected() : Object
      {
         return this._selected;
      }
      
      private function updateItem(params:Object) : void
      {
         var itemRender:ItemRender = null;
         var i:int = 0;
         for each(itemRender in this.itemRenderList)
         {
            itemRender.update(params);
         }
      }
      
      public function set columnCount(count:int) : void
      {
         this._columnCount = count;
      }
      
      public function get columnCount() : int
      {
         return this._columnCount;
      }
      
      public function set rowCount(count:int) : void
      {
         this._rowCount = count;
      }
      
      public function get rowCount() : int
      {
         return this._rowCount;
      }
      
      public function set itemWidth(value:int) : void
      {
         this._itemWidth = value;
      }
      
      public function get itemWidth() : int
      {
         return this._itemWidth;
      }
      
      public function set itemHeight(value:int) : void
      {
         this._itemHeight = value;
      }
      
      public function get itemHeight() : int
      {
         return this._itemHeight;
      }
      
      public function set dataProvider(params:Array) : void
      {
         this._dataProvider = params;
         this.render();
      }
      
      public function get dataProvider() : Array
      {
         return this._dataProvider;
      }
      
      public function set hgap(value:int) : void
      {
         this._hgap = value;
      }
      
      public function get hgap() : int
      {
         return this._hgap;
      }
      
      public function set vgap(value:int) : void
      {
         this._vgap = value;
      }
      
      public function get vgap() : int
      {
         return this._vgap;
      }
      
      public function get itemRender() : Class
      {
         return this._itemRender;
      }
      
      public function set itemRender(item:Class) : void
      {
         this._itemRender = item;
      }
      
      public function render() : void
      {
         var itemRender:ItemRender = null;
         var data:Object = null;
         this.removeAll();
         if(this._itemRender == null || this.dataProvider == null)
         {
            return;
         }
         var len:int = int(this.dataProvider.length);
         var itemLenth:int = int(this.itemRenderList.length);
         var count:int = 0;
         for each(itemRender in this.itemRenderList)
         {
            if(count == len)
            {
               break;
            }
            data = this.dataProvider[count];
            itemRender.data = data;
            count++;
         }
      }
      
      private function removeAll() : void
      {
         var itemRender:ItemRender = null;
         if(this.itemRenderList == null)
         {
            return;
         }
         for each(itemRender in this.itemRenderList)
         {
            itemRender.reset();
         }
      }
      
      public function dispos() : void
      {
         var itemRender:ItemRender = null;
         if(Boolean(this.itemRenderList))
         {
            while(this.itemRenderList.length > 0)
            {
               itemRender = this.itemRenderList.shift() as ItemRender;
               itemRender.dispos();
               itemRender = null;
            }
            this.itemRenderList = null;
         }
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

