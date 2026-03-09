package com.game.modules.view
{
   import com.channel.Message;
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.locators.GameData;
   import com.game.manager.EventManager;
   import com.game.modules.control.task.TaskList;
   import com.game.modules.view.person.GamePerson;
   import com.publiccomponent.alert.Alert;
   import com.publiccomponent.loading.MaterialLib;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import org.engine.core.GameSprite;
   
   public class DirectionView extends GameSprite
   {
      
      private var steerX:Number = 0;
      
      private var steerY:Number = 0;
      
      private var signName:String;
      
      private var nextPlaceID:int;
      
      private var master:GamePerson;
      
      public var isBig:int;
      
      private var passBool:Boolean;
      
      public function DirectionView()
      {
         super();
         ui = MaterialLib.getInstance().getMaterial("sigh") as MovieClip;
         MovieClip(ui).buttonMode = true;
         ui["bClip"].visible = false;
         ui["sighTxt"].visible = false;
         this.initEvent();
      }
      
      public function showOrHide(value:Boolean) : void
      {
         this.ui.visible = value;
      }
      
      private function initEvent() : void
      {
         EventManager.attachEvent(MovieClip(ui),MouseEvent.MOUSE_DOWN,this.onClickSign);
         EventManager.attachEvent(MovieClip(ui),MouseEvent.ROLL_OVER,this.onRollOverIt);
         EventManager.attachEvent(MovieClip(ui),MouseEvent.ROLL_OUT,this.onRollOutIt);
      }
      
      private function onClickSign(evt:MouseEvent) : void
      {
         var point:Point = null;
         if(GameData.instance.playerData.giantId == GameData.instance.playerData.userId)
         {
            return;
         }
         if(Boolean(GameData.instance.playerData.bobOwner))
         {
            new Alert().showSureOrCancel("确定离开擂台？",this.onBobAlerClose);
            return;
         }
         if(GameData.instance.playerData.refineState)
         {
            new Alert().showSureOrCancel("确定停止炼制？",this.onRefineAlerClose);
            return;
         }
         if(GameData.instance.playerData.currentScenenId == 1018 && GameData.instance.playerData.giantId == 1)
         {
            new Alert().showSureOrCancel("蝗虫马上就要被消灭掉了！你要就这样放弃吗？",this.farmSummerAiHandler);
            return;
         }
         evt.stopImmediatePropagation();
         if(GameData.instance.playerData.currentScenenId == 30006 && !TaskList.getInstance().hasBeenComplete(3019001))
         {
            new Alert().show("洞里太黑...还是别乱跑的好...");
            return;
         }
         this.master = MapView.instance.masterPerson;
         MapView.instance.addTimerListener(this.checkSign);
         if(GameData.instance.playerData.currentScenenId == 11002 || GameData.instance.playerData.currentScenenId == 3006 || GameData.instance.playerData.currentScenenId == 90002 || GameData.instance.playerData.currentScenenId == 90004)
         {
            point = new Point(evt.stageX,evt.stageY);
            this.steerX = point.x;
            this.steerY = point.y;
         }
         if(this.isBig == 1)
         {
            if(this.master.moveto(evt.stageX,evt.stageY,null,this.master.showData.moveFlag))
            {
               ApplicationFacade.getInstance().dispatch(EventConst.ROLEMOVE,{
                  "newx":evt.stageX,
                  "newy":evt.stageY
               });
            }
         }
         else if(this.master.moveto(this.steerX,this.steerY,null,this.master.showData.moveFlag))
         {
            ApplicationFacade.getInstance().dispatch(EventConst.ROLEMOVE,{
               "newx":this.steerX,
               "newy":this.steerY
            });
         }
      }
      
      private function onBobAlerClose(... rest) : void
      {
         if("确定" == rest[0])
         {
            GameData.instance.playerData.bobOwner = 0;
            ApplicationFacade.getInstance().dispatch(EventConst.LEAVEBOB_DIRECTION);
         }
      }
      
      private function onRefineAlerClose(... rest) : void
      {
         if("确定" == rest[0])
         {
            GameData.instance.playerData.refineState = false;
            ApplicationFacade.getInstance().dispatch(EventConst.STOPREFINE);
         }
      }
      
      private function farmSummerAiHandler(... rest) : void
      {
         if("确定" == rest[0])
         {
            new Message("onclickmap",1013).sendToChannel("bigmap");
         }
      }
      
      private function checkSign() : void
      {
         var dx:Number = x - this.master.x;
         var dy:Number = y - this.master.y + 61;
         var radius:Number = Math.sqrt(dx * dx + dy * dy);
         if(radius < 40)
         {
            this.master.stop();
            MapView.instance.removeTimerListener(this.checkSign);
            ApplicationFacade.getInstance().dispatch(EventConst.ROLEMOVE,{
               "newx":this.master.x,
               "newy":this.master.y
            });
            new Message("onclickdoor",{"id":this.nextPlaceID}).sendToChannel("itemclick");
         }
      }
      
      private function onRollOverIt(evt:MouseEvent) : void
      {
         ui["bClip"].visible = true;
         ui["sighTxt"].visible = true;
      }
      
      private function onRollOutIt(evt:MouseEvent) : void
      {
         ui["bClip"].visible = false;
         ui["sighTxt"].visible = false;
      }
      
      public function build(param:XML) : void
      {
         if(param != null)
         {
            this.x = param.@x;
            this.y = param.@y;
            this.steerX = param.@steerX;
            this.steerY = param.@steerY;
            this.signName = ui["sighTxt"].text = param.@name;
            this.nextPlaceID = param.@nextPlaceId;
            this.spriteName = "scenedirection";
            this.dymaicY = param.@dy;
         }
      }
      
      override public function get sortY() : Number
      {
         return y + 13350 - dymaicY;
      }
      
      override public function dispos() : void
      {
         MapView.instance.removeTimerListener(this.checkSign);
         EventManager.removeEvent(MovieClip(ui),MouseEvent.MOUSE_DOWN,this.onClickSign);
         EventManager.removeEvent(MovieClip(ui),MouseEvent.ROLL_OVER,this.onRollOverIt);
         EventManager.removeEvent(MovieClip(ui),MouseEvent.ROLL_OUT,this.onRollOutIt);
         super.dispos();
      }
   }
}

