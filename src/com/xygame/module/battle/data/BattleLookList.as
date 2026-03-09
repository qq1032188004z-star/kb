package com.xygame.module.battle.data
{
   import com.game.locators.GameData;
   import com.xygame.module.battle.event.BattleEvent;
   import org.green.server.data.ByteArray;
   
   public class BattleLookList
   {
      
      private static var _ins:BattleLookList;
      
      private var _lookList:Vector.<ByteArray>;
      
      public var battleEnd:Object;
      
      public var playerInfo:Object;
      
      public function BattleLookList()
      {
         super();
      }
      
      public static function get ins() : BattleLookList
      {
         return _ins = _ins || new BattleLookList();
      }
      
      public function initData(type:int) : void
      {
         this._lookList = new Vector.<ByteArray>();
         GameData.instance.initNewLook(type);
         BattleEvent.initNewLook();
         this.battleEnd = null;
      }
      
      public function addLookData(ba:ByteArray) : void
      {
         if(Boolean(this._lookList))
         {
            this._lookList.push(ba);
         }
      }
      
      public function getLookLen() : int
      {
         if(Boolean(this._lookList))
         {
            return this._lookList.length;
         }
         return 0;
      }
      
      public function getNewData() : ByteArray
      {
         if(Boolean(this._lookList))
         {
            return this._lookList.shift();
         }
         return null;
      }
   }
}

