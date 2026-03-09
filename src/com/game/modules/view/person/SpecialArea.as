package com.game.modules.view.person
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.manager.MouseManager;
   import com.game.util.IdName;
   import com.game.util.SceneAIBase;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.system.ApplicationDomain;
   
   public class SpecialArea extends SceneAIBase
   {
      
      private var flag:Boolean;
      
      private var special:int;
      
      private var sendAlready:Boolean = false;
      
      public function SpecialArea(param:Object)
      {
         super(param);
         this.special = param.special;
         this.sequenceID = param.sequenceID;
         this.spriteName = IdName.specialArea(param.sequenceID);
      }
      
      override public function load(... rest) : void
      {
         super.load(this.onLoadComplete);
      }
      
      override public function update(param:Object) : void
      {
         super.update(param);
      }
      
      private function onLoadComplete(evt:Event) : void
      {
         var domain:ApplicationDomain = evt.currentTarget.applicationDomain as ApplicationDomain;
         var cls:Class = domain.getDefinition("specialArea") as Class;
         this.sceneAIClip = new cls() as MovieClip;
         this.addChild(this.sceneAIClip);
         this.initEffect();
      }
      
      public function operate(isIn:Boolean) : void
      {
         this.flag = isIn;
         if(this.sceneAIClip.currentFrame < this.sceneAIClip.totalFrames)
         {
            this.sceneAIClip.addFrameScript(this.sceneAIClip.totalFrames - 1,this.sendMsg);
            if(this.sceneAIClip.currentFrame < this.sceneAIClip.totalFrames)
            {
               this.sceneAIClip.nextFrame();
               this.sceneAIClip.play();
            }
         }
         else
         {
            this.sendMsg();
         }
      }
      
      private function sendMsg() : void
      {
         this.sceneAIClip.stop();
         if(this.opeartByID())
         {
            return;
         }
         if(this.flag || this.sequenceID == 18005)
         {
            try
            {
               if(!this.sendAlready)
               {
                  ApplicationFacade.getInstance().dispatch(EventConst.MASTERISINSPECIALAREA,IdName.id(this.spriteName));
                  if(this.special != 1)
                  {
                     this.addEvent();
                  }
                  this.sendAlready = true;
               }
            }
            catch(e:*)
            {
               trace("这货不是场景AI.....GamePlayer -> masterIsInSpecialArea");
            }
         }
         else
         {
            try
            {
               if(this.sendAlready)
               {
                  ApplicationFacade.getInstance().dispatch(EventConst.MASTERISOUTSPECIALAREA,{
                     "npcid":IdName.id(this.spriteName),
                     "dialogID":IdName.id(this.spriteName)
                  });
                  this.sendAlready = false;
               }
            }
            catch(e:*)
            {
               trace("这货不是场景AI....GamePlayer -> masterIsOutSpecialArea");
            }
         }
      }
      
      private function opeartByID() : Boolean
      {
         if(this.sequenceID == 41311)
         {
            ApplicationFacade.getInstance().dispatch(EventConst.SCENEAREAAI,{"id":this.sequenceID});
            return true;
         }
         if(this.sequenceID != 41312)
         {
            if(this.sequenceID == 41313)
            {
               ApplicationFacade.getInstance().dispatch(EventConst.SCENEAREAAI,{"id":this.sequenceID});
               return true;
            }
         }
         return false;
      }
      
      private function addEvent() : void
      {
         this.sceneAIClip.addEventListener(MouseEvent.CLICK,this.onMouseClickWithCursor);
      }
      
      private function onMouseClickWithCursor(evt:MouseEvent) : void
      {
         switch(this.special)
         {
            case 2:
               if(MouseManager.getInstance().cursorName == "CursorTool1")
               {
                  MouseManager.getInstance().setCursor("");
                  this.sceneAIClip.removeEventListener(MouseEvent.CLICK,this.onMouseClickWithCursor);
                  ApplicationFacade.getInstance().dispatch(EventConst.ONCLICKNPC,{"id":IdName.id(this.spriteName)});
               }
         }
      }
      
      override public function get sortY() : Number
      {
         return -100;
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

