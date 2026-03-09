package com.game.modules.view.login
{
   import com.channel.Message;
   import com.game.facade.ApplicationFacade;
   import com.game.modules.control.LoginViewControl;
   import com.publiccomponent.loading.GreenLoading;
   import com.publiccomponent.loading.Loading;
   import flash.display.Loader;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   
   public class LoginView extends Sprite
   {
      
      public static var instance:LoginView = new LoginView();
      
      private var loader:Loader;
      
      private var extLoader:Loader;
      
      private var loading:Loading;
      
      public function LoginView()
      {
         super();
         this.loading = GreenLoading.loading;
         this.loader = new Loader();
         this.extLoader = new Loader();
         this.extLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.extLoadComponent);
         ApplicationFacade.getInstance().registerViewLogic(new LoginViewControl(this));
      }
      
      public function load(url:String) : void
      {
         if(this.loader != null)
         {
            this.loader.unloadAndStop();
         }
         this.loading.loadModule("正在加载...",url,this.onLoaded);
      }
      
      public function loadExt(url:String) : void
      {
         if(this.extLoader == null)
         {
            return;
         }
         this.extLoader.unloadAndStop();
         if(!this.contains(this.extLoader))
         {
            this.addChild(this.extLoader);
         }
         this.extLoader.load(new URLRequest(url));
      }
      
      protected function extLoadComponent(event:Event) : void
      {
         if(this.extLoader == null)
         {
            return;
         }
         if(this.extLoader.content.hasOwnProperty("closeBtn"))
         {
            this.extLoader.content["closeBtn"].addEventListener(MouseEvent.CLICK,this.onClickClose);
         }
      }
      
      private function onClickClose(event:MouseEvent) : void
      {
         if(Boolean(this.extLoader))
         {
            this.extLoader.unloadAndStop();
         }
      }
      
      public function unload() : void
      {
         if(this.loader != null)
         {
            this.loader.unloadAndStop();
         }
      }
      
      private function onLoaded(disPlay:Loader) : void
      {
         this.loading.visible = false;
         if(this.loader != null)
         {
            if(this.contains(this.loader))
            {
               this.removeChild(this.loader);
            }
            this.loader = disPlay;
            this.addChild(this.loader);
         }
         this.initEvent();
      }
      
      private function initEvent() : void
      {
         if(this.loader.content.hasOwnProperty("startBtn"))
         {
            this.loader.content["startBtn"].addEventListener(MouseEvent.CLICK,this.onClickHandler);
         }
         if(this.loader.content.hasOwnProperty("xuzhiBtn"))
         {
            this.loader.content["xuzhiBtn"].addEventListener(MouseEvent.CLICK,this.onClickHandler);
         }
         if(this.loader.content.hasOwnProperty("shouBtn"))
         {
            this.loader.content["shouBtn"].addEventListener(MouseEvent.CLICK,this.onClickHandler);
         }
         if(this.loader.content.hasOwnProperty("createBtn"))
         {
            this.loader.content["createBtn"].addEventListener(MouseEvent.CLICK,this.onClickHandler);
         }
         if(this.loader.content.hasOwnProperty("deskBtn"))
         {
            this.loader.content["deskBtn"].addEventListener(MouseEvent.CLICK,this.onClickHandler);
         }
      }
      
      private function onClickHandler(event:MouseEvent) : void
      {
         switch(event.currentTarget.name)
         {
            case "startBtn":
               new Message("startgame",{"type":0}).sendToChannel("newhand");
               break;
            case "xuzhiBtn":
               new Message("startgame",{"type":1}).sendToChannel("newhand");
               break;
            case "shouBtn":
               new Message("startgame",{"type":2}).sendToChannel("newhand");
               break;
            case "createBtn":
               new Message("startgame",{"type":3}).sendToChannel("newhand");
               break;
            case "deskBtn":
               new Message("startgame",{"type":4}).sendToChannel("newhand");
         }
      }
      
      private function removeEvent() : void
      {
         if(this.loader.content.hasOwnProperty("startBtn"))
         {
            this.loader.content["startBtn"].removeEventListener(MouseEvent.CLICK,this.onClickHandler);
         }
         if(this.loader.content.hasOwnProperty("xuzhiBtn"))
         {
            this.loader.content["xuzhiBtn"].removeEventListener(MouseEvent.CLICK,this.onClickHandler);
         }
         if(this.loader.content.hasOwnProperty("shouBtn"))
         {
            this.loader.content["shouBtn"].removeEventListener(MouseEvent.CLICK,this.onClickHandler);
         }
         if(this.loader.content.hasOwnProperty("createBtn"))
         {
            this.loader.content["createBtn"].removeEventListener(MouseEvent.CLICK,this.onClickHandler);
         }
         if(this.loader.content.hasOwnProperty("deskBtn"))
         {
            this.loader.content["deskBtn"].removeEventListener(MouseEvent.CLICK,this.onClickHandler);
         }
      }
      
      public function dispos() : void
      {
         if(this.loader == null)
         {
            return;
         }
         if(Boolean(this.extLoader))
         {
            this.extLoader.unloadAndStop();
            this.extLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.extLoadComponent);
            this.extLoader = null;
         }
         this.removeEvent();
         this.loader.unloadAndStop();
         if(this.contains(this.loader))
         {
            this.removeChild(this.loader);
         }
         this.loader = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

