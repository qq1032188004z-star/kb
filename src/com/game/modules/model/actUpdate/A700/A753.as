package com.game.modules.model.actUpdate.A700
{
   import com.game.cue.base.CueEnum;
   import com.game.cue.util.KabuCueUtil;
   import com.game.locators.CacheData;
   import com.game.modules.view.WindowLayer;
   import com.game.modules.vo.ActivityVo;
   import com.game.util.BynaryUtil;
   import com.game.util.FloatAlert;
   import org.green.server.events.MsgEvent;
   
   public class A753
   {
      
      private static var _ins:A753;
      
      public function A753()
      {
         super();
      }
      
      public static function get ins() : A753
      {
         return _ins = _ins || new A753();
      }
      
      public function handleKabuOnlineData(vo:ActivityVo, evt:MsgEvent) : void
      {
         var i:int = 0;
         var state:int = 0;
         var result:Object = new Object();
         if(evt == null)
         {
            return;
         }
         evt.msg.body.position = 0;
         var oper:String = evt.msg.body.readUTF();
         var code:int = 0;
         var list:Array = [];
         switch(oper)
         {
            case "open_ui":
               result.onlineTime = evt.msg.body.readInt();
               result.onlineFlag = evt.msg.body.readInt();
               for(i = 0; i < 6; i++)
               {
                  state = BynaryUtil.checkIndex(i + 1,result.onlineFlag) ? 1 : 0;
                  list.push(state);
               }
               CacheData.instance.kabuOnline.initializeOnline(result.onlineTime,list);
               result.energy = evt.msg.body.readInt();
               result.gotAwardFlag = evt.msg.body.readInt();
               evt.msg.body.readInt();
               result.award1 = evt.msg.body.readInt();
               result.award2 = evt.msg.body.readInt();
               result.award3 = evt.msg.body.readInt();
               result.award4 = evt.msg.body.readInt();
               CacheData.instance.kabuOnline.initializeOnlinePower(result);
               break;
            case "buy_monster":
               result.result = evt.msg.body.readInt();
               if(result.result == 1)
               {
                  KabuCueUtil.instance.showOtherCue(CueEnum.CUE_NOT_KBCOIN,"skillSwapNotKbCoin.swf");
               }
               break;
            case "energy_reward":
               result.index = evt.msg.body.readInt();
               result.result = evt.msg.body.readInt();
               switch(result.result)
               {
                  case 0:
                     CacheData.instance.kabuOnline.getAwardBack(result.index);
                     break;
                  case 3:
                     new FloatAlert().show(WindowLayer.instance,250,400,"能量不足");
                     break;
                  case 4:
                     new FloatAlert().show(WindowLayer.instance,250,400,"已经领取过了");
               }
               break;
            case "online_reward":
               result.index = evt.msg.body.readInt();
               result.result = evt.msg.body.readInt();
               if(result.result == 0)
               {
                  CacheData.instance.kabuOnline.getAwardBack(result.index);
               }
               else if(result.result == 2)
               {
                  new FloatAlert().show(WindowLayer.instance,250,400,"在线时间不足");
               }
               else if(result.result == 4)
               {
                  new FloatAlert().show(WindowLayer.instance,250,400,"已经领取过了");
               }
         }
      }
   }
}

