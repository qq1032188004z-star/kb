package com.game.dohko.view
{
   import com.game.dohko.data.ActiveCommonData;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   
   public class ActiveRuleUIBase extends BaseDisplay
   {
      
      protected var closeBtn:SimpleButton;
      
      protected var chooseMc:MovieClip;
      
      protected var startBtn:SimpleButton;
      
      public function ActiveRuleUIBase()
      {
         super();
      }
      
      override protected function onViewShowed() : void
      {
         this.closeBtn = mainUI.getChildByName("closeBtn") as SimpleButton;
         this.chooseMc = mainUI.getChildByName("chooseMc") as MovieClip;
         this.startBtn = mainUI.getChildByName("startBtn") as SimpleButton;
         this.initEvents();
         super.onViewShowed();
      }
      
      override protected function refreshView() : void
      {
         if(isLoaded)
         {
            ActiveCommonData.instance.promptFlag = moduleParams.promptFlag;
            if(moduleParams.promptFlag == 1)
            {
               this.chooseMc.gotoAndStop(1);
            }
            else
            {
               this.chooseMc.gotoAndStop(2);
            }
         }
      }
      
      private function initEvents() : void
      {
         this.closeBtn.addEventListener(MouseEvent.CLICK,this.onClose);
         this.startBtn.addEventListener(MouseEvent.CLICK,this.onStart);
         this.chooseMc.addEventListener(MouseEvent.CLICK,this.onChoose);
      }
      
      private function removeEvents() : void
      {
         this.closeBtn.removeEventListener(MouseEvent.CLICK,this.onClose);
         this.startBtn.removeEventListener(MouseEvent.CLICK,this.onStart);
         this.chooseMc.removeEventListener(MouseEvent.CLICK,this.onChoose);
      }
      
      private function onChoose(evt:MouseEvent) : void
      {
         if(this.chooseMc.currentFrame == 1)
         {
            this.chooseMc.gotoAndStop(2);
            ActiveCommonData.instance.promptFlag = 0;
         }
         else
         {
            this.chooseMc.gotoAndStop(1);
            ActiveCommonData.instance.promptFlag = 1;
         }
      }
      
      private function onStart(evt:MouseEvent) : void
      {
         if(moduleParams.startCallback != null)
         {
            moduleParams.startCallback.apply();
         }
      }
      
      private function onClose(evt:MouseEvent) : void
      {
         ActiveCommonData.instance.promptFlag = 0;
         if(moduleParams.closeCallback != null)
         {
            moduleParams.closeCallback.apply();
         }
      }
      
      override public function dispos() : void
      {
         super.dispos();
      }
   }
}

