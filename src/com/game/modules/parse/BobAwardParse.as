package com.game.modules.parse
{
   import com.game.locators.GameData;
   import com.game.modules.view.MapView;
   import com.game.modules.view.WindowLayer;
   import com.game.util.AwardAlert;
   import com.publiccomponent.alert.Alert;
   import com.publiccomponent.loading.XMLLocator;
   import org.green.server.data.MsgPacket;
   import org.green.server.interfaces.IParser;
   
   public class BobAwardParse implements IParser
   {
      
      private var xiuwei:Array = ["","攻击","防御","法术","抗性","体力","速度"];
      
      public function BobAwardParse()
      {
         super();
      }
      
      public function parse(msg:MsgPacket) : void
      {
         var xml:XML = null;
         var i:int = 0;
         var l:int = 0;
         var type:int = 0;
         var goodid:int = 0;
         var goodcount:int = 0;
         var money:int = 0;
         var exp:int = 0;
         var index:int = 0;
         var value:int = 0;
         var zhuangbeiid:int = 0;
         var zhuangbeicount:int = 0;
         if(msg.mParams == 999)
         {
            l = msg.body.readInt();
            for(i = 0; i < l; i++)
            {
               type = msg.body.readInt();
               switch(type)
               {
                  case 1:
                     goodid = msg.body.readInt();
                     goodcount = msg.body.readInt();
                     xml = XMLLocator.getInstance().tooldic[goodid];
                     new AwardAlert().showGoodsAward("assets/tool/" + goodid + ".swf",MapView.instance.stage,goodcount + "个" + xml.name,true);
                     break;
                  case 2:
                     money = msg.body.readInt();
                     new AwardAlert().showMoneyAward(money,WindowLayer.instance);
                     break;
                  case 3:
                     exp = msg.body.readInt();
                     new AwardAlert().showExpAward(exp,MapView.instance.stage);
                     break;
                  case 4:
                     index = msg.body.readInt();
                     value = msg.body.readInt();
                     new Alert().showOne("你获得了" + value + "修为");
                     break;
                  case 5:
                     zhuangbeiid = msg.body.readInt();
                     zhuangbeicount = msg.body.readInt();
                     xml = XMLLocator.getInstance().tooldic[zhuangbeiid];
                     new AwardAlert().showGoodsAward("assets/tool/" + zhuangbeiid + ".swf",MapView.instance.stage,zhuangbeicount + "个" + xml.name,true);
               }
            }
         }
         else if(msg.mParams == -1)
         {
            new Alert().showOne("还没有达到奖励条件");
         }
         else if(msg.mParams == -2)
         {
            new Alert().showOne("你已经领取了奖励");
         }
      }
      
      public function parsefloat(msg:MsgPacket) : Array
      {
         var temp1:int = 0;
         var temp2:int = 0;
         var xml:XML = null;
         var i:int = 0;
         var l:int = 0;
         var type:int = 0;
         var tempstr:String = "";
         var awardsarr:Array = [];
         if(msg.mParams == 11)
         {
            l = msg.body.readInt();
            for(i = 0; i < l; i++)
            {
               type = msg.body.readInt();
               switch(type)
               {
                  case 1:
                     temp1 = msg.body.readInt();
                     temp2 = msg.body.readInt();
                     xml = XMLLocator.getInstance().tooldic[temp1];
                     if(Boolean(xml))
                     {
                        tempstr = "获得" + temp2 + "个" + xml.name + "!";
                     }
                     break;
                  case 2:
                     temp1 = msg.body.readInt();
                     GameData.instance.playerData.coin += temp1;
                     tempstr = "获得" + temp1 + "个铜钱!";
                     break;
                  case 3:
                     temp1 = msg.body.readInt();
                     tempstr = "获得" + temp1 + "历练！";
                     break;
                  case 4:
                     temp1 = msg.body.readInt();
                     temp2 = msg.body.readInt();
                     if(Boolean(this.xiuwei[temp1]))
                     {
                        tempstr = "你获得了" + temp2 + this.xiuwei[temp1] + "修为" + "！";
                     }
                     else
                     {
                        trace("少年修为类型不对了 " + temp1);
                     }
                     break;
                  case 5:
                     temp1 = msg.body.readInt();
                     temp2 = msg.body.readInt();
                     xml = XMLLocator.getInstance().tooldic[temp1];
                     if(Boolean(xml))
                     {
                        tempstr = "获得" + temp2 + "个" + xml.name + "!";
                     }
                     break;
                  case 6:
                     temp1 = msg.body.readInt();
                     tempstr = "获得" + temp1 + "积分，记得兑换哦~";
               }
               if(tempstr != "")
               {
                  awardsarr.push(tempstr);
               }
               tempstr = "";
            }
         }
         return awardsarr;
      }
   }
}

