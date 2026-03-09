package com.game.modules.view.person
{
   import com.core.observer.MessageEvent;
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.locators.GameData;
   import com.game.manager.AlertManager;
   import com.game.manager.EventManager;
   import com.game.modules.control.person.PersonInfoControl;
   import com.game.modules.view.HorseRoundView;
   import com.game.modules.view.achieve.AchieveView;
   import com.game.modules.view.family.FamilyBadge;
   import com.game.util.CacheUtil;
   import com.game.util.ColorUtil;
   import com.game.util.HLoaderSprite;
   import com.game.util.HtmlUtil;
   import com.game.util.PhpInterFace;
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.loading.GreenLoading;
   import com.publiccomponent.ui.ToolTip;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.net.URLVariables;
   import flash.utils.getQualifiedClassName;
   import flash.utils.getTimer;
   import org.dress.ui.RoleFace;
   import org.json.JSON;
   
   public class PersonInfoPanel extends HLoaderSprite
   {
      
      public static const OPENFAMILYINFO:String = "openfamilyinfo";
      
      public static const INVITE_FAMILY:String = "invite_family";
      
      public static const REQUEST_PK:String = "request_pk";
      
      public static const SEND_EMAIL:String = "send_email";
      
      public static const ADD_FRIEND:String = "add_friend";
      
      public static const DEL_FRIEND:String = "del_friend";
      
      public static const GOTO_HOUSE:String = "goto_house";
      
      public static const INVITE_ENTER_ROOM:String = "invite_enter_room";
      
      public static const CHECK_POSITION:String = "check_position";
      
      public static const MOVE_TO_BLACK:String = "move_to_black";
      
      public static const DEL_BLACK:String = "del_black";
      
      public static const REQ_MASTER:String = "req_master";
      
      public static const REQ_APPRENTICE:String = "req_apprentice";
      
      public static const INVITE_TEAM:String = "invite_join_team";
      
      public static const TEAM_SYSTEM_CREATE_TEAM:String = "Team_system_create_team";
      
      private var selfData:Object;
      
      public var checkParams:Object;
      
      public var roleFace:RoleFace;
      
      public var personClip:MovieClip;
      
      private var detailView:PersonInfoDetailView;
      
      private var horseRoundView:HorseRoundView;
      
      private var personid:int;
      
      private var isOpen:Boolean;
      
      private var urlloader:URLLoader;
      
      public var littleGameXML:XML;
      
      private var badge:FamilyBadge;
      
      private var lt:int;
      
      public function PersonInfoPanel()
      {
         GreenLoading.loading.visible = true;
         super();
         this.url = "assets/personinfo/personinfo.swf";
      }
      
      override public function setShow() : void
      {
         this.personClip = this.bg;
         this.personClip.cacheAsBitmap = true;
         this.personClip.vipClip.stop();
         this.personClip.vipClip.visible = false;
         this.personClip.x = -50;
         this.addChild(this.personClip);
         this.roleFace = new RoleFace(294,330,1);
         this.roleFace.mouseEnabled = false;
         this.addChild(this.roleFace);
         this.horseRoundView = new HorseRoundView(306,300);
         addChild(this.horseRoundView);
         this.personClip.yaoQingClip.visible = false;
         ApplicationFacade.getInstance().registerViewLogic(new PersonInfoControl(this));
         GreenLoading.loading.visible = false;
      }
      
      private function initToolTip() : void
      {
         ToolTip.setDOInfo(this.personClip.teamBtn,"小游戏挑战");
         ToolTip.setDOInfo(this.personClip.houseBtn,"访问家园");
         ToolTip.setDOInfo(this.personClip.lookachievebtn,"查看成就");
         ToolTip.setDOInfo(this.personClip.pkBtn,"申请对战");
         ToolTip.setDOInfo(this.personClip.blackBtn,"添加到黑名单");
         ToolTip.setDOInfo(this.personClip.checkPositionBtn,"查看好友位置");
         ToolTip.setDOInfo(this.personClip.yaoQingBtn,"邀请");
         ToolTip.setDOInfo(this.personClip.shituBtn,"师徒申请");
      }
      
      public function initEvents() : void
      {
         EventManager.attachEvent(this.personClip.closeBtn,MouseEvent.CLICK,this.closeWindow);
         EventManager.attachEvent(this.personClip.yaoQingBtn,MouseEvent.CLICK,this.yaoClick);
         EventManager.attachEvent(this.personClip.yaoQingClip,MouseEvent.CLICK,this.yaoOperation);
         EventManager.attachEvent(this.personClip.houseBtn,MouseEvent.CLICK,this.gotoTheHouse);
         EventManager.attachEvent(this.personClip.pkBtn,MouseEvent.CLICK,this.pkWithIt);
         EventManager.attachEvent(this.personClip.checkPositionBtn,MouseEvent.CLICK,this.checkPlayerPosition);
         EventManager.attachEvent(this.personClip.blackBtn,MouseEvent.CLICK,this.moveToBlack);
         EventManager.attachEvent(this.personClip.lookachievebtn,MouseEvent.CLICK,this.openAchieve);
         EventManager.attachEvent(this.personClip.teamBtn,MouseEvent.CLICK,this.openLitgameList);
         EventManager.attachEvent(this.personClip.shituBtn,MouseEvent.CLICK,this.onShituBtn);
         EventManager.attachEvent(this.personClip.baishiBtn,MouseEvent.CLICK,this.onBaishiBtn);
         EventManager.attachEvent(this.personClip.shoutuBtn,MouseEvent.CLICK,this.onShoutuBtn);
      }
      
      public function removeEvents() : void
      {
         EventManager.removeEvent(this.personClip.closeBtn,MouseEvent.CLICK,this.closeWindow);
         EventManager.removeEvent(this.personClip.yaoQingBtn,MouseEvent.CLICK,this.yaoClick);
         EventManager.removeEvent(this.personClip.yaoQingClip,MouseEvent.CLICK,this.yaoOperation);
         EventManager.removeEvent(this.personClip.houseBtn,MouseEvent.CLICK,this.gotoTheHouse);
         EventManager.removeEvent(this.personClip.pkBtn,MouseEvent.CLICK,this.pkWithIt);
         EventManager.removeEvent(this.personClip.checkPositionBtn,MouseEvent.CLICK,this.checkPlayerPosition);
         EventManager.removeEvent(this.personClip.blackBtn,MouseEvent.CLICK,this.moveToBlack);
         EventManager.removeEvent(this.personClip.lookachievebtn,MouseEvent.CLICK,this.openAchieve);
         EventManager.removeEvent(this.personClip.teamBtn,MouseEvent.CLICK,this.openLitgameList);
         EventManager.removeEvent(this.personClip.shituBtn,MouseEvent.CLICK,this.onShituBtn);
         EventManager.removeEvent(this.personClip.baishiBtn,MouseEvent.CLICK,this.onBaishiBtn);
         EventManager.removeEvent(this.personClip.shoutuBtn,MouseEvent.CLICK,this.onShoutuBtn);
         this.clear();
         if(Boolean(this.badge) && this.contains(this.badge))
         {
            this.badge.dispos();
            this.badge = null;
         }
      }
      
      private function onStartDrag(evt:MouseEvent) : void
      {
         this.startDrag();
      }
      
      private function onStopDrag(evt:MouseEvent) : void
      {
         this.stopDrag();
      }
      
      public function onModifyBack() : void
      {
         if(Boolean(this.personClip))
         {
            this.personClip.beizhuTxt.text = this.checkParams.userBeiZhu;
         }
      }
      
      private function openDetailView() : void
      {
         this.detailView = CacheUtil.getObject(PersonInfoDetailView) as PersonInfoDetailView;
         this.detailView.x = 255;
         this.detailView.y = -20;
         this.detailView.checkParams = this.checkParams;
         if(!this.detailView.parent && Boolean(this.parent))
         {
            this.detailView.show(this.parent,370,40);
         }
      }
      
      private function openLitgameList(evt:Event) : void
      {
         this.urlloader = new URLLoader();
         this.urlloader.addEventListener(Event.COMPLETE,this.onLoadLittleGameComp);
         this.urlloader.dataFormat = URLLoaderDataFormat.TEXT;
         this.urlloader.load(new URLRequest(URLUtil.getSvnVer("config/littlegame.xml")));
      }
      
      private function onLoadLittleGameComp(evt:Event) : void
      {
         this.littleGameXML = new XML(this.urlloader.data);
         this.urlloader.removeEventListener(Event.COMPLETE,this.onLoadLittleGameComp);
         this.urlloader.close();
         this.urlloader = null;
         this.openLitgameList2(null);
      }
      
      public function reqVipInfoBack(params:Object) : void
      {
         if(params.isopenvip == 1)
         {
            if(params.expiretime - params.currentTime > 0)
            {
               if(params.isSuperVip > 0)
               {
                  this.personClip.vipClip.gotoAndStop("supervip");
               }
               else
               {
                  this.personClip.vipClip.gotoAndStop(params.vipLevel);
               }
               this.personClip.vipClip.visible = true;
            }
            else
            {
               this.personClip.vipClip.gotoAndStop(1);
               this.personClip.vipClip.visible = false;
            }
         }
         else
         {
            this.personClip.vipClip.gotoAndStop(1);
            this.personClip.vipClip.visible = false;
         }
      }
      
      private function openLitgameList2(evt:Event) : void
      {
         var urlvar:URLVariables = new URLVariables();
         urlvar.uid = GameData.instance.friendData.userId;
         new PhpInterFace().getData("http://php.wanwan4399.com/smallgame/game_score.php",urlvar,this.onSendBack,"POST");
      }
      
      private function onSendBack(obj:Object) : void
      {
         var obj2:Object;
         var arr:Array = null;
         var i:int = 0;
         var tempid:int = 0;
         var name:String = null;
         var gameMapid:int = 0;
         var maxscore:int = 0;
         if(obj == null)
         {
            return;
         }
         obj2 = JSON.decode(String(obj));
         if(Boolean(obj2) && Boolean(obj2.list))
         {
            arr = obj2.list;
            for(i = 0; i < arr.length; i++)
            {
               tempid = int(arr[i].gameid);
               name = this.littleGameXML.children().(@gameid == tempid).@name;
               gameMapid = int(this.littleGameXML.children().(@gameid == tempid).@mapid);
               arr[i].gamename = name;
               arr[i].gameMapid = gameMapid;
               maxscore = int(this.littleGameXML.children().(@gameid == tempid).@maxscore);
               if(arr[i].score < maxscore)
               {
                  arr[i].chaShow = false;
               }
               else
               {
                  arr[i].chaShow = true;
               }
            }
            ApplicationFacade.getInstance().dispatch(EventConst.SHOWLITGAMELIST,arr);
         }
      }
      
      public function build(params:Object) : void
      {
         if(this.personClip == null)
         {
            return;
         }
         this.isOpen = true;
         this.initToolTip();
         this.selfData = params;
         if(!this.checkParams)
         {
            this.checkParams = {};
         }
         this.checkParams.body = params;
         params.sex = this.checkParams.sex = params.roleType & 1;
         this.personClip.nameTxt.text = this.checkParams.userName = params.userName;
         this.personClip.idTxt.text = params.userId;
         this.personid = params.userId;
         this.personClip.blackBtn.mouseEnabled = true;
         this.personClip.blackBtn.filters = [];
         this.personClip.beizhuTxt.text = params.userBeiZhu;
         this.personClip.beizhuTxt.visible = false;
         this.personClip.beizhuClip.visible = false;
         this.checkParams.isFriend = params.isFriend;
         this.checkParams.userBeiZhu = params.userBeiZhu;
         if(params.isFriend == 1)
         {
            this.personClip.beizhuTxt.visible = true;
            this.personClip.beizhuClip.visible = true;
            this.personClip.yaoQingClip.gotoAndStop(2);
            if(this.checkParams.isBlack == 1)
            {
               this.personClip.blackBtn.enabled = false;
               this.personClip.blackBtn.filters = ColorUtil.getColorMatrixFilterGray();
            }
            else
            {
               this.personClip.blackBtn.enabled = true;
               this.personClip.blackBtn.filters = [];
            }
         }
         else if(params.isFriend == 2)
         {
            this.personClip.yaoQingClip.gotoAndStop(3);
            this.personClip.blackBtn.enabled = false;
            this.personClip.blackBtn.filters = ColorUtil.getColorMatrixFilterGray();
         }
         else
         {
            this.personClip.yaoQingClip.gotoAndStop(1);
            this.personClip.blackBtn.enabled = false;
            this.personClip.blackBtn.filters = ColorUtil.getColorMatrixFilterGray();
         }
         if(params.isOnline == 0)
         {
            this.personClip.teamBtn.enabled = false;
            this.personClip.teamBtn.filters = ColorUtil.getColorMatrixFilterGray();
            this.personClip.pkBtn.enabled = false;
            this.personClip.pkBtn.filters = ColorUtil.getColorMatrixFilterGray();
            this.personClip.lookachievebtn.mouseEnabled = false;
            this.personClip.lookachievebtn.filters = ColorUtil.getColorMatrixFilterGray();
         }
         else
         {
            this.personClip.teamBtn.enabled = true;
            this.personClip.teamBtn.filters = [];
            this.personClip.pkBtn.enabled = true;
            this.personClip.pkBtn.filters = [];
            this.personClip.lookachievebtn.mouseEnabled = true;
            this.personClip.lookachievebtn.filters = [];
         }
         this.horseRoundView.loadHorse(params.horseId,this.checkParams.userId);
         this.roleFace.setRole(params,"big");
         this.setFriendData(params);
         this.personClip.baishiBtn.visible = false;
         this.personClip.shoutuBtn.visible = false;
         this.openDetailView();
      }
      
      private function clear() : void
      {
         this.personClip.nameTxt.text = "";
         this.personClip.idTxt.text = "";
         if(this.roleFace != null)
         {
            this.roleFace.clear();
         }
      }
      
      private function setFriendData(params:Object) : void
      {
         GameData.instance.friendData.userId = uint(this.checkParams.userId);
         GameData.instance.friendData.userName = this.checkParams.userName;
         var sex:int = params.roleType & 1;
         GameData.instance.friendData.sex = sex * 10;
         GameData.instance.friendData.roleType = params.roleType;
         GameData.instance.friendData.color = params.roleType >> 1;
         GameData.instance.friendData.hatId = params.hatId;
         GameData.instance.friendData.clothId = params.clothId;
         GameData.instance.friendData.footId = params.footId;
         GameData.instance.friendData.faceId = params.faceId;
         GameData.instance.friendData.weaponId = params.weaponId;
         GameData.instance.friendData.wingId = params.wingId;
         GameData.instance.friendData.glassId = params.glassId;
      }
      
      private function closeWindow(evt:MouseEvent) : void
      {
         this.isOpen = false;
         this.personClip.yaoQingClip.visible = false;
         this.parent.removeChild(this);
         if(this.detailView != null && this.detailView.parent != null)
         {
            this.detailView.close();
         }
         ApplicationFacade.getInstance().dispatch(EventConst.CLOSECHALLENGE);
      }
      
      public function oncloseWindows() : void
      {
         if(this.parent != null && this.parent.contains(this))
         {
            this.closeWindow(null);
         }
      }
      
      private function yaoClick(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         this.personClip.yaoQingClip.visible = Boolean(this.personClip.yaoQingClip.visible) ? false : true;
      }
      
      private function yaoOperation(evt:MouseEvent) : void
      {
         this.personClip.yaoQingClip.visible = false;
         switch(evt.target.name)
         {
            case "b1":
               if(Boolean(this.selfData.hasOwnProperty("isAccept")) && Boolean(this.selfData.isAccept & 1))
               {
                  AlertManager.instance.showTipAlert({
                     "systemid":1067,
                     "flag":1
                  });
               }
               else
               {
                  AlertManager.instance.showTipAlert({
                     "systemid":1067,
                     "flag":2,
                     "replace":this.checkParams.userName,
                     "callback":this.addToMyFriend
                  });
               }
               break;
            case "b4":
               AlertManager.instance.showTipAlert({
                  "systemid":1067,
                  "flag":3,
                  "replace":this.checkParams.userName,
                  "replaceNum":this.checkParams.userId,
                  "callback":this.delFriend
               });
               break;
            case "b7":
               AlertManager.instance.showTipAlert({
                  "systemid":1067,
                  "flag":4,
                  "replace":this.checkParams.userName,
                  "replaceNum":this.checkParams.userId,
                  "callback":this.delBlack
               });
               break;
            case "b8":
            case "b5":
            case "b2":
               AlertManager.instance.showTipAlert({
                  "systemid":1067,
                  "flag":5,
                  "replace":this.checkParams.userName,
                  "replaceNum":this.checkParams.userId,
                  "callback":this.addToMyHouse
               });
               break;
            case "b6":
            case "b9":
            case "b3":
               if(GameData.instance.playerData.family_id <= 0)
               {
                  AlertManager.instance.showTipAlert({
                     "systemid":1067,
                     "flag":6
                  });
               }
               else if(this.checkParams.body.familyId > 0)
               {
                  AlertManager.instance.showTipAlert({
                     "systemid":1067,
                     "flag":7
                  });
               }
               else
               {
                  AlertManager.instance.showTipAlert({
                     "systemid":1067,
                     "flag":8,
                     "replace":this.checkParams.userName,
                     "callback":this.addToMyFamily
                  });
               }
               break;
            case "b10":
            case "b11":
            case "b12":
               if(GameData.instance.playerData.myTeamData == null)
               {
                  AlertManager.instance.showTipAlert({
                     "systemid":1067,
                     "flag":9,
                     "callback":this.onCreateTeamBack
                  });
               }
               else if(GameData.instance.playerData.myTeamData.teamHeadPlayer.playerId == GameData.instance.playerData.userId)
               {
                  AlertManager.instance.showTipAlert({
                     "systemid":1067,
                     "flag":10,
                     "replace":this.checkParams.userName,
                     "replaceNum":this.checkParams.userId,
                     "callback":this.addTeamPlayer
                  });
               }
               else
               {
                  AlertManager.instance.showTipAlert({
                     "systemid":1067,
                     "flag":11
                  });
               }
         }
      }
      
      private function addToMyFriend(str:String, data:Object) : void
      {
         if(str == "确定")
         {
            dispatchEvent(new MessageEvent(PersonInfoPanel.ADD_FRIEND,{
               "userId":this.checkParams.userId,
               "userName":this.checkParams.userName
            }));
            this.oncloseWindows();
         }
      }
      
      private function addToMyHouse(str:String, data:Object) : void
      {
         if(str == "确定")
         {
            dispatchEvent(new MessageEvent(PersonInfoPanel.INVITE_ENTER_ROOM,{
               "userId":this.checkParams.userId,
               "userName":this.checkParams.userName
            }));
            this.oncloseWindows();
         }
      }
      
      private function addToMyFamily(str:String, data:Object) : void
      {
         if(str == "确定")
         {
            dispatchEvent(new MessageEvent(PersonInfoPanel.INVITE_FAMILY,this.checkParams.userId));
            this.oncloseWindows();
         }
      }
      
      private function onCreateTeamBack(str:String, data:Object) : void
      {
         if(str == "确定")
         {
            dispatchEvent(new MessageEvent(PersonInfoPanel.TEAM_SYSTEM_CREATE_TEAM,{
               "userId":this.checkParams.userId,
               "userName":this.checkParams.userName
            }));
            this.oncloseWindows();
         }
      }
      
      private function addTeamPlayer(str:String, data:Object) : void
      {
         if(str == "确定")
         {
            dispatchEvent(new MessageEvent(PersonInfoPanel.INVITE_TEAM,{
               "userId":this.checkParams.userId,
               "userName":this.checkParams.userName
            }));
            this.oncloseWindows();
         }
      }
      
      private function gotoTheHouse(evt:MouseEvent = null) : void
      {
         if(GameData.instance.playerData.currentScenenId == 10005)
         {
            AlertManager.instance.showTipAlert({
               "systemid":1068,
               "flag":8,
               "callback":this.leaveTeamCopyOrNotForHouse
            });
            return;
         }
         EventManager.dispatch(this,new MessageEvent(PersonInfoPanel.GOTO_HOUSE,{
            "userId":this.selfData.userId,
            "userName":this.selfData.userName,
            "houseId":this.selfData.userId
         }));
         this.oncloseWindows();
      }
      
      private function leaveTeamCopyOrNotForHouse(str:String, data:Object) : void
      {
         if(str == "确定")
         {
            ApplicationFacade.getInstance().dispatch(EventConst.LEAVE_TEAMCOPY,{
               "callBack":this.gotoTheHouse,
               "sceneId":1002
            });
         }
      }
      
      private function pkWithIt(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         if(Boolean(this.personClip.pkBtn.enabled))
         {
            EventManager.dispatch(this,new MessageEvent(PersonInfoPanel.REQUEST_PK,this.selfData));
            this.oncloseWindows();
         }
      }
      
      private function checkPlayerPosition(evt:MouseEvent) : void
      {
         if(this.checkParams.body != null && this.checkParams.body.isOnline == 0)
         {
            if(this.checkParams.isFriend == 1)
            {
               AlertManager.instance.showTipAlert({
                  "systemid":1068,
                  "flag":1
               });
            }
            else
            {
               AlertManager.instance.showTipAlert({
                  "systemid":1068,
                  "flag":9
               });
            }
         }
         else
         {
            dispatchEvent(new MessageEvent(PersonInfoPanel.CHECK_POSITION,this.checkParams));
         }
      }
      
      private function moveToBlack(evt:MouseEvent) : void
      {
         if(Boolean(this.personClip.blackBtn.enabled))
         {
            dispatchEvent(new MessageEvent(PersonInfoPanel.MOVE_TO_BLACK,this.checkParams));
            this.oncloseWindows();
         }
      }
      
      private function openAchieve(evt:MouseEvent) : void
      {
         ApplicationFacade.getInstance().dispatch(EventConst.OPEN_CACHE_VIEW,{
            "showX":0,
            "showY":0,
            "id":this.personid,
            "sex":this.checkParams.sex
         },null,getQualifiedClassName(AchieveView));
      }
      
      private function delFriend(str:String, data:Object) : void
      {
         if(str == "确定")
         {
            EventManager.dispatch(this,new MessageEvent(PersonInfoPanel.DEL_FRIEND,{
               "userId":this.checkParams.userId,
               "userName":this.checkParams.userName
            }));
            this.oncloseWindows();
         }
      }
      
      private function delBlack(str:String, data:Object) : void
      {
         if(str == "确定")
         {
            EventManager.dispatch(this,new MessageEvent(PersonInfoPanel.DEL_BLACK,{
               "userId":this.checkParams.userId,
               "userName":this.checkParams.userName
            }));
            this.oncloseWindows();
         }
      }
      
      public function initBadge(body:Object) : void
      {
         if(!body)
         {
            return;
         }
         if(Boolean(this.badge) && this.contains(this.badge))
         {
            this.badge.dispos();
            this.badge = null;
         }
         this.badge = new FamilyBadge();
         this.badge.setBadge(body.midid,body.smallid,body._name,body.midcolor,body.circolor,0.6);
         this.badge.x = 100;
         this.badge.y = 7;
         this.addChildAt(this.badge,this.numChildren);
         EventManager.attachEvent(this.badge,MouseEvent.CLICK,this.on_Click_Badge);
         var tips:String = HtmlUtil.getHtmlText(14,"#FF0000","【" + body.f_name + "】");
         ToolTip.setDOInfo(this.badge,tips);
      }
      
      private function on_Click_Badge(evt:MouseEvent) : void
      {
         if(getTimer() - this.lt > 1000)
         {
            this.lt = getTimer();
            if(!GameData.instance.playerData.isInWarCraft)
            {
               this.dispatchEvent(new Event(PersonInfoPanel.OPENFAMILYINFO));
            }
            else
            {
               AlertManager.instance.showTipAlert({
                  "systemid":1068,
                  "flag":2
               });
            }
         }
      }
      
      public function zuoQiStateBack(body:Object) : void
      {
         if(Boolean(this.horseRoundView) && this.isOpen)
         {
            this.isOpen = false;
            this.horseRoundView.setHorseData(body);
         }
      }
      
      private function onShituBtn(evt:MouseEvent) : void
      {
         var value1:int = int(this.checkParams.body.historyValue);
         var value2:int = GameData.instance.playerData.historyValue;
         var value3:int = int(this.checkParams.body.kabuLevel);
         var value4:int = GameData.instance.playerData.kabuLevle;
         var value5:int = int(this.checkParams.body.signTime);
         var value6:int = GameData.instance.playerData.signTime;
         if(this.checkParams.body.maxLevel >= 100)
         {
            if(value1 > value2)
            {
               this.personClip.baishiBtn.visible = true;
            }
            else if(value1 == value2)
            {
               if(value3 > value4)
               {
                  this.personClip.baishiBtn.visible = true;
               }
               else if(value3 == value4 && value5 < value6)
               {
                  this.personClip.baishiBtn.visible = true;
               }
            }
         }
         this.personClip.shoutuBtn.visible = !this.personClip.baishiBtn.visible;
      }
      
      private function onBaishiBtn(evt:MouseEvent) : void
      {
         if(this.checkParams.body.isOnline == 0)
         {
            AlertManager.instance.showTipAlert({
               "systemid":1068,
               "flag":3
            });
         }
         else if(this.checkParams.body.maxLevel < 100)
         {
            AlertManager.instance.showTipAlert({
               "systemid":1068,
               "flag":4
            });
         }
         else
         {
            AlertManager.instance.showTipAlert({
               "systemid":1068,
               "flag":5
            });
            this.dispatchEvent(new MessageEvent(PersonInfoPanel.REQ_MASTER,this.checkParams));
            this.oncloseWindows();
         }
      }
      
      private function onShoutuBtn(evt:MouseEvent) : void
      {
         if(this.checkParams.body.isOnline == 0)
         {
            AlertManager.instance.showTipAlert({
               "systemid":1068,
               "flag":6
            });
         }
         else if(GameData.instance.playerData.maxLevel < 100)
         {
            AlertManager.instance.showTipAlert({
               "systemid":1068,
               "flag":7
            });
         }
         else
         {
            AlertManager.instance.showTipAlert({
               "systemid":1068,
               "flag":5
            });
            this.dispatchEvent(new MessageEvent(PersonInfoPanel.REQ_APPRENTICE,this.checkParams));
            this.oncloseWindows();
         }
      }
   }
}

