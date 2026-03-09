package com.xygame.module.battle.data
{
   public class BattleDefine
   {
      
      private static var _instance:BattleDefine;
      
      private var buf_show_index:Array;
      
      public function BattleDefine()
      {
         super();
      }
      
      public static function get instance() : BattleDefine
      {
         if(_instance == null)
         {
            _instance = new BattleDefine();
            _instance.initData();
         }
         return _instance;
      }
      
      public function initData() : void
      {
         this.buf_show_index = [0,0];
      }
      
      public function getBufShowIndex(index:int) : int
      {
         return this.buf_show_index[index];
      }
      
      public function setBufShowIndex(index:int, num:int) : void
      {
         this.buf_show_index[index] = num;
      }
   }
}

