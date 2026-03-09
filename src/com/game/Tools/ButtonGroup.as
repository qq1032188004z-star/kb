package com.game.Tools
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   
   public class ButtonGroup extends EventDispatcher
   {
      
      private var _btnList:Vector.<RectButton>;
      
      private var _curIndex:int = -1;
      
      private var _changeFun:Function;
      
      public function ButtonGroup(changeFun:Function = null, ary:Vector.<RectButton> = null)
      {
         var i:int = 0;
         super();
         this._changeFun = changeFun;
         this._btnList = new Vector.<RectButton>();
         if(Boolean(ary))
         {
            for(i = 0; i < ary.length; i++)
            {
               this.addRectButton(ary[i]);
            }
         }
      }
      
      public function setAllBtnVisible(flag:Boolean) : void
      {
         var btn:RectButton = null;
         for each(btn in this._btnList)
         {
            btn.visible = flag;
         }
      }
      
      public function set curIndex(value:int) : void
      {
         this._curIndex = value;
         this.selectButton();
      }
      
      public function get curIndex() : int
      {
         return this._curIndex;
      }
      
      public function addRectButton(btn:RectButton) : void
      {
         if(Boolean(btn))
         {
            (btn.skin as MovieClip).gotoAndStop(1);
            btn.addEventListener(MouseEvent.CLICK,this.onMyBtnMouseClick);
            this._btnList.push(btn);
         }
      }
      
      public function dispose() : void
      {
         var btn:RectButton = null;
         if(Boolean(this._btnList))
         {
            for each(btn in this._btnList)
            {
               btn.removeEventListener(MouseEvent.CLICK,this.onMyBtnMouseClick);
            }
            this._btnList = null;
         }
      }
      
      private function selectButton() : void
      {
         var btn:RectButton = null;
         for(var i:int = 0; i < this._btnList.length; i++)
         {
            btn = this._btnList[i];
            (btn.skin as MovieClip).gotoAndStop(i == this._curIndex ? 2 : 1);
         }
      }
      
      private function onMyBtnMouseClick(event:MouseEvent) : void
      {
         var index:int = int(this._btnList.indexOf(event.currentTarget));
         if(index == this._curIndex)
         {
            return;
         }
         this.curIndex = index;
         dispatchEvent(new Event(Event.CHANGE));
         if(this._changeFun != null)
         {
            this._changeFun.apply();
         }
      }
   }
}

