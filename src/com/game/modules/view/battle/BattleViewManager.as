package com.game.modules.view.battle
{
   import flash.display.Sprite;
   
   public class BattleViewManager
   {
      
      private static var instance:BattleViewManager;
      
      private var _tipView:Sprite;
      
      private var _monView:Sprite;
      
      private var _conView:Sprite;
      
      public function BattleViewManager()
      {
         super();
         this._tipView = new Sprite();
         this._tipView.name = "tipView";
         this._monView = new Sprite();
         this._monView.name = "monView";
         this._conView = new Sprite();
         this._conView.name = "conView";
      }
      
      public static function getInstance() : BattleViewManager
      {
         if(instance == null)
         {
            instance = new BattleViewManager();
         }
         return instance;
      }
      
      public function get tipView() : Sprite
      {
         return this._tipView;
      }
      
      public function get monView() : Sprite
      {
         return this._monView;
      }
      
      public function get conView() : Sprite
      {
         return this._conView;
      }
      
      public function ClearView() : void
      {
         while(Boolean(this._tipView.numChildren))
         {
            this._tipView.removeChildAt(0);
         }
         while(Boolean(this._monView.numChildren))
         {
            this._monView.removeChildAt(0);
         }
         while(Boolean(this._conView.numChildren))
         {
            this._conView.removeChildAt(0);
         }
      }
   }
}

