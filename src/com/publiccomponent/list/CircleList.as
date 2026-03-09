package com.publiccomponent.list
{
   import flash.display.Sprite;
   
   public class CircleList extends Sprite
   {
      
      private var _columnCount:int = 3;
      
      private var _rowCount:int = 3;
      
      private var _itemWidth:int = 104;
      
      private var _itemHeight:int = 104;
      
      private var _dataProvider:Array;
      
      private var _hgap:int = 5;
      
      private var _vgap:int = 5;
      
      private var _itemRender:Class;
      
      private var arr:Array = [{
         "x":40,
         "y":23
      },{
         "x":135,
         "y":33
      },{
         "x":240,
         "y":-5
      },{
         "x":345,
         "y":-3
      },{
         "x":430,
         "y":0
      },{
         "x":535,
         "y":0
      }];
      
      private var arrShade:Array = [{
         "x":42,
         "y":40
      },{
         "x":-14,
         "y":75
      },{
         "x":-14,
         "y":75
      },{
         "x":-14,
         "y":75
      },{
         "x":-14,
         "y":75
      },{
         "x":-14,
         "y":75
      }];
      
      private var arr2:Array = [{
         "x":40,
         "y":-10
      },{
         "x":135,
         "y":0
      },{
         "x":240,
         "y":-5
      },{
         "x":345,
         "y":-3
      },{
         "x":430,
         "y":0
      },{
         "x":535,
         "y":0
      }];
      
      public function CircleList(xCoord:Number = 0, yCoord:Number = 0)
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
         var count:int = 0;
         var i:int = 0;
         var j:int = 0;
         var data:Object = null;
         var item:ItemRender = null;
         if(this._itemRender == null || this.dataProvider == null)
         {
            return;
         }
         this.removeAll();
         var len:int = int(this.dataProvider.length);
         loop0:
         for(i = 0; i < this.rowCount; i++)
         {
            for(j = 0; j < this.columnCount; j++)
            {
               if(count == len)
               {
                  break loop0;
               }
               data = this.dataProvider[count];
               item = new this._itemRender() as ItemRender;
               if(j == 0)
               {
                  item.x = j * this.itemWidth + this.hgap * j;
                  item.y = i * this.itemHeight + this.vgap * i - 15;
               }
               else
               {
                  item.x = j * this.itemWidth + this.hgap * j;
                  item.y = i * this.itemHeight + this.vgap * i;
               }
               if(j == 0)
               {
                  item.width = this.itemWidth + 10;
                  item.height = this.itemHeight + 10;
               }
               else
               {
                  item.width = this.itemWidth;
                  item.height = this.itemHeight;
               }
               data.shadeX = this.arrShade[i].x;
               data.shadeY = this.arrShade[i].y;
               item.data = data;
               this.addChild(item);
               count++;
            }
         }
      }
      
      public function removeAll() : void
      {
         var num:int = this.numChildren;
         for(var i:int = 0; i < num; i++)
         {
            this.removeChildAt(0);
         }
      }
   }
}

