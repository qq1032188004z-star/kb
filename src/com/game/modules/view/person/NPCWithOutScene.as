package com.game.modules.view.person
{
   import com.core.observer.MessageEvent;
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.locators.EventDefine;
   import com.game.locators.GameData;
   import com.game.manager.MouseManager;
   import com.game.modules.control.task.TaskEvent;
   import com.game.modules.control.task.util.TaskUtils;
   import com.game.modules.view.MapView;
   import com.game.util.DateUtil;
   import com.game.util.GameAction;
   import com.game.util.IdName;
   import com.game.util.SceneAIBase;
   import com.publiccomponent.ui.ToolTip;
   import flash.display.FrameLabel;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.system.ApplicationDomain;
   import flash.utils.Dictionary;
   
   public class NPCWithOutScene extends SceneAIBase
   {
      
      private var special:int;
      
      private var istask:int = 0;
      
      private var isAction:Boolean = false;
      
      private var myname:String = "";
      
      private var _urlIndex:int = 0;
      
      private var _dy:Number = 0;
      
      private var specialMap:Dictionary;
      
      public function NPCWithOutScene(param:Object)
      {
         var tmpPoint:Point = null;
         var isTaskAbs:int = 0;
         this.makeSpecialMap();
         var tmpSequenceList:Array = this.specialMap[param.sequenceID];
         if(tmpSequenceList == null)
         {
            param.x = Math.random() * 300 + 280;
            param.y = Math.random() * 200 + 180;
         }
         else
         {
            if(param.istask < -1)
            {
               isTaskAbs = Math.abs(param.istask);
               this._urlIndex = Math.random() * isTaskAbs >> 0;
               param.url = param.url + "_" + GameData.instance.playerData.sceneId + "_" + (this._urlIndex + 1);
            }
            tmpPoint = this.specifiedPosition(tmpSequenceList);
            param.x = tmpPoint.x;
            param.y = tmpPoint.y;
         }
         if(param.sequenceID == 10036)
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
         super(param);
         this.special = param.special;
         this.istask = param.istask;
         this.myname = param.name;
         this.spriteName = IdName.npc(param.sequenceID);
         this._dy = param.dymaicY;
      }
      
      override public function load(... rest) : void
      {
         super.load(this.onLoadComplete);
      }
      
      override public function removeEvent() : void
      {
         GameData.instance.removeEventListener(EventDefine.SIMULATED_CLICK_NPC,this.onSimulatedClick);
         super.removeEvent();
      }
      
      private function onLoadComplete(evt:Event) : void
      {
         var cls:Class = null;
         var str:String = null;
         GameData.instance.addEventListener(EventDefine.SIMULATED_CLICK_NPC,this.onSimulatedClick);
         var domain:ApplicationDomain = evt.currentTarget.applicationDomain as ApplicationDomain;
         if(domain != null && Boolean(domain.getDefinition("npc")))
         {
            cls = domain.getDefinition("npc") as Class;
            this.sceneAIClip = new cls() as MovieClip;
            this.addChild(this.sceneAIClip);
            Sprite(ui).addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseClick);
            this.initEffect();
            if(this.istask != 0)
            {
               str = "";
               if(this.istask == 5)
               {
                  str = "去美佳处购买清洁喷水器，装备后，使用水弹术清理";
               }
               else if(this.istask == -1)
               {
                  Sprite(ui).buttonMode = true;
                  str = this.myname;
               }
               if(str.length > 0)
               {
                  if(Boolean(this.ui) && sequenceID != 10036)
                  {
                     ToolTip.BindDO(Sprite(ui),str);
                  }
               }
            }
         }
         if(Boolean(GameData.instance.autoLookForPresuresData.isAutoNum))
         {
            GameData.instance.autoLookForPresuresData.isGoNpc = true;
         }
         GameData.instance.dispatchEvent(new MessageEvent(EventDefine.NPC_LOAD_OK));
      }
      
      private function onSimulatedClick(event:MessageEvent) : void
      {
         if(Boolean(event) && Boolean(event.body.hasOwnProperty("npc")))
         {
            if(sequenceID == event.body["npc"])
            {
               this.onMouseClick(new MouseEvent(MouseEvent.CLICK));
            }
         }
      }
      
      private function onRemoveMe() : void
      {
         if(this.istask == 5 || this.istask == -1)
         {
            if(Boolean(this.ui) && sequenceID != 10036)
            {
               ToolTip.LooseDO(Sprite(ui));
            }
         }
      }
      
      override public function initEffect() : void
      {
         var frameLabel:FrameLabel = null;
         super.initEffect();
         var tempArr:Array = this.sceneAIClip.currentLabels;
         var i:int = 0;
         var len:int = int(tempArr.length);
         for(i = 0; i < len; i++)
         {
            frameLabel = tempArr[i];
            if(frameLabel.name == "removemaster")
            {
               sceneAIClip.addFrameScript(frameLabel.frame - 1,this.onRemoveMaster);
            }
            else if(frameLabel.name == "showmaster")
            {
               sceneAIClip.addFrameScript(frameLabel.frame - 1,this.showMaster);
            }
         }
      }
      
      private function onRemoveMaster() : void
      {
         ApplicationFacade.getInstance().dispatch(EventConst.HIDE_GAMEPERSON,{"type":1});
      }
      
      private function showMaster() : void
      {
         ApplicationFacade.getInstance().dispatch(EventConst.HIDE_GAMEPERSON,{"type":2});
      }
      
      public function play() : void
      {
         if(this.sceneAIClip.totalFrames > 1)
         {
            this.sceneAIClip.play();
         }
      }
      
      private function onMouseClick(evt:MouseEvent) : void
      {
         var str:String = null;
         var params:Object = null;
         evt.stopImmediatePropagation();
         if(this.istask > 0)
         {
            str = MouseManager.getInstance().cursorName;
            if(int(str.charAt(str.length - 1)) == this.istask && str.substring(0,12) == "CursorTool20")
            {
               this.isAction = true;
               Sprite(ui).removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseClick);
               if(!TaskUtils.getInstance().hasEventListener(TaskEvent.OP_MOUSE_ACTION_AI))
               {
                  TaskUtils.getInstance().addEventListener(TaskEvent.OP_MOUSE_ACTION_AI,this.onUseAction);
               }
               params = {};
               params.actionid = this.istask;
               params.destx = evt.stageX;
               params.desty = evt.stageY;
               ApplicationFacade.getInstance().dispatch(EventConst.SENDACTION,params);
               MouseManager.getInstance().setCursor("");
            }
         }
         else
         {
            if(Boolean(MouseManager.getInstance().cursorName))
            {
               MouseManager.getInstance().setCursor("");
               return;
            }
            if(this.specialMap[sequenceID] != null)
            {
               this.gotoSpecifiedPosition(this.specialMap[sequenceID]);
               return;
            }
            this.clickOver();
         }
      }
      
      private function clickOver() : void
      {
         ApplicationFacade.getInstance().dispatch(EventConst.PERSON_CAN_OR_NOT_MOVE,true);
         if(sequenceID == 10036)
         {
            ApplicationFacade.getInstance().dispatch(EventConst.HIDE_GAMEPERSON,{"type":1});
            GameData.instance.dispatchEvent(new MessageEvent(EventDefine.XUNBAO_224_DIG));
         }
         if(Sprite(ui).hasEventListener(MouseEvent.MOUSE_DOWN) && sequenceID != 10020 && sequenceID != 10021)
         {
            Sprite(ui).removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseClick);
         }
         if(this.sceneAIClip.currentFrame < this.sceneAIClip.totalFrames)
         {
            this.sceneAIClip.addFrameScript(this.sceneAIClip.totalFrames - 1,this.sendMsg);
            this.sceneAIClip.nextFrame();
            this.sceneAIClip.play();
         }
         else
         {
            this.sendMsg();
         }
      }
      
      private function onUseAction(evt:TaskEvent) : void
      {
         if(this.isAction)
         {
            TaskUtils.getInstance().removeEventListener(TaskEvent.OP_MOUSE_ACTION_AI,this.onUseAction);
            this.clickOver();
         }
      }
      
      private function sendMsg() : void
      {
         if(this.sceneAIClip.totalFrames > 1)
         {
            this.sceneAIClip.gotoAndStop(this.sceneAIClip.totalFrames);
         }
         if(this.sequenceID == 10019)
         {
            if(this.fallPage)
            {
               ApplicationFacade.getInstance().dispatch(EventConst.OPENSWFWINDOWS,{
                  "url":"assets/material/FallPageView.swf",
                  "xCoord":0,
                  "yCoord":0
               });
            }
         }
         ApplicationFacade.getInstance().dispatch(EventConst.CLICKNPCWITHOUTSCENECHECK,{
            "type":this.special,
            "npcid":IdName.id(this.spriteName),
            "actionID":1
         });
         if(this.sequenceID != 10020 && sequenceID != 10021)
         {
            ApplicationFacade.getInstance().dispatch(EventConst.REMOVEDYNAMICTASKNPC,this.spriteName);
         }
         ApplicationFacade.getInstance().dispatch(EventConst.PERSON_CAN_OR_NOT_MOVE,false);
         ApplicationFacade.getInstance().dispatch(EventConst.HIDE_GAMEPERSON,{"type":2});
      }
      
      public function get fallPage() : Boolean
      {
         var timeArr:Array = ["20260130000000","20260305235959"];
         if(DateUtil.isServerTimeBetween(timeArr[0],timeArr[1]))
         {
            GameAction.instance.playSwf(MapView.instance,200,100,"assets/activity/ani/PreHotMovie" + GameData.instance.playerData.sex + ".swf",null,1,true);
            return false;
         }
         return true;
      }
      
      override public function get sortY() : Number
      {
         var rect:Rectangle = null;
         var sortHeight:Number = this.y;
         if(this.sceneAIClip != null)
         {
            rect = this.sceneAIClip.getBounds(this.sceneAIClip);
            sortHeight += rect.bottom + 5;
         }
         return sortHeight - this._dy;
      }
      
      private function specifiedPosition(list:Array) : Point
      {
         var tmpPoint:Point = null;
         var obj:Object = null;
         var tmpArray:Array = [];
         for each(obj in list)
         {
            if(obj.mapid == GameData.instance.playerData.sceneId)
            {
               tmpPoint = new Point(obj.xCoord,obj.yCoord);
               tmpArray.push(tmpPoint);
            }
         }
         return tmpArray[this._urlIndex];
      }
      
      private function gotoSpecifiedPosition(list:Array) : void
      {
         var obj:Object = null;
         var tmpArray:Array = [];
         var destX:Number = 0;
         var destY:Number = 0;
         var rect:Rectangle = this.sceneAIClip.getBounds(this.sceneAIClip);
         var rectHeight:Number = rect.bottom - rect.top;
         var halfRectWidth:Number = (rect.right - rect.left) / 2;
         for each(obj in list)
         {
            if(obj.mapid == GameData.instance.playerData.sceneId)
            {
               tmpArray.push(obj);
            }
         }
         obj = tmpArray[this._urlIndex];
         if(obj.destX == -1 && obj.destY == -1)
         {
            if(sequenceID == 10036)
            {
               destX = this.x;
               destY = this.y;
               ApplicationFacade.getInstance().dispatch(EventConst.ROLEMOVE,{
                  "newx":destX,
                  "newy":destY,
                  "path":null
               });
               MapView.instance.masterPerson.moveto(destX,destY,this.clickOver);
            }
            else
            {
               this.clickOver();
            }
            return;
         }
         if(obj.destX == 0 && obj.destY == 0)
         {
            destX = this.x + halfRectWidth;
            destY = this.y + rectHeight;
         }
         else
         {
            destX = Number(obj.destX);
            destY = Number(obj.destY);
         }
         MapView.instance.masterPerson.moveto(destX,destY,this.clickOver);
      }
      
      override public function dispos() : void
      {
         this._urlIndex = 0;
         Sprite(ui).removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseClick);
         this.onRemoveMe();
         super.loader.unloadAndStop();
         if(sceneAIClip != null)
         {
            removeChild(sceneAIClip,false);
         }
         super.dispos();
      }
      
      private function makeSpecialMap() : void
      {
         this.specialMap = new Dictionary(true);
         this.specialMap[10018] = [{
            "mapid":40001,
            "xCoord":692.6,
            "yCoord":319,
            "destX":-1,
            "destY":-1
         },{
            "mapid":4002,
            "xCoord":185.65,
            "yCoord":135,
            "destX":-1,
            "destY":-1
         },{
            "mapid":10002,
            "xCoord":834.5,
            "yCoord":299,
            "destX":-1,
            "destY":-1
         },{
            "mapid":9003,
            "xCoord":207.65,
            "yCoord":129,
            "destX":-1,
            "destY":-1
         },{
            "mapid":9004,
            "xCoord":842.6,
            "yCoord":327,
            "destX":-1,
            "destY":-1
         },{
            "mapid":7001,
            "xCoord":239.65,
            "yCoord":419,
            "destX":-1,
            "destY":-1
         },{
            "mapid":2005,
            "xCoord":898.6,
            "yCoord":290,
            "destX":-1,
            "destY":-1
         }];
         this.specialMap[10019] = [{
            "mapid":40001,
            "xCoord":640,
            "yCoord":410,
            "destX":-1,
            "destY":-1
         },{
            "mapid":1004,
            "xCoord":692,
            "yCoord":442,
            "destX":-1,
            "destY":-1
         },{
            "mapid":1008,
            "xCoord":665,
            "yCoord":335,
            "destX":-1,
            "destY":-1
         },{
            "mapid":1009,
            "xCoord":391,
            "yCoord":409,
            "destX":-1,
            "destY":-1
         },{
            "mapid":1010,
            "xCoord":462,
            "yCoord":367,
            "destX":-1,
            "destY":-1
         },{
            "mapid":1012,
            "xCoord":393,
            "yCoord":381,
            "destX":-1,
            "destY":-1
         },{
            "mapid":2001,
            "xCoord":571,
            "yCoord":470,
            "destX":-1,
            "destY":-1
         },{
            "mapid":2003,
            "xCoord":446,
            "yCoord":462,
            "destX":-1,
            "destY":-1
         },{
            "mapid":6003,
            "xCoord":654,
            "yCoord":339,
            "destX":-1,
            "destY":-1
         },{
            "mapid":6004,
            "xCoord":614,
            "yCoord":464,
            "destX":-1,
            "destY":-1
         },{
            "mapid":20001,
            "xCoord":484,
            "yCoord":437,
            "destX":-1,
            "destY":-1
         }];
         var olympicFireList:Array = [{
            "mapid":2001,
            "xCoord":620,
            "yCoord":440,
            "destX":0,
            "destY":0
         },{
            "mapid":2103,
            "xCoord":530,
            "yCoord":255,
            "destX":0,
            "destY":0
         },{
            "mapid":80003,
            "xCoord":775,
            "yCoord":165,
            "destX":0,
            "destY":0
         },{
            "mapid":3001,
            "xCoord":385,
            "yCoord":247,
            "destX":410,
            "destY":302
         },{
            "mapid":4001,
            "xCoord":555,
            "yCoord":300,
            "destX":0,
            "destY":0
         },{
            "mapid":5002,
            "xCoord":534,
            "yCoord":396,
            "destX":0,
            "destY":0
         },{
            "mapid":10001,
            "xCoord":477,
            "yCoord":317,
            "destX":0,
            "destY":0
         },{
            "mapid":9001,
            "xCoord":305,
            "yCoord":290,
            "destX":0,
            "destY":0
         },{
            "mapid":7002,
            "xCoord":305,
            "yCoord":430,
            "destX":0,
            "destY":0
         },{
            "mapid":6001,
            "xCoord":140,
            "yCoord":335,
            "destX":0,
            "destY":0
         },{
            "mapid":40001,
            "xCoord":665,
            "yCoord":330,
            "destX":0,
            "destY":0
         }];
         this.specialMap[10020] = olympicFireList;
         this.specialMap[10021] = olympicFireList;
         this.specialMap[10022] = [{
            "mapid":1012,
            "xCoord":497.95,
            "yCoord":226.45,
            "destX":0,
            "destY":0
         },{
            "mapid":1022,
            "xCoord":410.95,
            "yCoord":205.45,
            "destX":0,
            "destY":0
         },{
            "mapid":1017,
            "xCoord":705.95,
            "yCoord":196.45,
            "destX":566,
            "destY":284
         }];
         this.specialMap[10023] = [{
            "mapid":1012,
            "xCoord":93,
            "yCoord":312.45,
            "destX":176,
            "destY":396
         },{
            "mapid":1022,
            "xCoord":36,
            "yCoord":376.45,
            "destX":0,
            "destY":0
         },{
            "mapid":1017,
            "xCoord":129,
            "yCoord":342.45,
            "destX":332,
            "destY":452
         }];
         this.specialMap[10024] = [{
            "mapid":1012,
            "xCoord":852.95,
            "yCoord":414.45,
            "destX":872,
            "destY":439
         },{
            "mapid":1022,
            "xCoord":298,
            "yCoord":232.45,
            "destX":431,
            "destY":335
         },{
            "mapid":1017,
            "xCoord":752.95,
            "yCoord":468.45,
            "destX":0,
            "destY":0
         }];
         this.specialMap[10029] = [{
            "mapid":1016,
            "xCoord":753.15,
            "yCoord":278.7,
            "destX":-1,
            "destY":-1
         },{
            "mapid":1016,
            "xCoord":863.4,
            "yCoord":369.55,
            "destX":-1,
            "destY":-1
         },{
            "mapid":1016,
            "xCoord":111.6,
            "yCoord":367.2,
            "destX":-1,
            "destY":-1
         },{
            "mapid":1016,
            "xCoord":308.5,
            "yCoord":292.15,
            "destX":-1,
            "destY":-1
         },{
            "mapid":1012,
            "xCoord":607.05,
            "yCoord":142.7,
            "destX":-1,
            "destY":-1
         },{
            "mapid":1012,
            "xCoord":108.1,
            "yCoord":182.25,
            "destX":-1,
            "destY":-1
         },{
            "mapid":1012,
            "xCoord":182,
            "yCoord":109.15,
            "destX":-1,
            "destY":-1
         },{
            "mapid":1012,
            "xCoord":798.9,
            "yCoord":112.6,
            "destX":-1,
            "destY":-1
         },{
            "mapid":1008,
            "xCoord":140.5,
            "yCoord":297.15,
            "destX":-1,
            "destY":-1
         },{
            "mapid":1008,
            "xCoord":908.9,
            "yCoord":351.2,
            "destX":-1,
            "destY":-1
         },{
            "mapid":1008,
            "xCoord":766.05,
            "yCoord":101.35,
            "destX":-1,
            "destY":-1
         },{
            "mapid":1008,
            "xCoord":766.05,
            "yCoord":101.35,
            "destX":-1,
            "destY":-1
         },{
            "mapid":1022,
            "xCoord":389.4,
            "yCoord":148.2,
            "destX":-1,
            "destY":-1
         },{
            "mapid":1022,
            "xCoord":69.9,
            "yCoord":267.75,
            "destX":-1,
            "destY":-1
         },{
            "mapid":1022,
            "xCoord":140.6,
            "yCoord":355.65,
            "destX":-1,
            "destY":-1
         },{
            "mapid":1022,
            "xCoord":69.9,
            "yCoord":267.75,
            "destX":-1,
            "destY":-1
         }];
         this.specialMap[10036] = [{
            "mapid":4001,
            "xCoord":744,
            "yCoord":258,
            "destX":-1,
            "destY":-1
         },{
            "mapid":5001,
            "xCoord":746.45,
            "yCoord":371.7,
            "destX":-1,
            "destY":-1
         },{
            "mapid":11001,
            "xCoord":360.5,
            "yCoord":383.7,
            "destX":-1,
            "destY":-1
         },{
            "mapid":10001,
            "xCoord":276,
            "yCoord":466,
            "destX":-1,
            "destY":-1
         },{
            "mapid":8001,
            "xCoord":629.45,
            "yCoord":421.7,
            "destX":-1,
            "destY":-1
         },{
            "mapid":9001,
            "xCoord":225.5,
            "yCoord":254.75,
            "destX":-1,
            "destY":-1
         },{
            "mapid":7002,
            "xCoord":710.5,
            "yCoord":436.7,
            "destX":-1,
            "destY":-1
         },{
            "mapid":6004,
            "xCoord":610,
            "yCoord":193,
            "destX":-1,
            "destY":-1
         },{
            "mapid":90001,
            "xCoord":289.5,
            "yCoord":286.7,
            "destX":-1,
            "destY":-1
         },{
            "mapid":2001,
            "xCoord":572.45,
            "yCoord":329.7,
            "destX":-1,
            "destY":-1
         },{
            "mapid":3001,
            "xCoord":482.45,
            "yCoord":256.7,
            "destX":-1,
            "destY":-1
         },{
            "mapid":2003,
            "xCoord":385.45,
            "yCoord":286.7,
            "destX":-1,
            "destY":-1
         },{
            "mapid":2002,
            "xCoord":267.55,
            "yCoord":388.7,
            "destX":-1,
            "destY":-1
         },{
            "mapid":40001,
            "xCoord":207.5,
            "yCoord":435.7,
            "destX":-1,
            "destY":-1
         },{
            "mapid":2101,
            "xCoord":520.5,
            "yCoord":462.7,
            "destX":-1,
            "destY":-1
         },{
            "mapid":10002,
            "xCoord":279.5,
            "yCoord":321.7,
            "destX":-1,
            "destY":-1
         },{
            "mapid":3002,
            "xCoord":259.55,
            "yCoord":402.7,
            "destX":-1,
            "destY":-1
         },{
            "mapid":4002,
            "xCoord":816,
            "yCoord":416,
            "destX":-1,
            "destY":-1
         },{
            "mapid":2102,
            "xCoord":193,
            "yCoord":298.7,
            "destX":-1,
            "destY":-1
         },{
            "mapid":9002,
            "xCoord":560.5,
            "yCoord":397.7,
            "destX":-1,
            "destY":-1
         },{
            "mapid":2103,
            "xCoord":193.55,
            "yCoord":378.7,
            "destX":-1,
            "destY":-1
         },{
            "mapid":7001,
            "xCoord":580,
            "yCoord":298,
            "destX":-1,
            "destY":-1
         },{
            "mapid":2004,
            "xCoord":500,
            "yCoord":435,
            "destX":-1,
            "destY":-1
         },{
            "mapid":3004,
            "xCoord":774,
            "yCoord":294,
            "destX":-1,
            "destY":-1
         },{
            "mapid":6003,
            "xCoord":700,
            "yCoord":344,
            "destX":-1,
            "destY":-1
         },{
            "mapid":4003,
            "xCoord":752.45,
            "yCoord":408.7,
            "destX":-1,
            "destY":-1
         },{
            "mapid":9004,
            "xCoord":467,
            "yCoord":367,
            "destX":-1,
            "destY":-1
         },{
            "mapid":6002,
            "xCoord":352.5,
            "yCoord":270.7,
            "destX":-1,
            "destY":-1
         }];
      }
   }
}

