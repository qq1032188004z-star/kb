package com.game.util
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.alert.Alert;
   import com.publiccomponent.loading.XMLLocator;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   
   public class TaskAcceptMachine extends Sprite
   {
      
      private var _loader:Loader;
      
      private var _clip:MovieClip;
      
      private var list:Array;
      
      private var itemList:Array;
      
      private var acceptId:int;
      
      private var canReceive:Boolean;
      
      private var currentTaskId:int;
      
      public function TaskAcceptMachine()
      {
         super();
         this._loader = new Loader();
         this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoadComplete);
         this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
         this._loader.load(new URLRequest(URLUtil.getSvnVer("assets/material/taskaccept.swf")));
      }
      
      public function setData(param:Object) : void
      {
         this.list = param.list;
         if(param.type == 1)
         {
            this.canReceive = true;
         }
         else
         {
            this.canReceive = false;
         }
         this.currentTaskId = param.taskId;
         if(this._clip != null)
         {
            this.initMachine();
         }
      }
      
      private function initMachine() : void
      {
         var machineItem:TaskMachineItem = null;
         var xml:XML = null;
         var taskId:int = 0;
         var i:int = 0;
         var len:int = int(this.list.length);
         this.itemList = [];
         if(len == 0)
         {
            machineItem = new TaskMachineItem(this.onClickItem);
            machineItem.taskname.text = "任务都做完了喔....";
            this.addChild(machineItem);
            machineItem.x = 40;
            machineItem.y = 26;
            this.itemList.push(machineItem);
            return;
         }
         for(i = 0; i < len; i++)
         {
            taskId = this.list[i] - this.list[i] % 100;
            xml = XMLLocator.getInstance().getTaskInfo(taskId);
            if(xml != null)
            {
               machineItem = new TaskMachineItem(this.onClickItem);
               machineItem.taskId = this.list[i];
               machineItem.taskname.text = xml.@name;
               this.addChild(machineItem);
               machineItem.x = 40;
               machineItem.y = 26 + i * (machineItem.height + 5);
               this.itemList.push(machineItem);
            }
         }
      }
      
      private function onClickItem(taskId:int) : void
      {
         var sid:int;
         var subxml:XML;
         var xml:XML = null;
         if(taskId == 0)
         {
            this.dispos();
            return;
         }
         this.setVisible(true);
         sid = taskId - taskId % 100;
         xml = XMLLocator.getInstance().getTaskInfo(sid);
         if(xml == null)
         {
            this.dispos();
            return;
         }
         subxml = xml.subtask.(@id == taskId)[0] as XML;
         if(subxml == null)
         {
            this.dispos();
            return;
         }
         this._clip.titleclip.titlename.text = xml.@name;
         this._clip.descclip.desccontent.text = subxml.describe;
         this._clip.award.coin.text = subxml.award.coin + "铜";
         this._clip.award.exp.text = subxml.award.exp;
         this.acceptId = taskId;
         this._clip.accept.addEventListener(MouseEvent.CLICK,this.onClickAccept);
      }
      
      private function onClickAccept(evt:MouseEvent) : void
      {
         var taskXML:XML = null;
         if(this.canReceive)
         {
            ApplicationFacade.getInstance().dispatch(EventConst.ONACCEPTTASKBYTASKMACHINE,this.acceptId);
            this.dispos();
         }
         else
         {
            taskXML = XMLLocator.getInstance().getTaskInfo(this.currentTaskId - this.currentTaskId % 100);
            new Alert().show("您已经接受了任务： " + taskXML.@name + ", 还没有完成哦....",this.closeAlert);
         }
      }
      
      private function closeAlert(txt:String, data:String) : void
      {
         this.dispos();
      }
      
      private function setVisible(flag:Boolean) : void
      {
         this._clip.titleclip.visible = flag;
         this._clip.descclip.visible = flag;
         this._clip.award.visible = flag;
         this._clip.accept.visible = flag;
         this._clip.accept.buttonMode = flag;
      }
      
      private function onLoadComplete(evt:Event) : void
      {
         var domain:ApplicationDomain;
         var cls:Class = null;
         this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoadComplete);
         domain = evt.currentTarget.applicationDomain as ApplicationDomain;
         try
         {
            cls = domain.getDefinition("taskacceptmachine") as Class;
         }
         catch(e:*)
         {
            O.o("所加载的元件中不包含导出名为taskacceptmachine的元件");
            this.dispos();
            return;
         }
         this._loader.unloadAndStop();
         this._clip = new cls() as MovieClip;
         this.setVisible(false);
         this.addChild(this._clip);
         this._clip.close.addEventListener(MouseEvent.CLICK,this.onClose);
         if(this.list != null)
         {
            this.initMachine();
            return;
         }
         this.dispos();
      }
      
      private function onClose(evt:MouseEvent) : void
      {
         this.dispos();
      }
      
      private function dispos() : void
      {
         var obj:TaskMachineItem = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
         if(this._loader != null)
         {
            this._loader.unloadAndStop();
            this._loader = null;
         }
         this.list = null;
         this.setVisible(false);
         try
         {
            for each(obj in this.itemList)
            {
               this.removeChild(obj);
            }
         }
         catch(e:*)
         {
            O.o("TaskAcceptMachine在清理东西时出错了....看看这里是不是需要加一个强制清理？？？ TaskAcceptMachine - > dispos");
         }
         this.itemList = null;
      }
      
      private function onLoadError(evt:IOErrorEvent) : void
      {
         O.o("TaskAcceptMachine加载出错了...请核查....");
         try
         {
            this._loader.unloadAndStop();
            this._loader = null;
         }
         catch(e:*)
         {
            O.o("TaskAcceptMachine加载出错了...请核查.... + 1");
         }
      }
   }
}

