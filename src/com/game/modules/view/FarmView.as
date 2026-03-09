package com.game.modules.view
{
   import com.game.manager.EventManager;
   import com.game.util.CacheUtil;
   import com.game.util.HLoaderSprite;
   import com.publiccomponent.loading.GreenLoading;
   import flash.events.Event;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   
   public class FarmView extends HLoaderSprite
   {
      
      public const FARM_UI_DESTROY:String = "farm_ui_destroy";
      
      public function FarmView()
      {
         GreenLoading.loading.visible = true;
         super();
         this.context = new LoaderContext(false,ApplicationDomain.currentDomain);
         this.url = "assets/farm/FarmUI.swf";
      }
      
      override public function setShow() : void
      {
         GreenLoading.loading.visible = false;
         bg.cacheAsBitmap = true;
         EventManager.attachEvent(bg,this.FARM_UI_DESTROY,this.onFarmUIDestroy);
      }
      
      private function onFarmUIDestroy(evt:Event) : void
      {
         EventManager.removeEvent(bg,this.FARM_UI_DESTROY,this.onFarmUIDestroy);
         this.disport();
      }
      
      override public function disport() : void
      {
         GreenLoading.loading.visible = false;
         if(bg)
         {
            CacheUtil.deleteObject(FarmView);
            bg["disport"]();
            super.disport();
         }
      }
   }
}

