package com.game.modules.parse
{
   import com.game.modules.control.monster.SpiritGenius;
   import com.publiccomponent.loading.XMLLocator;
   import org.green.server.data.MsgPacket;
   
   public class ToolParse
   {
      
      public function ToolParse()
      {
         super();
      }
      
      public function parse(msg:MsgPacket) : Object
      {
         var currentMsg:MsgPacket = null;
         var xml:XML = null;
         var result:Array = null;
         var temparr:Array = null;
         var i:int = 0;
         var tempskillid:int = 0;
         var allSkillList:Array = null;
         var unableSkillCount:int = 0;
         var f:int = 0;
         var obj:Object = null;
         var skill:XML = null;
         var obj2:Object = null;
         var skill2:XML = null;
         var obj3:Object = null;
         var params:Object = {};
         params.propsid = msg.body.readInt();
         params.monsterid = msg.body.readInt();
         if(params.propsid == 100013)
         {
            currentMsg = msg;
            params.id = currentMsg.body.readInt();
            params.typeid = currentMsg.body.readInt();
            params.iid = currentMsg.body.readInt();
            xml = XMLLocator.getInstance().getSprited(params.iid);
            params.name = xml == null ? "" : xml.name;
            params.isfirst = currentMsg.body.readInt();
            params.level = currentMsg.body.readInt();
            params.exp = currentMsg.body.readInt();
            params.type = currentMsg.body.readInt();
            params.attack = currentMsg.body.readInt();
            params.defence = currentMsg.body.readInt();
            params.magic = currentMsg.body.readInt();
            params.resistance = currentMsg.body.readInt();
            params.strength = currentMsg.body.readInt();
            params.hp = currentMsg.body.readInt();
            params.speed = currentMsg.body.readInt();
            params.mold = currentMsg.body.readInt();
            params.state = currentMsg.body.readInt();
            params.needExp = currentMsg.body.readInt();
            params.timetxt = currentMsg.body.readInt();
            params.attackLearnValue = currentMsg.body.readInt();
            params.defenceLearnValue = currentMsg.body.readInt();
            params.magicLearnValue = currentMsg.body.readInt();
            params.resistanceLearnValue = currentMsg.body.readInt();
            params.hpLearnValue = currentMsg.body.readInt();
            params.speedLearnVale = currentMsg.body.readInt();
            params.attackGeniusValue = currentMsg.body.readInt();
            params.defenceGeniusValue = currentMsg.body.readInt();
            params.magicGeniusValue = currentMsg.body.readInt();
            params.resistanceGeniusValue = currentMsg.body.readInt();
            params.hpGeniusValue = currentMsg.body.readInt();
            params.speedGeniusValue = currentMsg.body.readInt();
            params.attackGenius = SpiritGenius.cheakGenius(params.attackGeniusValue);
            params.defenceGenius = SpiritGenius.cheakGenius(params.defenceGeniusValue);
            params.magicGenius = SpiritGenius.cheakGenius(params.magicGeniusValue);
            params.resistanceGenius = SpiritGenius.cheakGenius(params.resistanceGeniusValue);
            params.hpGenius = SpiritGenius.cheakGenius(params.hpGeniusValue);
            params.speedGenius = SpiritGenius.cheakGenius(params.speedGeniusValue);
            params.CountGeniuscount = SpiritGenius.countGenius(params.attackGenius,params.defenceGenius,params.magicGenius,params.resistanceGenius,params.strengthGenius,params.speedGenius);
            params.skillcount = currentMsg.body.readInt();
            params.select = 1;
            result = [];
            temparr = [];
            for(i = 0; i < params.skillcount; i++)
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
            tempskillid = 1;
            allSkillList = [];
            while(tempskillid != 0)
            {
               obj2 = {};
               obj2.skillid = currentMsg.body.readInt();
               tempskillid = int(obj2.skillid);
               skill2 = XMLLocator.getInstance().getSkill(obj2.skillid);
               if(skill2 != null)
               {
                  if(tempskillid != 0 && temparr.indexOf(tempskillid) == -1)
                  {
                     obj2.skillname = skill2.name;
                     obj2.power = skill2.power;
                     obj2.count = skill2.count;
                     obj2.desc = skill2.desc;
                     obj2.skillmaxnum = obj2.skillnum = skill2.count;
                     allSkillList.push(obj2);
                  }
               }
            }
            unableSkillCount = currentMsg.body.readInt();
            for(f = 0; f < unableSkillCount; f++)
            {
               obj3 = {};
               obj3.skillid = 0;
               obj3.skillname = "无";
               obj3.power = 0;
               obj3.desc = "无";
               allSkillList.push(obj3);
            }
            params.skilllist = result;
            params.allSkillList = allSkillList;
         }
         return params;
      }
   }
}

