package com.game.modules.vo.monster
{
   import com.game.locators.CacheData;
   import com.game.modules.control.monster.SpiritGenius;
   import com.kb.util.CommonDefine;
   
   public class MonsterVo
   {
      
      public var other:Object;
      
      public var packId:int = -1;
      
      public var id:int;
      
      public var iid:int;
      
      public var level:int;
      
      public var exp:int;
      
      public var mold:int;
      
      public var timetxt:int;
      
      public var attack:int;
      
      public var defence:int;
      
      public var magic:int;
      
      public var resistance:int;
      
      public var strength:int;
      
      public var speed:int;
      
      private var _type:int;
      
      public var sex:int;
      
      public var needExp:int;
      
      public var isfirst:int;
      
      public var typeid:int;
      
      public var forbitItem:int;
      
      public var hp:int;
      
      public var state:int;
      
      public var peerlessId:int;
      
      public var peerlessStatus:int;
      
      public var tempPeerlessNum:int;
      
      public var skillcount:int;
      
      public var attackLearnValue:int;
      
      public var defenceLearnValue:int;
      
      public var magicLearnValue:int;
      
      public var resistanceLearnValue:int;
      
      public var hpLearnValue:int;
      
      public var speedLearnVale:int;
      
      public var hasSymm:Boolean;
      
      public var symmList:Array;
      
      private var _geniusNum:int = -1;
      
      private var _monsterIntro:MonsterIntroVo;
      
      private var _attackGeniusValue:int;
      
      private var _defenceGeniusValue:int;
      
      private var _magicGeniusValue:int;
      
      private var _resistanceGeniusValue:int;
      
      private var _hpGeniusValue:int;
      
      private var _speedGeniusValue:int;
      
      private var _attackGenius:int;
      
      private var _defenceGenius:int;
      
      private var _magicGenius:int;
      
      private var _resistanceGenius:int;
      
      private var _hpGenius:int;
      
      private var _speedGenius:int;
      
      public var learnSkillList:Array;
      
      public var unLearnSkillList:Array;
      
      public function MonsterVo()
      {
         super();
      }
      
      public function get geniusNum() : int
      {
         if(this._attackGenius == 0 && this._geniusNum == -1)
         {
            return 0;
         }
         if(this._geniusNum == -1)
         {
            this._geniusNum = SpiritGenius.countGeniusType(this._attackGenius,this._defenceGenius,this._magicGenius,this._resistanceGenius,this._hpGenius,this._speedGenius);
         }
         return this._geniusNum;
      }
      
      public function set geniusNum(value:int) : void
      {
         if(value != 0)
         {
            this._geniusNum = value;
         }
      }
      
      public function get type() : int
      {
         if(this._type == 0)
         {
            return this.monsterIntro.elem;
         }
         return this._type;
      }
      
      public function set type(value:int) : void
      {
         this._type = value;
      }
      
      public function get CountGeniuscount() : String
      {
         return CommonDefine.aptLit[this.geniusNum];
      }
      
      public function get attackGeniusValue() : int
      {
         return this._attackGeniusValue;
      }
      
      public function get defenceGeniusValue() : int
      {
         return this._defenceGeniusValue;
      }
      
      public function get magicGeniusValue() : int
      {
         return this._magicGeniusValue;
      }
      
      public function get resistanceGeniusValue() : int
      {
         return this._resistanceGeniusValue;
      }
      
      public function get hpGeniusValue() : int
      {
         return this._hpGeniusValue;
      }
      
      public function get speedGeniusValue() : int
      {
         return this._speedGeniusValue;
      }
      
      public function get attackGenius() : int
      {
         return this._attackGenius;
      }
      
      public function get defenceGenius() : int
      {
         return this._defenceGenius;
      }
      
      public function get magicGenius() : int
      {
         return this._magicGenius;
      }
      
      public function get resistanceGenius() : int
      {
         return this._resistanceGenius;
      }
      
      public function get hpGenius() : int
      {
         return this._hpGenius;
      }
      
      public function get speedGenius() : int
      {
         return this._speedGenius;
      }
      
      public function get monsterIntro() : MonsterIntroVo
      {
         if(this._monsterIntro == null)
         {
            this._monsterIntro = CacheData.instance.monsterIntroList.getMonsterIntroById(this.iid);
            if(this._monsterIntro == null)
            {
               this._monsterIntro = new MonsterIntroVo();
            }
         }
         return this._monsterIntro;
      }
      
      public function set attackGeniusValue($attackGeniusValue:int) : void
      {
         this._attackGeniusValue = $attackGeniusValue;
         this._attackGenius = SpiritGenius.cheakGenius($attackGeniusValue);
      }
      
      public function set defenceGeniusValue($defenceGeniusValue:int) : void
      {
         this._defenceGeniusValue = $defenceGeniusValue;
         this._defenceGenius = SpiritGenius.cheakGenius($defenceGeniusValue);
      }
      
      public function set magicGeniusValue($magicGeniusValue:int) : void
      {
         this._magicGeniusValue = $magicGeniusValue;
         this._magicGenius = SpiritGenius.cheakGenius($magicGeniusValue);
      }
      
      public function set resistanceGeniusValue($resistanceGeniusValue:int) : void
      {
         this._resistanceGeniusValue = $resistanceGeniusValue;
         this._resistanceGenius = SpiritGenius.cheakGenius($resistanceGeniusValue);
      }
      
      public function set hpGeniusValue($hpGeniusValue:int) : void
      {
         this._hpGeniusValue = $hpGeniusValue;
         this._hpGenius = SpiritGenius.cheakGenius($hpGeniusValue);
      }
      
      public function set speedGeniusValue($speedGeniusValue:int) : void
      {
         this._speedGeniusValue = $speedGeniusValue;
         this._speedGenius = SpiritGenius.cheakGenius($speedGeniusValue);
      }
   }
}

