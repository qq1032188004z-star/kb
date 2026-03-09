package com.xygame.module.battle.data
{
   import com.publiccomponent.loading.XMLLocator;
   import com.publiccomponent.loading.data.BufInfoTypeData;
   
   public class BufData
   {
      
      private static var buff55:Array = ["","5回合只受风系伤害、5回合只受机械系伤害循环","先手伤害加倍","秒杀直接对其造成100伤害以上的妖怪","每回合结束回血2000","满状态复活一次","PP值无限","自身血量低于1000时回血至满血状态"];
      
      private static var buff57:Array = ["","降低对手命中率","每回合恢复血量","令对手每回合减少技能使用次数","令对手每回合损血"];
      
      public static const BUF_NAME:Object = {
         1:"昏迷",
         2:"流血",
         3:"速度下降",
         4:"速度提升",
         5:"防御力下降",
         6:"防御力提升",
         7:"攻击力下降",
         8:"攻击力提升",
         9:"中毒",
         10:"受到法术伤害异常",
         11:"受到物理伤害异常",
         12:"不能使用物理技能",
         14:"不能使用法术技能",
         18:"法术下降",
         19:"法术提升",
         20:"命中率提升",
         21:"命中率下降",
         22:"抗性提升",
         23:"抗性下降",
         26:"睡眠",
         27:"迷惑",
         28:"疲劳",
         29:"灼伤",
         30:"激怒",
         31:"麻痹",
         32:"混乱",
         33:"吸血",
         34:"窒息",
         36:"加血",
         37:"加血",
         47:"冰冻",
         48:"自身血量低于50%时伤害加倍",
         49:"所有增益状态被消除",
         50:"所有负面状态被去除",
         62:"加血",
         63:"所有负面状态被去除"
      };
      
      public static const ROUND_START_ADD:Array = [62];
      
      public static const BUF_TYPE_0:int = 0;
      
      public static const BUF_TYPE_1:int = 1;
      
      public static const BUF_TYPE_2:int = 2;
      
      public static const BUF_TYPE_3:int = 3;
      
      public static const BUF_TYPE_4:int = 4;
      
      public static const BUF_TYPE_5:int = 5;
      
      public static const BUF_TYPE_6:int = 6;
      
      public static const COMBAT_SITE_ADD:int = 1;
      
      public static const COMBAT_SITE_MD:int = 2;
      
      public static const COMBAT_SITE_DEL:int = 3;
      
      public static const SITE_RECOVER_ID:int = 9999;
      
      public var add_or_remove:int;
      
      private var _oldParam1:int;
      
      public var param1:int;
      
      private var _param2:int;
      
      public var tipString:String;
      
      public var bufType:int;
      
      public var round:int;
      
      public const SPECIALID_ARR:Array = [3,4,5,6,7,8,18,19,21,20,23,22];
      
      private var _bufid:int;
      
      public var defid:int;
      
      public var atkid:int;
      
      public var left_or_right:int;
      
      private var _curTD:BufInfoTypeData;
      
      public function BufData()
      {
         super();
      }
      
      public function get param2() : int
      {
         return this._param2;
      }
      
      public function set param2(value:int) : void
      {
         this._param2 = value;
         if(Boolean(this._curTD))
         {
            this.tipString = this._curTD.combat_desc.replace("#num1#",this.param1).replace("#num2#",this._param2);
            if(Boolean(this._curTD.other_desc))
            {
               this._curTD.initOtherDesc(this.tipString);
            }
         }
      }
      
      public function get bufid() : int
      {
         return this._bufid;
      }
      
      public function set bufid(value:int) : void
      {
         this._bufid = value;
         this._curTD = XMLLocator.getInstance().getBufInfo(this._bufid);
      }
      
      public function get bufIconId() : int
      {
         var bfid:int = this._bufid;
         if(Boolean(this._curTD))
         {
            return this._bufid;
         }
         switch(bfid)
         {
            case 15:
            case 16:
               if(this.param1 == 0)
               {
                  this.tipString = (Boolean("免疫" + (bfid == 15)) ? "法术" : "物理") + "伤害";
               }
               else if(this.param1 == 50)
               {
                  this.tipString = (Boolean("所受" + (bfid == 15)) ? "法术" : "物理") + "伤害减半";
               }
               else
               {
                  this.tipString = (Boolean("受到" + (bfid == 15)) ? "法术" : "物理") + "伤害异常";
               }
               return this._bufid;
            case 55:
               if(this.param1 < 8 && this.param1 > 0)
               {
                  this.tipString = buff55[this.param1];
               }
               else
               {
                  this.tipString = "";
               }
               return this._bufid;
            case 57:
               if(this.param1 == 1 && this._param2 > 0 && this._param2 < 5)
               {
                  this.tipString = buff57[this._param2];
               }
               else
               {
                  this.tipString = "";
               }
               return this._bufid;
            default:
               if(this.SPECIALID_ARR.indexOf(int(this._bufid)) == -1)
               {
                  this.tipString = BUF_NAME[this._bufid];
                  if(bfid == 10)
                  {
                     this.tipString = "技能伤害比率为" + this.param1 + "%";
                  }
                  else if(bfid == 11)
                  {
                     this.tipString = "物理伤害比率为" + this.param1 + "%";
                  }
                  return this._bufid;
               }
               if(this.SPECIALID_ARR.indexOf(int(this._bufid)) % 2 == 1)
               {
                  if(this.param1 > 0)
                  {
                     bfid = this._bufid;
                     this.tipString = BUF_NAME[bfid] + "" + this.param1 + "级";
                  }
                  else if(this.param1 < 0)
                  {
                     if(this._bufid < 20)
                     {
                        bfid = this._bufid - 1;
                     }
                     else
                     {
                        bfid = this._bufid + 1;
                     }
                     this.tipString = BUF_NAME[bfid] + "" + -this.param1 + "级";
                  }
                  else if(this.param1 == 0)
                  {
                     bfid = 0;
                  }
               }
               else if(this.SPECIALID_ARR.indexOf(int(this._bufid)) % 2 == 0)
               {
                  if(this.param1 > 0)
                  {
                     if(bfid < 20)
                     {
                        bfid = this._bufid + 1;
                     }
                     else
                     {
                        bfid = this._bufid - 1;
                     }
                     this.tipString = BUF_NAME[bfid] + "" + this.param1 + "级";
                  }
                  else if(this.param1 < 0)
                  {
                     bfid = this._bufid;
                     this.tipString = BUF_NAME[bfid] + "" + -this.param1 + "级";
                  }
                  else if(this.param1 == 0)
                  {
                     bfid = 0;
                  }
               }
               else
               {
                  bfid = this._bufid;
                  this.tipString = BUF_NAME[bfid];
               }
               return bfid;
         }
      }
      
      public function get bufName() : String
      {
         var bid:int = this.bufIconId;
         if(Boolean(this._curTD))
         {
            return this._curTD.name;
         }
         if(bid == 55)
         {
            if(this.param1 < 8 && this.param1 > 0)
            {
               return buff55[this.param1];
            }
            return "";
         }
         if(this._bufid == 57)
         {
            if(this.param1 == 1 && this._param2 > 0 && this._param2 < 5)
            {
               return buff57[this._param2];
            }
            return "";
         }
         if(bid == 15 || bid == 16)
         {
            if(this.param1 == 0)
            {
               return (Boolean("免疫" + (bid == 15)) ? "法术" : "物理") + "伤害";
            }
            if(this.param1 == 50)
            {
               return (Boolean("所受" + (bid == 15)) ? "法术" : "物理") + "伤害减半";
            }
            return (Boolean("受到" + (bid == 15)) ? "法术" : "物理") + "伤害异常";
         }
         if(bid > 0 && Boolean(BUF_NAME.hasOwnProperty(bid.toString())))
         {
            return BUF_NAME[bid];
         }
         return "";
      }
      
      public function get offsetvalue() : int
      {
         if(this.SPECIALID_ARR.indexOf(this._bufid) % 2 == 1)
         {
            if(this._bufid > 19)
            {
               return 1;
            }
            return -1;
         }
         if(this.SPECIALID_ARR.indexOf(this._bufid) % 2 == 0)
         {
            if(this._bufid > 19)
            {
               return -1;
            }
            return 1;
         }
         return 0;
      }
      
      public function getOtherTip(id:int) : String
      {
         if(this._curTD && this._curTD.other_desc && Boolean(this._curTD.other_desc.hasOwnProperty(id.toString())))
         {
            return this._curTD.other_desc[id];
         }
         return this.tipString;
      }
   }
}

