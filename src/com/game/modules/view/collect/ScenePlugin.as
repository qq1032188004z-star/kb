package com.game.modules.view.collect
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.util.IdName;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import org.engine.core.GameSprite;
   
   public class ScenePlugin extends GameSprite
   {
      
      private var uiSkin:MovieClip;
      
      private var callBack:Function;
      
      private var loader:Loader;
      
      private var goObj:String;
      
      private var _url:String;
      
      public function ScenePlugin(param:Object)
      {
         super();
         try
         {
            this.loader = new Loader();
            this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoadComplement);
            this.x = param.x;
            this.y = param.y;
            this.sequenceID = param.sequenceID;
            this.goObj = param.goObj;
            this.spriteName = IdName.stone(param.sequenceID);
            this._url = param.url;
            ui = new Sprite();
         }
         catch(e:*)
         {
         }
      }
      
      public function load(url:String, callBack:Function = null) : void
      {
         this.callBack = callBack;
         this.loader.load(new URLRequest(this._url));
      }
      
      private function addChild(display:DisplayObject) : void
      {
         Sprite(ui).addChild(display);
      }
      
      private function removeChild(display:MovieClip) : void
      {
         if(Sprite(ui).contains(display))
         {
            Sprite(ui).removeChild(display);
            display.stop();
            display = null;
         }
      }
      
      override public function dispos() : void
      {
         this.loader.unloadAndStop();
         if(this.uiSkin != null)
         {
            this.uiSkin.stop();
            this.uiSkin.removeEventListener(MouseEvent.CLICK,this.onClickStone);
            this.removeChild(this.uiSkin);
            this.uiSkin = null;
         }
         super.dispos();
      }
      
      private function onLoadComplement(evt:Event) : void
      {
         var cls:Class = null;
         this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoadComplement);
         var domain:ApplicationDomain = evt.currentTarget.applicationDomain as ApplicationDomain;
         if(domain == null)
         {
            return;
         }
         if(domain.hasDefinition("plugin"))
         {
            cls = domain.getDefinition("plugin") as Class;
            this.uiSkin = new cls() as MovieClip;
            if(this.uiSkin != null)
            {
               this.uiSkin.buttonMode = true;
               this.uiSkin.addEventListener(MouseEvent.MOUSE_DOWN,this.onClickStone);
               this.addChild(this.uiSkin);
            }
         }
      }
      
      private function onClickStone(evt:MouseEvent) : void
      {
         var ary:Array = this.goObj.split("#");
         switch(ary[0])
         {
            case "scene":
               ApplicationFacade.getInstance().dispatch(EventConst.ENTERSCENE,ary[1]);
               break;
            case "act":
               ApplicationFacade.getInstance().dispatch(EventConst.BOBSTATECLICK,{"url":ary[1]});
         }
      }
   }
}

