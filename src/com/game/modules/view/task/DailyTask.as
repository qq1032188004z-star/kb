package com.game.modules.view.task
{
   import com.core.observer.MessageEvent;
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.manager.EventManager;
   import com.game.modules.control.task.DailyTaskControl;
   import com.game.modules.control.task.TaskEvent;
   import com.game.modules.control.task.TaskList;
   import com.game.modules.control.task.util.TaskUtils;
   import com.game.modules.view.task.daily.DailyTaskItem;
   import com.game.modules.vo.DailyTaskData;
   import com.publiccomponent.loading.GreenLoading;
   import com.publiccomponent.loading.Hloader;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   
   public class DailyTask extends MovieClip
   {
      
      public static const OP_DAILY_TASK:String = "opdailytask";
      
      private var dailyTaskClip:MovieClip;
      
      private var loader:Loader;
      
      private var dataList:Array;
      
      private var itemList:Array;
      
      private var _index:int = 0;
      
      private var currentTask:DailyTaskData;
      
      private var uiLoader:Hloader;
      
      private var count:int;
      
      private var index:int;
      
      private var shape:Sprite;
      
      private var f:ColorMatrixFilter = new ColorMatrixFilter([0.3,0.6,0,0,0,0.3,0.6,0,0,0,0.3,0.6,0,0,0,0,0,0,1,0]);
      
      private var currentItemIndex:int = 0;
      
      public function DailyTask()
      {
         super();
         this.shape = new Sprite();
         this.shape.graphics.beginFill(16777215,0);
         this.shape.graphics.drawRect(0,0,970,570);
         this.shape.graphics.endFill();
         this.addChild(this.shape);
         this.shape.x = 0;
         this.shape.y = 0;
         this.shape.mouseEnabled = false;
         ApplicationFacade.getInstance().registerViewLogic(new DailyTaskControl(this));
         this.dataList = new Array(5);
         GreenLoading.loading.visible = true;
         this.uiLoader = new Hloader("assets/material/dailytask.swf");
         this.uiLoader.addEventListener(Event.COMPLETE,this.loadComplement);
         TaskUtils.getInstance().addEventListener(TaskEvent.OP_UPDATE_DAILY_TASK,this.update);
         this.cacheAsBitmap = true;
      }
      
      private function loadComplement(evt:Event) : void
      {
         GreenLoading.loading.visible = false;
         try
         {
            this.dailyTaskClip = (this.uiLoader.content as MovieClip).getChildAt(0) as MovieClip;
            this.dailyTaskClip.coinaward.visible = false;
         }
         catch(e:*)
         {
            this.dispos();
            return;
         }
         this.uiLoader.unloadAndStop();
         this.uiLoader.removeEventListener(Event.COMPLETE,this.loadComplement);
         this.dailyTaskClip.stop();
         this.dailyTaskClip.taskcontent.addFrameScript(0,this.contentFun1);
         this.dailyTaskClip.taskcontent.addFrameScript(2,this.contentFun1);
         this.dailyTaskClip.taskcontent.addFrameScript(6,this.contentFun1);
         this.dailyTaskClip.taskcontent.addFrameScript(9,this.contentFun1);
         this.dailyTaskClip.taskcontent.addFrameScript(10,this.contentFun1);
         this.dailyTaskClip.taskcontent.addFrameScript(11,this.contentFun1);
         this.dailyTaskClip.taskcontent.addFrameScript(4,this.contentFun2);
         this.dailyTaskClip.taskimg.addFrameScript(6,this.imgFun1);
         this.dailyTaskClip.taskcontent.gotoAndStop(2);
         this.dailyTaskClip.taskimg.gotoAndStop(2);
         this.init();
      }
      
      private function contentFun1() : void
      {
         if(Boolean(this.dailyTaskClip.taskcontent.hasOwnProperty("namesplace")) && this.dailyTaskClip.taskcontent.namesplace != null)
         {
            if(this.currentTask != null)
            {
               if(this.currentTask.content == 0)
               {
                  this.dailyTaskClip.taskcontent.namesplace.gotoAndStop(1);
               }
               else
               {
                  this.dailyTaskClip.taskcontent.namesplace.gotoAndStop(this.currentTask.content);
               }
            }
            else
            {
               this.dailyTaskClip.taskcontent.namesplace.stop();
            }
         }
      }
      
      private function contentFun2() : void
      {
         if(this.currentTask == null)
         {
            return;
         }
         this.initCondMC();
      }
      
      private function imgFun1() : void
      {
         if(this.currentTask == null)
         {
            return;
         }
         this.dailyTaskClip.taskimg.imgList.gotoAndStop(this.currentTask.content);
      }
      
      private function init() : void
      {
         this.addChild(this.dailyTaskClip);
         this.dailyTaskClip.x = 154;
         this.dailyTaskClip.y = 21;
         if(Boolean(TaskList.getInstance().dailyTaskList.length))
         {
            this.afterSetData();
         }
      }
      
      public function setData() : void
      {
         if(this.dailyTaskClip == null)
         {
            return;
         }
         this.afterSetData();
      }
      
      private function afterSetData() : void
      {
         this.dailyTaskClip.close.addEventListener(MouseEvent.CLICK,this.onClose);
         this.buildData();
         this.currentView(this.dataList[0].taskid);
      }
      
      private function render() : void
      {
         var item:DailyTaskItem = null;
         if(this.itemList == null)
         {
            this.itemList = [];
         }
         var i:int = 0;
         var len:int = int(this.dataList.length);
         var xCoord:Number = 0;
         for(i = 0; i < len; i++)
         {
            if(this.dataList[i].totalIndex >= this.itemList.length)
            {
               item = new DailyTaskItem(this.dataList[i].taskid,this.dataList[i].index,this.dataList[i].callback);
               this.itemList.push(item);
               this.dailyTaskClip.addChildAt(item,this.dailyTaskClip.numChildren);
               if(i == 0)
               {
                  xCoord = 37;
               }
               else if(i == 1)
               {
                  xCoord = 144.65;
               }
               else if(i == 2)
               {
                  xCoord = 261.3;
               }
               else if(i == 3)
               {
                  xCoord = 376.1;
               }
               else if(i == 4)
               {
                  xCoord = 491.1;
               }
               item.x = xCoord;
               item.y = 76;
            }
            this.itemList[this.dataList[i].totalIndex].updateStatus(this.dataList[i].status);
         }
      }
      
      private function buildData(index:int = 0) : void
      {
         var param:Object = null;
         var temp:DailyTaskData = null;
         var i:int = 0;
         var len:int = int(TaskList.getInstance().dailyTaskList.length);
         for(i = 0; i < len; i++)
         {
            temp = TaskList.getInstance().dailyTaskList[index + i];
            param = {};
            param.status = temp.status;
            param.taskid = temp.taskid;
            param.index = i;
            param.totalIndex = index + i;
            param.callback = this.onClickItem;
            this.dataList[i] = param;
         }
         this.render();
      }
      
      public function update(evt:TaskEvent) : void
      {
         this.buildData(this._index);
         this.currentView(this.currentTask.taskid);
      }
      
      private function currentView(id:int) : void
      {
         var obj:Object = null;
         this.currentTask = this.getCurrentTask(id);
         if(this.currentTask == null)
         {
            return;
         }
         var ind:int = id % 1000000;
         ind = (ind / 10 >> 0) * 10 / 1000 >> 0;
         this.dailyTaskClip.taskcontent.gotoAndStop(ind);
         this.dailyTaskClip.taskimg.gotoAndStop(ind);
         this.dailyTaskClip.coinaward.text = this.currentTask.award.coin;
         this.dailyTaskClip.expaward.text = this.currentTask.award.exp;
         switch(this.currentTask.status)
         {
            case 0:
               this.btnStatus(true,false);
            case 1:
               this.btnStatus(true,false);
               break;
            case 2:
               this.btnStatus(false,true);
               break;
            case 4:
               this.btnStatus(false,false);
               if(this.currentTask.condition != null && this.currentTask.condition.length > 0)
               {
                  for each(obj in this.currentTask.condition)
                  {
                     obj.state = true;
                  }
               }
         }
      }
      
      private function btnStatus(acc:Boolean, drop:Boolean) : void
      {
         if(acc)
         {
            this.dailyTaskClip.accepttask.gotoAndStop(1);
         }
         else if(drop)
         {
            this.dailyTaskClip.accepttask.gotoAndStop(2);
         }
         if(!acc && !drop)
         {
            this.dailyTaskClip.accepttask.filters = [this.f];
            this.dailyTaskClip.accepttask.buttonMode = false;
            this.dailyTaskClip.accepttask.removeEventListener(MouseEvent.CLICK,this.onMouseClickAcceptBtn);
            this.dailyTaskClip.taskcomplete.visible = true;
         }
         else
         {
            this.dailyTaskClip.taskcomplete.visible = false;
            this.dailyTaskClip.accepttask.filters = [];
            this.dailyTaskClip.accepttask.buttonMode = true;
            this.dailyTaskClip.accepttask.addEventListener(MouseEvent.CLICK,this.onMouseClickAcceptBtn);
         }
      }
      
      private function getCurrentTask(id:int) : DailyTaskData
      {
         var task:DailyTaskData = null;
         for each(task in TaskList.getInstance().dailyTaskList)
         {
            if(task.taskid == id)
            {
               return task;
            }
         }
         return null;
      }
      
      private function onClickItem(id:int, filtID:int) : void
      {
         var task:DailyTaskData = this.getCurrentTask(id);
         if(task == null)
         {
            return;
         }
         if(this.currentItemIndex != filtID)
         {
            (this.itemList[this.currentItemIndex] as DailyTaskItem).updateClickStatus();
         }
         this.currentItemIndex = filtID;
         this.clearFilters();
         (this.itemList[filtID] as DailyTaskItem).updateFilters(2);
         if(task.needSingleInfo)
         {
            ApplicationFacade.getInstance().dispatch(EventConst.GETSINGLETASKINFO,{
               "callback":this.onGetSingleTaskInfoBack,
               "taskId":id
            });
         }
         else
         {
            this.currentView(id);
         }
      }
      
      private function clearFilters(cid:int = 0) : void
      {
         if(this.itemList == null)
         {
            return;
         }
         var i:int = 0;
         var len:int = int(this.itemList.length);
         for(i = 0; i < len; i++)
         {
            (this.itemList[i] as DailyTaskItem).updateFilters(1);
         }
      }
      
      private function onGetSingleTaskInfoBack(data:*) : void
      {
         var i:int = 0;
         var j:int = 0;
         var len:int = 0;
         var leng:int = 0;
         this.currentTask = this.getCurrentTask(data.taskId);
         if(this.currentTask.condition != null && this.currentTask.condition.length > 0 && data.hasOwnProperty("account") && data.account > 0)
         {
            i = 0;
            j = 0;
            len = int(this.currentTask.condition.length);
            leng = int(data.account);
            for(i = 0; i < len; i++)
            {
               j = 0;
               for(j = 0; j < leng; j++)
               {
                  if(data.list[j].key == this.currentTask.condition[i].id && data.list[j].value != 0)
                  {
                     this.currentTask.condition[i].state = true;
                     break;
                  }
               }
            }
         }
         this.currentView(data.taskId);
      }
      
      private function onClose(evt:MouseEvent) : void
      {
         this.dispos();
      }
      
      private function onMouseClickAcceptBtn(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         if(this.dailyTaskClip.accepttask.currentFrame == 1)
         {
            EventManager.dispatch(this,new MessageEvent(OP_DAILY_TASK,{
               "type":2,
               "taskID":this.currentTask.taskid,
               "actionID":2
            }));
         }
         else
         {
            EventManager.dispatch(this,new MessageEvent(OP_DAILY_TASK,{
               "type":2,
               "taskID":this.currentTask.taskid,
               "actionID":4
            }));
         }
      }
      
      private function initCondMC() : void
      {
         var i:int = 0;
         var len:int = int(this.currentTask.condition.length);
         for(i = 0; i < len; i++)
         {
            if(Boolean(this.currentTask.condition[i].state))
            {
               this.dailyTaskClip.taskcontent.getChildByName("good" + (i + 1)).gotoAndStop(2);
            }
            else
            {
               this.dailyTaskClip.taskcontent.getChildByName("good" + (i + 1)).gotoAndStop(1);
            }
         }
      }
      
      public function dispos() : void
      {
         var len:int = 0;
         (this.itemList[this.currentItemIndex] as DailyTaskItem).updateClickStatus();
         this.currentItemIndex = 0;
         this.clearFilters();
         if(this.dailyTaskClip != null)
         {
            this.dailyTaskClip.close.removeEventListener(MouseEvent.CLICK,this.onClose);
         }
         if(this.uiLoader != null)
         {
            this.uiLoader.removeEventListener(Event.COMPLETE,this.loadComplement);
            this.uiLoader.unloadAndStop();
            this.uiLoader = null;
         }
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
         var i:int = 0;
         if(Boolean(this.itemList))
         {
            len = int(this.itemList.length);
            for(i = 0; i < len; i++)
            {
               this.dailyTaskClip.removeChild(this.itemList[i]);
            }
            this.itemList = null;
         }
         for(i = 0; i < 5; i++)
         {
            this.dataList[i] = null;
         }
      }
   }
}

