package com.game.modules.vo.list
{
   import com.game.modules.vo.monster.MonsterVo;
   
   public class MonsterStorageList
   {
      
      public var packId:int;
      
      public var monsterTotalLenght:int;
      
      private var _monsterCurrentLength:int;
      
      private var _monsterlist:Array;
      
      public var isChange:Boolean = false;
      
      private var filters:Array;
      
      public function MonsterStorageList()
      {
         super();
      }
      
      public function set monsterlist($monsterlist:Array) : void
      {
         this._monsterlist = $monsterlist;
      }
      
      public function get monsterlist() : Array
      {
         return this._monsterlist == null ? [] : this._monsterlist;
      }
      
      public function get monsterCurrentLength() : int
      {
         return this.monsterlist.length;
      }
      
      public function searChIntroVague($vagueName:String) : Array
      {
         var monsterVo:MonsterVo = null;
         var needIntro:Array = [];
         for each(monsterVo in this.monsterlist)
         {
            if(monsterVo.monsterIntro.name.indexOf($vagueName) != -1)
            {
               if(needIntro.indexOf(monsterVo.monsterIntro) == -1)
               {
                  needIntro.push(monsterVo.monsterIntro);
               }
            }
         }
         return needIntro;
      }
      
      public function searchMonsterByName($vagueName:String) : Array
      {
         var monsterVo:MonsterVo = null;
         var needMonster:Array = [];
         for each(monsterVo in this.monsterlist)
         {
            if(monsterVo.monsterIntro.name.indexOf($vagueName) != -1)
            {
               needMonster.push(monsterVo);
            }
         }
         return needMonster;
      }
      
      public function getMonsters($filters:Array) : Array
      {
         var needs:Array = null;
         this.filters = $filters;
         if(this.monsterlist == null)
         {
            needs = [];
         }
         else
         {
            needs = this.monsterlist.filter(this.isMonster);
         }
         return needs;
      }
      
      public function addMonster($monsterVo:MonsterVo) : void
      {
         this.monsterlist.push($monsterVo);
      }
      
      private function hasMonster($monsterId:int) : Boolean
      {
         return this.indexOf($monsterId) != -1;
      }
      
      public function getMonster($id:int) : MonsterVo
      {
         var index:int = this.indexOf($id);
         return index == -1 ? null : this.monsterlist[index];
      }
      
      public function addMonsterSkill($id:int, $learnSkills:Array, $unLearnSkills:Array) : void
      {
         var monsterVo:MonsterVo = this.getMonster($id);
         if(Boolean(monsterVo))
         {
            monsterVo.learnSkillList = $learnSkills;
            monsterVo.unLearnSkillList = $unLearnSkills;
         }
      }
      
      public function addMonsterInfo(vo:MonsterVo) : void
      {
         var monsterVo:MonsterVo = this.getMonster(vo.id);
         if(Boolean(monsterVo))
         {
            monsterVo.mold = vo.mold;
            monsterVo.sex = vo.sex;
            monsterVo.attack = vo.attack;
            monsterVo.defence = vo.defence;
            monsterVo.magic = vo.magic;
            monsterVo.resistance = vo.resistance;
            monsterVo.strength = vo.strength;
            monsterVo.speed = vo.speed;
            monsterVo.attackGeniusValue = vo.attackGeniusValue;
            monsterVo.defenceGeniusValue = vo.defenceGeniusValue;
            monsterVo.magicGeniusValue = vo.magicGeniusValue;
            monsterVo.resistanceGeniusValue = vo.resistanceGeniusValue;
            monsterVo.hpGeniusValue = vo.hpGeniusValue;
            monsterVo.speedGeniusValue = vo.speedGeniusValue;
            monsterVo.exp = vo.exp;
            monsterVo.timetxt = vo.timetxt;
            monsterVo.type = vo.type;
            monsterVo.needExp = vo.needExp;
            monsterVo.attackLearnValue = vo.attackLearnValue;
            monsterVo.defenceLearnValue = vo.defenceLearnValue;
            monsterVo.magicLearnValue = vo.magicLearnValue;
            monsterVo.resistanceLearnValue = vo.resistanceLearnValue;
            monsterVo.hpLearnValue = vo.hpLearnValue;
            monsterVo.speedLearnVale = vo.speedLearnVale;
            monsterVo.hasSymm = vo.hasSymm;
         }
      }
      
      private function indexOf($id:int) : int
      {
         var monsterVo:MonsterVo = null;
         var index:int = -1;
         var length:int = int(this.monsterlist.length);
         for(var i:int = 0; i < length; i++)
         {
            monsterVo = this.monsterlist[i] as MonsterVo;
            if(Boolean(monsterVo) && monsterVo.id == $id)
            {
               index = i;
               break;
            }
         }
         return index;
      }
      
      public function delMonster($monsterId:int) : MonsterVo
      {
         var delMonsters:Array = null;
         var index:int = this.indexOf($monsterId);
         var delMonster:MonsterVo = null;
         if(index != -1)
         {
            delMonsters = this.monsterlist.splice(index,1);
            delMonster = delMonsters[0];
         }
         return delMonster;
      }
      
      private function isMonster(element:*, index:int, arr:Array) : Boolean
      {
         var state1:Boolean = this.filters[0] == 0 ? true : element.type == this.filters[0] - 1;
         var state2:Boolean = this.filters[1] == 0 ? true : element.geniusNum == this.filters[1];
         var state3:Boolean = this.filters[2] == 0 ? true : element.sex == this.filters[2];
         var state4:Boolean = this.filters[3] == 0 ? true : element.monsterIntro.group == this.filters[3] - 1;
         return state1 && state2 && state3 && state4;
      }
      
      public function disport() : void
      {
         var monsterVo:MonsterVo = null;
         while(this.monsterlist.length > 0)
         {
            monsterVo = this.monsterlist.shift();
            monsterVo = null;
         }
         this.monsterlist = null;
      }
   }
}

