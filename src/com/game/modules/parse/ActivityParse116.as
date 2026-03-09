package com.game.modules.parse
{
   import com.game.modules.parse.intf.IAParse;
   import com.game.modules.vo.ActivityVo;
   import flash.utils.ByteArray;
   
   public class ActivityParse116 implements IAParse
   {
      
      public function ActivityParse116()
      {
         super();
      }
      
      public function parse(vo:ActivityVo, ba:ByteArray) : void
      {
         var numAry:Array = null;
         var ary:Array = null;
         var a8:Array = null;
         var j:int = 0;
         var i:int = 0;
         var i8:int = 0;
         switch(vo.protocolID)
         {
            case 1:
               vo.valueobject["restCdTime"] = ba.readInt();
               vo.valueobject["restCount"] = ba.readInt();
               vo.valueobject["firstTime"] = ba.readInt();
               vo.valueobject["hadDo"] = ba.readInt();
               numAry = [];
               for(j = 0; j < 6; j++)
               {
                  numAry.push(ba.readInt());
               }
               vo.valueobject["bonusAry"] = numAry;
               break;
            case 2:
               vo.valueobject["awardNum"] = ba.readInt();
               break;
            case 3:
               vo.valueobject["result3"] = ba.readInt();
               vo.valueobject["awardNum"] = ba.readInt();
               break;
            case 4:
               vo.valueobject["result4"] = ba.readInt();
               break;
            case 5:
               vo.valueobject["result5"] = ba.readInt();
               ary = [];
               for(i = 0; i < 9; i++)
               {
                  ary.push(ba.readInt());
               }
               vo.valueobject["eventArr"] = ary;
               vo.valueobject["secenid"] = ba.readInt();
               vo.valueobject["secenTime"] = ba.readInt();
               vo.valueobject["flag"] = ba.readInt();
               if(vo.valueobject["flag"] == 0)
               {
                  vo.valueobject["type"] = ba.readInt();
                  vo.valueobject["num"] = ba.readInt();
               }
               break;
            case 6:
               vo.valueobject["result6"] = ba.readInt();
               break;
            case 7:
               vo.valueobject["result7"] = ba.readInt();
               vo.valueobject["awardType"] = ba.readInt();
               vo.valueobject["awardNum"] = ba.readInt();
               vo.valueobject["secenTime"] = ba.readInt();
               break;
            case 8:
               vo.valueobject["endGame"] = ba.readInt();
               a8 = [];
               for(i8 = 0; i8 < 6; i8++)
               {
                  a8.push(ba.readInt());
               }
               vo.valueobject["numArr"] = a8;
               break;
            case 9:
               vo.valueobject["result9"] = ba.readInt();
               vo.valueobject["kbcoin"] = ba.readInt();
               break;
            case 10:
               vo.valueobject["result10"] = ba.readInt();
               vo.valueobject["awardNum"] = ba.readInt();
               vo.valueobject["kbcoin"] = ba.readInt();
               break;
            case 11:
               vo.valueobject["result11"] = ba.readInt();
               vo.valueobject["awardNum"] = ba.readInt();
         }
      }
   }
}

