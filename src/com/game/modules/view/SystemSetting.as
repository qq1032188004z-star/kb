package com.game.modules.view
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.global.GlobalConfig;
   import com.game.locators.GameData;
   import com.game.locators.MsgDoc;
   import com.game.manager.AlertManager;
   import com.game.util.DelayShowUtil;
   import com.game.util.HLoaderSprite;
   import com.game.util.SceneSoundManager;
   import com.publiccomponent.loading.GreenLoading;
   import flash.display.MovieClip;
   import flash.display.StageQuality;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import org.green.server.manager.SocketManager;
   import sound.SoundManager;
   
   public class SystemSetting extends HLoaderSprite
   {
      
      private var systemClip:MovieClip;
      
      private var tid:int;
      
      private var musicMaxXCoord:Number = 230;
      
      private var musicMinXCoord:Number = 32;
      
      private var lastStageQuality:String;
      
      private var currentStageQuality:String;
      
      private var lastbgMusicVolumnCoord:Number;
      
      private var currentbgMusicVolumnCoord:Number;
      
      private var lastMusicVolumnCoord:Number;
      
      private var currentMusicVolumnCoord:Number;
      
      private var curSpeed:int;
      
      private var _oldSpeed:int;
      
      private var _oldShow:int;
      
      private var _oldVipAutoShow:int;
      
      private var _oldHideBeibei:int;
      
      private var _isDragBall:Boolean = false;
      
      private var flag:int;
      
      public function SystemSetting()
      {
         super();
         GreenLoading.loading.visible = true;
         this.lastStageQuality = this.currentStageQuality = GlobalConfig.getCurQuality();
         this.currentbgMusicVolumnCoord = this.lastbgMusicVolumnCoord = this.musicMinXCoord + (this.musicMaxXCoord - this.musicMinXCoord) * SoundManager.instance.bgMusucVolumn;
         this.currentMusicVolumnCoord = this.lastMusicVolumnCoord = this.musicMinXCoord + (this.musicMaxXCoord - this.musicMinXCoord) * SoundManager.instance.effectMusicVolumn;
         this.url = "assets/material/systemsetting.swf";
      }
      
      override public function setShow() : void
      {
         this.systemClip = this.bg;
         if(this.systemClip != null)
         {
            this.systemClip.changeClip.gotoAndStop(1);
            this.systemClip.panelClip.gotoAndStop(1);
            addChild(this.systemClip);
            this.tid = setTimeout(this.delayRegister,50);
            if([1,2,3].indexOf(GlobalConfig.COMBAT_GAP_TIME) != -1)
            {
               this.curSpeed = GlobalConfig.COMBAT_GAP_TIME;
            }
            else
            {
               this.curSpeed = 1;
            }
            this._oldSpeed = this.curSpeed;
            this._oldShow = GlobalConfig.is_show_restraint;
            this._oldVipAutoShow = GlobalConfig.is_vip_auto_recover;
            this._oldHideBeibei = GlobalConfig.is_hide_beibei;
            this.initEvent();
         }
         GreenLoading.loading.visible = false;
      }
      
      private function initEvent() : void
      {
         this.addEventListener(Event.ADDED_TO_STAGE,this.onAddToStage);
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoveFromStage);
         this.systemClip.huaBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.onChange);
         this.systemClip.musicBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.onChange);
         this.systemClip.combatBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.onChange);
         this.systemClip.closeBtn.addEventListener(MouseEvent.CLICK,this.closeWindow);
         this.systemClip.cancelBtn.addEventListener(MouseEvent.CLICK,this.closeWindow);
         this.systemClip.sureBtn.addEventListener(MouseEvent.CLICK,this.save);
         if(Boolean(stage))
         {
            stage.addEventListener(MouseEvent.MOUSE_UP,this.onStageMouseUp);
         }
      }
      
      private function onAddToStage(evt:Event) : void
      {
         if(Boolean(stage))
         {
            stage.addEventListener(MouseEvent.MOUSE_UP,this.onStageMouseUp);
         }
         this.currentStageQuality = this.lastStageQuality;
         this.currentbgMusicVolumnCoord = this.lastbgMusicVolumnCoord;
         this.currentMusicVolumnCoord = this.lastMusicVolumnCoord;
         this.tid = setTimeout(this.delayRegister,50);
         if([1,2,3].indexOf(GlobalConfig.COMBAT_GAP_TIME) != -1)
         {
            this.curSpeed = GlobalConfig.COMBAT_GAP_TIME;
         }
         else
         {
            this.curSpeed = 1;
         }
         this.systemClip.panelClip.gotoAndStop(1);
      }
      
      private function onRemoveFromStage(evt:Event) : void
      {
         GlobalConfig.is_show_restraint = this._oldShow;
         GlobalConfig.is_vip_auto_recover = this._oldVipAutoShow;
         GlobalConfig.is_hide_beibei = this._oldHideBeibei;
         this.curSpeed = this._oldSpeed;
         SocketManager.getGreenSocket().sendCmd(MsgDoc.OP_CLIENT_ACTIVITY_QINGYANG.send,405,[2,this.curSpeed,int(this.coordTransToVolumn(this.currentbgMusicVolumnCoord) * 100),int(this.coordTransToVolumn(this.currentMusicVolumnCoord) * 100),GlobalConfig.STAGE_QUALITY_ARY.indexOf(this.lastStageQuality),GlobalConfig.is_show_restraint,GlobalConfig.is_vip_auto_recover,GlobalConfig.is_hide_beibei]);
         GlobalConfig.COMBAT_GAP_TIME = this.curSpeed;
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.onStageMouseUp);
      }
      
      private function onChange(evt:MouseEvent) : void
      {
         switch(evt.currentTarget)
         {
            case this.systemClip.huaBtn:
               this.panelChange(1);
               break;
            case this.systemClip.musicBtn:
               this.panelChange(2);
               break;
            case this.systemClip.combatBtn:
               this.panelChange(3);
         }
      }
      
      private function panelChange(frame1:int) : void
      {
         this.systemClip.panelClip.gotoAndStop(frame1);
         this.systemClip.changeClip.gotoAndStop(frame1);
         this.tid = setTimeout(this.delayRegister,21);
      }
      
      private function delayRegister() : void
      {
         clearTimeout(this.tid);
         switch(this.systemClip.panelClip.currentFrame)
         {
            case 1:
               if(!this.systemClip.panelClip.leftBtn.hasEventListener(MouseEvent.MOUSE_DOWN))
               {
                  this.systemClip.panelClip.leftBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.reduceStageQuality);
               }
               if(!this.systemClip.panelClip.rightBtn.hasEventListener(MouseEvent.MOUSE_DOWN))
               {
                  this.systemClip.panelClip.rightBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.addStageQuality);
               }
               if(this.systemClip.panelClip.btnChangeBeibei != null)
               {
                  this.systemClip.panelClip.btnChangeBeibei.gotoAndStop(GlobalConfig.is_hide_beibei + 1);
               }
               if(!this.systemClip.panelClip.btnChangeBeibei.hasEventListener(MouseEvent.MOUSE_DOWN))
               {
                  this.systemClip.panelClip.btnChangeBeibei.addEventListener(MouseEvent.MOUSE_DOWN,this.onChangeBeibei);
               }
               if(Boolean(stage))
               {
                  if(this.currentStageQuality == "high")
                  {
                     stage.quality = StageQuality.HIGH;
                     this.systemClip.panelClip.ball.x = 236.7;
                  }
                  else if(this.currentStageQuality == "medium")
                  {
                     stage.quality = StageQuality.MEDIUM;
                     this.systemClip.panelClip.ball.x = 130;
                  }
                  else if(this.currentStageQuality == "low")
                  {
                     stage.quality = StageQuality.LOW;
                     this.systemClip.panelClip.ball.x = 27.7;
                  }
               }
               break;
            case 2:
               if(!this.systemClip.panelClip.mLeftBtn.hasEventListener(MouseEvent.MOUSE_DOWN))
               {
                  this.systemClip.panelClip.mLeftBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.reduceMusicVolume);
               }
               if(!this.systemClip.panelClip.mRightBtn.hasEventListener(MouseEvent.MOUSE_DOWN))
               {
                  this.systemClip.panelClip.mRightBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.addMusicVolume);
               }
               if(!this.systemClip.panelClip.eLeftBtn.hasEventListener(MouseEvent.MOUSE_DOWN))
               {
                  this.systemClip.panelClip.eLeftBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.reduceMusicVolume);
               }
               if(!this.systemClip.panelClip.eRightBtn.hasEventListener(MouseEvent.MOUSE_DOWN))
               {
                  this.systemClip.panelClip.eRightBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.addMusicVolume);
               }
               if(!this.systemClip.panelClip.mBall.hasEventListener(MouseEvent.MOUSE_DOWN))
               {
                  this.systemClip.panelClip.mBall.buttonMode = true;
                  this.systemClip.panelClip.mBall.addEventListener(MouseEvent.MOUSE_DOWN,this.dragMBall);
               }
               if(!this.systemClip.panelClip.eBall.hasEventListener(MouseEvent.MOUSE_DOWN))
               {
                  this.systemClip.panelClip.eBall.buttonMode = true;
                  this.systemClip.panelClip.eBall.addEventListener(MouseEvent.MOUSE_DOWN,this.dragEBall);
               }
               this.systemClip.panelClip.mBall.x = this.currentbgMusicVolumnCoord;
               this.systemClip.panelClip.eBall.x = this.currentMusicVolumnCoord;
               break;
            case 3:
               if(!this.systemClip.panelClip.cleftBtn.hasEventListener(MouseEvent.MOUSE_DOWN))
               {
                  this.systemClip.panelClip.cleftBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.reduceStageCombat);
               }
               if(!this.systemClip.panelClip.crightBtn.hasEventListener(MouseEvent.MOUSE_DOWN))
               {
                  this.systemClip.panelClip.crightBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.addStageCombat);
               }
               switch(this.curSpeed)
               {
                  case 1:
                     this.systemClip.panelClip.cball.x = 27.7;
                     break;
                  case 2:
                     this.systemClip.panelClip.cball.x = 130;
                     break;
                  case 3:
                     this.systemClip.panelClip.cball.x = 236.7;
               }
               this.systemClip.panelClip.btnChangeRestraint.gotoAndStop(GlobalConfig.is_show_restraint + 1);
               if(!this.systemClip.panelClip.btnChangeRestraint.hasEventListener(MouseEvent.MOUSE_DOWN))
               {
                  this.systemClip.panelClip.btnChangeRestraint.addEventListener(MouseEvent.MOUSE_DOWN,this.onChangeRestraint);
               }
               if(GameData.instance.playerData.isVip)
               {
                  this.systemClip.panelClip.btnVipAutoRecover.gotoAndStop(GlobalConfig.is_vip_auto_recover + 1);
               }
               else
               {
                  this.systemClip.panelClip.btnVipAutoRecover.gotoAndStop(2);
               }
               if(!this.systemClip.panelClip.btnVipAutoRecover.hasEventListener(MouseEvent.MOUSE_DOWN))
               {
                  this.systemClip.panelClip.btnVipAutoRecover.addEventListener(MouseEvent.MOUSE_DOWN,this.onChangeVipAutoRecover);
               }
               if(!this.systemClip.panelClip.btnOpenVip.hasEventListener(MouseEvent.MOUSE_DOWN))
               {
                  this.systemClip.panelClip.btnOpenVip.addEventListener(MouseEvent.MOUSE_DOWN,this.onOpenVip);
               }
         }
      }
      
      private function onChangeBeibei(event:MouseEvent) : void
      {
         GlobalConfig.is_hide_beibei = 1 - GlobalConfig.is_hide_beibei;
         this.systemClip.panelClip.btnChangeBeibei.gotoAndStop(GlobalConfig.is_hide_beibei + 1);
      }
      
      private function reduceMusicVolume(evt:MouseEvent) : void
      {
         this.addEventListener(Event.ENTER_FRAME,this.reduceFrameHandler);
         if(evt.target == this.systemClip.panelClip.mLeftBtn)
         {
            this.flag = 0;
            if(this.systemClip.panelClip.mBall.x <= this.musicMinXCoord)
            {
               return;
            }
            this.systemClip.panelClip.mBall.x -= 2;
         }
         if(evt.target == this.systemClip.panelClip.eLeftBtn)
         {
            this.flag = 1;
            if(this.systemClip.panelClip.eBall.x <= this.musicMinXCoord)
            {
               return;
            }
            this.systemClip.panelClip.eBall.x -= 2;
         }
      }
      
      private function addMusicVolume(evt:MouseEvent) : void
      {
         this.addEventListener(Event.ENTER_FRAME,this.addFrameHandler);
         if(evt.target == this.systemClip.panelClip.mRightBtn)
         {
            this.flag = 2;
            if(this.systemClip.panelClip.mBall.x >= this.musicMaxXCoord)
            {
               return;
            }
            this.systemClip.panelClip.mBall.x += 2;
         }
         if(evt.target == this.systemClip.panelClip.eRightBtn)
         {
            this.flag = 3;
            if(this.systemClip.panelClip.eBall.x >= this.musicMaxXCoord)
            {
               return;
            }
            this.systemClip.panelClip.eBall.x += 2;
         }
      }
      
      private function reduceStageQuality(evt:MouseEvent) : void
      {
         if(stage.quality == "HIGH")
         {
            stage.quality = this.currentStageQuality = StageQuality.MEDIUM;
            this.systemClip.panelClip.ball.x = 130;
         }
         else if(stage.quality == "MEDIUM")
         {
            stage.quality = this.currentStageQuality = StageQuality.LOW;
            this.systemClip.panelClip.ball.x = 27.7;
         }
      }
      
      private function addStageQuality(evt:MouseEvent) : void
      {
         if(stage.quality == "LOW")
         {
            stage.quality = this.currentStageQuality = StageQuality.MEDIUM;
            this.systemClip.panelClip.ball.x = 130;
         }
         else if(stage.quality == "MEDIUM")
         {
            stage.quality = this.currentStageQuality = StageQuality.HIGH;
            this.systemClip.panelClip.ball.x = 236.7;
         }
      }
      
      private function reduceStageCombat(evt:MouseEvent) : void
      {
         if(this.curSpeed == 3)
         {
            this.curSpeed = 2;
            this.systemClip.panelClip.cball.x = 130;
         }
         else if(this.curSpeed == 2)
         {
            this.curSpeed = 1;
            this.systemClip.panelClip.cball.x = 27.7;
         }
      }
      
      private function onChangeRestraint(evt:MouseEvent) : void
      {
         GlobalConfig.is_show_restraint = 1 - GlobalConfig.is_show_restraint;
         this.systemClip.panelClip.btnChangeRestraint.gotoAndStop(GlobalConfig.is_show_restraint + 1);
      }
      
      private function onChangeVipAutoRecover(evt:MouseEvent) : void
      {
         if(GameData.instance.playerData.isVip)
         {
            GlobalConfig.is_vip_auto_recover = 1 - GlobalConfig.is_vip_auto_recover;
            this.systemClip.panelClip.btnVipAutoRecover.gotoAndStop(GlobalConfig.is_vip_auto_recover + 1);
         }
         else
         {
            AlertManager.instance.addTipAlert({
               "tip":"只有VIP才能设置哦",
               "type":1
            });
         }
      }
      
      private function onOpenVip(evt:MouseEvent) : void
      {
         ApplicationFacade.getInstance().dispatch(EventConst.OPEN_MODULE,{
            "url":"assets/vip/VipExchangeModule.swf",
            "xCoord":0,
            "yCoord":0
         });
      }
      
      private function addStageCombat(evt:MouseEvent) : void
      {
         if(this.curSpeed == 1)
         {
            this.curSpeed = 2;
            this.systemClip.panelClip.cball.x = 130;
         }
         else if(this.curSpeed == 2)
         {
            this.curSpeed = 3;
            this.systemClip.panelClip.cball.x = 236.7;
         }
      }
      
      private function onStageMouseUp(evt:MouseEvent = null) : void
      {
         if(this._isDragBall)
         {
            this._isDragBall = false;
            this.onStop();
         }
      }
      
      private function onStop(evt:MouseEvent = null) : void
      {
         if(this.systemClip.panelClip.currentFrame != 2)
         {
            return;
         }
         this.removeEventListener(Event.ENTER_FRAME,this.addFrameHandler);
         this.removeEventListener(Event.ENTER_FRAME,this.reduceFrameHandler);
         if(this.systemClip.panelClip.mBall != null)
         {
            this.currentbgMusicVolumnCoord = this.systemClip.panelClip.mBall.x;
            this.systemClip.panelClip.mBall.stopDrag();
         }
         if(this.systemClip.panelClip.eBall != null)
         {
            this.currentMusicVolumnCoord = this.systemClip.panelClip.eBall.x;
            this.systemClip.panelClip.eBall.stopDrag();
         }
         SceneSoundManager.getInstance().setBgVolumn(this.coordTransToVolumn(this.currentbgMusicVolumnCoord));
         SceneSoundManager.getInstance().effectMusicVolumn = this.coordTransToVolumn(this.currentMusicVolumnCoord);
      }
      
      private function addFrameHandler(evt:Event) : void
      {
         if(this.flag == 2)
         {
            if(this.systemClip.panelClip.mBall.x >= this.musicMaxXCoord)
            {
               return;
            }
            this.systemClip.panelClip.mBall.x += 2;
         }
         if(this.flag == 3)
         {
            if(this.systemClip.panelClip.eBall.x >= this.musicMaxXCoord)
            {
               return;
            }
            this.systemClip.panelClip.eBall.x += 2;
         }
         this.onStop();
      }
      
      private function reduceFrameHandler(evt:Event) : void
      {
         if(this.flag == 0)
         {
            if(this.systemClip.panelClip.mBall.x <= this.musicMinXCoord)
            {
               return;
            }
            this.systemClip.panelClip.mBall.x -= 2;
         }
         if(this.flag == 1)
         {
            if(this.systemClip.panelClip.eBall.x <= this.musicMinXCoord)
            {
               return;
            }
            this.systemClip.panelClip.eBall.x -= 2;
         }
         this.onStop();
      }
      
      private function dragMBall(evt:MouseEvent) : void
      {
         this.systemClip.panelClip.mBall.startDrag(false,new Rectangle(31.7,56.5,199));
         this._isDragBall = true;
      }
      
      private function dragEBall(evt:MouseEvent) : void
      {
         this.systemClip.panelClip.eBall.startDrag(false,new Rectangle(31.7,132.5,199));
         this._isDragBall = true;
      }
      
      private function save(evt:MouseEvent) : void
      {
         this.lastbgMusicVolumnCoord = this.currentbgMusicVolumnCoord;
         this.lastMusicVolumnCoord = this.currentMusicVolumnCoord;
         this.lastStageQuality = this.currentStageQuality;
         this.systemClip.changeClip.gotoAndStop(1);
         this.systemClip.panelClip.gotoAndStop(2);
         this._oldShow = GlobalConfig.is_show_restraint;
         this._oldVipAutoShow = GlobalConfig.is_vip_auto_recover;
         this._oldSpeed = this.curSpeed;
         this._oldHideBeibei = GlobalConfig.is_hide_beibei;
         if(DelayShowUtil.instance.isShowPlayer)
         {
            if(GlobalConfig.is_hide_beibei == 1)
            {
               DelayShowUtil.instance.hidePlayersBeiBei();
            }
            else
            {
               DelayShowUtil.instance.showPlayersBeiBei();
            }
         }
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
      
      private function closeWindow(evt:MouseEvent) : void
      {
         SceneSoundManager.getInstance().setBgVolumn(this.coordTransToVolumn(this.lastbgMusicVolumnCoord));
         SceneSoundManager.getInstance().effectMusicVolumn = this.coordTransToVolumn(this.lastMusicVolumnCoord);
         stage.quality = this.lastStageQuality;
         this.systemClip.changeClip.gotoAndStop(1);
         this.systemClip.panelClip.gotoAndStop(2);
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
      
      private function coordTransToVolumn(coord:Number) : Number
      {
         coord -= this.musicMinXCoord;
         var result:Number = Math.abs(coord / (this.musicMaxXCoord - this.musicMinXCoord));
         if(result > 1)
         {
            result = 1;
         }
         return result;
      }
   }
}

