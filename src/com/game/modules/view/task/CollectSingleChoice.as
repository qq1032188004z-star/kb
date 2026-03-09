package com.game.modules.view.task
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.publiccomponent.loading.GreenLoading;
   import com.publiccomponent.loading.Hloader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.system.ApplicationDomain;
   
   public class CollectSingleChoice extends Sprite
   {
      
      private var loader:Hloader;
      
      private var mc:MovieClip;
      
      private var _rightAnswer:int;
      
      private var _selectAnswer:int;
      
      private var npcid:int;
      
      private var wholeList:Array;
      
      private var currentIndex:int;
      
      private var titleName:String;
      
      private var descList:Array;
      
      public function CollectSingleChoice()
      {
         super();
         GreenLoading.loading.visible = true;
         this.loader = new Hloader("assets/material/collectsingleChoice.swf");
         this.loader.addEventListener(Event.COMPLETE,this.onLoadComplete);
         this.cacheAsBitmap = true;
      }
      
      private function onLoadComplete(evt:Event) : void
      {
         evt.stopImmediatePropagation();
         var domain:ApplicationDomain = this.loader.contentLoaderInfo.applicationDomain;
         var cls:Class = domain.getDefinition("collectans") as Class;
         this.mc = new cls() as MovieClip;
         this.mc.cacheAsBitmap = true;
         this.mc.warningtf.visible = false;
         this.releaseLoader();
         if(this.wholeList != null && this.wholeList.length > 0)
         {
            this.init();
         }
      }
      
      private function releaseLoader() : void
      {
         if(Boolean(this.loader))
         {
            this.loader.removeEventListener(Event.COMPLETE,this.onLoadComplete);
            this.loader.unloadAndStop(true);
            this.loader = null;
         }
      }
      
      private function initEvents(flag:Boolean) : void
      {
         this.mc.answer1.buttonMode = true;
         this.mc.answer2.buttonMode = true;
         this.mc.answer3.buttonMode = true;
         this.mc.answer4.buttonMode = true;
         this.makeFilter(0);
         if(flag)
         {
            this.mc.closeBtn.addEventListener(MouseEvent.CLICK,this.onClickClose);
            this.mc.surebtn.addEventListener(MouseEvent.CLICK,this.onClickSure);
            this.mc.answer1.addEventListener(MouseEvent.CLICK,this.onClickAnswer);
            this.mc.answer2.addEventListener(MouseEvent.CLICK,this.onClickAnswer);
            this.mc.answer3.addEventListener(MouseEvent.CLICK,this.onClickAnswer);
            this.mc.answer4.addEventListener(MouseEvent.CLICK,this.onClickAnswer);
         }
         else
         {
            this.mc.closeBtn.removeEventListener(MouseEvent.CLICK,this.onClickClose);
            this.mc.surebtn.removeEventListener(MouseEvent.CLICK,this.onClickSure);
            this.mc.answer1.removeEventListener(MouseEvent.CLICK,this.onClickAnswer);
            this.mc.answer2.removeEventListener(MouseEvent.CLICK,this.onClickAnswer);
            this.mc.answer3.removeEventListener(MouseEvent.CLICK,this.onClickAnswer);
            this.mc.answer4.removeEventListener(MouseEvent.CLICK,this.onClickAnswer);
         }
      }
      
      private function onClickAnswer(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         this.mc.warningtf.visible = false;
         var str:String = evt.currentTarget.name;
         this._selectAnswer = int(str.charAt(str.length - 1));
         this.makeFilter(this._selectAnswer);
      }
      
      private function onClickClose(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         this.disport();
      }
      
      private function onClickSure(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         if(this._rightAnswer == this._selectAnswer && this._rightAnswer != 0)
         {
            if(this.npcid != 0)
            {
               ApplicationFacade.getInstance().dispatch(EventConst.MASTERISOUTSPECIALAREA,{
                  "npcid":this.npcid,
                  "dialogID":this._selectAnswer
               });
            }
            else
            {
               ApplicationFacade.getInstance().dispatch(EventConst.ONANSWERRIGHT);
            }
            this.disport();
         }
         else
         {
            this.mc.warningtf.visible = true;
         }
      }
      
      private function makeFilter(index:int) : void
      {
         this.mc.answer1.gotoAndStop(1);
         this.mc.answer2.gotoAndStop(1);
         this.mc.answer3.gotoAndStop(1);
         this.mc.answer4.gotoAndStop(1);
         if(index > 0 && index < 5)
         {
            this.mc["answer" + index].gotoAndStop(2);
         }
      }
      
      public function setData(param:Object) : void
      {
         this.npcid = param.npcid;
         this.wholeList = param.desc;
         this.descList = [];
         this.initQuestion();
      }
      
      private function initQuestion() : void
      {
         this.currentIndex = this.orderedByMyRule();
         if(this.currentIndex == -1)
         {
            this.disport();
            return;
         }
         var tempArr:Array = this.wholeList[this.currentIndex].desc as Array;
         this._rightAnswer = this.wholeList[this.currentIndex].ans;
         this.titleName = tempArr[0];
         this.descList = tempArr.slice(1,tempArr.length);
         if(Boolean(this.mc))
         {
            this.init();
         }
      }
      
      private function orderedByMyRule() : int
      {
         if(this.wholeList == null)
         {
            return -1;
         }
         if(this.wholeList.length == 1)
         {
            return 0;
         }
         return Math.random() * this.wholeList.length >> 0;
      }
      
      private function init() : void
      {
         if(this.descList == null)
         {
            this.disport();
            return;
         }
         GreenLoading.loading.visible = false;
         this.initEvents(true);
         if(!this.contains(this.mc))
         {
            this.addChild(this.mc);
            this.mc.x = 0;
            this.mc.y = 0;
         }
         var i:int = 0;
         var len:int = int(this.descList.length);
         this.mc.questiontf.text = this.titleName;
         for(i = 0; i < len; i++)
         {
            this.mc["answer" + (i + 1)].answertf.text = this.descList[i];
         }
      }
      
      public function disport() : void
      {
         GreenLoading.loading.visible = false;
         this._rightAnswer = 0;
         this._selectAnswer = 0;
         this.currentIndex = 0;
         this.descList = null;
         this.wholeList = null;
         this.npcid = 0;
         this.titleName = "";
         this.initEvents(false);
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

