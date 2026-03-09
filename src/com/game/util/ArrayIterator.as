package com.game.util
{
   public class ArrayIterator
   {
      
      protected var _index:int = 0;
      
      protected var _length:int;
      
      protected var _list:Array;
      
      public function ArrayIterator(data:Array)
      {
         super();
         this.list = data;
      }
      
      public function set list(value:Array) : void
      {
         this._list = value;
         if(this._list == null)
         {
            this._length = 0;
         }
         else
         {
            this._length = this._list.length;
         }
         this._index = 0;
      }
      
      public function get list() : Array
      {
         return this._list == null ? [] : this._list;
      }
      
      public function len() : int
      {
         return this._length;
      }
      
      public function get index() : int
      {
         return this._index;
      }
      
      public function set index(value:int) : void
      {
         if(value <= 0)
         {
            this._index = 0;
         }
         else if(value >= this._length - 1)
         {
            this._index = this._length - 1;
         }
         else
         {
            this._index = value;
         }
      }
      
      public function hasFront() : Boolean
      {
         return this._index > 0;
      }
      
      public function front() : Object
      {
         return this._list[--this._index];
      }
      
      public function current() : Object
      {
         return this._list[this._index];
      }
      
      public function hasNext() : Boolean
      {
         return this._index < this._length - 1;
      }
      
      public function next() : Object
      {
         return this._list[++this._index];
      }
      
      public function reset() : void
      {
         this._index = 0;
      }
   }
}

