package com.game.cue.view
{
   import com.game.cue.base.CueBaseWithClose;
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.locators.GameData;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class CueNotCoin extends CueBaseWithClose
   {
      
      private var btnClip:MovieClip;
      
      public function CueNotCoin()
      {
         super();
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         this.btnClip = this.bg.btnClip;
         this.btnClip.mouseEnabled = false;
      }
      
      override protected function onRegister() : void
      {
         if(Boolean(this.btnClip))
         {
            this.btnClip.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDownHandler);
         }
         registerCloseHandler(this.bg.closeBtn);
      }
      
      override protected function onRemove() : void
      {
         if(Boolean(this.btnClip))
         {
            this.btnClip.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDownHandler);
         }
         removeCloseHandler(this.bg.closeBtn);
      }
      
      protected function onMouseDownHandler(e:MouseEvent) : void
      {
         e.stopImmediatePropagation();
         var targetName:String = e.target.name;
         switch(targetName)
         {
            case "taskBtn":
               ApplicationFacade.getInstance().dispatch(EventConst.OPEN_MODULE,{
                  "url":"assets/module/TaskArchivesVersion3.swf",
                  "xCoord":0,
                  "yCoord":0
               });
               break;
            case "activityBtn":
               ApplicationFacade.getInstance().dispatch(EventConst.BOBSTATECLICK,{"url":"assets/weekly/WeeklyActivities.swf"});
               break;
            case "energyBtn":
               ApplicationFacade.getInstance().dispatch(EventConst.SENDUSERTOOTHERSCENE,1011);
               break;
            case "moneyBtn":
               ApplicationFacade.getInstance().dispatch(EventConst.OPEN_MODULE,{
                  "url":"assets/module/GodWealthModule.swf",
                  "xCoord":0,
                  "yCoord":0
               });
               break;
            case "manorBtn":
               GameData.instance.playerData["enterFarmFlag"] = true;
               ApplicationFacade.getInstance().dispatch(EventConst.ENTERSHENSHOU);
         }
      }
      
      override public function disport() : void
      {
         this.onRemove();
         super.disport();
      }
   }
}

