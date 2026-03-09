package com.game.modules.view.person
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.locators.GameData;
   import com.game.manager.MonsterManger;
   import com.game.manager.MouseManager;
   import com.game.modules.control.task.TaskEvent;
   import com.game.modules.control.task.util.TaskUtils;
   import com.game.util.IdName;
   import com.game.util.SceneAIBase;
   import com.publiccomponent.alert.Alert;
   import com.xygame.module.battle.event.BattleEvent;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.system.ApplicationDomain;
   
   public class WalkableNPC extends SceneAIBase
   {
      
      private var special:int;
      
      private var baseSpeed:int = 3;
      
      private var speedx:int;
      
      private var speedy:int;
      
      private var targetX:Number;
      
      private var targetY:Number;
      
      private var _flag:Boolean = false;
      
      private var istask:int;
      
      public function WalkableNPC(param:Object)
      {
         super(param);
         this.special = param.special;
         this.spriteName = IdName.npc(param.sequenceID);
         this.istask = param.istask;
         this.sequenceID = param.sequenceID;
      }
      
      override public function load(... rest) : void
      {
         super.load(this.onLoadComplete);
      }
      
      private function onLoadComplete(evt:Event) : void
      {
         evt.stopImmediatePropagation();
         var domain:ApplicationDomain = evt.currentTarget.applicationDomain as ApplicationDomain;
         var cls:* = domain.getDefinition("npc") as Class;
         this.sceneAIClip = new cls() as MovieClip;
         this.sceneAIClip.cacheAsBitmap = true;
         this.addChild(this.sceneAIClip);
         if(this.istask == 2)
         {
            Sprite(ui).buttonMode = true;
            this.baseSpeed = 2;
         }
         this.chooseTarget();
         Sprite(ui).addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         Sprite(ui).addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         if(this.istask == 4)
         {
            Sprite(ui).buttonMode = true;
         }
      }
      
      private function onEnterFrame(evt:Event) : void
      {
         evt.stopImmediatePropagation();
         this.x += this.speedx;
         this.y += this.speedy;
         if(this.onArrival() || (this.x >= 960 - this.ui.width || this.x < 0 || this.y >= 550 - this.ui.height || this.y < 0))
         {
            this.chooseTarget();
         }
      }
      
      private function onArrival() : Boolean
      {
         var dx:Number = this.targetX - this.x;
         var dy:Number = this.targetY - this.y;
         var dis:Number = Math.sqrt(dx * dx + dy * dy);
         if(dis < 60)
         {
            return true;
         }
         return false;
      }
      
      private function chooseTarget() : void
      {
         this.targetX = Math.random() * (970 - this.ui.width);
         this.targetY = Math.random() * (570 - this.ui.height);
         if(this.targetX > this.x)
         {
            this.speedx = this.baseSpeed;
         }
         else if(this.targetX < this.x)
         {
            this.speedx = -this.baseSpeed;
         }
         else
         {
            this.speedx = 0;
         }
         if(this.targetY > this.y)
         {
            this.speedy = this.baseSpeed;
         }
         else if(this.targetY < this.y)
         {
            this.speedy = -this.baseSpeed;
         }
         else
         {
            this.speedy = 0;
         }
         if(this.speedx > 0)
         {
            this.sceneAIClip.scaleX = -1;
         }
         else if(this.speedx < 0)
         {
            this.sceneAIClip.scaleX = 1;
         }
      }
      
      private function onMouseDown(evt:MouseEvent) : void
      {
         var str:String = null;
         var sid:int = 0;
         if(this.istask == 1 || this.istask == 3)
         {
            str = "CursorTool200" + this.special;
            if(MouseManager.getInstance().cursorName == str)
            {
               this._flag = true;
               this.speedx = 0;
               this.speedy = 0;
               if(!TaskUtils.getInstance().hasEventListener(TaskEvent.OP_MOUSE_ACTION_AI))
               {
                  TaskUtils.getInstance().addEventListener(TaskEvent.OP_MOUSE_ACTION_AI,this.doAction);
               }
            }
         }
         else if(this.istask == 2 || this.istask == 4)
         {
            if(Boolean(GameData.instance.playerData.bobOwner))
            {
               new Alert().showOne("在擂台上不能参加其他的战斗哦...");
               return;
            }
            if(this.istask == 2)
            {
               sid = MonsterManger.instance.combine1(1,0,234,45);
               ApplicationFacade.getInstance().dispatch(BattleEvent.npcClick,{"sid":sid});
               ApplicationFacade.getInstance().dispatch(EventConst.REMOVEDYNAMICTASKNPC,this.sequenceID);
            }
            else
            {
               ApplicationFacade.getInstance().dispatch(EventConst.CLICKNPCWITHOUTSCENECHECK,{
                  "type":this.special,
                  "npcid":sequenceID,
                  "actionID":1
               });
            }
         }
      }
      
      private function doAction(evt:TaskEvent) : void
      {
         if(this._flag)
         {
            TaskUtils.getInstance().removeEventListener(TaskEvent.OP_MOUSE_ACTION_AI,this.doAction);
            if(this.sceneAIClip.currentFrame < this.sceneAIClip.totalFrames)
            {
               this.sceneAIClip.addFrameScript(this.sceneAIClip.totalFrames - 1,this.doClick);
               this.sceneAIClip.nextFrame();
               this.sceneAIClip.play();
            }
            else
            {
               this.doClick();
            }
         }
      }
      
      private function doClick() : void
      {
         this.sceneAIClip.stop();
         if(this.istask == 3)
         {
            ApplicationFacade.getInstance().dispatch(EventConst.CLICKNPCWITHOUTSCENECHECK,{
               "type":this.special,
               "npcid":IdName.id(this.spriteName),
               "actionID":1
            });
         }
         else
         {
            ApplicationFacade.getInstance().dispatch(EventConst.ONCLICKNPC,{"id":IdName.id(this.spriteName)});
         }
         this._flag = false;
         this.dispos();
      }
      
      override public function dispos() : void
      {
         Sprite(ui).removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         Sprite(ui).removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         if(this.sceneAIClip != null)
         {
            this.removeChild(this.sceneAIClip,false);
         }
         super.dispos();
      }
   }
}

