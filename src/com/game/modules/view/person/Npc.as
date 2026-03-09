package com.game.modules.view.person
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.manager.MouseManager;
   import com.game.modules.control.task.TaskEvent;
   import com.game.modules.control.task.util.TaskUtils;
   import com.game.modules.view.MapView;
   import com.game.util.IdName;
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.loading.MaterialLib;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import org.engine.core.GameSprite;
   
   public class Npc extends GameSprite
   {
      
      private var npcClip:MovieClip;
      
      private var stateClip:MovieClip;
      
      private var functionClip:MovieClip;
      
      private var loader:Loader;
      
      private var clickHandler:Function;
      
      public var special:int;
      
      public var istask:int;
      
      public var enname:String;
      
      public var mapid:int;
      
      public var _url:String;
      
      public var steerX:Number;
      
      public var steerY:Number;
      
      private var master:GamePerson;
      
      private var tempParams:Object;
      
      private var _watchURL:String;
      
      private var watchFlag:Boolean;
      
      public function Npc(param:Object)
      {
         this.x = param.x;
         this.y = param.y;
         this.special = param.special;
         this.enname = param.enname;
         this.istask = param.istask;
         this._watchURL = param.watchURL;
         this.spriteName = IdName.npc(param.sequenceID);
         this.mapid = param.mapid;
         this._url = param.url + ".swf";
         super();
         ui = new Sprite();
         Sprite(ui).cacheAsBitmap = true;
         this.init();
      }
      
      public function update(param:Object) : void
      {
         try
         {
            if(param.hasOwnProperty("x"))
            {
               this.x = param.x;
            }
            if(param.hasOwnProperty("y"))
            {
               this.y = param.y;
            }
            if(param.hasOwnProperty("state"))
            {
               this.changeNPCState(param.state);
            }
         }
         catch(e:*)
         {
            trace("NPC -- > update");
         }
      }
      
      override public function get sortY() : Number
      {
         var sortHeight:Number = NaN;
         if(this.functionClip != null)
         {
            sortHeight = y + ui.height - 65;
         }
         else if(this.stateClip != null)
         {
            if(this.stateClip.currentFrame > 1)
            {
               sortHeight = y + ui.height - 55;
            }
            else
            {
               sortHeight = y + ui.height - 18;
            }
         }
         return sortHeight;
      }
      
      private function addChild(disPlay:DisplayObject) : void
      {
         Sprite(ui).addChild(disPlay);
         disPlay.name = this.spriteName;
      }
      
      private function removeChild(disPlay:MovieClip) : void
      {
         if(Sprite(ui).contains(disPlay))
         {
            Sprite(ui).removeChild(disPlay);
            disPlay.stop();
            disPlay = null;
         }
      }
      
      override public function dispos() : void
      {
         this.loader.unloadAndStop();
         MapView.instance.removeTimerListener(this.checkNpc);
         if(this.npcClip != null)
         {
            this.npcClip.removeEventListener(MouseEvent.MOUSE_DOWN,this.onClickNpc);
            this.npcClip.removeEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
            this.npcClip.removeEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
            this.removeChild(this.npcClip);
         }
         if(this.stateClip != null)
         {
            this.removeChild(this.stateClip);
         }
         if(this.functionClip != null)
         {
            this.removeChild(this.functionClip);
         }
         super.dispos();
      }
      
      private function init() : void
      {
         this.loader = new Loader();
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoadComplement);
      }
      
      public function load(clickHandler:Function = null) : void
      {
         try
         {
            this.clickHandler = clickHandler;
            this.loader.load(new URLRequest(URLUtil.getSvnVer(this._url)));
         }
         catch(e:*)
         {
         }
      }
      
      private function onLoadComplement(evt:Event) : void
      {
         this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoadComplement);
         var domain:ApplicationDomain = evt.currentTarget.applicationDomain as ApplicationDomain;
         var cls:Class = domain.getDefinition("npc") as Class;
         this.npcClip = new cls() as MovieClip;
         if(this.npcClip != null)
         {
            this.npcClip.gotoAndStop(1);
            this.npcClip.addEventListener(MouseEvent.MOUSE_DOWN,this.onClickNpc);
            this.npcClip.addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
            this.npcClip.addEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
            this.addChild(this.npcClip);
            if(this.istask == 1)
            {
               this.addTaskState();
            }
            if(IdName.id(this.spriteName) == 80002)
            {
               this.addFunctionClip("weizhenclip");
            }
            if(IdName.id(this.spriteName) == 80005)
            {
               this.addFunctionClip("jingheclip");
            }
            ApplicationFacade.getInstance().dispatch(EventConst.REQUESTNPCSTATE,IdName.id(this.spriteName));
         }
      }
      
      private function addTaskState() : void
      {
         this.stateClip = MaterialLib.getInstance().getMaterial("npcstate") as MovieClip;
         this.stateClip.x = this.npcClip.getChildAt(0).width / 2;
         this.stateClip.y = this.npcClip.y - 15;
         this.stateClip.stop();
         this.addChild(this.stateClip);
      }
      
      private function addFunctionClip(stlFlag:String) : void
      {
         this.functionClip = MaterialLib.getInstance().getMaterial(stlFlag) as MovieClip;
         if(this.functionClip != null)
         {
            this.functionClip.visible = false;
            this.functionClip.y = -80;
            this.functionClip.x = 40;
            this.addChild(this.functionClip);
         }
      }
      
      public function changeNPCState(npcState:int) : void
      {
         if(this.stateClip != null)
         {
            if(this.stateClip.totalFrames >= npcState)
            {
               this.stateClip.gotoAndStop(npcState);
            }
         }
      }
      
      public function getNPCState() : int
      {
         if(this.stateClip != null)
         {
            return this.stateClip.currentFrame;
         }
         return 1;
      }
      
      private function onClickNpc(evt:MouseEvent) : void
      {
         var params:Object = {};
         this.master = MapView.instance.masterPerson;
         evt.stopImmediatePropagation();
         if(MouseManager.getInstance().cursorName.substr(0,12) == "CursorTool20")
         {
            if(MouseManager.getInstance().cursorName == "CursorTool2003" && this._watchURL != "" && this._watchURL.length > 0 && this._watchURL != "null")
            {
               if(!TaskUtils.getInstance().hasEventListener(TaskEvent.OP_MOUSE_ACTION_AI))
               {
                  this.watchFlag = true;
                  TaskUtils.getInstance().addEventListener(TaskEvent.OP_MOUSE_ACTION_AI,this.onUseWatch);
               }
            }
            params.actionid = int(MouseManager.getInstance().cursorName.slice(13,MouseManager.getInstance().cursorName.length));
            params.destx = this.x + this.npcClip.width / 2;
            params.desty = this.y + this.npcClip.height / 2;
            ApplicationFacade.getInstance().dispatch(EventConst.SENDACTION,params);
         }
         else
         {
            this.handlNpcClick();
         }
         MouseManager.getInstance().setCursor("");
      }
      
      private function handlNpcClick() : void
      {
         this.tempParams = {};
         this.tempParams.id = IdName.id(this.spriteName);
         if(this.stateClip != null)
         {
            this.tempParams.NPCState = this.stateClip.currentFrame;
         }
         else
         {
            this.tempParams.NPCState = 0;
         }
         this.tempParams.x = this.x + this.npcClip.width / 2;
         this.tempParams.y = this.y + this.npcClip.height;
         if(this.special == 1 || this.special == 2)
         {
            if(this.master.moveto(this.tempParams.x,this.tempParams.y))
            {
               MapView.instance.addTimerListener(this.checkNpc);
               ApplicationFacade.getInstance().dispatch(EventConst.ROLEMOVE,{
                  "newx":this.tempParams.x,
                  "newy":this.tempParams.y,
                  "path":null
               });
            }
         }
      }
      
      private function checkNpc() : void
      {
         var dx:Number = x - this.master.x;
         var dy:Number = this.sortY - this.master.y;
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
            ApplicationFacade.getInstance().dispatch(EventConst.ONCLICKNPC,this.tempParams);
         }
      }
      
      public function onClose(param:Object) : void
      {
         if(this.functionClip != null)
         {
            if(this.stateClip != null)
            {
               if(this.stateClip.currentFrame == 1 || this.stateClip.currentFrame == 3)
               {
                  this.functionClip.visible = this.functionClip.visible == true ? false : true;
               }
            }
         }
         else if(this.stateClip != null)
         {
         }
      }
      
      private function onRollOut(evt:MouseEvent) : void
      {
         if(MouseManager.getInstance().cursorName.substr(0,12) != "CursorTool20")
         {
            MouseManager.getInstance().setCursor("");
         }
      }
      
      private function onRollOver(evt:MouseEvent) : void
      {
         if(MouseManager.getInstance().cursorName.substr(0,12) != "CursorTool20")
         {
            MouseManager.getInstance().setCursor("dialogue");
         }
      }
      
      override public function get centerX() : Number
      {
         if(this.npcClip != null)
         {
            return this.x + this.npcClip.width / 2;
         }
         return this.x;
      }
      
      override public function get centerY() : Number
      {
         if(this.npcClip != null)
         {
            return this.y + this.npcClip.height - 18;
         }
         return this.y;
      }
      
      private function onUseWatch(evt:TaskEvent) : void
      {
         if(this.watchFlag)
         {
            TaskUtils.getInstance().removeEventListener(TaskEvent.OP_MOUSE_ACTION_AI,this.onUseWatch);
            this.watchFlag = false;
            ApplicationFacade.getInstance().dispatch(EventConst.STARTTOPLAYANIMATION,{
               "npcid":0,
               "x":0,
               "y":0,
               "effectName":"",
               "url":this._watchURL + ".swf",
               "targetFunction":null,
               "type":0
            });
         }
      }
   }
}

