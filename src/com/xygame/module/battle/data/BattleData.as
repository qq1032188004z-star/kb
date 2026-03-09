package com.xygame.module.battle.data
{
   import com.game.global.GlobalConfig;
   import com.game.locators.GameData;
   import com.xygame.module.battle.util.SpiritXmlData;
   
   public class BattleData
   {
      
      public var escape:int = 0;
      
      public var mySpiritArr:Array;
      
      public var newbattle:Boolean = false;
      
      public var battleArr:Array;
      
      public var sid:int;
      
      public var allSkillArr:Array;
      
      public var otherArr:Array;
      
      public var battleType:int;
      
      public var skillCount:int;
      
      public var warCraft:Boolean = false;
      
      public var bgUrl:String;
      
      public var sceneId:int;
      
      public var round:int = 0;
      
      public var startTime:Number;
      
      private var _pAry:Array;
      
      private var _oAry:Array;
      
      public function BattleData()
      {
         super();
         this.battleArr = [];
         this.otherArr = [];
         this.mySpiritArr = [];
         this.allSkillArr = [];
         this._pAry = [];
         this._oAry = [];
      }
      
      public function initPosint() : void
      {
         this._pAry = [];
         this._oAry = [];
      }
      
      public function addBattle(data:SpiritData) : void
      {
         if(!data)
         {
            trace("[BattleData] 警告：尝试添加空的精魂数据");
            return;
         }
         this.battleArr.push(data);
         if(this.isPlayerSpirit(data))
         {
            this._pAry.push(data.uniqueid);
         }
         else
         {
            this._oAry.push(data.uniqueid);
         }
         this.collectSkills(data);
      }
      
      private function isPlayerSpirit(data:SpiritData) : Boolean
      {
         if(GameData.instance.lookBattle != 1)
         {
            return data.userid == GlobalConfig.userId;
         }
         switch(GameData.instance.newLookType)
         {
            case 1:
               return data.groupType == 1;
            case 2:
               return data.userid == BattleLookList.ins.playerInfo["player"]["id"];
            default:
               return false;
         }
      }
      
      private function isMySpirit(data:SpiritData) : Boolean
      {
         return data.userid == GlobalConfig.userId;
      }
      
      private function collectSkills(data:SpiritData) : void
      {
         var skill:Object = null;
         var effect:int = 0;
         if(!data.skillArr)
         {
            return;
         }
         for each(skill in data.skillArr)
         {
            if(Boolean(skill) && Boolean(skill.xml))
            {
               effect = int(skill.xml.effect);
               if(effect > 0)
               {
                  if(this.allSkillArr.indexOf(effect) == -1)
                  {
                     this.allSkillArr.push(effect);
                     ++this.skillCount;
                  }
               }
            }
         }
      }
      
      public function getSpiritid(unid:int) : int
      {
         var spirit:SpiritData = null;
         for each(spirit in this.mySpiritArr)
         {
            if(spirit.uniqueid == unid)
            {
               return spirit.spiritid;
            }
         }
         return 0;
      }
      
      public function getSpiritData(unid:int) : SpiritData
      {
         var spirit:SpiritData = null;
         for each(spirit in this.battleArr)
         {
            if(spirit.uniqueid == unid)
            {
               return spirit;
            }
         }
         return null;
      }
      
      public function getSpiritBySid(sid:int) : SpiritData
      {
         var spirit:SpiritData = null;
         for each(spirit in this.battleArr)
         {
            if(spirit.sid == sid)
            {
               return spirit;
            }
         }
         return null;
      }
      
      public function getShowDisplay() : SpiritData
      {
         var sd:SpiritData = null;
         var xml:XML = null;
         for each(sd in this.battleArr)
         {
            xml = SpiritXmlData.spirititem(sd.spiritid.toString());
            if(Boolean(xml) && Boolean(xml.hasOwnProperty("display")))
            {
               return sd;
            }
         }
         return null;
      }
      
      public function getCurrentPlayerSpirit() : SpiritData
      {
         var spirit:SpiritData = null;
         for each(spirit in this.battleArr)
         {
            if(this.isPlayerSpirit(spirit) && spirit.state == 1)
            {
               return spirit;
            }
         }
         return null;
      }
      
      public function getCurrentEnemySpirit() : SpiritData
      {
         var spirit:SpiritData = null;
         for each(spirit in this.battleArr)
         {
            if(!this.isPlayerSpirit(spirit) && spirit.state == 1)
            {
               return spirit;
            }
         }
         return null;
      }
      
      public function hasAlivePlayerSpirit() : Boolean
      {
         var spirit:SpiritData = null;
         for each(spirit in this.mySpiritArr)
         {
            if(spirit.hp > 0)
            {
               return true;
            }
         }
         return false;
      }
      
      public function hasAliveEnemySpirit() : Boolean
      {
         var spirit:SpiritData = null;
         for each(spirit in this.otherArr)
         {
            if(spirit.hp > 0)
            {
               return true;
            }
         }
         return false;
      }
      
      public function getPlayerAliveCount() : int
      {
         var spirit:SpiritData = null;
         var count:int = 0;
         for each(spirit in this.mySpiritArr)
         {
            if(spirit.hp > 0)
            {
               count++;
            }
         }
         return count;
      }
      
      public function getEnemyAliveCount() : int
      {
         var spirit:SpiritData = null;
         var count:int = 0;
         for each(spirit in this.otherArr)
         {
            if(spirit.hp > 0)
            {
               count++;
            }
         }
         return count;
      }
      
      public function get pAry() : Array
      {
         return this._pAry;
      }
      
      public function get oAry() : Array
      {
         return this._oAry;
      }
      
      public function dispose() : void
      {
         if(Boolean(this.battleArr))
         {
            this.battleArr.length = 0;
            this.battleArr = null;
         }
         if(Boolean(this.otherArr))
         {
            this.otherArr.length = 0;
            this.otherArr = null;
         }
         if(Boolean(this.mySpiritArr))
         {
            this.mySpiritArr.length = 0;
            this.mySpiritArr = null;
         }
         if(Boolean(this.allSkillArr))
         {
            this.allSkillArr.length = 0;
            this.allSkillArr = null;
         }
         if(Boolean(this._pAry))
         {
            this._pAry.length = 0;
            this._pAry = null;
         }
         if(Boolean(this._oAry))
         {
            this._oAry.length = 0;
            this._oAry = null;
         }
      }
      
      public function toString() : String
      {
         return "[BattleData" + " battleType=" + this.battleType + " round=" + this.round + " playerCount=" + this.mySpiritArr.length + " enemyCount=" + this.otherArr.length + " skillCount=" + this.skillCount + " bgUrl=" + this.bgUrl + "]";
      }
      
      public function clone() : BattleData
      {
         var data:BattleData = new BattleData();
         data.escape = this.escape;
         data.newbattle = this.newbattle;
         data.sid = this.sid;
         data.battleType = this.battleType;
         data.skillCount = this.skillCount;
         data.warCraft = this.warCraft;
         data.bgUrl = this.bgUrl;
         data.sceneId = this.sceneId;
         data.round = this.round;
         data.battleArr = this.battleArr.concat();
         data.otherArr = this.otherArr.concat();
         data.mySpiritArr = this.mySpiritArr.concat();
         data.allSkillArr = this.allSkillArr.concat();
         data._pAry = this._pAry.concat();
         data._oAry = this._oAry.concat();
         return data;
      }
   }
}

