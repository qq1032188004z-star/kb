package com.game.modules.control.task
{
   import com.core.observer.MessageEvent;
   import com.core.view.ViewConLogic;
   import com.game.locators.GameData;
   import com.game.locators.MsgDoc;
   import com.game.manager.EventManager;
   import com.game.modules.view.task.DailyTask;
   
   public class DailyTaskControl extends ViewConLogic
   {
      
      public static const NAME:String = "dailytaskmediator";
      
      private var clickCount:int = 0;
      
      private var clicknpcid:int = 0;
      
      public function DailyTaskControl(viewComponent:Object = null)
      {
         super(DailyTaskControl.NAME,viewComponent);
         this.initEvent();
      }
      
      private function initEvent() : void
      {
         EventManager.attachEvent(this.view,DailyTask.OP_DAILY_TASK,this.opDailyTask);
      }
      
      public function get view() : DailyTask
      {
         return this.viewComponent as DailyTask;
      }
      
      override public function listEvents() : Array
      {
         return [];
      }
      
      private function onOPDailyTaskBack(evt:MessageEvent) : void
      {
         var param:Object = evt.body;
         switch(param.actionID)
         {
            case 2:
               if(param.recvResult == 0)
               {
                  trace("接受任务出错");
               }
               else
               {
                  TaskList.getInstance().updateDailyTask(param.taskID,2);
               }
               trace("接受了任务");
               break;
            case 3:
               TaskList.getInstance().updateDailyTask(param.taskID,4);
               break;
            case 4:
               TaskList.getInstance().updateDailyTask(param.taskID,1);
               trace("放弃了任务了喔...");
         }
      }
      
      private function opDailyTask(evt:MessageEvent) : void
      {
         this.sendMessage(MsgDoc.OP_CLIENT_DAILY_TASK.send,evt.body.type,[evt.body.taskID,evt.body.actionID]);
      }
      
      private function clickDailyNPC(evt:MessageEvent) : void
      {
         var param:Object = evt.body;
         if(TaskList.getInstance().statusInDailyTaskList(param.taskid) != 2)
         {
            return;
         }
         if(!this.cutFilter(param.petid,GameData.instance.playerData.mid))
         {
            this.sendMessage(MsgDoc.OP_CLIENT_CLICK_NPC.send,param.npcid,[0]);
            return;
         }
         if(this.clicknpcid == param.npcid)
         {
            ++this.clickCount;
            if(param.account == this.clickCount)
            {
               this.sendMessage(MsgDoc.OP_CLIENT_CLICK_NPC.send,param.npcid,[0]);
               this.clickCount = 0;
               this.clicknpcid = 0;
            }
         }
         else
         {
            this.clickCount = 1;
            this.clicknpcid = param.npcid;
         }
      }
      
      private function cutFilter(str:String, id:int) : Boolean
      {
         var arr:Array = str.split(",");
         var i:int = 0;
         var len:int = int(arr.length);
         for(i = 0; i < len; i++)
         {
            if(int(arr[i]) == id)
            {
               return true;
            }
         }
         return false;
      }
   }
}

