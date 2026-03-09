package com.game.util
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class DynamicBuild extends SceneAIBase
   {
      
      private var special:int;
      
      private var flag:Boolean;
      
      private var timer:Timer;
      
      private var timeArr:Array;
      
      private var status:int;
      
      private var startFrame:int;
      
      private var tempData:Object;
      
      private var lastTime:int;
      
      private var needTosendClick:Boolean = false;
      
      public function DynamicBuild(param:Object)
      {
         super(param);
         this.special = param.special;
         this.sequenceID = param.sequenceID;
         this.spriteName = IdName.npc(param.sequenceID);
         this.ui.cacheAsBitmap = true;
      }
      
      override public function load(... rest) : void
      {
         if(rest.length != 0)
         {
            this.startFrame = rest[0];
         }
         super.load(this.onLoadComplete);
      }
      
      private function onLoadComplete(evt:Event) : void
      {
         if(this.sequenceID > 21502 && this.sequenceID < 21508 || this.sequenceID > 21818 && this.sequenceID <= 21823 || this.sequenceID == 91405 || this.sequenceID == 401308)
         {
            this.sceneAIClip = (this.loader.content as MovieClip).getChildAt(0) as MovieClip;
         }
         else
         {
            this.sceneAIClip = this.loader.getChildAt(0) as MovieClip;
         }
         this.sceneAIClip.cacheAsBitmap = true;
         this.addChild(this.sceneAIClip);
         if(this.sequenceID == 31202 || sequenceID == 31218)
         {
            this.sceneAIClip.getChildAt(0)["tree"].addFrameScript(13,this.sendClick);
            this.sceneAIClip.getChildAt(0)["tree"].addFrameScript(77,this.sendClick);
            this.sceneAIClip.getChildAt(0)["tree"].addFrameScript(126,this.sendClick);
            this.sceneAIClip.getChildAt(0)["tree"].addFrameScript(199,this.sendClick);
         }
         else if(this.sequenceID == 71304)
         {
            this.sceneAIClip.buttonMode = true;
         }
         if(this.startFrame != 0)
         {
            this.sceneAIClip.gotoAndPlay(this.startFrame);
         }
         if(this.tempData != null)
         {
            this.opUpdate();
         }
      }
      
      override public function playEffect(callback:Function = null) : void
      {
         super.playEffect(callback);
      }
      
      override public function update(param:Object) : void
      {
         this.tempData = {};
         var frameLabel:String = "";
         this.status = param.status;
         switch(this.status)
         {
            case 0:
               frameLabel = "first";
               break;
            case 1:
               frameLabel = "second";
               break;
            case 2:
               frameLabel = "third";
               break;
            case 3:
               frameLabel = "forth";
               break;
            default:
               frameLabel = "first";
         }
         this.tempData.currentLable = frameLabel;
         if(this.special == 2)
         {
            this.timeArr = [10,30,60,0];
            this.flag = param.canChange;
            this.lastTime = param.nextTime;
         }
         if(this.sceneAIClip != null)
         {
            this.opUpdate();
         }
      }
      
      private function opUpdate() : void
      {
         if(this.special == 2)
         {
            (this.sceneAIClip.getChildAt(0) as MovieClip).timeTF.text = "0";
            (this.sceneAIClip.getChildAt(0) as MovieClip).tree.gotoAndStop(this.tempData.currentLable);
            (this.sceneAIClip.getChildAt(0) as MovieClip).optree.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseClickBtn);
            if(!this.flag && this.status < 3)
            {
               this.timer = new Timer(1000,this.lastTime);
               this.timer.addEventListener(TimerEvent.TIMER,this.onTimer);
               this.timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimeComplete);
               this.timer.start();
            }
         }
      }
      
      private function onMouseClickBtn(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         if(this.flag)
         {
            if(this.status >= 3)
            {
               if(Boolean(this.sceneAIClip.getChildAt(0)["optree"].hasEventListener(MouseEvent.MOUSE_DOWN)))
               {
                  this.sceneAIClip.getChildAt(0)["optree"].removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseClickBtn);
               }
               return;
            }
            ++this.status;
            this.needTosendClick = true;
            (this.sceneAIClip.getChildAt(0) as MovieClip).tree.play();
         }
         else if(this.status < 3)
         {
            ApplicationFacade.getInstance().dispatch(EventConst.FRESHMANGUIDETOTASK,{
               "type":2,
               "dialogId":200500209,
               "subtaskID":2005002,
               "taskID":2005000
            });
         }
      }
      
      private function sendClick() : void
      {
         this.sceneAIClip.getChildAt(0)["tree"].stop();
         if(this.needTosendClick)
         {
            ApplicationFacade.getInstance().dispatch(EventConst.ONCLICKNPC,{"id":IdName.id(this.spriteName)});
            this.needTosendClick = false;
            if(this.status < 3)
            {
               this.update({
                  "status":this.status,
                  "canChange":false,
                  "nextTime":this.timeArr[this.status]
               });
            }
         }
      }
      
      private function onTimer(evt:TimerEvent) : void
      {
         --this.lastTime;
         (this.sceneAIClip.getChildAt(0) as MovieClip).timeTF.text = this.lastTime;
      }
      
      private function onTimeComplete(evt:TimerEvent) : void
      {
         this.timer.stop();
         this.timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
         this.timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTimeComplete);
         this.timer = null;
         this.flag = true;
      }
      
      override public function get sortY() : Number
      {
         if(this.sequenceID == 21704 || this.sequenceID == 21706 || this.sequenceID == 91204 || this.sequenceID == 61404 || sequenceID == 61428)
         {
            return 0;
         }
         return super.sortY;
      }
      
      override public function dispos() : void
      {
         super.loader.unloadAndStop();
         if(sceneAIClip != null)
         {
            removeChild(sceneAIClip,false);
         }
         super.dispos();
         this.tempData = null;
         this.timeArr = null;
      }
   }
}

