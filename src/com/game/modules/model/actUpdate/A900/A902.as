package com.game.modules.model.actUpdate.A900
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.locators.CacheData;
   import com.game.locators.GameData;
   import com.game.locators.MsgDoc;
   import com.game.modules.view.WindowLayer;
   import com.game.modules.vo.ActivityVo;
   import com.game.util.FloatAlert;
   import com.publiccomponent.alert.Alert;
   import org.green.server.events.MsgEvent;
   import org.green.server.manager.SocketManager;
   
   public class A902
   {
      
      private static var _ins:A902;
      
      public function A902()
      {
         super();
      }
      
      public static function get ins() : A902
      {
         return _ins = _ins || new A902();
      }
      
      public function onPerishEvilHandel(vo:ActivityVo, evt:MsgEvent) : void
      {
         var result:int = 0;
         var len:int = 0;
         var dataList:Array = null;
         var obj:Object = null;
         var type:int = 0;
         var flag:int = 0;
         var index:int = 0;
         var award:int = 0;
         if(vo == null || evt == null)
         {
            return;
         }
         var i:int = 0;
         switch(vo.protocolID)
         {
            case 1:
               vo.valueobject.flag = evt.msg.body.readInt();
               vo.valueobject.list = [];
               if(vo.valueobject.flag == 1)
               {
                  for(i = 0; i < 4; i++)
                  {
                     index = evt.msg.body.readInt();
                     vo.valueobject.list.push({"type":index});
                  }
               }
               vo.valueobject.evilFlag = evt.msg.body.readInt();
               if(vo.valueobject.evilFlag == 1)
               {
                  vo.valueobject.list.push({"type":99961});
               }
               len = int(vo.valueobject.list.length);
               if(len > 0 && CacheData.instance.perishEvilScene == 0)
               {
                  CacheData.instance.perishEvilScene = GameData.instance.playerData.currentScenenId;
                  ApplicationFacade.getInstance().dispatch(EventConst.BOBSTATECLICK,{
                     "url":"assets/dailyactive/perishevil/perishEvilModule.swf",
                     "xCoord":0,
                     "yCoord":0,
                     "moduleParams":vo.valueobject.list
                  });
               }
               break;
            case 2:
               result = evt.msg.body.readInt();
               if(result == 1)
               {
                  new FloatAlert().show(WindowLayer.instance.stage,300,350,"场景没有这只妖怪哦~");
               }
               else if(result == 2)
               {
                  new FloatAlert().show(WindowLayer.instance.stage,300,350,"战胜次数已经达到上限了哦~");
               }
               else if(result == 3)
               {
                  new FloatAlert().show(WindowLayer.instance.stage,300,350,"挑战魔君的时间已经结束了哦~");
               }
               else if(result == 4)
               {
                  new FloatAlert().show(WindowLayer.instance.stage,300,350," 没有召唤出魔君，不能挑战~");
               }
               else if(result == 5)
               {
                  new FloatAlert().show(WindowLayer.instance.stage,300,350,"你已经战胜过这只妖怪了哦~");
               }
               break;
            case 3:
               dataList = [];
               obj = {};
               result = evt.msg.body.readInt();
               ApplicationFacade.getInstance().dispatch(EventConst.BATTLE_ACT_OVER,{"result":result});
               type = evt.msg.body.readInt();
               if(result == 0 && type == 1)
               {
                  ApplicationFacade.getInstance().dispatch(EventConst.SENDMSGTOSWF,{
                     "msgname":"onperishEvilModule_update",
                     "radio":"perishEvilModuleClick"
                  });
               }
               if(result == 0)
               {
                  if(type == 0)
                  {
                     obj.expNum = evt.msg.body.readInt();
                     obj.coinNum = evt.msg.body.readInt();
                     obj.IsSuccFlag = evt.msg.body.readInt();
                     if(obj.IsSuccFlag == 1)
                     {
                        SocketManager.getGreenSocket().sendCmd(MsgDoc.OP_CLIENT_ACTIVITY_QINGYANG.send,902,[1,GameData.instance.playerData.sceneId]);
                        new Alert().show("异界魔尊已经出现在你身边，击败它将获得大量奖励！~");
                     }
                  }
                  vo.valueobject.awardFlag = evt.msg.body.readInt();
                  if(vo.valueobject.awardFlag == 1)
                  {
                     obj.type = 3;
                     obj.awardlist = [];
                     obj.getlist = [];
                     obj.awardTime = evt.msg.body.readInt();
                     for(i = 0; i < 6; i++)
                     {
                        award = evt.msg.body.readInt();
                        obj.awardlist.push(award);
                     }
                     dataList.push(obj);
                  }
                  else
                  {
                     obj.type = 2;
                     dataList.push(obj);
                  }
                  ApplicationFacade.getInstance().dispatch(EventConst.BOBSTATECLICK,{
                     "url":"assets/dailyactive/perishevil/perishEvilBattleUI.swf",
                     "xCoord":0,
                     "yCoord":0,
                     "moduleParams":dataList
                  });
               }
               break;
            case 4:
               vo.valueobject.result = evt.msg.body.readInt();
               break;
            case 5:
               vo.valueobject.flag = evt.msg.body.readInt();
               if(vo.valueobject.flag == 1)
               {
                  vo.valueobject.monsterType = evt.msg.body.readInt();
                  vo.valueobject.time = evt.msg.body.readInt();
                  vo.valueobject.mapid = evt.msg.body.readInt();
               }
               break;
            case 6:
               flag = evt.msg.body.readInt();
               if(flag == 2)
               {
                  SocketManager.getGreenSocket().sendCmd(MsgDoc.OP_CLIENT_ACTIVITY_QINGYANG.send,902,[1,GameData.instance.playerData.sceneId]);
               }
         }
      }
   }
}

