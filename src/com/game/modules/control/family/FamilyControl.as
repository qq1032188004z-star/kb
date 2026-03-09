package com.game.modules.control.family
{
   import com.core.observer.MessageEvent;
   import com.core.view.ViewConLogic;
   import com.game.event.EventConst;
   import com.game.global.GlobalConfig;
   import com.game.locators.GameData;
   import com.game.locators.MsgDoc;
   import com.game.manager.EventManager;
   import com.game.modules.view.MapView;
   import com.game.modules.view.family.FamilyCheckList;
   import com.game.modules.view.family.FamilyContribution;
   import com.game.modules.view.family.FamilyInfoRead;
   import com.game.modules.view.family.FamilyInfoWrite;
   import com.game.modules.view.family.FamilyJoinIn;
   import com.game.modules.view.family.FamilyRecord;
   import com.game.modules.view.family.FamilySn;
   import com.game.util.GameDynamicUI;
   import com.game.util.PhpInterFace;
   import flash.events.Event;
   import flash.net.URLVariables;
   import flash.utils.getQualifiedClassName;
   import org.json.JSON;
   
   public class FamilyControl extends ViewConLogic
   {
      
      private static var _instance:FamilyControl;
      
      public static const NAME:String = "FamilyControl";
      
      private var phpInterFace:PhpInterFace;
      
      public function FamilyControl(viewCompoenent:Object = null)
      {
         super(NAME,viewCompoenent);
         if(viewCompoenent != null)
         {
            this.initViewEvent();
         }
      }
      
      public static function get instance() : FamilyControl
      {
         if(_instance == null)
         {
            _instance = new FamilyControl();
         }
         return _instance;
      }
      
      public function get view() : *
      {
         return this.getViewComponent();
      }
      
      private function initViewEvent() : void
      {
         if(this.view is FamilyInfoWrite)
         {
            EventManager.attachEvent(this.view,EventConst.ERQ_CREATE_FAMILY,this.on_ReqCreateFamily);
         }
         else if(this.view is FamilyJoinIn)
         {
            EventManager.attachEvent(this.view,EventConst.REQ_JOININ_FAMILY,this.on_ReqJoininFamily);
         }
         else if(this.view is FamilyRecord)
         {
            sendMessage(MsgDoc.OP_CLIENT_REQ_FAMILY_INFO.send,0,[FamilySn.FAMILYRECORD_SN,GameData.instance.playerData.family_base_id]);
            EventManager.attachEvent(this.view,EventConst.REQ_JOININ_FAMILY,this.on_ReqJoininFamily);
            EventManager.attachEvent(this.view,EventConst.RECORD_EXIT_FAMILY,this.on_ReqExitFamily);
            EventManager.attachEvent(this.view,EventConst.RECORD_TRANSFORM_LEADER,this.on_ReqTransLeader);
            EventManager.attachEvent(this.view,EventConst.RECORD_CHANGE_NOTICE,this.on_ChangeNotice);
            EventManager.attachEvent(this.view,EventConst.RECORD_CHANGE_FAMILY_INFO,this.on_ChangeIofo);
            EventManager.attachEvent(this.view,EventConst.RECORD_CHANGE_LEVEL,this.on_ChangeLevel);
            EventManager.attachEvent(this.view,EventConst.RECORD_FIRE,this.on_ReqFire);
         }
      }
      
      private function on_ReqCreateFamily(evt:MessageEvent) : void
      {
         var body:Object = evt.body;
         var list:Array = [];
         if(body != null)
         {
            list = [String(body.fname),String(body.notice),int(body.setting),int(body.midid),int(body.smallid),int(body.midcolor),int(body.circolor),String(body._name)];
         }
         sendMessage(MsgDoc.OP_CLIENT_REQ_CREATE_FAMILY.send,0,list);
      }
      
      private function on_ReqJoininFamily(evt:MessageEvent) : void
      {
         this.sendMessage(MsgDoc.OP_CLIENT_REQ_JOININ_FAMILY.send,0,[int(evt.body)]);
      }
      
      private function on_ReqExitFamily(evt:Event) : void
      {
         sendMessage(MsgDoc.OP_CLIENT_REQ_EXIT_FAMILY.send);
      }
      
      private function on_ReqTransLeader(evt:MessageEvent) : void
      {
         sendMessage(MsgDoc.OP_CLIENT_REQ_TRANS_LEADER.send,0,[int(evt.body.option),int(evt.body.uid)]);
      }
      
      private function on_ChangeNotice(evt:MessageEvent) : void
      {
         sendMessage(MsgDoc.OP_CLIENT_REQ_CHANGE_NOTICE.send,0,[String(evt.body)]);
      }
      
      private function on_ChangeIofo(evt:MessageEvent) : void
      {
         var body:Object = evt.body;
         var list:Array = [int(body.setting),int(body.midid),int(body.smallid),int(body.midcolor),int(body.circolor),String(body._name),int(body.badge_id)];
         sendMessage(MsgDoc.OP_CLIENT_REQ_CHANGE_INFO.send,0,list);
      }
      
      private function on_ChangeLevel(evt:MessageEvent) : void
      {
         sendMessage(MsgDoc.OP_CLIENT_REQ_CHANGE_LEVEL.send,0,[int(evt.body.uid),int(evt.body.level)]);
      }
      
      private function on_ReqFire(evt:MessageEvent) : void
      {
         sendMessage(MsgDoc.OP_CLIENT_REQ_FIRE_MEMBER.send,0,[evt.body.uid]);
      }
      
      public function sendOnRename(rName:String) : void
      {
         sendMessage(MsgDoc.OP_CLIENT_REQ_FAMILY_RENAME.send,0,[rName]);
      }
      
      override public function listEvents() : Array
      {
         return [[EventConst.ERQ_CREATE_FAMILY_BACK,this.on_ReqCreateFamilyBack],[EventConst.REQ_FAMILY_INFO_BACK,this.getFamilyInfoBack],[EventConst.REQ_FAMILY_INFO_FAILED,this.getFamilyInfoFailed],[EventConst.FAMILY_MEMBERS_BACK,this.getFamilyMembersBack],[EventConst.FAMILY_EXIT_BACK,this.exitFamilyBack],[EventConst.FAMILY_TRANS_BACK,this.transLeaderBack],[EventConst.RECORD_CHANGE_INFO_BACK,this.on_ChangeInfoBack],[EventConst.ENTER_FAMILY_BASE,this.on_EnterFamilyBase],[EventConst.REQ_FAMILY_CHECK_IN,this.on_Req_Check_In],[EventConst.REQ_FAMILY_INFO,this.on_Req_Family_Info],[EventConst.REQ_FAMILY_CHECK_LIST,this.on_Req_CheckIn_List],[EventConst.FAMILY_CHECK_LIST_BACK,this.on_CheckInListBack],[EventConst.RECORD_CHANGE_LEVEL,this.on_ChangeLevel]];
      }
      
      private function on_ReqCreateFamilyBack(evt:MessageEvent) : void
      {
         if(this.view is FamilyInfoWrite)
         {
            (this.view as FamilyInfoWrite).disport();
         }
      }
      
      private function getFamilyInfoBack(evt:MessageEvent) : void
      {
         if(evt.body.sn == 2222)
         {
            (this.view as FamilyRecord).initBadge(evt.body);
            sendMessage(MsgDoc.OP_CLIENT_REQ_FAMILY_MEMBERS.send,0,[GameData.instance.playerData.family_base_id,3]);
         }
         else if(evt.body.sn == 5555)
         {
            dispatch(EventConst.OPEN_CACHE_VIEW,evt.body,null,getQualifiedClassName(FamilyInfoRead));
         }
         else if(evt.body.sn == 4444)
         {
            dispatch(EventConst.OPEN_CACHE_VIEW,evt.body,null,getQualifiedClassName(FamilyContribution));
         }
      }
      
      private function getFamilyInfoFailed(evt:MessageEvent) : void
      {
         if(this.view as FamilyRecord && (this.view as FamilyRecord).parent && (this.view as FamilyRecord).parent.contains(this.view))
         {
            (this.view as FamilyRecord).disport();
         }
      }
      
      private function getFamilyMembersBack(evt:MessageEvent) : void
      {
         if(this.view == null)
         {
            return;
         }
         var list:Array = evt.body as Array;
         if(this.view && this.view is FamilyRecord && list != null)
         {
         }
      }
      
      private function exitFamilyBack(evt:MessageEvent) : void
      {
      }
      
      private function transLeaderBack(evt:MessageEvent) : void
      {
         if(this.view && this.view is FamilyRecord)
         {
            if(this.view.LeaderExit == true && GameData.instance.playerData.family_level == 1)
            {
               sendMessage(MsgDoc.OP_CLIENT_REQ_EXIT_FAMILY.send);
            }
         }
      }
      
      private function on_ChangeInfoBack(evt:MessageEvent) : void
      {
      }
      
      private function on_EnterFamilyBase(evt:MessageEvent) : void
      {
         this.getFamilyNameAndEnterBase(int(evt.body));
      }
      
      private function on_Req_Check_In(evt:MessageEvent) : void
      {
         sendMessage(MsgDoc.OP_CLIENT_REQ_FAMILY_CHECK_IN.send);
      }
      
      private function on_Req_Family_Info(evt:MessageEvent) : void
      {
         if(evt.body.hasOwnProperty("sn"))
         {
            sendMessage(MsgDoc.OP_CLIENT_REQ_FAMILY_INFO.send,0,[int(evt.body.sn),int(evt.body.fid)]);
         }
         else
         {
            sendMessage(MsgDoc.OP_CLIENT_REQ_FAMILY_INFO.send,0,[FamilySn.FAMILYCONTROL_SN,int(evt.body)]);
         }
      }
      
      private function on_Req_CheckIn_List(evt:MessageEvent) : void
      {
         sendMessage(MsgDoc.OP_CLIENT_REQ_FAMILY_MEMBERS.send,0,[GameData.instance.playerData.family_base_id,1]);
      }
      
      private function on_CheckInListBack(evt:MessageEvent) : void
      {
         if(GameData.instance.playerData.family_base_id == GameData.instance.playerData.family_id)
         {
            dispatch(EventConst.OPEN_CACHE_VIEW,evt.body,null,getQualifiedClassName(FamilyCheckList));
         }
      }
      
      public function ContributionOption(param:int = 0, body:Array = null) : void
      {
         sendMessage(MsgDoc.OP_CLIENT_REQ_FAMILY_CONTRIBUTION.send,param,body);
      }
      
      public function getBoxAward($index:int) : void
      {
         if($index > 0 && $index <= 3)
         {
            sendMessage(MsgDoc.OP_CLIENT_REQ_FAMILY_CONTRIBUTION.send,3,[$index]);
         }
      }
      
      private function getFamilyNameAndEnterBase(familyId:int = 0) : void
      {
         var urlvar:URLVariables = null;
         if(familyId > 0)
         {
            try
            {
               if(Boolean(MapView.instance.stage))
               {
                  GameDynamicUI.addUI(MapView.instance.stage,200,200,"loading");
               }
               GameData.instance.playerData.family_base_id = familyId;
               this.phpInterFace = new PhpInterFace();
               urlvar = new URLVariables();
               urlvar.idStr = familyId;
               this.phpInterFace.getData(GlobalConfig.phpserver + "shitu/family.php",urlvar,this.enterFamilyBase);
               sendMessage(MsgDoc.OP_CLIENT_REQ_ENTER_FAMILY_BASE.send,GameData.instance.playerData.family_base_id);
            }
            catch(e:*)
            {
               O.o("FamilyControl::getFamilyNameAndEnterBase() " + e);
            }
         }
      }
      
      private function enterFamilyBase(obj:Object) : void
      {
         var params:Object = JSON.decode(String(obj));
         var list:Array = params.list as Array;
         if(list != null && list[0] != null)
         {
            GameData.instance.playerData.family_base_name = list[0].fname + "";
            O.o("\nfamily_base_id = " + GameData.instance.playerData.family_base_id);
         }
         if(Boolean(this.phpInterFace))
         {
            this.phpInterFace.dispos();
         }
         this.phpInterFace = null;
      }
   }
}

