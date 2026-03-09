package com.game.modules.control
{
   import com.channel.Message;
   import com.core.observer.MessageEvent;
   import com.core.view.ViewConLogic;
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.locators.GameData;
   import com.game.locators.MsgDoc;
   import com.game.manager.FishManager;
   import com.game.modules.ai.AlphaArea;
   import com.game.modules.control.task.TaskList;
   import com.game.modules.view.MapView;
   import com.game.util.MD5;
   import com.publiccomponent.alert.Alert;
   
   public class FlashControl extends ViewConLogic
   {
      
      public static const NAME:String = "flashcontrol";
      
      private var tempTownerId:int;
      
      public function FlashControl(name:String = null, viewComponent:Object = null)
      {
         super(NAME,viewComponent);
      }
      
      override public function listEvents() : Array
      {
         return [[EventConst.QUERYCOPYPROGRESS,this.onQuerCopyProgress],[EventConst.GOTONEXTLEVEL,this.onGotoNextLevel],[EventConst.EXITWORLD,this.onExitWorld],[EventConst.SENDMSG,this.onSendMsgHandler],[EventConst.BUYGOODS,this.onBuyGoods],[EventConst.CREATEROLE,this.onCreateRole],[EventConst.LINGQUPRIZE,this.onLingQuPrize],[EventConst.LINGQUNEWHAND,this.onLingQuNewHand],[EventConst.START_LITTLE_GAME,this.onStartLittleGame],[EventConst.SENDMSGTOSWF,this.sendMsgToSwf],[EventConst.GETFABAO,this.getFabao],[EventConst.REMOVESHADE,this.removeShade],[EventConst.ARRIVESHUILIANDONG,this.arriveToDong],[EventConst.ARRIVEXUANWO,this.arriveXuanwo],[EventConst.ARRIVEXUAN,this.arriveXuan],[EventConst.YUNLEIXU_SHOWLEIDIAN,this.onYunLeiXunLeiDian]];
      }
      
      private function arriveToDong(evt:MessageEvent) : void
      {
         if(MapView.instance.masterPerson.moveto(evt.body.steerX,evt.body.steerY,this.justLoadShuiliandong))
         {
            ApplicationFacade.getInstance().dispatch(EventConst.ROLEMOVE,{
               "newx":evt.body.steerX,
               "newy":evt.body.steerY,
               "path":null
            });
         }
      }
      
      private function arriveXuan(evt:MessageEvent) : void
      {
         var obj:Object = evt.body;
         var d:String = GameData.instance.playerData.uid + "|" + obj["spiritLevel"] + "|" + obj["spiritHp"] + "|" + obj["spiritAtk"] + "|" + obj["spiritDef"] + "|" + obj["spiritMagAtk"] + "|" + obj["spiritMagDef"] + "|" + obj["spiritSpeed"];
         var str:String = MD5.hash(d);
         dispatch(EventConst.STOPOK,this.getCode(str.toUpperCase()));
      }
      
      private function getCode(str:String) : String
      {
         var code:String = "";
         for(var i:int = 0; i < str.length; i += 2)
         {
            code += str.substr(i,1);
         }
         return code;
      }
      
      private function arriveXuanwo(evt:MessageEvent) : void
      {
         FishManager.getInstance().gotoCheakFish(evt.body.body);
      }
      
      private function justLoadShuiliandong() : void
      {
         if(GameData.instance.playerData.currentScenenId == 30005 && !TaskList.getInstance().hasBeenComplete(3019001))
         {
            new Alert().show("想进去？那就去找傲来海岸上摘椰子的老猴吧！");
            return;
         }
         MapView.instance.loadMap(30006);
      }
      
      private function removeShade(evt:MessageEvent) : void
      {
         AlphaArea.instance.unLoadAlpha();
      }
      
      private function onQuerCopyProgress(event:MessageEvent) : void
      {
         var leaveBob:Function = null;
         leaveBob = function(... rest):void
         {
            if("确定" == rest[0])
            {
               if(GameData.instance.playerData.bobOwner == 2)
               {
                  sendMessage(MsgDoc.OP_CLIENT_OUT_DBOB.send);
               }
               else
               {
                  sendMessage(MsgDoc.OP_CLIENT_OUT_BOB.send);
               }
               if(tempTownerId == 13)
               {
                  justOpenCopyView();
                  return;
               }
               MapView.instance.masterPerson.moveto(event.body.steerX,event.body.steerY,justOpenCopyView);
            }
         };
         this.tempTownerId = event.body.towerid;
         if(Boolean(GameData.instance.playerData.bobOwner))
         {
            new Alert().showSureOrCancel("是否离开擂台",leaveBob);
            return;
         }
         if(this.tempTownerId == 13)
         {
            this.justOpenCopyView();
            return;
         }
         MapView.instance.masterPerson.moveto(event.body.steerX,event.body.steerY,this.justOpenCopyView);
      }
      
      private function justOpenCopyView() : void
      {
         sendMessage(MsgDoc.OP_QUERY_COPYP_ROGRESS.send,this.tempTownerId);
      }
      
      private function onGotoNextLevel(event:MessageEvent) : void
      {
         sendMessage(MsgDoc.CLIENT_GOTO_COPY_LEVEL.send,GameData.instance.playerData.currentCopyLevel);
      }
      
      private function onExitWorld(event:MessageEvent) : void
      {
         sendMessage(MsgDoc.OP_CLIENT_EXIT_WORLD.send,GameData.instance.playerData.serverId);
      }
      
      private function onSendMsgHandler(event:MessageEvent) : void
      {
         sendMessage(MsgDoc.OP_CLIENT_CHAT.send,0,[1,0,String(event.body)]);
      }
      
      private function onBuyGoods(event:MessageEvent) : void
      {
         var params:Object = event.body;
         if(params != null)
         {
            if(params.count == 0)
            {
               new Alert().show("请输入购买数量");
               return;
            }
            if(GameData.instance.playerData.isVip)
            {
               if(params.price * 0.8 > GameData.instance.playerData.coin)
               {
                  new Alert().show("你的钱不够了");
                  return;
               }
            }
            else if(params.price > GameData.instance.playerData.coin)
            {
               new Alert().show("你的钱不够了");
               return;
            }
            sendMessage(MsgDoc.OP_CLIENT_BUY_GOODS.send,params.id,[int(params.count)]);
            ApplicationFacade.getInstance().dispatch(EventConst.GET_ITEM_NUM,{"item":[params.id]});
         }
      }
      
      private function onCreateRole(event:MessageEvent) : void
      {
         sendMessage(MsgDoc.OP_CLIENT_CREATE_ROLE.send,0,[1,event.body.name]);
      }
      
      private function onLingQuPrize(event:MessageEvent) : void
      {
         sendMessage(MsgDoc.OP_CLIENT_LINGQUPRIZE.send);
      }
      
      private function onLingQuNewHand(event:MessageEvent) : void
      {
         var param:Object = event.body;
         if(param != null && Boolean(param.hasOwnProperty("code")))
         {
            if(param.code == 1)
            {
               sendMessage(MsgDoc.OP_CLIENT_NEWHAND.send,1,[0,0]);
            }
            else if(param.code == 2)
            {
               sendMessage(MsgDoc.OP_CLIENT_NEWHAND.send,2,[param.id,0]);
            }
            else if(param.code == 3)
            {
               GameData.instance.playerData.coin += 5000;
               sendMessage(MsgDoc.OP_CLIENT_NEWHAND.send,3,[0,0]);
            }
         }
      }
      
      private function onStartLittleGame(event:MessageEvent) : void
      {
         sendMessage(MsgDoc.OP_CLIENT_LITTLE_GAME.send,int(event.body),[0,0]);
      }
      
      private function sendMsgToSwf(evt:MessageEvent) : void
      {
         var params:Object = evt.body;
         new Message(params.msgname,params.body).sendToChannel(params.radio);
      }
      
      private function getFabao(evt:MessageEvent) : void
      {
         sendMessage(MsgDoc.OP_CLIENT_FABAO.send);
      }
      
      private function onYunLeiXunLeiDian(evt:MessageEvent) : void
      {
         var id:int = int(evt.body.playerId);
         sendMessage(MsgDoc.OP_CLIENT_MESSAGE_FACE.send,2,[id]);
      }
   }
}

