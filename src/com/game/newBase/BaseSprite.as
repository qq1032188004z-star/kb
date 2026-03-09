package com.game.newBase
{
   import com.core.observer.MessageEvent;
   import com.game.Tools.RectButton;
   import com.game.util.DisplayUtil;
   import com.game.util.MovieClipUtil;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.IEventDispatcher;
   import flash.events.MouseEvent;
   import flash.system.ApplicationDomain;
   
   public class BaseSprite extends Sprite
   {
      
      public static const CLOSE_MAIN_VIEW:String = "close_main_view";
      
      public static const SIMPLE_BUTTON:int = 1;
      
      public static const RECT_BUTTON:int = 2;
      
      private var _btnList:Vector.<DisplayObject>;
      
      protected var _application:ApplicationDomain;
      
      protected var _dis:IEventDispatcher;
      
      protected var uiSkin:DisplayObjectContainer;
      
      protected var _btnClose:*;
      
      public function BaseSprite(res:* = null, skinName:String = null, dis:IEventDispatcher = null)
      {
         super();
         this._dis = dis;
         this._btnList = new Vector.<DisplayObject>();
         if(res != null)
         {
            this.initSkin(res,skinName);
         }
      }
      
      protected function initSkin(res:*, skinName:String = null) : void
      {
         if(res is ApplicationDomain)
         {
            this._application = res;
            if(Boolean(skinName))
            {
               this.uiSkin = this.getInstanceByClass(skinName) as Sprite;
               addChild(this.uiSkin);
            }
         }
         else if(res is DisplayObjectContainer)
         {
            this.uiSkin = res;
         }
         if(this.uiSkin != null)
         {
            this.uiSkin.cacheAsBitmap = true;
            if(this.uiSkin.hasOwnProperty("btnClose"))
            {
               this.setCloseBtn(this.uiSkin["btnClose"]);
            }
            this.initView();
            this.initEvent();
         }
      }
      
      override public function get visible() : Boolean
      {
         return this.uiSkin.visible;
      }
      
      override public function set visible(value:Boolean) : void
      {
         this.uiSkin.visible = value;
      }
      
      public function setCloseBtn(button:DisplayObject) : void
      {
         if(button == null || button.parent == null)
         {
            return;
         }
         if(button is SimpleButton)
         {
            this._btnClose = button as SimpleButton;
         }
         else
         {
            this._btnClose = this.createMyBtn(RECT_BUTTON,button,false);
            if(Boolean(this._btnClose.parent))
            {
               this._btnClose.parent.addChild(this._btnClose);
            }
         }
         this._btnClose.addEventListener(MouseEvent.CLICK,this.onCloseHandler);
      }
      
      protected function initView() : void
      {
      }
      
      protected function initEvent() : void
      {
      }
      
      protected function removeEvent() : void
      {
      }
      
      protected function childDisport() : void
      {
      }
      
      public function disport() : void
      {
         var display:DisplayObject = null;
         this.removeEvent();
         this.childDisport();
         this._application = null;
         this.graphics.clear();
         if(this._btnClose)
         {
            if(Boolean(this._btnClose.hasEventListener(MouseEvent.CLICK)))
            {
               this._btnClose.removeEventListener(MouseEvent.CLICK,this.onCloseHandler);
            }
            this._btnClose = null;
         }
         if(this.uiSkin != null)
         {
            this.onFiguredChildren(this.uiSkin);
            if(Boolean(this.uiSkin.parent))
            {
               this.uiSkin.parent.removeChild(this.uiSkin);
            }
            this.uiSkin = null;
         }
         if(Boolean(this._btnList))
         {
            for each(display in this._btnList)
            {
               if(display is RectButton)
               {
                  (display as RectButton).onRemoveRect();
               }
            }
            this._btnList = null;
         }
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
      
      protected function onFiguredChildren(target:DisplayObjectContainer) : void
      {
         var i:int = 0;
         var obj:DisplayObject = null;
         var num:Number = target.numChildren;
         for(i = num - 1; i >= 0; i--)
         {
            obj = target.getChildAt(i) as DisplayObject;
            if(Boolean(obj))
            {
               if(obj is DisplayObjectContainer)
               {
                  this.onFiguredChildren(DisplayObjectContainer(obj));
               }
               else if(obj is MovieClip)
               {
                  MovieClipUtil.stopMovieClip(obj as MovieClip);
               }
            }
         }
      }
      
      protected function onCloseHandler(e:MouseEvent) : void
      {
         dispatchEvent(new MessageEvent(CLOSE_MAIN_VIEW));
      }
      
      protected function relateSimpleBtns(... args) : void
      {
         this.relateSimpleBtnsByParent(this.uiSkin,args);
      }
      
      protected function relateSimpleBtnsByParent(par:DisplayObjectContainer, args:Array) : void
      {
         var btnName:String = null;
         for each(btnName in args)
         {
            this[btnName] = this.createMyBtn(SIMPLE_BUTTON,par[btnName]);
         }
      }
      
      protected function relateRectBtns(... args) : void
      {
         this.relateRectBtnsByParent(this.uiSkin,args);
      }
      
      protected function btnsNoDisable(... args) : void
      {
         var btnName:String = null;
         for each(btnName in args)
         {
            if(this[btnName] is RectButton)
            {
               this[btnName].setDisable(true);
            }
            else if(this[btnName] is SimpleButton)
            {
               this[btnName].mouseEnabled = false;
               DisplayUtil.grayDisplayObject(this[btnName]);
            }
         }
      }
      
      protected function relateRectBtnsByParent(par:DisplayObjectContainer, args:Array) : void
      {
         var btnName:String = null;
         for each(btnName in args)
         {
            this[btnName] = this.createMyBtn(RECT_BUTTON,par[btnName]);
         }
      }
      
      protected function relateTextFields(... args) : void
      {
         this.relateTextFieldsByParent(this.uiSkin,args);
      }
      
      protected function relateTextFieldsByParent(par:DisplayObjectContainer, args:Array) : void
      {
         var btnName:String = null;
         for each(btnName in args)
         {
            this[btnName] = par[btnName];
         }
      }
      
      protected function relateDisplayObjectContainer(... args) : void
      {
         this.relateDisplayObjectContainerByParent(this.uiSkin,args);
      }
      
      protected function relateDisplayObjectContainerByParent(par:DisplayObjectContainer, args:Array) : void
      {
         var btnName:String = null;
         for each(btnName in args)
         {
            this[btnName] = par[btnName];
         }
      }
      
      protected function createMyBtn(type:int, displayObj:DisplayObject, needListener:Boolean = true) : DisplayObject
      {
         var btn:DisplayObject = null;
         switch(type)
         {
            case SIMPLE_BUTTON:
               btn = displayObj;
               break;
            case RECT_BUTTON:
               btn = DisplayUtil.getRectButton(displayObj);
         }
         this._btnList.push(btn);
         if(needListener)
         {
            btn.addEventListener(MouseEvent.CLICK,this.onMyBtnMouseClick,false,0,true);
         }
         return btn;
      }
      
      protected function onMyBtnMouseClick(event:MouseEvent) : void
      {
      }
      
      public function getInstanceByClass(className:String) : Object
      {
         return new (this._application.getDefinition(className) as Class)();
      }
   }
}

