package com.game.modules.view.shenshou
{
   import com.game.facade.ApplicationFacade;
   import com.game.modules.control.shenshou.ShenshouViewControl;
   import com.game.util.CacheUtil;
   import com.game.util.HLoaderSprite;
   import com.publiccomponent.loading.GreenLoading;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   
   public class ShenshouView extends HLoaderSprite
   {
      
      public function ShenshouView()
      {
         super();
         GreenLoading.loading.visible = true;
         this.context = new LoaderContext(false,ApplicationDomain.currentDomain);
         ApplicationFacade.getInstance().registerViewLogic(new ShenshouViewControl(this));
         this.url = "assets/shenshou/ShenShou.swf";
      }
      
      override public function setShow() : void
      {
         GreenLoading.loading.visible = false;
      }
      
      override public function disport() : void
      {
         CacheUtil.deleteObject(ShenshouView);
         ApplicationFacade.getInstance().removeViewLogic(ShenshouViewControl.NAME);
         try
         {
            loader.loader.content["disport"]();
         }
         catch(e:*)
         {
         }
         super.disport();
         GreenLoading.loading.visible = false;
      }
   }
}

