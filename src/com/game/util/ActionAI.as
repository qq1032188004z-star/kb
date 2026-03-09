package com.game.util
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.manager.MouseManager;
   import com.game.modules.control.task.TaskEvent;
   import com.game.modules.control.task.util.TaskUtils;
   import flash.display.FrameLabel;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.system.ApplicationDomain;
   
   public class ActionAI extends SceneAIBase
   {
      
      private var _flag:Boolean = false;
      
      private var _type:int;
      
      private var loadCompletePlay:Function;
      
      public function ActionAI(param:Object)
      {
         super(param);
         this._type = param.special;
         this.spriteName = IdName.npc(param.sequenceID);
      }
      
      override public function load(... rest) : void
      {
         if(rest.length > 0)
         {
            this.loadCompletePlay = rest[0] as Function;
         }
         super.load(this.onLoadComplete);
      }
      
      private function onLoadComplete(evt:Event) : void
      {
         var domain:ApplicationDomain = evt.currentTarget.applicationDomain as ApplicationDomain;
         var cls:Class = domain.getDefinition("actionai") as Class;
         this.sceneAIClip = new cls() as MovieClip;
         this.addChild(this.sceneAIClip);
         this.initEffect();
         this.sceneAIClip.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         if(this.loadCompletePlay != null)
         {
            this.playEffect(this.loadCompletePlay);
         }
      }
      
      private function onMouseDown(evt:Event) : void
      {
         var str:String = "CursorTool200" + this._type;
         O.o(MouseManager.getInstance().cursorName);
         if(MouseManager.getInstance().cursorName == str)
         {
            if(IdName.id(this.spriteName) == 21108)
            {
               GameDynamicUI.removeUI("jiantou");
            }
            this._flag = true;
            if(!TaskUtils.getInstance().hasEventListener(TaskEvent.OP_MOUSE_ACTION_AI))
            {
               TaskUtils.getInstance().addEventListener(TaskEvent.OP_MOUSE_ACTION_AI,this.doAction);
            }
         }
      }
      
      private function doAction(evt:TaskEvent) : void
      {
         var scriptFrames:int = 0;
         if(this._flag)
         {
            TaskUtils.getInstance().removeEventListener(TaskEvent.OP_MOUSE_ACTION_AI,this.doAction);
            scriptFrames = 1;
            if(this.sceneAIClip.totalFrames > 1)
            {
               if(this.sceneAIClip.currentLabels == null || this.sceneAIClip.currentLabels.length == 0 || (this.sceneAIClip.currentLabels[this.sceneAIClip.currentLabels.length - 1] as FrameLabel).frame != this.sceneAIClip.totalFrames)
               {
                  scriptFrames = this.sceneAIClip.totalFrames - 1;
                  this.sceneAIClip.addFrameScript(scriptFrames,this.onLastFrame);
               }
            }
            this.playEffect(this.onFrameNameFunc);
         }
      }
      
      private function onFrameNameFunc(spname:String = "") : void
      {
         this.sceneAIClip.stop();
         if(this.sceneAIClip.totalFrames == this.sceneAIClip.currentFrame)
         {
            this.onLastFrame();
         }
         else
         {
            ApplicationFacade.getInstance().dispatch(EventConst.ONCLICKNPC,{"id":IdName.id(this.spriteName)});
            this._flag = false;
         }
      }
      
      private function onLastFrame() : void
      {
         this.sceneAIClip.stop();
         ApplicationFacade.getInstance().dispatch(EventConst.ONCLICKNPC,{"id":IdName.id(this.spriteName)});
         this._flag = false;
         this.dispos();
      }
      
      override public function dispos() : void
      {
         if(super.loader != null)
         {
            super.loader.unloadAndStop();
         }
         if(sceneAIClip != null)
         {
            removeChild(sceneAIClip,false);
         }
         super.dispos();
      }
   }
}

