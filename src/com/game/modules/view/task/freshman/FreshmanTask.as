package com.game.modules.view.task.freshman
{
   import com.game.modules.control.task.TaskEvent;
   import com.game.modules.control.task.util.TaskUtils;
   import com.game.util.CacheUtil;
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.loading.GreenLoading;
   import com.publiccomponent.loading.Loading;
   import com.publiccomponent.loading.XMLLocator;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   
   public class FreshmanTask extends Sprite
   {
      
      private var loading:Loading;
      
      private var mc:MovieClip;
      
      private var taskArr:Array;
      
      private var sceneID:int;
      
      private var flag:Boolean = false;
      
      private var taskID:int;
      
      private var _index:int = 0;
      
      private var shape:Sprite;
      
      private var f:ColorMatrixFilter = new ColorMatrixFilter([0.3,0.6,0,0,0,0.3,0.6,0,0,0,0.3,0.6,0,0,0,0,0,0,1,0]);
      
      public function FreshmanTask()
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
         this.taskArr = [];
         this.loading = GreenLoading.loading;
         this.loading.visible = true;
         this.loading.loadModule("正在加载新手捕捉任务，请稍等...",URLUtil.getSvnVer("assets/material/freshmanTask.swf"),this.onLoadComplete);
         this.cacheAsBitmap = true;
      }
      
      public function setData(params:int) : void
      {
         this._index = 0;
         if(!this.isIn(params))
         {
            this.taskID = params;
            this.taskArr.push(params);
            if(this.mc != null)
            {
               this.init();
            }
            else
            {
               this.flag = true;
            }
         }
         else if(this.mc != null)
         {
            this.init();
         }
      }
      
      private function isIn(id:int) : Boolean
      {
         if(this.taskArr.length == 0)
         {
            return false;
         }
         var i:int = 0;
         var len:int = int(this.taskArr.length);
         for(i = 0; i < len; i++)
         {
            if(this.taskArr[i] == id)
            {
               return true;
            }
         }
         return false;
      }
      
      private function init() : void
      {
         var xml:XML = null;
         var goodXML:XML = null;
         if(!this.mc.gotoNow.hasEventListener(MouseEvent.MOUSE_DOWN))
         {
            this.mc.gotoNow.addEventListener(MouseEvent.CLICK,this.onMouseClickGo);
         }
         if(!this.mc.close.hasEventListener(MouseEvent.CLICK))
         {
            this.mc.close.addEventListener(MouseEvent.CLICK,this.onMouseClickClose);
         }
         this.initTaskBtnEvent();
         xml = XMLLocator.getInstance().dailyTask.children().(@id == this.taskID)[0] as XML;
         if(xml == null)
         {
            xml = XMLLocator.getInstance().dailyTask.children()[0] as XML;
         }
         goodXML = XMLLocator.getInstance().getTool(int(xml.diff.goods.@id));
         this.sceneID = int(xml.targetScene);
         this.mc.taskdesc.text = xml.dia.(@id == 1).toString();
         this.mc.tasktarget.text = xml.dia.(@id == 2).toString();
         this.mc.taskaward.text = int(xml.diff.exp) + " 历练\t" + int(xml.diff.goods.@number) + "个" + String(goodXML.name);
      }
      
      private function initTaskBtnEvent() : void
      {
         this.mc.aFlag.visible = false;
         this.mc.bFlag.visible = false;
         this.mc.cFlag.visible = false;
         switch(this.taskID % 10)
         {
            case 1:
               this.setFilters(true,false,false);
               break;
            case 2:
               this.setFilters(false,true,false);
               break;
            case 3:
               this.setFilters(false,false,true);
         }
      }
      
      private function setFilters(aflag:Boolean, bflag:Boolean, cflag:Boolean) : void
      {
         if(aflag)
         {
            (this.mc.taskone as MovieClip).filters = [];
            (this.mc.taskone as MovieClip).addEventListener(MouseEvent.CLICK,this.onMouseClickOne);
            (this.mc.taskone as MovieClip).addEventListener(MouseEvent.ROLL_OVER,this.onMouseRollOver);
         }
         else if(bflag)
         {
            (this.mc.taskone as MovieClip).filters = [this.f];
            (this.mc.taskone as MovieClip).removeEventListener(MouseEvent.CLICK,this.onMouseClickOne);
            (this.mc.taskone as MovieClip).removeEventListener(MouseEvent.ROLL_OVER,this.onMouseRollOver);
            (this.mc.tasktwo as MovieClip).filters = [];
            (this.mc.tasktwo as MovieClip).addEventListener(MouseEvent.CLICK,this.onMouseClickTwo);
            (this.mc.tasktwo as MovieClip).addEventListener(MouseEvent.ROLL_OVER,this.onMouseRollOver);
            this.mc.aFlag.visible = true;
         }
         else if(cflag)
         {
            (this.mc.taskone as MovieClip).filters = [this.f];
            (this.mc.taskone as MovieClip).removeEventListener(MouseEvent.CLICK,this.onMouseClickOne);
            (this.mc.taskone as MovieClip).removeEventListener(MouseEvent.ROLL_OVER,this.onMouseRollOver);
            (this.mc.tasktwo as MovieClip).filters = [this.f];
            (this.mc.tasktwo as MovieClip).removeEventListener(MouseEvent.CLICK,this.onMouseClickTwo);
            (this.mc.tasktwo as MovieClip).removeEventListener(MouseEvent.ROLL_OVER,this.onMouseRollOver);
            (this.mc.taskthree as MovieClip).filters = [];
            (this.mc.taskthree as MovieClip).addEventListener(MouseEvent.CLICK,this.onMouseClickThree);
            (this.mc.taskthree as MovieClip).addEventListener(MouseEvent.ROLL_OVER,this.onMouseRollOver);
            this.mc.aFlag.visible = true;
            this.mc.bFlag.visible = true;
         }
         else
         {
            this.mc.aFlag.visible = true;
            this.mc.bFlag.visible = true;
            this.mc.cFlag.visible = true;
            this.destroyMe();
         }
      }
      
      private function onMouseRollOver(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         (evt.currentTarget as MovieClip).gotoAndStop(2);
         (evt.currentTarget as MovieClip).addEventListener(MouseEvent.ROLL_OUT,this.onMouseRollOut);
      }
      
      private function onMouseRollOut(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         (evt.currentTarget as MovieClip).gotoAndStop(1);
         (evt.currentTarget as MovieClip).removeEventListener(MouseEvent.ROLL_OUT,this.onMouseRollOut);
      }
      
      private function onMouseClickOne(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         if(this.taskArr.length > 0)
         {
            this.taskID = this.taskArr[0];
         }
         this.init();
      }
      
      private function onMouseClickTwo(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         if(this.taskArr.length > 1)
         {
            this.taskID = this.taskArr[1];
         }
         this.init();
      }
      
      private function onMouseClickThree(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         if(this.taskArr.length > 2)
         {
            this.taskID = this.taskArr[2];
         }
         this.init();
      }
      
      private function onLoadComplete(display:Loader) : void
      {
         this.loading.visible = false;
         this.mc = (display.getChildAt(0) as MovieClip).getChildAt(0) as MovieClip;
         this.addChild(this.mc);
         this.mc.x = 200;
         this.mc.y = 50;
         (this.mc.taskone as MovieClip).filters = [];
         (this.mc.tasktwo as MovieClip).filters = [this.f];
         (this.mc.taskthree as MovieClip).filters = [this.f];
         (this.mc.taskone as MovieClip).buttonMode = true;
         (this.mc.tasktwo as MovieClip).buttonMode = true;
         (this.mc.taskthree as MovieClip).buttonMode = true;
         display.unloadAndStop();
         if(this.flag)
         {
            this.init();
         }
      }
      
      private function onMouseClickGo(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         this.mc.gotoNow.removeEventListener(MouseEvent.CLICK,this.onMouseClickGo);
         var obj:Object = {};
         obj.taskID = this.taskID;
         obj.actionID = 1;
         obj.level = 0;
         obj.type = 1;
         TaskUtils.getInstance().dispatchEvent(TaskEvent.DAILYTASKOPINNOTDAILY,obj);
         this.dispos();
         TaskUtils.getInstance().dispatchEvent(TaskEvent.SENDTOOTHERSCENE,this.sceneID);
      }
      
      private function onMouseClickClose(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         this.mc.close.removeEventListener(MouseEvent.CLICK,this.onMouseClickClose);
         this.dispos();
      }
      
      public function dispos() : void
      {
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
         this.mc.gotoNow.removeEventListener(MouseEvent.CLICK,this.onMouseClickGo);
         this.mc.close.removeEventListener(MouseEvent.CLICK,this.onMouseClickClose);
      }
      
      public function destroyMe() : void
      {
         (this.mc.taskthree as SimpleButton).removeEventListener(MouseEvent.CLICK,this.onMouseClickThree);
         this.mc.stop();
         this.mc = null;
         this.taskArr = null;
         this.dispos();
         this.shape = null;
         CacheUtil.pool[FreshmanTask] = null;
         delete CacheUtil.pool[FreshmanTask];
      }
   }
}

