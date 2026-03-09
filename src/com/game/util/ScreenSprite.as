package com.game.util
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.modules.view.MapView;
   import com.publiccomponent.alert.Alert;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class ScreenSprite extends Sprite
   {
      
      public static var instance:ScreenSprite = new ScreenSprite();
      
      private var tid:uint;
      
      private var senceid:int = 0;
      
      private var collectStatus:Boolean;
      
      private var dagongstatus:Boolean;
      
      private var eatStatus:Boolean;
      
      private var bobStatus:Boolean;
      
      public var fishStatus:int;
      
      private var blueSecretCollectStatus:Boolean;
      
      public function ScreenSprite()
      {
         super();
         this.visible = false;
         this.graphics.beginFill(16777215,0);
         this.graphics.drawRect(-100,-100,1500,1500);
         this.graphics.endFill();
         this.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
      }
      
      public function show(value:Boolean, tidbool:Boolean = false, senceid:int = 0) : void
      {
         this.senceid = senceid;
         this.visible = value;
         if(value && !tidbool)
         {
            this.tid = setTimeout(this.hide,13000);
         }
         else
         {
            clearTimeout(this.tid);
         }
      }
      
      private function onMouseDown(evt:MouseEvent) : void
      {
         var isRightSence:Boolean = this.senceid == 2005 || this.senceid == 9003 || this.senceid == 9004 || this.senceid == 10002 || this.senceid == 10003 || this.senceid == 7003 || this.senceid == 5001 || this.senceid == 6003 || this.senceid == 30005;
         if(isRightSence && !this.blueSecretCollectStatus)
         {
            this.blueSecretCollectStatus = true;
            new Alert().showSureOrCancel("是否中断收集蓝色物质?",this.cancelBlueChallenge);
         }
         if(this.senceid == 1 && !this.collectStatus)
         {
            this.collectStatus = true;
            new Alert().showSureOrCancel("正在采集中，你是否立即停止?",this.cancelCollectHandle);
         }
         if(this.senceid == 2 && !this.bobStatus)
         {
            this.bobStatus = true;
            new Alert().showSureOrCancel("是否要离开擂台?",this.cancelChallenge);
         }
         if(this.senceid == 3 && !this.eatStatus)
         {
            new Alert().showSureOrCancel("小心点哦，别再被吃掉了^_^",this.eatOut);
            this.eatStatus = true;
         }
         if(this.senceid == 3002 && !this.dagongstatus)
         {
            this.dagongstatus = true;
            new Alert().showSureOrCancel("你想要停止本次打工吗？",this.stopJobing);
         }
         if(this.senceid == 30007 && this.fishStatus == 0)
         {
            new Alert().showSureOrCancel("正在垂钓中，是否立即停止",this.stopFishing);
         }
         if(this.senceid == 30007 && this.fishStatus == 2)
         {
            this.hide();
            ApplicationFacade.getInstance().dispatch(EventConst.CHOOSEFISH);
         }
         if(this.senceid == 30007 && this.fishStatus == 3)
         {
            this.hide();
            new Alert().show("太慢啦……被妖怪逃跑了……");
            ApplicationFacade.getInstance().dispatch(EventConst.STOPFISHING);
         }
      }
      
      private function stopFishing(str:String, params2:*) : void
      {
         if("确定" == str)
         {
            ApplicationFacade.getInstance().dispatch(EventConst.STOPFISHING);
            this.hide();
         }
      }
      
      private function stopJobing(str:String, params2:*) : void
      {
         if("确定" == str)
         {
            ApplicationFacade.getInstance().dispatch(EventConst.STOPJOBING);
            this.hide();
         }
         else
         {
            this.dagongstatus = false;
         }
      }
      
      private function eatOut(str:String, params2:*) : void
      {
         if("确定" == str)
         {
            ApplicationFacade.getInstance().dispatch(EventConst.EATOUT);
            this.eatStatus = false;
         }
         else
         {
            this.eatStatus = false;
         }
      }
      
      private function cancelCollectHandle(str:String, params2:*) : void
      {
         if("确定" == str)
         {
            ApplicationFacade.getInstance().dispatch(EventConst.CANCLECOLLECT);
            this.hide();
         }
         else
         {
            this.collectStatus = false;
         }
      }
      
      private function cancelChallenge(str:String, params2:*) : void
      {
         if("确定" == str)
         {
            ApplicationFacade.getInstance().dispatch(EventConst.CANCELCHALLENGE);
            this.hide();
         }
         else
         {
            this.bobStatus = false;
         }
      }
      
      public function hide() : void
      {
         clearTimeout(this.tid);
         this.collectStatus = false;
         this.blueSecretCollectStatus = false;
         this.eatStatus = false;
         this.bobStatus = false;
         this.dagongstatus = false;
         this.fishStatus = 0;
         this.visible = false;
      }
      
      private function cancelBlueChallenge(str:String, params2:*) : void
      {
         if("确定" == str)
         {
            ApplicationFacade.getInstance().dispatch(EventConst.CANCELBLUECHALLENGE);
            this.hide();
            MapView.instance.masterPerson.collectFilm.addFrameScript(0,null);
            MapView.instance.masterPerson.removeCollectBar();
         }
         else
         {
            this.blueSecretCollectStatus = false;
         }
      }
   }
}

