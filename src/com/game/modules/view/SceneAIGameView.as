package com.game.modules.view
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   
   public class SceneAIGameView
   {
      
      public static var instance:SceneAIGameView = new SceneAIGameView();
      
      private var gameId:int;
      
      private var gameLoader:Loader;
      
      private var sceneAIGame:DisplayObject;
      
      public function SceneAIGameView()
      {
         super();
         this.gameLoader = new Loader();
      }
      
      private function onLoaded(evt:Event) : void
      {
         var cls:Class = null;
         this.gameLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoaded);
         var domain:ApplicationDomain = evt.currentTarget.applicationDomain;
         if(domain.hasDefinition("SceneAIGame"))
         {
            cls = domain.getDefinition("SceneAIGame") as Class;
            this.sceneAIGame = new cls();
            MapView.instance.addChild(this.sceneAIGame);
            this.sceneAIGame["startGame"](MapView.instance.masterPerson.ui);
            this.initEvent();
         }
      }
      
      private function initEvent() : void
      {
         this.sceneAIGame.addEventListener(Event.COMPLETE,this.onComplement);
      }
      
      private function onComplement(evt:Event) : void
      {
         ApplicationFacade.getInstance().dispatch(EventConst.GET_XIAO_YIN_YU);
      }
      
      public function load(id:int) : void
      {
         this.gameLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoaded);
         this.gameLoader.load(new URLRequest("assets/littlegame/sceneAIGame" + id + ".swf"));
      }
      
      public function dispos() : void
      {
         if(Boolean(this.gameLoader))
         {
            this.gameLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoaded);
            this.gameLoader.unloadAndStop(false);
         }
         if(Boolean(this.sceneAIGame))
         {
            this.sceneAIGame.removeEventListener(Event.COMPLETE,this.onComplement);
            this.sceneAIGame["clear"]();
         }
         this.sceneAIGame = null;
      }
   }
}

