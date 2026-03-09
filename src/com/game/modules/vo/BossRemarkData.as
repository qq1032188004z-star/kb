package com.game.modules.vo
{
   public class BossRemarkData
   {
      
      private static var _instance:BossRemarkData;
      
      public var open:int;
      
      public var bossId:int;
      
      public var bossHp:int;
      
      public var initBossHp:int;
      
      public var tid:int;
      
      public var isEffBtn:Boolean;
      
      public var rankDays:int;
      
      public var playerListPage:Array;
      
      public function BossRemarkData()
      {
         super();
         this.playerListPage = [];
      }
      
      public static function get instance() : BossRemarkData
      {
         if(_instance == null)
         {
            _instance = new BossRemarkData();
         }
         return _instance;
      }
      
      public function dispose() : void
      {
         _instance = null;
      }
   }
}

