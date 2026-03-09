package com.game.util
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.modules.control.LittlegameControl;
   import com.publiccomponent.URLUtil;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   
   public class LittleGameStartUI extends Sprite
   {
      
      private var loader:Loader;
      
      private var mc:MovieClip;
      
      private var _gameid:int = -1;
      
      private var shape:Sprite;
      
      public function LittleGameStartUI()
      {
         super();
         this.loader = new Loader();
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoadComplete);
         this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
         this.loader.load(new URLRequest(URLUtil.getSvnVer("assets/material/littlegamestart.swf")));
      }
      
      private function onLoadComplete(evt:Event) : void
      {
         this.shape = new Sprite();
         this.shape.graphics.beginFill(16777215,0);
         this.shape.graphics.drawRect(0,0,970,570);
         this.shape.graphics.endFill();
         this.addChildAt(this.shape,0);
         this.shape.x = 0;
         this.shape.y = 0;
         this.shape.mouseEnabled = false;
         this.mc = (this.loader.getChildAt(0) as MovieClip).getChildAt(0) as MovieClip;
         this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoadComplete);
         this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
         this.loader = null;
         this.addChild(this.mc);
         this.mc.x = 323;
         this.mc.y = 171;
         if(this._gameid != -1)
         {
            this.show();
         }
      }
      
      public function startLittleGame(gameid:int) : void
      {
         this._gameid = gameid;
         if(this.mc != null)
         {
            this.show();
         }
      }
      
      private function show() : void
      {
         this.loader = new Loader();
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoadImgComplete);
         this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onLoadImgError);
         this.loader.load(new URLRequest(URLUtil.getSvnVer("assets/littlegame/startimg/" + this._gameid + ".swf")));
      }
      
      private function onLoadImgComplete(evt:Event) : void
      {
         this.visible = true;
         this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoadImgComplete);
         this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoadImgError);
         this.mc.imgBG.addChildAt(this.loader,0);
         this.loader.x = 0;
         this.loader.y = 0;
         this.mc.close.addEventListener(MouseEvent.CLICK,this.onMouseClickClose);
         this.mc.startBtn.addEventListener(MouseEvent.CLICK,this.onMouseClickStart);
      }
      
      private function onLoadImgError(evt:IOErrorEvent) : void
      {
         this.loader.load(new URLRequest(URLUtil.getSvnVer("assets/littlegame/startimg/4.swf")));
      }
      
      private function onLoadError(evt:IOErrorEvent) : void
      {
         O.o("【小游戏开始UI加载失败了....】",evt);
         this.dispos();
      }
      
      private function releaseLoader() : void
      {
         if(this.loader != null)
         {
            this.loader.unloadAndStop();
            this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoadImgComplete);
            this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoadImgError);
            this.loader = null;
         }
      }
      
      private function onMouseClickClose(evt:MouseEvent) : void
      {
         this.dispos();
      }
      
      private function onMouseClickStart(evt:MouseEvent) : void
      {
         this.visible = false;
         if(ApplicationFacade.getInstance().retrieveViewLogic(LittlegameControl.NAME) == null)
         {
            ApplicationFacade.getInstance().registerViewLogic(new LittlegameControl());
         }
         ApplicationFacade.getInstance().dispatch(EventConst.LITTLE_GAME_START,this._gameid);
         this.dispos();
      }
      
      public function dispos() : void
      {
         this.releaseLoader();
         this._gameid = -1;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
         if(this.mc != null)
         {
            this.mc.close.removeEventListener(MouseEvent.CLICK,this.onMouseClickClose);
            this.mc.startBtn.removeEventListener(MouseEvent.CLICK,this.onMouseClickStart);
            this.mc.imgBG.removeChildAt(0);
         }
      }
   }
}

