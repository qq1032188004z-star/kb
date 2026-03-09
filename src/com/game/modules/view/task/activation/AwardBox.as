package com.game.modules.view.task.activation
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.manager.EventManager;
   import com.game.util.CacheUtil;
   import com.game.util.ColorUtil;
   import com.game.util.HLoaderSprite;
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.alert.Alert;
   import com.publiccomponent.ui.ToolTip;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.external.ExternalInterface;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.utils.ByteArray;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import org.green.server.core.GreenSocket;
   import org.green.server.manager.SocketManager;
   
   public class AwardBox extends HLoaderSprite
   {
      
      public static var AwardStep:int = 0;
      
      public static var LeftTime:int = 0;
      
      private static var LeftTid:int = 0;
      
      private static var AnswerTimes:int = 0;
      
      private static var AnswerTime:int = 0;
      
      private static var AnswerId:int = 0;
      
      private var body:Object;
      
      private var barTid:int = 0;
      
      private var hardword:HardWorkAward;
      
      private var answerTid:int = 0;
      
      private var s:GreenSocket = SocketManager.getGreenSocket();
      
      private const AwardTime:Array = [0,60,300,600,1200,1800];
      
      private var urlloader:URLLoader;
      
      private var xml:XML;
      
      public function AwardBox()
      {
         super();
      }
      
      public static function setLeftTime(time:int, step:int) : void
      {
         LeftTime = time;
         AwardStep = step;
         if(LeftTime == -1)
         {
            AwardStep = 6;
            return;
         }
         if(LeftTime > 0)
         {
            LeftTid = setInterval(leftTimeHandler,1000);
         }
         else
         {
            leftTimeHandler();
         }
      }
      
      private static function leftTimeHandler() : void
      {
         if(LeftTime > 0)
         {
            --LeftTime;
         }
         else
         {
            LeftTime = 0;
            clearInterval(LeftTid);
            if(AwardStep < 6)
            {
               ApplicationFacade.getInstance().dispatch(EventConst.ONLINEAWARDTIME,0);
            }
         }
      }
      
      public static function setAnswerData(times:int = 0, time:int = 0, id:int = 0) : void
      {
         AnswerTimes = times;
         AnswerTime = time;
         AnswerId = id;
      }
      
      override public function initParams(params:Object = null) : void
      {
         this.body = params;
         if(bg)
         {
            this.setShow();
         }
         else
         {
            this.url = "assets/material/award_box.swf";
         }
      }
      
      override public function setShow() : void
      {
         bg.cacheAsBitmap = true;
         bg.gotoAndStop(1);
         bg.b4.visible = false;
         bg.mc.visible = true;
         for(var i:int = 1; i < 6; i++)
         {
            if(i < AwardStep)
            {
               bg.mc["bar" + i].gotoAndStop(bg.mc["bar" + i].totalFrames);
               bg.mc["get" + i].gotoAndStop(2);
               ToolTip.setDOInfo(bg.mc["get" + i],"已领取过了！");
            }
            else if(i == AwardStep)
            {
               bg.mc["bar" + i].gotoAndStop(1);
               bg.mc["get" + i].gotoAndStop(1);
               bg.mc["get" + i].filters = ColorUtil.getColorMatrixFilterGray();
               clearInterval(this.barTid);
               this.barTid = setInterval(this.barMoveHandler,1000);
            }
            else
            {
               bg.mc["bar" + i].gotoAndStop(1);
               bg.mc["get" + i].gotoAndStop(1);
               bg.mc["get" + i].filters = ColorUtil.getColorMatrixFilterGray();
               ToolTip.setDOInfo(bg.mc["get" + i],"领取时间还没到呢！");
            }
         }
         EventManager.attachEvent(bg.btn0,MouseEvent.CLICK,this.onBtn0);
         EventManager.attachEvent(bg.btn1,MouseEvent.CLICK,this.onBtn1);
         EventManager.attachEvent(bg.btn2,MouseEvent.CLICK,this.onBtn2);
         EventManager.attachEvent(bg.btn3,MouseEvent.CLICK,this.onBtn3);
         EventManager.attachEvent(bg.answerMC.sureBtn,MouseEvent.CLICK,this.onClickSureBtn);
         EventManager.attachEvent(bg.answerMC.mc2,MouseEvent.CLICK,this.onClickMc2);
         EventManager.attachEvent(bg.answerMC.mc3,MouseEvent.CLICK,this.onClickMc3);
         if(AnswerTimes < 10 && AnswerTime <= 0)
         {
            this.onBtn3(null);
         }
         else
         {
            this.onBtn1(null);
         }
         this.s.sendCmd(1184833,11,[1]);
      }
      
      override public function disport() : void
      {
         var i:int = 0;
         var n:int = 0;
         if(AwardStep < 6 || AnswerTimes < 10)
         {
            this.parentRemove();
            return;
         }
         CacheUtil.deleteObject(AwardBox);
         if(bg)
         {
            EventManager.removeEvent(bg.btn0,MouseEvent.CLICK,this.onBtn0);
            EventManager.removeEvent(bg.btn1,MouseEvent.CLICK,this.onBtn1);
            EventManager.removeEvent(bg.btn2,MouseEvent.CLICK,this.onBtn2);
            EventManager.removeEvent(bg.btn3,MouseEvent.CLICK,this.onBtn3);
            EventManager.removeEvent(bg.btn4,MouseEvent.CLICK,this.onBtn4);
            EventManager.removeEvent(bg.answerMC.sureBtn,MouseEvent.CLICK,this.onClickSureBtn);
            EventManager.removeEvent(bg.answerMC.mc2,MouseEvent.CLICK,this.onClickMc2);
            EventManager.removeEvent(bg.answerMC.mc3,MouseEvent.CLICK,this.onClickMc3);
            for(i = 1; i < 6; i++)
            {
               ToolTip.LooseDO(bg.mc["get" + i]);
            }
            n = 1;
            while(n < 8)
            {
               EventManager.removeEvent(bg.newhands["d" + n],MouseEvent.CLICK,this.onClick7DayAward);
            }
         }
         if(Boolean(this.hardword))
         {
            if(this.contains(this.hardword))
            {
               this.removeChild(this.hardword);
            }
            this.hardword.disport();
            this.hardword = null;
         }
         LeftTime = 0;
         clearInterval(LeftTid);
         clearInterval(this.barTid);
         clearInterval(this.answerTid);
         this.urlloader = null;
         this.xml = null;
         super.disport();
      }
      
      private function barMoveHandler() : void
      {
         var frame:int = 0;
         if(!bg)
         {
            clearInterval(this.barTid);
            return;
         }
         if(bg)
         {
            ToolTip.LooseDO(bg.mc["get" + AwardStep]);
         }
         if(LeftTime > 0)
         {
            frame = int((this.AwardTime[AwardStep] - LeftTime) / this.AwardTime[AwardStep] * bg.mc["bar" + AwardStep].totalFrames);
            bg.mc["bar" + AwardStep].gotoAndStop(frame);
            ToolTip.setDOInfo(bg.mc["get" + AwardStep],this.getLeftTimeStr());
         }
         else
         {
            clearInterval(this.barTid);
            ToolTip.setDOInfo(bg.mc["get" + AwardStep],"点击领取神秘奖励");
            bg.mc["bar" + AwardStep].gotoAndStop(bg.mc["bar" + AwardStep].totalFrames);
            bg.mc["get" + AwardStep].gotoAndStop(1);
            bg.mc["get" + AwardStep].filters = null;
            EventManager.attachEvent(bg.mc["get" + AwardStep],MouseEvent.CLICK,this.onGetAward);
         }
      }
      
      private function getLeftTimeStr() : String
      {
         var str:String = "剩余时间：";
         if(LeftTime > 60)
         {
            str += int(LeftTime / 60) + "分钟";
         }
         else
         {
            str = LeftTime + "秒钟";
         }
         return str;
      }
      
      private function onGetAward(evt:MouseEvent) : void
      {
         ToolTip.LooseDO(bg.mc["get" + AwardStep]);
         EventManager.removeEvent(bg.mc["get" + AwardStep],MouseEvent.CLICK,this.onGetAward);
         ApplicationFacade.getInstance().dispatch(EventConst.GETAWARD);
      }
      
      public function onGetAwardBack() : void
      {
         ApplicationFacade.getInstance().dispatch(EventConst.ONLINEAWARDTIME,1);
         ToolTip.setDOInfo(bg.mc["get" + AwardStep],"已领取过了！");
         ++AwardStep;
         if(ExternalInterface.available)
         {
            if(AwardStep < 1 || AwardStep > 5)
            {
               ExternalInterface.call("taskStateFunction",-1,0,-1,-1,-1);
            }
            else
            {
               ExternalInterface.call("taskStateFunction",-1,6 - AwardStep,-1,-1,-1);
            }
         }
         setLeftTime(this.AwardTime[AwardStep],AwardStep);
         if(bg)
         {
            this.setShow();
         }
      }
      
      private function onBtn0(evt:MouseEvent) : void
      {
         this.disport();
      }
      
      private function onBtn1(evt:MouseEvent) : void
      {
         if(bg.currentFrame == 1 && evt != null)
         {
            return;
         }
         bg.gotoAndStop(1);
         bg.mc.visible = true;
         bg.answerMC.visible = false;
         bg.newhands.visible = false;
         if(Boolean(this.hardword) && this.contains(this.hardword))
         {
            this.removeChild(this.hardword);
         }
      }
      
      private function onBtn2(evt:MouseEvent) : void
      {
         if(bg.currentFrame == 2 && evt != null)
         {
            return;
         }
         bg.gotoAndStop(2);
         bg.mc.visible = false;
         bg.answerMC.visible = false;
         bg.newhands.visible = false;
         if(this.hardword == null)
         {
            ApplicationFacade.getInstance().dispatch(EventConst.GETHARDWORD);
         }
         else if(!this.contains(this.hardword))
         {
            addChild(this.hardword);
         }
      }
      
      public function onOpenHardWordView(hard:HardWorkAward) : void
      {
         if(Boolean(hard))
         {
            this.hardword = hard;
            this.hardword.x = 215;
            this.hardword.y = 190;
            if(!this.contains(this.hardword))
            {
               addChild(this.hardword);
            }
         }
      }
      
      private function onBtn3(evt:MouseEvent) : void
      {
         if(bg.currentFrame == 3 && evt != null)
         {
            return;
         }
         bg.gotoAndStop(3);
         bg.mc.visible = false;
         bg.newhands.visible = false;
         if(Boolean(this.hardword) && this.contains(this.hardword))
         {
            this.removeChild(this.hardword);
         }
         bg.answerMC.visible = true;
         bg.answerMC.mc1.gotoAndStop(1);
         bg.answerMC.mc2.gotoAndStop(1);
         bg.answerMC.mc3.gotoAndStop(1);
         bg.answerMC.mc4.gotoAndStop(1);
         bg.answerMC.timeTxt.text = "";
         bg.answerMC.txt1.text = "";
         bg.answerMC.txt2.text = "";
         bg.answerMC.txt3.text = "";
         bg.answerMC.mc2.visible = false;
         bg.answerMC.mc3.visible = false;
         bg.answerMC.sureBtn.filters = ColorUtil.getColorMatrixFilterGray();
         bg.answerMC.sureBtn.mouseEnabled = false;
         if(AnswerTime > 0)
         {
            bg.answerMC.mc1.gotoAndStop(1);
            bg.answerMC.mc4.gotoAndStop(2);
            bg.answerMC.timeTxt.text = int(AnswerTime / 60) + "分" + int(AnswerTime % 60) + "秒后";
            clearInterval(this.answerTid);
            this.answerTid = setInterval(this.answerTimeHandler,1000);
         }
         else if(AnswerTimes < 10)
         {
            this.answerTimeHandler();
         }
         else
         {
            bg.answerMC.timeTxt.text = "今天已全部开启完了！";
         }
      }
      
      private function answerTimeHandler() : void
      {
         if(!bg)
         {
            clearInterval(this.answerTid);
            return;
         }
         if(AnswerTime > 0)
         {
            bg.answerMC.timeTxt.text = int(AnswerTime / 60) + "分" + int(AnswerTime % 60) + "秒后";
            --AnswerTime;
         }
         else
         {
            bg.answerMC.timeTxt.text = "";
            bg.answerMC.mc1.gotoAndStop(2);
            bg.answerMC.mc4.gotoAndStop(1);
            if(AnswerTimes < 10 && AnswerId > 0)
            {
               this.loadAndShowQuetion();
            }
            clearInterval(this.answerTid);
            ApplicationFacade.getInstance().dispatch(EventConst.ONLINEAWARDTIME,0);
         }
      }
      
      private function onClickSureBtn(evt:MouseEvent) : void
      {
         if(bg.answerMC.txt1.text != "")
         {
            if(bg.answerMC.mc2.currentFrame == 2)
            {
               ApplicationFacade.getInstance().dispatch(EventConst.GETANSWERAWARD,1);
            }
            if(bg.answerMC.mc3.currentFrame == 2)
            {
               ApplicationFacade.getInstance().dispatch(EventConst.GETANSWERAWARD,2);
            }
         }
      }
      
      private function onClickMc2(evt:MouseEvent) : void
      {
         bg.answerMC.mc2.gotoAndStop(2);
         bg.answerMC.mc3.gotoAndStop(1);
      }
      
      private function onClickMc3(evt:MouseEvent) : void
      {
         bg.answerMC.mc2.gotoAndStop(1);
         bg.answerMC.mc3.gotoAndStop(2);
      }
      
      private function onBtn4(evt:MouseEvent) : void
      {
         bg.mc.visible = false;
         bg.newhands.visible = true;
         bg.answerMC.visible = false;
         bg.gotoAndStop(4);
         if(Boolean(this.hardword) && this.contains(this.hardword))
         {
            this.removeChild(this.hardword);
         }
         var i:int = 1;
         while(i < 8)
         {
            bg.newhands["d" + i].gotoAndStop(1);
            EventManager.removeEvent(bg.newhands["d" + i],MouseEvent.CLICK,this.onClick7DayAward);
            EventManager.attachEvent(bg.newhands["d" + i],MouseEvent.CLICK,this.onClick7DayAward);
            i++;
         }
      }
      
      private function onClick7DayAward(event:MouseEvent) : void
      {
         this.s.sendCmd(1184833,11,[2,int(String(event.currentTarget.name).charAt(1))]);
      }
      
      public function on7daysBack(value:Object) : void
      {
         var i:int = 0;
         var b:Boolean = false;
         if(bg)
         {
            i = 1;
            b = false;
            while(i < 8)
            {
               if(value.valueobject["d" + i] == 0)
               {
                  bg.newhands["d" + i].gotoAndStop(1);
                  bg.newhands["d" + i].filters = ColorUtil.getColorMatrixFilterGray();
               }
               else if(value.valueobject["d" + i] == 1)
               {
                  bg.newhands["d" + i].gotoAndStop(1);
                  bg.newhands["d" + i].filters = [];
                  b = true;
               }
               else
               {
                  value.valueobject["d" + i] == 2;
               }
               bg.newhands["d" + i].gotoAndStop(2);
               bg.newhands["d" + i].filters = ColorUtil.getColorMatrixFilterGray();
               i++;
            }
            if(value.valueobject.loginDays > 0 && b)
            {
               bg.b4.visible = true;
               EventManager.attachEvent(bg.btn4,MouseEvent.CLICK,this.onBtn4);
            }
         }
      }
      
      public function onlinqu7daysBack(value:Object) : void
      {
         var i:int = 0;
         var c:int = 0;
         if(bg && Boolean(bg.newhands))
         {
            if(Boolean(bg.newhands["d" + value.valueobject.rewardLevel]) && value.valueobject.result == 0)
            {
               bg.newhands["d" + value.valueobject.rewardLevel].gotoAndStop(2);
               bg.newhands["d" + value.valueobject.rewardLevel].filters = ColorUtil.getColorMatrixFilterGray();
               i = 1;
               c = 0;
               while(i < 8)
               {
                  c += MovieClip(bg.newhands["d" + i]).currentFrame;
               }
               if(c == 14)
               {
                  bg.b4.visible = false;
                  EventManager.removeEvent(bg.btn4,MouseEvent.CLICK,this.onBtn4);
               }
            }
            if(value.valueobject.result == 1)
            {
               new Alert().show("登录天数不够");
            }
            else if(value.valueobject.result == 2)
            {
               new Alert().show("已经领取过该奖项");
            }
         }
      }
      
      private function loadAndShowQuetion() : void
      {
         if(this.xml == null)
         {
            this.urlloader = new URLLoader();
            this.urlloader.dataFormat = URLLoaderDataFormat.BINARY;
            this.urlloader.addEventListener(Event.COMPLETE,this.onLoaded);
            this.urlloader.addEventListener(IOErrorEvent.IO_ERROR,this.onError);
            this.urlloader.load(new URLRequest(URLUtil.getSvnVer("config/films")));
         }
         else
         {
            this.showQuestion();
         }
      }
      
      private function onLoaded(evt:Event) : void
      {
         var bytes:ByteArray = this.urlloader.data as ByteArray;
         bytes.uncompress();
         bytes.position = 0;
         var str:String = bytes.readUTFBytes(bytes.bytesAvailable);
         this.xml = new XML(str);
         this.urlloader.removeEventListener(Event.COMPLETE,this.onLoaded);
         this.urlloader.removeEventListener(IOErrorEvent.IO_ERROR,this.onError);
         this.urlloader = null;
         this.showQuestion();
      }
      
      private function onError(evt:IOErrorEvent) : void
      {
         this.urlloader.removeEventListener(Event.COMPLETE,this.onLoaded);
         this.urlloader.removeEventListener(IOErrorEvent.IO_ERROR,this.onError);
         this.urlloader = null;
      }
      
      private function showQuestion() : void
      {
         var node:XML = null;
         node = this.xml.children().(@id == 3000 + AnswerId)[0];
         if(node != null && Boolean(node.hasOwnProperty("question")))
         {
            bg.answerMC.txt1.text = node.question + "";
            bg.answerMC.txt2.text = "A. " + node.answer1;
            bg.answerMC.txt3.text = "B. " + node.answer2;
            bg.answerMC.mc2.visible = true;
            bg.answerMC.mc3.visible = true;
            bg.answerMC.mc2.buttonMode = true;
            bg.answerMC.mc3.buttonMode = true;
            bg.answerMC.mc2.gotoAndStop(2);
            bg.answerMC.sureBtn.filters = null;
            bg.answerMC.sureBtn.mouseEnabled = true;
            node = null;
         }
      }
      
      public function onGetAnswerAwardBack(params:Object) : void
      {
         ApplicationFacade.getInstance().dispatch(EventConst.ONLINEAWARDTIME,1);
         setAnswerData(params.answerTimes,params.answerTime,params.answerId);
         this.onBtn3(null);
      }
   }
}

