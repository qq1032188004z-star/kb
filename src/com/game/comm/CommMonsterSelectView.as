package com.game.comm
{
   import com.core.observer.MessageEvent;
   import com.game.locators.GlobalAPI;
   import com.game.manager.EventManager;
   import com.game.util.DisplayUtil;
   import com.greensock.OverwriteManager;
   import com.greensock.TweenMax;
   import com.kb.util.CommonDefine;
   import com.publiccomponent.ui.ToolTip;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.system.ApplicationDomain;
   import flash.utils.ByteArray;
   
   public class CommMonsterSelectView extends Sprite
   {
      
      public static const SELECT_CHANGE:String = "monster_select_change";
      
      public static const TYPE_DEPARTMENT:int = 0;
      
      public static const TYPE_QUALIFICATIONS:int = 1;
      
      public static const TYPE_GROUP:int = 3;
      
      public static const TYPE_SEX:int = 2;
      
      public static const TYPE_SORT:int = 5;
      
      private var EmbeddedSWF:Class;
      
      private var _type:int;
      
      private var _selectOrder:int;
      
      private var _skinAry:Array;
      
      private var _appDomain:ApplicationDomain;
      
      private var _btnSelect:MovieClip;
      
      private var _spSelect:Sprite;
      
      private var _enabled:Boolean;
      
      private var closeObj:Object;
      
      private var openObj:Object;
      
      public function CommMonsterSelectView(type:int, selectOrder:int = 0, skinAry:Array = null, app:ApplicationDomain = null)
      {
         var swfBytes:ByteArray = null;
         var loader:Loader = null;
         this.EmbeddedSWF = CommMonsterSelectView_EmbeddedSWF;
         super();
         this._type = type;
         this._selectOrder = selectOrder;
         if(skinAry == null)
         {
            this._skinAry = [0,0];
         }
         else
         {
            this._skinAry = skinAry;
         }
         if(app != null)
         {
            this._appDomain = app;
            this.appLoader();
         }
         else
         {
            swfBytes = new this.EmbeddedSWF();
            loader = new Loader();
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoadComplete);
            loader.loadBytes(swfBytes);
         }
      }
      
      private function onLoadComplete(event:Event) : void
      {
         var loader:Loader = Loader(event.target.loader);
         this._appDomain = loader.contentLoaderInfo.applicationDomain;
         this.appLoader();
      }
      
      private function appLoader() : void
      {
         this.initView();
         this.initEvent();
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      private function getInstanceByClass(className:String) : Object
      {
         if(Boolean(this._appDomain))
         {
            if(this._appDomain.hasDefinition(className))
            {
               return new (this._appDomain.getDefinition(className) as Class)();
            }
         }
         return null;
      }
      
      private function initView() : void
      {
         switch(this._type)
         {
            case TYPE_DEPARTMENT:
               this._btnSelect = this.getInstanceByClass("mcDep_" + this._skinAry[0]) as MovieClip;
               this._spSelect = this.getInstanceByClass("spDep_" + this._skinAry[1]) as Sprite;
               break;
            case TYPE_QUALIFICATIONS:
               this._btnSelect = this.getInstanceByClass("mcQua_" + this._skinAry[0]) as MovieClip;
               this._spSelect = this.getInstanceByClass("spQua_" + this._skinAry[1]) as Sprite;
               break;
            case TYPE_GROUP:
               this._btnSelect = this.getInstanceByClass("mcGroup_" + this._skinAry[0]) as MovieClip;
               this._spSelect = this.getInstanceByClass("spGroup_" + this._skinAry[1]) as Sprite;
               break;
            case TYPE_SEX:
               this._btnSelect = this.getInstanceByClass("mcSex_" + this._skinAry[0]) as MovieClip;
               this._spSelect = this.getInstanceByClass("spSex_" + this._skinAry[1]) as Sprite;
               break;
            case TYPE_SORT:
               this._btnSelect = this.getInstanceByClass("mcSort_" + this._skinAry[0]) as MovieClip;
               this._spSelect = this.getInstanceByClass("spSort_" + this._skinAry[1]) as Sprite;
         }
         if(Boolean(this._btnSelect))
         {
            this._btnSelect.buttonMode = true;
            this.addChild(this._btnSelect);
         }
         if(Boolean(this._spSelect))
         {
            this.addChild(this._spSelect);
            this.initAction();
         }
         this.bindDO();
         this._btnSelect.gotoAndStop(this._selectOrder + 1);
         this.hide();
         this.enabled = true;
      }
      
      private function initAction() : void
      {
         this.closeObj = {
            "width":30,
            "height":10,
            "autoAlpha":0,
            "overwrite":OverwriteManager.AUTO,
            "onComplete":this.onCompleteHandler
         };
         this.openObj = {
            "width":this._spSelect.width,
            "height":this._spSelect.height,
            "overwrite":OverwriteManager.AUTO,
            "autoAlpha":1
         };
         this._spSelect.width = 30;
         this._spSelect.height = 10;
         this._spSelect.alpha = 0;
         this.onCompleteHandler();
      }
      
      private function onCompleteHandler() : void
      {
         if(this.contains(this._spSelect))
         {
            this.removeChild(this._spSelect);
         }
      }
      
      private function bindDO() : void
      {
         var length:int = 0;
         var targetName:String = null;
         var targetIndex:int = 0;
         var i:int = 0;
         var display:DisplayObject = null;
         switch(this._type)
         {
            case TYPE_DEPARTMENT:
               length = int(this._spSelect["btnClip"].numChildren);
               for(i = 0; i < length; i++)
               {
                  display = this._spSelect["btnClip"].getChildAt(i);
                  targetName = display.name;
                  if(targetName.indexOf("btn") != -1)
                  {
                     targetIndex = int(targetName.substr(3));
                     if(targetIndex != 0)
                     {
                        ToolTip.BindDO(display,CommonDefine.departList[targetIndex - 1]);
                     }
                  }
               }
         }
      }
      
      private function setSelectOrder(select:int) : void
      {
         if(this._selectOrder != select)
         {
            this.setOrder(select);
            dispatchEvent(new Event(SELECT_CHANGE));
         }
      }
      
      public function get type() : int
      {
         return this._type;
      }
      
      public function setOrder(order:int) : void
      {
         this._selectOrder = order;
         this._btnSelect.gotoAndStop(this._selectOrder + 1);
      }
      
      private function looseDO() : void
      {
         var length:int = 0;
         var i:int = 0;
         switch(this._type)
         {
            case TYPE_DEPARTMENT:
               length = int(this._spSelect["btnClip"].numChildren);
               for(i = 0; i < length; i++)
               {
                  ToolTip.LooseDO(this._spSelect["btnClip"].getChildAt(i));
               }
         }
      }
      
      public function get selectOrder() : int
      {
         return this._selectOrder;
      }
      
      private function initEvent() : void
      {
         EventManager.attachEvent(this._btnSelect,MouseEvent.CLICK,this.onSelectBtnHandler);
         EventManager.attachEvent(this._spSelect["btnClose"],MouseEvent.CLICK,this.onSelectCloseHandler);
         EventManager.attachEvent(this._spSelect["btnClip"],MouseEvent.CLICK,this.onBtnClipHandler);
         GlobalAPI.eventDispatcher.addEventListener("comm_monster_open_select",this.onOpenSelect);
      }
      
      private function onSelectCloseHandler(evt:MouseEvent) : void
      {
         if(!this._enabled)
         {
            return;
         }
         evt.stopImmediatePropagation();
         this.hide();
      }
      
      private function onBtnClipHandler(evt:MouseEvent) : void
      {
         var index:int = 0;
         if(!this._enabled)
         {
            return;
         }
         evt.stopImmediatePropagation();
         var targetName:String = evt.target.name;
         this.hide();
         if(targetName.indexOf("btn") != -1)
         {
            index = int(targetName.substr(3));
            this.setSelectOrder(index);
         }
      }
      
      private function onSelectBtnHandler(evt:MouseEvent) : void
      {
         if(!this._enabled)
         {
            return;
         }
         evt.stopImmediatePropagation();
         if(this.contains(this._spSelect))
         {
            this.hide();
         }
         else
         {
            this.show();
         }
      }
      
      public function hide() : void
      {
         if(this.contains(this._spSelect))
         {
            TweenMax.to(this._spSelect,0.4,this.closeObj);
         }
      }
      
      public function show() : void
      {
         if(!this.contains(this._spSelect))
         {
            this.addChild(this._spSelect);
            TweenMax.to(this._spSelect,0.4,this.openObj);
            GlobalAPI.eventDispatcher.dispatchEvent(new MessageEvent("comm_monster_open_select",this._type));
         }
      }
      
      private function onRemove() : void
      {
         if(Boolean(this._btnSelect))
         {
            EventManager.removeEvent(this._btnSelect,MouseEvent.CLICK,this.onSelectBtnHandler);
         }
         if(Boolean(this._spSelect))
         {
            EventManager.removeEvent(this._spSelect["btnClose"],MouseEvent.CLICK,this.onSelectCloseHandler);
            EventManager.removeEvent(this._spSelect["btnClip"],MouseEvent.CLICK,this.onBtnClipHandler);
         }
         GlobalAPI.eventDispatcher.removeEventListener("comm_monster_open_select",this.onOpenSelect);
      }
      
      private function onOpenSelect(event:MessageEvent) : void
      {
         var type:int = int(event.body);
         if(type != this._type)
         {
            this.hide();
         }
      }
      
      public function set orderEnabled(ary:Array) : void
      {
         var num:int = 0;
         var btnC:Sprite = this._spSelect["btnClip"];
         for(var i:int = 0; i < ary.length; i++)
         {
            num = int(ary[i]);
            if(btnC.hasOwnProperty("btn" + (i + 1)))
            {
               btnC["btn" + (i + 1)].mouseEnabled = num == 0;
               if(!num == 0)
               {
                  DisplayUtil.grayDisplayObject(btnC["btn" + (i + 1)]);
               }
               else
               {
                  DisplayUtil.ungrayDisplayObject(btnC["btn" + (i + 1)]);
               }
            }
         }
      }
      
      public function set enabled(flag:Boolean) : void
      {
         this._enabled = flag;
         this.mouseChildren = this.mouseEnabled = flag;
         if(!flag)
         {
            this._btnSelect.gotoAndStop(1);
            DisplayUtil.grayDisplayObject(this._btnSelect);
            this.hide();
         }
         else
         {
            DisplayUtil.ungrayDisplayObject(this._btnSelect);
         }
      }
      
      public function disport() : void
      {
         this.looseDO();
         this.onRemove();
      }
   }
}

