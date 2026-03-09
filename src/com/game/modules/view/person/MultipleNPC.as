package com.game.modules.view.person
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.locators.GameData;
   import com.game.manager.MouseManager;
   import com.game.modules.action.GameSpriteAction;
   import com.game.modules.control.task.TaskEvent;
   import com.game.modules.control.task.TaskList;
   import com.game.modules.control.task.util.TaskInfoXMLParser;
   import com.game.modules.control.task.util.TaskUtils;
   import com.game.modules.view.MapView;
   import com.game.modules.vo.NPCVo;
   import com.game.util.BitValueUtil;
   import com.game.util.GameDynamicUI;
   import com.game.util.GamePersonControl;
   import com.game.util.IdName;
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.alert.Alert;
   import com.publiccomponent.loading.GreenLoading;
   import com.publiccomponent.loading.MaterialLib;
   import com.publiccomponent.ui.TextArea;
   import com.publiccomponent.ui.ToolTip;
   import flash.display.DisplayObject;
   import flash.display.FrameLabel;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.utils.Timer;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import org.engine.core.GameSprite;
   import org.plat.monitor.PlatMonitorLog;
   
   public class MultipleNPC extends GameSprite implements INPC
   {
      
      private var _npcData:NPCVo;
      
      private var loopType:int = 1;
      
      private var pickupType:int = 2;
      
      private var fsmState:int;
      
      private var npcState:int;
      
      private var mc:MovieClip;
      
      private var stateMC:MovieClip;
      
      private var loader:Loader;
      
      private var currentCursorName:String;
      
      private var actionFlag:Boolean;
      
      private var master:GamePerson;
      
      private var playEffectCallback:Function;
      
      private var npcNameTF:TextField;
      
      private var isClick:Boolean = false;
      
      private var mouseoverDia:XML;
      
      private var mouseoverflag:int;
      
      private var msgTxt:TextArea;
      
      private var timer:Timer;
      
      private var tempParams:Object;
      
      private var isPlaying:Boolean = false;
      
      private var playTimer:Timer;
      
      private var _needHold:Boolean = false;
      
      private var _startHold:int = 0;
      
      private var _holdSid:uint;
      
      private var tempState:int;
      
      private var sid:uint;
      
      private var animationPosList:Array;
      
      private var tempDis:MovieClip;
      
      private var tid:uint;
      
      private var msgForNext:*;
      
      public function MultipleNPC(param:NPCVo)
      {
         var t_flag:Boolean = false;
         var offsetx:Number = NaN;
         var offsety:Number = NaN;
         this.animationPosList = [{
            "id":31309,
            "xCoord":187,
            "yCoord":250
         },{
            "id":401402,
            "xCoord":600,
            "yCoord":201
         },{
            "id":401403,
            "xCoord":600,
            "yCoord":201
         },{
            "id":51317,
            "xCoord":480,
            "yCoord":250
         },{
            "id":61222,
            "xCoord":525,
            "yCoord":478
         },{
            "id":21922,
            "xCoord":712,
            "yCoord":498
         },{
            "id":301507,
            "xCoord":254,
            "yCoord":431
         },{
            "id":21926,
            "xCoord":712,
            "yCoord":498
         },{
            "id":21927,
            "xCoord":500,
            "yCoord":335
         },{
            "id":41225,
            "xCoord":281,
            "yCoord":323
         },{
            "id":111301,
            "xCoord":837,
            "yCoord":453
         },{
            "id":301512,
            "xCoord":595,
            "yCoord":435
         },{
            "id":81104,
            "xCoord":515,
            "yCoord":440
         },{
            "id":901210,
            "xCoord":811.2,
            "yCoord":540
         },{
            "id":31219,
            "xCoord":276,
            "yCoord":449
         },{
            "id":71701,
            "xCoord":632,
            "yCoord":415
         },{
            "id":101203,
            "xCoord":553,
            "yCoord":321
         },{
            "id":71122,
            "xCoord":198,
            "yCoord":282
         },{
            "id":31108,
            "xCoord":590,
            "yCoord":380
         },{
            "id":901212,
            "xCoord":660,
            "yCoord":545
         },{
            "id":71124,
            "xCoord":460,
            "yCoord":257
         },{
            "id":91325,
            "xCoord":830,
            "yCoord":395
         },{
            "id":91328,
            "xCoord":349,
            "yCoord":264
         },{
            "id":901213,
            "xCoord":250,
            "yCoord":435
         }];
         super();
         this.x = param.x;
         this.y = param.y;
         this.spriteName = IdName.npc(param.sequenceID);
         this.sequenceID = param.sequenceID;
         if(param.getValueOfSpecifiedBit(12))
         {
            if(Boolean(GameData.instance.playerData.roleType & 1 > 0))
            {
               param.url += "_1";
            }
            else
            {
               param.url += "_2";
            }
         }
         param.url += ".swf";
         if(param.getValueOfSpecifiedBit(13))
         {
            param.name = GameData.instance.playerData.userName;
         }
         this.ui = new Sprite();
         Sprite(ui).cacheAsBitmap = true;
         if(param.getValueOfSpecifiedBit(10))
         {
            t_flag = Math.random() > 0.7 ? true : false;
            if(t_flag)
            {
               offsetx = (900 - this.x) * Math.random();
               offsety = (500 - this.y) * Math.random();
               this.x += offsetx;
               this.y += offsety;
            }
            else
            {
               offsetx = (this.x - 50) * Math.random();
               offsety = (this.y - 50) * Math.random();
               this.x -= offsetx;
               this.y -= offsety;
            }
         }
         this._npcData = param;
         this.loader = new Loader();
      }
      
      public function load(reload:Boolean = false) : void
      {
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoadComplete);
         this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
         if(reload)
         {
            PlatMonitorLog.instance.writeNewLog(501);
            this.loader.load(new URLRequest(URLUtil.getSvnVer(this._npcData.url) + new Date().getTime()));
         }
         else
         {
            this.loader.load(new URLRequest(URLUtil.getSvnVer(this._npcData.url)));
         }
      }
      
      public function onLoadComplete(evt:Event) : void
      {
         evt.stopImmediatePropagation();
         if(this._npcData.mapid != GameData.instance.playerData.currentScenenId && sequenceID != 10033)
         {
            this.dispos();
            return;
         }
         if(this.loader.contentLoaderInfo.bytesLoaded < this.loader.contentLoaderInfo.bytesTotal)
         {
            this.load(true);
            return;
         }
         GreenLoading.loading.visible = false;
         this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoadComplete);
         var domain:ApplicationDomain = evt.currentTarget.applicationDomain as ApplicationDomain;
         var cls:Class = domain.getDefinition("npc") as Class;
         this.mc = new cls() as MovieClip;
         this.mc.stop();
         this.mc.addEventListener(Event.ADDED_TO_STAGE,this.onAddToStage);
         this.addChild(this.mc);
         this.loader.unloadAndStop();
         this.loader = null;
         if(this._npcData.getValueOfSpecifiedBit(3))
         {
            this.npcNameTF = new TextField();
            this.npcNameTF.multiline = false;
            this.npcNameTF.wordWrap = false;
            this.npcNameTF.mouseEnabled = false;
            this.npcNameTF.selectable = false;
            this.npcNameTF.defaultTextFormat = new TextFormat("宋体",14,255,null,null,null,null,null,TextFormatAlign.CENTER);
            if(this._npcData.name.length > 7)
            {
               this.npcNameTF.width += 14 * (this._npcData.name.length - 7);
            }
            this.npcNameTF.text = this._npcData.name;
            this.npcNameTF.filters = [new GlowFilter(16777215,1,3,3,10)];
            Sprite(this.ui).addChild(this.npcNameTF);
            this.npcNameTF.parent.setChildIndex(this.npcNameTF,0);
         }
         this.updateState(1);
         if(this._npcData.type == this.pickupType)
         {
            this.mc.buttonMode = true;
         }
         if(this.sequenceID == 10011)
         {
            ApplicationFacade.getInstance().dispatch(EventConst.TASKTOZHUANGYUANGUIDE,{
               "flag":false,
               "step0":-1,
               "step1":-1
            });
         }
         if(this._npcData.getValueOfSpecifiedBit(15))
         {
            if(this.mc.parent is Sprite)
            {
               this.mc.parent.mouseEnabled = this.mc.parent.mouseChildren = false;
            }
         }
      }
      
      public function onLoadError(evt:IOErrorEvent) : void
      {
         trace("【多功能NPC类加载失败...】" + evt);
         this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoadComplete);
         this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
         this.loader.unloadAndStop();
         this.loader = null;
         GreenLoading.loading.visible = false;
      }
      
      public function initEvents() : void
      {
         var tempArr:Array = null;
         var i:int = 0;
         var len:int = 0;
         var frameLabel:FrameLabel = null;
         if(this.mc.totalFrames > 1)
         {
            tempArr = this.mc.currentLabels;
            if(tempArr == null)
            {
               return;
            }
            i = 0;
            len = int(tempArr.length);
            for(i = 0; i < len; i++)
            {
               frameLabel = tempArr[i];
               if(frameLabel.name.substr(0,12) == "requeststate")
               {
                  this.mc.addFrameScript(frameLabel.frame - 1,this.requestState);
               }
               else if(frameLabel.name.length >= 9 && frameLabel.name.substr(0,9) == "autoclick")
               {
                  this.mc.addFrameScript(frameLabel.frame - 1,this.stopAndClickMe);
               }
               else if(frameLabel.name == "pushmaster")
               {
                  this.mc.addFrameScript(frameLabel.frame - 1,this.onPushMasterBack);
               }
               else if(frameLabel.name.substr(0,5) == "timer")
               {
                  this.mc.addFrameScript(frameLabel.frame - 1,this.onStartPlayTimer);
               }
               else if(frameLabel.name == "backtofirst")
               {
                  this.mc.addFrameScript(frameLabel.frame - 1,this.onBackToFirst);
               }
               else if(frameLabel.name == "pushback")
               {
                  this.mc.addFrameScript(frameLabel.frame - 1,this.onPushBack);
               }
               else if(frameLabel.name.length >= 12 && frameLabel.name.substr(0,12) == "removemaster")
               {
                  this.mc.addFrameScript(frameLabel.frame - 1,this.onRemoveMaster);
               }
               else if(frameLabel.name.length >= 10 && frameLabel.name.substr(0,10) == "showmaster")
               {
                  this.mc.addFrameScript(frameLabel.frame - 1,this.showMaster);
               }
               else if(frameLabel.name == "backnonestop")
               {
                  this.mc.addFrameScript(frameLabel.frame - 1,this.onPlayEffectToNoneStop);
               }
               else if(frameLabel.name.substr(0,4) == "hold")
               {
                  this.mc.addFrameScript(frameLabel.frame - 1,this.onNeedHoldMC);
               }
               else if(frameLabel.frame > 1)
               {
                  this.mc.addFrameScript(frameLabel.frame - 1,this.onPlayEffectTo);
               }
            }
         }
      }
      
      public function playEffect(callback:Function = null) : void
      {
         this.opPersonCanMoveOrNot(false);
         if(callback != null)
         {
            this.playEffectCallback = callback;
         }
         if(this.mc.currentFrame == this.mc.totalFrames && this._npcData.type == 3)
         {
            this.onPlayEffectTo();
            return;
         }
         if(this.mc.currentFrame < this.mc.totalFrames)
         {
            if(this._npcData.type != this.pickupType)
            {
               this.isPlaying = true;
            }
            if(this.stateMC != null)
            {
               this.stateMC.visible = false;
            }
            if(!this.mc.hasEventListener(Event.ENTER_FRAME))
            {
               this.mc.addEventListener(Event.ENTER_FRAME,this.playEnterFrame);
            }
            this.mc.play();
         }
      }
      
      public function gotoAndPlay(index:int) : void
      {
         if(this.mc.totalFrames > 1 && this.mc.totalFrames >= index)
         {
            this.mc.gotoAndPlay(index);
         }
      }
      
      private function playEnterFrame(evt:Event) : void
      {
         evt.stopImmediatePropagation();
         if(this._npcData.getValueOfSpecifiedBit(14))
         {
            if(BitValueUtil.getBitValue(GameData.instance.playerData.taskStatus,1))
            {
               this.gotoAndPlay(1);
               return;
            }
         }
         if(this.tempState != this.npcState)
         {
            this.tempState = this.npcState;
            this.updateState(this.npcState);
         }
      }
      
      public function requestState() : void
      {
         ApplicationFacade.getInstance().dispatch(EventConst.REQUESTNPCSTATE,IdName.id(this.spriteName));
         this.initNPCByType();
      }
      
      private function onPlayEffectTo() : void
      {
         this.opPersonCanMoveOrNot(true);
         this.mc.stop();
         this.isPlaying = false;
         if(this.stateMC != null && !this.stateMC.visible)
         {
            this.stateMC.visible = true;
         }
         this.mc.removeEventListener(Event.ENTER_FRAME,this.playEnterFrame);
         this.updateState(this.npcState);
         this.initNPCByType();
         if(this.playEffectCallback != null)
         {
            this.playEffectCallback.apply(null,[this.spriteName]);
         }
         this.playEffectCallback = null;
      }
      
      private function onPlayEffectToNoneStop() : void
      {
         this.isPlaying = false;
         if(this.stateMC != null && !this.stateMC.visible)
         {
            this.stateMC.visible = true;
         }
         this.mc.removeEventListener(Event.ENTER_FRAME,this.playEnterFrame);
         this.initNPCByType();
         if(this.playEffectCallback != null)
         {
            this.playEffectCallback.apply(null,[this.spriteName]);
         }
         this.playEffectCallback = null;
      }
      
      private function onNeedHoldMC() : void
      {
         var frame:FrameLabel = null;
         this.opPersonCanMoveOrNot(true);
         this.mc.stop();
         this._needHold = true;
         var tmpArr:Array = this.mc.currentLabels;
         for each(frame in tmpArr)
         {
            if(frame.name.substr(0,4) == "hold" && frame.frame == this.mc.currentFrame)
            {
               this._startHold = int(frame.name.substring(4)) * 1000;
            }
         }
         this.initNPCByType();
      }
      
      private function onStartPlayTimer() : void
      {
         this.opPersonCanMoveOrNot(true);
         this.mc.stop();
         if(this.playTimer != null && this.playTimer.running)
         {
            return;
         }
         this.initNPCByType();
         this.playEffectCallback = null;
         var repeatcount:int = int(this.mc.currentFrameLabel.substr(5));
         this.playTimer = new Timer(1000,repeatcount);
         this.playTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onPlayTimerComplete);
         this.playTimer.start();
      }
      
      private function onPlayTimerComplete(evt:TimerEvent) : void
      {
         evt.stopImmediatePropagation();
         this.playTimer.reset();
         this.playTimer.stop();
         this.playTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onPlayTimerComplete);
         this.playTimer = null;
         this.opPersonCanMoveOrNot(false);
         this.mc.play();
      }
      
      private function onBackToFirst() : void
      {
         this.opPersonCanMoveOrNot(true);
         this.mc.stop();
         this.mc.gotoAndPlay(1);
      }
      
      public function gotoFrame(fname:String) : void
      {
         var tempaArr:Array = null;
         var frameLabel:FrameLabel = null;
         if(this.mc.totalFrames > 1)
         {
            tempaArr = this.mc.currentLabels;
            if(tempaArr == null)
            {
               return;
            }
            for each(frameLabel in tempaArr)
            {
               if(frameLabel.name == fname)
               {
                  this.mc.gotoAndStop(frameLabel.frame);
                  return;
               }
            }
         }
      }
      
      public function updateState(state:int) : void
      {
         var dest:DisplayObject = null;
         var destX:Number = NaN;
         var destY:Number = NaN;
         var uiName:String = null;
         var rect:Rectangle = null;
         var dx:Number = NaN;
         var dy:Number = NaN;
         if(this._npcData.getValueOfSpecifiedBit(4))
         {
            if(state <= 1)
            {
               if(this.stateMC != null && Sprite(this.ui).contains(this.stateMC))
               {
                  this.stateMC.stop();
                  Sprite(ui).removeChild(this.stateMC);
                  this.stateMC = null;
               }
               this.npcState = 1;
            }
            else
            {
               this.npcState = state;
            }
            if(Boolean(this.mc.hasOwnProperty("mainnpc")) && this.mc["mainnpc"] != null)
            {
               dest = this.mc["mainnpc"];
            }
            else if(Boolean(this.mc.hasOwnProperty("mouseclick")) && this.mc["mouseclick"] != null)
            {
               dest = this.mc["mouseclick"];
            }
            else if(Boolean(this.mc.hasOwnProperty("animation")) && this.mc["animation"] != null)
            {
               dest = this.mc["animation"];
            }
            if(!Boolean(dest))
            {
               if(this.stateMC != null && Sprite(ui).contains(this.stateMC))
               {
                  this.stateMC.visible = false;
                  this.stateMC.stop();
                  Sprite(ui).removeChild(this.stateMC);
                  this.stateMC = null;
               }
               if(Boolean(this.npcNameTF))
               {
                  this.npcNameTF.visible = false;
               }
               return;
            }
            destX = dest.x + dest.width / 2;
            destY = dest.y;
            if(this._npcData.getValueOfSpecifiedBit(4))
            {
               if(this.npcState > 1)
               {
                  if(state == 2)
                  {
                     uiName = "acceptState";
                  }
                  else
                  {
                     uiName = "completeState";
                  }
                  if(this.stateMC == null)
                  {
                     this.stateMC = MaterialLib.getInstance().getMaterial(uiName) as MovieClip;
                  }
                  else if(this.stateMC.name != uiName)
                  {
                     if(Sprite(ui).contains(this.stateMC))
                     {
                        Sprite(ui).removeChild(this.stateMC);
                     }
                     this.stateMC = MaterialLib.getInstance().getMaterial(uiName) as MovieClip;
                  }
                  Sprite(ui).addChild(this.stateMC);
                  this.stateMC.play();
                  rect = this.stateMC.getRect(this.stateMC);
                  this.stateMC.x = destX - (rect.right - rect.left) / 2;
                  this.stateMC.y = destY - rect.bottom / 2 - 20;
                  this.stateMC.visible = true;
               }
               else if(this.stateMC != null && Sprite(this.ui).contains(this.stateMC))
               {
                  this.stateMC.stop();
                  Sprite(ui).removeChild(this.stateMC);
                  this.stateMC = null;
               }
            }
         }
         if(this._npcData.getValueOfSpecifiedBit(3))
         {
            this.npcNameTF.visible = true;
            dx = this.npcNameTF.x - destX + this.npcNameTF.width / 2;
            dy = this.npcNameTF.y - destY + 20;
            if(Math.sqrt(dx * dx + dy * dy) < 10)
            {
               return;
            }
            this.npcNameTF.x -= dx;
            this.npcNameTF.y -= dy;
         }
      }
      
      private function onAddToStage(evt:Event) : void
      {
         var time:int = 0;
         evt.stopImmediatePropagation();
         this.mc.removeEventListener(Event.ADDED_TO_STAGE,this.onAddToStage);
         if(this.sequenceID != 401405 && !this._npcData.getValueOfSpecifiedBit(15))
         {
            this.mc.addEventListener(MouseEvent.ROLL_OVER,this.onMouseRollOver);
         }
         this.parseTalkList();
         if(this.mouseoverDia != null && this.sequenceID != 21210)
         {
            this.msgTxt = new TextArea(115,20);
            this.msgTxt.mouseEnabled = false;
            this.addChild(this.msgTxt);
            time = this.sequenceID % 5;
            time = 3 * time * 1000 - 2000;
            time = time > 0 ? time : 1000;
            this.sid = setTimeout(this.startTimer,time);
         }
         this.initEvents();
         this.initNPCByType();
         this.playEffect(null);
         if(this._npcData.getValueOfSpecifiedBit(6))
         {
            if(this.mc.hasOwnProperty("mouseclick"))
            {
               ToolTip.BindDO(this.mc["mouseclick"],this._npcData.name);
            }
            else if(this.mc.hasOwnProperty("animation"))
            {
               ToolTip.BindDO(this.mc["animation"],this._npcData.name);
            }
         }
      }
      
      private function startTimer() : void
      {
         clearTimeout(this.sid);
         this.sid = 0;
         this.autoSaySomething(null);
         this.timer = new Timer(10000);
         this.timer.addEventListener(TimerEvent.TIMER,this.autoSaySomething);
         this.timer.start();
      }
      
      private function addChild(display:DisplayObject) : void
      {
         Sprite(this.ui).addChild(display);
         try
         {
            display.name = spriteName;
         }
         catch(e:*)
         {
            trace("【设置NPC名字失败...addChild】");
         }
      }
      
      private function initNPCByType() : void
      {
         if(this._npcData.type == this.loopType)
         {
            this.mc.buttonMode = true;
            if(!this.mc.hasEventListener(Event.ENTER_FRAME))
            {
               this.mc.addEventListener(Event.ENTER_FRAME,this.playEnterFrame);
            }
            ApplicationFacade.getInstance().dispatch(EventConst.REQUESTNPCSTATE,IdName.id(this.spriteName));
         }
         if(Boolean(this.mc.hasOwnProperty("actionshoot")) && this.mc["actionshoot"] != null)
         {
            if(!this.mc["actionshoot"].hasEventListener(MouseEvent.MOUSE_DOWN))
            {
               this.mc["actionshoot"].addEventListener(MouseEvent.MOUSE_DOWN,this.onActionMouseClick);
            }
            if(Boolean(this.mc["actionshoot"].hasEventListener(Event.REMOVED_FROM_STAGE)))
            {
               this.mc["actionshoot"].addEventListener(Event.REMOVED_FROM_STAGE,this.removeClipEvent);
            }
            if(this.sequenceID == 81304)
            {
               ToolTip.BindDO(this.mc["actionshoot"],"这里有块石头很奇怪，用粒子光线射一下看看吧！");
            }
            else if(this.sequenceID == 61406)
            {
               ToolTip.BindDO(this.mc["actionshoot"],"使用粒子光线可以唤出傲天!");
            }
            else if(this.sequenceID == 301605)
            {
               ToolTip.BindDO(this.mc["actionshoot"],"奇怪的橄榄枝，试着烧毁它看看!");
            }
            else if(this.sequenceID == 71118)
            {
               ToolTip.BindDO(this.mc["actionshoot"],"用粒子光线射击这里可以获得紫藤");
            }
            else if(this.sequenceID == 71119 || this.sequenceID == 71120 || this.sequenceID == 71121)
            {
               ToolTip.BindDO(this.mc["actionshoot"],"使用粒子光线射击试试看。");
            }
            else if(this.sequenceID == 401407)
            {
               ToolTip.BindDO(this.mc["actionshoot"],"这里的黑雾很诡异，莫非与宝镜有关，用扫描电波扫描一下看看吧！");
            }
            else if(this.sequenceID == 220917)
            {
               ToolTip.BindDO(this.mc["actionshoot"],"使用魔晶射线帮助悟空脱困！");
            }
            else if(this.sequenceID == 221108)
            {
               ToolTip.BindDO(this.mc["actionshoot"],"使用魔晶射线帮助沙僧脱困！");
            }
         }
         if(Boolean(this.mc.hasOwnProperty("mouseclick")) && this.mc["mouseclick"] != null)
         {
            if(Boolean(this.mc["mouseclick"].hasOwnProperty("buttonMode")))
            {
               this.mc["mouseclick"].buttonMode = true;
            }
            if(!this.mc["mouseclick"].hasEventListener(MouseEvent.MOUSE_DOWN))
            {
               this.mc["mouseclick"].addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseClick);
            }
            if(Boolean(this.mc["mouseclick"].hasEventListener(Event.REMOVED_FROM_STAGE)))
            {
               this.mc["mouseclick"].addEventListener(Event.REMOVED_FROM_STAGE,this.removeClipEvent);
            }
            if(this.sequenceID == 31603)
            {
               ToolTip.BindDO(this.mc["mouseclick"],"每天13：00到14：00，19：00到20：00，不见不散！");
            }
         }
         if(Boolean(this.mc.hasOwnProperty("animation")) && this.mc["animation"] != null)
         {
            if(Boolean(this.mc["animation"].hasOwnProperty("buttonMode")))
            {
               this.mc["animation"].buttonMode = true;
            }
            if(this.sequenceID == 501104)
            {
               if(this.mc.currentFrameLabel == "first")
               {
                  ToolTip.BindDO(this.mc["animation"],"晶莹剔透的水晶，光线的照耀下绚丽多姿，似乎可以转动");
               }
               else if(this.mc.currentFrameLabel == "second")
               {
                  ToolTip.BindDO(this.mc["animation"],"插入地面的金属棍，\n好像堵住了什么");
               }
            }
            if(this.sequenceID == 161610)
            {
               if(Boolean(this.mc.hasOwnProperty("tipMc")) && this.mc["tipMc"] != null)
               {
                  this.mc["tipMc"].gotoAndStop(1);
               }
            }
            this.mc["animation"].addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseClickAnimation);
            if(Boolean(this.mc["animation"].hasEventListener(Event.REMOVED_FROM_STAGE)))
            {
               this.mc["animation"].addEventListener(Event.REMOVED_FROM_STAGE,this.removeClipEvent);
            }
         }
      }
      
      private function removeClipEvent(evt:Event) : void
      {
         evt.stopImmediatePropagation();
         this.removeEventWhenPlay();
         if(this.sequenceID == 501104 && this.mc["animation"] != null || (this.sequenceID == 83104 || this.sequenceID == 61406 || this.sequenceID == 301605 || this.sequenceID == 71118 || this.sequenceID == 71119 || this.sequenceID == 71120 || this.sequenceID == 71121 || this.sequenceID == 401407 || this.sequenceID == 220917 || this.sequenceID == 221108) && this.mc["actionshoot"] != null || this.sequenceID == 31603 && this.mc["mouseclic"] != null)
         {
            ToolTip.LooseDO(this.mc["actionshoot"]);
         }
      }
      
      private function removeEventWhenPlay() : void
      {
         if(this.mc == null)
         {
            return;
         }
         if(Boolean(this.mc.hasOwnProperty("actionshoot")) && this.mc["actionshoot"] != null)
         {
            this.mc["actionshoot"].removeEventListener(MouseEvent.MOUSE_DOWN,this.onActionMouseClick);
         }
         if(Boolean(this.mc.hasOwnProperty("mouseclick")) && this.mc["mouseclick"] != null)
         {
            if(Boolean(this.mc["mouseclick"].hasOwnProperty("buttonMode")))
            {
               this.mc["mouseclick"].buttonMode = false;
            }
            this.mc["mouseclick"].removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseClick);
         }
         if(Boolean(this.mc.hasOwnProperty("animation")) && this.mc["animation"] != null)
         {
            if(Boolean(this.mc["animation"].hasOwnProperty("buttonMode")))
            {
               this.mc["animation"].buttonMode = false;
            }
            this.mc["animation"].removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseClickAnimation);
         }
      }
      
      private function onActionMouseClick(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         GameDynamicUI.removeUI("jiantou");
         this.master = MapView.instance.masterPerson;
         this.currentCursorName = MouseManager.getInstance().cursorName;
         if(this.currentCursorName != "")
         {
            if(this.sequenceID == 81304 || this.sequenceID == 61406 || sequenceID == 301605 || sequenceID == 71118 || this.sequenceID == 71119 || this.sequenceID == 71120 || this.sequenceID == 71121 || this.sequenceID == 401407 || this.sequenceID == 220917)
            {
               if(Boolean(this.mc) && Boolean(this.mc.hasOwnProperty("actionshoot")))
               {
                  ToolTip.LooseDO(this.mc["actionshoot"]);
               }
            }
         }
         if(this.currentCursorName.substring(0,12) == "CursorTool20")
         {
            this.actionFlag = true;
            if(!TaskUtils.getInstance().hasEventListener(TaskEvent.OP_MOUSE_ACTION_AI))
            {
               TaskUtils.getInstance().addEventListener(TaskEvent.OP_MOUSE_ACTION_AI,this.onUseAction);
            }
            this.sendAction(this.currentCursorName,evt.stageX,evt.stageY);
         }
         else if(this.currentCursorName.substr(0,9) == "packmouse")
         {
            MouseManager.getInstance().setCursor("");
            this.actionFlag = true;
            this.onUseAction(null);
         }
      }
      
      public function sendAction(str:String, destx:Number, desty:Number) : void
      {
         var params:Object = {};
         params.actionid = int(str.slice(13,str.length));
         var tmpP:Point = this.parseGlobalToLocal(destx,desty);
         params.destx = tmpP.x;
         params.desty = tmpP.y;
         ApplicationFacade.getInstance().dispatch(EventConst.SENDACTION,params);
         MouseManager.getInstance().setCursor("");
      }
      
      private function onMouseClick(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         if(MouseManager.getInstance().cursorName.substring(0,12) == "CursorTool20")
         {
            if(MouseManager.getInstance().cursorName == "CursorTool2003")
            {
               this.onActionMouseClick(evt);
            }
            else
            {
               this.sendAction(MouseManager.getInstance().cursorName,evt.stageX,evt.stageY);
            }
            return;
         }
         if(this.checkMouseCursor(MouseManager.getInstance().cursorName))
         {
            MouseManager.getInstance().setCursor("");
            return;
         }
         if(this._needHold)
         {
            this._holdSid = setTimeout(this.onHoldComplete,this._startHold);
            if(Boolean(this.mc) && Boolean(this.mc.stage))
            {
               this.mc.stage.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUpHoldMC);
            }
            return;
         }
         if(this._npcData.type == this.pickupType && !this._npcData.getValueOfSpecifiedBit(1))
         {
            this.operateOnSendClick();
            this.disposByFlag(true);
            return;
         }
         if(this._npcData.getValueOfSpecifiedBit(6) && Boolean(this.mc.hasOwnProperty("mouseclick")))
         {
            ToolTip.LooseDO(this.mc["mouseclick"]);
         }
         if(!this._npcData.getValueOfSpecifiedBit(1))
         {
            if(this._npcData.getValueOfSpecifiedBit(2))
            {
               this.isClick = true;
               this.playEffect(this.onFrameNameFunc);
               return;
            }
            this.isClick = true;
            this.onFrameNameFunc();
            return;
         }
         this.master = MapView.instance.masterPerson;
         if(this._npcData.getValueOfSpecifiedBit(9))
         {
            this.gotoSpecifiedPlaceAndClick();
            return;
         }
         this.tempParams = {};
         this.tempParams.id = IdName.id(this.spriteName);
         this.tempParams.x = this.x + this.mc["mouseclick"].x + this.mc["mouseclick"].width / 2 + 5;
         this.tempParams.y = this.y + this.mc["mouseclick"].y + this.mc["mouseclick"].height + 5;
         this.startToMove(this.checkNpc,null);
      }
      
      private function startToMove(checkFun:Function, onArrival:Function = null) : void
      {
         if(checkFun != null)
         {
            MapView.instance.addTimerListener(this.checkNpc);
         }
         var targetPoint:Point = this.parseLocalToGlobal(this.tempParams.x,this.tempParams.y);
         if(targetPoint.x > 60 && targetPoint.x < 910 && targetPoint.y > 60 && targetPoint.y < 510)
         {
            this.master.moveto(targetPoint.x,targetPoint.y,onArrival);
            ApplicationFacade.getInstance().dispatch(EventConst.ROLEMOVE,{
               "newx":targetPoint.x,
               "newy":targetPoint.y,
               "path":null
            });
         }
         else
         {
            this.autoClickMe();
         }
      }
      
      private function gotoSpecifiedPlaceAndClick() : void
      {
         var tmpPoint:Point = null;
         this.master = MapView.instance.masterPerson;
         if(this.sequenceID == 21922)
         {
            tmpPoint = this.parseLocalToGlobal(446,798);
         }
         else if(this.sequenceID == 91304 && GamePersonControl.instance.isFlyIngHorse(GameData.instance.playerData.horseID))
         {
            tmpPoint = this.parseLocalToGlobal(this._npcData.targetx,this._npcData.targety - 185);
         }
         else
         {
            tmpPoint = this.parseLocalToGlobal(this._npcData.targetx,this._npcData.targety);
         }
         if(tmpPoint.x > 60 && tmpPoint.x < 910 && tmpPoint.y > 60 && tmpPoint.y < 510)
         {
            this.master.moveto(tmpPoint.x,tmpPoint.y,this.autoClickMe);
         }
         else
         {
            this.autoClickMe();
         }
      }
      
      private function onMouseClickAnimation(evt:MouseEvent) : void
      {
         var obj:Object = null;
         evt.stopImmediatePropagation();
         if(this.isPlaying)
         {
            return;
         }
         if(MouseManager.getInstance().cursorName.substring(0,12) == "CursorTool20")
         {
            this.sendAction(MouseManager.getInstance().cursorName,evt.stageX,evt.stageY);
            return;
         }
         if(this.checkMouseCursor(MouseManager.getInstance().cursorName))
         {
            MouseManager.getInstance().setCursor("");
            return;
         }
         if(MouseManager.getInstance().cursorName.substr(0,3) == "npc")
         {
            MouseManager.getInstance().setCursor("");
         }
         if(Boolean(this.mc.hasOwnProperty("animation")) && this.mc["animation"] != null)
         {
            if(this.sequenceID == 501103 || this._npcData.getValueOfSpecifiedBit(6))
            {
               ToolTip.LooseDO(this.mc["animation"]);
            }
         }
         this.master = MapView.instance.masterPerson;
         for each(obj in this.animationPosList)
         {
            if(obj.id == this.sequenceID)
            {
               this.tempParams = {};
               this.tempParams.x = obj.xCoord;
               this.tempParams.y = obj.yCoord;
               this.startToMove(null,this.playEffect);
               return;
            }
         }
         if(this.mc.currentFrame < this.mc.totalFrames)
         {
            this.playEffect(null);
         }
      }
      
      public function onUseAction(evt:TaskEvent) : void
      {
         var scriptFrames:int = 0;
         if(this.actionFlag)
         {
            TaskUtils.getInstance().removeEventListener(TaskEvent.OP_MOUSE_ACTION_AI,this.onUseAction);
            if(this.currentCursorName == "CursorTool2003" && this._npcData.watchURL != "null")
            {
               ApplicationFacade.getInstance().dispatch(EventConst.STARTTOPLAYANIMATION,{
                  "npcid":0,
                  "x":0,
                  "y":0,
                  "effectName":"",
                  "url":this._npcData.watchURL + ".swf",
                  "targetFunction":null,
                  "type":0
               });
               ApplicationFacade.getInstance().dispatch(EventConst.SENDXIYOUPERSON,this.sequenceID);
               return;
            }
            if(this.currentCursorName.substr(0,12) == "CursorTool20" && int(this.currentCursorName.substring(12)) != this._npcData.special || this.currentCursorName.substr(0,9) == "packmouse" && int(this.currentCursorName.substring(9)) != this._npcData.special)
            {
               return;
            }
            this.mc["actionshoot"].play();
            scriptFrames = 1;
            if(this.mc.totalFrames > 1)
            {
               if(this.mc.currentLabels == null || this.mc.currentLabels.length == 0 || (this.mc.currentLabels[this.mc.currentLabels.length - 1] as FrameLabel).frame != this.mc.totalFrames)
               {
                  scriptFrames = this.mc.totalFrames - 1;
                  this.mc.addFrameScript(scriptFrames,this.onFrameNameFunc);
               }
            }
            this.playEffect(this.onFrameNameFunc);
         }
      }
      
      private function onFrameNameFunc(spName:String = "") : void
      {
         if(this.mc.currentFrame == this.mc.totalFrames && this.mc.totalFrames > 1)
         {
            if(this.mc.currentLabels == null || this.mc.currentLabels.length == 0)
            {
               this.mc.addFrameScript(this.mc.totalFrames - 1,null);
            }
         }
         this.opPersonCanMoveOrNot(true);
         this.mc.stop();
         if(this.isClick || this.actionFlag)
         {
            this.operateOnSendClick();
         }
         this.actionFlag = false;
         this.isClick = false;
      }
      
      private function removeChild(display:MovieClip, needPlayRemoveCG:Boolean = false) : void
      {
         if(needPlayRemoveCG && display.currentFrame < display.totalFrames)
         {
            this.tempDis = display;
            display.addFrameScript(display.totalFrames - 1,this.remove);
            display.nextFrame();
            display.play();
         }
         else
         {
            this.remove(display);
         }
      }
      
      private function remove(display:MovieClip = null) : void
      {
         if(display != null)
         {
            display.stop();
            Sprite(this.ui).removeChild(display);
         }
         else if(this.tempDis != null)
         {
            this.tempDis.stop();
            this.tempDis.addFrameScript(this.tempDis.totalFrames - 1,null);
            Sprite(this.ui).removeChild(this.tempDis);
            this.tempDis = null;
         }
      }
      
      private function checkNpc() : void
      {
         var targ:DisplayObject = null;
         var dx:Number = this.tempParams.x - this.master.x;
         var dy:Number = this.tempParams.y - this.master.y;
         var radius:Number = Math.sqrt(dx * dx + dy * dy);
         if(radius < 60)
         {
            this.master.stop();
            MapView.instance.removeTimerListener(this.checkNpc);
            ApplicationFacade.getInstance().dispatch(EventConst.ROLEMOVE,{
               "newx":this.master.x,
               "newy":this.master.y,
               "path":null
            });
            if(this.sequenceID == 401405)
            {
               ApplicationFacade.getInstance().dispatch(EventConst.SENDUSERTOOTHERSCENE,40005);
               return;
            }
            if(this._npcData.type != this.loopType)
            {
               if(!this.isPlaying)
               {
                  if(this.mc.currentFrame < this.mc.totalFrames && this._npcData.getValueOfSpecifiedBit(2))
                  {
                     this.isClick = true;
                     this.playEffect(this.onFrameNameFunc);
                  }
                  else
                  {
                     this.operateOnSendClick();
                  }
               }
            }
            else
            {
               this.operateOnSendClick();
               if(this._npcData.type == this.pickupType)
               {
                  this.disposByFlag(true);
               }
            }
            if(this._npcData.getValueOfSpecifiedBit(5))
            {
               this.disposByFlag(true);
            }
         }
      }
      
      override public function get sortY() : Number
      {
         var dis:DisplayObject = null;
         var rect:Rectangle = null;
         var desty:Number = NaN;
         if(this.mc == null || this._npcData.getValueOfSpecifiedBit(7))
         {
            return 0;
         }
         if(Boolean(this.mc.hasOwnProperty("mainnpc")) && this.mc["mainnpc"] != null)
         {
            dis = this.mc["mainnpc"];
         }
         else if(Boolean(this.mc.hasOwnProperty("mouseclick")) && this.mc["mouseclick"] != null)
         {
            dis = this.mc["mouseclick"];
         }
         else if(Boolean(this.mc.hasOwnProperty("actionshoot")) && this.mc["actionshoot"] != null)
         {
            dis = this.mc["actionshoot"];
         }
         else if(Boolean(this.mc.hasOwnProperty("animation")) && this.mc["animation"] != null)
         {
            dis = this.mc["animation"];
         }
         if(dis != null)
         {
            rect = dis.getRect(this.mc);
         }
         else
         {
            rect = this.mc.getRect(this.mc);
         }
         desty = rect.bottom;
         return this.y + desty - this._npcData.dymaicY;
      }
      
      public function needMeSaySomething(str:String, ... rest) : void
      {
         if(this.msgTxt != null)
         {
            this.msgTxt.clear();
         }
         else
         {
            this.msgTxt = new TextArea(115,20);
         }
         Sprite(ui).addChild(this.msgTxt);
         this.msgTxt.text = str;
         if(rest != null && rest.length > 0)
         {
            this.msgForNext = rest[0];
            this.tid = setTimeout(this.notifyNext,5000);
         }
      }
      
      private function notifyNext() : void
      {
         clearTimeout(this.tid);
         this.tid = 0;
         ApplicationFacade.getInstance().dispatch(EventConst.NONSENSE_NPC_SAY_SOMETHING,this.msgForNext);
      }
      
      private function autoSaySomething(evt:TimerEvent) : void
      {
         if(this.mouseoverDia == null || this.msgTxt == null)
         {
            return;
         }
         var diaid:int = this.mouseoverflag % this.mouseoverDia.children().length();
         ++this.mouseoverflag;
         this.needMeSaySomething((this.mouseoverDia.children()[diaid] as XML).toString());
      }
      
      public function autoClickMe() : void
      {
         this.operateOnSendClick();
         if(this._npcData.type == this.pickupType)
         {
            this.disposByFlag(true);
         }
      }
      
      private function stopAndClickMe() : void
      {
         this.autoClickMe();
         if(this._npcData.type != this.pickupType && !this._npcData.getValueOfSpecifiedBit(5))
         {
            this.onPlayEffectTo();
         }
      }
      
      private function onMouseRollOver(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         this.mc.filters = [new GlowFilter(16777215,1,10,10,2,1,false,false)];
         this.mc.addEventListener(MouseEvent.ROLL_OUT,this.onMouseRollOut);
         if(sequenceID == 81105)
         {
            if(this.mc.currentFrameLabel.substr(0,9) == "autoclick")
            {
               if(Boolean(this.mc.hasOwnProperty("animation")) && this.mc["animation"] != null)
               {
                  MouseManager.getInstance().setCursor("npc" + sequenceID);
               }
            }
         }
         if(this.sequenceID == 161610)
         {
            if(Boolean(this.mc.hasOwnProperty("tipMc")) && this.mc["tipMc"] != null)
            {
               this.mc["tipMc"].gotoAndStop(2);
            }
         }
         if(this.sequenceID > 191502 && this.sequenceID < 191515)
         {
            if(Boolean(this.mc.hasOwnProperty("tipMc")) && this.mc["tipMc"] != null)
            {
               this.mc["tipMc"].gotoAndStop(2);
            }
         }
      }
      
      private function onMouseRollOut(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         this.mc.removeEventListener(MouseEvent.ROLL_OUT,this.onMouseRollOut);
         this.mc.filters = null;
         if(this.sequenceID == 161610)
         {
            if(Boolean(this.mc.hasOwnProperty("tipMc")) && this.mc["tipMc"] != null)
            {
               this.mc["tipMc"].gotoAndStop(1);
            }
         }
         if(this.sequenceID > 191502 && this.sequenceID < 191515)
         {
            if(Boolean(this.mc.hasOwnProperty("tipMc")) && this.mc["tipMc"] != null)
            {
               this.mc["tipMc"].gotoAndStop(1);
            }
         }
      }
      
      private function onPushMasterBack() : void
      {
         this.master = MapView.instance.masterPerson;
         if(this.sequenceID == 21922)
         {
            this.master.easeMoveTo(881,828);
         }
         else
         {
            GameSpriteAction.instance.smashedOut(this.master,this.master.x - 200,this.master.y + 200,1);
            this.stopAndClickMe();
         }
      }
      
      private function onPushBack() : void
      {
      }
      
      private function onRemoveMaster() : void
      {
         ApplicationFacade.getInstance().dispatch(EventConst.HIDE_GAMEPERSON,{"type":1});
      }
      
      private function showMaster() : void
      {
         ApplicationFacade.getInstance().dispatch(EventConst.HIDE_GAMEPERSON,{"type":2});
      }
      
      private function checkMouseCursor(cursorName:String) : Boolean
      {
         if(cursorName.substr(0,12) == "CursorTool20" || cursorName.substr(0,9) == "packmouse")
         {
            return true;
         }
         return false;
      }
      
      private function opPersonCanMoveOrNot(canmove:Boolean) : void
      {
         if(this._npcData.getValueOfSpecifiedBit(8))
         {
            ApplicationFacade.getInstance().dispatch(EventConst.PERSON_CAN_OR_NOT_MOVE,!canmove);
         }
         if(!canmove && MapView.instance.masterPerson != null)
         {
            MapView.instance.masterPerson.stop();
         }
      }
      
      private function parseLocalToGlobal(xCoord:Number, yCoord:Number) : Point
      {
         var master:GamePerson = MapView.instance.masterPerson;
         return master.ui.parent.localToGlobal(new Point(xCoord,yCoord));
      }
      
      private function parseGlobalToLocal(xCoord:Number, yCoord:Number) : Point
      {
         var master:GamePerson = MapView.instance.masterPerson;
         return master.ui.parent.globalToLocal(new Point(xCoord,yCoord));
      }
      
      public function releaseEvents() : void
      {
         var tempArr:Array = null;
         var i:int = 0;
         var len:int = 0;
         var frameLabel:FrameLabel = null;
         if(this.mc.totalFrames > 1)
         {
            tempArr = this.mc.currentLabels;
            if(tempArr == null)
            {
               return;
            }
            i = 0;
            len = int(tempArr.length);
            for each(frameLabel in tempArr)
            {
               this.mc.addFrameScript(frameLabel.frame - 1,null);
            }
         }
      }
      
      private function disposByFlag(flag:Boolean = false) : void
      {
         if(Boolean(this.ui) && Sprite(this.ui).contains(this.mc))
         {
            this.removeChild(this.mc,flag);
         }
         this.dispos();
      }
      
      private function operateOnSendClick() : void
      {
         trace("点击NPC... " + this.sequenceID);
         if(this._npcData.getValueOfSpecifiedBit(11))
         {
            if(this.sequenceID == 91304)
            {
               if(!GamePersonControl.instance.isFlyIngHorse(GameData.instance.playerData.horseID))
               {
                  new Alert().show("太高了，够不着!~");
                  return;
               }
               ApplicationFacade.getInstance().dispatch(EventConst.ONCLICKNPC,{
                  "id":this.sequenceID,
                  "type":this._npcData.type
               });
            }
            else if(this.sequenceID == 31606)
            {
               if(TaskList.getInstance().getStateOfSpecifiedTask(3058000) != 1)
               {
                  return;
               }
               MouseManager.getInstance().setCursor("taskCursor3058001");
            }
            else if(sequenceID == 71701)
            {
               ApplicationFacade.getInstance().dispatch(EventConst.ONGETDIALOGBACK,{
                  "type":1,
                  "npcid":71701,
                  "itemCount":0,
                  "dialogId":40
               });
            }
            else if(sequenceID >= 10030 && sequenceID <= 10035)
            {
               ApplicationFacade.getInstance().dispatch(EventConst.SEND_SIGNAL_OF_ACTIVITY_AI,sequenceID);
            }
         }
         else
         {
            ApplicationFacade.getInstance().dispatch(EventConst.ONCLICKNPC,{
               "id":this.sequenceID,
               "type":this._npcData.type
            });
         }
         if(this._npcData.getValueOfSpecifiedBit(5))
         {
            this.disposByFlag(true);
         }
         if(this.sequenceID == 13001 || this.sequenceID == 12005 || this.sequenceID == 61403 || this.sequenceID == 101303 || this.sequenceID == 21515)
         {
            if(this.sequenceID == 12005)
            {
               ApplicationFacade.getInstance().dispatch(EventConst.REQ_RECALL_TRUMP,1);
            }
            GameDynamicUI.removeUI("taskGuide");
         }
      }
      
      override public function dispos() : void
      {
         this.onMouseUpHoldMC(null);
         if(Boolean(this.loader))
         {
            this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoadComplete);
            this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
            this.loader.unloadAndStop();
            this.loader = null;
         }
         if(this.mc != null && this.ui != null && Sprite(ui).contains(this.mc))
         {
            if(this._npcData.getValueOfSpecifiedBit(6) && Boolean(this.mc["mouseclick"]))
            {
               ToolTip.LooseDO(this.mc["mouseclick"]);
            }
            this.remove(this.mc);
            this.mc.removeEventListener(Event.ENTER_FRAME,this.playEnterFrame);
            if(this.mc.hasEventListener(MouseEvent.ROLL_OVER))
            {
               this.mc.removeEventListener(MouseEvent.ROLL_OVER,this.onMouseRollOver);
            }
            this.releaseEvents();
         }
         this.removeEventWhenPlay();
         MapView.instance.removeTimerListener(this.checkNpc);
         if(this.msgTxt != null)
         {
            this.msgTxt.clear();
            if(Boolean(this.ui) && Sprite(ui).contains(this.msgTxt))
            {
               Sprite(ui).removeChild(this.msgTxt);
            }
            this.msgTxt = null;
         }
         if(this.mouseoverDia != null)
         {
            this.mouseoverDia = null;
         }
         this.mouseoverflag = 0;
         if(this.tid != 0)
         {
            clearTimeout(this.tid);
         }
         this.tid = 0;
         this.msgForNext = null;
         if(this.timer != null)
         {
            this.timer.stop();
            this.timer.removeEventListener(TimerEvent.TIMER,this.autoSaySomething);
            this.timer = null;
         }
         if(this.sid != 0)
         {
            clearTimeout(this.sid);
         }
         this.sid = 0;
         if(this.playTimer != null)
         {
            this.playTimer.reset();
            this.playTimer.stop();
            this.playTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onPlayTimerComplete);
            this.playTimer = null;
         }
         super.dispos();
      }
      
      private function onHoldComplete() : void
      {
         clearTimeout(this._holdSid);
         this._needHold = false;
         this._startHold = 0;
         this._holdSid = 0;
         this.playEffect();
      }
      
      private function onMouseUpHoldMC(evt:MouseEvent) : void
      {
         if(this._holdSid != 0)
         {
            clearTimeout(this._holdSid);
            this._holdSid = 0;
         }
         if(Boolean(this.mc) && Boolean(this.mc.stage))
         {
            this.mc.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUpHoldMC);
         }
      }
      
      public function parseTalkList() : void
      {
         this.mouseoverDia = TaskInfoXMLParser.instance.getTalkMsgBySequenceID(sequenceID);
      }
   }
}

