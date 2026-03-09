package com.game.modules.view.task.activation
{
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.alert.Alert;
   import com.publiccomponent.loading.GreenLoading;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.utils.Timer;
   import flash.utils.getDefinitionByName;
   
   public class TestForMessager extends Sprite
   {
      
      private var loader:Loader;
      
      private var mc:MovieClip;
      
      private var loadCount:int = 4;
      
      private var callback:Function;
      
      private var timer:Timer;
      
      private var answer:int = 0;
      
      private var upList:Array = [2,3,5];
      
      private var upContainer:Array;
      
      private var upArr:Array;
      
      private var upLine:Number = 200;
      
      private var upBlank:Number = 20;
      
      private var downList:Array;
      
      private var downArr:Array;
      
      private var downLine:Number = 400;
      
      private var downBlank:Number = 10;
      
      private var clsList:Array;
      
      private var wenhao:MovieClip;
      
      private var upDown:Boolean = false;
      
      private var currentLevel:int = 0;
      
      public function TestForMessager()
      {
         super();
         GreenLoading.loading.visible = true;
         this.loader = new Loader();
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoadComplete);
         this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
         this.loader.load(new URLRequest(URLUtil.getSvnVer("assets/material/testformessager.swf")));
      }
      
      private function onLoadComplete(evt:Event) : void
      {
         this.mc = this.loader.content as MovieClip;
         var domain:ApplicationDomain = this.loader.contentLoaderInfo.applicationDomain;
         var touxiang1:Class = domain.getDefinition("touxiang1") as Class;
         var touxiang2:Class = domain.getDefinition("touxiang2") as Class;
         var touxiang3:Class = domain.getDefinition("touxiang3") as Class;
         var touxiang4:Class = domain.getDefinition("touxiang4") as Class;
         var touxiang5:Class = domain.getDefinition("touxiang5") as Class;
         var touxiang6:Class = domain.getDefinition("touxiang6") as Class;
         var touxiang7:Class = domain.getDefinition("touxiang7") as Class;
         var touxiang8:Class = domain.getDefinition("touxiang8") as Class;
         var touxiang9:Class = domain.getDefinition("touxiang9") as Class;
         var touxiang10:Class = domain.getDefinition("touxiang10") as Class;
         var touxiang11:Class = domain.getDefinition("touxiang11") as Class;
         this.clsList = [touxiang1,touxiang2,touxiang3,touxiang4,touxiang5,touxiang6,touxiang7,touxiang8,touxiang9,touxiang10,touxiang11];
         var cls:Class = domain.getDefinition("wenhao") as Class;
         this.wenhao = new cls() as MovieClip;
         this.mc.addChild(this.wenhao);
         this.mc.stop();
         this.wenhao.stop();
         this.wenhao.visible = false;
         this.loader.unloadAndStop();
         this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoadComplete);
         this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
         this.loader = null;
         this.addChild(this.mc);
         this.mc.x = 0;
         this.mc.y = 0;
         this.initEvent();
         if(this.callback != null)
         {
            this.initGame();
         }
      }
      
      private function onLoadError(evt:IOErrorEvent) : void
      {
         O.o("TestForMessager - onLoadError");
         --this.loadCount;
         if(this.loadCount > 0)
         {
            this.loader.load(new URLRequest(URLUtil.getSvnVer("assets/material/testformessager.swf")));
            return;
         }
         this.loader.unloadAndStop();
         this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoadComplete);
         this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
         this.loader = null;
         this.dispos();
      }
      
      private function initEvent() : void
      {
         if(this.mc != null)
         {
            this.mc.soundMC.gotoAndStop(1);
            this.mc.soundMC.addEventListener(MouseEvent.CLICK,this.onClickSound);
            this.mc.closeBtn.addEventListener(MouseEvent.CLICK,this.onClickClose);
         }
      }
      
      private function removeEvent() : void
      {
         if(this.mc != null)
         {
            this.mc.soundMC.gotoAndStop(1);
            this.mc.soundMC.removeEventListener(MouseEvent.CLICK,this.onClickSound);
            this.mc.closeBtn.removeEventListener(MouseEvent.CLICK,this.onClickClose);
         }
      }
      
      private function onClickSound(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         this.mc.soundMC.gotoAndStop(this.mc.soundMC.currentFrame == 1 ? 2 : 1);
      }
      
      private function onClickClose(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         if(this.timer != null)
         {
            this.timer.reset();
            this.timer.stop();
            this.timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
            this.timer = null;
         }
         this.removeEvent();
         this.dispos();
      }
      
      public function dispos(flag:Boolean = false) : void
      {
         this.removeEvent();
         this.destroyData();
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
         this.removeChild(this.mc);
         if(this.callback != null)
         {
            if(flag)
            {
               this.callback.apply(null,[false]);
            }
            else
            {
               this.callback.apply(null,["closedialog"]);
            }
         }
         this.callback = null;
         this.mc.stop();
         this.mc = null;
      }
      
      public function setData(param:Object) : void
      {
         this.callback = param.callback;
         if(this.mc != null)
         {
            this.initGame();
         }
      }
      
      private function initGame(level:int = 0) : void
      {
         var obj:MovieClip = null;
         var dis:MovieClip = null;
         if(this.upContainer != null)
         {
            for each(obj in this.upContainer)
            {
               this.mc.removeChild(obj);
            }
            this.upContainer.length = 0;
            this.upContainer = null;
         }
         if(this.downList != null)
         {
            for each(dis in this.downList)
            {
               dis.removeEventListener(MouseEvent.CLICK,this.onChooseClick);
               this.mc.removeChild(dis);
            }
            this.downList.length = 0;
            this.downList = null;
         }
         this.mc.question.visible = false;
         this.answer = 0;
         this.setUp(this.upList[level]);
      }
      
      private function setUp(txCount:int) : void
      {
         var tmp:int = 0;
         if(this.upArr != null)
         {
            this.upArr.length = 0;
            this.upArr = null;
         }
         this.wenhao.visible = false;
         this.upArr = [];
         var i:int = 0;
         for(i = 0; i < txCount; i++)
         {
            tmp = (Math.random() * 11 >> 0) + 1;
            while(this.upArr.indexOf(tmp) != -1)
            {
               tmp = (Math.random() * 11 >> 0) + 1;
            }
            this.upArr.push(tmp);
         }
         this.setPosition();
         GreenLoading.loading.visible = false;
         this.showTimer();
      }
      
      private function setDown(txCount:int) : void
      {
         var tmp:int = 0;
         if(this.downArr != null)
         {
            this.downArr.length = 0;
            this.downArr = null;
         }
         this.downArr = [];
         var i:int = 0;
         this.downArr.push(this.answer);
         for(i = 0; i < txCount - 1; i++)
         {
            tmp = (Math.random() * 11 >> 0) + 1;
            while(this.downArr.indexOf(tmp) != -1)
            {
               tmp = (Math.random() * 11 >> 0) + 1;
            }
            this.downArr.push(tmp);
         }
         this.setPosition(true);
         this.findTimer();
      }
      
      private function showTimer(delay:int = 3000) : void
      {
         if(this.timer == null)
         {
            this.timer = new Timer(delay);
            this.timer.addEventListener(TimerEvent.TIMER,this.onTimer);
         }
         this.upDown = false;
         this.timer.start();
      }
      
      private function findTimer(delay:int = 15000) : void
      {
         if(this.timer == null)
         {
            this.timer = new Timer(delay);
            this.timer.addEventListener(TimerEvent.TIMER,this.onTimer);
         }
         this.upDown = true;
         this.timer.start();
      }
      
      private function onTimer(evt:TimerEvent) : void
      {
         var obj:MovieClip = null;
         var miss:int = 0;
         var i:int = 0;
         var len:int = 0;
         var item:MovieClip = null;
         evt.stopImmediatePropagation();
         if(this.timer == null)
         {
            return;
         }
         this.timer.reset();
         this.timer.stop();
         this.timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
         this.timer = null;
         if(this.upDown)
         {
            if(this.downList != null && this.downList.length > 0)
            {
               for each(obj in this.downList)
               {
                  this.mc.removeChild(obj);
               }
               this.downList.length = 0;
               this.downList = null;
            }
            this.mc.closeBtn.mouseEnabled = false;
            new Alert().showOne("时间到了...",this.clickHandler);
         }
         else
         {
            miss = Math.random() * this.upArr.length >> 0;
            i = 0;
            len = int(this.clsList.length);
            for(i = 0; i < len; i++)
            {
               if(this.upContainer[miss] is this.clsList[i])
               {
                  this.answer = i + 1;
                  break;
               }
            }
            this.upArr.length = 0;
            this.upArr = null;
            item = this.upContainer.splice(miss,1)[0];
            this.mc.removeChild(item);
            this.wenhao.x = item.x;
            this.wenhao.y = item.y;
            this.wenhao.visible = true;
            this.mc.question.visible = true;
            this.setDown(4);
         }
      }
      
      private function setPosition(pos:Boolean = false) : void
      {
         var item:MovieClip = null;
         var len:int = 0;
         var i:int = 0;
         if(pos)
         {
            if(this.downArr != null && this.downArr.length > 0)
            {
               if(this.downList == null)
               {
                  this.downList = [];
               }
               len = int(this.downArr.length);
               while(len > 0)
               {
                  i = Math.random() * len >> 0;
                  item = new this.clsList[this.downArr.splice(i,1)[0] - 1]() as MovieClip;
                  this.mc.addChild(item);
                  if(len == 4)
                  {
                     item.x = 300;
                  }
                  else
                  {
                     item.x = this.downList[this.downList.length - 1].x + this.downBlank + this.downList[this.downList.length - 1].width / 2 + item.width / 2;
                  }
                  item.y = this.downLine;
                  this.downList.push(item);
                  item.buttonMode = true;
                  item.addEventListener(MouseEvent.CLICK,this.onChooseClick);
                  len--;
               }
            }
         }
         else if(this.upArr != null && this.upArr.length > 0)
         {
            if(this.upContainer == null)
            {
               this.upContainer = [];
            }
            len = int(this.upArr.length);
            for(i = 0; i < len; i++)
            {
               item = new this.clsList[this.upArr[i] - 1]() as MovieClip;
               this.upContainer.push(item);
               this.mc.addChild(item);
               if(len == 2)
               {
                  item.x = 350 + i * 300;
                  item.y = this.upLine;
               }
               else if(len == 3)
               {
                  item.x = 350 + i * 150;
                  item.y = this.upLine;
               }
               else if(i >= 2)
               {
                  item.x = 350 + (i - 2) * 150;
                  item.y = 250;
               }
               else
               {
                  item.x = 425 + i * 150;
                  item.y = 150;
               }
            }
         }
      }
      
      private function onChooseClick(evt:MouseEvent) : void
      {
         var dis:MovieClip = null;
         evt.stopImmediatePropagation();
         if(this.downList != null)
         {
            for each(dis in this.downList)
            {
               dis.removeEventListener(MouseEvent.CLICK,this.onChooseClick);
            }
         }
         if(this.timer != null)
         {
            this.timer.reset();
            this.timer.stop();
            this.timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
            this.timer = null;
         }
         var i:int = 0;
         var len:int = int(this.clsList.length);
         var item:MovieClip = evt.currentTarget as MovieClip;
         if(item is this.clsList[this.answer - 1])
         {
            this.mc.closeBtn.mouseEnabled = false;
            new Alert().showOne("太棒了!～选对了...",this.chooseRightHandler);
            return;
         }
         this.mc.closeBtn.mouseEnabled = false;
         new Alert().showOne("额偶！～选错了...又得从头再来了...",this.clickHandler);
      }
      
      private function clickHandler(txt:String, ... rest) : void
      {
         this.currentLevel = 0;
         this.mc.closeBtn.mouseEnabled = true;
         if(txt == "确定")
         {
            this.initGame(0);
         }
      }
      
      private function chooseRightHandler(txt:String, ... rest) : void
      {
         ++this.currentLevel;
         this.mc.closeBtn.mouseEnabled = true;
         if(txt == "确定")
         {
            if(this.currentLevel == this.upList.length)
            {
               this.win();
            }
            else
            {
               this.initGame(this.currentLevel);
            }
         }
      }
      
      private function win() : void
      {
         this.dispos(true);
      }
      
      private function destroyData() : void
      {
         var item:MovieClip = null;
         var dis:MovieClip = null;
         if(this.timer != null)
         {
            this.timer.reset();
            this.timer.stop();
            this.timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
            this.timer = null;
         }
         this.answer = 0;
         this.upList = null;
         if(this.upContainer != null && this.upContainer.length > 0)
         {
            for each(item in this.upContainer)
            {
               this.mc.removeChild(item);
            }
            this.upContainer.length = 0;
            this.upContainer = null;
         }
         if(this.upArr != null && this.upArr.length > 0)
         {
            this.upArr.length = 0;
            this.upArr = null;
         }
         if(this.downList != null && this.downList.length > 0)
         {
            for each(dis in this.downList)
            {
               this.mc.removeChild(dis);
            }
            this.downList.length = 0;
            this.downList = null;
         }
         if(this.downArr != null && this.downArr.length > 0)
         {
            this.downArr.length = 0;
            this.downArr = null;
         }
         if(this.clsList != null && this.clsList.length > 0)
         {
            this.clsList.length = 0;
            this.clsList = null;
         }
         this.mc.removeChild(this.wenhao);
         this.upDown = false;
         this.currentLevel = 0;
      }
   }
}

