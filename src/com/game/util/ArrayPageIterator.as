package com.game.util
{
   public class ArrayPageIterator extends ArrayIterator
   {
      
      private var _pageLength:int = 0;
      
      public function ArrayPageIterator(data:Array, page:int)
      {
         super(data);
         this._pageLength = page;
      }
      
      public function get pageLength() : int
      {
         return this._pageLength;
      }
      
      public function set pageLength(value:int) : void
      {
         this._pageLength = value;
      }
      
      public function get totalPageLength() : int
      {
         return Math.ceil(_length / this.pageLength);
      }
      
      public function set currentPage(page:int) : void
      {
         if(page <= 0)
         {
            index = 0;
         }
         else if(page >= this.totalPageLength - 1)
         {
            index = (this.totalPageLength - 1) * this.pageLength;
         }
         else
         {
            index = (page - 1) * this.pageLength;
         }
      }
      
      public function get currentPage() : int
      {
         var page:Number = Math.floor(index / this.pageLength);
         if(_length < 1)
         {
            return 0;
         }
         return page + 1;
      }
      
      public function hasNextPage() : Boolean
      {
         return _index + this._pageLength < _length;
      }
      
      public function nextPage() : Array
      {
         index += this.pageLength;
         return this.curentPageList();
      }
      
      public function hasFrontPage() : Boolean
      {
         return _index > 0;
      }
      
      public function frontPage() : Array
      {
         if(index >= this.pageLength)
         {
            index -= this.pageLength;
         }
         else
         {
            index = 0;
         }
         return this.curentPageList();
      }
      
      public function curentPageList() : Array
      {
         var next:Array = [];
         for(var i:int = index; i < _length; i++)
         {
            if(i - index >= this.pageLength)
            {
               return next;
            }
            next.push(_list[i]);
         }
         return next;
      }
   }
}

