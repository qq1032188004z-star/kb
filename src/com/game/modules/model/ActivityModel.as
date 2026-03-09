package com.game.modules.model
{
   import com.core.model.Model;
   import com.game.event.EventConst;
   import com.game.locators.CacheData;
   import com.game.locators.MsgDoc;
   import com.game.modules.model.actUpdate.A000.A11;
   import com.game.modules.model.actUpdate.A000.A151;
   import com.game.modules.model.actUpdate.A000.A154;
   import com.game.modules.model.actUpdate.A000.A18;
   import com.game.modules.model.actUpdate.A000.A224;
   import com.game.modules.model.actUpdate.A000.A276;
   import com.game.modules.model.actUpdate.A000.A294;
   import com.game.modules.model.actUpdate.A000.A325;
   import com.game.modules.model.actUpdate.A000.A38;
   import com.game.modules.model.actUpdate.A000.A95;
   import com.game.modules.model.actUpdate.A100.A195;
   import com.game.modules.model.actUpdate.A100.A199;
   import com.game.modules.model.actUpdate.A300.A339;
   import com.game.modules.model.actUpdate.A300.A340;
   import com.game.modules.model.actUpdate.A300.A351;
   import com.game.modules.model.actUpdate.A400.A405;
   import com.game.modules.model.actUpdate.A500.A500;
   import com.game.modules.model.actUpdate.A600.A601;
   import com.game.modules.model.actUpdate.A600.A603;
   import com.game.modules.model.actUpdate.A600.A604;
   import com.game.modules.model.actUpdate.A600.A610;
   import com.game.modules.model.actUpdate.A600.A632;
   import com.game.modules.model.actUpdate.A600.A646;
   import com.game.modules.model.actUpdate.A600.A655;
   import com.game.modules.model.actUpdate.A700.A703;
   import com.game.modules.model.actUpdate.A700.A750;
   import com.game.modules.model.actUpdate.A700.A753;
   import com.game.modules.model.actUpdate.A700.A758;
   import com.game.modules.model.actUpdate.A700.A764;
   import com.game.modules.model.actUpdate.A700.A774;
   import com.game.modules.model.actUpdate.A700.A776;
   import com.game.modules.model.actUpdate.A700.A777;
   import com.game.modules.model.actUpdate.A700.A780;
   import com.game.modules.model.actUpdate.A700.A784;
   import com.game.modules.model.actUpdate.A900.A900;
   import com.game.modules.model.actUpdate.A900.A902;
   import com.game.modules.parse.ActivityDoc;
   import com.game.modules.parse.ActivityParse116;
   import com.game.modules.parse.intf.IAParse;
   import com.game.modules.vo.ActivityVo;
   import flash.utils.getDefinitionByName;
   import org.green.server.data.ByteArray;
   import org.green.server.events.MsgEvent;
   
   public class ActivityModel extends Model
   {
      
      public static const NAME:String = "activityModel";
      
      private var calsiumState:int = 0;
      
      private var ishadCreateFairFight:Boolean;
      
      private var msg_bos_questionTime:int;
      
      private var msg_bos_saleTime:int;
      
      private var msg_bos_divinationTime:int;
      
      private var msg_bos_onlineTime:int;
      
      private var msg_bos_offTime:int;
      
      private var msg_bos_breedTime:int;
      
      private var questionUpTime:int;
      
      private var saleUpTime:int;
      
      public function ActivityModel(modelName:String = null)
      {
         var newModelName:String = modelName == null ? NAME : modelName;
         super(newModelName);
         new ActivityDoc();
         this.initEvent();
      }
      
      override public function onRegister() : void
      {
         registerListener(MsgDoc.OP_CLIENT_ACTIVITY_QINGYANG.back.toString(),this.onGetQingYangActivityBack);
         registerListener(MsgDoc.OP_CLIENT_DANCE_ACTIVITY.back.toString(),this.onDanceActivityHandler);
         registerListener(MsgDoc.OP_CLIENT_DANCE_STAGE.back.toString(),this.onDanceStageHandler);
         registerListener(MsgDoc.OP_CLIENT_MSG_DAILYCOMPASS.back.toString(),this.onDailyCompassUpate);
         registerListener(MsgDoc.OP_CLIENT_ACTIVITY_QINGYANG_NEW.back.toString(),this.onGetNewActivityBack);
      }
      
      private function initEvent() : void
      {
         CacheData.instance.onlineTimer.addOnline(A780.ins.onTimer);
      }
      
      private function onGetNewActivityBack(evt:MsgEvent) : void
      {
         var vo:ActivityVo = new ActivityVo();
         vo.head = evt.msg.mParams;
         if(evt.msg.body != null)
         {
            evt.msg.body.position = 0;
            switch(vo.head)
            {
               case 601:
                  A601.ins.onAct601Update(evt,this);
                  break;
               case 603:
                  A603.ins.onAct603Update(evt);
                  break;
               case 610:
                  A610.ins.onAct610Update(evt);
                  break;
               case 632:
                  A632.ins.onAct632Update(evt);
                  break;
               case 646:
                  A646.ins.onAct646Update(evt,this);
                  break;
               case 655:
                  A655.ins.handlerRegression(vo,evt,con);
                  break;
               case 604:
                  A604.ins.onAct604Update(evt,con);
                  break;
               case 703:
                  A703.ins.onAct703Update(evt);
                  break;
               case 753:
                  A753.ins.handleKabuOnlineData(vo,evt);
                  break;
               case 750:
                  A750.ins.onAct750Update(evt);
                  break;
               case 764:
                  A764.ins.onAct764Update(evt);
                  break;
               case 758:
                  A758.ins.onAct758Update(evt);
                  break;
               case 774:
                  A774.ins.onAct774Update(evt);
                  break;
               case 776:
                  A776.ins.onAct776Update(evt);
                  break;
               case 777:
                  A777.ins.onAct777Update(evt);
                  break;
               case 780:
                  A780.ins.onAct780Update(evt);
                  break;
               case 784:
                  A784.ins.onAct784Update(evt);
            }
         }
      }
      
      private function onGetQingYangActivityBack(evt:MsgEvent) : void
      {
         var vo:ActivityVo = null;
         var playTime:int = 0;
         var timePlus:int = 0;
         var a116:ActivityParse116 = null;
         var targetName:String = null;
         var IClass:Class = null;
         var iparse:IAParse = null;
         vo = new ActivityVo();
         vo.head = evt.msg.mParams;
         O.traceSocket(evt);
         if(evt.msg.body != null)
         {
            evt.msg.body.position = 0;
            vo.protocolID = evt.msg.body.readInt();
            if(vo.protocolID == 0)
            {
               playTime = evt.msg.body.readInt();
               timePlus = evt.msg.body.readInt();
               CacheData.instance.onlinelist.initialize(vo.head,playTime,timePlus);
            }
            else
            {
               switch(vo.head)
               {
                  case 11:
                     A11.ins.update(vo,evt);
                     break;
                  case 38:
                     vo = A38.ins.onRegressionActivityHandler(evt);
                     break;
                  case 95:
                     A95.ins.onSpaceChestHandler(vo,evt);
                     break;
                  case 151:
                     A151.ins.onNewPlayerSign(vo,evt);
                     break;
                  case 154:
                     A154.ins.onMallActivity(vo,evt);
                     break;
                  case 116:
                     a116 = new ActivityParse116();
                     a116.parse(vo,evt.msg.body);
                     break;
                  case 224:
                     A224.ins.handlerPresuresIconMovie(vo,evt);
                     break;
                  case 276:
                     A276.ins.onNewHandBraveInfo(vo,evt);
                     break;
                  case 10000:
                     this.onMessageBoxInfo(vo,evt);
                     break;
                  case 294:
                     A294.ins.onTopLimitOpen(vo,evt);
                     break;
                  case 325:
                     A325.ins.handleSevenTreasureData(vo,evt);
                     break;
                  case 900:
                     A900.ins.handleHeavenFurui(vo,evt);
                     break;
                  case 902:
                     A902.ins.onPerishEvilHandel(vo,evt);
                     break;
                  case 195:
                     A195.ins.onBossRemarkHandler(vo,evt,this);
                     break;
                  case 336:
                     if(vo == null || evt == null)
                     {
                        return;
                     }
                     if(vo.protocolID == 3)
                     {
                        dispatch(EventConst.ACHIEVEMENT_NOTIFY_AWARD);
                     }
                     break;
                  case 339:
                  case 347:
                     A339.ins.onEvoBattleBackHandler(vo,evt,this);
                     break;
                  case 340:
                     A340.ins.onSignIn340Handler(vo,evt);
                     break;
                  case 18:
                     A18.ins.onShenDanHandler(vo,evt);
                     break;
                  case 351:
                     A351.ins.onAct351Update(vo,evt);
                     break;
                  case 405:
                     A405.ins.onAct405Update(vo,evt);
                     break;
                  case 406:
                     if(vo == null || evt == null)
                     {
                        return;
                     }
                     dispatch(EventConst.PHONE_PLAY_BONUS,[evt.msg.body.readInt(),evt.msg.body.readInt()]);
                     break;
                  case 199:
                     A199.ins.onAct199Update(vo,evt);
                     break;
                  case 500:
                     A500.ins.onAct500Update(vo,evt);
                     break;
                  default:
                     targetName = "com.game.modules.parse.ActivityParse" + vo.head;
                     try
                     {
                        IClass = getDefinitionByName(targetName) as Class;
                     }
                     catch(error:Error)
                     {
                        trace("[" + targetName + "]: Not Found!");
                     }
                     if(IClass != null)
                     {
                        iparse = new IClass();
                        iparse.parse(vo,evt.msg.body);
                     }
               }
               dispatch(EventConst.ACTIVITY_MESSAGE_QINGYANG_BACK + vo.head + "" + vo.protocolID,vo);
            }
         }
      }
      
      private function onDanceActivityHandler(e:MsgEvent) : void
      {
         O.traceSocket(e);
         e.stopImmediatePropagation();
         e.msg.body.position = 0;
         var gameState:int = e.msg.body.readInt();
         var data:Object = {};
         data.gameState = gameState;
         if(gameState == 0 || gameState == 2)
         {
            data.state = e.msg.mParams;
            switch(data.state)
            {
               case 3:
                  data.serverDifficulty = e.msg.body.readInt();
                  data.serverTime = e.msg.body.readInt();
                  data.processid = e.msg.body.readInt();
                  data.clothNum = e.msg.body.readInt();
                  break;
               case 4:
                  data.serverTime = e.msg.body.readInt();
                  data.processid = e.msg.body.readInt();
                  data.serverCombo = e.msg.body.readInt();
                  data.serverScore = e.msg.body.readInt();
                  break;
               case 5:
                  data.serverTime = e.msg.body.readInt();
                  data.processid = e.msg.body.readInt();
                  data.serverCombo = e.msg.body.readInt();
                  data.serverScore = e.msg.body.readInt();
                  data.serverExp = e.msg.body.readInt();
                  data.todayRewardExpCnt = e.msg.body.readInt();
                  data.todayRewardExp = e.msg.body.readInt();
                  data.drawRewardCnt = e.msg.body.readInt();
                  break;
               case 6:
                  data.selectIndex = e.msg.body.readInt();
                  data.googType = e.msg.body.readInt();
                  data.goodId = e.msg.body.readInt();
                  data.goodNum = e.msg.body.readInt();
                  data.awardIndex = e.msg.body.readInt();
                  break;
               case 7:
                  data.rt = e.msg.body.readInt();
                  if(data.rt == 0)
                  {
                     data.dressid = e.msg.body.readInt();
                  }
                  break;
               case 8:
                  data.rt = e.msg.body.readInt();
            }
         }
         dispatch(EventConst.RESPONSE_DANCE_ACTIVITY,data);
      }
      
      private function onDanceStageHandler(e:MsgEvent) : void
      {
         var indexCount:int = 0;
         var items:Array = null;
         var i:int = 0;
         O.traceSocket(e);
         if(e.msg.mParams == 777)
         {
            return;
         }
         var activityVO:ActivityVo = new ActivityVo();
         activityVO.head = e.msg.mParams;
         if(activityVO.head == 0)
         {
            indexCount = e.msg.body.readInt();
            items = [];
            for(i = 0; i < 6; i++)
            {
               items.push(this.readItem(e.msg.body));
            }
            activityVO.valueobject.count = indexCount;
            activityVO.valueobject.list = items;
         }
         else if(activityVO.head == 1)
         {
            activityVO.valueobject = this.readItem(e.msg.body);
         }
         else if(activityVO.head == 2)
         {
            activityVO.valueobject = this.readItem(e.msg.body);
         }
         dispatch(EventConst.RESPONSE_DANCE_STAGE,activityVO);
      }
      
      private function onDailyCompassUpate(evt:MsgEvent) : void
      {
         O.traceSocket(evt);
         var dailyCompass:int = evt.msg.body.readInt();
         dispatch(EventConst.DAILYCOMPASS_UPDATE,{"dailyCompass":dailyCompass});
      }
      
      private function readItem(byte:ByteArray) : Object
      {
         var item:Object = {};
         item.index = byte.readInt();
         item.uid = byte.readInt();
         return item;
      }
      
      private function onMessageBoxInfo(vo:ActivityVo, evt:MsgEvent) : void
      {
         var state:int = 0;
         if(vo == null)
         {
            return;
         }
         if(evt == null)
         {
            return;
         }
         switch(vo.protocolID)
         {
            case 1:
               vo.valueobject.result1 = evt.msg.body.readInt();
               vo.valueobject.time1 = evt.msg.body.readInt();
               if(vo.valueobject.result1 == 0)
               {
                  if(vo.valueobject.time1 > 600)
                  {
                     this.questionUpTime = 600;
                     this.msg_bos_questionTime = vo.valueobject.time1;
                     CacheData.instance.onlineTimer.addOnline(this.doMsgBoxQuestionTimer);
                     CacheData.instance.onlinelist.setPlayState(10002,false);
                  }
                  else
                  {
                     this.questionUpTime = 0;
                     this.msg_bos_questionTime = vo.valueobject.time1;
                     CacheData.instance.onlineTimer.addOnline(this.doMsgBoxQuestionTimer);
                  }
               }
               this.setMsgState(10002,vo.valueobject.result1,vo.valueobject.time1,600);
               break;
            case 2:
               vo.valueobject.result2 = evt.msg.body.readInt();
               vo.valueobject.time2 = evt.msg.body.readInt();
               state = -1;
               if(vo.valueobject.result2 == 0)
               {
                  state = 0;
                  this.msg_bos_divinationTime = vo.valueobject.time2;
                  CacheData.instance.onlineTimer.addOnline(this.doMsgBoxdivinationTimer);
               }
               else if(vo.valueobject.result2 == 1)
               {
                  state = 2;
               }
               else if(vo.valueobject.result2 == 2)
               {
                  state = 1;
               }
               this.setMsgState(10001,state,vo.valueobject.time2);
               break;
            case 3:
               vo.valueobject.iOnlineRes = evt.msg.body.readInt();
               vo.valueobject.iOnlineId = evt.msg.body.readInt();
               vo.valueobject.iOnlieLeftTime = evt.msg.body.readInt();
               vo.valueobject.iOfflineRes = evt.msg.body.readInt();
               vo.valueobject.iOfflineId = evt.msg.body.readInt();
               vo.valueobject.iOfflieLeftTime = evt.msg.body.readInt();
               if(vo.valueobject.iOnlineRes == 0)
               {
                  this.msg_bos_onlineTime = vo.valueobject.iOnlieLeftTime;
                  CacheData.instance.onlineTimer.addOnline(this.doMsgBoxOnlineTimer);
               }
               if(vo.valueobject.iOfflineRes == 0)
               {
                  this.msg_bos_offTime = vo.valueobject.iOfflieLeftTime;
                  CacheData.instance.onlineTimer.addOnline(this.doMsgBoxOfflineTimer);
               }
               this.setMsgState(10003,vo.valueobject.iOnlineRes,vo.valueobject.iOnlieLeftTime);
               this.setMsgState(10004,vo.valueobject.iOfflineRes,vo.valueobject.iOfflieLeftTime);
               break;
            case 4:
               vo.valueobject.result4 = evt.msg.body.readInt();
               vo.valueobject.time4 = evt.msg.body.readInt();
               if(vo.valueobject.result4 == 0)
               {
                  this.msg_bos_breedTime = vo.valueobject.time4;
                  CacheData.instance.onlineTimer.addOnline(this.doMsgBoxBreedTimer);
               }
               this.setMsgState(10005,vo.valueobject.result4,vo.valueobject.time4);
               break;
            case 5:
               vo.valueobject.result5 = evt.msg.body.readInt();
               vo.valueobject.time5 = evt.msg.body.readInt();
               if(vo.valueobject.result5 == 0)
               {
                  if(vo.valueobject.time5 > 600)
                  {
                     this.saleUpTime = 600;
                     this.msg_bos_saleTime = vo.valueobject.time5;
                     CacheData.instance.onlineTimer.addOnline(this.doMsgBoxSaleTimer);
                     CacheData.instance.onlinelist.setPlayState(10007,false);
                  }
                  else
                  {
                     this.saleUpTime = 0;
                     this.msg_bos_saleTime = vo.valueobject.time5;
                     CacheData.instance.onlineTimer.addOnline(this.doMsgBoxSaleTimer);
                  }
               }
               this.setMsgState(10007,vo.valueobject.result5,vo.valueobject.time5,600);
         }
      }
      
      private function setMsgState(id:int, state:int, time:int, showTime:int = 0) : void
      {
         CacheData.instance.onlinelist.setPlayState(id,false);
         CacheData.instance.onlinelist.setActivityGoing(id,false);
         switch(state)
         {
            case 0:
               if(showTime == 0)
               {
                  CacheData.instance.onlinelist.setPlayState(id,true);
                  CacheData.instance.onlinelist.setTimePlus(id,time);
               }
               else if(time <= showTime)
               {
                  CacheData.instance.onlinelist.setPlayState(id,true);
                  CacheData.instance.onlinelist.setTimePlus(id,time);
               }
               break;
            case 1:
               CacheData.instance.onlinelist.setTimePlus(id,0);
               CacheData.instance.onlinelist.setPlayState(id,true);
               CacheData.instance.onlinelist.setActivityGoing(id,true);
               break;
            case 2:
               CacheData.instance.onlinelist.setPlayState(id,false);
         }
      }
      
      private function doMsgBoxQuestionTimer() : void
      {
         if(this.msg_bos_questionTime < this.questionUpTime)
         {
            this.setMsgState(10002,0,this.msg_bos_questionTime);
            if(this.questionUpTime == 0)
            {
               CacheData.instance.onlineTimer.delOnline(this.doMsgBoxQuestionTimer);
            }
            this.questionUpTime = 0;
         }
         else
         {
            --this.msg_bos_questionTime;
         }
      }
      
      private function doMsgBoxSaleTimer() : void
      {
         if(this.msg_bos_saleTime < this.saleUpTime)
         {
            this.setMsgState(10007,0,this.msg_bos_saleTime);
            if(this.saleUpTime == 0)
            {
               CacheData.instance.onlineTimer.delOnline(this.doMsgBoxSaleTimer);
            }
            this.saleUpTime = 0;
         }
         else
         {
            --this.msg_bos_saleTime;
         }
      }
      
      private function doMsgBoxdivinationTimer() : void
      {
         if(this.msg_bos_divinationTime <= 0)
         {
            this.setMsgState(10001,1,0,0);
            CacheData.instance.onlineTimer.delOnline(this.doMsgBoxdivinationTimer);
         }
         else
         {
            --this.msg_bos_divinationTime;
         }
      }
      
      private function doMsgBoxOnlineTimer() : void
      {
         if(this.msg_bos_onlineTime <= 0)
         {
            this.setMsgState(10003,1,0,0);
            CacheData.instance.onlineTimer.delOnline(this.doMsgBoxOnlineTimer);
         }
         else
         {
            --this.msg_bos_onlineTime;
         }
      }
      
      private function doMsgBoxOfflineTimer() : void
      {
         if(this.msg_bos_offTime <= 0)
         {
            this.setMsgState(10004,1,0,0);
            CacheData.instance.onlineTimer.delOnline(this.doMsgBoxOfflineTimer);
         }
         else
         {
            --this.msg_bos_offTime;
         }
      }
      
      private function doMsgBoxBreedTimer() : void
      {
         var time:int = 0;
         if(this.msg_bos_questionTime >= 600)
         {
            time = 600;
         }
         else
         {
            time = 0;
         }
         if(this.msg_bos_breedTime <= 0)
         {
            this.setMsgState(10005,1,0,0);
            CacheData.instance.onlineTimer.delOnline(this.doMsgBoxBreedTimer);
         }
         else
         {
            --this.msg_bos_breedTime;
         }
      }
   }
}

