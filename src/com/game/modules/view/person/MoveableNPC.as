package com.game.modules.view.person
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.manager.MouseManager;
   import com.game.modules.control.task.TaskEvent;
   import com.game.modules.control.task.util.TaskInfoXMLParser;
   import com.game.modules.control.task.util.TaskUtils;
   import com.game.modules.view.MapView;
   import com.game.modules.vo.NPCVo;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   
   public class MoveableNPC extends MoveableGameSprite implements INPC
   {
      
      public var npcData:NPCVo;
      
      public function MoveableNPC(npcdata:NPCVo)
      {
         super();
         this.npcData = npcdata;
         bodyUrl = "assets/npc/npc" + this.npcData.sequenceID + ".green";
         this.build();
      }
      
      override public function build() : void
      {
         if(this.npcData.getValueOfSpecifiedBit(10))
         {
            x = Math.random() * 500 + 200;
            y = Math.random() * 300 + 100;
         }
         else
         {
            x = this.npcData.x;
            y = this.npcData.y;
         }
         if(this.npcData.getValueOfSpecifiedBit(3))
         {
            nameLabel = new TextField();
            nameLabel.defaultTextFormat = new TextFormat("宋体",14,255,null,null,null,null,null,TextFormatAlign.CENTER);
            nameLabel.mouseEnabled = false;
            nameLabel.filters = [new GlowFilter(16777215,1,3,3,10)];
            addChild(nameLabel);
            nameLabel.text = this.npcData.name;
         }
         super.build();
      }
      
      override public function onLoadBodyComplete(param:Object) : void
      {
         super.onLoadBodyComplete(param);
         this.parseTalkList();
         if(talkList != null && talkList.length > 0)
         {
            createMsgTxt();
         }
      }
      
      public function parseTalkList() : void
      {
         var i:int = 0;
         var len:int = 0;
         var subxml:XML = null;
         var tempXML:XML = TaskInfoXMLParser.instance.getTalkMsgBySequenceID(sequenceID);
         if(tempXML != null)
         {
            talkList = [];
            i = 0;
            len = int(tempXML.children().length());
            for(i = 0; i < len; i++)
            {
               subxml = tempXML.children()[i] as XML;
               talkList.push(subxml.toString());
            }
         }
      }
      
      public function load(reload:Boolean = false) : void
      {
      }
      
      public function onLoadComplete(evt:Event) : void
      {
      }
      
      public function onLoadError(evt:IOErrorEvent) : void
      {
      }
      
      public function requestState() : void
      {
      }
      
      public function updateState(npcState:int) : void
      {
      }
      
      public function playEffect(callback:Function = null) : void
      {
      }
      
      public function initEvents() : void
      {
      }
      
      public function releaseEvents() : void
      {
      }
      
      public function sendAction(actionName:String, targetX:Number, targetY:Number) : void
      {
         var params:Object = {};
         params.actionid = int(actionName.substring(12));
         var tmpP:Point = this.parseGlobalToLocal(targetX,targetY);
         params.destx = tmpP.x;
         params.desty = tmpP.y;
         ApplicationFacade.getInstance().dispatch(EventConst.SENDACTION,params);
         MouseManager.getInstance().setCursor("");
      }
      
      public function onUseAction(evt:TaskEvent) : void
      {
         if(!actionFlag)
         {
            return;
         }
         actionFlag = false;
         TaskUtils.getInstance().removeEventListener(TaskEvent.OP_MOUSE_ACTION_AI,this.onUseAction);
         if(cursorName == "CursorTool2003" && this.npcData.watchURL != "null")
         {
            ApplicationFacade.getInstance().dispatch(EventConst.STARTTOPLAYANIMATION,{
               "npcid":0,
               "x":0,
               "y":0,
               "effectName":"",
               "url":this.npcData.watchURL + ".swf",
               "targetFunction":null,
               "type":0
            });
            ApplicationFacade.getInstance().dispatch(EventConst.SENDXIYOUPERSON,this.sequenceID);
            return;
         }
         if(cursorName.substr(0,12) == "CursorTool20" && int(cursorName.substring(12)) != this.npcData.special || cursorName.substr(0,9) == "packmouse" && int(cursorName.substring(9)) != this.npcData.special)
         {
            return;
         }
      }
      
      override protected function onMouseDown(evt:MouseEvent) : void
      {
         var point:Point = null;
         evt.stopImmediatePropagation();
         masterPerson = MapView.instance.masterPerson;
         cursorName = MouseManager.getInstance().cursorName;
         if(cursorName.substr(0,12) == "CursorTool20")
         {
            this.sendAction(cursorName,evt.stageX,evt.stageY);
            actionFlag = true;
            if(!TaskUtils.getInstance().hasEventListener(TaskEvent.OP_MOUSE_ACTION_AI))
            {
               TaskUtils.getInstance().addEventListener(TaskEvent.OP_MOUSE_ACTION_AI,this.onUseAction);
            }
         }
         else if(cursorName.substr(0,9) != "packmouse")
         {
            if(this.npcData.getValueOfSpecifiedBit(1))
            {
               if(this.npcData.getValueOfSpecifiedBit(9))
               {
                  point = this.getTargetPosition(this.npcData.targetx,this.npcData.targety);
                  masterPerson.moveto(point.x,point.y,this.sendClickMe);
               }
               else
               {
                  point = parseLocalToGlobal(x,y);
                  masterPerson.moveto(point.x,point.y);
                  MapView.instance.addTimerListener(checkPosition);
               }
            }
            else
            {
               this.sendClickMe();
            }
         }
      }
      
      override protected function sendClickMe() : void
      {
         ApplicationFacade.getInstance().dispatch(EventConst.ONCLICKNPC,{
            "id":this.npcData.sequenceID,
            "type":this.npcData.type
         });
      }
      
      protected function getTargetPosition(xcoord:Number, ycoord:Number) : Point
      {
         return parseLocalToGlobal(xcoord,ycoord);
      }
   }
}

