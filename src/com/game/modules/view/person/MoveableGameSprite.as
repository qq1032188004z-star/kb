package com.game.modules.view.person
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.modules.view.MapView;
   import com.publiccomponent.ui.TextArea;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.utils.clearInterval;
   import flash.utils.clearTimeout;
   import flash.utils.setInterval;
   import flash.utils.setTimeout;
   import org.dress.ui.BaseBody;
   import org.engine.frame.FrameTimer;
   import org.engine.game.AdMoveSprite;
   
   public class MoveableGameSprite extends AdMoveSprite
   {
      
      public var step:int;
      
      public var pointer:int;
      
      public var moveDelay:int;
      
      public var moveCount:int;
      
      public var msgTid:uint;
      
      public var talkTid:uint;
      
      public var cursorName:String;
      
      public var actionFlag:Boolean = false;
      
      public var body:BaseBody;
      
      public var nameLabel:TextField;
      
      public var bodySprite:Sprite;
      
      public var msgTxt:TextArea;
      
      public var moveArea:Rectangle;
      
      public var masterPerson:GamePerson;
      
      public var talkList:Array;
      
      public var bodyUrl:String = "";
      
      public function MoveableGameSprite()
      {
         super();
         speed = 2;
         ui = new Sprite();
         this.bodySprite = new Sprite();
      }
      
      public function build() : void
      {
         this.addChild(this.bodySprite);
         this.body = new BaseBody();
         this.bodySprite.addChild(this.body);
         this.bodySprite.buttonMode = true;
         this.bodySprite.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         this.loadBody();
         this.startAutoMove();
         FrameTimer.getInstance().addCallBack(this.render);
      }
      
      public function loadBody() : void
      {
         this.body.load(this.bodyUrl,"spirit",this.onLoadBodyComplete);
      }
      
      public function addChild(display:DisplayObject) : void
      {
         if(display != null)
         {
            Sprite(ui).addChild(display);
         }
      }
      
      public function onLoadBodyComplete(param:Object) : void
      {
         if(Boolean(this.nameLabel))
         {
            this.nameLabel.x = (this.bodySprite.width - this.nameLabel.width) / 2;
            this.nameLabel.y = -this.nameLabel.height - 10;
         }
         this.step = param.step;
         this.body.render(direction);
      }
      
      public function startAutoMove() : void
      {
         this.moveDelay = (Math.random() * 10 >> 0) + 15;
         FrameTimer.getInstance().addCallBack(this.move);
      }
      
      public function move() : void
      {
         var xCoord:Number = NaN;
         var yCoord:Number = NaN;
         var point:Point = null;
         ++this.moveCount;
         if(this.moveCount >= this.moveDelay)
         {
            this.moveCount = 0;
            this.moveDelay = (Math.random() * 10 >> 0) + 15;
            if(Boolean(this.moveArea))
            {
               xCoord = Math.random() * this.moveArea.width + this.moveArea.x;
               yCoord = Math.random() * this.moveArea.height + this.moveArea.y;
               if(ui == null || ui.parent == null)
               {
                  return;
               }
               point = this.ui.parent.localToGlobal(new Point(xCoord,yCoord));
               xCoord = point.x;
               yCoord = point.y;
            }
            else
            {
               xCoord = Math.random() * 960 + 10;
               yCoord = Math.random() * 530;
            }
            moveto(xCoord,yCoord);
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
      
      public function createMsgTxt() : void
      {
         this.msgTxt = new TextArea(115,20);
         this.msgTxt.mouseEnabled = false;
         this.msgTxt.mouseChildren = false;
         this.addChild(this.msgTxt);
         var tempTime:int = sequenceID % 5;
         tempTime = 3 * tempTime * 1000 - 2000;
         tempTime = tempTime > 0 ? tempTime : 1000;
         this.talkTid = setTimeout(this.startTalk,tempTime);
      }
      
      public function startTalk() : void
      {
         clearTimeout(this.talkTid);
         this.msgTid = setInterval(this.saySomething,10000);
      }
      
      public function saySomething() : void
      {
         if(this.msgTxt == null)
         {
            this.createMsgTxt();
         }
         this.msgTxt.clear();
         Sprite(ui).addChild(this.msgTxt);
         this.msgTxt.text = this.talkList[Math.random() * this.talkList.length >> 0];
      }
      
      override public function dispos() : void
      {
         clearTimeout(this.talkTid);
         clearInterval(this.msgTid);
         if(Boolean(this.msgTxt))
         {
            this.msgTxt.clear();
            if(Boolean(this.msgTxt.parent))
            {
               this.msgTxt.parent.removeChild(this.msgTxt);
            }
            this.msgTxt = null;
         }
         if(Boolean(this.body))
         {
            this.body.dispos();
            this.body = null;
         }
         if(this.bodySprite != null)
         {
            this.bodySprite.buttonMode = false;
            this.bodySprite.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
            if(Boolean(this.bodySprite.parent))
            {
               this.bodySprite.parent.removeChild(this.bodySprite);
            }
            this.bodySprite = null;
         }
         if(Boolean(runner))
         {
            runner.stop();
            runner = null;
         }
         if(Boolean(this.nameLabel))
         {
            if(Boolean(this.nameLabel.parent))
            {
               this.nameLabel.parent.removeChild(this.nameLabel);
            }
            this.nameLabel = null;
         }
         FrameTimer.getInstance().removeCallBack(this.move);
         FrameTimer.getInstance().removeCallBack(this.render);
         super.dispos();
      }
      
      public function checkPosition() : void
      {
         var dx:Number = x - this.masterPerson.x;
         var dy:Number = y - this.masterPerson.y;
         var radius:Number = Math.sqrt(dx * dx + dy * dy);
         if(radius < 30)
         {
            this.masterPerson.stop(false);
            MapView.instance.removeTimerListener(this.checkPosition);
            ApplicationFacade.getInstance().dispatch(EventConst.ROLEMOVE,{
               "newx":this.masterPerson.x,
               "newy":this.masterPerson.y,
               "path":null
            });
            this.sendClickMe();
         }
      }
      
      protected function sendClickMe() : void
      {
      }
      
      protected function parseGlobalToLocal(xCoord:Number, yCoord:Number) : Point
      {
         var tempMaster:GamePerson = MapView.instance.masterPerson;
         return tempMaster.ui.parent.globalToLocal(new Point(xCoord,yCoord));
      }
      
      protected function parseLocalToGlobal(xCoord:Number, yCoord:Number) : Point
      {
         var tempMaster:GamePerson = MapView.instance.masterPerson;
         return tempMaster.ui.parent.localToGlobal(new Point(xCoord,yCoord));
      }
      
      protected function onMouseDown(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
      }
   }
}

