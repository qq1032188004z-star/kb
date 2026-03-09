package com.game.modules.view.trump
{
   import com.core.observer.MessageEvent;
   import com.game.manager.EventManager;
   import com.game.modules.control.trump.TrumpEvent;
   import com.game.util.HLoaderSprite;
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.alert.Alert;
   import com.publiccomponent.loading.XMLLocator;
   import flash.display.Loader;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   
   public class TrumpTrainingItem extends HLoaderSprite
   {
      
      public var body:Object;
      
      private var myLoader:Loader;
      
      private var maskSprite:Sprite;
      
      private var totalSeconds:int;
      
      private var tid:int;
      
      public function TrumpTrainingItem(params:Object = null)
      {
         super();
         this.body = params;
         this.showloading = false;
         this.url = "assets/fabao/trumptrainingItem.swf";
      }
      
      override public function setShow() : void
      {
         bg.cacheAsBitmap = true;
         if(Boolean(this.body))
         {
            bg.mc.gotoAndStop(this.body.frame);
            if(this.body.frame == 1)
            {
               EventManager.attachEvent(bg.btn1,MouseEvent.CLICK,this.onMonsters);
               EventManager.attachEvent(bg.btn2,MouseEvent.CLICK,this.onTripod);
               bg.btn3.visible = false;
               bg.btn4.visible = false;
            }
            else if(this.body.frame == 2)
            {
               bg.btn1.visible = false;
               bg.btn2.visible = false;
               EventManager.attachEvent(bg.btn3,MouseEvent.CLICK,this.onStop);
               bg.btn4.visible = false;
               this.showTime(this.body.time);
               this.showImg();
            }
            else if(this.body.frame == 3)
            {
               bg.btn1.visible = false;
               bg.btn2.visible = false;
               bg.btn3.visible = false;
               EventManager.attachEvent(bg.btn4,MouseEvent.CLICK,this.onGet);
               this.showImg();
            }
            else if(this.body.frame == 4)
            {
               bg.btn1.visible = false;
               bg.btn2.visible = false;
               bg.btn3.visible = false;
               bg.btn4.visible = false;
            }
         }
         else
         {
            bg.mc.gotoAndStop(4);
         }
      }
      
      private function onMonsters(evt:MouseEvent) : void
      {
         this.dispatchEvent(new Event(TrumpTrainningView.OPENMONSTERLISTVIEW));
      }
      
      private function onTripod(evt:MouseEvent) : void
      {
         this.dispatchEvent(new Event(TrumpTrainningView.OPENTRIPODVIEW));
      }
      
      private function onStop(evt:MouseEvent) : void
      {
         new Alert().showSureOrCancel("停止训练会让之前的训练课程大打折扣，确定要放弃吗？",this.sureOrcancel);
      }
      
      private function sureOrcancel(... rest) : void
      {
         if("确定" == rest[0] && this.body != null && this.body.trainId != null)
         {
            this.dispatchEvent(new MessageEvent(TrumpEvent.TRAINGETBACKMONSTER,this.body.trainId));
         }
      }
      
      private function onGet(evt:MouseEvent) : void
      {
         if(this.body != null && this.body.trainId != null)
         {
            this.dispatchEvent(new MessageEvent(TrumpEvent.TRAINGETBACKMONSTER,this.body.trainId));
         }
      }
      
      private function showImg() : void
      {
         if(this.body == null || this.body.iid == null)
         {
            return;
         }
         this.myLoader = new Loader();
         var myurl:String = URLUtil.getSvnVer("assets/monsterimg/" + this.body.iid + ".swf");
         this.myLoader.load(new URLRequest(myurl));
         addChild(this.myLoader);
         this.myLoader.x = 25;
         this.myLoader.y = 5;
         this.myLoader.scaleX = 0.7;
         this.myLoader.scaleY = 0.7;
         this.maskSprite = new Sprite();
         this.maskSprite.graphics.beginFill(0,100);
         this.maskSprite.graphics.drawCircle(0,0,21);
         this.maskSprite.graphics.endFill();
         addChild(this.maskSprite);
         this.maskSprite.x = 45;
         this.maskSprite.y = 23;
         this.myLoader.mask = this.maskSprite;
         var xml:XML = XMLLocator.getInstance().getSprited(this.body.iid);
         bg.nameTxt.text = "" + xml.name;
      }
      
      private function showTime(seconds:int) : void
      {
         this.totalSeconds = seconds;
         this.tid = setInterval(this.loopCount,1000);
      }
      
      private function loopCount() : void
      {
         var str:String = null;
         var minutes:int = 0;
         var hour:int = 0;
         var day:int = 0;
         this.totalSeconds -= 1;
         if(this.totalSeconds <= 0)
         {
            clearInterval(this.tid);
         }
         else
         {
            minutes = this.totalSeconds / 60;
            hour = minutes / 60;
            day = hour / 24;
            if(day > 0)
            {
               str = day + "天" + int(hour % 24) + "时";
            }
            else if(hour > 0)
            {
               str = hour + "时" + int(minutes % 60) + "分";
            }
            else if(minutes > 0)
            {
               str = minutes + "分" + int(this.totalSeconds % 60) + "秒";
            }
            else
            {
               str = int(this.totalSeconds % 60) + "秒";
            }
            bg.timeTxt.text = str;
         }
      }
      
      override public function disport() : void
      {
         if(!bg)
         {
            return;
         }
         EventManager.removeEvent(bg.btn1,MouseEvent.CLICK,this.onMonsters);
         EventManager.removeEvent(bg.btn2,MouseEvent.CLICK,this.onTripod);
         EventManager.removeEvent(bg.btn3,MouseEvent.CLICK,this.onStop);
         EventManager.removeEvent(bg.btn4,MouseEvent.CLICK,this.onGet);
         if(this.body && this.body.frame && this.body.frame == 2)
         {
            clearInterval(this.tid);
         }
         if(this.myLoader != null)
         {
            removeChild(this.myLoader);
            this.myLoader.unload();
            this.myLoader = null;
         }
         if(this.maskSprite != null)
         {
            removeChild(this.maskSprite);
            this.maskSprite = null;
         }
         super.disport();
      }
   }
}

