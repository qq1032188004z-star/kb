package com.game.modules.view
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.locators.CacheData;
   import com.game.manager.EventManager;
   import com.publiccomponent.URLUtil;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   
   public class BatchUseClip extends Sprite
   {
      
      private var loader:Loader;
      
      private var data:Object;
      
      public function BatchUseClip()
      {
         super();
         this.mouseEnabled = false;
         this.buttonMode = true;
         this.initliaze();
      }
      
      private function initliaze() : void
      {
         this.loader = new Loader();
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onCompleteHandler);
         this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onIoErrorHandler);
         this.loader.load(new URLRequest(URLUtil.getSvnVer("assets/tool/batchUse.swf")));
         addChild(this.loader);
         EventManager.attachEvent(this,MouseEvent.ROLL_OUT,this.onRollOutHandler);
      }
      
      public function setData($container:DisplayObjectContainer, $value:Object, $xCoode:int, $yCoode:int) : void
      {
         this.data = $value;
         this.x = $xCoode;
         this.y = $yCoode;
         this.visible = true;
         $container.addChild(this);
      }
      
      private function onCompleteHandler(e:Event) : void
      {
         var mc:MovieClip = this.loader.content as MovieClip;
         EventManager.attachEvent(mc["btn"],MouseEvent.MOUSE_DOWN,this.onMouseDownHandler);
      }
      
      private function onIoErrorHandler(e:IOErrorEvent) : void
      {
         e.stopImmediatePropagation();
      }
      
      private function onMouseDownHandler(e:MouseEvent) : void
      {
         e.stopImmediatePropagation();
         if(this.data != null)
         {
            if(CacheData.instance.openState == 1)
            {
               ApplicationFacade.getInstance().dispatch(EventConst.S_BATCHUSEPROP_PACK,this.data);
            }
            else if(CacheData.instance.openState == 2)
            {
               ApplicationFacade.getInstance().dispatch(EventConst.S_BATCHUSEPROP_MONSTER,this.data);
            }
         }
         this.onRollOutHandler(null);
      }
      
      public function onRollOutHandler(e:MouseEvent) : void
      {
         this.visible = false;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
      
      public function disport() : void
      {
         if(Boolean(this.loader))
         {
            this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onIoErrorHandler);
            this.loader.unloadAndStop();
            this.loader = null;
         }
         if(Boolean(this.parent))
         {
            if(this.parent is Loader)
            {
               (this.parent as Loader).unloadAndStop();
            }
            else
            {
               this.parent.removeChild(this);
            }
         }
      }
   }
}

