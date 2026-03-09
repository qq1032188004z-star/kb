package com.kb.components.list
{
   import fl.events.ListEvent;
   import flash.display.Sprite;
   
   public class BaseItem extends Sprite
   {
      
      public static const ITEM_SELECT_CHANGED:String = "item_select_changed";
      
      protected var _baseList:BaseList;
      
      protected var bindedData:Object;
      
      public function BaseItem()
      {
         super();
      }
      
      protected function dispacthSelectChanged() : void
      {
         if(this._baseList.dispatcher != null)
         {
            this._baseList.dispatcher.dispatchEvent(new ListEvent(ITEM_SELECT_CHANGED));
         }
      }
      
      public function set data(value:Object) : void
      {
         this.bindedData = value;
      }
      
      public function get data() : Object
      {
         return this.bindedData;
      }
      
      public function set baseList(value:BaseList) : void
      {
         this._baseList = value;
      }
   }
}

