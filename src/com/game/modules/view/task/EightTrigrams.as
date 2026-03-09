package com.game.modules.view.task
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.locators.GameData;
   import com.game.util.AwardAlert;
   import com.game.util.HtmlUtil;
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.loading.XMLLocator;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.net.URLRequest;
   import flash.utils.Timer;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class EightTrigrams extends Sprite
   {
      
      private var mc:MovieClip;
      
      private var loader:Loader;
      
      private var timer:Timer;
      
      private var trigram:int;
      
      private var itemid:int;
      
      private var award:int;
      
      private var npcid:int;
      
      private var listArr:Array;
      
      private var currentId:int;
      
      private var shape:Sprite;
      
      private var delay:int = 42;
      
      private var index:int = 0;
      
      private var sid:int;
      
      public function EightTrigrams()
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
         this.loader = new Loader();
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoadComplete);
         this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
         this.loader.load(new URLRequest(URLUtil.getSvnVer("assets/material/trigram.swf")));
      }
      
      private function onLoadComplete(evt:Event) : void
      {
         this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoadComplete);
         this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
         this.mc = (this.loader.getChildAt(0) as MovieClip).getChildAt(0) as MovieClip;
         this.loader.unloadAndStop();
         this.loader = null;
         this.mc.closeBtn.visible = false;
         this.listArr = [[1,1,2,1,11,1,2,1],[1,1,2,11,2,3,2,2],[5,3,2,1,3,3,2,11],[5,3,11,2,5,3,3,2],[5,3,5,11,6,3,3,2],[7,11,5,3,6,11,5,5],[9,5,11,6,7,5,11,6],[10,11,9,7,10,11,9,7]];
         this.shape.addChild(this.mc);
         this.mc.x = 0;
         this.mc.y = 0;
         if(this.trigram != 0)
         {
            this.init();
         }
      }
      
      private function getcurrentTime() : Number
      {
         var current:Date = new Date();
         current.setTime(GameData.instance.playerData.systemTimes * 1000);
         var month:Number = current.month + 1;
         var day:Number = 0;
         if(month == 2)
         {
            day = current.date;
         }
         return day;
      }
      
      private function onLoadError(evt:IOErrorEvent) : void
      {
         this.loader.unloadAndStop();
         this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoadComplete);
         this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
         this.loader = null;
         this.dispos();
      }
      
      public function setData(trigram:int, award:int, npcid:int, currentId:int, itemid:int) : void
      {
         this.trigram = trigram;
         this.itemid = itemid;
         this.award = award;
         this.npcid = npcid;
         this.currentId = currentId - 1;
         if(this.mc != null)
         {
            this.init();
         }
      }
      
      private function init() : void
      {
         this.mc.BG.gotoAndStop(1);
         for(var i:int = 1; i <= 8; i++)
         {
            (this.mc["mc" + i] as MovieClip).gotoAndStop(this.listArr[this.currentId][i - 1]);
         }
         this.mc.startBtn.visible = true;
         this.mc.stopBtn.visible = false;
         this.mc.startBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.onClickStart);
         this.timer = new Timer(1000,4);
         this.timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimer);
      }
      
      private function onClickStart(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         this.mc.startBtn.removeEventListener(MouseEvent.CLICK,this.onClickStart);
         this.mc.startBtn.visible = false;
         this.mc.stopBtn.visible = true;
         this.timer.start();
         (this.mc.BG as MovieClip).play();
      }
      
      private function onClose(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         this.dispos("close");
      }
      
      private function onTimer(evt:TimerEvent) : void
      {
         evt.stopImmediatePropagation();
         this.timer.stop();
         this.timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
         this.timer = null;
         this.stopPlay();
      }
      
      private function stopPlay() : void
      {
         this.mc.BG.stop();
         this.sid = setTimeout(this.slowDown,this.delay);
      }
      
      private function slowDown() : void
      {
         if(this.mc.BG.currentFrame == this.mc.BG.totalFrames)
         {
            this.mc.BG.gotoAndStop(1);
         }
         else
         {
            this.mc.BG.nextFrame();
         }
         ++this.index;
         if(this.delay <= 1000)
         {
            this.delay = 42 * this.index + 1 / 2 * 50 * Math.pow(this.index,2);
         }
         clearTimeout(this.sid);
         if(this.mc.BG.currentFrame == this.trigram)
         {
            this.slowOver();
         }
         else
         {
            this.sid = setTimeout(this.slowDown,this.delay);
         }
      }
      
      private function slowOver() : void
      {
         this.mc.BG.stop();
         this.sid = setTimeout(this.showAward,500);
      }
      
      private function showAward() : void
      {
         var subxml:XML = null;
         clearTimeout(this.sid);
         var url:String = "";
         var namestr:String = "";
         subxml = XMLLocator.getInstance().getTool(this.itemid);
         if(Boolean(subxml))
         {
            namestr = subxml.name.toString();
            url = "assets/tool/" + this.itemid + ".swf";
            new AwardAlert().showGoodsAward(url,stage,"获得 " + HtmlUtil.getHtmlText(12,"#FF0000",namestr),true,this.dispos);
         }
         if(this.award != 0)
         {
            new AwardAlert().showExpAward(this.award,stage,this.dispos);
         }
      }
      
      public function dispos(param:Object = null) : void
      {
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
         if(this.timer != null)
         {
            this.timer.reset();
            this.timer.stop();
            this.timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
            this.timer = null;
         }
         this.trigram = 0;
         if(param != null && param as String == "close")
         {
            return;
         }
         ApplicationFacade.getInstance().dispatch(EventConst.MASTERISOUTSPECIALAREA,{
            "npcid":this.npcid,
            "dialogID":1111111
         });
         this.delay = 42;
         this.index = 0;
      }
   }
}

