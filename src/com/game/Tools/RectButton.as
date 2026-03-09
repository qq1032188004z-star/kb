package com.game.Tools
{
   import com.game.util.DisplayUtil;
   import com.greensock.TweenMax;
   import com.greensock.easing.Linear;
   import com.publiccomponent.ui.ToolTip;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   
   public class RectButton extends Sprite
   {
      
      protected var _skinCon:Sprite;
      
      protected var _skin:DisplayObject;
      
      protected var hitBmpData:BitmapData = new BitmapData(1,1,true,16777215);
      
      protected var _hitRect:Bitmap;
      
      protected var _hitCon:RectHitSprite;
      
      protected var tipBmpData:BitmapData = new BitmapData(1,1,true,16777215);
      
      protected var _tipRect:Bitmap;
      
      protected var _tipCon:RectHitSprite;
      
      protected var _tween:TweenMax;
      
      protected var _upValue:Number = 1;
      
      protected var _overValue:Number = 1.05;
      
      protected var _downHValue:Number = 0.95;
      
      protected var _downVValue:Number = 0.95;
      
      protected var _needShake:Boolean;
      
      private var _disable:Boolean;
      
      private var _tips:String;
      
      private var _isDisableTips:Boolean;
      
      public var overFilterArr:Array;
      
      protected var _shakeTween:TweenMax;
      
      protected var _initRadius:Point = new Point(4,6);
      
      protected var _radius:Point = new Point();
      
      protected var _startPos:Point = new Point();
      
      public var sita:Number;
      
      protected var _shakeTime:Number = 5;
      
      protected var _isFirst:Boolean = true;
      
      public function RectButton()
      {
         super();
         this.overFilterArr = [new GlowFilter(16777215,1,10,10,2,1,true,false)];
      }
      
      public function setOverFilterArr(arr:Array) : void
      {
         this.overFilterArr = arr;
      }
      
      public function setSkin(displayObj:DisplayObject) : void
      {
         if(!this._skinCon)
         {
            this._skinCon = new Sprite();
            addChild(this._skinCon);
            this._skinCon.mouseChildren = this._skinCon.mouseEnabled = false;
         }
         this._skin = displayObj;
         this._skin.x = this._skin.y = 0;
         this._skinCon.addChild(this._skin);
         if(this._skin is Sprite || this._skin is MovieClip)
         {
            this._skin["mouseChildren"] = this._skin["mouseEnabled"] = false;
         }
         if(this._skin.hasOwnProperty("hitRect"))
         {
            this.setHitRect(this._skin["hitRect"].width,this._skin["hitRect"].height);
            if(Boolean(this._skin["hitRect"].parent))
            {
               this._skin["hitRect"].parent.removeChild(this._skin["hitRect"]);
            }
         }
         else
         {
            this.setHitRect(this._skin.width,this._skin.height);
         }
      }
      
      public function adjustCenterPos() : void
      {
         this._skin.x = -this._skin.width * 0.5;
         this._skin.y = -this._skin.height * 0.5;
         this._skinCon.x = this._skin.width * 0.5;
         this._skinCon.y = this._skin.height * 0.5;
         this._hitRect.x = 0;
         this._hitRect.y = 0;
         this._tipRect.x = 0;
         this._tipRect.y = 0;
      }
      
      public function setHitRect(w:int, h:int, X:int = 999, Y:int = 999) : void
      {
         if(!this._tipCon)
         {
            this._tipCon = new RectHitSprite();
            this._tipCon.tipHeight = h * 0.5;
            addChild(this._tipCon);
         }
         if(Boolean(this.tipBmpData))
         {
            this.tipBmpData.dispose();
         }
         this.tipBmpData = new BitmapData(Math.max(1,w),Math.max(1,h),true,0);
         if(!this._tipRect)
         {
            this._tipRect = new Bitmap();
            this._tipCon.addChild(this._tipRect);
         }
         this._tipRect.bitmapData = this.tipBmpData;
         if(!this._hitCon)
         {
            this._hitCon = new RectHitSprite();
            this._tipCon.tipHeight = h * 0.5;
            addChild(this._hitCon);
         }
         if(Boolean(this.hitBmpData))
         {
            this.hitBmpData.dispose();
         }
         this.hitBmpData = new BitmapData(Math.max(1,w),Math.max(1,h),true,0);
         if(!this._hitRect)
         {
            this._hitRect = new Bitmap();
            this._hitCon.addChild(this._hitRect);
         }
         this._hitRect.bitmapData = this.hitBmpData;
         if(X == 999 && Y == 999)
         {
            this._tipRect.x = this._hitRect.x = -w * 0.5;
            this._tipRect.y = this._hitRect.y = -h * 0.5;
         }
         else
         {
            this._tipRect.x = this._hitRect.x = X;
            this._tipRect.y = this._hitRect.y = Y;
         }
         this.addEventListener(Event.ADDED_TO_STAGE,this.initListener);
      }
      
      protected function initListener(event:Event = null) : void
      {
         this.removeEventListener(Event.ADDED_TO_STAGE,this.initListener);
         this._hitCon.buttonMode = this._hitCon.useHandCursor = true;
         this._hitCon.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOverHandler);
         this._hitCon.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOutHandler);
         this._hitCon.addEventListener(MouseEvent.CLICK,this.onMouseOverHandler);
         this._hitCon.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDownHandler);
         addEventListener(MouseEvent.CLICK,this.onThisClickHandler,false,int.MAX_VALUE);
      }
      
      protected function onThisClickHandler(event:MouseEvent) : void
      {
         if(this.isHit(event.localX,event.localY))
         {
            if(this.disable)
            {
               event.stopImmediatePropagation();
            }
         }
         else
         {
            event.stopImmediatePropagation();
         }
      }
      
      public function get tips() : String
      {
         return this._tips;
      }
      
      public function set tips(value:String) : void
      {
         this._tips = value;
         ToolTip.LooseDO(this._tipCon);
         ToolTip.LooseDO(this._hitCon);
         if(value != null && value != "")
         {
            ToolTip.setDOInfo(this._tipCon,this.tips);
            ToolTip.setDOInfo(this._hitCon,this.tips);
            this.isDisableTips = this._isDisableTips;
         }
      }
      
      public function get isDisableTips() : Boolean
      {
         return this._isDisableTips;
      }
      
      public function set isDisableTips(value:Boolean) : void
      {
         this._isDisableTips = value;
         if(this._tips == null || this._tips == "")
         {
            return;
         }
         if(this._isDisableTips)
         {
            ToolTip.LooseDO(this._hitCon);
         }
      }
      
      public function onRemoveRect() : void
      {
         ToolTip.LooseDO(this._hitCon);
         ToolTip.LooseDO(this._tipCon);
         this.flashSkin(false);
         this.shakeSkin(false);
         this.onTweenComplete();
         this.clearShakeTween();
         this._hitCon.removeEventListener(MouseEvent.MOUSE_OVER,this.onMouseOverHandler);
         this._hitCon.removeEventListener(MouseEvent.MOUSE_OUT,this.onMouseOutHandler);
         this._hitCon.removeEventListener(MouseEvent.CLICK,this.onMouseOverHandler);
         this._hitCon.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDownHandler);
         removeEventListener(MouseEvent.CLICK,this.onThisClickHandler);
         if(Boolean(this._skin))
         {
            this.removeParent(this._skin);
         }
         this.removeParent(this._skinCon);
         this.removeParent(this._hitCon);
         if(Boolean(this.hitBmpData))
         {
            this.hitBmpData.dispose();
            this.hitBmpData = null;
         }
         if(Boolean(this._hitRect))
         {
            if(Boolean(this._hitRect.bitmapData))
            {
               this._hitRect.bitmapData.dispose();
            }
            this._hitRect = null;
         }
         this.removeParent(this._tipCon);
         if(Boolean(this.tipBmpData))
         {
            this.tipBmpData.dispose();
            this.tipBmpData = null;
         }
         if(Boolean(this._tipRect))
         {
            if(Boolean(this._tipRect.bitmapData))
            {
               this._tipRect.bitmapData.dispose();
            }
            this._tipRect = null;
         }
         if(Boolean(this._tween))
         {
            this._tween.kill();
            this._tween = null;
         }
         this.overFilterArr = null;
      }
      
      private function removeParent(p:DisplayObject) : void
      {
         if(Boolean(p.parent))
         {
            p.parent.removeChild(p);
         }
         p = null;
      }
      
      private function isHit(x:Number, y:Number) : Boolean
      {
         if(this._hitRect && x >= this._hitRect.x && x <= this._hitRect.width + this._hitRect.x)
         {
            if(y >= this._hitRect.y && y <= this._hitRect.height + this._hitRect.y)
            {
               return true;
            }
         }
         return false;
      }
      
      protected function onMouseDownHandler(event:MouseEvent) : void
      {
         this.tweenSize(this._downHValue,this._downVValue);
         this.flashSkin(false);
         this.shakeSkin(false);
      }
      
      protected function onMouseOutHandler(event:MouseEvent) : void
      {
         this.tweenSize(this._upValue,this._upValue);
         this.flashSkin(false);
         this.shakeSkin(false);
      }
      
      protected function onMouseOverHandler(event:MouseEvent) : void
      {
         this.tweenSize(this._upValue,this._upValue);
         this.flashSkin(true);
         this.shakeSkin(true);
      }
      
      protected function tweenSize(hvalue:Number, vvalue:Number) : void
      {
         if(!this._skinCon)
         {
            return;
         }
         if(Boolean(this._tween))
         {
            this._tween.kill();
            this._tween = null;
         }
         this._tween = TweenMax.to(this._skinCon,0.1,{
            "scaleX":hvalue,
            "scaleY":vvalue,
            "onComplete":this.onTweenComplete
         });
      }
      
      protected function onTweenComplete() : void
      {
         if(Boolean(this._tween))
         {
            this._tween.kill();
            this._tween = null;
         }
      }
      
      protected function flashSkin(bool:Boolean) : void
      {
         if(bool)
         {
            this._skinCon.filters = this.overFilterArr;
         }
         else
         {
            this._skinCon.filters = [];
         }
      }
      
      protected function shakeSkin(bool:Boolean) : void
      {
         if(!this._needShake)
         {
            return;
         }
         this.clearShakeTween();
         if(bool)
         {
            if(this._isFirst)
            {
               this._isFirst = false;
               this._radius.x = this._initRadius.x * 0.5;
               this._radius.y = this._initRadius.y * 0.5;
               this._startPos.x = -this._initRadius.x * 0.5;
               this._startPos.y = 0;
               this.sita = 0;
               this._shakeTween = TweenMax.to(this,this._shakeTime * 0.25,{
                  "sita":Math.PI,
                  "onUpdate":this.onUpdate,
                  "onComplete":this.onShakeComplete,
                  "ease":Linear.easeNone
               });
            }
            else
            {
               this._radius.x = this._initRadius.x;
               this._radius.y = this._initRadius.y;
               this._startPos.x = 0;
               this._startPos.y = 0;
               this.sita = Math.PI;
               this._shakeTween = TweenMax.to(this,this._shakeTime,{
                  "sita":Math.PI * 3,
                  "onUpdate":this.onUpdate,
                  "onComplete":this.onShakeComplete,
                  "ease":Linear.easeNone
               });
            }
         }
         else
         {
            this._skinCon.x = this._skinCon.y = 0;
            this.sita = 0;
            this._isFirst = true;
         }
      }
      
      protected function clearShakeTween() : void
      {
         if(Boolean(this._shakeTween))
         {
            this._shakeTween.kill();
            this._shakeTween = null;
         }
      }
      
      protected function onUpdate() : void
      {
         this._skinCon.x = this._startPos.x + this._radius.x * Math.cos(this.sita);
         this._skinCon.y = this._startPos.y + this._radius.y * Math.sin(this.sita);
      }
      
      protected function onShakeComplete() : void
      {
         this.shakeSkin(true);
      }
      
      public function set needShake(value:Boolean) : void
      {
         this._needShake = value;
      }
      
      public function setDisable(bool:Boolean, grayCtrl:Boolean = true) : void
      {
         this._disable = bool;
         if(grayCtrl)
         {
            if(bool)
            {
               DisplayUtil.grayDisplayObject(this);
            }
            else
            {
               DisplayUtil.ungrayDisplayObject(this);
            }
         }
         this._hitCon.visible = !bool;
      }
      
      public function set downHValue(value:Number) : void
      {
         this._downHValue = value;
      }
      
      public function set downVValue(value:Number) : void
      {
         this._downVValue = value;
      }
      
      public function get skin() : DisplayObject
      {
         return this._skin;
      }
      
      public function get disable() : Boolean
      {
         return this._disable;
      }
   }
}

