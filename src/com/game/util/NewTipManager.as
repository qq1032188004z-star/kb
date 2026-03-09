package com.game.util
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.utils.Dictionary;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class NewTipManager
   {
      
      private static var _instance:NewTipManager;
      
      private var _toolFunData:Dictionary;
      
      private var _toolTipData:Dictionary;
      
      private var _currentToolTip:Sprite;
      
      private var _currentTarget:DisplayObject;
      
      private var _stageWidth:Number = 970;
      
      private var _stageHeight:Number = 570;
      
      private var _tipTxt:TextField;
      
      private var _maxTextWidth:Number = 500;
      
      private var _borderColor:uint = 16777215;
      
      private var _bgColor:uint = 16777164;
      
      private var _bgAlpha:Number = 0.75;
      
      private var _padding:uint = 3;
      
      private var _isMouseOnTip:Boolean = false;
      
      private var _isOnTipDic:Dictionary;
      
      private var _checkHideTime:uint;
      
      public function NewTipManager(singletonEnforcer:SingletonEnforcer)
      {
         super();
         if(singletonEnforcer == null)
         {
            throw new Error("NewTipManager是单例类，请使用getInstance()方法获取实例。");
         }
         this.initialize();
      }
      
      public static function getInstance() : NewTipManager
      {
         if(_instance == null)
         {
            _instance = new NewTipManager(new SingletonEnforcer());
         }
         return _instance;
      }
      
      private function initialize() : void
      {
         this._toolTipData = new Dictionary(true);
         this._toolFunData = new Dictionary(true);
         this._isOnTipDic = new Dictionary(true);
         this._currentToolTip = this.createToolTipSprite();
         this.createTextField();
      }
      
      public function setStageSize(width:Number, height:Number) : void
      {
         this._stageWidth = width;
         this._stageHeight = height;
      }
      
      public function setFun(target:DisplayObject, fun:Function) : void
      {
         if(target == null)
         {
            return;
         }
         if(Boolean(this._toolFunData[target]))
         {
            this.removeToolFun(target);
         }
         this._toolFunData[target] = fun;
      }
      
      public function addToolTip(target:DisplayObject, tipContent:*) : void
      {
         if(target == null)
         {
            return;
         }
         if(Boolean(this._isOnTipDic[target]))
         {
            delete this._isOnTipDic[target];
         }
         this.addTip(target,tipContent);
      }
      
      public function addHoverableToolTip(target:DisplayObject, tipSprite:Sprite) : void
      {
         if(target == null || tipSprite == null)
         {
            return;
         }
         this._isOnTipDic[target] = true;
         this.addTip(target,tipSprite);
      }
      
      private function addTip(target:DisplayObject, tipContent:*) : void
      {
         if(Boolean(this._toolTipData[target]))
         {
            this.removeToolTip(target);
         }
         this._toolTipData[target] = tipContent;
         target.addEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
         target.addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
         target.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
      }
      
      public function removeToolTip(target:DisplayObject) : void
      {
         if(target == null || !this._toolTipData[target])
         {
            return;
         }
         delete this._toolTipData[target];
         target.removeEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
         target.removeEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
         target.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
         if(this._currentTarget == target)
         {
            this.hideToolTip();
         }
      }
      
      public function removeToolFun(target:DisplayObject) : void
      {
         if(target == null || !this._toolFunData[target])
         {
            return;
         }
         delete this._toolFunData[target];
      }
      
      public function setStyle(maxTextWidth:Number = 500, borderColor:uint = 16777215, bgColor:uint = 14281964, bgAlpha:Number = 0.75, textColor:uint = 16750950, padding:uint = 5) : void
      {
         this._maxTextWidth = maxTextWidth;
         this._borderColor = borderColor;
         this._bgColor = bgColor;
         this._bgAlpha = bgAlpha;
         this._padding = padding;
         var format:TextFormat = new TextFormat();
         format.size = 12;
         format.color = textColor;
         this._tipTxt.defaultTextFormat = format;
         this._tipTxt.textColor = textColor;
      }
      
      private function onTipRollOver(event:MouseEvent) : void
      {
         this._isMouseOnTip = true;
      }
      
      private function onTipRollOut(event:MouseEvent) : void
      {
         this._isMouseOnTip = false;
         this._checkHideTime = setTimeout(this.checkHideToolTip,42);
      }
      
      private function checkHideToolTip() : void
      {
         if(!this._isMouseOnTip && Boolean(this._currentTarget))
         {
            this.hideToolTip();
         }
      }
      
      private function onRollOver(event:MouseEvent) : void
      {
         if(Boolean(this._checkHideTime))
         {
            clearTimeout(this._checkHideTime);
            this._checkHideTime = 0;
         }
         var target:DisplayObject = event.currentTarget as DisplayObject;
         if(Boolean(target))
         {
            if(Boolean(this._toolFunData[target]))
            {
               this._toolFunData[target].apply(null,[MouseEvent.ROLL_OVER]);
            }
            if(Boolean(this._toolTipData[target]))
            {
               this._currentTarget = target;
               this.showToolTip(target,this._toolTipData[target],event.stageX,event.stageY);
            }
         }
      }
      
      private function onRollOut(event:MouseEvent) : void
      {
         var target:DisplayObject = event.currentTarget as DisplayObject;
         if(Boolean(target) && Boolean(this._toolFunData[target]))
         {
            this._toolFunData[target].apply(null,[MouseEvent.ROLL_OUT]);
         }
         if(target == this._currentTarget)
         {
            if(Boolean(this._isOnTipDic[target]))
            {
               this._checkHideTime = setTimeout(this.checkHideToolTip,42);
            }
            else
            {
               this.hideToolTip();
            }
         }
      }
      
      private function onMouseMove(event:MouseEvent) : void
      {
         var target:DisplayObject = event.currentTarget as DisplayObject;
         if(target == this._currentTarget && this._currentToolTip.parent && !this._isOnTipDic[target])
         {
            this.updateToolTipPosition(event.stageX,event.stageY);
         }
      }
      
      private function showToolTip(target:DisplayObject, content:*, mouseX:Number, mouseY:Number) : void
      {
         var contentDisplay:DisplayObject = null;
         var contentWidth:Number = NaN;
         var contentHeight:Number = NaN;
         while(this._currentToolTip.numChildren > 0)
         {
            this._currentToolTip.removeChildAt(0);
         }
         this._currentToolTip.graphics.clear();
         if(content is String)
         {
            this.updateTextTip(content as String);
            contentWidth = this._tipTxt.width;
            contentHeight = this._tipTxt.height;
            this.drawBackground(contentWidth,contentHeight);
            this._currentToolTip.addChild(this._tipTxt);
         }
         else
         {
            if(!(content is DisplayObjectContainer))
            {
               trace("错误：提示内容必须是字符串或DisplayObjectContainer");
               return;
            }
            contentDisplay = content as DisplayObjectContainer;
            this._currentToolTip.graphics.clear();
            this._currentToolTip.addChild(contentDisplay);
            if(Boolean(this._isOnTipDic[target]))
            {
               this._currentToolTip.mouseEnabled = true;
               this._currentToolTip.mouseChildren = true;
               this._currentToolTip.addEventListener(MouseEvent.ROLL_OVER,this.onTipRollOver);
               this._currentToolTip.addEventListener(MouseEvent.ROLL_OUT,this.onTipRollOut);
            }
         }
         this._currentToolTip.filters = [new DropShadowFilter(2)];
         this.updateToolTipPosition(mouseX,mouseY);
         if(Boolean(target.stage))
         {
            target.stage.addChild(this._currentToolTip);
         }
      }
      
      private function drawBackground(contentWidth:Number, contentHeight:Number) : void
      {
         var gp:Graphics = this._currentToolTip.graphics;
         gp.clear();
         gp.lineStyle(1,this._borderColor);
         gp.beginFill(this._bgColor,this._bgAlpha);
         gp.drawRect(0,0,contentWidth + this._padding * 2,contentHeight + this._padding * 2);
         gp.endFill();
      }
      
      private function updateTextTip(text:String) : void
      {
         this._tipTxt.htmlText = text;
         this._tipTxt.wordWrap = false;
         this._tipTxt.width = NaN;
         var textWidth:Number = this._tipTxt.textWidth + 6;
         if(textWidth > this._maxTextWidth)
         {
            this._tipTxt.width = this._maxTextWidth;
            this._tipTxt.wordWrap = true;
            this._tipTxt.height = this._tipTxt.textHeight + 4;
         }
         else
         {
            this._tipTxt.width = textWidth;
            this._tipTxt.wordWrap = false;
            this._tipTxt.height = this._tipTxt.textHeight + 4;
         }
         this._tipTxt.x = this._padding;
         this._tipTxt.y = this._padding;
      }
      
      private function updateToolTipPosition(mouseX:Number, mouseY:Number) : void
      {
         var posX:Number = mouseX + 10;
         var posY:Number = mouseY + 10;
         if(posX + this._currentToolTip.width > this._stageWidth)
         {
            posX = mouseX - this._currentToolTip.width - 5;
            if(posX < 0)
            {
               posX = this._stageWidth - this._currentToolTip.width - 5;
            }
         }
         if(posY + this._currentToolTip.height > this._stageHeight)
         {
            posY = mouseY - this._currentToolTip.height - 5;
            if(posY < 0)
            {
               posY = this._stageHeight - this._currentToolTip.height - 5;
            }
         }
         posX = Math.max(5,Math.min(posX,this._stageWidth - this._currentToolTip.width - 5));
         posY = Math.max(5,Math.min(posY,this._stageHeight - this._currentToolTip.height - 5));
         this._currentToolTip.x = posX;
         this._currentToolTip.y = posY;
      }
      
      private function hideToolTip() : void
      {
         if(Boolean(this._currentToolTip.parent))
         {
            this._currentToolTip.parent.removeChild(this._currentToolTip);
         }
         this._currentTarget = null;
      }
      
      private function createToolTipSprite() : Sprite
      {
         var sprite:Sprite = new Sprite();
         sprite.mouseEnabled = false;
         sprite.mouseChildren = false;
         return sprite;
      }
      
      private function createTextField() : void
      {
         this._tipTxt = new TextField();
         this._tipTxt.autoSize = TextFieldAutoSize.LEFT;
         this._tipTxt.selectable = false;
         this._tipTxt.multiline = true;
      }
      
      public function destroy() : void
      {
         var target1:Object = null;
         var target2:Object = null;
         for(target1 in this._toolTipData)
         {
            if(target1 is DisplayObject)
            {
               this.removeToolTip(target1 as DisplayObject);
            }
         }
         this._toolTipData = null;
         this._isOnTipDic = null;
         for(target2 in this._toolFunData)
         {
            if(target2 is DisplayObject)
            {
               this.removeToolFun(target2 as DisplayObject);
            }
         }
         this._toolFunData = null;
         if(Boolean(this._currentToolTip) && Boolean(this._currentToolTip.parent))
         {
            this._currentToolTip.parent.removeChild(this._currentToolTip);
         }
         this._currentToolTip = null;
         this._currentTarget = null;
         this._tipTxt = null;
      }
   }
}

class SingletonEnforcer
{
   
   public function SingletonEnforcer()
   {
      super();
   }
}
