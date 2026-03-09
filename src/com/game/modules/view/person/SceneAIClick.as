package com.game.modules.view.person
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.manager.MouseManager;
   import com.game.modules.view.MapView;
   import com.game.util.IdName;
   import com.game.util.SceneAIBase;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.system.ApplicationDomain;
   
   public class SceneAIClick extends SceneAIBase
   {
      
      private var callback:Function;
      
      private var cursorName:String;
      
      private var needNearBy:Boolean;
      
      private var special:int;
      
      private var mouseevent:MouseEvent;
      
      public function SceneAIClick(param:Object)
      {
         super(param);
         this.special = param.special;
         this.spriteName = IdName.sceneAI(param.sequenceID);
      }
      
      override public function load(... rest) : void
      {
         if(rest.length >= 1 && rest[0] is Boolean)
         {
            this.needNearBy = rest[0];
         }
         else
         {
            this.needNearBy = false;
         }
         super.load(this.onLoadComplete);
      }
      
      override public function update(param:Object) : void
      {
         super.update(param);
      }
      
      private function onLoadComplete(evt:Event) : void
      {
         var cls:Class = null;
         var domain:ApplicationDomain = evt.currentTarget.applicationDomain as ApplicationDomain;
         if(domain != null && domain.hasDefinition("sceneai"))
         {
            cls = domain.getDefinition("sceneai") as Class;
            this.sceneAIClip = new cls() as MovieClip;
            this.addChild(this.sceneAIClip);
            ApplicationFacade.getInstance().dispatch(EventConst.REQUESTNPCSTATE,IdName.id(this.spriteName));
            this.initEffect();
            if(this.sceneAIClip.totalFrames > 1)
            {
               this.sceneAIClip.play();
            }
            if(this.special != -1)
            {
               if(!this.sceneAIClip.hasEventListener(MouseEvent.ROLL_OVER))
               {
                  Sprite(ui).addEventListener(MouseEvent.ROLL_OVER,this.onMouseRollOver);
               }
               if(!this.sceneAIClip.hasEventListener(MouseEvent.ROLL_OVER))
               {
                  Sprite(ui).addEventListener(MouseEvent.ROLL_OUT,this.onMouseRollOut);
               }
               Sprite(ui).addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseClick);
            }
         }
      }
      
      private function onMouseRollOver(evt:MouseEvent) : void
      {
         if(this.cursorName != null && this.cursorName.length > 0)
         {
            MouseManager.getInstance().cursorName = this.cursorName;
         }
         else
         {
            this.sceneAIClip.buttonMode = true;
         }
      }
      
      private function onMouseRollOut(evt:MouseEvent) : void
      {
         if(this.cursorName != null && this.cursorName.length > 0)
         {
            MouseManager.getInstance().setCursor("");
         }
      }
      
      private function onMouseClick(evt:MouseEvent) : void
      {
         this.mouseevent = evt;
         evt.stopImmediatePropagation();
         if(this.needNearBy)
         {
            this.handlNpcClick();
         }
         else
         {
            this.onClickCallback();
         }
      }
      
      private function onClickCallback() : void
      {
         if(this.sceneAIClip.hasEventListener(MouseEvent.MOUSE_DOWN))
         {
            this.sceneAIClip.dispatchEvent(this.mouseevent);
         }
         else if(this.sceneAIClip.hasEventListener(MouseEvent.MOUSE_DOWN))
         {
            this.sceneAIClip.dispatchEvent(this.mouseevent);
         }
         else
         {
            this.sendMsg();
         }
      }
      
      private function playover() : void
      {
         this.sceneAIClip.stop();
         this.sendMsg();
      }
      
      private function sendMsg() : void
      {
         ApplicationFacade.getInstance().dispatch(EventConst.ONCLICKNPC,{"id":IdName.id(this.spriteName)});
      }
      
      override public function dispos() : void
      {
         super.loader.unloadAndStop();
         if(sceneAIClip != null)
         {
            removeChild(sceneAIClip,false);
         }
         super.dispos();
      }
      
      private function handlNpcClick() : void
      {
         var tempParams:Object = {};
         tempParams.id = IdName.id(this.spriteName);
         var rect:Rectangle = this.sceneAIClip.getRect(this.sceneAIClip);
         tempParams.x = rect.x + rect.width / 2 + 5;
         tempParams.y = rect.y + rect.height;
         if(MapView.instance.masterPerson.moveto(tempParams.x,tempParams.y))
         {
            MapView.instance.addTimerListener(this.checkNpc);
            ApplicationFacade.getInstance().dispatch(EventConst.ROLEMOVE,{
               "newx":tempParams.x,
               "newy":tempParams.y,
               "path":null
            });
         }
      }
      
      private function checkNpc() : void
      {
         var dx:Number = x - MapView.instance.masterPerson.x;
         var dy:Number = sortY - MapView.instance.masterPerson.y;
         var radius:Number = Math.sqrt(dx * dx + dy * dy);
         if(radius < 60)
         {
            MapView.instance.masterPerson.stop();
            MapView.instance.removeTimerListener(this.checkNpc);
            ApplicationFacade.getInstance().dispatch(EventConst.ROLEMOVE,{
               "newx":MapView.instance.masterPerson.x,
               "newy":MapView.instance.masterPerson.y,
               "path":null
            });
            this.onClickCallback();
         }
      }
   }
}

