package com.xygame.module.battle.data
{
   import flash.display.MovieClip;
   
   public class SpiritData
   {
      
      public var level:int;
      
      public var left:Boolean = false;
      
      private var _hp:int;
      
      public var mySid:int;
      
      public var state:int;
      
      public var name:String;
      
      public var catchType:int;
      
      public var elem:int;
      
      public var userid:int;
      
      public var uniqueid:int;
      
      public var mySpirit:Boolean;
      
      public var showlp:int = 0;
      
      public var sid:int;
      
      public var skillArr:Array = new Array();
      
      public var spiritid:int;
      
      public var groupType:int;
      
      public var skillId:int;
      
      public var isbattle:Boolean;
      
      public var attrid:int;
      
      public var maxhp:int;
      
      public var bufArr:Array;
      
      public var url:String;
      
      public var title:MovieClip;
      
      private var _sframe:int;
      
      public var frame:int;
      
      public var aframe:int;
      
      public var srcid:String = "";
      
      public function SpiritData()
      {
         super();
      }
      
      public function get sframe() : int
      {
         return this._sframe;
      }
      
      public function set sframe(value:int) : void
      {
         this._sframe = value < 2 ? 2 : value;
      }
      
      public function get hp() : int
      {
         return this._hp;
      }
      
      public function set hp(value:int) : void
      {
         this._hp = value;
      }
   }
}

