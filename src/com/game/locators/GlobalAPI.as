package com.game.locators
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import flash.events.EventDispatcher;
   
   public class GlobalAPI
   {
      
      public static var eventDispatcher:EventDispatcher;
      
      public function GlobalAPI()
      {
         super();
      }
      
      public static function openCountryMap(id:int) : void
      {
         if(id > 210)
         {
            ApplicationFacade.getInstance().dispatch(EventConst.BOBSTATECLICK,{
               "moduleParams":id,
               "url":"assets/map/NewAreaMapView.swf"
            });
         }
         else
         {
            ApplicationFacade.getInstance().dispatch(EventConst.BOBSTATECLICK,{"url":"assets/map/country/AreaMapView" + id + ".swf"});
         }
      }
   }
}

