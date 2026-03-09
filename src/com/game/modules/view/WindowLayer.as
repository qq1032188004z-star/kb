package com.game.modules.view
{
   import com.game.facade.ApplicationFacade;
   import com.game.manager.EventManager;
   import com.game.modules.control.WindowLayerControl;
   import com.publiccomponent.loading.GreenLoading;
   import com.publiccomponent.loading.Loading;
   import flash.display.Loader;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   
   public class WindowLayer extends BaseLayer
   {
      
      public static var instance:WindowLayer = new WindowLayer();
      
      private var loading:Loading;
      
      private var removeCallBack:Function;
      
      private var _initX:Number = 130;
      
      private var _initY:Number;
      
      private var loader:Loader;
      
      private var moduleParams:Object;
      
      private var spiritmask:Sprite = new Sprite();
      
      public function WindowLayer()
      {
         super();
         this.mouseEnabled = false;
         EventManager.attachEvent(this,Event.ADDED_TO_STAGE,this.onAddToStage);
      }
      
      private function onAddToStage(evt:Event) : void
      {
         EventManager.removeEvent(this,Event.ADDED_TO_STAGE,this.onAddToStage);
         this.loading = GreenLoading.loading;
         ApplicationFacade.getInstance().registerViewLogic(new WindowLayerControl(this));
      }
      
      public function openSwfView(label:String, url:String, isShowClose:Boolean = true, isDisableBg:Boolean = false, removeCallBack:Function = null, xCoord:Number = 130, yCoord:Number = 0) : void
      {
         this.graphics.clear();
         if(isDisableBg)
         {
            if("assets/login/book.swf" == url)
            {
               this.spiritmask.graphics.beginFill(0,0.8);
               this.spiritmask.graphics.drawRect(-1000,-1000,5000,5000);
               this.spiritmask.graphics.endFill();
               instance.addChild(this.spiritmask);
            }
         }
         this._initX = xCoord;
         this._initY = yCoord;
         this.removeCallBack = removeCallBack;
         this.loading.visible = true;
         this.loading.setCloseBtnShow(false);
         this.loading.loadModule(label,url,this.onCallBack);
      }
      
      public function openModule(label:String, url:String, isShowClose:Boolean = true, isDisableBg:Boolean = false, removeCallBack:Function = null, xCoord:Number = 130, yCoord:Number = 0, moduleParams:Object = null) : void
      {
         var onIoErrorHandler:Function = null;
         onIoErrorHandler = function(event:IOErrorEvent):void
         {
            O.o("【WindowLayer】" + event + url);
         };
         this.graphics.clear();
         this.moduleParams = moduleParams;
         if(isDisableBg)
         {
            this.graphics.beginFill(0,0);
            this.graphics.drawRect(-1000,-1000,5000,5000);
            this.graphics.endFill();
         }
         this._initX = xCoord;
         this._initY = yCoord;
         this.removeCallBack = removeCallBack;
         this.loading.visible = true;
         if(Boolean(this.loader))
         {
            if(Boolean(this.loader.content) && Boolean(this.loader.content.hasOwnProperty("dispos")))
            {
               this.loader["content"]["dispos"]();
            }
            if(Boolean(this.loader.content) && Boolean(this.loader.content.hasOwnProperty("disport")))
            {
               this.loader["content"]["disport"]();
            }
            this.loader.unloadAndStop(false);
            this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoaded);
         }
         this.loader = new Loader();
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoaded);
         this.loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.onProgress);
         this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onIoErrorHandler);
         this.loader.load(new URLRequest(url),new LoaderContext(false,ApplicationDomain.currentDomain));
      }
      
      private function onProgress(evt:ProgressEvent) : void
      {
         this.loading.setProgress("正在加载....",evt.bytesLoaded,evt.bytesTotal);
      }
      
      private function onLoaded(evt:Event) : void
      {
         this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoaded);
         this.loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,this.onProgress);
         if(this.loader.content.hasOwnProperty("moduleParams"))
         {
            this.loader.content["moduleParams"] = this.moduleParams;
         }
         this.onCallBack(this.loader);
      }
      
      private function onCallBack(obj:Loader) : void
      {
         this.loading.setCloseBtnShow(false);
         this.loading.visible = false;
         obj.addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoveFromStage);
         showUI(obj,this._initX,this._initY);
      }
      
      private function onRemoveFromStage(evt:Event) : void
      {
         this.loading.materialLoader.unLoaderSwf();
         this.loading.visible = false;
         if(this.removeCallBack != null)
         {
            this.removeCallBack.apply(null,[null]);
            this.removeCallBack = null;
         }
         evt.currentTarget.removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemoveFromStage);
         if(Boolean(this.spiritmask) && instance.contains(this.spiritmask))
         {
            instance.removeChild(this.spiritmask);
         }
         this.graphics.clear();
         this._initX = 0;
         this._initY = 0;
      }
   }
}

