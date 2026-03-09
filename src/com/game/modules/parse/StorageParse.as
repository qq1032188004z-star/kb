package com.game.modules.parse
{
   import com.game.modules.vo.list.MonsterStorageList;
   import com.game.modules.vo.monster.MonsterVo;
   import flash.utils.ByteArray;
   import org.green.server.data.MsgPacket;
   import org.green.server.interfaces.IParser;
   
   public class StorageParse implements IParser
   {
      
      public var flag:Boolean = false;
      
      public var storage:MonsterStorageList;
      
      public function StorageParse()
      {
         super();
      }
      
      public function parse(msg:MsgPacket) : void
      {
         var j:int = 0;
         var monsterVo:MonsterVo = null;
         var currentMsg:MsgPacket = msg;
         this.storage = new MonsterStorageList();
         this.storage.packId = msg.mParams;
         msg.body.position = 0;
         var mcount:int = currentMsg.body.readInt();
         var mArrary:Array = [];
         if(mcount > 0)
         {
            for(j = 0; j < mcount; j++)
            {
               monsterVo = new MonsterVo();
               this.readBase(monsterVo,currentMsg.body,this.storage.packId != 0);
               monsterVo.packId = this.storage.packId;
               mArrary.push(monsterVo);
            }
         }
         else
         {
            O.o("镇魂顶是空");
         }
         this.storage.monsterlist = mArrary;
         currentMsg.body.readInt();
         this.storage.monsterTotalLenght = currentMsg.body.readInt();
      }
      
      private function readBase(_monsterVo:MonsterVo, _byte:ByteArray, isAll:Boolean) : void
      {
         _monsterVo.id = _byte.readInt();
         _monsterVo.iid = _byte.readInt();
         _monsterVo.level = _byte.readInt();
         if(isAll)
         {
            _monsterVo.exp = _byte.readInt();
            _monsterVo.mold = _byte.readInt();
            _monsterVo.timetxt = _byte.readInt();
            _monsterVo.attack = _byte.readInt();
            _monsterVo.defence = _byte.readInt();
            _monsterVo.magic = _byte.readInt();
            _monsterVo.resistance = _byte.readInt();
            _monsterVo.strength = _byte.readInt();
            _monsterVo.speed = _byte.readInt();
            _monsterVo.type = _byte.readInt();
            _monsterVo.sex = _byte.readInt();
            _monsterVo.needExp = _byte.readInt();
            _monsterVo.attackLearnValue = _byte.readInt();
            _monsterVo.defenceLearnValue = _byte.readInt();
            _monsterVo.magicLearnValue = _byte.readInt();
            _monsterVo.resistanceLearnValue = _byte.readInt();
            _monsterVo.hpLearnValue = _byte.readInt();
            _monsterVo.speedLearnVale = _byte.readInt();
            _monsterVo.attackGeniusValue = _byte.readInt();
            _monsterVo.defenceGeniusValue = _byte.readInt();
            _monsterVo.magicGeniusValue = _byte.readInt();
            _monsterVo.resistanceGeniusValue = _byte.readInt();
            _monsterVo.hpGeniusValue = _byte.readInt();
            _monsterVo.speedGeniusValue = _byte.readInt();
            _monsterVo.hasSymm = _byte.readInt() > 0 ? true : false;
         }
         else
         {
            _monsterVo.timetxt = _byte.readInt();
            _monsterVo.sex = _byte.readInt();
            _monsterVo.geniusNum = _byte.readInt();
         }
      }
   }
}

