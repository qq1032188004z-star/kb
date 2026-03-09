package com.game.modules.view.person
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.global.GlobalConfig;
   import com.game.locators.GameData;
   import com.game.manager.AlertManager;
   import com.game.manager.EventManager;
   import com.game.manager.MouseManager;
   import com.game.modules.action.GameSpriteAction;
   import com.game.modules.action.SwfAction;
   import com.game.modules.control.task.util.TaskUtils;
   import com.game.modules.view.MapView;
   import com.game.modules.view.collect.PersonStatus;
   import com.game.modules.view.magic.MagicSendManager;
   import com.game.modules.view.monster.GameMonster;
   import com.game.modules.view.person.label.FamilyLabel;
   import com.game.modules.view.person.label.SuperVipLabel;
   import com.game.modules.view.person.label.TitleLabel;
   import com.game.modules.view.trump.TrumpView;
   import com.game.modules.vo.HorseCheckVo;
   import com.game.modules.vo.ShowData;
   import com.game.util.BitValueUtil;
   import com.game.util.DisplayUtil;
   import com.game.util.GamePersonControl;
   import com.game.util.HorseCheck;
   import com.game.util.ShareLocalUtil;
   import com.publiccomponent.loading.MaterialLib;
   import com.publiccomponent.ui.ColorLabel;
   import com.publiccomponent.ui.FaceSprit;
   import com.publiccomponent.ui.TextArea;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.ui.MouseCursor;
   import flash.utils.clearTimeout;
   import org.dress.ui.RoleFace;
   import org.engine.frame.FrameTimer;
   import org.engine.game.AdMoveSprite;
   import org.engine.game.MoveSprite;
   
   public class GamePerson extends AdMoveSprite
   {
      
      private var nameLabel:ColorLabel;
      
      private var titleLabel:TitleLabel;
      
      private var familyLabel:FamilyLabel;
      
      private var superVipLabel:SuperVipLabel;
      
      private var msgTxt:TextArea;
      
      private var temLeave:MovieClip;
      
      public var roleFace:RoleFace;
      
      private var faceSprite:FaceSprit;
      
      private var hasSendMsg:Boolean = false;
      
      public var mm:GameMonster;
      
      public var trump:TrumpView;
      
      public var statusClip:PersonStatus;
      
      public var collectFilm:MovieClip;
      
      public var showData:ShowData;
      
      private var actionPlayer:SwfAction;
      
      public var activityAnimation:MovieClip;
      
      private var isHasPet:Boolean;
      
      private var isNewClick:Boolean;
      
      private var tid:int;
      
      private var isMoving:Boolean;
      
      private var body:int;
      
      public var yCoode:Number = 0;
      
      public var xCoode:Number = 0;
      
      public function GamePerson(value:ShowData)
      {
         this.showData = value;
         this.sequenceID = value.userId;
         this.ui = new Sprite();
         super();
         this.setSpeed(7.5);
         this.init();
      }
      
      public function addChild(display:DisplayObject) : void
      {
         Sprite(ui).addChild(display);
      }
      
      private function contains(disPlay:DisplayObject) : Boolean
      {
         return Sprite(ui).contains(disPlay);
      }
      
      private function addChildAt(display:DisplayObject, index:int = 0) : void
      {
         Sprite(ui).addChildAt(display,index);
      }
      
      private function removeChild(display:DisplayObject) : void
      {
         if(display != null && Sprite(ui).contains(display))
         {
            Sprite(ui).removeChild(display);
         }
         display = null;
      }
      
      public function init() : void
      {
         this.nameLabel = new ColorLabel(0,30);
         this.nameLabel.mouseEnabled = false;
         this.nameLabel.mouseChildren = false;
         this.roleFace = new RoleFace();
         this.addChild(this.roleFace);
         this.addChild(this.nameLabel);
         if(this.showData.userId == -1)
         {
            this.spriteName = "机舱小助手";
            this.roleFace.setBody(-1);
            this.nameLabel.x = 35;
            FrameTimer.getInstance().addCallBack(this.render);
         }
         else
         {
            this.spriteName = this.showData.userName;
            this.initZRoleFace();
         }
         this.updateSuperVipLabel();
         this.updateShowTilte();
         this.updateFamilyLabel();
         EventManager.attachEvent(this.roleFace,MouseEvent.MOUSE_DOWN,this.onClickPerson);
         EventManager.attachEvent(this.roleFace,Event.COMPLETE,this.onRofaceLoaded);
      }
      
      public function updateSuperVipLabel() : void
      {
         if(this.showData.isSupertrump)
         {
            this.superVipLabel = new SuperVipLabel();
            this.addChild(this.superVipLabel);
         }
         this.updateXYLabel();
      }
      
      public function updateFamilyLabel() : void
      {
         if(this.showData.isShowFamily && this.showData.familyId > 0)
         {
            if(this.familyLabel == null)
            {
               this.familyLabel = new FamilyLabel(0,0);
               this.addChild(this.familyLabel);
            }
            this.familyLabel.build({
               "id":this.showData.familyId,
               "name":this.showData.familyAllName
            });
         }
         else
         {
            this.delFamilyLabel();
         }
         this.updateXYLabel();
      }
      
      public function updateShowTilte() : void
      {
         if(this.showData.titleIndex > 0)
         {
            if(this.titleLabel == null)
            {
               this.titleLabel = new TitleLabel(0,0);
               this.addChild(this.titleLabel);
            }
            this.titleLabel.build(this.showData.titleIndex);
         }
         else
         {
            this.delTitleLabel();
         }
         this.updateXYLabel();
      }
      
      private function updateXYLabel() : void
      {
         var tp:int = 0;
         var offsetList:Array = null;
         if(this.showData.horseID != 0 && (!GamePersonControl.instance.isFlyIngHorse(this.showData.horseID) || GamePersonControl.instance.isFlyIngAndChangeHorse(this.showData.horseID)))
         {
            offsetList = GamePersonControl.instance.getStatusOffset(this.showData.horseID);
            tp = offsetList[1] + 70;
         }
         else
         {
            tp = -115;
         }
         if(Boolean(this.titleLabel))
         {
            this.titleLabel.y = tp;
            tp -= 20;
         }
         if(Boolean(this.familyLabel))
         {
            this.familyLabel.y = tp;
            tp -= 20;
         }
         if(Boolean(this.superVipLabel))
         {
            this.superVipLabel.y = tp - 10;
         }
      }
      
      public function hideLabel() : void
      {
         if(Boolean(this.titleLabel))
         {
            this.titleLabel.visible = false;
         }
         if(Boolean(this.familyLabel))
         {
            this.familyLabel.visible = false;
         }
      }
      
      public function showLabel() : void
      {
         if(Boolean(this.titleLabel))
         {
            this.titleLabel.visible = true;
         }
         if(Boolean(this.familyLabel))
         {
            this.familyLabel.visible = true;
         }
      }
      
      public function delTitleLabel() : void
      {
         if(Boolean(this.titleLabel))
         {
            this.titleLabel.disport();
            this.titleLabel = null;
         }
      }
      
      public function delFamilyLabel() : void
      {
         if(Boolean(this.familyLabel))
         {
            this.familyLabel.disport();
            this.familyLabel = null;
         }
      }
      
      private function initZRoleFace() : void
      {
         var sex:int = this.showData.roleType & 1;
         if(sex >= 1 || sex < 0)
         {
            sex = 1;
         }
         sex *= 10;
         var color:int = this.showData.roleType >> 1;
         if(color > 3 || color < 1)
         {
            color = 1;
         }
         this.body = 1000 + sex + color;
         if(GamePersonControl.instance.isInSpecialSceneList())
         {
            this.showData.moveFlag = 2;
            this.roleFace.setBody(-3);
         }
         else if(this.showData.isInChange != 0 && this.showData.bodyID != 0)
         {
            this.roleFace.setBody(this.showData.bodyID);
            this.showData.moveFlag = 1;
         }
         else
         {
            this.showData.isInChange = 0;
            this.showData.bodyID = 0;
            this.showData.moveFlag = 1;
            if(this.showData.horseID != 0)
            {
               if(GamePersonControl.instance.isFlyIngHorse(this.showData.horseID) && !GamePersonControl.instance.isFlyIngAndChangeHorse(this.showData.horseID))
               {
                  if(this.showData.taozhuangId != 0)
                  {
                     this.roleFace.setBody(this.showData.taozhuangId);
                  }
                  else
                  {
                     this.roleFace.setBody(this.body);
                  }
                  this.updateDress(this.showData,true);
               }
               this.setHorse(this.showData.horseSpeed,this.showData.horseIndex,this.showData.horseID);
            }
            else
            {
               if(!GamePersonControl.instance.isFlyIngAndChangeHorse(this.showData.horseID))
               {
                  if(this.showData.taozhuangId != 0)
                  {
                     this.roleFace.setBody(this.showData.taozhuangId);
                  }
                  else
                  {
                     this.roleFace.setBody(this.body);
                  }
                  this.updateDress(this.showData,true);
               }
               if(GamePersonControl.instance.isFlyIngHorse(this.showData.horseID))
               {
                  this.setHorse(this.showData.horseSpeed,this.showData.horseIndex,this.showData.horseID);
               }
            }
         }
         if(!FrameTimer.getInstance().hasCallBack(this.render))
         {
            FrameTimer.getInstance().addCallBack(this.render);
         }
         if(this.showData.playerStatus == 7)
         {
            this.yCoode = 70;
            this.xCoode = 0;
            this.playStatus = "temLeave";
         }
         this.updateXYLabel();
         this.removeStatus();
      }
      
      public function updateDress(params:Object, forceUpdates:Boolean = false) : void
      {
         if(GamePersonControl.instance.isInSpecialSceneList())
         {
            return;
         }
         if(this.showData.moveFlag > 1 || this.showData.isInChange != 0)
         {
            if(!GamePersonControl.instance.isFlyIngHorse(this.showData.horseID) || GamePersonControl.instance.isFlyIngAndChangeHorse(this.showData.horseID))
            {
               return;
            }
         }
         if(this.showData.horseID != 0)
         {
            if(!GamePersonControl.instance.isFlyIngHorse(this.showData.horseID) || GamePersonControl.instance.isFlyIngAndChangeHorse(this.showData.horseID))
            {
               return;
            }
         }
         this.showData.updateDress(params);
         var sex:int = this.showData.roleType & 1;
         sex *= 10;
         var color:int = this.showData.roleType >> 1;
         if(color > 3 || color < 1)
         {
            color = 1;
         }
         this.body = 1000 + sex + color;
         if(this.showData.taozhuangId != 0)
         {
            this.roleFace.clear();
            this.roleFace.setRole(this.showData);
            if(GamePersonControl.instance.isFlyIngHorse(this.showData.horseID))
            {
               this.roleFace.setPet(this.showData.horseID);
            }
         }
         else
         {
            this.roleFace.setBody(this.body);
            GamePersonControl.instance.updateRoleFace(this.roleFace,sex,params,forceUpdates);
         }
         if(GameData.instance.firstEnterScene && GlobalConfig.userId == this.showData.userId)
         {
            params.body = this.body;
            params.roleType = this.showData.roleType;
            ShareLocalUtil.instance.saveSelfDate(GlobalConfig.userName,params);
         }
         this.updateXYLabel();
      }
      
      public function cancelChange(params:Object) : void
      {
         this.setSpeed(7.5);
         this.showData.roleType = params.roleType;
         this.showData.isInChange = 0;
         this.showData.bodyID = 0;
         if(this.showData.moveFlag > 1 || this.showData.isInChange != 0)
         {
            return;
         }
         this.showData.updateDress(params);
         this.initZRoleFace();
         if(Boolean(this.roleFace))
         {
            this.roleFace.x = 0;
         }
      }
      
      private function onRofaceLoaded(evt:Event) : void
      {
         this.roleFace.render(direction,4);
         this.updateBodyOffset();
      }
      
      public function setDirection(dir:int) : void
      {
         if(Boolean(this.roleFace))
         {
            this.direction = this.roleFace.direction = dir;
            this.roleFace.render(direction,4);
         }
      }
      
      private function setSpeed($speed:Number) : void
      {
         this.speed = $speed;
      }
      
      public function changeBody(id:int, callBack:Function) : void
      {
         this.actionRemove();
         this.showData.bodyID = id;
         if(Boolean(this.roleFace))
         {
            this.stop();
            this.roleFace.changeBody(id,false,callBack);
            this.updateBodyOffset();
         }
      }
      
      public function backToInitRoleFace(callBack:Function) : void
      {
         if(Boolean(this.roleFace))
         {
            if(this.showData.taozhuangId != 0)
            {
               this.roleFace.changeBody(this.showData.taozhuangId,true,callBack);
            }
            else
            {
               this.roleFace.changeBody(this.body,true,callBack);
            }
         }
      }
      
      public function setPeronName(value:String) : void
      {
         this.spriteName = value;
         if(this.nameLabel != null)
         {
            this.nameLabel.text = value;
            if(this.showData.isVip)
            {
               this.nameLabel.txtFilter();
            }
         }
         if(Boolean(this.trump) && Boolean(this.trump.params))
         {
            this.trump.params = this.showData;
         }
      }
      
      public function setNameFilter(value:*) : void
      {
         if(Boolean(this.nameLabel))
         {
            this.nameLabel.txtFilter(value);
         }
      }
      
      public function onClickPerson(event:MouseEvent) : void
      {
         var params:Object = null;
         if(this.showData.userId == GlobalConfig.userId && GameData.instance.playerData.isNewHand < 9)
         {
            return;
         }
         if(GameData.instance.cantClickPerson)
         {
            return;
         }
         if(MouseManager.getInstance().cursorName == "CursorTool2001" && GameData.instance.playerData.sceneId == 8001 && GameData.instance.playerData.fireCurrentPerson == this.showData.userId)
         {
            ApplicationFacade.getInstance().dispatch(EventConst.FIRE_IMMORAL_VIEW,{
               "code":4,
               "userId":GameData.instance.playerData.fireCurrentPerson
            });
            return;
         }
         if(MouseManager.getInstance().cursorName == "CursorTool3001")
         {
            ApplicationFacade.getInstance().dispatch(EventConst.BLACKTOWERCLICKPERSON,{
               "userId":this.showData.userId,
               "tx":this.x,
               "ty":this.y
            });
            return;
         }
         if(GameData.instance.playerData.fireMosueCurse == "CursorTool8001" && GameData.instance.playerData.sceneId == 8001 && GameData.instance.playerData.fireCurrentPerson == GameData.instance.playerData.userId)
         {
            ApplicationFacade.getInstance().dispatch(EventConst.FIRE_IMMORAL_VIEW,{
               "userId":this.showData.userId,
               "code":2,
               "toX":this.x,
               "toY":this.y
            });
            event.stopImmediatePropagation();
            return;
         }
         if(MouseManager.getInstance().cursorName == "CursorTool2001" && GameData.instance.playerData.giantId == this.showData.userId)
         {
            if(!TaskUtils.getInstance().hasEventListener("opmouseactionai"))
            {
               TaskUtils.getInstance().addEventListener("opmouseactionai",this.onActionToShootGiant);
            }
         }
         var giant:* = MapView.instance.findGameSprite(201211002);
         if(giant && giant.MasterID == GameData.instance.playerData.userId)
         {
            if(!GamePersonControl.instance.isFlyIngHorse(this.showData.horseID) && this.sequenceID != GameData.instance.playerData.userId)
            {
               giant.FireData = this.showData;
            }
            return;
         }
         if(!this.roleFace.getIsMouseEnable(event.stageX,event.stageY))
         {
            return;
         }
         event.stopImmediatePropagation();
         if(this.sequenceID == -1)
         {
            ApplicationFacade.getInstance().dispatch(EventConst.NEWHANDSTART);
            return;
         }
         GameData.instance.friendData.userId = this.sequenceID;
         var cursorName:String = MouseManager.getInstance().cursorName;
         if(cursorName == null || cursorName.length == 0 || cursorName == "auto" || cursorName == MouseCursor.BUTTON)
         {
            if(this.sequenceID != GlobalConfig.userId)
            {
               ApplicationFacade.getInstance().dispatch(EventConst.OPENPERSONINFOVIEW,{
                  "userId":this.sequenceID,
                  "isOnline":1,
                  "source":0,
                  "userName":this.spriteName,
                  "sex":this.showData.roleType & 1
               });
            }
            else
            {
               ApplicationFacade.getInstance().dispatch(EventConst.OPENPERSONDETAILVIEW,{
                  "userId":this.sequenceID,
                  "isOnline":1,
                  "source":0,
                  "userName":this.spriteName,
                  "sex":this.showData.roleType & 1,
                  "body":this.showData
               });
            }
         }
         else
         {
            if(cursorName.substr(0,12) == "CursorTool20")
            {
               params = {};
               params.actionid = int(cursorName.slice(13,cursorName.length));
               if((params.actionid >= 100 || params.actionid == 14) && GamePersonControl.instance.isFlyIngHorse(this.showData.horseID))
               {
                  if(params.actionid >= 100)
                  {
                     AlertManager.instance.showTipAlert({
                        "systemid":1069,
                        "flag":1
                     });
                  }
                  else
                  {
                     AlertManager.instance.showTipAlert({
                        "systemid":1069,
                        "flag":2
                     });
                  }
               }
               else
               {
                  params.destx = this.x;
                  params.desty = this.y - this.roleFace.height / 2;
                  params.destid = this.sequenceID;
                  ApplicationFacade.getInstance().dispatch(EventConst.SENDACTION,params);
               }
            }
            MouseManager.getInstance().setCursor("");
         }
      }
      
      private function onActionToShootGiant(evt:Event) : void
      {
         TaskUtils.getInstance().removeEventListener("opmouseactionai",this.onActionToShootGiant);
         ApplicationFacade.getInstance().dispatch("GiantSprite_ReqState",this.showData.userId);
      }
      
      public function update(params:ShowData) : void
      {
         this.showData = params;
         this.showData.moveFlag = 1;
         this.sequenceID = params.userId;
         this.spriteName = params.userName;
         this.updateNameBorder(this.showData.nameBorderId);
         this.showData.x = this.x;
         this.showData.y = this.y;
         if(GamePersonControl.instance.isInPetArearList())
         {
            this.setPet(GamePersonControl.instance.getPetId());
         }
         else if(GamePersonControl.instance.isInSpecialSceneList())
         {
            this.showData.moveFlag = 2;
         }
         else
         {
            if(GamePersonControl.instance.isFlyIngHorse(this.showData.horseID))
            {
               this.showData.moveFlag = 2;
            }
            this.updataMM();
         }
         this.updataFabao();
      }
      
      public function updataxy(x:int, y:int) : void
      {
         if(this.showData == null)
         {
            return;
         }
         this.x = this.showData.x = x;
         this.y = this.showData.y = y;
         this.update(this.showData);
         if(Boolean(this.mm))
         {
            this.mm.stop();
         }
         if(Boolean(this.trump))
         {
            this.trump.stop();
         }
      }
      
      public function updateNameBorder(id:int) : void
      {
         if(this.nameLabel != null)
         {
            this.showData.nameBorderId = this.nameLabel.setBorder(this.showData.nameBorderId,id);
            this.nameLabel.text = this.showData.userName;
            if(this.showData.isVip)
            {
               this.nameLabel.txtFilter();
            }
            if(this.showData.familyName != null && this.showData.familyName.length != 0)
            {
               this.nameLabel.setFlag(this.showData.familyName);
            }
         }
      }
      
      public function updateFlagName(str:String) : void
      {
         this.showData.familyName = str;
         if(this.nameLabel != null)
         {
            this.nameLabel.setFlag(str);
         }
      }
      
      public function releaseFabao() : void
      {
         this.reTakeFabao();
         if(this.showData.userId != GlobalConfig.userId && GlobalConfig.is_hide_beibei == 1)
         {
            return;
         }
         if(this.sequenceID == GameData.instance.playerData.houseId)
         {
            ApplicationFacade.getInstance().dispatch(EventConst.REMOVETRUMP);
         }
         this.trump = new TrumpView();
         this.trump.master = this;
         if(this.showData.userId == GlobalConfig.userId)
         {
            GameData.instance.playerData.trumpstate = 1;
         }
         this.trump.setTrump(this.showData);
         this.fabaoPosition();
         if(Boolean(scene))
         {
            scene.add(this.trump);
         }
         this.addFollower(this.trump);
         if(GamePersonControl.instance.isFlyIngHorse(this.showData.horseID))
         {
            this.trump.dymaicY = 220;
         }
         else
         {
            this.trump.dymaicY = 100;
         }
      }
      
      public function updataFabao() : void
      {
         if(this.showData.isVip || this.showData.userId == GameData.instance.playerData.userId)
         {
            if(this.showData.state == 2 || this.showData.state == 3)
            {
               this.releaseFabao();
            }
            else if(this.showData.state == 1)
            {
               this.reTakeFabao();
            }
         }
      }
      
      public function fabaoPosition() : void
      {
         if(this.trump != null)
         {
            this.trump.x = this.trump.master.x + 1;
            this.trump.y = this.trump.master.y + 1;
         }
      }
      
      public function reTakeFabao() : void
      {
         if(this.trump != null && this.showData != null)
         {
            if(this.showData.userId == GlobalConfig.userId)
            {
               GameData.instance.playerData.trumpstate = -1;
            }
            if(this.sequenceID == GameData.instance.playerData.houseId)
            {
               ApplicationFacade.getInstance().dispatch(EventConst.TRUMPBACK,this.showData);
            }
            if(Boolean(scene))
            {
               scene.remove(this.trump);
            }
            this.removeFollower(this.trump);
            this.trump.master = null;
            this.trump.dispos();
            this.trump = null;
         }
      }
      
      public function updataMM() : void
      {
         this.retakeMM();
         if(this.showData.mid > 0 && (this.showData.mstate == 1 && this.showData.moveFlag <= 1 || GamePersonControl.instance.isFlyIngHorse(this.showData.horseID)))
         {
            this.mm = new GameMonster(this.showData);
            this.mm.update(this.showData);
            if(Boolean(scene))
            {
               scene.add(this.mm);
            }
            this.mm.x = x;
            this.mm.y = y;
            this.addFollower(this.mm);
         }
      }
      
      public function retakeMM() : void
      {
         if(this.mm != null)
         {
            scene.removeByName(this.mm.spriteName);
            this.removeFollower(this.mm);
            this.mm = null;
         }
      }
      
      public function addPersonFollower(role:GamePerson) : void
      {
         var index:int = int(GameData.instance.playerData.followerList.indexOf(role.showData));
         if(index == -1)
         {
            super.addFollower(role);
            GameData.instance.playerData.followerList.push(role.showData);
         }
      }
      
      public function removePersonFollower(role:GamePerson) : void
      {
         var index:int = int(GameData.instance.playerData.followerList.indexOf(role.showData));
         if(index != -1)
         {
            super.removeFollower(role);
            GameData.instance.playerData.followerList.splice(index,1);
         }
      }
      
      public function updatePersonFollwer() : void
      {
         var showParams:ShowData = null;
         var followerPerson:GamePerson = null;
         var personFollowerList:Array = GameData.instance.playerData.followerList;
         for each(showParams in personFollowerList)
         {
            followerPerson = new GamePerson(showParams);
            if(Boolean(scene))
            {
               scene.add(followerPerson);
               followerPerson.x = x;
               followerPerson.y = y;
               super.addFollower(followerPerson);
            }
            followerPerson.update(showParams);
         }
      }
      
      public function set msg(content:String) : void
      {
         var offsetList:Array = null;
         if(Boolean(this.msgTxt))
         {
            this.msgTxt.clear();
         }
         if(this.sequenceID == -1)
         {
            this.msgTxt = new TextArea(100,-20);
         }
         else if(this.showData.horseID != 0 && (!GamePersonControl.instance.isFlyIngHorse(this.showData.horseID) || GamePersonControl.instance.isFlyIngAndChangeHorse(this.showData.horseID)))
         {
            offsetList = GamePersonControl.instance.getMsgOffset(this.showData.horseID);
            this.msgTxt = new TextArea(offsetList[0],offsetList[1]);
         }
         else
         {
            this.msgTxt = new TextArea(60,-40);
         }
         if(Boolean(this.faceSprite))
         {
            this.faceSprite.clear();
         }
         this.faceSprite = null;
         this.addChild(this.msgTxt);
         if(Boolean(content) && content.length > 60)
         {
            content = content.substr(0,60);
         }
         this.msgTxt.text = content;
      }
      
      public function set playStatus(str:String) : void
      {
         var offsetList:Array = null;
         if(Boolean(this.statusClip))
         {
            this.statusClip.clear();
            if(Boolean(this.statusClip.parent))
            {
               this.statusClip.parent.removeChild(this.statusClip);
            }
         }
         var $x:Number = -20;
         if(str == "temLeave")
         {
            if(Boolean(this.titleLabel))
            {
               this.yCoode -= 20;
            }
            if(Boolean(this.familyLabel))
            {
               this.yCoode -= 20;
            }
            this.showLabel();
            $x = 0;
         }
         else
         {
            $x = -20;
            this.hideLabel();
         }
         if(this.showData.horseID != 0 && (!GamePersonControl.instance.isFlyIngHorse(this.showData.horseID) || GamePersonControl.instance.isFlyIngAndChangeHorse(this.showData.horseID)))
         {
            offsetList = GamePersonControl.instance.getStatusOffset(this.showData.horseID);
            this.statusClip = new PersonStatus(offsetList[0],offsetList[1] + this.yCoode);
         }
         else
         {
            this.statusClip = new PersonStatus($x - this.xCoode,-185 + this.yCoode);
         }
         this.addChild(this.statusClip);
         this.statusClip.setStatus(str,this.showData);
      }
      
      public function removeStatus() : void
      {
         FrameTimer.getInstance().removeCallBack(this.removeStatus);
         this.yCoode = 0;
         this.xCoode = 0;
         this.showLabel();
         if(this.statusClip != null)
         {
            this.statusClip.clear();
            if(Boolean(this.statusClip.parent))
            {
               this.removeChild(this.statusClip);
            }
         }
      }
      
      public function setCollectBar() : void
      {
         var offsetList:Array = null;
         if(Boolean(this.collectFilm))
         {
            this.collectFilm.stop();
            if(this.contains(this.collectFilm))
            {
               this.removeChild(this.collectFilm);
            }
            this.collectFilm = null;
         }
         this.collectFilm = MaterialLib.getInstance().getMaterial("bar") as MovieClip;
         this.collectFilm.width = 100;
         this.collectFilm.height = 15;
         if(this.showData.horseID != 0 && (!GamePersonControl.instance.isFlyIngHorse(this.showData.horseID) || GamePersonControl.instance.isFlyIngAndChangeHorse(this.showData.horseID)))
         {
            offsetList = GamePersonControl.instance.getCollectOffset(this.showData.horseID);
            this.collectFilm.x = offsetList[0];
            this.collectFilm.y = offsetList[1];
         }
         else
         {
            this.collectFilm.x = -47;
            this.collectFilm.y = -106;
         }
         this.addChild(this.collectFilm);
         this.collectFilm.gotoAndPlay(2);
      }
      
      public function removeCollectBar() : void
      {
         if(this.collectFilm != null)
         {
            this.collectFilm.stop();
            this.collectFilm.addFrameScript(this.collectFilm.totalFrames - 1,null);
            if(Boolean(this.collectFilm.parent))
            {
               this.removeChild(this.collectFilm);
            }
         }
      }
      
      public function set face(faceId:int) : void
      {
         var offsetList:Array = null;
         if(Boolean(this.msgTxt))
         {
            this.msgTxt.clear();
         }
         this.msgTxt = null;
         if(Boolean(this.faceSprite))
         {
            this.faceSprite.clear();
         }
         if(this.showData.horseID != 0 && (!GamePersonControl.instance.isFlyIngHorse(this.showData.horseID) || GamePersonControl.instance.isFlyIngAndChangeHorse(this.showData.horseID)))
         {
            offsetList = GamePersonControl.instance.getFaceOffset(this.showData.horseID);
            this.faceSprite = new FaceSprit(offsetList[0],offsetList[1]);
         }
         else
         {
            this.faceSprite = new FaceSprit(-25,-130);
         }
         this.addChild(this.faceSprite);
         this.faceSprite.setFace(faceId);
      }
      
      public function clearAllState() : void
      {
         if(Boolean(this.msgTxt))
         {
            this.msgTxt.clear();
         }
         this.msgTxt = null;
         if(Boolean(this.faceSprite))
         {
            this.faceSprite.clear();
         }
         this.faceSprite = null;
         this.removeCollectBar();
         this.removeStatus();
         this.actionRemove();
      }
      
      public function playAction() : void
      {
         var moveSprite:MoveSprite = null;
         this.actionRemove();
         for each(moveSprite in this.followers)
         {
            moveSprite["stop"]();
         }
         this.runner.stop();
         this.roleFace.setState(RoleFace.ACTIONSTATE);
      }
      
      override public function get sortY() : Number
      {
         return this.y + dymaicY;
      }
      
      override public function dispos() : void
      {
         var moveSprite:MoveSprite = null;
         clearTimeout(this.tid);
         this.delTitleLabel();
         this.delFamilyLabel();
         if(Boolean(this.actionPlayer))
         {
            this.actionPlayer.dispos();
         }
         if(Boolean(this.superVipLabel))
         {
            this.superVipLabel.dispose();
         }
         this.actionPlayer = null;
         this.showData = null;
         this.reTakeFabao();
         this.retakeMM();
         DisplayUtil.dispos([this.nameLabel,this.msgTxt,this.faceSprite]);
         if(this.statusClip != null)
         {
            this.statusClip.dispos();
         }
         this.statusClip = null;
         if(this.roleFace != null)
         {
            EventManager.removeEvent(this.roleFace,MouseEvent.MOUSE_DOWN,this.onClickPerson);
            EventManager.removeEvent(this.roleFace,Event.COMPLETE,this.onRofaceLoaded);
            this.roleFace.dispos();
         }
         this.roleFace = null;
         for each(moveSprite in followers)
         {
            moveSprite.dispos();
         }
         FrameTimer.getInstance().removeCallBack(this.render);
         FrameTimer.getInstance().removeCallBack(this.checkPosition,1);
         this.removeCollectBar();
         if(ui != null)
         {
            while(Boolean(Sprite(ui).numChildren))
            {
               Sprite(ui).removeChildAt(0);
            }
         }
         super.dispos();
      }
      
      override public function moveto(destx:int, desty:int, onArrive:Function = null, moveFlag:int = 1) : Boolean
      {
         if(Boolean(this.showData))
         {
            if(this.showData.userId == GameData.instance.playerData.userId)
            {
               if(Boolean(GameData.instance.playerData.magicStatus))
               {
                  switch(GameData.instance.playerData.magicStatus)
                  {
                     case 14:
                        AlertManager.instance.showTipAlert({
                           "systemid":1049,
                           "flag":9
                        });
                        break;
                     case 26:
                        AlertManager.instance.showTipAlert({
                           "systemid":1049,
                           "flag":15
                        });
                        break;
                     case 29:
                        AlertManager.instance.showTipAlert({
                           "systemid":1049,
                           "flag":16
                        });
                  }
                  return false;
               }
            }
            destx *= GameData.instance.scaleStep;
            desty *= GameData.instance.scaleStep;
            if(Boolean(this.actionPlayer) || this.showData.horseID == 0)
            {
               this.actionRemove();
            }
            if(Math.abs(this.x - destx) < 16 && Math.abs(this.y - desty) < 10)
            {
               if(onArrive != null)
               {
                  onArrive();
                  this.isNewClick = true;
                  return true;
               }
            }
            if(super.moveto(destx,desty,onArrive,this.showData.moveFlag))
            {
               this.isNewClick = true;
               ApplicationFacade.getInstance().dispatch(EventConst.ACTIVITY_BALL_MOVE,{
                  "userId":this.showData.userId,
                  "newx":destx,
                  "newy":desty
               });
               return true;
            }
            if(onArrive != null)
            {
               onArrive();
               this.isNewClick = true;
               return true;
            }
         }
         return false;
      }
      
      override public function onGo() : void
      {
         this.isMoving = true;
         if(this.roleFace == null)
         {
            return;
         }
         if(this.roleFace.currentState != RoleFace.MOVESTATE)
         {
            this.roleFace.setState(RoleFace.MOVESTATE);
         }
         if(this.isHasPet)
         {
            this.roleFace.setState(RoleFace.PETSTATE);
         }
         if(this.showData.userId == GlobalConfig.userId)
         {
            FrameTimer.getInstance().addCallBack(this.checkPosition,1);
         }
      }
      
      override public function onStop() : void
      {
         this.isMoving = false;
         FrameTimer.getInstance().removeCallBack(this.checkPosition,1);
         if(this.roleFace != null)
         {
            this.roleFace.setState(RoleFace.STOPSTATE);
         }
      }
      
      public function turnTo(xCoord:Number, yCoord:Number) : void
      {
         if(this.roleFace.currentState == RoleFace.ACTIONSTATE)
         {
            return;
         }
         if(!this.isMoving && GameData.instance.playerData.bobOwner == 0)
         {
            this.beforeGo(xCoord,yCoord);
         }
      }
      
      public function stop(isfollowersStop:Boolean = false) : void
      {
         var moveSprite:MoveSprite = null;
         this.isMoving = false;
         FrameTimer.getInstance().removeCallBack(this.checkPosition,1);
         if(Boolean(this.runner))
         {
            this.runner.stop();
         }
         this.stopEaseMove();
         if(this.roleFace != null && isfollowersStop || this.sequenceID == GlobalConfig.userId)
         {
            if(this.roleFace != null)
            {
               this.roleFace.setState(RoleFace.STOPSTATE);
            }
         }
         for each(moveSprite in followers)
         {
            if(moveSprite is GamePerson)
            {
               moveSprite["stop"](isfollowersStop);
               moveSprite.stopEaseMove();
            }
            else if(isfollowersStop)
            {
               if(Boolean(moveSprite.runner))
               {
                  moveSprite.runner.stop();
               }
               moveSprite.onStop();
               moveSprite.stopEaseMove();
            }
         }
      }
      
      override public function render() : void
      {
         if(Boolean(this.roleFace))
         {
            switch(this.roleFace.currentState)
            {
               case RoleFace.MOVESTATE:
                  this.checkFollow();
                  this.roleFace.move(direction,true);
                  break;
               case RoleFace.ACTIONSTATE:
                  this.roleFace.playAction(direction);
                  break;
               case RoleFace.STOPSTATE:
                  this.roleFace.standRender(direction);
                  break;
               case RoleFace.PETSTATE:
                  this.roleFace.hasPetMove(direction);
            }
         }
      }
      
      private function checkFollow() : void
      {
         var fl:MoveSprite = null;
         var xfo:int = 0;
         var yfo:int = 0;
         var result:int = 0;
         if(Boolean(followers) && followers.length > 0)
         {
            fl = followers[0] as MoveSprite;
            xfo = this.x - fl.x;
            yfo = this.y - fl.y;
            if(dir == 6)
            {
               if(yfo < 0)
               {
                  return;
               }
            }
            if(dir == 4)
            {
               if(xfo > 0)
               {
                  return;
               }
            }
            if(dir == 0)
            {
               if(xfo < 0)
               {
                  return;
               }
            }
            if(dir == 2)
            {
               if(yfo > 0)
               {
                  return;
               }
            }
            result = Math.sqrt(xfo * xfo + yfo * yfo);
            if(result >= 40 && this.isNewClick)
            {
               this.isNewClick = false;
               if(Boolean(this.astar) && Boolean(this.astar.astarpath))
               {
                  goto(this.astar.astarpath,null);
               }
            }
         }
      }
      
      public function setHorse(sp:int, index:int, id:int) : void
      {
         this.actionRemove();
         this.showData.moveFlag = 1;
         this.isHasPet = false;
         this.nameLabel.y = 0;
         if(this.showData.isInChange == 1 && this.showData.bodyID != 0)
         {
            return;
         }
         var sex:int = this.showData.roleType & 1;
         if(sex > 1 || sex < 0)
         {
            sex = 1;
         }
         var checkHorse:HorseCheckVo = new HorseCheckVo();
         checkHorse.horseId = id;
         checkHorse.sceneId = GameData.instance.playerData.currentScenenId;
         checkHorse.objTempData = {
            "sp":sp,
            "index":index
         };
         HorseCheck.instance.checkBySceneId(checkHorse,this.checkHorseBack);
      }
      
      private function checkHorseBack(checkData:HorseCheckVo) : void
      {
         var sex:int = 0;
         var tempId:int = 0;
         var color:int = 0;
         if(this.showData != null && checkData.checkResult)
         {
            sex = this.showData.roleType & 1;
            if(sex > 1 || sex < 0)
            {
               sex = 1;
            }
            this.roleFace.x = 0;
            if(BitValueUtil.getBitValue(checkData.userState,2) || BitValueUtil.getBitValue(checkData.userState,3))
            {
               tempId = GamePersonControl.instance.getNewHorSeId(checkData.horseId,sex);
               this.roleFace.setPet(0);
               this.roleFace.clear();
               this.roleFace.changeBody(tempId,false,this.horseLoaded);
            }
            else
            {
               color = this.showData.roleType >> 1;
               if(color > 3 || color < 1)
               {
                  color = 1;
               }
               this.body = 1000 + sex * 10 + color;
               if(this.showData.taozhuangId != 0)
               {
                  this.roleFace.setBody(this.showData.taozhuangId);
               }
               else
               {
                  this.roleFace.setBody(this.body);
               }
               this.dymaicY = 150;
               this.isHasPet = true;
               this.updateDress(this.showData,true);
               this.roleFace.setPet(checkData.horseId);
            }
            if((checkData.horseState & 2) != 0 || (checkData.horseState & 4) != 0)
            {
               this.showData.moveFlag = 2;
            }
            this.nameLabel.y = GamePersonControl.instance.getYOffsetByPetId(checkData.horseId);
            this.showData.setHorseParams(checkData.objTempData.sp,checkData.horseId,checkData.objTempData.index);
            if(this.showData.userId == GlobalConfig.userId)
            {
               GameData.instance.playerData.setHorseParams(checkData.objTempData.sp,checkData.horseId,checkData.objTempData.index);
            }
            this.setSpeed(7.5 * checkData.objTempData.sp / 100);
            this.updateXYLabel();
         }
      }
      
      public function horseLoaded() : void
      {
         var offsetX:Number = GamePersonControl.instance.getOffsetX(this.showData.horseID);
         var offsetY:Number = GamePersonControl.instance.getOffsetY(this.showData.horseID);
         if(Boolean(this.roleFace))
         {
            this.roleFace.x = offsetX;
            this.roleFace.y = offsetY;
         }
      }
      
      public function cancelHorse() : void
      {
         if(Boolean(this.showData))
         {
            this.stopEaseMove();
            this.setSpeed(7.5);
            this.dymaicY = 0;
            this.nameLabel.y = 0;
            this.isHasPet = false;
            this.showData.moveFlag = 1;
            this.roleFace.setPet(0);
            if(GamePersonControl.instance.isInPetArearList())
            {
               this.setPet(GamePersonControl.instance.getPetId());
            }
            this.showData.setHorseParams(100,0,0);
            this.recoverXYCoord();
            if(Boolean(this.roleFace))
            {
               if(GameData.instance.playerData.giantId == GameData.instance.playerData.userId)
               {
                  O.o();
               }
               else
               {
                  this.roleFace.x = 0;
                  this.roleFace.y = 0;
               }
               this.updateBodyOffset();
            }
            if(this.sequenceID == GlobalConfig.userId)
            {
               GameData.instance.playerData.moveFlag = 1;
               GameData.instance.playerData.setHorseParams(100,0,0);
            }
            this.showData.horseID = 0;
            if(this.showData.isInChange == 0 && this.showData.bodyID == 0)
            {
               this.initZRoleFace();
            }
            if(this.showData.bodyID == -3)
            {
               this.showData.moveFlag = 2;
            }
         }
      }
      
      public function updateBodyOffset() : void
      {
         var obj:Object = null;
         for each(obj in MagicSendManager.offsetArr)
         {
            if(this.showData.bodyID == int(obj.id))
            {
               this.roleFace.x = int(obj.xoffset);
               this.roleFace.y = int(obj.yoffset);
               break;
            }
         }
      }
      
      private function checkPosition() : void
      {
         GameSpriteAction.instance.checkSpecialArea(this);
      }
      
      public function setPet(id:int) : void
      {
         if(!GamePersonControl.instance.isFlyIngHorse(this.showData.horseID))
         {
            this.isHasPet = true;
            this.roleFace.currentState = RoleFace.PETSTATE;
            this.roleFace.setPet(id);
         }
         else if(id != 0)
         {
            this.showData.moveFlag = 2;
         }
      }
      
      private function recoverXYCoord() : void
      {
         if(Boolean(this.msgTxt))
         {
            this.msgTxt.x = 60;
            this.msgTxt.y = -40;
         }
         if(Boolean(this.faceSprite))
         {
            this.faceSprite.x = -25;
            this.faceSprite.y = -130;
         }
         if(Boolean(this.collectFilm))
         {
            this.collectFilm.x = -47;
            this.collectFilm.y = -106;
         }
         if(Boolean(this.statusClip))
         {
            this.statusClip.x = -20;
            this.statusClip.y = -185;
         }
      }
      
      public function get bottomX() : Number
      {
         var rect:Rectangle = this.nameLabel.getRect(this.ui);
         return (rect.left + rect.right) / 2;
      }
      
      public function get bottomY() : Number
      {
         var rect:Rectangle = this.nameLabel.getRect(this.ui);
         return rect.top;
      }
      
      public function playPersonAction(actionId:int) : void
      {
         if(Boolean(this.actionPlayer))
         {
            this.actionPlayer.dispos();
         }
         this.actionPlayer = null;
         this.stop();
         this.roleFace.visible = true;
         var sex:int = this.showData.roleType & 1;
         if(sex >= 1 || sex < 0)
         {
            sex = 1;
         }
         sex *= 100;
         var color:int = this.showData.roleType >> 1;
         if(color > 3 || color < 1)
         {
            color = 1;
         }
         color *= 10;
         var id:int = 1000 + sex + color + actionId;
         this.actionPlayer = new SwfAction(this.unvisiblerole);
         if(actionId < 3)
         {
            this.actionPlayer.loadAndPlay(Sprite(this.ui),"assets/action/action" + id + ".swf",this.bottomX - 42,this.bottomY - 97,null,null,null,0,this.actionRemove);
         }
         else if(actionId == 3 && GamePersonControl.instance.isDanceTaoZhuang(this.showData.taozhuangId))
         {
            id = 1000 + sex + actionId;
            this.actionPlayer.loadAndPlay(Sprite(this.ui),"assets/action/" + this.showData.taozhuangId + "action" + id + ".swf",this.bottomX - 42,this.bottomY - 97,null,null,null,0,null,false);
         }
         else
         {
            this.actionPlayer.loadAndPlay(Sprite(this.ui),"assets/action/action" + id + ".swf",this.bottomX - 42,this.bottomY - 97,null,null,null,0,null,false);
         }
      }
      
      private function unvisiblerole() : void
      {
         if(Boolean(this.roleFace))
         {
            this.roleFace.visible = false;
         }
      }
      
      public function actionRemove(data:Object = null) : void
      {
         if(Boolean(this.actionPlayer))
         {
            this.actionPlayer.dispos();
         }
         this.actionPlayer = null;
         if(Boolean(this.roleFace))
         {
            this.roleFace.visible = true;
         }
      }
      
      public function playActivityAnimation() : void
      {
         var offsetList:Array = null;
         if(Boolean(this.activityAnimation))
         {
            this.activityAnimation.stop();
            if(this.contains(this.activityAnimation))
            {
               this.removeChild(this.activityAnimation);
            }
            this.activityAnimation = null;
         }
         this.activityAnimation = MaterialLib.getInstance().getMaterial("anniversary") as MovieClip;
         this.activityAnimation.addFrameScript(this.activityAnimation.totalFrames - 1,this.removeActivityAnimation);
         this.activityAnimation.width = 100;
         this.activityAnimation.height = 99.2;
         if(this.showData.horseID != 0 && !GamePersonControl.instance.isFlyIngHorse(this.showData.horseID))
         {
            offsetList = GamePersonControl.instance.getCollectOffset(this.showData.horseID);
            this.activityAnimation.x = offsetList[0];
         }
         else
         {
            this.activityAnimation.x = 0;
            this.activityAnimation.y = -82;
         }
         this.addChild(this.activityAnimation);
         this.activityAnimation.gotoAndPlay(1);
      }
      
      public function removeActivityAnimation() : void
      {
         if(this.activityAnimation != null)
         {
            this.activityAnimation.stop();
            this.activityAnimation.addFrameScript(this.activityAnimation.totalFrames - 1,null);
            if(Boolean(this.activityAnimation.parent))
            {
               this.removeChild(this.activityAnimation);
            }
         }
      }
   }
}

