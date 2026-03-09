package com.game.modules.view.job
{
   import com.game.facade.ApplicationFacade;
   import com.game.locators.GameData;
   import com.game.modules.control.job.JobControl;
   import com.game.util.CacheUtil;
   import com.game.util.HLoaderSprite;
   import com.publiccomponent.loading.GreenLoading;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class JobView extends HLoaderSprite
   {
      
      public static const startjob:String = "startjob";
      
      private var mc:MovieClip;
      
      private var mcplay:MovieClip;
      
      private var palyloader:Loader;
      
      private var timeid:int;
      
      public function JobView()
      {
         super();
         GreenLoading.loading.visible = true;
         if(GameData.instance.playerData.currentScenenId == 3002)
         {
            this.url = "assets/material/job.swf";
         }
         if(GameData.instance.playerData.currentScenenId == 6002)
         {
            this.url = "assets/material/waterjob.swf";
         }
         this.graphics.beginFill(16711680,0);
         this.graphics.drawRect(-1000,-1000,2000,2000);
         this.graphics.endFill();
      }
      
      override public function setShow() : void
      {
         if(GameData.instance.playerData.currentScenenId != 3002 && GameData.instance.playerData.currentScenenId != 6002)
         {
            this.disport();
            return;
         }
         this.mc = this.bg;
         this.mc.cacheAsBitmap = true;
         this.addChild(this.mc);
         if(!ApplicationFacade.getInstance().hasViewLogic("JobControl"))
         {
            ApplicationFacade.getInstance().registerViewLogic(new JobControl(this));
         }
         this.initEventListener();
         GreenLoading.loading.visible = false;
      }
      
      private function initEventListener() : void
      {
         this.mc.startBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.startJob);
         this.mc.cancelBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.closeWindow);
         this.mc.closeBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.closeWindow);
      }
      
      private function startJob(evt:Event) : void
      {
         if(this.parent != null)
         {
            if(this.parent.contains(this))
            {
               this.parent.removeChild(this);
            }
         }
         this.dispatchEvent(new Event(JobView.startjob));
      }
      
      public function closeWindow(evt:Event) : void
      {
         this.disport();
      }
      
      override public function disport() : void
      {
         ApplicationFacade.getInstance().removeViewLogic(JobControl.NAME);
         CacheUtil.deleteObject(JobView);
         this.graphics.clear();
         super.disport();
      }
   }
}

