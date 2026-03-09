package com.game.modules.parse
{
   import com.game.locators.MsgDoc;
   import com.game.modules.view.task.activation.AwardBox;
   import flash.external.ExternalInterface;
   import org.green.server.data.MsgPacket;
   import org.green.server.interfaces.IParser;
   
   public class TaskParse implements IParser
   {
      
      protected var currentMsg:MsgPacket;
      
      public var params:Object = {};
      
      public function TaskParse()
      {
         super();
      }
      
      public function parse(msg:MsgPacket) : void
      {
         this.currentMsg = msg;
         switch(msg.mOpcode)
         {
            case MsgDoc.OP_CLIENT_REQ_USERTASKLIST.back:
               this.onReqUserTaskListBack();
               break;
            case MsgDoc.OP_CLIENT_REQ_TASKFINISHED.back:
               this.onReqTaskFinishedBack();
               break;
            case MsgDoc.OP_CLIENT_REQ_TASKDROP.back:
               this.onDropTask();
               break;
            case MsgDoc.OP_CLIENT_REQ_TASKTALK.back:
               this.onGetDialogBack();
               break;
            case MsgDoc.OP_CLIENT_CLICK_DAILY_TASK.back:
               this.dailyTaskBack();
               break;
            case MsgDoc.OP_CLIENT_DAILY_TASK.back:
               this.opDailyTask();
               break;
            case MsgDoc.OP_CLIENT_GET_RIGHTUP_CLIP.back:
               this.onGetRightUpClip();
               break;
            case MsgDoc.OP_CLIENT_REQ_NPCTASKLIST.back:
               this.onReqNPCTaskList();
               break;
            case MsgDoc.OP_CLIENT_REQ_ACCEPTTASK.back:
               this.onAcceptTaskBack();
               break;
            case MsgDoc.OP_CLIENT_GET_SINGLE_TASK_INFO.back:
               this.onGetSingleTaskInfoBack();
               break;
            case MsgDoc.OP_CLIENT_REQ_ACTIVATION.back:
               this.onGetActivationBack();
         }
      }
      
      private function onReqUserTaskListBack() : void
      {
         var i:int;
         var j:int;
         var acceptedTaskList:Array;
         var finishedTaskList:Array;
         var acceptedTaskParams:Array = null;
         var acceptedTask:Object = null;
         var finishedTask:Object = null;
         var acceptedTaskParam:Object = null;
         this.params = {};
         i = 0;
         j = 0;
         acceptedTaskList = [];
         finishedTaskList = [];
         this.params.newestFlag = this.currentMsg.body.readUTF();
         this.params.acceptedTaskCount = this.currentMsg.body.readInt();
         for(i = 0; i < this.params.acceptedTaskCount; i++)
         {
            acceptedTask = {};
            acceptedTask.subtaskID = this.currentMsg.body.readInt();
            acceptedTask.taskID = acceptedTask.subtaskID - acceptedTask.subtaskID % 1000;
            acceptedTask.taskParamCount = this.currentMsg.body.readInt();
            acceptedTaskParams = [];
            for(j = 0; j < acceptedTask.taskParamCount; j++)
            {
               acceptedTaskParam = {};
               acceptedTaskParam.param = this.currentMsg.body.readInt();
               acceptedTaskParam.value = this.currentMsg.body.readInt();
               acceptedTaskParams.push(acceptedTaskParam);
            }
            acceptedTask.params = acceptedTaskParams;
            acceptedTaskList.push(acceptedTask);
         }
         this.params.finishedTaskCount = this.currentMsg.body.readInt();
         for(i = 0; i < this.params.finishedTaskCount; i++)
         {
            finishedTask = {};
            finishedTask.subtaskID = this.currentMsg.body.readInt();
            finishedTask.taskID = finishedTask.subtaskID - finishedTask.subtaskID % 1000;
            finishedTask.finishTime = this.currentMsg.body.readInt();
            finishedTaskList.push(finishedTask);
         }
         this.params.acceptedTaskList = acceptedTaskList;
         this.params.finishedTaskList = finishedTaskList;
         try
         {
            this.params.awardTime = this.currentMsg.body.readInt();
            this.params.awardStep = this.currentMsg.body.readInt();
            AwardBox.setLeftTime(this.params.awardTime,this.params.awardStep);
            if(ExternalInterface.available)
            {
               if(this.params.awardStep < 1 || this.params.awardStep > 6)
               {
                  ExternalInterface.call("taskStateFunction",-1,0,-1,-1,-1);
               }
               else
               {
                  ExternalInterface.call("taskStateFunction",-1,7 - this.params.awardStep,-1,-1,-1);
               }
            }
            this.params.answerTimes = this.currentMsg.body.readInt();
            this.params.answerTime = this.currentMsg.body.readInt();
            this.params.answerId = this.currentMsg.body.readInt();
            AwardBox.setAnswerData(this.params.answerTimes,this.params.answerTime,this.params.answerId);
         }
         catch(e:*)
         {
            O.o("\n\n拿不到在线奖励的倒计时间！！！\n\n");
         }
         this.currentMsg.userdata = this.params;
      }
      
      private function onReqTaskFinishedBack() : void
      {
         var i:int = 0;
         var item:Object = null;
         this.params = {};
         this.params.subtaskID = this.currentMsg.mParams;
         this.params.taskID = this.params.subtaskID - this.params.subtaskID % 100;
         if(this.currentMsg.body != null && this.currentMsg.body.bytesAvailable > 0)
         {
            this.params.coin = this.currentMsg.body.readInt();
            this.params.exp = this.currentMsg.body.readInt();
            this.params.cultivate = this.currentMsg.body.readInt();
            if(this.currentMsg.body.bytesAvailable > 0)
            {
               this.params.itemCount = this.currentMsg.body.readInt();
               this.params.item = [];
               i = 0;
               for(i = 0; i < this.params.itemCount; i++)
               {
                  item = {};
                  item.type = this.currentMsg.body.readInt();
                  item.id = this.currentMsg.body.readInt();
                  item.number = this.currentMsg.body.readInt();
                  this.params.item.push(item);
               }
            }
            this.params.limitaward = this.currentMsg.body.readInt();
            this.params.bigaward = this.currentMsg.body.readInt();
         }
         this.currentMsg.userdata = this.params;
      }
      
      private function onDropTask() : void
      {
         this.params = {};
         this.params.taskid = this.currentMsg.body.readInt();
         this.currentMsg.userdata = this.params;
      }
      
      private function onGetDialogBack() : void
      {
         var itemArr:Array = null;
         var list2:Array = null;
         var list3:Array = null;
         var idList:Array = null;
         var num:int = 0;
         var arr:Array = null;
         var item:Object = null;
         var goodArr:Array = null;
         var good:Object = null;
         var ability:Object = null;
         var list:Array = null;
         var j:int = 0;
         var gamelist:Array = null;
         var game:Object = null;
         var obj:Object = null;
         var item1:Object = null;
         var obj1:Object = null;
         var k:int = 0;
         this.params = {};
         this.params.type = this.currentMsg.mParams;
         var i:int = 0;
         switch(this.currentMsg.mParams)
         {
            case 1:
            case 5:
            case 22:
               this.params.npcid = this.currentMsg.body.readInt();
               this.params.itemCount = this.currentMsg.body.readInt();
               if(this.params.itemCount != 0)
               {
                  itemArr = [];
                  for(i = 0; i < this.params.itemCount; i++)
                  {
                     item = {};
                     item.type = this.currentMsg.body.readInt();
                     item.id = this.currentMsg.body.readInt();
                     item.number = this.currentMsg.body.readInt();
                     itemArr.push(item);
                  }
                  this.params.itemArr = itemArr;
               }
               this.params.dialogId = this.currentMsg.body.readInt();
               this.params.subtaskID = (this.params.dialogId - this.params.dialogId % 100) / 100;
               this.params.taskID = this.params.subtaskID - this.params.subtaskID % 1000;
               break;
            case 2:
            case 14:
            case 17:
               this.params.dialogId = this.currentMsg.body.readInt();
               this.params.subtaskID = (this.params.dialogId - this.params.dialogId % 100) / 100;
               this.params.taskID = this.params.subtaskID - this.params.subtaskID % 1000;
               if(this.currentMsg.body.bytesAvailable > 0)
               {
                  goodArr = [];
                  this.params.account = this.currentMsg.body.readInt();
                  if(this.params.account != 0)
                  {
                     for(i = 0; i < this.params.account; i++)
                     {
                        good = {};
                        good.type = this.currentMsg.body.readInt();
                        good.id = this.currentMsg.body.readInt();
                        good.number = this.currentMsg.body.readInt();
                        goodArr.push(good);
                     }
                     this.params.goods = goodArr;
                  }
                  this.params.flag = this.currentMsg.body.readInt();
               }
               break;
            case 3:
               this.params.dialogId = this.currentMsg.body.readInt();
               this.params.goodId = this.currentMsg.body.readInt();
               break;
            case 4:
               this.params.targetId = this.currentMsg.body.readInt();
               this.params.currentStatus = this.currentMsg.body.readInt();
               this.params.isNext = this.currentMsg.body.readInt() == 1 ? true : false;
               if(!this.params.isNext)
               {
                  this.params.nextTime = this.currentMsg.body.readInt();
               }
               else
               {
                  this.params.nextTime = 0;
               }
               break;
            case 6:
               this.params.roletype = this.currentMsg.body.readInt();
               break;
            case 7:
               this.params.boardId = this.currentMsg.body.readInt();
               this.params.dialogId = this.currentMsg.body.readInt();
               this.params.npcid = this.currentMsg.body.readInt();
               this.params.subtaskID = (this.params.dialogId - this.params.dialogId % 100) / 100;
               this.params.taskID = this.params.subtaskID - this.params.subtaskID % 1000;
               break;
            case 8:
               if(this.currentMsg.body.bytesAvailable > 0)
               {
                  this.params.dialogId = this.currentMsg.body.readInt();
               }
               if(this.currentMsg.body.bytesAvailable > 0)
               {
                  this.params.abilityNum = this.currentMsg.body.readInt();
                  if(this.params.abilityNum > 0 && this.currentMsg.body.bytesAvailable > 0)
                  {
                     list = [];
                     for(i = 0; i < this.params.abilityNum; i++)
                     {
                        ability = {};
                        ability.id = this.currentMsg.body.readInt();
                        switch(ability.id)
                        {
                           case 1:
                              ability.gamenum = this.currentMsg.body.readInt();
                              j = 0;
                              gamelist = [];
                              for(j = 0; j < ability.gamenum; j++)
                              {
                                 game = {};
                                 game.id = this.currentMsg.body.readInt();
                                 gamelist.push(game);
                              }
                              ability.gamelist = gamelist;
                              break;
                           case 2:
                              break;
                           case 3:
                        }
                        list.push(ability);
                     }
                     this.params.functionList = list;
                  }
               }
               break;
            case 9:
               this.params.account = this.currentMsg.body.readInt();
               list2 = [];
               while(this.currentMsg.body.bytesAvailable > 0)
               {
                  list2.push(this.currentMsg.body.readInt());
               }
               this.params.list = list2;
               break;
            case 10:
               this.params.dialogOne = this.currentMsg.body.readInt();
               this.params.dialogTwo = this.currentMsg.body.readInt();
               this.params.npcid = this.currentMsg.body.readInt();
               break;
            case 11:
               this.params.id = this.currentMsg.body.readInt();
               this.params.currentId = this.currentMsg.body.readInt();
               this.params.trigram = this.currentMsg.body.readInt();
               this.params.exp = this.currentMsg.body.readInt();
               this.params.npcid = this.currentMsg.body.readInt();
               this.params.itemid = this.currentMsg.body.readInt();
               break;
            case 12:
               this.params.awardbox = this.currentMsg.body.readInt();
               this.params.awardindex = this.currentMsg.body.readInt();
               break;
            case 13:
               this.params.account = this.currentMsg.body.readInt();
               break;
            case 15:
               this.params.coin = this.currentMsg.body.readInt();
               this.params.exp = this.currentMsg.body.readInt();
               this.params.cultivate = this.currentMsg.body.readInt();
               if(this.currentMsg.body.bytesAvailable > 0)
               {
                  this.params.itemCount = this.currentMsg.body.readInt();
                  this.params.item = [];
                  for(i = 0; i < this.params.itemCount; i++)
                  {
                     obj = {};
                     obj.type = this.currentMsg.body.readInt();
                     obj.id = this.currentMsg.body.readInt();
                     obj.number = this.currentMsg.body.readInt();
                     this.params.item.push(obj);
                  }
               }
               break;
            case 16:
               this.params.version = this.currentMsg.body.readInt();
               this.params.progress = this.currentMsg.body.readInt();
               break;
            case 18:
               this.params.xiuweiType = this.currentMsg.body.readInt();
               this.params.xiuweiNum = this.currentMsg.body.readInt();
               break;
            case 19:
               this.params.account = this.currentMsg.body.readInt();
               list3 = [];
               while(this.currentMsg.body.bytesAvailable > 0)
               {
                  list3.push(this.currentMsg.body.readInt());
               }
               this.params.list = list3;
               break;
            case 20:
               this.params.npcid = this.currentMsg.body.readInt();
               this.params.status = this.currentMsg.body.readInt();
               break;
            case 21:
               this.params.npcid = this.currentMsg.body.readInt();
               this.params.count = this.currentMsg.body.readInt();
               this.params.paramList = [];
               if(this.currentMsg.body.bytesAvailable > 0)
               {
                  i = 0;
                  for(i = 0; i < this.params.count; i++)
                  {
                     item1 = {};
                     item1.type = this.currentMsg.body.readInt();
                     item1.id = this.currentMsg.body.readInt();
                     this.params.paramList.push(item1);
                  }
               }
               this.params.dialogId = this.currentMsg.body.readInt();
               this.params.subtaskID = (this.params.dialogId - this.params.dialogId % 100) / 100;
               this.params.taskID = this.params.subtaskID - this.params.subtaskID % 1000;
               break;
            case 23:
               this.params.count = this.currentMsg.body.readInt();
               break;
            case 24:
               this.params.count = this.currentMsg.body.readInt();
               idList = [];
               for(i = 0; i < this.params.count; i++)
               {
                  idList.push(this.currentMsg.body.readInt());
               }
               this.params.list = idList;
               break;
            case 26:
               this.params.dialogId = this.currentMsg.body.readInt();
               if(this.currentMsg.body.bytesAvailable > 0)
               {
                  this.params.coin = this.currentMsg.body.readInt();
                  this.params.exp = this.currentMsg.body.readInt();
                  this.params.cultivate = this.currentMsg.body.readInt();
                  if(this.currentMsg.body.bytesAvailable > 0)
                  {
                     this.params.itemCount = this.currentMsg.body.readInt();
                     this.params.item = [];
                     for(i = 0; i < this.params.itemCount; i++)
                     {
                        obj1 = {};
                        obj1.type = this.currentMsg.body.readInt();
                        obj1.id = this.currentMsg.body.readInt();
                        obj1.number = this.currentMsg.body.readInt();
                        this.params.item.push(obj1);
                     }
                  }
               }
               break;
            case 100:
               num = this.currentMsg.body.readInt();
               arr = [];
               for(k = 0; k < num; k++)
               {
                  arr.push([this.currentMsg.body.readInt(),this.currentMsg.body.readInt(),this.currentMsg.body.readInt()]);
               }
               this.params.itemList = arr;
         }
         this.currentMsg.userdata = this.params;
      }
      
      private function dailyTaskBack() : void
      {
         var task:Object = null;
         this.params = {};
         this.params.type = this.currentMsg.mParams;
         this.params.taskaccount = this.currentMsg.body.readInt();
         var list:Array = [];
         while(this.currentMsg.body.bytesAvailable > 0)
         {
            task = {};
            task.taskID = this.currentMsg.body.readInt();
            task.status = this.currentMsg.body.readInt();
            task.cond = this.currentMsg.body.readInt();
            task.needSingleInfo = this.currentMsg.body.readInt() == 1 ? true : false;
            list.push(task);
         }
         this.params.tasklist = list;
         this.currentMsg.userdata = this.params;
      }
      
      private function opDailyTask() : void
      {
         this.params = {};
         this.params.taskID = this.currentMsg.mParams;
         this.currentMsg.body.position = 0;
         this.params.actionID = this.currentMsg.body.readInt();
         switch(this.params.actionID)
         {
            case 1:
               this.params.status = this.currentMsg.body.readInt();
               break;
            case 2:
               this.params.recvResult = this.currentMsg.body.readInt();
               break;
            case 3:
               break;
            case 4:
               this.params.refuseResult = this.currentMsg.body.readInt();
         }
         this.currentMsg.userdata = this.params;
      }
      
      private function onGetRightUpClip() : void
      {
         this.params = {};
         this.params.type = this.currentMsg.mParams;
         if(this.params.type != 0)
         {
            this.params.taskId = this.currentMsg.body.readInt();
         }
         this.currentMsg.userdata = this.params;
      }
      
      private function onReqNPCTaskList() : void
      {
         var specialType:int = 0;
         var i:int = 0;
         var taskArr:Array = null;
         var task:Object = null;
         var ability:Object = null;
         var list:Array = null;
         var j:int = 0;
         var gamelist:Array = null;
         var game:Object = null;
         this.params = {};
         this.params.npcid = this.currentMsg.mParams;
         this.params.dialogId = this.currentMsg.body.readInt();
         if(this.currentMsg.body.bytesAvailable > 0)
         {
            this.params.type = this.currentMsg.body.readInt();
            this.params.taskcount = this.currentMsg.body.readInt();
            specialType = 0;
            if(this.params.taskcount == -1)
            {
               this.params.specialType = -1;
               this.params.taskcount = this.currentMsg.body.readInt();
            }
            i = 0;
            if(this.params.taskcount > 0)
            {
               taskArr = [];
               if(this.params.type == 0)
               {
                  for(i = 0; i < this.params.taskcount; i++)
                  {
                     task = {};
                     task.dialogId = this.currentMsg.body.readInt();
                     task.subtaskID = (task.dialogId - task.dialogId % 100) / 100;
                     task.taskID = task.subtaskID - task.subtaskID % 1000;
                     task.state = this.currentMsg.body.readInt();
                     taskArr.push(task);
                  }
               }
               else if(this.params.type == 1)
               {
                  for(i = 0; i < this.params.taskcount; i++)
                  {
                     taskArr.push(this.currentMsg.body.readInt());
                  }
                  this.params.canReceive = this.currentMsg.body.readInt();
                  this.params.taskId = this.currentMsg.body.readInt();
               }
               this.params.tasklist = taskArr;
            }
            if(this.currentMsg.body.bytesAvailable > 0)
            {
               this.params.abilityNum = this.currentMsg.body.readInt();
               if(this.params.abilityNum > 0 && this.currentMsg.body.bytesAvailable > 0)
               {
                  list = [];
                  for(i = 0; i < this.params.abilityNum; i++)
                  {
                     ability = {};
                     ability.id = this.currentMsg.body.readInt();
                     switch(ability.id)
                     {
                        case 1:
                           ability.gamenum = this.currentMsg.body.readInt();
                           j = 0;
                           gamelist = [];
                           for(j = 0; j < ability.gamenum; j++)
                           {
                              game = {};
                              game.id = this.currentMsg.body.readInt();
                              gamelist.push(game);
                           }
                           ability.gamelist = gamelist;
                           break;
                        case 2:
                           break;
                        case 3:
                           break;
                        case 4:
                     }
                     list.push(ability);
                  }
                  this.params.functionList = list;
               }
            }
         }
         this.currentMsg.userdata = this.params;
      }
      
      private function onAcceptTaskBack() : void
      {
         this.params = {};
         this.params.taskId = this.currentMsg.mParams;
         this.params.flag = this.currentMsg.body.readInt() == 1;
      }
      
      private function onGetSingleTaskInfoBack() : void
      {
         var list:Array = null;
         var i:int = 0;
         var task:Object = null;
         this.params = {};
         this.params.taskId = this.currentMsg.mParams;
         this.params.flag = this.currentMsg.body.readInt() != -1;
         if(Boolean(this.params.flag) && this.currentMsg.body.bytesAvailable > 0)
         {
            this.params.account = this.currentMsg.body.readInt();
            list = [];
            i = 0;
            for(i = 0; i < this.params.account; i++)
            {
               task = {};
               task.key = this.currentMsg.body.readInt();
               task.value = this.currentMsg.body.readInt();
               list.push(task);
            }
            this.params.list = list;
         }
      }
      
      private function onGetActivationBack() : void
      {
         this.params = {};
         this.params.type = this.currentMsg.mParams;
         this.params.monsterID = this.currentMsg.body.readInt();
      }
   }
}

