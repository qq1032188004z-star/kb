package org.engine.core
{
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import flash.utils.getTimer;
   
   public class Render
   {
      
      private static var _instance:Render;
      
      private var objContainer:DisplayObjectContainer;
      
      private var debugContainer:Sprite;
      
      private var bgNow:DisplayObject;
      
      private var renderList:Array = [];
      
      private var item:GameSprite;
      
      private var ui:DisplayObject;
      
      private var len:int;
      
      private var count:int;
      
      private var isRender:Boolean;
      
      private var renderRect:Rectangle;
      
      private var tempList:Array = [];
      
      private var _timeShape:Shape;
      
      private var _renderVec:Vector.<DelayNode>;
      
      public function Render()
      {
         super();
         this.init();
         this.objContainer = new Sprite();
         this.renderRect = new Rectangle(-970,-570,1200,800);
      }
      
      public static function get instance() : Render
      {
         if(_instance == null)
         {
            _instance = new Render();
         }
         return _instance;
      }
      
      private function init() : void
      {
         this._timeShape = new Shape();
         this._timeShape.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         this._renderVec = new Vector.<DelayNode>();
      }
      
      public function isInRenderRect(item:GameSprite) : Boolean
      {
         this.renderRect.x = -this.objContainer.x - 100;
         this.renderRect.y = -this.objContainer.y - 100;
         if(this.renderRect.contains(item.centerX,item.centerY))
         {
            return true;
         }
         return false;
      }
      
      public function render(scene:Scene, viewport:Viewport) : void
      {
         this.displayBg(scene,viewport);
         this.sort(scene,viewport);
         this.display(scene,viewport);
         this.isRender = false;
         ++this.count;
         if(this.count > 5)
         {
            this.isRender = true;
            this.count = 0;
         }
      }
      
      private function displayBg(scene:Scene, viewport:Viewport) : void
      {
         this.tempList = [];
         var container:DisplayObjectContainer = viewport.container;
         if(this.bgNow != scene.bg)
         {
            if(this.bgNow != null && container.contains(this.bgNow))
            {
               if(this.bgNow.hasOwnProperty("unloadAndStop"))
               {
                  if(this.bgNow["content"] is DisplayObjectContainer)
                  {
                     this.removeAllChild(this.bgNow["content"]);
                  }
                  this.bgNow["unloadAndStop"](false);
               }
               if(this.bgNow.hasOwnProperty("dispos"))
               {
                  this.bgNow["dispos"]();
               }
               if(this.bgNow != null && container.contains(this.bgNow))
               {
                  container.removeChild(this.bgNow);
               }
               this.bgNow = null;
            }
            if(scene.bg != null)
            {
               container.addChildAt(scene.bg,0);
               container.addChildAt(this.objContainer,1);
            }
            this.bgNow = scene.bg;
         }
      }
      
      private function removeAllChild(bgDisplay:DisplayObjectContainer) : void
      {
         var disItem:DisplayObject = null;
         if(bgDisplay == null)
         {
            return;
         }
         while(bgDisplay.numChildren > 0)
         {
            disItem = bgDisplay.getChildAt(0);
            if(disItem is Bitmap)
            {
               if(disItem["bitmapdata"] != null)
               {
                  disItem["bitmapdata"]["dispos"]();
               }
            }
            bgDisplay.removeChild(disItem);
         }
      }
      
      private function removeDisplayObject(bgObject:DisplayObject) : void
      {
         if(bgObject == null)
         {
            return;
         }
         if(bgObject is Bitmap)
         {
            if(bgObject["bitmapdata"] != null)
            {
               bgObject["bitmapdata"]["dispos"]();
            }
         }
         if(Boolean(bgObject.parent))
         {
            bgObject.parent.removeChild(bgObject);
         }
      }
      
      private function sort(scene:Scene, viewport:Viewport) : void
      {
         if(this.isRender)
         {
            this.renderList = scene.spriteList;
            if(scene.isScroll && this.objContainer.numChildren > 0 && scene.isAllDisplay)
            {
               this.renderList = this.processInRender();
            }
            this.renderList.sortOn("sortY",Array.NUMERIC);
         }
      }
      
      private function processInRender() : Array
      {
         var item:GameSprite = null;
         this.tempList.length = 0;
         for each(item in this.renderList)
         {
            if(this.isInRenderRect(item) || item.isAwaysShow)
            {
               this.tempList.push(item);
            }
         }
         return this.tempList;
      }
      
      private function display(scene:Scene, viewport:Viewport) : void
      {
         this.len = this.renderList.length;
         for(var i:int = 0; i < this.len; i++)
         {
            this.item = this.renderList[i];
            this.ui = this.item.ui;
            if(this.ui != null)
            {
               if(this.objContainer.contains(this.ui))
               {
                  if(this.isRender && this.objContainer.getChildIndex(this.ui) != i)
                  {
                     if(this.objContainer.numChildren > i)
                     {
                        this.objContainer.swapChildrenAt(this.objContainer.getChildIndex(this.ui),i);
                     }
                  }
               }
               else
               {
                  this.objContainer.addChild(this.ui);
               }
            }
         }
      }
      
      public function dispose() : void
      {
         var len:int = 0;
         if(Boolean(this._timeShape))
         {
            this._timeShape.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
            this._timeShape = null;
         }
         if(Boolean(this._renderVec))
         {
            len = int(this._renderVec.length);
            while(Boolean(len--))
            {
               this._renderVec.pop().callBack = null;
            }
            this._renderVec = null;
         }
         _instance = null;
      }
      
      private function onEnterFrame(evt:Event) : void
      {
         var len:int = 0;
         var item:DelayNode = null;
         var now:int = getTimer();
         if(this._renderVec.length > 0)
         {
            for(len = int(this._renderVec.length); len > 0; )
            {
               item = this._renderVec[len - 1];
               if(now - item.lastDealTime > item.delay)
               {
                  item.lastDealTime = now;
                  if(item.callBack != null)
                  {
                     item.callBack();
                  }
               }
               len--;
            }
         }
      }
      
      public function addRenderDelay(func:Function, delay:int) : void
      {
         var delayNode:DelayNode = new DelayNode();
         delayNode.callBack = func;
         delayNode.delay = delay;
         delayNode.lastDealTime = getTimer();
         this._renderVec.push(delayNode);
      }
      
      public function removeRender(func:Function) : void
      {
         var item:DelayNode = null;
         var len:int = int(this._renderVec.length);
         if(len > 0)
         {
            while(len > 0)
            {
               item = this._renderVec[len - 1];
               if(item.callBack == func)
               {
                  item.callBack = null;
                  this._renderVec.splice(len,1);
               }
               len--;
            }
         }
      }
   }
}

class DelayNode
{
   
   public var callBack:Function;
   
   public var delay:int;
   
   public var lastDealTime:int;
   
   public function DelayNode()
   {
      super();
   }
}
