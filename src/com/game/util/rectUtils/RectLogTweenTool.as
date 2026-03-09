package com.game.util.rectUtils
{
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class RectLogTweenTool extends Sprite
   {
      
      private var _con:Sprite;
      
      private var _mask:Sprite;
      
      private var _rowHeight:int;
      
      private var _storeNum:int = 20;
      
      private var _sourceList:Vector.<DisplayObject>;
      
      private var _showList:Vector.<DisplayObject>;
      
      private var _showNum:int = 3;
      
      private var _initPosList:Vector.<Point>;
      
      private var _targetPosList:Vector.<Point>;
      
      public var tweenValue:Number = 0;
      
      private var _tween:TweenLite;
      
      private var _tweenTime:Number = 0.5;
      
      private var _delayTween:TweenLite;
      
      private var _delayTime:Number = 1;
      
      private var _onRoll:Boolean;
      
      private var _curIndex:int;
      
      private var _pauseTime:Number;
      
      private var _storeItemList:Vector.<DisplayObject>;
      
      private var _pauseTween:TweenMax;
      
      public function RectLogTweenTool(rowHeight:int, maskRect:Rectangle, showNum:int, storeNum:int, tweenTime:Number = 0.5, pauseTime:Number = 0)
      {
         super();
         this._con = new Sprite();
         addChild(this._con);
         this._mask = new Sprite();
         this._mask.graphics.beginFill(65450);
         this._mask.graphics.drawRect(maskRect.x,maskRect.y,maskRect.width,maskRect.height);
         this._mask.graphics.endFill();
         addChild(this._mask);
         this._con.mask = this._mask;
         this._rowHeight = rowHeight;
         this._showNum = showNum;
         this._storeNum = storeNum;
         this._tweenTime = tweenTime;
         this._pauseTime = pauseTime;
         this._sourceList = new Vector.<DisplayObject>();
         this._showList = new Vector.<DisplayObject>();
         this._storeItemList = new Vector.<DisplayObject>();
         this._initPosList = new Vector.<Point>();
         this._targetPosList = new Vector.<Point>();
         for(var i:int = 0; i < this._showNum + 1; i++)
         {
            this._initPosList.push(new Point(0,i * this._rowHeight));
            this._targetPosList.push(new Point(0,(i - 1) * this._rowHeight));
         }
      }
      
      private function storeDisplayObject(dis:DisplayObject) : void
      {
         if(this._showList.indexOf(dis) != -1 || this._storeItemList.indexOf(dis) != -1)
         {
            return;
         }
         this._storeItemList.push(dis);
         if(this._storeItemList.length > this._storeNum)
         {
            this._storeItemList.shift();
         }
      }
      
      public function getDisplayObject() : DisplayObject
      {
         if(Boolean(this._storeItemList.length))
         {
            return this._storeItemList.pop();
         }
         return null;
      }
      
      public function addDisplayObject(dis:DisplayObject, inCurIndex:Boolean = false) : void
      {
         this._sourceList.push(dis);
         if(this._sourceList.length > this._storeNum)
         {
            this.storeDisplayObject(this._sourceList.shift());
         }
         if(inCurIndex && this._sourceList.length > 2)
         {
            this._curIndex = this._sourceList.length - 2;
         }
         this.checkRoll();
      }
      
      public function addDisplayObjectList(arr:Array) : void
      {
         var i:int = 0;
         for(i = 0; i < arr.length; i++)
         {
            this._sourceList.push(arr[i]);
            if(this._sourceList.length > this._storeNum)
            {
               this.storeDisplayObject(this._sourceList.shift());
            }
         }
         this.checkRoll();
      }
      
      public function checkRoll() : void
      {
         var i:int = 0;
         var len:int = 0;
         if(this._sourceList.length <= this._showNum)
         {
            this._con.removeChildren();
            this._showList.length = 0;
            len = int(this._sourceList.length);
            for(i = 0; i < len; i++)
            {
               this._con.addChild(this._sourceList[i]);
               this._sourceList[i].x = this._initPosList[i].x;
               this._sourceList[i].y = this._initPosList[i].y;
               this._showList.push(this._sourceList[i]);
            }
         }
         else if(!this._onRoll)
         {
            this._onRoll = true;
            this._con.removeChildren();
            this._showList.length = 0;
            len = this._showNum;
            for(i = 0; i < len; i++)
            {
               this._con.addChild(this._sourceList[i]);
               this._sourceList[i].x = this._initPosList[i].x;
               this._sourceList[i].y = this._initPosList[i].y;
               this._showList.push(this._sourceList[i]);
            }
            this._curIndex = this._showNum - 1;
            if(this._pauseTime > 0)
            {
               this.removePauseTween();
               this._pauseTween = TweenMax.delayedCall(this._pauseTime,this.onDelay);
               return;
            }
            this.startDelay();
         }
      }
      
      private function startTween() : void
      {
         this.tweenValue = 0;
         if(!this._tween)
         {
            this._tween = TweenLite.to(this,this._tweenTime,{
               "tweenValue":this._rowHeight,
               "onComplete":this.onTweenComplete,
               "onUpdate":this.onTweenUpdate
            });
         }
         else
         {
            this._tween.restart();
         }
      }
      
      private function onTweenUpdate() : void
      {
         for(var i:int = 0; i < this._showList.length; i++)
         {
            this._showList[i].y = this._initPosList[i].y - this.tweenValue;
         }
      }
      
      private function onTweenComplete() : void
      {
         for(var i:int = 0; i < this._showList.length; i++)
         {
            this._showList[i].y = this._targetPosList[i].y;
         }
         var item:DisplayObject = this._showList.shift();
         if(this._sourceList.indexOf(item) == -1)
         {
            this.storeDisplayObject(item);
         }
         if(this._pauseTime > 0)
         {
            this.removePauseTween();
            this._pauseTween = TweenMax.delayedCall(this._pauseTime,this.onDelay);
            return;
         }
         this.startDelay();
      }
      
      private function onDelay() : void
      {
         this.startDelay();
      }
      
      private function startDelay() : void
      {
         this._delayTween = TweenLite.delayedCall(this._delayTime,this.onDelayComplete);
      }
      
      private function onDelayComplete() : void
      {
         this._delayTween.kill();
         ++this._curIndex;
         if(this._curIndex >= this._sourceList.length)
         {
            this._curIndex = 0;
         }
         this._showList.push(this._sourceList[this._curIndex]);
         for(var i:int = 0; i < this._showList.length; i++)
         {
            this._showList[i].y = this._initPosList[i].y;
            this._con.addChild(this._showList[i]);
         }
         this.startTween();
      }
      
      public function destroy() : void
      {
         var displayObject2:DisplayObject = null;
         var displayObject1:DisplayObject = null;
         var displayObject:DisplayObject = null;
         if(Boolean(this._tween))
         {
            this._tween.kill();
            this._tween = null;
         }
         if(Boolean(this._delayTween))
         {
            this._delayTween.kill();
            this._delayTween = null;
         }
         this.removePauseTween();
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
         for each(displayObject2 in this._storeItemList)
         {
            if(displayObject2.hasOwnProperty("dispose"))
            {
               displayObject2["dispose"]();
            }
         }
         this._storeItemList.length = 0;
         this._storeItemList = null;
         for each(displayObject1 in this._sourceList)
         {
            if(displayObject1.hasOwnProperty("dispose"))
            {
               displayObject1["dispose"]();
            }
         }
         this._sourceList.length = 0;
         this._sourceList = null;
         for each(displayObject in this._showList)
         {
            if(displayObject.hasOwnProperty("dispose"))
            {
               displayObject["dispose"]();
            }
         }
         this._showList.length = 0;
         this._showList = null;
      }
      
      private function removePauseTween() : void
      {
         if(Boolean(this._pauseTween))
         {
            this._pauseTween.kill();
            this._pauseTween = null;
         }
      }
      
      public function get sourceNum() : int
      {
         return this._sourceList.length;
      }
      
      public function get sourceList() : Vector.<DisplayObject>
      {
         return this._sourceList;
      }
   }
}

