package com.game.modules.parse
{
   import com.game.locators.CacheData;
   import com.game.locators.GameData;
   import com.game.modules.control.monster.SpiritGenius;
   import com.game.modules.vo.monster.MonsterIntroVo;
   import org.green.server.data.MsgPacket;
   import org.green.server.interfaces.IParser;
   
   public class SpiritParse implements IParser
   {
      
      public var params:Object;
      
      public function SpiritParse()
      {
         super();
      }
      
      public function parse(msg:MsgPacket) : void
      {
         var mObj:Object = null;
         var introVo:MonsterIntroVo = null;
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
         this.params.sn = currentMsg.body.readInt();
         this.params.mcount = currentMsg.body.readInt();
         var mArrary:Array = [];
         for(var j:int = 0; j < this.params.mcount; j++)
         {
            mObj = {};
            mObj.id = currentMsg.body.readInt();
            if(mObj.id == 0)
            {
               break;
            }
            mObj.typeid = currentMsg.body.readInt();
            mObj.iid = currentMsg.body.readInt();
            introVo = CacheData.instance.monsterIntroList.getMonsterIntroById(mObj.iid);
            mObj.name = introVo.name;
            mObj.group = introVo.group;
            mObj.nextmonsterid = introVo.nextmonsterid;
            mObj.siteList = introVo.siteList;
            mObj.isfirst = currentMsg.body.readInt();
            mObj.level = currentMsg.body.readInt();
            mObj.exp = currentMsg.body.readInt();
            mObj.type = currentMsg.body.readInt();
            mObj.forbitItem = currentMsg.body.readInt();
            mObj.attack = currentMsg.body.readInt();
            mObj.defence = currentMsg.body.readInt();
            mObj.magic = currentMsg.body.readInt();
            mObj.resistance = currentMsg.body.readInt();
            mObj.strength = currentMsg.body.readInt();
            mObj.hp = currentMsg.body.readInt();
            mObj.speed = currentMsg.body.readInt();
            mObj.mold = currentMsg.body.readInt();
            mObj.state = currentMsg.body.readInt();
            mObj.needExp = currentMsg.body.readInt();
            mObj.timetxt = currentMsg.body.readInt();
            mObj.sex = currentMsg.body.readInt();
            mObj.attackLearnValue = currentMsg.body.readInt();
            mObj.defenceLearnValue = currentMsg.body.readInt();
            mObj.magicLearnValue = currentMsg.body.readInt();
            mObj.resistanceLearnValue = currentMsg.body.readInt();
            mObj.hpLearnValue = currentMsg.body.readInt();
            mObj.speedLearnVale = currentMsg.body.readInt();
            mObj.attackGeniusValue = currentMsg.body.readInt();
            mObj.defenceGeniusValue = currentMsg.body.readInt();
            mObj.magicGeniusValue = currentMsg.body.readInt();
            mObj.resistanceGeniusValue = currentMsg.body.readInt();
            mObj.hpGeniusValue = currentMsg.body.readInt();
            mObj.speedGeniusValue = currentMsg.body.readInt();
            mObj.peerlessId = currentMsg.body.readInt();
            mObj.peerlessStatus = currentMsg.body.readInt();
            mObj.tempPeerlessNum = currentMsg.body.readInt();
            mObj.attackGenius = SpiritGenius.cheakGenius(mObj.attackGeniusValue);
            mObj.defenceGenius = SpiritGenius.cheakGenius(mObj.defenceGeniusValue);
            mObj.magicGenius = SpiritGenius.cheakGenius(mObj.magicGeniusValue);
            mObj.resistanceGenius = SpiritGenius.cheakGenius(mObj.resistanceGeniusValue);
            mObj.hpGenius = SpiritGenius.cheakGenius(mObj.hpGeniusValue);
            mObj.speedGenius = SpiritGenius.cheakGenius(mObj.speedGeniusValue);
            mObj.CountGeniuscount = SpiritGenius.countGenius(mObj.attackGenius,mObj.defenceGenius,mObj.magicGenius,mObj.resistanceGenius,mObj.hpGenius,mObj.speedGenius);
            mObj.skillcount = currentMsg.body.readInt();
            mObj.select = 1;
            result = [];
            temparr = [];
            for(i = 0; i < mObj.skillcount; i++)
            {
               obj = {};
               obj.skillid = currentMsg.body.readInt();
               temparr.push(obj.skillid);
               obj.skillnum = currentMsg.body.readInt();
               obj.skillmaxnum = currentMsg.body.readInt();
               result.push(obj);
            }
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
            symmLength = currentMsg.body.readInt();
            symmList = [];
            for(z = 0; z < symmLength; z++)
            {
               symmObj = {};
               symmObj.symmPlace = currentMsg.body.readInt();
               symmObj.symmId = currentMsg.body.readInt();
               symmObj.symmIndex = currentMsg.body.readInt();
               symmObj.symmFlag = mObj.id;
               symmList.push(symmObj);
            }
            mObj.symmList = symmList;
            tempskillid = currentMsg.body.readInt();
            while(tempskillid != -1 && tempskillid != 0)
            {
               if(tempskillid > 0 && temparr.indexOf(tempskillid) == -1)
               {
                  obj2 = {};
                  obj2.skillid = tempskillid;
                  allSkillList.push(obj2);
               }
               tempskillid = currentMsg.body.readInt();
            }
            tempskillid = currentMsg.body.readInt();
            while(tempskillid != -1 && tempskillid != 0)
            {
               if(tempskillid > 0 && temparr.indexOf(tempskillid) == -1)
               {
                  obj2 = {};
                  obj2.skillid = tempskillid;
                  allSkillList.push(obj2);
               }
               tempskillid = currentMsg.body.readInt();
            }
            mObj.skilllist = result;
            mObj.allSkillList = allSkillList;
            mObj.allSkillList.sortOn("skillid",Array.NUMERIC | Array.DESCENDING);
            mArrary.push(mObj);
         }
         trace("SpiritParse======================妖怪技能==================",this.params.monsterCurrentLength,this.params.monsterTotalLenght);
         this.params.monsterlist = mArrary;
         GameData.instance.playerData.packMonsters = null;
         GameData.instance.playerData.packMonsters = mArrary;
      }
   }
}

