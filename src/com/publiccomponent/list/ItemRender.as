package com.publiccomponent.list
{
   import com.publiccomponent.events.ItemClickEvent;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class ItemRender extends MovieClip
   {
      
      private var _data:Object = {};
      
      public var skinName:String;
      
      public function ItemRender()
      {
         super();
         this.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
      }
      
      public function dispos() : void
      {
         this.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
      }
      
      public function closeListener() : void
      {
         this.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
      }
      
      public function set data(params:Object) : void
      {
         this._data = params;
      }
      
      public function get data() : Object
      {
         return this._data;
      }
      
      public function update(params:Object = null) : void
      {
      }
      
      public function reset() : void
      {
      }
      
      private function onMouseDown(evt:MouseEvent) : void
      {
         this.dispatchEvent(new ItemClickEvent(ItemClickEvent.ITEMCLICKEVENT,this.data));
      }
      
      public function initSkin(sp:Sprite) : void
      {
      }
   }
}

