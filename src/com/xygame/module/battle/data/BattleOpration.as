package com.xygame.module.battle.data
{
   public class BattleOpration
   {
      
      public var def_hp:int;
      
      public var param0:int;
      
      public var param1:int;
      
      public var catchData:*;
      
      public var brust:int;
      
      public var haveBattle:int;
      
      public var skilltype:int;
      
      public var effect:int;
      
      public var atkid:int;
      
      public var atkbuf:Object = {
         "brust":0,
         "atk_hp":0,
         "def_hp":0,
         "rebound_hp":0
      };
      
      public var rebound_hp:int;
      
      public var defid:int;
      
      public var appendData:Object;
      
      public var atk_hp:int;
      
      public var haveBuf:int;
      
      public var skillid:int;
      
      public var itemid:int;
      
      public var sid:int;
      
      public var cmdtype:int;
      
      public var bufArr:Array = [];
      
      public var appendArr:Array = [];
      
      public var uniqueid:int;
      
      public var miss:int;
      
      public var range:int;
      
      public var avail:int;
      
      public function BattleOpration()
      {
         super();
      }
   }
}

