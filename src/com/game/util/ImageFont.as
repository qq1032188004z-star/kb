package com.game.util
{
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.system.ApplicationDomain;
   import flash.text.TextFormatAlign;
   
   public class ImageFont extends Sprite
   {
      
      private var _type:int = 0;
      
      private var sxx:Number = 1;
      
      private var syy:Number = 1;
      
      private var _text:String;
      
      private var _align:String;
      
      private var _hGap:Number = 2;
      
      private var _namePrefix:String;
      
      private var _application:ApplicationDomain;
      
      private var _curNum:int = 0;
      
      private var _endNum:int = 0;
      
      private var _rollVal:int = 0;
      
      public function ImageFont()
      {
         super();
         mouseChildren = false;
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoved,false,0,true);
      }
      
      private static function transText(val:String) : String
      {
         if(val == "-")
         {
            return "subtract";
         }
         if(val == "+")
         {
            return "add";
         }
         return val;
      }
      
      public function set resource(value:ApplicationDomain) : void
      {
         this._application = value;
         this.update();
      }
      
      public function getInstanceByClass(className:String) : Object
      {
         return new (this._application.getDefinition(className) as Class)();
      }
      
      public function set namePrefix(value:String) : void
      {
         this._namePrefix = value;
      }
      
      public function get namePrefix() : String
      {
         return this._namePrefix;
      }
      
      public function set text(val:String) : void
      {
         if(isNaN(Number(val)) == false)
         {
            if(this._rollVal != 0)
            {
               this._endNum = Number(val);
               if(this._curNum < this._endNum)
               {
                  if(this._rollVal < 0)
                  {
                     this._rollVal *= -1;
                  }
               }
               else if(this._rollVal > 0)
               {
                  this._rollVal *= -1;
               }
               this.addEventListener(Event.ENTER_FRAME,this.onEnterFrameHandler,false,0,true);
            }
            else
            {
               this._curNum = Number(val);
               this._text = val;
               this.update();
               this.removeEventListener(Event.ENTER_FRAME,this.onEnterFrameHandler);
            }
         }
         else
         {
            this._text = val;
            this.update();
         }
      }
      
      public function get text() : String
      {
         return this._text;
      }
      
      public function set align(val:String) : void
      {
         this._align = val;
         this.update();
      }
      
      public function set horizontalGap(value:Number) : void
      {
         this._hGap = value;
      }
      
      public function setItemScale(sx:Number, sy:Number) : void
      {
         this.sxx = sx;
         this.syy = sy;
         this.update();
      }
      
      public function setRoll(value:int) : void
      {
         this._rollVal = value;
      }
      
      private function onEnterFrameHandler(e:Event) : void
      {
         this._curNum += this._rollVal;
         if(this._curNum > this._endNum && this._rollVal > 0)
         {
            this._curNum = this._endNum;
            this.removeEventListener(Event.ENTER_FRAME,this.onEnterFrameHandler);
         }
         else if(this._curNum < this._endNum && this._rollVal < 0)
         {
            this._curNum = this._endNum;
            this.removeEventListener(Event.ENTER_FRAME,this.onEnterFrameHandler);
         }
         this._text = this._curNum + "";
         this.update();
      }
      
      private function update() : void
      {
         var s:String = null;
         var item:DisplayObject = null;
         var offset:int = 0;
         var i:int = 0;
         var numChild:int = this.numChildren;
         for(var j:int = numChild - 1; j >= 0; j--)
         {
            this.removeChildAt(i);
         }
         if(this._text == null || this._application == null)
         {
            return;
         }
         var fontArr:Array = this._text.split("");
         for each(s in fontArr)
         {
            s = transText(s);
            if(s != "")
            {
               if(this._application.hasDefinition(this._namePrefix + s))
               {
                  item = this.getInstanceByClass(this._namePrefix + s) as DisplayObject;
               }
               if(Boolean(item))
               {
                  item.x = this.width != 0 ? this.width + this._hGap : 0;
                  item.scaleX = this.sxx;
                  item.scaleY = this.syy;
                  addChild(item);
               }
            }
         }
         if(this._align == TextFormatAlign.CENTER)
         {
            offset = -this.width / 2;
         }
         else if(this._align == TextFormatAlign.RIGHT)
         {
            offset = -this.width;
         }
         if(offset != 0)
         {
            for(i = 0; i < numChildren; i++)
            {
               getChildAt(i).x = getChildAt(i).x + offset;
            }
         }
      }
      
      private function onRemoved(event:Event) : void
      {
         var item:Bitmap = null;
         for(var i:int = numChildren - 1; i >= 0; i--)
         {
            item = getChildAt(i) as Bitmap;
            if(Boolean(item))
            {
               item.bitmapData.dispose();
            }
         }
      }
   }
}

