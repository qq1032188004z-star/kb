package com.game.modules.view.person.actAI
{
   import com.core.observer.MessageEvent;
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.locators.EventDefine;
   import com.game.locators.GameData;
   import com.game.manager.AlertManager;
   import com.game.manager.MouseManager;
   import com.game.util.IdName;
   import com.game.util.SceneAIBase;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import flash.system.ApplicationDomain;
   
   public class NPC211409 extends SceneAIBase
   {
      
      private var special:int;
      
      private var istask:int = 0;
      
      private var myname:String = "";
      
      private var _dy:Number = 0;
      
      private var _type:int;
      
      private var _door:Sprite;
      
      private var _monkey:Sprite;
      
      private var _mc:MovieClip;
      
      private var _isPlay:Boolean = false;
      
      private var _lastCursorName:String;
      
      public function NPC211409(param:Object)
      {
         this.istask = param.istask;
         this.special = param.special;
         this.myname = param.name;
         this.spriteName = IdName.npc(param.sequenceID);
         this._dy = param.dymaicY;
         this._type = param.type;
         this.sequenceID = param.sequenceID;
         if(this.getValueOfSpecifiedBit(12))
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
         param.url += ".swf";
      }
      
      public function getValueOfSpecifiedBit(bit:int) : Boolean
      {
         if(bit > 16 || bit <= 0)
         {
            return false;
         }
         return (this.istask & Math.pow(2,bit - 1)) > 0 ? true : false;
      }
      
      override public function load(... rest) : void
      {
         super.load(this.onLoadComplete);
      }
      
      override public function removeEvent() : void
      {
      }
      
      public function onLoadComplete(evt:Event) : void
      {
         var cls:Class = null;
         var domain:ApplicationDomain = evt.currentTarget.applicationDomain as ApplicationDomain;
         if(domain != null && Boolean(domain.getDefinition("npc")))
         {
            cls = domain.getDefinition("npc") as Class;
            this.sceneAIClip = new cls() as MovieClip;
            addChild(sceneAIClip);
         }
         this._lastCursorName = "";
         if(Boolean(this.sceneAIClip))
         {
            this._monkey = sceneAIClip["monkey"];
            this._door = sceneAIClip["door"];
            this._door.addEventListener(MouseEvent.CLICK,this.onMouseClick);
            this._door.addEventListener(MouseEvent.ROLL_OVER,this.onMouseType);
            this._door.addEventListener(MouseEvent.ROLL_OUT,this.onMouseType);
            this._mc = sceneAIClip["mc"];
            this._mc.visible = false;
            this._mc.gotoAndStop(1);
            this._mc.addFrameScript(this._mc.totalFrames - 1,this.playOver);
         }
         GameData.instance.dispatchEvent(new MessageEvent(EventDefine.NPC_LOAD_OK));
      }
      
      private function playOver() : void
      {
         this.showMaster();
         this._isPlay = false;
         this._mc.stop();
         if(this._mc.currentFrame > 100)
         {
            ApplicationFacade.getInstance().dispatch(EventConst.ONCLICKNPC,{
               "id":this.sequenceID,
               "type":this._type
            });
         }
      }
      
      private function onMouseRollOver(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         evt.currentTarget.filters = [new GlowFilter(16777215,1,10,10,2,1,false,false)];
         evt.currentTarget.addEventListener(MouseEvent.ROLL_OUT,this.onMouseRollOut);
      }
      
      private function onMouseRollOut(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         evt.currentTarget.removeEventListener(MouseEvent.ROLL_OUT,this.onMouseRollOut);
         evt.currentTarget.filters = null;
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
      
      private function onMouseType(evt:MouseEvent) : void
      {
         switch(evt.type)
         {
            case MouseEvent.ROLL_OVER:
               this._lastCursorName = MouseManager.getInstance().cursorName;
         }
      }
      
      private function onMouseClick(evt:MouseEvent) : void
      {
         var currentCursorName:String;
         evt.stopImmediatePropagation();
         currentCursorName = MouseManager.getInstance().cursorName;
         if(this._lastCursorName.substring(0,14) == "CursorTool2002")
         {
            this._isPlay = true;
            this._monkey.visible = false;
            this._door.visible = false;
            this._mc.visible = true;
            this._mc.gotoAndPlay(1);
         }
         else
         {
            AlertManager.instance.addTipAlert({
               "tip":"入口处似有神秘结界，要用魔晶射线才能打破结界！",
               "type":2,
               "callback":function(type:String = "", data:Object = null):void
               {
               }
            });
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
   }
}

