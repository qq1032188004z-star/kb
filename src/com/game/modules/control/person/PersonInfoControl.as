package com.game.modules.control.person
{
   import com.core.observer.MessageEvent;
   import com.core.view.ViewConLogic;
   import com.game.event.EventConst;
   import com.game.locators.GameData;
   import com.game.locators.MsgDoc;
   import com.game.manager.EventManager;
   import com.game.modules.parse.MAAParse;
   import com.game.modules.view.WindowLayer;
   import com.game.modules.view.family.FamilyInfoRead;
   import com.game.modules.view.family.FamilySn;
   import com.game.modules.view.person.PersonInfoPanel;
   import com.game.util.FloatAlert;
   import com.game.util.GameDynamicUI;
   import flash.events.Event;
   import flash.utils.clearTimeout;
   import flash.utils.getQualifiedClassName;
   import flash.utils.setTimeout;
   
   public class PersonInfoControl extends ViewConLogic
   {
      
      public static const NAME:String = "personinfimediator";
      
      private var familyInfo:Object;
      
      private var tid:int;
      
      public function PersonInfoControl(viewComponent:Object)
      {
         super(NAME,viewComponent);
         EventManager.attachEvent(this.view,Event.ADDED_TO_STAGE,this.onAddToStage);
         this.onAddToStage(null);
      }
      
      private function initEvent() : void
      {
         var checkuid:uint = 0;
         this.view.visible = false;
         if(this.view.checkParams != null)
         {
            clearTimeout(this.tid);
            this.tid = setTimeout(this.timeOutHandler,5000);
            checkuid = uint(this.view.checkParams.userId);
            GameDynamicUI.addUI(WindowLayer.instance.stage,200,200,"loading");
            sendMessage(MsgDoc.OP_CLIENT_REQ_SELF_DRESS.send,checkuid,[this.view.checkParams.isOnline]);
            sendMessage(MsgDoc.OP_CLIENT_REQ_VIP_INFO.send,checkuid);
         }
         EventManager.attachEvent(this.view,Event.REMOVED_FROM_STAGE,this.onRemoveFromStage);
         EventManager.attachEvent(this.view,PersonInfoPanel.ADD_FRIEND,this.addFriend);
         EventManager.attachEvent(this.view,PersonInfoPanel.DEL_FRIEND,this.delFriend);
         EventManager.attachEvent(this.view,PersonInfoPanel.MOVE_TO_BLACK,this.moveToBlack);
         EventManager.attachEvent(this.view,PersonInfoPanel.INVITE_ENTER_ROOM,this.inViteFriendEnterMyRoom);
         EventManager.attachEvent(this.view,PersonInfoPanel.REQUEST_PK,this.requestPK);
         EventManager.attachEvent(this.view,PersonInfoPanel.GOTO_HOUSE,this.gotoHouse);
         EventManager.attachEvent(this.view,PersonInfoPanel.CHECK_POSITION,this.checkPosition);
         EventManager.attachEvent(this.view,PersonInfoPanel.DEL_BLACK,this.delBlack);
         EventManager.attachEvent(this.view,PersonInfoPanel.INVITE_FAMILY,this.inviteToMyFamily);
         EventManager.attachEvent(this.view,PersonInfoPanel.OPENFAMILYINFO,this.openFamilyInfo);
         EventManager.attachEvent(this.view,PersonInfoPanel.REQ_MASTER,this.onReqMaster);
         EventManager.attachEvent(this.view,PersonInfoPanel.REQ_APPRENTICE,this.onReqApprentice);
         EventManager.attachEvent(this.view,PersonInfoPanel.INVITE_TEAM,this.onInviteTeamHandler);
         EventManager.attachEvent(this.view,PersonInfoPanel.TEAM_SYSTEM_CREATE_TEAM,this.onSystemCreateHandler);
      }
      
      private function onAddToStage(evt:Event) : void
      {
         this.view.initEvents();
         this.initEvent();
      }
      
      private function onRemoveFromStage(evt:Event) : void
      {
         this.view.removeEvents();
         EventManager.removeEvent(this.view,Event.REMOVED_FROM_STAGE,this.onRemoveFromStage);
         EventManager.removeEvent(this.view,PersonInfoPanel.ADD_FRIEND,this.addFriend);
         EventManager.removeEvent(this.view,PersonInfoPanel.DEL_FRIEND,this.delFriend);
         EventManager.removeEvent(this.view,PersonInfoPanel.MOVE_TO_BLACK,this.moveToBlack);
         EventManager.removeEvent(this.view,PersonInfoPanel.INVITE_ENTER_ROOM,this.inViteFriendEnterMyRoom);
         EventManager.removeEvent(this.view,PersonInfoPanel.REQUEST_PK,this.requestPK);
         EventManager.removeEvent(this.view,PersonInfoPanel.GOTO_HOUSE,this.gotoHouse);
         EventManager.removeEvent(this.view,PersonInfoPanel.CHECK_POSITION,this.checkPosition);
         EventManager.removeEvent(this.view,PersonInfoPanel.DEL_BLACK,this.delBlack);
         EventManager.removeEvent(this.view,PersonInfoPanel.INVITE_FAMILY,this.inviteToMyFamily);
         EventManager.removeEvent(this.view,PersonInfoPanel.OPENFAMILYINFO,this.openFamilyInfo);
         EventManager.removeEvent(this.view,PersonInfoPanel.REQ_MASTER,this.onReqMaster);
         EventManager.removeEvent(this.view,PersonInfoPanel.REQ_APPRENTICE,this.onReqApprentice);
         EventManager.removeEvent(this.view,PersonInfoPanel.INVITE_TEAM,this.onInviteTeamHandler);
         EventManager.removeEvent(this.view,PersonInfoPanel.TEAM_SYSTEM_CREATE_TEAM,this.onSystemCreateHandler);
      }
      
      public function get view() : PersonInfoPanel
      {
         return this.getViewComponent() as PersonInfoPanel;
      }
      
      override public function listEvents() : Array
      {
         return [[EventConst.GETPERSONDRESSBACK,this.getPersonDressBack],[EventConst.BATTLE_START,this.onbattleStart],[EventConst.GETPERSONINFOFAIL,this.getInfoFail],[EventConst.REQ_FAMILY_INFO_BACK,this.getFamilyInfoBack],[EventConst.ZUOQISTATE_BACK,this.getZuoQiStateBack],[EventConst.MODYFY_BEZHU_BACK,this.onModifyBeiZhuBack],[EventConst.REQ_VIPINFO_BACK,this.onReqVipInfoBack]];
      }
      
      private function onReqVipInfoBack(evt:MessageEvent) : void
      {
         this.view.reqVipInfoBack(evt.body);
      }
      
      private function onModifyBeiZhuBack(evt:MessageEvent) : void
      {
         this.view.onModifyBack();
      }
      
      private function getZuoQiStateBack(evt:MessageEvent) : void
      {
         this.view.zuoQiStateBack(evt.body);
      }
      
      private function onbattleStart(event:MessageEvent) : void
      {
         this.view.oncloseWindows();
      }
      
      private function getPersonDressBack(event:MessageEvent) : void
      {
         this.view.visible = true;
         this.view.build(event.body);
         sendMessage(MsgDoc.OP_CLIENT_REQ_HORSE_STATE.send,this.view.checkParams.userId);
         if(event.body.familyId != null && event.body.familyId > 0)
         {
            sendMessage(MsgDoc.OP_CLIENT_REQ_FAMILY_INFO.send,0,[FamilySn.PERSONINFOCONTROL_SN,int(event.body.familyId)]);
         }
         clearTimeout(this.tid);
         this.tid = 0;
         GameDynamicUI.removeUI("loading");
      }
      
      private function getFamilyInfoBack(evt:MessageEvent) : void
      {
         if(this.view && evt.body != null && evt.body.sn != null && evt.body.sn == 3333)
         {
            this.familyInfo = evt.body;
            this.view.initBadge(evt.body);
         }
         else
         {
            this.familyInfo = null;
         }
      }
      
      private function delFriend(evt:MessageEvent) : void
      {
         sendMessage(MsgDoc.OP_CLIENT_DELETE_FRIEND.send,evt.body.userId,[evt.body.userName]);
      }
      
      private function addFriend(evt:MessageEvent) : void
      {
         sendMessage(MsgDoc.OP_CLIENT_ASK_MAKE_FRIEND.send,evt.body.userId,[evt.body.userName]);
      }
      
      private function requestPK(event:MessageEvent) : void
      {
         dispatch(EventConst.REQUES_BATTLE_WITH,event.body);
      }
      
      private function onSystemCreateHandler(e:MessageEvent) : void
      {
         e.stopImmediatePropagation();
         GameData.instance.playerData.invitePlayer = e.body;
         sendMessage(MsgDoc.OP_CLIENT_CREATE_TEAM.send,0,[0,GameData.instance.playerData.userName]);
      }
      
      private function gotoHouse(evt:MessageEvent) : void
      {
         dispatch(EventConst.REQ_ENTER_ROOM,evt.body);
      }
      
      private function onInviteTeamHandler(evt:MessageEvent) : void
      {
         var userId:int = int(evt.body.userId);
         var username:int = int(evt.body.userName);
         sendMessage(MsgDoc.OP_CLIENT_INVITE_JOIN_TEAM.send,0,[userId]);
      }
      
      private function checkPosition(evt:MessageEvent) : void
      {
         var body:Object = evt.body;
         sendMessage(MsgDoc.OP_CLIENT_CHECK_POSITION.send,body.userId,[body.userName]);
      }
      
      private function inViteFriendEnterMyRoom(evt:MessageEvent) : void
      {
         sendMessage(MsgDoc.OP_CLIENT_INVITE_ENTER_ROOM.send,evt.body.userId,[evt.body.userName]);
      }
      
      private function moveToBlack(evt:MessageEvent) : void
      {
         var params:Object = evt.body;
         sendMessage(MsgDoc.OP_CLIENT_ADD_BLACK.send,params.userId,[params.userName]);
      }
      
      private function delBlack(evt:MessageEvent) : void
      {
         var params:Object = evt.body;
         sendMessage(MsgDoc.OP_CLIENT_DELETE_BLACK.send,params.userId,[params.userName]);
      }
      
      private function getInfoFail(evt:MessageEvent) : void
      {
         this.view.oncloseWindows();
      }
      
      private function inviteToMyFamily(evt:MessageEvent) : void
      {
         sendMessage(MsgDoc.OP_CLIENT_INVITE_JOIN_FAMILY.send,0,[int(evt.body)]);
      }
      
      private function openFamilyInfo(evt:Event) : void
      {
         if(this.familyInfo != null)
         {
            dispatch(EventConst.OPEN_CACHE_VIEW,this.familyInfo,null,getQualifiedClassName(FamilyInfoRead));
         }
      }
      
      private function onReqMaster(evt:MessageEvent) : void
      {
         MAAParse.PersonInfoList.push(evt.body);
         sendMessage(MsgDoc.OP_CLIENT_REQ_MASTER.send,evt.body.userId);
      }
      
      private function onReqApprentice(evt:MessageEvent) : void
      {
         MAAParse.PersonInfoList.push(evt.body);
         sendMessage(MsgDoc.OP_CLIENT_REQ_APPRENTICE.send,evt.body.userId);
      }
      
      private function timeOutHandler() : void
      {
         clearTimeout(this.tid);
         this.tid = 0;
         new FloatAlert().show(WindowLayer.instance,300,400,"该用户不存在!",4,200);
         GameDynamicUI.removeUI("loading");
      }
   }
}

