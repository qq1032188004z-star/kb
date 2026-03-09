package com.game.Tools
{
   import flash.events.EventDispatcher;
   
   public class TurnPage extends EventDispatcher
   {
      
      protected var _currentPage:int = 1;
      
      protected var _len:int = 0;
      
      protected var _pageSize:int = 1;
      
      protected var _maxPage:int = 1;
      
      protected var _beginIndex:int = 0;
      
      protected var _endIndex:int = 0;
      
      protected var _currentIndex:int = 0;
      
      public function TurnPage(pageSize:int = 1)
      {
         super();
         this._pageSize = pageSize;
      }
      
      public function get pageSize() : int
      {
         return this._pageSize;
      }
      
      public function set pageSize(value:int) : void
      {
         this._pageSize = value;
      }
      
      public function get currentIndex() : int
      {
         return this._currentIndex;
      }
      
      public function resetCurrentIndex(value:int) : void
      {
         var teamCurPage:int = int(value / this._pageSize) + 1;
         teamCurPage = teamCurPage > this._maxPage ? this._maxPage : teamCurPage;
         if(teamCurPage == 0)
         {
            if(this._currentPage != 1)
            {
               this.beginIndex = 0;
            }
         }
         else if(teamCurPage != this._currentPage)
         {
            this.currentPage = teamCurPage;
         }
         this._currentIndex = value;
         if(this._currentIndex >= this._len - 1)
         {
            this._currentIndex = this._len - 1;
         }
         else if(this._currentIndex <= 0)
         {
            this._currentIndex = 0;
         }
         this.setEndIndex();
      }
      
      public function set currentIndex(value:int) : void
      {
         var teamCurPage:int = 0;
         this._currentIndex = value;
         if(this._currentIndex >= this._len - 1)
         {
            this._currentIndex = this._len - 1;
         }
         else if(this._currentIndex <= 0)
         {
            this._currentIndex = 0;
         }
         teamCurPage = int(this._currentIndex / this._pageSize) + 1;
         teamCurPage = teamCurPage > this._maxPage ? this._maxPage : teamCurPage;
         if(teamCurPage == 0)
         {
            if(this._currentPage != 1)
            {
               this.beginIndex = 0;
            }
         }
         else if(teamCurPage != this._currentPage)
         {
            this.currentPage = teamCurPage;
         }
         this.setEndIndex();
      }
      
      public function get currentPage() : int
      {
         return this._currentPage;
      }
      
      public function set currentPage(value:int) : void
      {
         this._currentPage = value <= 1 ? 1 : value;
         this._currentPage = this._currentPage > this._maxPage ? this._maxPage : this._currentPage;
         this._beginIndex = this._currentIndex = (this._currentPage - 1) * this._pageSize;
         this.setEndIndex();
      }
      
      public function set beginIndex(value:uint) : void
      {
         this._beginIndex = value;
         if(this._beginIndex <= 0)
         {
            this._beginIndex = 0;
         }
         else if(this._beginIndex >= this._len - 1)
         {
            this._beginIndex = this._len - 1 - this._len % this._pageSize;
         }
         this.resetCurrentPage();
      }
      
      public function get beginIndex() : uint
      {
         return this._beginIndex;
      }
      
      public function get endIndex() : uint
      {
         return this._endIndex;
      }
      
      public function get maxPage() : int
      {
         return this._maxPage;
      }
      
      public function set maxPage(value:int) : void
      {
         this._maxPage = value < 1 ? 1 : value;
         this._currentPage = this._currentPage > this._maxPage ? this._maxPage : this._currentPage;
         this._beginIndex = (this._currentPage - 1) * this._pageSize;
         this._len = this._maxPage * this._pageSize;
         this.setEndIndex();
      }
      
      public function set len(value:uint) : void
      {
         if(value <= 0)
         {
            this._len = 0;
            this._beginIndex = 0;
            this._endIndex = 0;
            this._currentPage = 1;
            this._maxPage = 1;
            this.update();
            return;
         }
         this._len = value;
         this._maxPage = Math.max(1,Math.ceil(this._len / this._pageSize));
         this.currentPage = this._currentPage > this.maxPage ? this.maxPage : this._currentPage;
         this.setEndIndex();
      }
      
      public function get len() : uint
      {
         return this._len;
      }
      
      private function resetCurrentPage() : void
      {
         var teamCurPage:int = Math.ceil(this._beginIndex / (this._pageSize - 1));
         if(teamCurPage == 0)
         {
            this._currentPage = 1;
         }
         else if(teamCurPage != this._currentPage)
         {
            this._currentPage = teamCurPage;
         }
         this.setEndIndex();
      }
      
      private function setEndIndex() : void
      {
         this._endIndex = this._beginIndex + this._pageSize - 1;
         if(this._endIndex >= this._len - 1)
         {
            this._endIndex = this._len - 1;
         }
         if(this._endIndex <= 0)
         {
            this._endIndex = 0;
         }
         this.update();
      }
      
      protected function update() : void
      {
      }
   }
}

