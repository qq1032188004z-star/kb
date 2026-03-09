package com.game.modules.view.battle
{
   import com.channel.ChannelEvent;
   import com.channel.ChannelPool;
   import com.channel.Message;
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.locators.GameData;
   import com.game.manager.EventManager;
   import com.game.manager.MouseManager;
   import com.game.modules.view.MapView;
   import com.game.modules.view.collect.PersonStatus;
   import com.game.modules.view.person.GamePerson;
   import com.publiccomponent.loading.MaterialLib;
   import com.publiccomponent.ui.Label;
   import com.publiccomponent.ui.TextArea;
   import com.xygame.module.battle.event.BattleEvent;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.clearInterval;
   import flash.utils.clearTimeout;
   import flash.utils.setInterval;
   import flash.utils.setTimeout;
   import org.dress.ui.BaseBody;
   import org.engine.frame.FrameTimer;
   import org.engine.game.AdMoveSprite;
   
   public class AIMonster extends AdMoveSprite
   {
      
      public static const MONSTERCLICK:String = "monsterclick";
      
      private var nameLabel:Label;
      
      private var body:BaseBody;
      
      public var name:String;
      
      public var data:Object;
      
      private var iscopymonster:Boolean;
      
      public var iscontinuemove:int;
      
      private var step:int;
      
      private var pointer:int;
      
      private var moveDelay:int;
      
      private var moveCount:int;
      
      private var monsterflag:int = 0;
      
      private var master2:GamePerson;
      
      private var tid:int;
      
      private var bodySprite:Sprite;
      
      private var timeDelayCount:int = 2000;
      
      private var moveArea:Rectangle;
      
      public var statusClip:PersonStatus;
      
      private var bShowKingEffect:Boolean;
      
      private var kingLabel:DisplayObject;
      
      private var msgArray2:Array;
      
      private var msgArray3:Array;
      
      private var iidlist:Array;
      
      private var msgTxt:TextArea;
      
      private var msgTid:int = 0;
      
      public function AIMonster(data:Object, bShowKingEffect:Boolean = false)
      {
         var index:int = 0;
         this.data = {};
         this.msgArray2 = ["今天天气真好啊！我浑身充满了力气。","哈哈~我觉得我比昨天又强壮了。","听说金兜山，双叉岭，傲来海岸都有神明果，可惜我没去过。","主人我喜欢你，你喜欢我吗？","主人你今天穿得好好看啊！","呼……刚刚运动了一下累死我了。常常锻炼身体好啊！","捣蛋妖好可怕啊……主人你要保护我！","那屋子旁边的机器是叫食物储存器吗？"];
         this.msgArray3 = ["主人！快看，快看我的样子！","发生什么事了？我觉得体内有股神奇的力量涌上来。","从我还在蛋里时，我就知道我不一般。","主人，我好想出去看看外面的世界，快带我出去。"];
         this.iidlist = ["6000033","6000063","6000093","6000123"];
         super();
         this.speed = 2;
         this.timeDelayCount = data.count;
         ui = new Sprite();
         this.bodySprite = new Sprite();
         this.data = data;
         spriteName = data.monsterName;
         this.iscopymonster = data.isCopySence;
         this.monsterflag = data.monsterflag == null ? 0 : int(data.monsterflag);
         if(data.moveArea != null)
         {
            this.moveArea = data.moveArea;
         }
         else if(data.hasOwnProperty("scope"))
         {
            index = Math.random() * 100 % Math.ceil(this.data.scope.length / 4);
            this.moveArea = new Rectangle(this.data.scope[index * 4],this.data.scope[index * 4 + 1],this.data.scope[index * 4 + 2] - this.data.scope[index * 4],this.data.scope[index * 4 + 3] - this.data.scope[index * 4 + 1]);
         }
         else
         {
            this.moveArea = null;
         }
         if(this.monsterflag == 0)
         {
            if(!this.iscopymonster)
            {
               this.build();
            }
            else
            {
               this.delayShow();
            }
         }
         else
         {
            this.buildAndShow(bShowKingEffect);
         }
         this.iscontinuemove = this.data.iscontinuemove;
      }
      
      private function addKingLabel() : void
      {
         this.kingLabel = MaterialLib.getInstance().getMaterial("kingView") as DisplayObject;
         this.addChild(this.kingLabel);
      }
      
      private function delKingLabel() : void
      {
         if(Boolean(this.kingLabel))
         {
            this.removeChild(this.kingLabel);
            this.kingLabel = null;
         }
      }
      
      override public function get sortY() : Number
      {
         return y + dymaicY;
      }
      
      private function addChild(disPlay:DisplayObject) : void
      {
         if(disPlay != null)
         {
            Sprite(ui).addChild(disPlay);
         }
      }
      
      private function removeChild(disPlay:DisplayObject) : void
      {
         if(disPlay != null && Sprite(ui).contains(disPlay))
         {
            Sprite(ui).removeChild(disPlay);
            disPlay = null;
         }
      }
      
      public function buildAndShow(bShowKingEffect:Boolean = false) : void
      {
         this.x = this.data.x;
         this.y = this.data.y;
         this.nameLabel = new Label();
         this.addChild(this.nameLabel);
         this.nameLabel.labelTxt.text = this.data.labelName;
         if(bShowKingEffect && this.data.CountGeniuscount == "绝代妖王")
         {
            this.addKingLabel();
         }
         this.addChild(this.bodySprite);
         this.body = new BaseBody();
         this.bodySprite.addChild(this.body);
         EventManager.attachEvent(this.bodySprite,MouseEvent.MOUSE_DOWN,this.onClickMonster);
         EventManager.attachEvent(this.bodySprite,MouseEvent.MOUSE_MOVE,this.onRollOut);
         EventManager.attachEvent(this.bodySprite,MouseEvent.MOUSE_OUT,this.onRollOver);
         if(Boolean(this.data.iid))
         {
            this.body.load("assets/spirit/" + this.data.iid + ".green","spirit",this.onLoadComplement);
         }
         if(!this.iscopymonster)
         {
            this.startAutoMove();
         }
         if(this.iscontinuemove == 1)
         {
            FrameTimer.getInstance().addCallBack(this.render);
         }
      }
      
      public function build() : void
      {
         clearTimeout(this.tid);
         this.tid = setTimeout(this.delayShow,this.timeDelayCount);
      }
      
      private function delayShow() : void
      {
         var index:int = 0;
         clearTimeout(this.tid);
         if(this.moveArea != null)
         {
            x = Math.random() * this.moveArea.width + this.moveArea.x;
            y = Math.random() * this.moveArea.height + this.moveArea.y;
         }
         else
         {
            index = 0;
            if(Boolean(this.data.counts))
            {
               index = int(Math.random() * 100 % (int(this.data.counts) << 1)) << 1;
            }
            if(Boolean(this.data.placeList) && index > this.data.placeList.length)
            {
               index = int(Math.random() * 100 % (2 << 1)) << 1;
            }
            x = this.data.placeList[index];
            y = this.data.placeList[index + 1];
         }
         if(Boolean(this.data.israte) && this.data.israte == 1)
         {
            this.nameLabel = new Label(0,0,9633939);
         }
         else
         {
            this.nameLabel = new Label();
         }
         this.addChild(this.nameLabel);
         this.nameLabel.labelTxt.text = this.data.labelName;
         this.addChild(this.bodySprite);
         this.body = new BaseBody();
         this.bodySprite.addChild(this.body);
         EventManager.attachEvent(this.bodySprite,MouseEvent.MOUSE_DOWN,this.onClickMonster);
         EventManager.attachEvent(this.bodySprite,MouseEvent.MOUSE_OUT,this.onRollOut);
         EventManager.attachEvent(this.bodySprite,MouseEvent.MOUSE_MOVE,this.onRollOver);
         clearTimeout(this.tid);
         if(Boolean(this.data.monsterId))
         {
            this.body.load("assets/spirit/" + this.data.monsterId + ".green","spirit",this.onLoadComplement);
         }
         if(!this.iscopymonster)
         {
            this.startAutoMove();
         }
         if(this.iscontinuemove == 1)
         {
            FrameTimer.getInstance().addCallBack(this.render);
         }
      }
      
      private function onRollOver(evt:MouseEvent) : void
      {
         if(this.body != null)
         {
            if(this.body.isActive(evt.stageX,evt.stageY))
            {
               ui["filters"] = [new GlowFilter(16777215,1,10,10,2,1,false,false)];
               Sprite(ui).buttonMode = true;
            }
            else
            {
               ui["filters"] = null;
               Sprite(ui).buttonMode = false;
            }
         }
      }
      
      private function onRollOut(evt:MouseEvent) : void
      {
         ui["filters"] = null;
         Sprite(ui).buttonMode = false;
      }
      
      private function onLoadComplement(params:Object) : void
      {
         var len:int = 0;
         if(this.nameLabel == null)
         {
            return;
         }
         this.nameLabel.x = -(49 - params.width) / 2 - params.width / 2;
         this.nameLabel.y = -params.height - 25;
         if(this.data.monsterId == 279)
         {
            this.nameLabel.x = -57.5;
            this.nameLabel.y = -133;
            y += 30;
         }
         this.step = params.step;
         if(this.monsterflag == 1)
         {
            this.nameLabel.x = -39.5;
            this.nameLabel.y = -params.height - 35;
         }
         if(this.monsterflag == 2)
         {
            len = int(this.data.labelName.length);
            this.nameLabel.x = -(params.width >> 2) - (len << 3);
            this.msgTxt = new TextArea(80,-50);
            this.addChild(this.msgTxt);
            this.msgTid = setInterval(this.loopMsg,10000);
         }
         this.body.render(this.direction);
      }
      
      private function loopMsg() : void
      {
         var s:int = 0;
         var r:int = 0;
         if(this.iidlist.indexOf(String(this.data.iid)) != -1)
         {
            s = Math.random() * this.msgArray3.length;
            this.msgTxt.text = this.msgArray3[s];
         }
         else
         {
            r = Math.random() * this.msgArray2.length;
            this.msgTxt.text = this.msgArray2[r];
         }
         if(!Sprite(ui).contains(this.msgTxt))
         {
            this.addChild(this.msgTxt);
         }
      }
      
      private function onClickMonster(evt:MouseEvent) : void
      {
         var mdata:Object = null;
         var userid:uint = 0;
         var params:Object = null;
         if(GameData.instance.playerData.userId == GameData.instance.playerData.fireCurrentPerson)
         {
            return;
         }
         if(GameData.instance.playerData.giantId == GameData.instance.playerData.userId)
         {
            return;
         }
         if(this.body != null)
         {
            if(!this.body.isActive(evt.stageX,evt.stageY))
            {
               return;
            }
         }
         evt.stopImmediatePropagation();
         if(this.monsterflag == 1)
         {
            if(GameData.instance.playerData.houseId == GameData.instance.playerData.userId)
            {
               ApplicationFacade.getInstance().dispatch(EventConst.GETTRAININGMONSTERINFO,0);
               return;
            }
            ApplicationFacade.getInstance().dispatch(EventConst.GETTRAININGMONSTERINFO,this.data.id);
            return;
         }
         if(this.monsterflag == 2)
         {
            ChannelPool.getChannel("shenshou").addChannelListener("timeChange",this.onTimeChangeHandler);
            ChannelPool.getChannel("shenshou").addChannelListener("UseToolBack",this.onUseToolBackHandler);
            mdata = this.data;
            userid = uint(GameData.instance.playerData.userId);
            mdata.selfshenshou = userid == GameData.instance.playerData.shenshoudata.userid ? true : false;
            new Message("aishenshou",mdata).sendToChannel("shenshou");
            return;
         }
         this.master2 = MapView.instance.masterPerson;
         var point:Point = this.master2.ui.parent.localToGlobal(new Point(this.x,this.y));
         if(MouseManager.getInstance().cursorName.substr(0,12) == "CursorTool20")
         {
            params = {};
            params.actionid = int(MouseManager.getInstance().cursorName.slice(13,MouseManager.getInstance().cursorName.length));
            params.destx = this.x + 15;
            params.desty = this.y;
            MouseManager.getInstance().setCursor("");
            ApplicationFacade.getInstance().dispatch(EventConst.SENDACTION,params);
         }
         else
         {
            MouseManager.getInstance().setCursor("");
            if(this.master2.moveto(point.x,point.y,this.checkAiMonster))
            {
               ApplicationFacade.getInstance().dispatch(EventConst.ROLEMOVE,{
                  "newx":point.x,
                  "newy":point.y
               });
               MapView.instance.addTimerListener(this.checkAiMonster);
            }
         }
      }
      
      private function onTimeChangeHandler(event:ChannelEvent) : void
      {
         if(this.data.hasOwnProperty("eggtime"))
         {
            this.data.eggtime -= 60;
            if(this.data.eggtime <= 0)
            {
               ++this.data.eggstep;
               new Message("addShenshouStep",this.data).sendToChannel("shenshou");
            }
         }
      }
      
      private function onUseToolBackHandler(evt:ChannelEvent) : void
      {
         var param:Object = evt.getMessage().getBody();
         if(this.data.index == param.index && this.data.selfshenshou == true)
         {
            this.data.eggrate = param.rate;
            this.data.eggtime = param.time;
            if(this.data.eggtime <= 0 || this.data.eggstep < param.step)
            {
               this.data.eggid = param.iid;
               this.data.eggstep = param.step;
               this.data.eggmood = param.mode;
               new Message("addShenshouStep",this.data).sendToChannel("shenshou");
            }
         }
      }
      
      private function checkAiMonster() : void
      {
         var dx:Number = x - this.master2.x;
         var dy:Number = y - this.master2.y;
         var radius:Number = Math.sqrt(dx * dx + dy * dy);
         if(radius < 60)
         {
            this.master2.stop(false);
            MapView.instance.removeTimerListener(this.checkAiMonster);
            ApplicationFacade.getInstance().dispatch(EventConst.ROLEMOVE,{
               "newx":this.master2.x,
               "newy":this.master2.y,
               "path":null
            });
            ApplicationFacade.getInstance().dispatch(BattleEvent.npcClick,this.data);
         }
      }
      
      private function startAutoMove() : void
      {
         this.moveDelay = int(Math.random() * 10 + 15);
         FrameTimer.getInstance().addCallBack(this.move);
      }
      
      private function move() : void
      {
         var xCoord:Number = NaN;
         var yCoord:Number = NaN;
         var point:Point = null;
         ++this.moveCount;
         if(this.moveCount >= this.moveDelay)
         {
            this.moveCount = 0;
            this.moveDelay = int(Math.random() * 10 + 15);
            if(this.moveArea == null)
            {
               xCoord = Math.random() * 960 + 10;
               yCoord = Math.random() * 530;
            }
            else
            {
               xCoord = Math.random() * this.moveArea.width + this.moveArea.x;
               yCoord = Math.random() * this.moveArea.height + this.moveArea.y;
               if(this.ui == null || this.ui.parent == null)
               {
                  return;
               }
               point = this.ui.parent.localToGlobal(new Point(xCoord,yCoord));
               xCoord = point.x;
               yCoord = point.y;
            }
            this.moveto(xCoord,yCoord);
         }
      }
      
      override public function render() : void
      {
         if(this.body != null)
         {
            this.body.render(direction,this.pointer);
         }
         if(this.pointer < this.step - 1)
         {
            ++this.pointer;
         }
         else
         {
            this.pointer = 0;
         }
      }
      
      override public function onStop() : void
      {
         if(this.iscontinuemove == 0)
         {
            FrameTimer.getInstance().removeCallBack(this.render);
         }
      }
      
      public function setState(state:String) : void
      {
         if(Boolean(this.statusClip))
         {
            this.statusClip.dispos();
         }
         this.statusClip = new PersonStatus(10,-168);
         this.addChild(this.statusClip);
         this.statusClip.setStatus(state);
      }
      
      public function removeStatus() : void
      {
         if(Boolean(this.statusClip))
         {
            this.statusClip.dispos();
         }
         this.statusClip = null;
      }
      
      override public function dispos() : void
      {
         this.delKingLabel();
         this.removeStatus();
         ChannelPool.getChannel("shenshou").removeListener("timeChange",this.onTimeChangeHandler);
         ChannelPool.getChannel("shenshou").removeListener("UseToolBack",this.onUseToolBackHandler);
         if(ui != null)
         {
            ui["filters"] = null;
         }
         clearTimeout(this.tid);
         if(this.msgTxt != null)
         {
            clearInterval(this.msgTid);
            this.msgTxt.clear();
            if(Sprite(ui).contains(this.msgTxt))
            {
               Sprite(ui).removeChild(this.msgTxt);
            }
            this.msgTxt = null;
         }
         if(this.body != null)
         {
            this.body.dispos();
            this.body = null;
         }
         if(this.bodySprite != null)
         {
            EventManager.removeEvent(this.bodySprite,MouseEvent.MOUSE_DOWN,this.onClickMonster);
            this.bodySprite.removeEventListener(MouseEvent.MOUSE_OUT,this.onRollOut);
            this.bodySprite.removeEventListener(MouseEvent.MOUSE_MOVE,this.onRollOver);
            if(Boolean(this.bodySprite.parent))
            {
               this.bodySprite.parent.removeChild(this.bodySprite);
            }
         }
         this.bodySprite = null;
         if(this.runner != null)
         {
            this.runner.stop();
         }
         this.runner = null;
         if(this.nameLabel != null)
         {
            this.nameLabel.dispos();
         }
         this.nameLabel = null;
         MapView.instance.removeTimerListener(this.checkAiMonster);
         FrameTimer.getInstance().removeCallBack(this.move);
         FrameTimer.getInstance().removeCallBack(this.render);
         super.dispos();
      }
   }
}

