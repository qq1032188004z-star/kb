package com.game.modules.parse
{
   import com.game.modules.control.monster.SpiritGenius;
   import com.publiccomponent.loading.XMLLocator;
   import org.green.server.data.MsgPacket;
   
   public class SortParse
   {
      
      private var params:Object = {};
      
      public function SortParse()
      {
         super();
      }
      
      public function parse(msg:MsgPacket) : Object
      {
         var obj2:Object = null;
         var skill2:XML = null;
         var obj:Object = null;
         var skill:XML = null;
         var obj3:Object = null;
         var currentMsg:MsgPacket = msg;
         this.params.id = currentMsg.body.readInt();
         this.params.typeid = currentMsg.body.readInt();
         this.params.iid = currentMsg.body.readInt();
         var xml:XML = XMLLocator.getInstance().getSprited(this.params.iid);
         this.params.name = xml == null ? "" : String(xml.name);
         this.params.isfirst = currentMsg.body.readInt();
         this.params.level = currentMsg.body.readInt();
         this.params.exp = currentMsg.body.readInt();
         this.params.type = currentMsg.body.readInt();
         this.params.forbitItem = currentMsg.body.readInt();
         this.params.attack = currentMsg.body.readInt();
         this.params.defence = currentMsg.body.readInt();
         this.params.magic = currentMsg.body.readInt();
         this.params.resistance = currentMsg.body.readInt();
         this.params.strength = currentMsg.body.readInt();
         this.params.hp = currentMsg.body.readInt();
         this.params.speed = currentMsg.body.readInt();
         this.params.mold = currentMsg.body.readInt();
         this.params.state = currentMsg.body.readInt();
         this.params.needExp = currentMsg.body.readInt();
         this.params.timetxt = currentMsg.body.readInt();
         this.params.sex = currentMsg.body.readInt();
         this.params.attackLearnValue = currentMsg.body.readInt();
         this.params.defenceLearnValue = currentMsg.body.readInt();
         this.params.magicLearnValue = currentMsg.body.readInt();
         this.params.resistanceLearnValue = currentMsg.body.readInt();
         this.params.hpLearnValue = currentMsg.body.readInt();
         this.params.speedLearnVale = currentMsg.body.readInt();
         this.params.attackGeniusValue = currentMsg.body.readInt();
         this.params.defenceGeniusValue = currentMsg.body.readInt();
         this.params.magicGeniusValue = currentMsg.body.readInt();
         this.params.resistanceGeniusValue = currentMsg.body.readInt();
         this.params.hpGeniusValue = currentMsg.body.readInt();
         this.params.speedGeniusValue = currentMsg.body.readInt();
         this.params.attackGenius = SpiritGenius.cheakGenius(this.params.attackGeniusValue);
         this.params.defenceGenius = SpiritGenius.cheakGenius(this.params.defenceGeniusValue);
         this.params.magicGenius = SpiritGenius.cheakGenius(this.params.magicGeniusValue);
         this.params.resistanceGenius = SpiritGenius.cheakGenius(this.params.resistanceGeniusValue);
         this.params.hpGenius = SpiritGenius.cheakGenius(this.params.hpGeniusValue);
         this.params.speedGenius = SpiritGenius.cheakGenius(this.params.speedGeniusValue);
         this.params.CountGeniuscount = SpiritGenius.countGenius(this.params.attackGenius,this.params.defenceGenius,this.params.magicGenius,this.params.resistanceGenius,this.params.hpGenius,this.params.speedGenius);
         this.params.uprlitemid = currentMsg.body.readInt();
         this.params.isiprlopen = currentMsg.body.readInt();
         this.params.uprltimes = currentMsg.body.readInt();
         this.params.skillcount = currentMsg.body.readInt();
         this.params.select = 1;
         var result:Array = [];
         var temparr:Array = [];
         var len:int = this.params.skillcount > 100 ? 0 : int(this.params.skillcount);
         for(var i:int = 0; i < len; i++)
         {
            obj = {};
            obj.skillid = currentMsg.body.readInt();
            temparr.push(obj.skillid);
            skill = XMLLocator.getInstance().getSkill(obj.skillid);
            if(skill != null)
            {
               obj.skillname = skill.name;
               obj.power = skill.power;
               obj.desc = skill.desc;
            }
            if(skill == null)
            {
               O.o(obj.skillid);
            }
            obj.skillnum = currentMsg.body.readInt();
            obj.skillmaxnum = currentMsg.body.readInt();
            result.push(obj);
         }
         var tempskillid:int = 1;
         var allSkillList:Array = [];
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
         var unableSkillCount:int = currentMsg.body.readInt();
         for(var f:int = 0; f < unableSkillCount; f++)
         {
            obj3 = {};
            obj3.skillid = 0;
            allSkillList.push(obj3);
         }
         var symmType:int = currentMsg.body.readInt();
         O.o("symmType:",symmType);
         this.params.symmFlag = symmType > 0 ? true : false;
         this.params.skilllist = result;
         return this.params;
      }
   }
}

