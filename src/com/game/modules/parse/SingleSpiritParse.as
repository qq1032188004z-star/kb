package com.game.modules.parse
{
   import com.game.modules.vo.monster.MonsterVo;
   import org.green.server.data.MsgPacket;
   import org.green.server.interfaces.IParser;
   
   public class SingleSpiritParse implements IParser
   {
      
      public var params:Object;
      
      public function SingleSpiritParse()
      {
         super();
      }
      
      public function parse(msg:MsgPacket) : void
      {
         var vo:MonsterVo = null;
         var result:Array = null;
         var temparr:Array = null;
         var i:int = 0;
         var tempskillid:int = 0;
         var allSkillList:Array = null;
         var obj2:Object = null;
         var skill2:XML = null;
         var unableSkillCount:int = 0;
         var f:int = 0;
         var symmLength:int = 0;
         var symmList:Array = null;
         var z:int = 0;
         var obj:Object = null;
         var obj3:Object = null;
         var symmObj:Object = null;
         this.params = {};
         var currentMsg:MsgPacket = msg;
         this.params.mcount = currentMsg.body.readInt();
         var mArrary:Array = [];
         for(var j:int = 0; j < this.params.mcount; j++)
         {
            vo = new MonsterVo();
            vo.id = currentMsg.body.readInt();
            if(vo.id == 0)
            {
               break;
            }
            vo.typeid = currentMsg.body.readInt();
            vo.iid = currentMsg.body.readInt();
            vo.isfirst = currentMsg.body.readInt();
            vo.level = currentMsg.body.readInt();
            vo.exp = currentMsg.body.readInt();
            vo.type = currentMsg.body.readInt();
            vo.forbitItem = currentMsg.body.readInt();
            vo.attack = currentMsg.body.readInt();
            vo.defence = currentMsg.body.readInt();
            vo.magic = currentMsg.body.readInt();
            vo.resistance = currentMsg.body.readInt();
            vo.strength = currentMsg.body.readInt();
            vo.hp = currentMsg.body.readInt();
            vo.speed = currentMsg.body.readInt();
            vo.mold = currentMsg.body.readInt();
            vo.state = currentMsg.body.readInt();
            vo.needExp = currentMsg.body.readInt();
            vo.timetxt = currentMsg.body.readInt();
            vo.sex = currentMsg.body.readInt();
            vo.attackLearnValue = currentMsg.body.readInt();
            vo.defenceLearnValue = currentMsg.body.readInt();
            vo.magicLearnValue = currentMsg.body.readInt();
            vo.resistanceLearnValue = currentMsg.body.readInt();
            vo.hpLearnValue = currentMsg.body.readInt();
            vo.speedLearnVale = currentMsg.body.readInt();
            vo.attackGeniusValue = currentMsg.body.readInt();
            vo.defenceGeniusValue = currentMsg.body.readInt();
            vo.magicGeniusValue = currentMsg.body.readInt();
            vo.resistanceGeniusValue = currentMsg.body.readInt();
            vo.hpGeniusValue = currentMsg.body.readInt();
            vo.speedGeniusValue = currentMsg.body.readInt();
            vo.peerlessId = currentMsg.body.readInt();
            vo.peerlessStatus = currentMsg.body.readInt();
            vo.tempPeerlessNum = currentMsg.body.readInt();
            vo.skillcount = currentMsg.body.readInt();
            result = [];
            temparr = [];
            for(i = 0; i < vo.skillcount; i++)
            {
               obj = {};
               obj.skillid = currentMsg.body.readInt();
               temparr.push(obj.skillid);
               obj.skillnum = currentMsg.body.readInt();
               obj.skillmaxnum = currentMsg.body.readInt();
               result.push(obj);
            }
            vo.learnSkillList = result;
            tempskillid = 1;
            allSkillList = [];
            while(tempskillid != 0)
            {
               obj2 = {};
               obj2.skillid = currentMsg.body.readInt();
               tempskillid = int(obj2.skillid);
               if(tempskillid != 0 && temparr.indexOf(tempskillid) == -1)
               {
                  allSkillList.push(obj2);
               }
            }
            unableSkillCount = currentMsg.body.readInt();
            for(f = 0; f < unableSkillCount; f++)
            {
               obj3 = {};
               obj3.skillid = 0;
               allSkillList.push(obj3);
            }
            vo.unLearnSkillList = allSkillList;
            symmLength = currentMsg.body.readInt();
            symmList = [];
            for(z = 0; z < symmLength; z++)
            {
               symmObj = {};
               symmObj.symmPlace = currentMsg.body.readInt();
               symmObj.symmId = currentMsg.body.readInt();
               symmObj.symmIndex = currentMsg.body.readInt();
               symmObj.symmFlag = vo.id;
               symmList.push(symmObj);
            }
            vo.symmList = symmList;
            mArrary.push(vo);
         }
         this.params.monsterlist = mArrary;
      }
   }
}

