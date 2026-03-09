package com.xygame.module.battle.battleItem
{
   import flash.events.Event;
   import flash.geom.Point;
   
   public class BattleRoleEvent extends Event
   {
      
      public static const canOpration:String = "canopration";
      
      public static const bloodMcPlay:String = "bloodmcplay";
      
      public static const battleRoleOK:String = "battleroleOK";
      
      public static const playNextOpration:String = "playNextOpration";
      
      public static const changeRoleInfo:String = "changeRoleInfo";
      
      public static const missEffect:String = "misseffect";
      
      public static const addBattleEffect:String = "addbattleEffect";
      
      public static const battleEventTest:String = "battleeventtest";
      
      public static const enterSceneOver:String = "entersceneover";
      
      public static const battleRoleMove:String = "battleroleMove";
      
      public static const OPEN_SITE:String = "OPEN_SITE";
      
      private var br:BattleRole;
      
      public var data:Object;
      
      private var step:Point;
      
      public function BattleRoleEvent(type:String, stepValue:Point = null, batRole:BattleRole = null, data:Object = null)
      {
         super(type);
         if(stepValue != null)
         {
            this.stepPoint = stepValue;
         }
         if(batRole != null)
         {
            this.battleRole = batRole;
         }
         if(data != null)
         {
            this.data = data;
         }
      }
      
      public function get battleRole() : BattleRole
      {
         return this.br;
      }
      
      public function get stepPoint() : Point
      {
         return this.step;
      }
      
      public function set battleRole(value:BattleRole) : void
      {
         this.br = value;
      }
      
      public function set stepPoint(value:Point) : void
      {
         this.step = new Point(value.x,value.y);
      }
   }
}

