package com.game.modules.control
{
   import com.core.observer.MessageEvent;
   import com.core.view.ViewConLogic;
   import com.game.event.EventConst;
   import com.game.locators.GameData;
   import com.game.locators.MsgDoc;
   import com.game.manager.EventManager;
   import com.game.modules.view.FaceView;
   import com.game.modules.view.MapView;
   import com.game.modules.view.WindowLayer;
   import com.game.modules.view.person.GamePerson;
   import com.publiccomponent.URLUtil;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   
   public class TemLeaveControl extends ViewConLogic
   {
      
      private var loader:Loader;
      
      private var times:int = 3;
      
      private var bg:MovieClip;
      
      private var url:String;
      
      private var tid:uint;
      
      public function TemLeaveControl()
      {
         super("teamleaveView");
      }
      
      override public function listEvents() : Array
      {
         return [[EventConst.TEMLEAVE_VISIBLE,this.onTemLeaveHandler]];
      }
      
      private function onTemLeaveHandler(e:MessageEvent) : void
      {
         var data:Object = null;
         var person:GamePerson = null;
         if(e.body == null)
         {
            return;
         }
         data = e.body;
         person = MapView.instance.findGameSprite(data.uid) as GamePerson;
         if(Boolean(person))
         {
            if(data.type == 1)
            {
               person.yCoode = 70;
               person.xCoode = 10;
               person.playStatus = "temLeave";
               person.showData.playerStatus = 7;
               if(data.uid == GameData.instance.playerData.userId)
               {
                  FaceView.clip.bottomClip.stopTime();
                  GameData.instance.playerData.playerStatus = 7;
                  this.addLeave();
               }
               person.stop(true);
            }
            else
            {
               person.removeStatus();
               person.showData.playerStatus = 0;
               if(data.uid == GameData.instance.playerData.userId)
               {
                  this.removeLeave();
                  FaceView.clip.bottomClip.showTime(GameData.instance.playerData.playerSurplus);
                  GameData.instance.playerData.playerStatus = 0;
               }
            }
         }
      }
      
      private function onCompelteHandler(e:Event) : void
      {
         if(this.loader == null)
         {
            return;
         }
         this.bg = this.loader.content as MovieClip;
         WindowLayer.instance.stage.addChild(this.bg);
         this.initEvents();
      }
      
      private function addLeave() : void
      {
         if(this.bg == null && this.loader == null)
         {
            WindowLayer.instance.graphics.clear();
            WindowLayer.instance.graphics.beginFill(16777215,0.01);
            WindowLayer.instance.graphics.drawRect(-100,-100,1100,770);
            WindowLayer.instance.graphics.endFill();
            this.times = 3;
            this.loader = new Loader();
            this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onCompelteHandler);
            this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onIoErrorHandler);
            this.url = URLUtil.getSvnVer("assets/activity/leave/leaveUi.swf");
            this.loader.load(new URLRequest(this.url));
         }
      }
      
      private function removeLeave() : void
      {
         WindowLayer.instance.graphics.clear();
         this.clearLoader();
         this.removeBg();
      }
      
      private function initEvents() : void
      {
         if(this.bg == null)
         {
            return;
         }
         EventManager.attachEvent(this.bg.start1,MouseEvent.MOUSE_DOWN,this.onMouseDown);
         EventManager.attachEvent(this.bg.start2,MouseEvent.MOUSE_DOWN,this.onMouseDown);
      }
      
      private function onMouseDown(e:MouseEvent) : void
      {
         sendMessage(MsgDoc.OP_CLIETN_SERV_STOP.send,GameData.instance.playerData.userId,[0]);
      }
      
      private function removeEvents() : void
      {
         if(this.bg == null)
         {
            return;
         }
         EventManager.removeEvent(this.bg.start1,MouseEvent.MOUSE_DOWN,this.onMouseDown);
         EventManager.removeEvent(this.bg.start2,MouseEvent.MOUSE_DOWN,this.onMouseDown);
      }
      
      private function clearLoader() : void
      {
         if(this.loader == null)
         {
            return;
         }
         this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onCompelteHandler);
         this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onIoErrorHandler);
         this.loader.unloadAndStop();
         this.loader = null;
      }
      
      private function removeBg() : void
      {
         this.removeEvents();
         this.clearLoader();
         if(Boolean(this.bg))
         {
            if(Boolean(this.bg.parent))
            {
               this.bg.parent.removeChild(this.bg);
            }
            this.bg = null;
         }
      }
      
      private function onIoErrorHandler(e:IOErrorEvent) : void
      {
         if(this.times > 0)
         {
            --this.times;
            this.loader.load(new URLRequest(this.url));
         }
         else
         {
            trace("加载出错了！");
         }
      }
   }
}

