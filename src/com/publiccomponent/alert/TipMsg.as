package com.publiccomponent.alert
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.manager.MouseManager;
   import com.game.util.ColorUtil;
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.util.MovieClipLoader;
   import com.publiccomponent.util.NewAlertWindow;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.events.TimerEvent;
   import flash.net.URLRequest;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.utils.Timer;
   import flash.utils.clearTimeout;
   import flash.utils.getDefinitionByName;
   import flash.utils.setTimeout;
   
   internal class TipMsg extends Sprite
   {
      
      private var callBack:Function;
      
      private var linkBack:Function;
      
      private var msg:String;
      
      private var disPlay:MovieClip;
      
      private var data:Object;
      
      private var timer:Timer;
      
      private var selfTF:TextField;
      
      private var sx:int = -120;
      
      private var sy:int = -43;
      
      private var time:int = 0;
      
      private var savemouseName:String = "";
      
      private var valueY:int = 0;
      
      private var valueX:int = 0;
      
      private var valueW:int = 0;
      
      private var tf:TextFormat = new TextFormat();
      
      private var GameData:* = getDefinitionByName("com.game.locators.GameData");
      
      private var absid:uint;
      
      private var baotip:Loader;
      
      public function TipMsg()
      {
         super();
      }
      
      public function showAcceptOrRefuseView(msg:String, closeHandler:Function = null, data:Object = null, linkHandler:Function = null) : void
      {
         this.valueX = -8;
         this.msg = msg;
         this.callBack = closeHandler;
         this.linkBack = linkHandler;
         this.data = data;
         new MovieClipLoader().load("assets/material/acceptrefuse.swf",this.onAcceptOrRefuseViewLoaded);
      }
      
      private function onAcceptOrRefuseViewLoaded(disPlay:MovieClip) : void
      {
         this.removeAll();
         if(disPlay == null)
         {
            this.graphics.clear();
            return;
         }
         this.disPlay = disPlay;
         disPlay.x -= 260;
         disPlay.y -= 170;
         this.addChild(disPlay);
         this.showTxt();
         disPlay.msgTxt.addEventListener(TextEvent.LINK,this.linkHandler);
         disPlay.acceptBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.closeHandler);
         disPlay.refuseBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.closeHandler);
      }
      
      private function onshowMouse() : void
      {
         this.savemouseName = MouseManager.getInstance().cursorName;
         MouseManager.getInstance().setCursor("");
      }
      
      private function onSaveMouse() : void
      {
         MouseManager.getInstance().setCursor(this.savemouseName);
      }
      
      private function linkHandler(event:TextEvent) : void
      {
         if(this.linkBack != null)
         {
            this.linkBack.apply(null,[event.text,this.data]);
         }
      }
      
      private function showTxt() : void
      {
         if(Boolean(this.disPlay) && Boolean(this.disPlay.msgTxt))
         {
            this.disPlay.msgTxt.selectable = false;
            this.disPlay.msgTxt.visible = false;
         }
         this.tf.size = 16;
         this.tf.align = TextFormatAlign.CENTER;
         this.selfTF = new TextField();
         this.selfTF.multiline = true;
         this.selfTF.wordWrap = true;
         this.selfTF.mouseEnabled = false;
         this.selfTF.htmlText = this.msg + "";
         this.selfTF.width = 277 + this.valueW;
         this.selfTF.setTextFormat(this.tf);
         this.selfTF.height = this.selfTF.textHeight + 20;
         this.selfTF.x = this.sx + this.valueX;
         this.selfTF.y = this.sy + (115 - this.selfTF.height) * 0.5 + this.valueY;
         if(this.linkBack != null)
         {
            this.selfTF.addEventListener(TextEvent.LINK,this.linkHandler);
            this.selfTF.mouseEnabled = true;
         }
         this.addChild(this.selfTF);
         if(Boolean(this.GameData.instance.playerData.isAutoBattle))
         {
            this.absid = setTimeout(this.closeHandler,3500);
         }
         this.onshowMouse();
      }
      
      private function closeHandler(evt:MouseEvent = null) : void
      {
         clearTimeout(this.absid);
         this.closeView(evt);
         if(Boolean(evt))
         {
            if(evt.target["name"] == "acceptBtn")
            {
               if(this.callBack != null)
               {
                  this.callBack.apply(null,["接受",this.data]);
               }
            }
            if(evt.target["name"] == "refuseBtn")
            {
               if(this.callBack != null)
               {
                  this.callBack.apply(null,["拒绝",this.data]);
               }
            }
            if(evt.target["name"] == "sureBtn")
            {
               if(this.callBack != null)
               {
                  this.callBack.apply(null,["确定",this.data]);
               }
            }
            if(evt.target["name"] == "cancelBtn")
            {
               if(this.callBack != null)
               {
                  this.callBack.apply(null,["取消",this.data]);
               }
            }
         }
         else if(this.callBack != null)
         {
            this.callBack.apply(null,["取消",this.data]);
            this.callBack.apply(null,["拒绝",this.data]);
         }
         if(Boolean(this.baotip))
         {
            this.baotip["unloadAndStop"](false);
            if(this.contains(this.baotip))
            {
               this.removeChild(this.baotip);
            }
            this.baotip = null;
         }
         if(Boolean(this.disPlay) && Boolean(this.disPlay.hasOwnProperty("tb")))
         {
            this.disPlay.tb.removeEventListener(MouseEvent.ROLL_OVER,this.onRollOverTb);
            this.disPlay.tb.removeEventListener(MouseEvent.ROLL_OUT,this.onRollOutTb);
         }
         this.callBack = null;
      }
      
      private function closeView(evt:MouseEvent) : void
      {
         this.onSaveMouse();
         if(this.linkBack != null && this.selfTF != null)
         {
            this.selfTF.removeEventListener(TextEvent.LINK,this.linkHandler);
         }
         this.linkBack = null;
         this.graphics.clear();
         if(evt != null)
         {
            evt.stopImmediatePropagation();
            evt.target.removeEventListener(MouseEvent.MOUSE_DOWN,this.closeHandler);
            evt.target.removeEventListener(MouseEvent.MOUSE_DOWN,this.closeView);
         }
         else if(Boolean(this.disPlay))
         {
            if(this.disPlay.hasOwnProperty("acceptBtn"))
            {
               this.disPlay.acceptBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.closeHandler);
            }
            if(this.disPlay.hasOwnProperty("refuseBtn"))
            {
               this.disPlay.refuseBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.closeHandler);
            }
            if(this.disPlay.hasOwnProperty("cancelBtn"))
            {
               this.disPlay.cancelBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.closeHandler);
            }
            if(this.disPlay.hasOwnProperty("sureBtn"))
            {
               this.disPlay.sureBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.closeHandler);
            }
         }
         if(this.disPlay && this.disPlay.parent && this.disPlay.parent.contains(this.disPlay))
         {
            this.disPlay.parent.removeChild(this.disPlay);
         }
         if(this.parent is Sprite && this.parent.numChildren == 1)
         {
            Sprite(this.parent).graphics.clear();
         }
         this.parent.removeChild(this);
      }
      
      public function showSureView(msg:String, closeHandler:Function = null, data:Object = null) : void
      {
         this.msg = msg;
         this.data = data;
         this.callBack = closeHandler;
         this.onSureViewLoaded(new NewAlertWindow());
      }
      
      public function showSureViewLink(msg:String, closeHandler:Function = null, data:Object = null, linkHandler:Function = null) : void
      {
         this.msg = msg;
         this.callBack = closeHandler;
         this.linkBack = linkHandler;
         this.data = data;
         this.onSureViewLoaded(new NewAlertWindow());
      }
      
      public function showCongratulateView(msg:String, closeHandler:Function = null, data:Object = null) : void
      {
         this.valueY = 15;
         this.msg = msg;
         this.data = data;
         this.callBack = closeHandler;
         new MovieClipLoader().load("assets/material/surecongrate.swf",this.onSureViewLoaded);
      }
      
      public function showSureOneView(msg:String, closeHandler:Function = null, data:Object = null) : void
      {
         this.valueY = 15;
         this.msg = msg;
         this.data = data;
         this.callBack = closeHandler;
         new MovieClipLoader().load("assets/material/sureone.swf",this.onSureViewLoaded);
      }
      
      public function showTwo(msg:String, closeHandler:Function = null) : void
      {
         this.valueX = 30;
         this.valueY = -30;
         this.msg = msg;
         this.callBack = closeHandler;
         new MovieClipLoader().load("assets/material/suretwo.swf",this.onSureViewLoaded);
      }
      
      public function showUserPassWordError() : void
      {
         this.callBack = null;
         new MovieClipLoader().load("assets/material/userpasserror.swf",this.onErrorLoad);
      }
      
      public function showIdPassWordError() : void
      {
         this.callBack = null;
         new MovieClipLoader().load("assets/material/idpasserror.swf",this.onErrorLoad);
      }
      
      public function showBallteOrNo(msg:String, closeHandler:Function = null) : void
      {
         this.msg = msg;
         this.callBack = closeHandler;
         this.valueX = -10;
         this.valueY = -30;
         new MovieClipLoader().load("assets/material/battleorno.swf",this.onSureOrCancelViewLoaded);
      }
      
      public function showVip(msg:String) : void
      {
         this.msg = msg;
         new MovieClipLoader().load("assets/material/vipalert.swf",this.onVipViewLoaded);
      }
      
      private function onErrorLoad(disPlay:MovieClip) : void
      {
         this.removeAll();
         if(disPlay == null)
         {
            this.graphics.clear();
            return;
         }
         this.disPlay = disPlay;
         disPlay.x -= 260;
         disPlay.y -= 170;
         this.addChild(disPlay);
         disPlay.sureBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.closeHandler);
      }
      
      private function onSureViewLoaded(disPlay:MovieClip) : void
      {
         this.removeAll();
         if(disPlay == null)
         {
            this.graphics.clear();
            return;
         }
         this.disPlay = disPlay;
         disPlay.x -= 260;
         disPlay.y -= 170;
         if(disPlay.hasOwnProperty("tb"))
         {
            disPlay.tb.visible = false;
            if(Boolean(this.data))
            {
               if(Boolean(this.data.hasOwnProperty("useState")) && Boolean(int(this.data.useState) & 1 << 9))
               {
                  disPlay.tb.visible = true;
                  disPlay.tb.addEventListener(MouseEvent.ROLL_OVER,this.onRollOverTb);
                  disPlay.tb.addEventListener(MouseEvent.ROLL_OUT,this.onRollOutTb);
               }
            }
         }
         this.addChild(disPlay);
         this.showTxt();
         disPlay.sureBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.closeHandler);
      }
      
      private function onRollOverTb(event:MouseEvent) : void
      {
         if(this.baotip == null)
         {
            this.baotip = new Loader();
            this.baotip.mouseChildren = false;
            this.baotip.mouseEnabled = false;
            this.baotip.x = 210;
            this.baotip.y = -60;
            this.addChild(this.baotip);
            this.baotip.load(new URLRequest(URLUtil.getSvnVer("assets/material/award10tips.swf")));
         }
         if(Boolean(this.baotip) && !this.contains(this.baotip))
         {
            this.addChild(this.baotip);
         }
      }
      
      private function onRollOutTb(event:MouseEvent) : void
      {
         if(Boolean(this.baotip) && this.contains(this.baotip))
         {
            this.removeChild(this.baotip);
         }
      }
      
      public function showSureOrCancelView(msg:String, closeHandler:Function = null, data:Object = null, linkHandler:Function = null) : void
      {
         this.msg = msg;
         this.callBack = closeHandler;
         this.linkBack = linkHandler;
         this.data = data;
         new MovieClipLoader().load("assets/material/surecancel.swf",this.onSureOrCancelViewLoaded);
      }
      
      public function showSureOrCancelAndTimeView(msg:String, closeHandler:Function = null, data:Object = null, linkHandler:Function = null, time:int = 0) : void
      {
         this.msg = msg;
         this.callBack = closeHandler;
         this.linkBack = linkHandler;
         this.data = data;
         this.time = time;
         new MovieClipLoader().load("assets/material/surecancelAndTime.swf",this.onSureOrCancelAndTimeViewLoaded);
      }
      
      private function onSureOrCancelViewLoaded(disPlay:MovieClip) : void
      {
         this.removeAll();
         if(disPlay == null)
         {
            this.graphics.clear();
            return;
         }
         this.disPlay = disPlay;
         disPlay.x -= 260;
         disPlay.y -= 170;
         this.addChild(disPlay);
         this.showTxt();
         disPlay.sureBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.closeHandler);
         disPlay.cancelBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.closeHandler);
      }
      
      private function onSureOrCancelAndTimeViewLoaded(disPlay:MovieClip) : void
      {
         this.removeAll();
         if(disPlay == null)
         {
            this.graphics.clear();
            return;
         }
         this.disPlay = disPlay;
         disPlay.x -= 260;
         disPlay.y -= 170;
         this.addChild(disPlay);
         this.showTxt();
         disPlay.sureBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.closeHandler);
         disPlay.cancelBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.closeHandler);
         disPlay.sureBtn.visible = false;
         disPlay.spTime.visible = true;
         disPlay.spTime.filters = ColorUtil.getColorMatrixFilterGray();
         (disPlay.spTime.txt as TextField).text = "(" + this.time + ")";
         this.timer = new Timer(1000);
         this.timer.addEventListener(TimerEvent.TIMER,this.onTimer);
         this.timer.start();
      }
      
      private function onTimer(event:TimerEvent) : void
      {
         --this.time;
         if(this.disPlay.spTime == null)
         {
            return;
         }
         (this.disPlay.spTime.txt as TextField).text = "(" + this.time + ")";
         if(this.time <= 0)
         {
            this.timer.stop();
            this.disPlay.sureBtn.visible = true;
            this.disPlay.spTime.visible = false;
         }
      }
      
      private function onVipViewLoaded(disPlay:MovieClip) : void
      {
         this.removeAll();
         if(disPlay == null)
         {
            this.graphics.clear();
            return;
         }
         this.disPlay = disPlay;
         disPlay.x = -437;
         disPlay.y = -224;
         this.addChild(disPlay);
         this.showTxt();
         disPlay.tequanBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.onVip);
         disPlay.kaitontBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.onVip);
         disPlay.closeBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.closeView);
      }
      
      private function onVip(evt:MouseEvent) : void
      {
         evt.target.removeEventListener(MouseEvent.MOUSE_DOWN,this.onVip);
         this.disPlay.closeBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.closeView);
         this.closeView(evt);
         if(evt.currentTarget.name == "tequanBtn")
         {
            ApplicationFacade.getInstance().dispatch("open_module",{
               "url":"assets/vip/VIPPrivilege.swf",
               "xCoord":0,
               "yCoord":0
            });
         }
         else
         {
            ApplicationFacade.getInstance().dispatch(EventConst.OPEN_MODULE,{
               "url":"assets/vip/VipExchangeModule.swf",
               "xCoord":0,
               "yCoord":0
            });
         }
      }
      
      public function showGiveUpHBTask(callback:Function) : void
      {
         this.callBack = callback;
         new MovieClipLoader().load("assets/material/hbgiveup.swf",this.onLoadGiveUpTaskComplete);
      }
      
      private function onLoadGiveUpTaskComplete(disPlay:MovieClip) : void
      {
         this.removeAll();
         if(disPlay == null)
         {
            this.graphics.clear();
            return;
         }
         this.disPlay = disPlay;
         disPlay.x = -500;
         disPlay.y = -270;
         this.addChild(disPlay);
         disPlay.cancelBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.closeHandler);
         disPlay.refuseBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.closeHandler);
         disPlay.sureBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.closeHandler);
      }
      
      private function removeAll() : void
      {
         if(Boolean(this.timer))
         {
            this.timer.stop();
            this.timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
            this.timer = null;
         }
         if(this.disPlay != null)
         {
            if(this.contains(this.disPlay))
            {
               this.removeChild(this.disPlay);
            }
         }
         if(Boolean(this.selfTF) && this.contains(this.selfTF))
         {
            this.removeChild(this.selfTF);
         }
         this.selfTF = null;
      }
   }
}

