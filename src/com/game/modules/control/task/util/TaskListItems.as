package com.game.modules.control.task.util
{
   import caurina.transitions.Tweener;
   import com.channel.Message;
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.modules.control.task.TaskEvent;
   import com.game.modules.control.task.TaskList;
   import com.game.modules.view.FaceView;
   import com.game.util.PropertyPool;
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.loading.GreenLoading;
   import com.publiccomponent.loading.Hloader;
   import com.publiccomponent.loading.XMLLocator;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class TaskListItems extends MovieClip
   {
      
      private var actionCls:Class;
      
      private var listCls:Class;
      
      private var functionCls:Class;
      
      private var dialogCls:Class;
      
      private var mc:MovieClip;
      
      private var items:Array;
      
      private var itemBlank:int = 5;
      
      private var currentNPCID:int;
      
      private var loader:Loader;
      
      private var desc:String;
      
      private var timeoverFlag:Boolean = false;
      
      private var defaultTextFormat:TextFormat = new TextFormat("宋体",14,16777215);
      
      private var npcNameTextFormat:TextFormat = new TextFormat("宋体",26,16776960,true);
      
      private var data:Object;
      
      private var currentIndex:int;
      
      private var dialogOne:String;
      
      private var dialogTwo:String;
      
      private var waitDialogXML:XML;
      
      private var dialogId:int = 0;
      
      private var specialList:Array = [401101,12004,301701,18004,401103,19006,21911,17003,22301,22201,22403];
      
      private var uiLoader:Hloader;
      
      private var needSendChoose:int = 0;
      
      private var functionListOfCurrentNPC:Array;
      
      private var inTaskDialogXML:XML;
      
      private var bInTask:Boolean;
      
      private var bInfunctionList:Boolean;
      
      public function TaskListItems()
      {
         super();
         var shape:Sprite = new Sprite();
         shape.graphics.beginFill(16777215,0);
         shape.graphics.drawRect(0,0,970,570);
         shape.graphics.endFill();
         this.addChildAt(shape,0);
         shape.mouseEnabled = false;
         shape.x = 0;
         shape.y = 0;
         GreenLoading.loading.visible = true;
         this.uiLoader = new Hloader("assets/material/dialog.swf");
         this.uiLoader.addEventListener(Event.COMPLETE,this.onLoadComplete);
         this.uiLoader.addEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
         this.cacheAsBitmap = true;
      }
      
      private function onLoadComplete(evt:Event) : void
      {
         var domain:ApplicationDomain = null;
         var cls:Class = null;
         evt.stopImmediatePropagation();
         this.uiLoader.removeEventListener(Event.COMPLETE,this.onLoadComplete);
         try
         {
            domain = this.uiLoader.contentLoaderInfo.applicationDomain;
            cls = domain.getDefinition("taskDialog") as Class;
            this.mc = new cls() as MovieClip;
            this.addChild(this.mc);
            this.visible = false;
            this.mc.x = 85;
            this.mc.y = 470;
         }
         catch(e:*)
         {
            this.dispos();
            return;
         }
         (this.mc.nameMC.npcName as TextField).defaultTextFormat = this.npcNameTextFormat;
         this.mc.lastDialog.visible = false;
         this.mc.nextDialog.visible = false;
         this.mc.sayTxt.text = "";
         this.actionCls = domain.getDefinition("actionItem") as Class;
         this.listCls = domain.getDefinition("tasklist") as Class;
         this.functionCls = domain.getDefinition("functionItem") as Class;
         this.dialogCls = domain.getDefinition("dialogItem") as Class;
         if(this.waitDialogXML == null)
         {
            PropertyPool.instance.getXML("config/","waitdialog",this.onLoadWaitDialogComp);
         }
         if(this.inTaskDialogXML == null)
         {
            PropertyPool.instance.getXML("config/","intask_waitdialog",this.onLoadInTaskWiaitDialogComp);
         }
         this.cacheAsBitmap = true;
         this.mc.cacheAsBitmap = true;
      }
      
      private function onLoadError(evt:IOErrorEvent) : void
      {
         trace("加载失败...");
         this.dispos();
      }
      
      private function onLoadWaitDialogComp(wait:XML, ... rest) : void
      {
         if(wait == null)
         {
            this.dispos();
            return;
         }
         this.waitDialogXML = wait;
         if(this.data != null && this.waitDialogXML != null && this.inTaskDialogXML != null)
         {
            this.init();
         }
      }
      
      private function onLoadInTaskWiaitDialogComp(wait:XML, ... rest) : void
      {
         if(wait == null)
         {
            this.dispos();
            return;
         }
         this.inTaskDialogXML = wait;
         if(this.data != null && this.waitDialogXML != null && this.inTaskDialogXML != null)
         {
            this.init();
         }
      }
      
      public function addTask(param:Object) : void
      {
         if(param == null)
         {
            this.dispos();
            return;
         }
         this.releaseData();
         this.items = [];
         this.currentNPCID = param.npcid;
         this.dialogId = param.dialogId;
         if(Boolean(param.hasOwnProperty("chooseId")) && Boolean(param.chooseId))
         {
            this.needSendChoose = param.chooseId;
         }
         this.data = param;
         if(Boolean(this.data.hasOwnProperty("taskCount")) || Boolean(this.data.hasOwnProperty("abilityNum")))
         {
            this.bInTask = true;
         }
         else
         {
            this.bInTask = false;
         }
         if(this.mc != null)
         {
            if(this.inTaskDialogXML != null && this.waitDialogXML != null)
            {
               this.init();
            }
            else
            {
               if(this.inTaskDialogXML == null)
               {
                  PropertyPool.instance.getXML("config/","intask_waitdialog",this.onLoadInTaskWiaitDialogComp);
               }
               if(this.waitDialogXML == null)
               {
                  PropertyPool.instance.getXML("config/","waitdialog",this.onLoadWaitDialogComp);
               }
            }
         }
         else if(this.uiLoader == null)
         {
            GreenLoading.loading.visible = true;
            this.uiLoader = new Hloader("assets/material/dialog.swf");
            this.uiLoader.addEventListener(Event.COMPLETE,this.onLoadComplete);
         }
      }
      
      private function spliteFromFunctionListByIndex(value:int) : void
      {
         var vo:TasklistItemVo = null;
         if(this.functionListOfCurrentNPC == null || this.functionListOfCurrentNPC.length == 0)
         {
            return;
         }
         for each(vo in this.functionListOfCurrentNPC)
         {
            if(vo.index == value)
            {
               vo.beUsed = true;
            }
         }
      }
      
      private function randomDialog() : XML
      {
         var xml:XML = null;
         var rand:int = 0;
         try
         {
            if(this.bInTask)
            {
               xml = this.inTaskDialogXML.children().(@id == currentNPCID)[0] as XML;
               while(xml == null)
               {
                  rand = Math.random() * this.waitDialogXML.children().length() >> 0;
                  xml = this.waitDialogXML.children()[rand] as XML;
                  if(xml.@id > 1000)
                  {
                     xml = null;
                  }
               }
            }
            else if(this.bInfunctionList)
            {
               xml = this.inTaskDialogXML.children().(@id == currentNPCID)[0] as XML;
            }
            else if(this.specialList.indexOf(this.currentNPCID) != -1)
            {
               xml = this.inTaskDialogXML.children().(@id == currentNPCID)[0] as XML;
            }
            else
            {
               xml = null;
               while(xml == null)
               {
                  rand = Math.random() * this.waitDialogXML.children().length() >> 0;
                  xml = this.waitDialogXML.children()[rand] as XML;
                  if(xml.@id > 1000)
                  {
                     xml = null;
                  }
               }
            }
         }
         catch(e:*)
         {
            if(this.waitDialogXML == null)
            {
               this.dispos();
               return null;
            }
            xml = waitDialogXML.children()[1] as XML;
            if(xml == null)
            {
               this.dispos();
               return null;
            }
         }
         return xml;
      }
      
      private function init() : void
      {
         var vo:TasklistItemVo = null;
         this.visible = true;
         GreenLoading.loading.visible = false;
         this.functionListOfCurrentNPC = TaskList.getInstance().functionListOnCurrentNPC(this.currentNPCID);
         this.mc.close.addEventListener(MouseEvent.CLICK,this.onMouseClickClose);
         var nameXML:XML = XMLLocator.getInstance().getNPC(this.currentNPCID);
         if(nameXML == null)
         {
            trace("鼎兄给的NPC的id有问题...都加载不到人名的...TaskListItems -- > addTask");
            this.dispos();
            return;
         }
         if(this.mc && this.mc.nameMC && Boolean(this.mc.nameMC.npcName) && Boolean(this.mc.nameMC.npcName.text))
         {
            this.mc.nameMC.npcName.text = nameXML.name + "";
         }
         this.loadNPCIMG(this.currentNPCID);
         if(this.functionListOfCurrentNPC != null && this.functionListOfCurrentNPC.length > 0)
         {
            for each(vo in this.functionListOfCurrentNPC)
            {
               if(vo.canShow())
               {
                  this.bInfunctionList = true;
               }
            }
         }
         else
         {
            this.bInfunctionList = false;
         }
         if(this.waitDialogXML != null)
         {
            this.printEffect();
         }
         else
         {
            PropertyPool.instance.getXML("config/","waitdialog",this.onLoadWaitDialogComp);
         }
      }
      
      private function printEffect() : void
      {
         var tempXML:XML = this.randomDialog();
         if(tempXML == null)
         {
            this.dispos();
            return;
         }
         this.dialogOne = tempXML.children()[0].toString();
         this.dialogTwo = tempXML.children()[1].toString();
         if(this.dialogTwo == "null" || this.dialogTwo.length == 0)
         {
            this.dialogTwo = "离开";
         }
         this.mc.sayTxt.text = "";
         this.mc.sayTxt.appendText(this.dialogOne);
         this.printComplete();
      }
      
      private function onClickNPCSay(evt:MouseEvent) : void
      {
         if(Boolean(this.mc.sayTxt.hasEventListener(MouseEvent.CLICK)))
         {
            this.mc.sayTxt.removeEventListener(MouseEvent.CLICK,this.onClickNPCSay);
         }
         if(this.dialogOne.length == 0)
         {
            return;
         }
         this.mc.sayTxt.appendText(this.dialogOne.substring(this.currentIndex));
         this.printComplete();
      }
      
      private function printComplete() : void
      {
         var taskitem:TaskListItem = null;
         var tempName:String = null;
         var j:int = 0;
         var str:String = null;
         var gameItem:TasklistItemVo = null;
         var vo:TasklistItemVo = null;
         if(this.timeoverFlag)
         {
            return;
         }
         this.timeoverFlag = true;
         this.currentIndex = 0;
         var i:int = 0;
         var len:int = 0;
         if(this.data.hasOwnProperty("taskCount"))
         {
            len = int(this.data.taskCount);
            this.items = [];
            for(i = 0; i < len; i++)
            {
               taskitem = new TaskListItem(this.listCls);
               taskitem.addTask(1,this.data.tasklist[i].data,this.opNPCList,this.data.tasklist[i].state);
               this.mc.addChild(taskitem);
               taskitem.x = 619;
               this.items.push(taskitem);
            }
         }
         if(Boolean(this.data.hasOwnProperty("abilityNum")) && this.data.abilityNum > 0)
         {
            len = int(this.data.abilityNum);
            for(i = 0; i < len; i++)
            {
               tempName = this.getNameByID(this.data.abilityList[i].id);
               if(tempName != "")
               {
                  if(this.data.abilityList[i].id != 1)
                  {
                     taskitem = new TaskListItem(this.functionCls);
                     taskitem.addTask(2,this.data.abilityList[i].id,this.opFunction,tempName);
                     this.mc.addChild(taskitem);
                     taskitem.x = 619;
                     this.items.push(taskitem);
                     this.spliteFromFunctionListByIndex(this.data.abilityList[i].id);
                  }
                  else if(this.data.abilityList[i].gamenum > 0 && this.functionListOfCurrentNPC != null && this.functionListOfCurrentNPC.length > 0)
                  {
                     j = 0;
                     for(j = 0; j < this.data.abilityList[i].gamenum; j++)
                     {
                        for each(gameItem in this.functionListOfCurrentNPC)
                        {
                           if(gameItem.type == 5)
                           {
                              if(gameItem.code == this.data.abilityList[i].gamelist[j].id)
                              {
                                 taskitem = new TaskListItem(this.functionCls);
                                 taskitem.addTask(2,this.data.abilityList[i].id,this.opFunction,{
                                    "id":gameItem.code,
                                    "name":gameItem.name
                                 });
                                 this.mc.addChild(taskitem);
                                 taskitem.x = 619;
                                 this.items.push(taskitem);
                                 this.spliteFromFunctionListByIndex(this.data.abilityList[i].id);
                              }
                           }
                        }
                     }
                  }
               }
            }
         }
         if(this.functionListOfCurrentNPC != null && this.functionListOfCurrentNPC.length > 0)
         {
            for each(vo in this.functionListOfCurrentNPC)
            {
               if(!vo.beUsed && vo.canShow())
               {
                  taskitem = new TaskListItem(this.functionCls);
                  if(taskitem.type == 5)
                  {
                     taskitem.addTask(2,vo.index,this.opFunction,{
                        "id":vo.code,
                        "name":vo.name
                     });
                  }
                  else
                  {
                     taskitem.addTask(2,vo.index,this.opFunction,vo.name);
                  }
                  this.mc.addChild(taskitem);
                  taskitem.x = 619;
                  this.items.push(taskitem);
               }
            }
         }
         taskitem = new TaskListItem(this.dialogCls);
         taskitem.addTask(0,this.dialogTwo,this.dispos);
         this.mc.addChild(taskitem);
         taskitem.x = 619;
         this.items.push(taskitem);
         this.updatePosition();
      }
      
      public function opNPCList(task:Task) : void
      {
         TaskUtils.getInstance().dispatchEvent(TaskEvent.OPENDIALOG,{
            "task":task,
            "position":0,
            "needchoose":this.needSendChoose
         });
         this.dispos(true);
      }
      
      private function opFunction(opcode:int, id:int) : void
      {
         var tmpArr:Array = null;
         var tempList:Array = null;
         var param:Object = null;
         var moduleParam:Object = null;
         var tmpObj:Object = null;
         var vo:TasklistItemVo = null;
         if(opcode == 1)
         {
            ApplicationFacade.getInstance().dispatch(EventConst.SHOW_LITTLE_GAME_START,id);
         }
         else
         {
            tmpArr = this.getMsgByID(opcode);
            if(tmpArr[0] != 4)
            {
               tempList = this.getPhpAndTime(opcode);
               if(Boolean(tempList[0]))
               {
                  param = {};
                  param.php = tempList[1];
                  param.time = tempList[2];
                  moduleParam = {};
                  tmpObj = tmpArr[2];
                  moduleParam.url = tmpObj.url;
                  moduleParam.xCoord = tmpObj.xCoord;
                  moduleParam.yCoord = tmpObj.yCoord;
                  moduleParam.mouseright = true;
                  moduleParam.moduleParams = param;
                  this.sendMsgByApplicationFacade(tmpArr[1],moduleParam);
               }
               else
               {
                  vo = this.getMsgToSrv(opcode);
                  if(Boolean(vo))
                  {
                     this.sendMsgByApplicationFacade(EventConst.EVENT_TASKLISTITEMS_SEND_MSG_TO_SRV,vo);
                  }
                  else
                  {
                     if(opcode == 11)
                     {
                        this.sendMsgByApplicationFacade(EventConst.MAKE_CRAZY_RECORD_SCENE_LIST,true);
                     }
                     this.sendMsgByApplicationFacade(tmpArr[1],tmpArr[2]);
                  }
               }
            }
            else
            {
               new Message(tmpArr[1]).sendToChannel(tmpArr[2]);
            }
         }
         this.dispos();
      }
      
      private function sendMsgByApplicationFacade(type:String, obj:Object = null) : void
      {
         if(obj != null)
         {
            ApplicationFacade.getInstance().dispatch(type,obj);
         }
         else
         {
            ApplicationFacade.getInstance().dispatch(type);
         }
      }
      
      private function getVoByID(id:int) : TasklistItemVo
      {
         var vo:TasklistItemVo = null;
         if(this.functionListOfCurrentNPC != null && this.functionListOfCurrentNPC.length > 0)
         {
            for each(vo in this.functionListOfCurrentNPC)
            {
               if(vo.index == id)
               {
                  return vo;
               }
            }
         }
         return null;
      }
      
      private function getNameByID(id:int) : String
      {
         var str:String = "";
         var vo:TasklistItemVo = this.getVoByID(id);
         if(vo != null)
         {
            str = vo.name;
         }
         return str;
      }
      
      private function getMsgByID(id:int) : Array
      {
         var result:Array = new Array(3);
         var vo:TasklistItemVo = this.getVoByID(id);
         if(vo != null)
         {
            result = vo.getMsgEventBody();
         }
         return result;
      }
      
      public function updatePosition() : void
      {
         var i:int = 0;
         var len:int = int(this.items.length);
         var destY:Number = 95;
         this.items.sortOn("type",Array.NUMERIC);
         for(i = 0; i < len; i++)
         {
            this.items[i].y = 300;
            destY = destY - this.items[i].height - this.itemBlank;
            Tweener.addTween(this.items[i],{
               "y":destY,
               "time":0.5,
               "transition":"easeInOutBack"
            });
         }
      }
      
      public function get itemLength() : int
      {
         return this.items.length;
      }
      
      private function loadNPCIMG(npcid:int) : void
      {
         var url:String = null;
         if(this.loader != null)
         {
            this.loader.unloadAndStop();
            this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoadImgComplete);
            if(Boolean(this.loader.parent))
            {
               this.loader.parent.removeChild(this.loader);
            }
         }
         this.loader = new Loader();
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoadImgComplete);
         var tempXML:XML = XMLLocator.getInstance().getNPC(npcid);
         if(tempXML != null)
         {
            url = URLUtil.getSvnVer("assets/dialogimg/half/" + tempXML.enname + ".swf");
         }
         else
         {
            url = URLUtil.getSvnVer("assets/dialogimg/half/tangtaizong.swf");
         }
         this.loader.load(new URLRequest(url));
      }
      
      private function onLoadImgComplete(evt:Event) : void
      {
         evt.stopImmediatePropagation();
         if(this.mc == null)
         {
            this.dispos();
            return;
         }
         this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoadImgComplete);
         this.mc.imgBG.addChild(this.loader);
         this.loader.x = 153.5 - this.loader.width;
         this.loader.y = 123.7 - this.loader.height;
      }
      
      private function onMouseClickClose(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         this.dispos();
      }
      
      private function releaseData() : void
      {
         this.desc = "";
         this.data = null;
         this.currentIndex = 0;
         this.dialogId = 0;
         this.currentNPCID = 0;
         this.dialogOne = "";
         this.dialogTwo = "";
         this.timeoverFlag = false;
         this.needSendChoose = 0;
         this.bInTask = false;
         this.bInfunctionList = false;
         var i:int = 0;
         if(this.items != null && this.items.length > 0)
         {
            for(i = 0; i < this.items.length; i++)
            {
               this.items[i].dispos();
            }
            this.items.length = 0;
            this.items = null;
         }
      }
      
      public function dispos(flag:Boolean = false) : void
      {
         if(!flag)
         {
            FaceView.clip.showBottom();
         }
         this.releaseData();
         if(this.uiLoader != null)
         {
            this.uiLoader.unloadAndStop();
            this.uiLoader.removeEventListener(Event.COMPLETE,this.onLoadComplete);
            this.uiLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
            this.uiLoader = null;
         }
         if(Boolean(this.mc))
         {
            this.mc.close.removeEventListener(MouseEvent.CLICK,this.onMouseClickClose);
            if(this.loader != null)
            {
               this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoadImgComplete);
               if(Boolean(this.mc.imgBG.contains(this.loader)))
               {
                  this.mc.imgBG.removeChild(this.loader);
               }
               this.loader.unloadAndStop();
               this.loader = null;
            }
            if(this.mc != null && Boolean(this.mc.hasOwnProperty("sayTxt")))
            {
               this.mc.sayTxt.removeEventListener(MouseEvent.CLICK,this.onClickNPCSay);
            }
         }
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
         GreenLoading.loading.visible = false;
      }
      
      private function getPhpAndTime(value:int) : Array
      {
         var vo:TasklistItemVo = null;
         var result:Array = [false,"",""];
         if(this.functionListOfCurrentNPC != null && this.functionListOfCurrentNPC.length > 0)
         {
            for each(vo in this.functionListOfCurrentNPC)
            {
               if(vo.index == value)
               {
                  if(vo.php.length > 0)
                  {
                     result[0] = true;
                     result[1] = vo.php;
                     result[2] = vo.time;
                  }
               }
            }
         }
         return result;
      }
      
      private function getMsgToSrv(value:int) : TasklistItemVo
      {
         var vo:TasklistItemVo = null;
         if(this.functionListOfCurrentNPC != null && this.functionListOfCurrentNPC.length > 0)
         {
            for each(vo in this.functionListOfCurrentNPC)
            {
               if(vo.index == value)
               {
                  if(vo.msgCode > 0)
                  {
                     return vo;
                  }
               }
            }
         }
         return null;
      }
   }
}

