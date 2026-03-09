package com.game.newBase
{
   import com.core.observer.MessageEvent;
   import com.game.locators.EventDefine;
   import com.game.locators.GameData;
   import com.game.util.HLoaderSprite;
   
   public class BaseAI extends HLoaderSprite
   {
      
      public function BaseAI()
      {
         super();
      }
      
      override public function setShow() : void
      {
         super.setShow();
         GameData.instance.addEventListener(EventDefine.CURRENT_SCENEN_CHANGE,this.onScenenChangeHandler);
      }
      
      protected function onScenenChangeHandler(event:MessageEvent) : void
      {
      }
      
      override public function disport() : void
      {
         GameData.instance.removeEventListener(EventDefine.CURRENT_SCENEN_CHANGE,this.onScenenChangeHandler);
         super.disport();
      }
   }
}

