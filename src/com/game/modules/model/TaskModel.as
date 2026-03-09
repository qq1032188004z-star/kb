package com.game.modules.model
{
   import com.core.model.Model;
   import com.core.observer.MessageEvent;
   import com.game.event.EventConst;
   import com.game.locators.EventDefine;
   import com.game.locators.GameData;
   import com.game.locators.MsgDoc;
   import com.game.modules.parse.ActivityParse;
   import com.game.modules.parse.TaskParse;
   import com.game.modules.view.FaceView;
   import com.game.modules.vo.ActivityEventBody;
   import com.game.modules.vo.ActivityVo;
   import com.publiccomponent.ui.ButtonEffect;
   import com.publiccomponent.util.ButtonEffectUtil;
   import flash.external.ExternalInterface;
   import org.green.server.data.MsgPacket;
   import org.green.server.events.MsgEvent;
   
   public class TaskModel extends Model
   {
      
      public static const NAME:String = "taskModel";
      
      private var dailyTaskNum:int;
      
      public function TaskModel(modelName:String = null)
      {
         super(NAME);
      }
      
      override public function onRegister() : void
      {
         registerListener(MsgDoc.OP_CLIENT_REQ_USERTASKLIST.back.toString(),this.onUserTaskListBack);
         registerListener(MsgDoc.OP_CLIENT_REQ_TASKFINISHED.back.toString(),this.onTaskFinishedBack);
         registerListener(MsgDoc.OP_CLIENT_REQ_TASKDROP.back.toString(),this.onTaskDropBack);
         registerListener(MsgDoc.OP_CLIENT_REQ_TASKTALK.back.toString(),this.onTaskTalkBack);
         registerListener(MsgDoc.OP_CLIENT_CLICK_DAILY_TASK.back.toString(),this.onClickDailyTaskBack);
         registerListener(MsgDoc.OP_CLIENT_DAILY_TASK.back.toString(),this.onOpDailyTaskBack);
         registerListener(MsgDoc.OP_CLIENT_GET_RIGHTUP_CLIP.back.toString(),this.onGetRightUpClipBack);
         registerListener(MsgDoc.OP_CLIENT_REQ_NPCTASKLIST.back.toString(),this.onTaskListOnNPCBack);
         registerListener(MsgDoc.OP_CLIENT_REQ_ACCEPTTASK.back.toString(),this.onAcceptTaskBack);
         registerListener(MsgDoc.OP_CLIENT_GET_SINGLE_TASK_INFO.back.toString(),this.onGetSingleTaskInfoBack);
         registerListener(MsgDoc.OP_CLIENT_REQ_ACTIVATION.back.toString(),this.onActivationBack);
         registerListener(MsgDoc.OP_CLIENT_GET_MOJINGLUOPAN.back.toString(),this.onGetMoJingLuoPanBack);
         registerListener(MsgDoc.OP_CLIENT_ANNIVERSARY_ACTIVATION.back.toString(),this.onAnniversaryInfoBack);
         registerListener(MsgDoc.OP_CLIENT_ACTIVITY.back.toString(),this.onGetActivityInfoBack);
         registerListener(MsgDoc.OP_CLIENT_TASK_LITTLEGAME.back.toString(),this.onTaskLittleGameBack);
         registerListener(MsgDoc.OP_CLIENT_TASK_ARCHIVES.back.toString(),this.onTaskArchivesVersionBack);
         registerListener(MsgDoc.OP_CLIENT_ACTIVITY_QINGYANG_NEW.back.toString(),this.onNewDailyTaskDataBack);
      }
      
      private function onUserTaskListBack(evt:MsgEvent) : void
      {
         this.dispatch(EventConst.GETUSERTASKLISTBACK,this.parseMSG(evt.msg));
      }
      
      private function onTaskFinishedBack(evt:MsgEvent) : void
      {
         O.traceSocket(evt);
         var obj:Object = this.parseMSG(evt.msg);
         if(obj.hasOwnProperty("subtaskID"))
         {
            this.dispatch(EventConst.GETTASKFINISHEDINFOBACK,obj);
         }
         else
         {
            this.dispatch(EventConst.GETTASKFINISHEDINFOBACK,evt.msg.mParams);
         }
      }
      
      private function onTaskDropBack(evt:MsgEvent) : void
      {
         O.traceSocket(evt);
         this.dispatch(EventConst.DROPTASKINFOBACK,this.parseMSG(evt.msg));
      }
      
      private function onTaskTalkBack(evt:MsgEvent) : void
      {
         O.traceSocket(evt,"",0,2);
         var param:Object = this.parseMSG(evt.msg);
         this.dispatch(EventConst.ONGETDIALOGBACK,param);
      }
      
      private function onClickDailyTaskBack(evt:MsgEvent) : void
      {
         O.traceSocket(evt);
         var obj:Object = this.parseMSG(evt.msg);
         if(obj.type == 2)
         {
            this.dispatch(EventConst.ACTIVE_TASK_BACK,obj.tasklist);
         }
      }
      
      private function onOpDailyTaskBack(evt:MsgEvent) : void
      {
         O.traceSocket(evt);
         this.dispatch(EventConst.ONDAILYTASKOPBACK,this.parseMSG(evt.msg));
      }
      
      private function onGetRightUpClipBack(evt:MsgEvent) : void
      {
         O.traceSocket(evt);
         this.dispatch(EventConst.ONGETRIGHTUPCLIPBACK,this.parseMSG(evt.msg));
      }
      
      private function onTaskListOnNPCBack(evt:MsgEvent) : void
      {
         O.traceSocket(evt);
         this.dispatch(EventConst.GETNPCTASKLISTBACK,this.parseMSG(evt.msg));
      }
      
      private function onAcceptTaskBack(evt:MsgEvent) : void
      {
         O.traceSocket(evt);
      }
      
      private function onGetSingleTaskInfoBack(evt:MsgEvent) : void
      {
         O.traceSocket(evt);
         this.dispatch(EventConst.GETSINGLETASKINFOBACK,this.parseMSG(evt.msg));
      }
      
      private function onActivationBack(evt:MsgEvent) : void
      {
         O.traceSocket(evt);
         this.dispatch(EventConst.CONTROL_TO_POPUP_WINDOW,this.parseMSG(evt.msg));
      }
      
      private function onGetMoJingLuoPanBack(evt:MsgEvent) : void
      {
         O.traceSocket(evt);
         var obj:Object = {};
         obj.type = evt.msg.mParams;
         obj.mid = evt.msg.body.readInt();
         if(obj.type == 2)
         {
            obj.coin = evt.msg.body.readInt();
            obj.exp = evt.msg.body.readInt();
         }
         this.dispatch(EventConst.SEND_PACKET_IN_MATERIAL_BACK,obj);
      }
      
      private function onGetMidAutumnBack(evt:MsgEvent) : void
      {
         var i:int = 0;
         var obj:Object = {};
         obj.flag = evt.msg.mParams;
         if(obj.flag == 0)
         {
            obj.shiplist = [];
            i = 0;
            for(i = 0; i < 12; i++)
            {
               obj.shiplist.push(evt.msg.body.readInt());
            }
            obj.shelflist = [];
            for(i = 0; i < 16; i++)
            {
               obj.shelflist.push(evt.msg.body.readInt());
            }
         }
         else if(obj.flag == 1)
         {
            obj.type = evt.msg.body.readInt();
            obj.index = evt.msg.body.readInt();
            obj.status = evt.msg.body.readInt();
         }
         else if(obj.flag == 2)
         {
            obj.able = evt.msg.body.readInt();
            obj.index = evt.msg.body.readInt();
            obj.type = evt.msg.body.readInt();
         }
         this.dispatch(EventConst.SEND_PACKET_IN_MID_AUTUMN_BACK,obj);
      }
      
      private function onAnniversaryInfoBack(evt:MsgEvent) : void
      {
         var param:Object = null;
         O.traceSocket(evt);
         if(evt.msg.mParams == 3)
         {
            param = {};
            param.flag = evt.msg.body.readInt() == 1 ? true : false;
            param.uid = evt.msg.body.readInt();
            this.dispatch(EventConst.GET_ANNIVERSARY_ACTIVITY_INFO_BACK,param);
         }
         else if(evt.msg.mParams == 4)
         {
            param = {};
            param.exp = evt.msg.body.readInt();
            param.uid = evt.msg.body.readInt();
            param.flag = evt.msg.body.readInt() == 1 ? true : false;
            this.dispatch(EventConst.GET_EFFECT_AWARD_BACK,param);
         }
      }
      
      private function onGetActivityInfoBack(evt:MsgEvent) : void
      {
         var key:int = 0;
         var value:int = 0;
         var param:ActivityEventBody = null;
         var temp:Object = null;
         O.traceSocket(evt);
         var head:int = evt.msg.mParams;
         if(head == 26)
         {
            key = 0;
            value = 0;
            switch(head)
            {
               case 26:
                  evt.msg.body.position = 0;
                  key = evt.msg.body.readInt();
                  if(key == 1)
                  {
                     value = evt.msg.body.readInt();
                     value += 10029;
                     param = new ActivityEventBody();
                     param.head = head;
                     param.setValueByKey(key,value);
                     dispatch(EventConst.GET_SIGNAL_OF_ADD_ACTIVITY_AI,param);
                  }
            }
         }
         else
         {
            temp = this.paraseActivityMsg(evt.msg);
            dispatch(EventConst.ACTIVITY_MESSAGE_BACK,temp);
         }
      }
      
      private function onGetActivityGharryHandler(e:MsgEvent) : void
      {
         var temp:Object = this.paraseActivityMsg(e.msg);
         dispatch(EventConst.ACTIVITY_MESSAGE_GHARRY,temp);
      }
      
      private function paraseActivityMsg(msg:MsgPacket) : Object
      {
         var parse:ActivityParse = new ActivityParse();
         parse.parse(msg);
         return parse.params;
      }
      
      private function parseMSG(msg:MsgPacket) : Object
      {
         var parse:TaskParse = new TaskParse();
         parse.parse(msg);
         return parse.params;
      }
      
      private function onTaskLittleGameBack(evt:MsgEvent) : void
      {
         var cmd:int = 0;
         var protocolID:int = 0;
         var data:Object = {};
         if(evt.msg.mParams == 99)
         {
            cmd = evt.msg.body.readInt();
            data.cmd = cmd;
            data.data = evt.msg.body;
            dispatch(EventConst.TASK_LITTLEGAME,data);
         }
         else if(evt.msg.mParams == 224)
         {
            evt.msg.body.position = 0;
            protocolID = evt.msg.body.readInt();
            if(protocolID == 4)
            {
               data.data = evt.msg.body;
               if(Boolean(GameData.instance.autoLookForPresuresData.isAutoNum))
               {
                  GameData.instance.autoLookForPresuresData.keepAuto = true;
               }
               GameData.instance.dispatchEvent(new MessageEvent(EventDefine.XUNBAO_224_FINISH,data));
            }
         }
      }
      
      private function onTaskArchivesVersionBack(evt:MsgEvent) : void
      {
         var tema:int = 0;
         var temb:int = 0;
         O.traceSocket(evt,"",evt.msg.mParams,2);
         var data:Object = {};
         switch(evt.msg.mParams)
         {
            case 1:
               evt.msg.body.position = 0;
               data = evt.msg.body;
               dispatch(EventConst.TASK_ARCHIVES_VERSION_PAGE1,data);
               break;
            case 2:
               evt.msg.body.position = 0;
               data = evt.msg.body;
               dispatch(EventConst.TASK_ARCHIVES_VERSION_PAGE2,data);
               break;
            case 3:
               evt.msg.body.position = 0;
               data = evt.msg.body;
               dispatch(EventConst.TASK_ARCHIVES_VERSION_PAGE3,data);
               break;
            case 4:
               evt.msg.body.position = 0;
               GameData.instance.playerData.taskArchivesVersionInfo = new ActivityVo();
               tema = GameData.instance.playerData.taskArchivesVersionInfo.valueobject.specialTaskID = evt.msg.body.readInt();
               temb = GameData.instance.playerData.taskArchivesVersionInfo.valueobject.specialTaskState = evt.msg.body.readInt();
               break;
            case 5:
               evt.msg.body.position = 0;
               data = evt.msg.body;
               dispatch(EventConst.TASK_ARCHIVES_REPLACE_TOPIC,data);
         }
      }
      
      private function onDailyTaskDataBack(evt:MsgEvent) : void
      {
         var rewardIndex:int = 0;
         var awardTime:int = 0;
         var awardState:int = 0;
         O.traceSocket(evt);
         var data:Object = {};
         switch(evt.msg.mParams)
         {
            case 1:
               evt.msg.body.position = 0;
               data = evt.msg.body;
               dispatch(EventConst.CLICK__DAILYTASK_ICON,data);
               break;
            case 2:
               evt.msg.body.position = 0;
               data = evt.msg.body;
               dispatch(EventConst.CLICK__DAILYTASK_AWARD,data);
               evt.msg.body.position = 0;
               rewardIndex = evt.msg.body.readInt();
               awardTime = evt.msg.body.readInt();
               if(awardTime > 0)
               {
                  this.onDailyTaskUIState(1);
               }
               else
               {
                  this.onDailyTaskUIState(0);
               }
               break;
            case 3:
               evt.msg.body.position = 0;
               data = evt.msg.body;
               dispatch(EventConst.CLICK__DAILYTASK_COMPLETED,data);
               --this.dailyTaskNum;
               this.onDailyTaskUIState(1);
               if(this.dailyTaskNum <= 0)
               {
                  this.dailyTaskNum = 0;
               }
               if(ExternalInterface.available)
               {
                  ExternalInterface.call("taskStateFunction",-1,-1,this.dailyTaskNum,-1,-1);
               }
               break;
            case 4:
               evt.msg.body.position = 0;
               this.dailyTaskNum = evt.msg.body.readInt();
               awardState = evt.msg.body.readInt();
               this.onDailyTaskUIState(awardState);
               if(ExternalInterface.available)
               {
                  ExternalInterface.call("taskStateFunction",-1,-1,this.dailyTaskNum,-1,-1);
               }
         }
      }
      
      private function onNewDailyTaskDataBack(evt:MsgEvent) : void
      {
         var vo:ActivityVo = new ActivityVo();
         vo.head = evt.msg.mParams;
         if(evt.msg.body != null)
         {
            evt.msg.body.position = 0;
            switch(vo.head)
            {
               case 617:
                  this.onAct617Update(evt);
            }
         }
      }
      
      private function onAct617Update(evt:MsgEvent) : void
      {
         var lottery_num:int = 0;
         var got_ids:int = 0;
         var len:int = 0;
         var taskId:int = 0;
         var state:int = 0;
         var awardTime:int = 0;
         var rewardIndex:int = 0;
         var i:int = 0;
         if(evt == null)
         {
            return;
         }
         O.traceSocket(evt);
         evt.msg.body.position = 0;
         var oper:String = evt.msg.body.readUTF();
         var data:Object = {};
         switch(oper)
         {
            case "ui_info":
               this.dailyTaskNum = 0;
               data = evt.msg.body;
               dispatch(EventConst.CLICK__DAILYTASK_ICON,data);
               lottery_num = evt.msg.body.readInt();
               if(lottery_num > 0)
               {
                  this.onDailyTaskUIState(1);
               }
               got_ids = evt.msg.body.readInt();
               len = evt.msg.body.readInt();
               for(i = 0; i < len; i++)
               {
                  taskId = evt.msg.body.readInt();
                  state = evt.msg.body.readInt();
                  if(state == 0)
                  {
                     ++this.dailyTaskNum;
                  }
               }
               if(ExternalInterface.available)
               {
                  ExternalInterface.call("taskStateFunction",-1,-1,this.dailyTaskNum,-1,-1);
               }
               break;
            case "finish_daily_task":
               data = evt.msg.body;
               dispatch(EventConst.CLICK__DAILYTASK_COMPLETED,data);
               --this.dailyTaskNum;
               this.onDailyTaskUIState(1);
               if(this.dailyTaskNum <= 0)
               {
                  this.dailyTaskNum = 0;
               }
               if(ExternalInterface.available)
               {
                  ExternalInterface.call("taskStateFunction",-1,-1,this.dailyTaskNum,-1,-1);
               }
               break;
            case "lottery":
               data = evt.msg.body;
               dispatch(EventConst.CLICK__DAILYTASK_AWARD,data);
               awardTime = evt.msg.body.readInt();
               rewardIndex = evt.msg.body.readInt();
               if(awardTime > 0)
               {
                  this.onDailyTaskUIState(1);
               }
               else
               {
                  this.onDailyTaskUIState(0);
               }
         }
      }
      
      private function onDailyTaskUIState(state:int) : void
      {
         if(state == 0)
         {
            ButtonEffectUtil.delEffect(FaceView.clip.getTopButton("dailyTaskClip"));
         }
         else
         {
            ButtonEffectUtil.registerEffect(FaceView.clip.getTopButton("dailyTaskClip"),ButtonEffect.EFFECT_LOTTERY,false);
         }
      }
   }
}

