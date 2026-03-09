package com.game.modules.parse
{
   import com.game.locators.MsgDoc;
   import com.game.modules.view.WindowLayer;
   import com.game.util.FloatAlert;
   import flash.utils.ByteArray;
   import org.green.server.data.MsgPacket;
   import org.green.server.interfaces.IParser;
   
   public class ActivityParse implements IParser
   {
      
      public static var nameList:Array = ["白龙马","猪八戒","沙僧","唐僧","孙悟空","金甲剑狮","绿刺蝠卫","九幽看守者","惊雷大仙","幻咒王","红煞狼怪","噬魂","蓝羽大仙","傲天","冲霄","苍炼狂鲨","苍炼木神","苍炼石骨","苍炼火圣","苍炼金蛛","苍炼獠魔","苍炼月妖","苍炼厉猫","苍炼风鹫","苍炼天卓狼","帝江剑仆","帝江枪将","帝江枪将","帝江浪人","帝江魔尊","伏龙窟","天神界","敬佛堂","地魂界","锁妖塔","摄魂使者","横钢战牛","钢斧鳄","赤蝎皇","刑天","文殊菩萨","太白金星","太上老君","观音菩萨","九天真王","太虚水云鹤","九天战猫","霸刀螳螂","焚天血蟒","地煞猴王"];
      
      protected var curretnMsg:MsgPacket;
      
      public var params:Object = {};
      
      public function ActivityParse()
      {
         super();
      }
      
      public function parse(msg:MsgPacket) : void
      {
         this.curretnMsg = msg;
         switch(msg.mOpcode)
         {
            case MsgDoc.OP_CLIENT_ACTIVITY.back:
               this.analysisCardActivity();
               break;
            case MsgDoc.OP_CLIENT_ACTIVITY_GHARRY.back:
               this.analysisGharry();
         }
      }
      
      private function analysisGharry() : void
      {
         var head:int = this.curretnMsg.mParams;
         this.params.head = head;
         switch(head)
         {
            case 8:
               this.activityEscortGharry();
         }
      }
      
      private function analysisCardActivity() : void
      {
         var head:int = this.curretnMsg.mParams;
         this.params.head = head;
         switch(head)
         {
            case 22:
               this.activityCardAward();
               break;
            case 23:
               this.activityCardAwardSwap();
               break;
            case 24:
               this.activityCardSystem();
               break;
            case 25:
               this.activityCardSystemCards();
               break;
            case 28:
               this.activityCardMyCards();
               break;
            case 29:
               this.activtyCardTurnWaste();
         }
      }
      
      private function activityCardAward() : void
      {
         this.curretnMsg.body.position = 0;
         this.params.cardId = this.curretnMsg.body.readInt();
      }
      
      private function activityCardAwardSwap() : void
      {
         this.curretnMsg.body.position = 0;
         this.params.cardId = this.curretnMsg.body.readInt();
         this.params.result = this.curretnMsg.body.readInt();
      }
      
      private function activityCardSystemCards() : void
      {
         var card:Object = null;
         this.curretnMsg.body.position = 0;
         var list:Array = [];
         for(var i:int = 0; i < 6; i++)
         {
            card = {};
            card.key = this.curretnMsg.body.readInt();
            list.push(card);
         }
         this.params.list = list;
      }
      
      private function activityCardSystem() : void
      {
         this.curretnMsg.body.position = 0;
         this.params.result = this.curretnMsg.body.readInt();
      }
      
      private function activityCardMyCards() : void
      {
         var counts:int = 0;
         var taskVo:Object = null;
         var char:int = 0;
         this.curretnMsg.body.position = 0;
         var taskList:Array = [];
         var i:int = 0;
         counts = this.curretnMsg.body.readInt();
         for(i = 0; i < counts; i++)
         {
            taskVo = this.readTaskVo(this.curretnMsg.body,true);
            taskList.push(taskVo);
         }
         counts = this.curretnMsg.body.readInt();
         for(i = 0; i < counts; i++)
         {
            taskVo = this.readTaskVo(this.curretnMsg.body,false);
            taskList.push(taskVo);
         }
         this.params.taskList = taskList;
         var dayItems:Array = [];
         counts = 30;
         for(i = 0; i < counts; i++)
         {
            char = this.curretnMsg.body.readShort();
            dayItems.push(char);
         }
         this.params.dayItems = dayItems;
         this.params.firstAward = this.curretnMsg.body.readInt();
         this.params.awardTimes = this.curretnMsg.body.readShort();
         this.params.changeTimes = this.curretnMsg.body.readShort();
         this.params.todoyAward = this.curretnMsg.body.readShort();
      }
      
      private function readTaskVo(byte:ByteArray, isDel:Boolean = true) : Object
      {
         var taskVo:Object = {};
         taskVo.online = isDel;
         taskVo.key = byte.readShort();
         taskVo.value = byte.readShort();
         return taskVo;
      }
      
      private function activtyCardTurnWaste() : void
      {
         this.curretnMsg.body.position = 0;
         this.params.cardId = this.curretnMsg.body.readInt();
         new FloatAlert().show(WindowLayer.instance.stage,350,250,"恭喜你获得一张" + nameList[this.params.cardId - 1] + "卡牌",2);
      }
      
      private function activityEscortGharry() : void
      {
         this.curretnMsg.body.position = 0;
         var type:int = this.curretnMsg.body.readInt();
         this.params.type = type;
         switch(type)
         {
            case 1:
               this.params.gharryId = this.curretnMsg.body.readInt();
               this.params.lastCount = this.curretnMsg.body.readInt();
               this.params.reflushToken = this.curretnMsg.body.readInt();
               this.params.rob = this.curretnMsg.body.readInt();
               this.params.escort = this.curretnMsg.body.readInt();
               this.params.escortTimes = this.curretnMsg.body.readInt();
               break;
            case 2:
               this.params.reflushFlag = this.curretnMsg.body.readInt();
               this.params.lastCounts = this.curretnMsg.body.readInt();
               this.params.randomGharry = this.curretnMsg.body.readInt();
               this.params.rob = this.curretnMsg.body.readInt();
               break;
            case 3:
               this.params.reflushFlag = this.curretnMsg.body.readInt();
               this.params.reflushLastCounts = this.curretnMsg.body.readInt();
               this.params.randomGharry = this.curretnMsg.body.readInt();
               this.params.rob = this.curretnMsg.body.readInt();
               break;
            case 6:
               this.params.playerId = this.curretnMsg.body.readInt();
               this.params.playerFlag = this.curretnMsg.body.readInt();
               break;
            case 7:
               this.params.battleFlag = this.curretnMsg.body.readInt();
               break;
            case 8:
               this.params.flushFlag = this.curretnMsg.body.readInt();
               break;
            case 9:
         }
      }
   }
}

