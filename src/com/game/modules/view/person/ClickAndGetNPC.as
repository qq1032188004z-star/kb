package com.game.modules.view.person
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.util.IdName;
   import com.game.util.SceneAIBase;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.system.ApplicationDomain;
   
   public class ClickAndGetNPC extends SceneAIBase
   {
      
      public function ClickAndGetNPC(param:Object)
      {
         super(param);
         this.spriteName = IdName.npc(param.sequenceID);
      }
      
      override public function load(... rest) : void
      {
         super.load(this.onLoadComplete);
      }
      
      private function onLoadComplete(evt:Event) : void
      {
         var cls:Class = null;
         var domain:ApplicationDomain = evt.currentTarget.applicationDomain as ApplicationDomain;
         if(domain != null && domain.hasDefinition("clickdis"))
         {
            cls = domain.getDefinition("clickdis") as Class;
            this.sceneAIClip = new cls() as MovieClip;
            this.addChild(this.sceneAIClip);
            if(this.sceneAIClip.totalFrames > 1)
            {
               this.sceneAIClip.play();
            }
            this.sceneAIClip.buttonMode = true;
            Sprite(ui).addEventListener(MouseEvent.CLICK,this.onMouseClick);
         }
      }
      
      private function onMouseClick(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         if(this.sceneAIClip.currentFrame < this.sceneAIClip.totalFrames)
         {
            this.sceneAIClip.addFrameScript(this.sceneAIClip.totalFrames - 1,this.lastFrame);
            this.sceneAIClip.nextFrame();
            this.sceneAIClip.play();
         }
         else
         {
            this.lastFrame();
         }
      }
      
      private function lastFrame() : void
      {
         this.sceneAIClip.stop();
         ApplicationFacade.getInstance().dispatch(EventConst.REMOVEDYNAMICTASKNPC,IdName.id(this.spriteName));
         ApplicationFacade.getInstance().dispatch(EventConst.ONCLICKNPC,{"id":IdName.id(this.spriteName)});
      }
   }
}

