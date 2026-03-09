package com.game.modules.control.monster
{
   import com.core.observer.MessageEvent;
   import com.core.view.ViewConLogic;
   import com.game.event.EventConst;
   import com.game.global.GlobalConfig;
   import com.game.locators.CacheData;
   import com.game.locators.GameData;
   import com.game.locators.MsgDoc;
   import com.game.manager.AlertManager;
   import com.game.manager.EventManager;
   import com.game.manager.MonsterManger;
   import com.game.modules.view.MapView;
   import com.game.modules.view.monster.MonsterListView;
   import com.game.modules.view.monster.Props;
   import com.game.util.BitValueUtil;
   import com.publiccomponent.alert.Alert;
   import com.publiccomponent.ui.ToolTip;
   import flash.events.Event;
   
   public class MonsterListControl extends ViewConLogic
   {
      
      public static const NAME:String = "monstermediator";
      
      private var propsView:Props;
      
      private var sended:Boolean = true;
      
      public function MonsterListControl(viewComponent:Object)
      {
         super(NAME,viewComponent);
         EventManager.attachEvent(this.view,Event.ADDED_TO_STAGE,this.onAddToStage);
         this.onAddToStage(null);
      }
      
      private function onAddToStage(evt:Event) : void
      {
         this.view.initToolTip();
         CacheData.instance.openState = 2;
         sendMessage(MsgDoc.OP_CLIENT_REQ_SPIRIT_LIST.send);
         EventManager.attachEvent(this.view,MonsterListEvent.GETMONSTERINLIST,this.getMonsterInList);
         EventManager.attachEvent(this.view,MonsterListEvent.GETMONSTEROUTLIST,this.getMonsterOutList);
         EventManager.attachEvent(this.view,MonsterListEvent.CUREALLMONSTER,this.cureAllMonster);
         EventManager.attachEvent(this.view,MonsterListEvent.GCMONSTER,this.gcMonster);
         EventManager.attachEvent(this.view,MonsterListEvent.SETFIRST,this.setFirst);
         EventManager.attachEvent(this.view,EventConst.TRIPODTRAIN,this.tripodTrain);
         EventManager.attachEvent(this.view,MonsterListEvent.GETSYMMPAKAGELIST,this.getSymmList);
         EventManager.attachEvent(this.view,MonsterListEvent.SYMM_WEAR_OR_OFF,this.onSymmWearOrOff);
      }
      
      private function tripodTrain(evt:MessageEvent) : void
      {
         var list:Array = evt.body as Array;
         sendMessage(MsgDoc.OP_CLIENT_TRAIN_MONSTER.send,1,list);
         this.sended = false;
      }
      
      private function onTrainMonsterBack(event:MessageEvent) : void
      {
         if(this.view.stage == null)
         {
            return;
         }
         if(this.view.selectTrainData == null || this.sended)
         {
            return;
         }
         AlertManager.instance.showTipAlert({
            "systemid":1072,
            "flag":4
         });
         var obj:Object = {};
         obj.id = this.view.selectTrainData.id;
         obj.iid = this.view.selectTrainData.iid;
         obj.x = 350;
         obj.y = 300;
         obj.labelName = "正在训练中";
         if(Boolean(GameData.instance.playerData.mstate) && GameData.instance.playerData.msid == obj.id)
         {
            GameData.instance.playerData.mstate = 0;
            MapView.instance.masterPerson.retakeMM();
         }
         if(GameData.instance.playerData.sceneId == 1002 && GameData.instance.playerData.userId == GameData.instance.playerData.houseId)
         {
            MonsterManger.instance.addAIMonsterAtHome(obj);
         }
         this.view.selectTrainData = null;
         this.sended = true;
         this.view.disport();
      }
      
      private function getMonsterInList(evt:MonsterListEvent) : void
      {
         if(evt.params != null)
         {
            sendMessage(MsgDoc.OP_CLIENT_SPIRIT_OPERATOR.send,0,[0,int(evt.params.id)]);
         }
      }
      
      private function getMonsterOutList(evt:MonsterListEvent) : void
      {
         if(evt.params != null)
         {
            sendMessage(MsgDoc.OP_CLIENT_SPIRIT_OPERATOR.send,0,[1,int(evt.params.id)]);
         }
      }
      
      private function cureAllMonster(evt:MonsterListEvent) : void
      {
         sendMessage(MsgDoc.OP_CLIENT_SPIRIT_CURE.send,MonsterListView.curerentId);
      }
      
      private function reGetMonsterList(evt:MessageEvent) : void
      {
         sendMessage(MsgDoc.OP_CLIENT_REQ_SPIRIT_LIST.send);
      }
      
      private function getSymmList(evt:MonsterListEvent) : void
      {
         sendMessage(MsgDoc.OP_CLIENT_SPIRIT_EQUIP_ALL.send,GameData.instance.playerData.userId,[1]);
      }
      
      private function setFirst(evt:MonsterListEvent) : void
      {
         sendMessage(MsgDoc.OP_CLIENT_SET_FIRST.send,0,[int(evt.params.id)]);
      }
      
      public function get view() : MonsterListView
      {
         return this.getViewComponent() as MonsterListView;
      }
      
      override public function listEvents() : Array
      {
         return [[EventConst.GETMONSTERLISTBACK,this.onGetMonsterListBack],[EventConst.MONSTEROPERATION,this.onMonsterOperation],[EventConst.GETPROPSLISTBACK,this.onGetPropsListBack],[EventConst.USEPROPSBACK,this.onUsePropsBack],[EventConst.GCMONSTERBACK,this.onGcMonsterBack],[EventConst.SETFIRSTBACK,this.onSetFirstBack],[EventConst.CUREMONSTERLIVEBACK,this.onCureAllBack],[EventConst.GETMONSTERLIST,this.onReqMonsterList],[EventConst.TELLMONSTERLISTCHANGE,this.reGetMonsterList],[EventConst.STARTTRAINMONSTERBACK,this.onTrainMonsterBack],[EventConst.SYMM_PAKAGE_LIST_BACK,this.onSymmPakageListBack],[EventConst.SYMM_WEAR_BACK,this.onSymmWearBack],[EventConst.SYMM_TAKEOFF_BACK,this.onSymmTakeOffBack],[EventConst.SYMM_SINGLE_LIST_BACK,this.onSymmSingleListBack],[EventConst.S_BATCHUSEPROP_MONSTER,this.onBatchUseProp],[EventConst.S_BATCHUSE_PROPS,this.responseBatchUseProp]];
      }
      
      private function responseBatchUseProp(e:MessageEvent) : void
      {
         e.stopImmediatePropagation();
         this.view.batchUseProp(e.body);
      }
      
      private function onBatchUseProp(e:MessageEvent) : void
      {
         var itemVO:Object = e.body;
         this.view.openBatchUseProp(itemVO);
      }
      
      private function onReqMonsterList(evt:MessageEvent) : void
      {
         var obj:Object = evt.body;
         sendMessage(MsgDoc.OP_CLIENT_REQ_SPIRIT_LIST.send);
      }
      
      private function onGetMonsterListBack(event:MessageEvent) : void
      {
         this.view.build(event.body,false);
      }
      
      private function onMonsterOperation(event:MessageEvent) : void
      {
         var params:Object = event.body;
         this.view.setMonsterState(params.mid,params.ope,params.msid);
      }
      
      private function gcMonster(evt:MonsterListEvent) : void
      {
         sendMessage(MsgDoc.OP_CLIENT_PUTTO_SPIRITSTORE.send,int(evt.params.id),[4,0]);
      }
      
      public function onGetPropsListBack(event:MessageEvent) : void
      {
         for(var i:int = 0; i < event.body.list[0].goods.length; i++)
         {
            if(BitValueUtil.getBitValue(event.body.list[0].goods[i].usableStatus,7) == false)
            {
               event.body.list[0].goods.splice(i,1);
            }
         }
         if(event.body.list[0].goods.length != 0)
         {
            this.view.setdata(event.body.list[0]);
         }
      }
      
      private function onUsePropsBack(event:MessageEvent) : void
      {
         var params:Object = event.body;
         this.view.cureSingleMonster(params,params.propsid);
      }
      
      private function onGcMonsterBack(event:MessageEvent) : void
      {
         var obj:Object = null;
         for(var i:int = 0; i < this.view.params.monsterlist.length; i++)
         {
            obj = this.view.params.monsterlist[i];
            if(obj.id == event.body.id)
            {
               this.view.params.monsterlist.splice(i,1);
               this.view.build(this.view.params);
               if(obj.state == 1)
               {
                  dispatch(EventConst.GCMONSTERSETFOLLOWBACK,{
                     "userId":GlobalConfig.userId,
                     "ope":0,
                     "msid":obj.id,
                     "mid":obj.iid,
                     "name":obj.name
                  });
               }
               break;
            }
         }
      }
      
      private function onSetFirstBack(event:MessageEvent) : void
      {
         var obj:Object = null;
         var i:int = 0;
         var params:Object = event.body;
         var leng:int = int(this.view.params.monsterlist.length);
         if(leng < 2)
         {
            return;
         }
         var temp:Object = this.view.params.monsterlist[0];
         if(temp != null && temp.isfirst == 1)
         {
            for(i = 1; i < leng; i++)
            {
               obj = this.view.params.monsterlist[i];
               if(obj.id == params.id)
               {
                  obj.isfirst = 1;
                  temp.isfirst = 0;
                  this.view.params.monsterlist[0] = obj;
                  this.view.params.monsterlist[i] = temp;
                  break;
               }
            }
            this.view.build(this.view.params,true);
         }
         else
         {
            for each(obj in this.view.params.monsterlist)
            {
               if(obj.id == params.id)
               {
                  obj.isfirst = 1;
               }
               else
               {
                  obj.isfirst = 0;
               }
            }
            this.view.build(this.view.params,false);
         }
      }
      
      private function onSymmWearOrOff(evt:MessageEvent) : void
      {
         var list:Array = null;
         evt.stopImmediatePropagation();
         var data:Object = evt.body;
         if(data.code == 1)
         {
            sendMessage(MsgDoc.OP_CLIENT_SPIRIT_EQUIP_WEAR.send,data.iid,[data.symmIndex]);
         }
         else if(data.code == 2)
         {
            new Alert().showSureOrCancel("是否卸下该灵玉",this.onSureTakeOff,data);
         }
         else if(data.code == 3)
         {
            list = data.symmSendList;
            if(list.length > 0)
            {
               sendMessage(MsgDoc.OP_CLIENT_SPIRIT_EQUIP_INFO.send,GameData.instance.playerData.userId,[list.length].concat(list));
            }
         }
      }
      
      private function onSureTakeOff(type:String, data:Object) : void
      {
         if(type == "确定")
         {
            sendMessage(MsgDoc.OP_CLIENT_SPIRIT_EQUIP_TAKEOFF.send,data.iid,[data.symmIndex]);
            this.getSymmList(null);
         }
      }
      
      private function onSymmPakageListBack(evt:MessageEvent) : void
      {
         var type:int = int(evt.body.type);
         var data:Array = evt.body.list;
         this.view.setSymmData(data);
      }
      
      private function onSymmSingleListBack(evt:MessageEvent) : void
      {
         var list:Array = evt.body as Array;
         this.view.setSelectedData(list);
      }
      
      private function onSymmWearBack(evt:MessageEvent) : void
      {
         var data:Object = evt.body;
         var id:int = int(data.id);
         var newSymm:int = int(data.newSymm);
         var oldSymm:int = int(data.oldSymm);
         this.view.symmOffandWear(id,newSymm,oldSymm);
         sendMessage(MsgDoc.OP_CLIENT_REQ_SPIRIT_LIST.send);
      }
      
      private function onSymmTakeOffBack(evt:MessageEvent) : void
      {
         var data:Object = evt.body;
         var id:int = int(data.id);
         var oldSymm:int = int(data.oldSymm);
         this.view.symmOffandWear(id,0,oldSymm);
         sendMessage(MsgDoc.OP_CLIENT_REQ_SPIRIT_LIST.send);
      }
      
      private function onCureAllBack(event:MessageEvent) : void
      {
         this.view.cureMonsterAllState(int(event.body));
      }
      
      override public function onRemove() : void
      {
         ToolTip.removeToolTip();
         if(this.propsView != null)
         {
            this.propsView.dispos();
         }
         EventManager.removeEvent(this.view,MonsterListEvent.GETMONSTERINLIST,this.getMonsterInList);
         EventManager.removeEvent(this.view,MonsterListEvent.GETMONSTEROUTLIST,this.getMonsterOutList);
         EventManager.removeEvent(this.view,MonsterListEvent.CUREALLMONSTER,this.cureAllMonster);
         EventManager.removeEvent(this.view,MonsterListEvent.GCMONSTER,this.gcMonster);
         EventManager.removeEvent(this.view,MonsterListEvent.SETFIRST,this.setFirst);
         EventManager.removeEvent(this.view,EventConst.TRIPODTRAIN,this.tripodTrain);
         EventManager.removeEvent(this.view,Event.ADDED_TO_STAGE,this.onAddToStage);
         EventManager.removeEvent(this.view,MonsterListEvent.GETSYMMPAKAGELIST,this.getSymmList);
         EventManager.removeEvent(this.view,MonsterListEvent.SYMM_WEAR_OR_OFF,this.onSymmWearOrOff);
      }
   }
}

