package com.game.modules.view.person.actAI
{
   import com.core.observer.MessageEvent;
   import com.game.locators.EventDefine;
   import com.game.locators.GameData;
   import com.game.locators.MsgDoc;
   import com.game.manager.AlertManager;
   import com.game.modules.view.MapView;
   import com.game.util.IdName;
   import com.game.util.LuaObjUtil;
   import com.game.util.SceneAIBase;
   import com.game.util.XMLServerch;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.system.ApplicationDomain;
   import org.green.server.core.GreenSocket;
   import org.green.server.events.MsgEvent;
   import org.green.server.manager.SocketManager;
   
   public class Act638AI extends SceneAIBase
   {
      
      private var sock:GreenSocket = SocketManager.getGreenSocket();
      
      private var _configXML:XML;
      
      private var boss:MovieClip;
      
      private var _left_combat_cnt:int;
      
      private var isAction:Boolean;
      
      private var special:int;
      
      private var istask:int = 0;
      
      private var myname:String = "";
      
      private var _dy:Number = 0;
      
      public function Act638AI(param:Object)
      {
         super(param);
         this.special = param.special;
         this.istask = param.istask;
         this.myname = param.name;
         this.spriteName = IdName.npc(param.sequenceID);
         this._dy = param.dymaicY;
         XMLServerch.instance.searchXML("config/activityConfig/Act638",this.onXMLComplete);
      }
      
      override public function load(... rest) : void
      {
         super.load(this.onLoadComplete);
      }
      
      override public function removeEvent() : void
      {
         if(Boolean(this.sock))
         {
            this.sock.removeSocketListener(MsgDoc.OP_CLIENT_ACTIVITY_QINGYANG_NEW.back,this.onSocketHandler);
            this.sock = null;
         }
         GameData.instance.removeEventListener(EventDefine.SIMULATED_CLICK_NPC,this.onSimulatedClick);
         Sprite(ui).removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseClick);
         super.removeEvent();
      }
      
      override public function dispos() : void
      {
         super.loader.unloadAndStop();
         if(sceneAIClip != null)
         {
            removeChild(sceneAIClip,false);
         }
         super.dispos();
      }
      
      private function onLoadComplete(evt:Event) : void
      {
         var cls:Class = null;
         GameData.instance.addEventListener(EventDefine.SIMULATED_CLICK_NPC,this.onSimulatedClick);
         var domain:ApplicationDomain = evt.currentTarget.applicationDomain as ApplicationDomain;
         if(domain != null && Boolean(domain.getDefinition("npc")))
         {
            cls = domain.getDefinition("npc") as Class;
            this.sceneAIClip = new cls() as MovieClip;
            this.addChild(this.sceneAIClip);
            Sprite(ui).addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseClick);
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
      
      private function onMouseClick(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         this.gotoSpecifiedPosition();
      }
      
      private function gotoSpecifiedPosition() : void
      {
         var xCoode:int = this.x + Math.floor(Math.random() * 20);
         var yCoode:int = this.y + Math.floor(Math.random() * 50);
         var point:Point = MapView.instance.masterPerson.ui.parent.localToGlobal(new Point(xCoode,yCoode));
         MapView.instance.masterPerson.moveto(point.x,point.y,this.clickOver);
      }
      
      private function clickOver() : void
      {
         /*
          * 反编译出错
          * 代码可能被加密
          * 提示：您可以尝试在“设置”中启用“反混淆代码”选项。
          * 错误类型: IndexOutOfBoundsException (Index -1 out of bounds for length 0)
          */
         throw new flash.errors.IllegalOperationError("由于错误未反编译");
      }
      
      private function specifiedPosition() : Point
      {
         var tmpPoint:Point = null;
         var obj:Object = null;
         var list:Array = LuaObjUtil.getLuaObjArr(String(this._configXML.ai_point));
         for each(obj in list)
         {
            if(obj.mapid == GameData.instance.playerData.sceneId)
            {
               tmpPoint = new Point(obj.xCoord,obj.yCoord);
               break;
            }
         }
         return tmpPoint;
      }
      
      private function onXMLComplete(xml:XML) : void
      {
         this._configXML = xml;
         this.sock.attachSocketListener(MsgDoc.OP_CLIENT_ACTIVITY_QINGYANG_NEW.back,this.onSocketHandler);
         this.sock.sendCmd(MsgDoc.OP_CLIENT_ACTIVITY_QINGYANG_NEW.send,638,["ui_info"]);
         var tmpPoint:Point = this.specifiedPosition();
         this.x = tmpPoint.x;
         this.y = tmpPoint.y;
      }
      
      private function onSocketHandler(event:MsgEvent) : void
      {
         var oper:String = null;
         var error:int = 0;
         var hurt:int = 0;
         var exp:int = 0;
         var coin:int = 0;
         var game_coin:int = 0;
         var str:String = null;
         O.traceSocket(event);
         if(event.msg.body != null)
         {
            event.msg.body.position = 0;
            if(event.msg.mParams == 638)
            {
               event.msg.body.position = 0;
               oper = event.msg.body.readUTF();
               switch(oper)
               {
                  case "ui_info":
                     this._left_combat_cnt = event.msg.body.readInt();
                     break;
                  case "start_combat":
                     error = event.msg.body.readInt();
                     if(error == 0)
                     {
                        this._left_combat_cnt = event.msg.body.readInt();
                     }
                     else
                     {
                        switch(error)
                        {
                           case 1:
                              AlertManager.instance.addTipAlert({
                                 "tip":"你今天已经出战" + this.combat_num + "次了\n先休息休息",
                                 "type":2
                              });
                              break;
                           case 2:
                              AlertManager.instance.addTipAlert({
                                 "tip":"正在战斗中，先休息休息",
                                 "type":2
                              });
                              break;
                           case 3:
                              AlertManager.instance.addTipAlert({
                                 "tip":"背包中无可参与战斗的妖怪",
                                 "type":2
                              });
                        }
                     }
                     break;
                  case "sweep":
                     event.msg.body.readInt();
                     event.msg.body.readInt();
                     event.msg.body.readInt();
                     event.msg.body.readInt();
                     this._left_combat_cnt = event.msg.body.readInt();
                     break;
                  case "combat_over":
                     hurt = event.msg.body.readInt();
                     exp = event.msg.body.readInt();
                     coin = event.msg.body.readInt();
                     game_coin = event.msg.body.readInt();
                     str = "本场挑战对BOSS造成" + hurt + "点伤害";
                     if(exp == 0 && coin == 0 && game_coin == 0)
                     {
                        str += "\n今日挑战获得历练/铜钱/天道值已达上限，无法再获得哦";
                     }
                     else
                     {
                        str += "，获得：\n";
                        if(exp != 0)
                        {
                           str += "历练：" + exp + "\n";
                        }
                        if(coin != 0)
                        {
                           str += "铜钱：" + coin + "\n";
                        }
                        if(game_coin != 0)
                        {
                           str += "天道值：" + game_coin + "\n";
                        }
                     }
                     AlertManager.instance.addTipAlert({
                        "tip":str,
                        "type":2
                     });
               }
            }
         }
      }
      
      private function get combat_num() : int
      {
         return this._configXML.combat_num;
      }
   }
}

