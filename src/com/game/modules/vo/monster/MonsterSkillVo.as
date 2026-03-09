package com.game.modules.vo.monster
{
   public class MonsterSkillVo
   {
      
      public var id:int;
      
      private var _skillIntro:SkillIntroVo;
      
      private var _skillNum:int = -1;
      
      private var _skillMaxNum:int = -1;
      
      public function MonsterSkillVo()
      {
         super();
      }
      
      public function set skillNum($value:int) : void
      {
         this._skillNum = $value;
      }
      
      public function set skillMaxNum($value:int) : void
      {
         this._skillMaxNum = $value;
      }
      
      public function get skillMaxNum() : int
      {
         return this._skillMaxNum == -1 ? this.skillIntro.count : this._skillMaxNum;
      }
      
      public function get skillNum() : int
      {
         return this._skillNum == -1 ? this.skillIntro.count : this._skillNum;
      }
      
      public function get skillIntro() : SkillIntroVo
      {
         if(this._skillIntro == null)
         {
            this._skillIntro = new SkillIntroVo(this.id);
         }
         return this._skillIntro;
      }
   }
}

