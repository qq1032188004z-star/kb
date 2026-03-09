package com.game.modules.vo.list
{
   import com.game.modules.vo.monster.MonsterIntroVo;
   import com.game.util.LuaObjUtil;
   import com.publiccomponent.loading.XMLLocator;
   import flash.utils.Dictionary;
   
   public class MonsterIntroList
   {
      
      private var _monsterDic:Dictionary;
      
      public function MonsterIntroList()
      {
         super();
         this._monsterDic = new Dictionary();
      }
      
      public function getMonsterIntroById(id:int) : MonsterIntroVo
      {
         var xml:XML = null;
         if(!this._monsterDic.hasOwnProperty(id.toString()))
         {
            xml = XMLLocator.getInstance().getSprited(id);
            this._monsterDic[id] = this.getNewMonster(xml);
         }
         return this._monsterDic[id];
      }
      
      private function getNewMonster(node:XML) : MonsterIntroVo
      {
         var introVo:MonsterIntroVo = new MonsterIntroVo();
         if(Boolean(node))
         {
            introVo.id = node.@id;
            introVo.name = node.name;
            introVo.elem = node.elem;
            introVo.growup = node.growup;
            introVo.nextmonsterid = node.nextmonsterid;
            introVo.iscontinue = node.iscontinue;
            introVo.group = node.group;
            introVo.sequence = node.sequence;
            introVo.height = node.height;
            introVo.weight = node.weight;
            introVo.distribute = node.distribute;
            introVo.food = node.food;
            introVo.intro = node.introduce;
            if(Boolean(node.hasOwnProperty("site")))
            {
               introVo.siteList = LuaObjUtil.getLuaObjArr(String(node.site));
            }
         }
         return introVo;
      }
   }
}

