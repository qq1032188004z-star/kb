package com.game.modules.view.person.actAI
{
   import com.core.observer.MessageEvent;
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.locators.EventDefine;
   import com.game.locators.GameData;
   import com.game.util.IdName;
   import com.game.util.SceneAIBase;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import flash.system.ApplicationDomain;
   
   public class NPC161706 extends SceneAIBase
   {
      
      private var special:int;
      
      private var istask:int = 0;
      
      private var myname:String = "";
      
      private var _dy:Number = 0;
      
      private var _type:int;
      
      private var _mcList:Vector.<MovieClip>;
      
      private var _count:int = 0;
      
      private var _curClickMc:int = -1;
      
      private var _isPlay:Boolean = false;
      
      public function NPC161706(param:Object)
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
         this._mcList = new Vector.<MovieClip>();
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
         var i:int = 0;
         var domain:ApplicationDomain = evt.currentTarget.applicationDomain as ApplicationDomain;
         if(domain != null && Boolean(domain.getDefinition("npc")))
         {
            cls = domain.getDefinition("npc") as Class;
            this.sceneAIClip = new cls() as MovieClip;
            addChild(sceneAIClip);
         }
         if(Boolean(this.sceneAIClip))
         {
            for(i = 0; i < 4; i++)
            {
               this._mcList.push(sceneAIClip["mc" + i]);
               this._mcList[i].gotoAndStop(1);
               this._mcList[i].addFrameScript(this._mcList[i].totalFrames - 1,this.playOver);
               this._mcList[i].addEventListener(MouseEvent.CLICK,this.onMouseClick);
               this._mcList[i].addEventListener(MouseEvent.ROLL_OVER,this.onMouseRollOver);
            }
         }
         GameData.instance.dispatchEvent(new MessageEvent(EventDefine.NPC_LOAD_OK));
      }
      
      private function playOver() : void
      {
         this.showMaster();
         this._isPlay = false;
         this._mcList[this._curClickMc].visible = false;
         this._mcList[this._curClickMc].gotoAndStop(1);
         ++this._count;
         if(this._count >= 4)
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
      
      private function onMouseClick(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         var index:int = int(this._mcList.indexOf(evt.currentTarget));
         if(index != -1 && !this._isPlay)
         {
            this._curClickMc = index;
            this._isPlay = true;
            this.clickOver();
         }
      }
      
      private function clickOver() : void
      {
         this.onRemoveMaster();
         this._mcList[this._curClickMc].gotoAndPlay(2);
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

