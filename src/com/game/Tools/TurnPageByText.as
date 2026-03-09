package com.game.Tools
{
   import com.game.modules.view.WindowLayer;
   import com.game.util.FloatAlert;
   import flash.display.InteractiveObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.Timer;
   
   public class TurnPageByText extends TurnPage
   {
      
      private var btnFirstPage:RectButton;
      
      private var btnLastPage:RectButton;
      
      public var btnPrevPage:RectButton;
      
      public var btnNextPage:RectButton;
      
      private var btnPrev:RectButton;
      
      private var btnNext:RectButton;
      
      private var txtPage:InteractiveObject;
      
      private var _time:Timer;
      
      public function TurnPageByText(pageSize:uint = 1, clickTime:int = 0)
      {
         super(pageSize);
         if(clickTime > 0)
         {
            this._time = new Timer(clickTime,1);
         }
      }
      
      public function setSkin(btnPrevPage:RectButton = null, btnNextPage:RectButton = null, btnPrev:RectButton = null, btnNext:RectButton = null, btnFirst:RectButton = null, btnLast:RectButton = null, txt:InteractiveObject = null) : void
      {
         this.txtPage = txt;
         beginIndex = 0;
         _currentPage = 1;
         if(Boolean(this.txtPage))
         {
            if(this.txtPage is TextField)
            {
               TextField(this.txtPage).selectable = false;
            }
            this.update();
         }
         if(Boolean(btnPrevPage))
         {
            btnPrevPage.useHandCursor = btnPrevPage.buttonMode = true;
            this.btnPrevPage = btnPrevPage;
            this.btnPrevPage.addEventListener(MouseEvent.CLICK,this.onMouseClickHandler);
         }
         if(Boolean(btnNextPage))
         {
            btnNextPage.useHandCursor = btnNextPage.buttonMode = true;
            this.btnNextPage = btnNextPage;
            this.btnNextPage.addEventListener(MouseEvent.CLICK,this.onMouseClickHandler);
         }
         if(Boolean(btnPrev))
         {
            btnPrev.useHandCursor = btnPrev.buttonMode = true;
            this.btnPrev = btnPrev;
            this.btnPrev.addEventListener(MouseEvent.CLICK,this.onMouseClickHandler,false,0,true);
         }
         if(Boolean(btnNext))
         {
            btnNext.useHandCursor = btnNext.buttonMode = true;
            this.btnNext = btnNext;
            this.btnNext.addEventListener(MouseEvent.CLICK,this.onMouseClickHandler,false,0,true);
         }
         if(Boolean(btnFirst))
         {
            btnFirst.useHandCursor = btnFirst.buttonMode = true;
            this.btnFirstPage = btnFirst;
            this.btnFirstPage.addEventListener(MouseEvent.CLICK,this.onMouseClickHandler,false,0,true);
         }
         if(Boolean(btnLast))
         {
            btnLast.useHandCursor = btnLast.buttonMode = true;
            this.btnLastPage = btnLast;
            this.btnLastPage.addEventListener(MouseEvent.CLICK,this.onMouseClickHandler,false,0,true);
         }
         this.tryToChangeGray();
      }
      
      public function setText(curPage:int, pageCount:int) : void
      {
         _currentPage = curPage;
         _maxPage = pageCount;
         if(_currentPage > _maxPage)
         {
            _currentPage = _maxPage;
         }
         this.tryToChangeGray();
         if(Boolean(this.txtPage))
         {
            if(this.txtPage is TextField)
            {
               this.txtPage["text"] = String(_currentPage) + "/" + String(_maxPage);
            }
            else
            {
               this.txtPage["text"] = String(_currentPage) + "/" + String(_maxPage);
            }
         }
      }
      
      override protected function update() : void
      {
         this.setText(_currentPage,_maxPage);
      }
      
      private function onMouseClickHandler(e:MouseEvent) : void
      {
         if(Boolean(this._time))
         {
            if(this._time.running)
            {
               new FloatAlert().show(WindowLayer.instance,300,300,"点击太快了哦，休息一下！");
               return;
            }
            this._time.start();
         }
         switch(e.currentTarget)
         {
            case this.btnPrevPage:
               currentIndex -= _pageSize;
               break;
            case this.btnNextPage:
               currentIndex += _pageSize;
               break;
            case this.btnPrev:
               --currentIndex;
               break;
            case this.btnNext:
               ++currentIndex;
               break;
            case this.btnFirstPage:
               currentIndex = 0;
               break;
            case this.btnLastPage:
               currentIndex = _maxPage * pageSize;
         }
         this.tryToChangeGray();
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      private function tryToChangeGray() : void
      {
         if(Boolean(this.btnPrevPage))
         {
            this.btnPrevPage.setDisable(false);
         }
         if(Boolean(this.btnPrev))
         {
            this.btnPrev.setDisable(false);
         }
         if(Boolean(this.btnFirstPage))
         {
            this.btnFirstPage.setDisable(false);
         }
         if(Boolean(this.btnNextPage))
         {
            this.btnNextPage.setDisable(false);
         }
         if(Boolean(this.btnNext))
         {
            this.btnNext.setDisable(false);
         }
         if(Boolean(this.btnLastPage))
         {
            this.btnLastPage.setDisable(false);
         }
         if(_maxPage == 1)
         {
            if(Boolean(this.btnPrevPage))
            {
               this.btnPrevPage.setDisable(true);
            }
            if(Boolean(this.btnLastPage))
            {
               this.btnLastPage.setDisable(true);
            }
            if(Boolean(this.btnFirstPage))
            {
               this.btnFirstPage.setDisable(true);
            }
            if(Boolean(this.btnNextPage))
            {
               this.btnNextPage.setDisable(true);
            }
         }
         else if(_currentPage >= _maxPage)
         {
            if(Boolean(this.btnNextPage))
            {
               this.btnNextPage.setDisable(true);
            }
            if(Boolean(this.btnLastPage))
            {
               this.btnLastPage.setDisable(true);
            }
         }
         else if(_currentPage == 1)
         {
            if(Boolean(this.btnPrevPage))
            {
               this.btnPrevPage.setDisable(true);
            }
            if(Boolean(this.btnFirstPage))
            {
               this.btnFirstPage.setDisable(true);
            }
         }
         if(Boolean(this.btnPrev))
         {
            if(_currentIndex == 0)
            {
               this.btnPrev.setDisable(true);
            }
         }
         if(Boolean(this.btnNext))
         {
            if(_currentIndex == _len - 1)
            {
               this.btnNext.setDisable(true);
            }
         }
      }
   }
}

