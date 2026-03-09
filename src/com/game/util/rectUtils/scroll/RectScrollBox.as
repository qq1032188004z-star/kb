package com.game.util.rectUtils.scroll
{
   import com.core.observer.MessageEvent;
   import com.game.util.DisplayUtil;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class RectScrollBox extends Sprite
   {
      
      private var _viewRect:Rectangle;
      
      private var _contentCon:Sprite;
      
      private var _mask:Sprite;
      
      private var _scrollBar:RectScrollBar;
      
      private var _showTopBottomBtn:Boolean;
      
      private var _noShowScrollBar:Boolean;
      
      private var _displayObjList:Vector.<DisplayObject>;
      
      private var _colNum:int;
      
      private var _colGap:int;
      
      private var _rowGap:int;
      
      private var _area:Sprite;
      
      private var _lastRate:Number = 0;
      
      private var _scrollBarFixX:int;
      
      private var _extraHeight:int;
      
      private var _scrollCallFun:Function;
      
      private var _isFixContentY:Boolean;
      
      private var _layoutPos:Point;
      
      private var _scrollGraySkin:DisplayObject;
      
      public function RectScrollBox(W:int, H:int, colNum:int = 1, showTopBottomBtn:Boolean = false, scrollBarFixX:int = 0, extraHeight:int = 0, layoutPos:Point = null)
      {
         super();
         this._colNum = colNum;
         this._showTopBottomBtn = showTopBottomBtn;
         this._scrollBarFixX = scrollBarFixX;
         this._extraHeight = extraHeight;
         this._viewRect = new Rectangle(0,0,W,H);
         this._layoutPos = Boolean(layoutPos) ? layoutPos : new Point();
         this.init();
      }
      
      private function init() : void
      {
         this._displayObjList = new Vector.<DisplayObject>();
         this._contentCon = new Sprite();
         addChild(this._contentCon);
         this._mask = new Sprite();
         this._mask.graphics.beginFill(65450);
         this._mask.graphics.drawRect(this._viewRect.x,this._viewRect.y,this._viewRect.width,this._viewRect.height);
         this._mask.graphics.endFill();
         addChild(this._mask);
         this._contentCon.mask = this._mask;
         this._scrollBar = new RectScrollBar();
         addChild(this._scrollBar);
         this._scrollBar.x = this._viewRect.width + this._scrollBar.width * 0.5 + this._scrollBarFixX;
         this._scrollBar.visible = false;
         this._scrollBar.addEventListener(RectScrollBar.ON_SCROLL_UPDATE,this.onScrollUpdate,false,0,true);
         this._area = new Sprite();
         this._area.graphics.beginFill(65450,0);
         this._area.graphics.drawRect(this._viewRect.x,this._viewRect.y,this._viewRect.width + this._scrollBar.width,this._viewRect.height);
         this._area.graphics.endFill();
         addChildAt(this._area,0);
      }
      
      public function changeViewRect(viewRect:Rectangle, needToBottom:Boolean = true) : void
      {
         this._viewRect = viewRect;
         if(!this._mask)
         {
            this._mask = new Sprite();
         }
         this._mask.graphics.clear();
         this._mask.graphics.beginFill(65450);
         this._mask.graphics.drawRect(this._viewRect.x,this._viewRect.y,this._viewRect.width,this._viewRect.height);
         this._mask.graphics.endFill();
         addChild(this._mask);
         this._contentCon.mask = this._mask;
         if(!this._area)
         {
            this._area = new Sprite();
         }
         this._area.graphics.clear();
         this._area.graphics.beginFill(65450,0);
         this._area.graphics.drawRect(this._viewRect.x,this._viewRect.y,this._viewRect.width + this._scrollBar.width,this._viewRect.height);
         this._area.graphics.endFill();
         addChildAt(this._area,0);
         this.updateView(needToBottom);
      }
      
      public function changeHitArea(wd:Number, ht:Number, dx:int = 0, dy:int = 0) : void
      {
         if(!this._area)
         {
            this._area = new Sprite();
         }
         this._area.graphics.clear();
         this._area.graphics.beginFill(65450,0);
         this._area.graphics.drawRect(dx,dy,wd,ht);
         this._area.graphics.endFill();
         addChildAt(this._area,0);
      }
      
      public function scrollShowBar(bool:Boolean) : void
      {
         this._scrollBar.scrollShowBar(bool);
         if(bool)
         {
            this._scrollBar.x = this._viewRect.width;
         }
         else
         {
            this._scrollBar.x = this._viewRect.width + this._scrollBar.width * 0.5;
         }
      }
      
      public function noShowScrollBar(bool:Boolean) : void
      {
         this._noShowScrollBar = bool;
         this._scrollBar.noShowScrollBar(bool);
      }
      
      public function setGap(colGap:int, rowGap:int) : void
      {
         this._colGap = colGap;
         this._rowGap = rowGap;
      }
      
      public function addDisplayObj(dis:DisplayObject, needUpdateScrollBar:Boolean = true) : void
      {
         this._contentCon.addChild(dis);
         var col:int = this._displayObjList.length % this._colNum;
         var row:int = this._displayObjList.length / this._colNum;
         dis.x = col * this._colGap + this._layoutPos.x;
         dis.y = row * this._rowGap + this._layoutPos.y;
         this._displayObjList.push(dis);
         if(needUpdateScrollBar)
         {
            if(this.getContentHeight() > this._viewRect.height)
            {
               this._scrollBar.visible = !this._noShowScrollBar;
               this._scrollBar.setScrollHeight(this.getContentHeight(),this._viewRect.height,this._showTopBottomBtn);
               this._scrollBar.setScrollBtnPos(0);
            }
         }
      }
      
      protected function onScrollUpdate(event:MessageEvent) : void
      {
         var rate:Number = Number(event.body["rate"]);
         this._lastRate = rate < 0 ? 0 : rate;
         var dis:Number = (this.getContentHeight() - this._viewRect.height) * rate;
         if(!this._isFixContentY)
         {
            this._contentCon.y = -dis;
         }
         if(this._scrollCallFun != null)
         {
            this._scrollCallFun.apply();
         }
         this._isFixContentY = false;
      }
      
      public function setScrollCallFun(fun:Function) : void
      {
         this._scrollCallFun = fun;
      }
      
      public function updateView(needToBottom:Boolean = false) : void
      {
         var dis:Number = NaN;
         this._isFixContentY = false;
         if(this.getContentHeight() > this._viewRect.height)
         {
            this._scrollBar.visible = !this._noShowScrollBar;
            this._scrollBar.setScrollHeight(this.getContentHeight(),this._viewRect.height,this._showTopBottomBtn);
            if(needToBottom)
            {
               dis = this.getContentHeight() - this._viewRect.height;
               this._contentCon.y = -dis;
               this._scrollBar.setScrollBtnPos(1);
            }
            else
            {
               dis = (this.getContentHeight() - this._viewRect.height) * this._lastRate;
               this._contentCon.y = -dis;
               this._scrollBar.setScrollBtnPos(this._lastRate);
            }
         }
         else
         {
            this._contentCon.y = 0;
            this._scrollBar.visible = false;
            this._scrollBar.setScrollHeight(this._viewRect.height * 2,this._viewRect.height,false);
            this._scrollBar.clearScrollRange();
         }
         if(Boolean(this._scrollGraySkin))
         {
            this._scrollGraySkin.visible = !this._scrollBar.visible;
         }
      }
      
      public function setGrayBar(sp:Sprite) : void
      {
         this._scrollGraySkin = sp;
         DisplayUtil.grayDisplayObject(this._scrollGraySkin);
         this._scrollGraySkin.x = this._scrollBar.x;
         this._scrollGraySkin.height = this._viewRect.height;
         addChild(this._scrollGraySkin);
      }
      
      public function onUpdateScrollToPos(scrollHeight:Number) : void
      {
         var rate:Number = NaN;
         var dis:Number = NaN;
         this._isFixContentY = false;
         if(this.getContentHeight() > this._viewRect.height)
         {
            this._scrollBar.visible = !this._noShowScrollBar;
            this._scrollBar.setScrollHeight(this.getContentHeight(),this._viewRect.height,this._showTopBottomBtn);
            rate = Number(scrollHeight / this.getContentHeight()) >= 1 ? 1 : Number(scrollHeight / this.getContentHeight());
            dis = (this.getContentHeight() - this._viewRect.height) * rate;
            this._contentCon.y = -dis;
            this._scrollBar.setScrollBtnPos(rate);
         }
         else
         {
            this._contentCon.y = 0;
            this._scrollBar.visible = false;
         }
      }
      
      public function onUpdateFixContentY() : void
      {
         var rate:Number = NaN;
         this._isFixContentY = true;
         if(this.getContentHeight() > this._viewRect.height)
         {
            this._scrollBar.visible = !this._noShowScrollBar;
            this._scrollBar.setScrollHeight(this.getContentHeight(),this._viewRect.height,this._showTopBottomBtn);
            rate = Math.abs(this._contentCon.y) / (this.getContentHeight() - this._viewRect.height);
            rate = rate >= 1 ? 1 : rate;
            rate = rate < 0 ? 0 : rate;
            this._scrollBar.setScrollBtnPos(rate);
         }
         else
         {
            this._contentCon.y = 0;
            this._scrollBar.visible = false;
         }
      }
      
      public function clear() : void
      {
         for(var i:int = this._displayObjList.length - 1; i >= 0; i--)
         {
            if(Boolean(this._displayObjList[i]) && Boolean(this._displayObjList[i].parent))
            {
               if(this._displayObjList[i].hasOwnProperty("clear"))
               {
                  this._displayObjList[i]["clear"]();
               }
               else if(this._displayObjList[i].hasOwnProperty("disport"))
               {
                  this._displayObjList[i]["disport"]();
               }
               if(Boolean(this._displayObjList[i].parent))
               {
                  this._displayObjList[i].parent.removeChild(this._displayObjList[i]);
               }
            }
            this._displayObjList.splice(i,1);
         }
      }
      
      public function clearByNum(clearNum:int) : void
      {
         for(var i:int = 0; i < clearNum; i++)
         {
            if(Boolean(this._displayObjList[0]) && Boolean(this._displayObjList[0].parent))
            {
               if(this._displayObjList[0].hasOwnProperty("clear"))
               {
                  this._displayObjList[0]["clear"]();
               }
               else if(this._displayObjList[i].hasOwnProperty("disport"))
               {
                  this._displayObjList[i]["disport"]();
               }
               this._displayObjList[0].parent.removeChild(this._displayObjList[0]);
            }
            this._displayObjList.splice(0,1);
         }
      }
      
      public function clearByItem(item:DisplayObject) : void
      {
         var dis:DisplayObject = null;
         var index:int = int(this._displayObjList.indexOf(item));
         if(index != -1)
         {
            dis = this._displayObjList.splice(index,1)[0];
            if(Boolean(dis) && Boolean(dis.parent))
            {
               if(dis.hasOwnProperty("clear"))
               {
                  dis["clear"]();
               }
               else if(dis.hasOwnProperty("disport"))
               {
                  dis["disport"]();
               }
               if(Boolean(dis.parent))
               {
                  dis.parent.removeChild(dis);
               }
            }
            this.updateContent();
         }
      }
      
      private function updateContent() : void
      {
         var dis:DisplayObject = null;
         var col:int = 0;
         var row:int = 0;
         for(var i:int = 0; i < this._displayObjList.length; i++)
         {
            dis = this._displayObjList[i];
            col = i % this._colNum;
            row = i / this._colNum;
            dis.x = col * this._colGap + this._layoutPos.x;
            dis.y = row * this._rowGap + this._layoutPos.y;
         }
         this.updateView();
      }
      
      public function get displayObjList() : Vector.<DisplayObject>
      {
         return this._displayObjList;
      }
      
      public function getContentHeight() : Number
      {
         return this._contentCon.height + this._extraHeight;
      }
      
      public function get scrollBar() : RectScrollBar
      {
         return this._scrollBar;
      }
      
      public function get contentCon() : Sprite
      {
         return this._contentCon;
      }
      
      public function destroy() : void
      {
         var item:DisplayObject = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
         if(Boolean(this._scrollBar))
         {
            this._scrollBar.removeEventListener(RectScrollBar.ON_SCROLL_UPDATE,this.onScrollUpdate);
            this._scrollBar.destroy();
         }
         if(this._contentCon.numChildren > 0)
         {
            while(this._contentCon.numChildren > 0)
            {
               item = this._contentCon.getChildAt(0);
               if(Boolean(item))
               {
                  if(item.hasOwnProperty("disport"))
                  {
                     item["disport"]();
                  }
                  if(Boolean(item.parent))
                  {
                     item.parent.removeChild(item);
                  }
               }
            }
         }
      }
   }
}

