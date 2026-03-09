package com.game.comm.view
{
   import com.game.comm.ActComponentUrl;
   import com.game.comm.manager.ActViewManager;
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.locators.GameData;
   import com.game.util.OldBaseSprite;
   import flash.events.MouseEvent;
   
   public class NoCopperView extends OldBaseSprite
   {
      
      public function NoCopperView(callback:Function = null)
      {
         super();
         start(callback);
         setURL(ActComponentUrl.NO_COPPER_VIEW);
      }
      
      override protected function setShow() : void
      {
         if(Boolean(bg))
         {
            this.initEvents();
         }
      }
      
      private function initEvents() : void
      {
         bg.taskBtn.addEventListener(MouseEvent.CLICK,this.onTask);
         bg.activityBtn.addEventListener(MouseEvent.CLICK,this.onActivity);
         bg.energyBtn.addEventListener(MouseEvent.CLICK,this.onEnergy);
         bg.manorBtn.addEventListener(MouseEvent.CLICK,this.onManor);
         bg.closeBtn.addEventListener(MouseEvent.CLICK,this.onClose);
      }
      
      private function removeEvents() : void
      {
         bg.taskBtn.removeEventListener(MouseEvent.CLICK,this.onTask);
         bg.activityBtn.removeEventListener(MouseEvent.CLICK,this.onActivity);
         bg.energyBtn.removeEventListener(MouseEvent.CLICK,this.onEnergy);
         bg.manorBtn.removeEventListener(MouseEvent.CLICK,this.onManor);
         bg.closeBtn.removeEventListener(MouseEvent.CLICK,this.onClose);
      }
      
      private function onTask(evt:MouseEvent) : void
      {
         ApplicationFacade.getInstance().dispatch(EventConst.OPEN_MODULE,{
            "url":"assets/module/TaskArchivesVersion3.swf",
            "xCoord":0,
            "yCoord":0
         });
         this.disport();
      }
      
      private function onActivity(evt:MouseEvent) : void
      {
         ApplicationFacade.getInstance().dispatch(EventConst.BOBSTATECLICK,{"url":"assets/weekly/WeeklyActivities.swf"});
         this.disport();
      }
      
      private function onEnergy(evt:MouseEvent) : void
      {
         this.disport();
         ApplicationFacade.getInstance().dispatch(EventConst.SENDUSERTOOTHERSCENE,1011);
      }
      
      private function onManor(evt:MouseEvent) : void
      {
         this.disport();
         GameData.instance.playerData["enterFarmFlag"] = true;
         ApplicationFacade.getInstance().dispatch(EventConst.ENTERSHENSHOU);
      }
      
      private function onClose(evt:MouseEvent) : void
      {
         this.disport();
      }
      
      override public function disport() : void
      {
         if(Boolean(bg))
         {
            this.removeEvents();
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
         ActViewManager.NO_COPPER_VIEW = 0;
         super.disport();
         if(_callback != null)
         {
            _callback();
         }
         _callback = null;
      }
   }
}

