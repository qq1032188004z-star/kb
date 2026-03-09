package com.game.util
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.manager.MouseManager;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.system.ApplicationDomain;
   
   public class MouseCursorAI extends SceneAIBase
   {
      
      private var _type:int;
      
      public function MouseCursorAI(param:Object)
      {
         super(param);
         this.spriteName = IdName.specialArea(param.sequenceID);
      }
      
      override public function load(... rest) : void
      {
         super.load(this.onLoadComplete);
      }
      
      public function onLoadComplete(evt:Event) : void
      {
         var domain:ApplicationDomain = evt.currentTarget.applicationDomain as ApplicationDomain;
         var cls:Class = domain.getDefinition("mousecursorai") as Class;
         this.sceneAIClip = new cls() as MovieClip;
         this.addChild(this.sceneAIClip);
         this.initEffect();
      }
      
      override public function update(param:Object) : void
      {
         MouseManager.getInstance().setCursor("");
         if(this.sceneAIClip.currentFrame < this.sceneAIClip.totalFrames)
         {
            this.sceneAIClip.play();
         }
         if(this.sceneAIClip.totalFrames == 1)
         {
            this.sendMsg();
         }
         else
         {
            this.sceneAIClip.addFrameScript(this.sceneAIClip.totalFrames - 1,this.sendMsg);
         }
      }
      
      private function sendMsg() : void
      {
         this.sceneAIClip.stop();
         ApplicationFacade.getInstance().dispatch(EventConst.ONCLICKNPC,{"id":IdName.id(this.spriteName)});
         this.removeChild(this.sceneAIClip);
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
   }
}

