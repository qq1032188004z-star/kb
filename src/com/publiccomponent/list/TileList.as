package com.publiccomponent.list
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.system.ApplicationDomain;
   
   public class TileList extends Sprite
   {
      
      private var _columnCount:int = 3;
      
      private var _rowCount:int = 3;
      
      private var _itemWidth:int = 100;
      
      private var _itemHeight:int = 80;
      
      private var _dataProvider:Array;
      
      private var _xmlDataProvide:XMLList;
      
      private var _hgap:int = 5;
      
      private var _vgap:int = 5;
      
      private var _itemRender:Class;
      
      private var _selected:Object;
      
      private var _application:ApplicationDomain;
      
      public function TileList(xCoord:Number = 0, yCoord:Number = 0)
      {
         super();
         this._dataProvider = [];
         this.x = xCoord;
         this.y = yCoord;
      }
      
      public function build(pColumnCount:int = 3, pRowCount:int = 3, pItemWidth:int = 100, pItemHeight:int = 80, pVgap:int = 5, pHgap:int = 5, pItemRender:Class = null, app:ApplicationDomain = null) : void
      {
         this._application = app;
         this.columnCount = pColumnCount;
         this.rowCount = pRowCount;
         this.itemWidth = pItemWidth;
         this.itemHeight = pItemHeight;
         this.hgap = pVgap;
         this.vgap = pHgap;
         this.itemRender = pItemRender;
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
         var display:DisplayObject = null;
         var i:int = 0;
         while(i < this.numChildren)
         {
            display = this.getChildAt(i);
            if(display is ItemRender)
            {
               (display as ItemRender).update(params);
            }
            i++;
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
      
      public function set xmlDataProvider(xmllist:XMLList) : void
      {
         this._xmlDataProvide = xmllist;
         this.rendXmllist();
      }
      
      public function set reverseDataProvider(params:Array) : void
      {
         this._dataProvider = params;
         this.reverseRender();
      }
      
      public function get dataProvider() : Array
      {
         return this._dataProvider;
      }
      
      public function get xmlDataProvider() : XMLList
      {
         return this._xmlDataProvide;
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
               if(Boolean(data) && (!data.hasOwnProperty("userId") || Boolean(data.hasOwnProperty("userId")) && data.userId > 0))
               {
                  item = this.getNewItem();
                  item.x = j * this.itemWidth + this.hgap * j;
                  item.y = i * this.itemHeight + this.vgap * i;
                  item.width = this.itemWidth == -1 ? item.width : this.itemWidth;
                  item.height = this.itemHeight == -1 ? item.height : this.itemHeight;
                  item.data = data;
                  this.addChild(item);
                  count++;
               }
               else
               {
                  count++;
               }
            }
         }
      }
      
      public function rendXmllist() : void
      {
         var count:int = 0;
         var i:int = 0;
         var j:int = 0;
         var data:XML = null;
         var item:ItemRender = null;
         if(this._itemRender == null || this.xmlDataProvider == null)
         {
            return;
         }
         this.removeAll();
         var len:int = int(this.xmlDataProvider.length());
         loop0:
         for(i = 0; i < this.rowCount; i++)
         {
            for(j = 0; j < this.columnCount; j++)
            {
               if(count == len)
               {
                  break loop0;
               }
               data = this.xmlDataProvider[count];
               if(Boolean(data) && (!data.hasOwnProperty("userId") || data.hasOwnProperty("userId") && data.userId > 0))
               {
                  item = this.getNewItem();
                  item.x = j * this.itemWidth + this.hgap * j;
                  item.y = i * this.itemHeight + this.vgap * i;
                  item.width = this.itemWidth == -1 ? item.width : this.itemWidth;
                  item.height = this.itemHeight == -1 ? item.height : this.itemHeight;
                  item.data = data;
                  this.addChild(item);
                  count++;
               }
               else
               {
                  count++;
               }
            }
         }
      }
      
      private function getNewItem() : ItemRender
      {
         var item:ItemRender = new this._itemRender() as ItemRender;
         if(Boolean(this._application))
         {
            item.initSkin(this.getInstanceByClass(item.skinName) as Sprite);
         }
         return item;
      }
      
      public function reverseRender() : void
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
               item = this.getNewItem();
               item.x = j * this.itemWidth - this.hgap * j;
               item.y = -(i * this.itemHeight - this.vgap * i);
               item.width = this.itemWidth == -1 ? item.width : this.itemWidth;
               item.height = this.itemHeight == -1 ? item.height : this.itemHeight;
               item.data = data;
               this.addChild(item);
               count++;
            }
         }
      }
      
      public function setData(list:Array) : void
      {
         var item:ItemRender = null;
         for(var i:int = 0; i < numChildren; i++)
         {
            item = this.getChildAt(i) as ItemRender;
            try
            {
               item.data = list[i];
            }
            catch(e:*)
            {
            }
         }
      }
      
      private function removeAll() : void
      {
         var num:int = this.numChildren;
         for(var i:int = 0; i < num; i++)
         {
            this.removeChildAt(0);
         }
      }
      
      public function dispos() : void
      {
         this.removeAll();
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
      
      public function getInstanceByClass(className:String) : Object
      {
         return new (this._application.getDefinition(className) as Class)();
      }
   }
}

