package org.engine.core
{
   import com.game.global.GlobalConfig;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import flash.utils.getDefinitionByName;
   import org.engine.util.LoaderUtil;
   
   public class GameSprite
   {
      
      public var sortIndex:int;
      
      public var sequenceID:int;
      
      private var _x:Number = 0;
      
      private var _y:Number = 0;
      
      private var _ui:DisplayObject;
      
      public var scene:Scene;
      
      public var spriteName:String;
      
      public var angle:Number = 0;
      
      public var dymaicY:Number = Math.random();
      
      public var isSupportMouse:Boolean = true;
      
      private var loaderUtil:LoaderUtil;
      
      private var rect:Rectangle;
      
      private var inputCallBack:Function;
      
      public var isAwaysShow:Boolean = false;
      
      public var sameY:Number;
      
      public function GameSprite()
      {
         super();
         this.loaderUtil = new LoaderUtil();
      }
      
      public function set x(value:Number) : void
      {
         this._x = value;
         if(this._ui != null)
         {
            this._ui.x = value;
         }
      }
      
      public function set y(value:Number) : void
      {
         this._y = value;
         if(this._ui != null)
         {
            this._ui.y = value;
         }
      }
      
      public function get x() : Number
      {
         return this._x;
      }
      
      public function get y() : Number
      {
         return this._y;
      }
      
      public function set ui(displsy:DisplayObject) : void
      {
         this._ui = displsy;
         if(this._ui != null)
         {
            this._ui.x = this._x;
            this._ui.y = this._y;
            this._ui.addEventListener(Event.ADDED_TO_STAGE,this.onAddToStage);
         }
      }
      
      private function onAddToStage(evt:Event) : void
      {
         var xScroll:Number = NaN;
         var yScroll:Number = NaN;
         var n:int = 0;
         this._ui.removeEventListener(Event.ADDED_TO_STAGE,this.onAddToStage);
         if(GlobalConfig.userId == this.sequenceID)
         {
            xScroll = 0;
            yScroll = 0;
            if(this.scene.bg && this.scene.isBig)
            {
               n = int(this.x / 970);
               xScroll = -(this.x - n * 970) * 0.5 - n * 970;
               if(xScroll < 970 - this.scene.bg.width)
               {
                  xScroll = 970 - this.scene.bg.width;
               }
               n = int(this.y / 570);
               yScroll = -(this.y - n * 570) * 0.5 - n * 570;
               if(yScroll < 570 - this.scene.bg.height)
               {
                  yScroll = 570 - this.scene.bg.height;
               }
            }
            this.scene.bg.x = xScroll;
            this.scene.bg.y = yScroll;
            this._ui.parent.x = xScroll;
            this._ui.parent.y = yScroll;
         }
      }
      
      public function get ui() : DisplayObject
      {
         return this._ui;
      }
      
      public function set alpha(value:Number) : void
      {
         if(this._ui != null)
         {
            this._ui.alpha = value;
         }
      }
      
      public function getTile() : Tile
      {
         return this.scene.map.getTileByPos(this.x,this.y);
      }
      
      public function get sortY() : Number
      {
         if(this.ui != null)
         {
            this.rect = this.ui.getRect(this.ui);
            return this.rect.bottom + this.y - this.dymaicY;
         }
         return this.y;
      }
      
      public function get centerX() : Number
      {
         if(this.ui != null)
         {
            return this.x + this.ui.width / 2;
         }
         return this.x;
      }
      
      public function get centerY() : Number
      {
         if(this.ui != null)
         {
            return this.y + this.ui.height / 2;
         }
         return this.y;
      }
      
      public function get maxX() : Number
      {
         if(this.ui != null)
         {
            return this.x + this.ui.width;
         }
         return this.x;
      }
      
      public function get maxY() : Number
      {
         if(this.ui != null)
         {
            return this.y + this.ui.height;
         }
         return this.y;
      }
      
      public function set hideable(value:Boolean) : void
      {
         if(this.ui != null)
         {
            this.ui.visible = value;
         }
      }
      
      public function get hideable() : Boolean
      {
         if(this.ui != null)
         {
            return this.ui.visible;
         }
         return true;
      }
      
      public function set filters(value:Array) : void
      {
         if(this.ui != null)
         {
            this.ui.filters = value;
         }
      }
      
      public function zoom() : void
      {
      }
      
      public function normal() : void
      {
      }
      
      public function set url(urlString:String) : void
      {
         var URLUtil:* = undefined;
         try
         {
            URLUtil = getDefinitionByName("com.publiccomponent.URLUtil");
            urlString = URLUtil.getSvnVer(urlString);
         }
         catch(e:*)
         {
            trace("【gameSpirit获取版本号异常】" + e);
         }
         this.loaderUtil.load(urlString,this.callBack);
      }
      
      private function callBack(disPlay:Loader) : void
      {
         this.ui = disPlay;
         if(!this.isSupportMouse)
         {
            this.ui["mouseEnabled"] = false;
            this.ui["mouseChildren"] = false;
         }
      }
      
      public function setUrl(urlString:String, inputCallBack:Function) : void
      {
         var URLUtil:* = undefined;
         try
         {
            URLUtil = getDefinitionByName("com.publiccomponent.URLUtil");
            urlString = URLUtil.getSvnVer(urlString);
         }
         catch(e:*)
         {
            trace("【gameSpirit获取版本号异常】" + e);
         }
         this.inputCallBack = inputCallBack;
         this.loaderUtil.load(urlString,this.loadComplete);
      }
      
      private function loadComplete(disPlay:Loader) : void
      {
         this.ui = disPlay;
         if(this.inputCallBack != null)
         {
            this.inputCallBack(disPlay);
         }
      }
      
      public function initDirection(direct:int = 0) : void
      {
      }
      
      public function dispos() : void
      {
         if(this.ui != null)
         {
            this._ui.removeEventListener(Event.ADDED_TO_STAGE,this.onAddToStage);
            this.ui.filters = null;
            if(this.ui is Loader)
            {
               this.ui["unloadAndStop"](false);
            }
            else if(this.ui is MovieClip)
            {
               this.ui["stop"]();
            }
            if(this.ui.parent != null)
            {
               if(this.ui.parent is DisplayObjectContainer)
               {
                  this.ui.parent.removeChild(this.ui);
               }
            }
            if(this.scene != null)
            {
               this.scene.remove(this);
            }
            this.ui = null;
         }
         if(Boolean(this.loaderUtil))
         {
            this.loaderUtil.dispos();
         }
         this.loaderUtil = null;
         this.inputCallBack = null;
      }
   }
}

