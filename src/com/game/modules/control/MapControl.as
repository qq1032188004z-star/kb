package com.game.modules.control
{
   import com.channel.Message;
   import com.core.observer.MessageEvent;
   import com.core.view.ViewConLogic;
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.global.GlobalConfig;
   import com.game.locators.CacheData;
   import com.game.locators.GameData;
   import com.game.locators.MsgDoc;
   import com.game.manager.EventManager;
   import com.game.manager.FishManager;
   import com.game.manager.MonsterManger;
   import com.game.manager.MouseManager;
   import com.game.modules.action.GameSpriteAction;
   import com.game.modules.action.MouseActionControl;
   import com.game.modules.action.MouseEnableView;
   import com.game.modules.action.SwfAction;
   import com.game.modules.ai.SpecialAreaManager;
   import com.game.modules.control.battle.BattleControl;
   import com.game.modules.control.task.TaskList;
   import com.game.modules.view.FaceView;
   import com.game.modules.view.FarmView;
   import com.game.modules.view.MapView;
   import com.game.modules.view.VIPNoticeView;
   import com.game.modules.view.VIPPrivilegeView;
   import com.game.modules.view.magic.MagicSendManager;
   import com.game.modules.view.monster.MonsterPolling;
   import com.game.modules.view.person.GamePerson;
   import com.game.modules.view.person.MoveableNPC;
   import com.game.modules.view.person.MultipleNPC;
   import com.game.modules.view.person.Npc;
   import com.game.modules.view.person.SceneAIClick;
   import com.game.modules.view.person.SpecialArea;
   import com.game.modules.view.person.WalkableNPC;
   import com.game.modules.view.person.actAI.NPC14017;
   import com.game.modules.view.person.actAI.NPC161706;
   import com.game.modules.view.person.actAI.NPC211409;
   import com.game.modules.view.person.actAI.NPC22013;
   import com.game.modules.view.person.actAI.OrderClickNPC;
   import com.game.modules.view.shenshou.ShenshouView;
   import com.game.modules.vo.ActivityEventBody;
   import com.game.modules.vo.HorseCheckVo;
   import com.game.modules.vo.NPCVo;
   import com.game.modules.vo.PlayerData;
   import com.game.modules.vo.ShowData;
   import com.game.util.ActionAI;
   import com.game.util.AwardAlert;
   import com.game.util.CacheUtil;
   import com.game.util.DelayShowUtil;
   import com.game.util.DynamicBuild;
   import com.game.util.FloatAlert;
   import com.game.util.GameAction;
   import com.game.util.GameDynamicUI;
   import com.game.util.GamePersonControl;
   import com.game.util.HorseCheck;
   import com.game.util.HtmlUtil;
   import com.game.util.IdName;
   import com.game.util.MouseCursorAI;
   import com.game.util.NpcXMLParser;
   import com.game.util.SceneAIBase;
   import com.game.util.SceneAIFactory;
   import com.game.util.ScreenSprite;
   import com.publiccomponent.alert.Alert;
   import com.publiccomponent.loading.XMLLocator;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.getQualifiedClassName;
   import org.engine.core.GameSprite;
   
   public class MapControl extends ViewConLogic
   {
      
      public static const NAME:String = "mapmediator";
      
      private var tempareaid:int;
      
      private var tempcount:int = 0;
      
      private var flag:Boolean = true;
      
      private var currentSceneCount:int;
      
      private var afterBeFinish:Array = [40002,40003,40004,40005,23002,23003];
      
      private var pa:Object;
      
      private var targetMouseCursorAIId:int;
      
      private var stoneAccount:Object;
      
      private var rect2:Rectangle;
      
      private var tmpClickObject:Object;
      
      private var backdoorMapId:int;
      
      private var enterSceneFaildList:Array = [0,1013,1018,1023,1024,1055];
      
      private var independentList:Array;
      
      private var haveSpecialOperateList:Array = [1019,1020,1021];
      
      private var haveSpecialOperateTargetID:int = 0;
      
      private var crazyRecordRoom:Array = [1019,1020,1021];
      
      private var newHandBraveData:Object = {};
      
      public function MapControl(viewComponent:Object = null)
      {
         super(NAME,viewComponent);
         this.initEvent();
      }
      
      public function get view() : MapView
      {
         return this.getViewComponent() as MapView;
      }
      
      private function initEvent() : void
      {
         EventManager.attachEvent(this.view,MapView.MAPLOADED,this.onMapLoaded);
         EventManager.attachEvent(this.view,MapView.ROLEMOVE,this.sendPositionToServer);
         EventManager.attachEvent(this.view,MapView.ACTIONEVENT,this.onAction);
         EventManager.attachEvent(this.view,MapView.LEAVEBOB,this.onLeaveBob);
         EventManager.attachEvent(this.view,EventConst.MOUSECURSORCLICK,this.onClickMouseCursorAi);
         EventManager.attachEvent(this.view,MapView.REQ_HOUHUA_DATA,this.reqHouHuaData);
         GameData.instance.addEventListener("changmapscale",this.onScaleMapHandler);
         EventManager.attachEvent(this.view,EventConst.ACTIVITY_DANCE_LEVEL,this.onDance_level);
      }
      
      private function onScaleMapHandler(event:Event) : void
      {
         MapView.instance.masterPerson.stop();
         MapView.instance.scene.scalescene(GameData.instance.scaleStep);
         MapView.instance.masterPerson.runner.scaleScroll(MapView.instance.masterPerson.x,MapView.instance.masterPerson.y,GameData.instance.scaleStep);
      }
      
      private function reqHouHuaData(evt:Event) : void
      {
         sendMessage(MsgDoc.OP_CLIENT_REQ_HOUHUA_DATA.send,2001);
      }
      
      private function onMapLoaded(evt:MessageEvent) : void
      {
         if(int(evt.body) != 1013)
         {
            GameData.instance.playerData.shenshouBackId = int(evt.body);
         }
         GameData.instance.playerData.currentScenenId = int(evt.body);
         sendMessage(MsgDoc.OP_CLIENT_REQ_ENTER_SCENE.send,int(evt.body));
         var xml:XML = XMLLocator.getInstance().mapdic[int(evt.body)];
         if(Boolean(xml))
         {
            if(int(xml["havecountry"]) == 1)
            {
               GameData.instance.playerData.araamapId = int(xml["countryid"]);
            }
            else
            {
               GameData.instance.playerData.araamapId = 0;
            }
            if(Boolean(xml.hasOwnProperty("type")))
            {
               GameData.instance.playerData.sceneType = int(xml["type"]);
               if(int(xml["type"]) != 2)
               {
                  if(GameData.instance.playerData.copyScene > 0)
                  {
                     this.justLeftCopy();
                  }
               }
               CacheData.instance.sceneName = xml.@name;
               if(Boolean(xml.hasOwnProperty("horseState")))
               {
                  CacheData.instance.scenceHorseLimited = xml.horseState;
               }
               else
               {
                  CacheData.instance.scenceHorseLimited = 3;
               }
               CacheData.instance.scenceHorseTips = int(xml.horseTips) & 0xFF;
            }
         }
         if(GameData.instance.playerData.sceneType != 0 || GameData.instance.playerData.currentScenenId == 15000)
         {
            dispatch(EventConst.PAUSE_PAPERHORSE);
         }
         else
         {
            dispatch(EventConst.RESUME_PAPERHORSE);
         }
      }
      
      private function onAction(evt:MessageEvent) : void
      {
         var obj:Object = evt.body;
         var userId:int = GlobalConfig.userId;
         if(MouseActionControl.instance.check(this.view,obj.actionid,obj))
         {
            if(!obj.hasOwnProperty("destid"))
            {
               obj.destid = 0;
            }
            sendMessage(MsgDoc.OP_CLIENT_SEND_ACTION.send,1,[userId,obj.actionid,int(obj.destx),int(obj.desty),obj.flag,obj.destid]);
         }
      }
      
      private function onLeaveBob(event:MessageEvent) : void
      {
         if(Boolean(GameData.instance.playerData.bobOwner & 1 == 1))
         {
            sendMessage(MsgDoc.OP_CLIENT_OUT_BOB.send);
         }
         else
         {
            sendMessage(MsgDoc.OP_CLIENT_OUT_DBOB.send);
         }
      }
      
      private function requestNPCState(evt:MessageEvent) : void
      {
         sendMessage(MsgDoc.OP_CLIENT_NPC_STATUS.send,int(evt.body));
      }
      
      private function onDance_level(e:Event) : void
      {
         trace("玩家离开舞台的时候执行操作！",GameData.instance.playerData.pos);
         sendMessage(MsgDoc.OP_CLIENT_DANCE_STAGE.send,2,[GameData.instance.playerData.pos]);
      }
      
      override public function listEvents() : Array
      {
         return [[EventConst.ENTER_WORLD_BACK,this.onEnterWorldBack],[EventConst.ENTER_SCENE_BACK,this.onEnterSceneBack],[EventConst.REQUEST_PLAYERLIST_BACK,this.onRequestPlayerListBack],[EventConst.ONUSERENTER,this.onUserEnterScene],[EventConst.ONUSERLEAVE,this.onUserLeave],[EventConst.ON_USER_MOVE_BACK,this.onUserMove],[EventConst.SENDACTION,this.onAction],[EventConst.MONSTEROPERATION,this.onMonsterOperation],[EventConst.GCMONSTERSETFOLLOWBACK,this.onGcMonsterSetFollowBack],[EventConst.SENDCHANGEDRESSBACK,this.onDressChanged],[EventConst.SENDPUBLICKMSGBACK,this.onSendMsgBack],[EventConst.ENTERROOMBACK,this.onEnterRoomBack],[EventConst.ENTERSCENE,this.onEnterScene],[EventConst.ONCLICKDOOR,this.onClickDoor],[EventConst.ONGETNPCLISTBACK,this.onGetNpcListBack],[EventConst.ONGETNPCSTATEBACK,this.onGetNpcStateBack],[EventConst.OPENTREASUREHOUSE,this.onOpenTreasureHouse],[EventConst.ONLEFTCOPY,this.onLeftCopy],[EventConst.SENDUSERTOOTHERSCENE,this.sendUserToOtherScene],[EventConst.CHANGEBODYCARDBACK,this
         .someOneChangeBody],[EventConst.ENTERCOPYSENCE,this.enterCopySence],[EventConst.CARDHASPASSTIMEBACK,this.onSomeOneCardPassTime],[EventConst.TRUMPBACK,this.trumpBack],[EventConst.RECALL_TRUMP_BACK,this.recallTrumpBack],[EventConst.STARTTOPLAYANIMATION,this.onStartToPlayAnimation],[EventConst.REMOVETRUMP,this.removejiayuanfabao],[EventConst.LINGQUPRIZEBACK,this.lingquBack],[EventConst.REQUESTNPCSTATE,this.requestNPCState],[EventConst.ONCLICKNPC,this.onClickNPCNew],[EventConst.REMOVEDYNAMICTASKNPC,this.onRemoveGameSprite],[EventConst.ROLEMOVE,this.sendPositionToServer],[EventConst.REQCOPYNEXTLEVEL,this.onGotoNextLevel],[EventConst.SENDACTIONBACK,this.onSendActionBack],[EventConst.ENABLEROBOT,this.enableRobot],[EventConst.REMOVEMASTERABOVEAI,this.onRemoveMasterAboveAI],[EventConst.PLAYNPCEFFECTBYTASK,this.onPlayEffectByTask],[EventConst.NEEDLISTENMOUSECURSORAI,this.onNeedListenMouseCursorai],[EventConst.CLICKNPCWITHOUTSCENECHECK,this.clickNpcWithOutCheckScene],[EventConst.ZHIYINOVER,this.zhiyinOver]
         ,[EventConst.GOTOZIYUANCANG,this.gotoZiyuanCang],[EventConst.UPDATEPLAYERDATA,this.updatePlayerName],[EventConst.ONMOVESTONETORIGHTPLACE,this.onMoveStoneToRightPlace],[EventConst.SCENEAREAAI,this.onTrigerSceneAI],[EventConst.DRESSCHANGEBACK,this.onDressChangeBack],[EventConst.ADDDYNAMICUIONMAINUI,this.addGameDynamicUI],[EventConst.NONSENSE_NPC_SAY_SOMETHING,this.nonsenseNPCSaySomething],[EventConst.EATOUT,this.eatOutMasterPerson],[EventConst.ENTER_SCENE_FAILED,this.onEnterSceneFailed],[EventConst.ONCLICKELEPHENT,this.gotoElephent],[EventConst.BATTLE_TO_TASK,this.battleOver],[EventConst.ONGOTOYUNZHANDONG,this.onGotoYunzhandong],[EventConst.ONGOTOLIANDANFANG,this.onGotoLiandanfang],[EventConst.CHECKPOSITIONBACK,this.checkPositionBack],[EventConst.LEAVEBOB_DIRECTION,this.onLeaveBob],[EventConst.SHOWTRAINGMONSTERSATHOME,this.onShowTraingMonsters],[EventConst.CHEAKFISHINGORNOTBACK,this.startFishing],[EventConst.STOPFISHING,this.stopFishing],[EventConst.CHOOSEFISH,this.chooseFish],[EventConst
         .SENDXIYOUPERSON,this.onSendXiYouPerson],[EventConst.CHANGENAMEBORDERBACK,this.onChangeNameBorder],[EventConst.CANCELCHANGEBACK,this.onCancelChangeBack],[EventConst.JOB_INFO_BACK,this.jobInfoBack],[EventConst.ENTER_FAMILY_BASE_BACK,this.enterFamilyRoom],[EventConst.REQ_PLAYER_STATE,this.onPlayerState],[EventConst.HORSEUSEBACK,this.onHorseUseback],[EventConst.CANCELHORSE,this.onCancelHorse],[EventConst.PLAYERCHANGENAMEBACK,this.onPlayerChangeNameBack],[EventConst.PLAYBADGEMOVIE,this.onPlayerBadgeMovie],[EventConst.USE_CLICK_DAILY_TASK_MSG,this.onUseClickDailyTaskMsg],[EventConst.OP_THE_BALLON_ACTIVE,this.onOpBallonActive],[EventConst.SHOW_AWARD_ALERT_BY_MATERIAL,this.showAwardByMaterial],[EventConst.HIDE_GAMEPERSON,this.hideMasterPerson],[EventConst.USE_TAI_SHANG_LING_BACK,this.onUseTaishanglingBack],[EventConst.SHOW_MONSTER,this.onServerShowMonster],[EventConst.MAKE_CRAZY_RECORD_SCENE_LIST,this.makeCrazyRecordRoomList],[EventConst.ALLPERSONINSCENE,this.onAllPersonInScene],[EventConst.REQ_HOUHUA_DATA_BACK
         ,this.onReqHouhuaDataBack],[EventConst.PLAYERACTION_BACK,this.onPlayerActionBack],[EventConst.ON_CHANGE_FACE,this.onChangeFaceBack],[EventConst.CHANG_FACE_EYE_BACK,this.onChangeFaceEyeBack],[EventConst.GET_SIGNAL_OF_ADD_ACTIVITY_AI,this.onGetSignalOfAddAIBack],[EventConst.ACTIVITY_MESSAGE_GHARRY,this.onActivityMessageHandler],[EventConst.REQ_ENTER_ROOM,this.onRegEnterRoom],[EventConst.S_TITLE_UPDATE_SHOW,this.onUpdateShowHandler],[EventConst.S_VIP_LEVEL_UP_TO_SUPER,this.onPlayerToBeSuperVip],[EventConst.S_NEWHAND_BRAVE_SEND,this.onNewHandBraveGuide]];
      }
      
      private function onPlayerToBeSuperVip(evt:MessageEvent) : void
      {
         GameData.instance.playerData.isSupertrump = true;
         if(Boolean(this.view.masterPerson))
         {
            this.view.masterPerson.updateSuperVipLabel();
            this.view.masterPerson.updataFabao();
            VIPPrivilegeView.getInstance().updateView();
         }
      }
      
      private function onChangeFaceBack(evt:MessageEvent) : void
      {
         var role:GamePerson = null;
         if(!GameData.instance.playerData.isInWarCraft)
         {
            role = this.view.findGameSprite(evt.body.userId) as GamePerson;
            if(role == null)
            {
               return;
            }
            if(evt.body.userId == GameData.instance.playerData.userId)
            {
               GameData.instance.playerData.roleType = evt.body.roleType;
               role.updateDress(GameData.instance.playerData,true);
            }
            else
            {
               role.showData.roleType = evt.body.roleType;
               role.updateDress(role.showData);
            }
         }
      }
      
      private function onChangeFaceEyeBack(evt:MessageEvent) : void
      {
         var role:GamePerson = null;
         if(evt.body.result == 1)
         {
            role = this.view.findGameSprite(evt.body.uid) as GamePerson;
            if(role != null)
            {
               if(evt.body.uid == GameData.instance.playerData.userId)
               {
                  GameData.instance.playerData.faceId = evt.body.faceId;
                  this.view.masterPerson.updateDress(GameData.instance.playerData);
               }
               else
               {
                  role.showData.faceId = evt.body.faceId;
                  role.updateDress(role.showData);
               }
            }
         }
      }
      
      private function onReqHouhuaDataBack(evt:MessageEvent) : void
      {
         this.view.reqHouHuaDataBack();
      }
      
      private function onServerShowMonster(evt:MessageEvent) : void
      {
         var params:Object = evt.body;
         MonsterManger.instance.addServerMonsterList(params.list);
      }
      
      private function onCancelHorse(evt:MessageEvent) : void
      {
         sendMessage(MsgDoc.OP_CLIENT_HORSE_USE.send,2);
      }
      
      private function onHorseUseback(evt:MessageEvent) : void
      {
         var role:GamePerson = null;
         var r:GamePerson = null;
         var params:Object = evt.body;
         if(params != null)
         {
            if(params.code == -2)
            {
               new Alert().showOne("你不是VIP，或者你的VIP等级不够哦");
               return;
            }
            if(params.code == 1)
            {
               if(params.result == 1)
               {
                  role = this.view.findGameSprite(params.userId) as GamePerson;
                  if(role != null)
                  {
                     role.setHorse(params.horseSpeed,params.horseIndex,params.horseId);
                  }
               }
               else
               {
                  if(params.result == -1)
                  {
                     new FloatAlert().show(this.view.stage,300,300,"小卡布，骑乘坐骑要有坐骑套装【赤武骑装】哦O(∩_∩)O");
                  }
                  if(params.result == -2)
                  {
                     new FloatAlert().show(this.view.stage,300,300,"这只神兽坐骑太累了，要明天才能恢复体力(⊙o⊙)");
                  }
               }
            }
            else if(params.code == 2)
            {
               if(params.result == 1)
               {
                  r = this.view.findGameSprite(params.userId) as GamePerson;
                  if(r != null)
                  {
                     r.cancelHorse();
                  }
               }
               else
               {
                  new FloatAlert().show(this.view.stage,300,300,"取消骑乘失败");
               }
            }
         }
      }
      
      private function onPlayerState(evt:MessageEvent) : void
      {
         sendMessage(MsgDoc.OP_CLIENT_REQPLAYER_STATE.send,0,evt.body as Array);
      }
      
      private function onCancelChangeBack(evt:MessageEvent) : void
      {
         if(GameData.instance.playerData.currentScenenId == 15000)
         {
            return;
         }
         var params:Object = evt.body;
         var role:GamePerson = this.view.findGameSprite(params.userId) as GamePerson;
         if(role != null)
         {
            role.cancelChange(params);
         }
         if(params.userId == GlobalConfig.userId)
         {
            MouseEnableView.instance.unload();
         }
      }
      
      private function jobInfoBack(event:MessageEvent) : void
      {
         if(event.body.params == 3)
         {
            this.view.stopRoleJobStatus(event.body.checknum as int);
         }
         if(event.body.params == 1 && event.body.checknum != -1)
         {
            this.view.hideMyselfAndPlay(event.body.checknum as int);
         }
      }
      
      private function stopFishing(evt:MessageEvent) : void
      {
         FishManager.getInstance().stopFishing(true);
      }
      
      private function chooseFish(evt:MessageEvent) : void
      {
         FishManager.getInstance().chooseFish();
      }
      
      private function startFishing(evt:MessageEvent) : void
      {
         if(evt.body.fishbool == 1)
         {
            FishManager.getInstance().startFishing(evt.body);
         }
         else
         {
            FishManager.getInstance().overFishing(evt.body);
         }
      }
      
      private function checkPositionBack(evt:MessageEvent) : void
      {
         var desc:String = null;
         var xml:XML = null;
         var body:Object = evt.body;
         if(body.serverId == -1 || body.sceneId == -1)
         {
            new Alert().show("当前好友不在线");
         }
         else
         {
            if(body.serverId == 0)
            {
               desc = "当前";
            }
            else
            {
               desc = body.serverId + "";
            }
            xml = XMLLocator.getInstance().mapdic[body.sceneId] as XML;
            if(xml == null)
            {
               new Alert().showSureOrCancel("当前好友在家园");
            }
            else if(body.serverId >= 10000)
            {
               new Alert().showSureOrCancel("当前好友在" + xml.@name);
            }
            else
            {
               new Alert().showSureOrCancel("当前好友在" + desc + "服的" + xml.@name);
            }
         }
      }
      
      private function sendPositionToServer(evt:MessageEvent) : void
      {
         var obj:Object = evt.body;
         if(this.view.masterPerson.ui.parent == null)
         {
            return;
         }
         var point:Point = this.view.masterPerson.ui.parent.globalToLocal(new Point(obj.newx,obj.newy));
         sendMessage(MsgDoc.OP_CLIENT_PLAYER_START_MOVING.send,0,[int(point.x),int(point.y),GlobalConfig.userId,this.view.masterPerson.showData.moveFlag]);
      }
      
      private function removejiayuanfabao(evt:MessageEvent) : void
      {
         this.view.removeTrump();
      }
      
      private function onStartToPlayAnimation(event:MessageEvent) : void
      {
         var xCoord:Number = NaN;
         var yCoord:Number = NaN;
         var gs:GameSprite = null;
         var tmpPoint:Point = null;
         var param:Object = event.body;
         if(Boolean(param.hasOwnProperty("npcid")) && param.npcid != 0)
         {
            gs = this.view.findGameSprite(IdName.npc(param.npcid));
            if(gs == null)
            {
               gs = this.view.findGameSprite(IdName.sceneAI(param.npcid));
            }
            if(gs == null)
            {
               gs = this.view.findGameSprite(IdName.specialArea(param.npcid));
            }
            if(gs == null)
            {
               gs = this.view.masterPerson;
            }
            xCoord = gs.x;
            yCoord = gs.y;
         }
         else if(param.x == -1 && param.y == -1)
         {
            tmpPoint = this.view.masterPerson.ui.parent.localToGlobal(new Point(this.view.masterPerson.x,this.view.masterPerson.y));
            xCoord = tmpPoint.x;
            yCoord = tmpPoint.y - 55;
         }
         else if(param.x == -2 && param.y == -2)
         {
            xCoord = this.view.masterPerson.mm.x;
            yCoord = this.view.masterPerson.mm.y;
         }
         else if(param.x == -3 && param.y == -3)
         {
            xCoord = 0;
            yCoord = 0;
            this.dispatch(EventConst.HIDE_GAMEPERSON,{"type":1});
         }
         else
         {
            xCoord = Number(param.x);
            yCoord = Number(param.y);
         }
         if(Boolean(param.hasOwnProperty("effectName")) && (param.effectName.length != 0 || param.effectName != ""))
         {
            if(param.hasOwnProperty("targetFunction"))
            {
               GameAction.instance.playEffect(this.view,xCoord,yCoord,param.effectName,param.targetFunction);
            }
            else
            {
               GameAction.instance.playEffect(this.view,xCoord,yCoord,param.effectName);
            }
         }
         else
         {
            GameAction.instance.playSwf(this.view,xCoord,yCoord,param.url,param.targetFunction,param.type);
         }
      }
      
      private function recallTrumpBack(params:Object) : void
      {
         if(params.body["userId"] == GlobalConfig.userId)
         {
            GameData.instance.playerData.state = params.body["ope"];
            GameData.instance.playerData.trumpAppearance = params.body["trumpAppearance"];
         }
         var role:GamePerson = this.view.findGameSprite(params.body["userId"]) as GamePerson;
         if(Boolean(role))
         {
            role.showData.state = params.body["ope"];
            role.showData.trumpAppearance = params.body["trumpAppearance"];
            role.updataFabao();
         }
         if(params.body["ope"] == 2)
         {
            this.view.removeTrump();
         }
      }
      
      private function onEnterWorldBack(event:MessageEvent) : void
      {
         var params:PlayerData = GameData.instance.playerData;
         var code:int = GameData.instance.playerData.isNewHand;
         if(code == 1 || code == 2 || code == 3 || code == 4)
         {
            if(GameData.instance.playerData.sex > 0)
            {
               this.changeScene(901);
            }
            else
            {
               this.changeScene(902);
            }
         }
         else if(params.sceneId == 901 || params.sceneId == 902)
         {
            this.changeScene(1006);
         }
         else
         {
            this.changeScene(params.sceneId);
         }
      }
      
      private function onEnterSceneBack(event:MessageEvent) : void
      {
         var horseCheckData:HorseCheckVo = null;
         this.tempareaid = GameData.instance.playerData.currentScenenId;
         this.tempcount = 0;
         if(this.crazyRecordRoom.indexOf(GameData.instance.playerData.nextSceneId) == -1)
         {
            GameData.instance.playerData.isInCrazyRecordRoom = false;
            this.dispatch(EventConst.MAKE_CRAZY_RECORD_SCENE_LIST,false);
         }
         if(this.independentList != null && this.independentList.length > 0)
         {
            this.independentList = null;
         }
         dispatch(EventConst.CLEARUI);
         if(this.stoneAccount != null)
         {
            this.stoneAccount = null;
         }
         this.view.onEnterSceneBack();
         this.currentSceneCount = 0;
         if(this.view.hasEventListener(Event.ENTER_FRAME))
         {
            this.view.removeEventListener(Event.ENTER_FRAME,this.cheakFall);
         }
         if(GameData.instance.playerData.nextSceneId == 1013)
         {
            dispatch(EventConst.OPEN_CACHE_VIEW,{
               "showX":0,
               "showY":0
            },null,getQualifiedClassName(ShenshouView));
         }
         else if(GameData.instance.playerData.nextSceneId == 1018)
         {
            dispatch(EventConst.OPEN_CACHE_VIEW,{
               "showX":0,
               "showY":0
            },null,getQualifiedClassName(FarmView));
         }
         else if(this.crazyRecordRoom.indexOf(GameData.instance.playerData.nextSceneId) != -1)
         {
            FaceView.clip.topClip.visible = false;
            this.dispatch(EventConst.BOBSTATECLICK,{
               "url":"assets/module/CrazyRecordRoom.swf",
               "xCoord":0,
               "yCoord":0
            });
            GameData.instance.playerData.isInCrazyRecordRoom = true;
         }
         if(GameData.instance.playerData.hasLinHorse)
         {
            GameData.instance.playerData.hasLinHorse = false;
            dispatch(EventConst.OPENSWFWINDOWS,{
               "url":"assets/material/taozhuang.swf",
               "xCoord":130,
               "yCoord":0
            });
         }
         if(GameData.instance.playerData.nextSceneId == 14000)
         {
            if(!GameData.instance.playerData.isInMazeIsland)
            {
               this.dispatch(EventConst.OPEN_MODULE,{
                  "url":"assets/mazeroad/MazeCopy.swf",
                  "xCoord":0,
                  "yCoord":0
               });
            }
            else
            {
               this.dispatch(EventConst.ON_ENTER_MAZE_SCENE_SUCCESSED,1);
            }
         }
         else if(GameData.instance.playerData.nextSceneId == 14001)
         {
            this.dispatch(EventConst.ON_ENTER_MAZE_SCENE_SUCCESSED,2);
         }
         else
         {
            GameData.instance.playerData.isInMazeIsland = false;
         }
         this.dispatch(EventConst.PERSON_CAN_OR_NOT_MOVE,false);
         if(!GameData.instance.playerData.ableName && GameData.instance.playerData.isNewHand > 6)
         {
            dispatch(EventConst.BOBSTATECLICK,{"url":"assets/material/AlertChangeName.swf"});
            this.sendMessage(MsgDoc.OP_CLIENT_CHANGNAME.send,0,[1,"卡布001"]);
            GameData.instance.playerData.userName = "卡布001";
            this.view.masterPerson.showData.userName = "卡布001";
            this.view.masterPerson.setPeronName("卡布001");
            GameData.instance.playerData.ableName = true;
         }
         if(GameData.instance.playerData.horseID != 0)
         {
            horseCheckData = new HorseCheckVo();
            horseCheckData.horseId = GameData.instance.playerData.horseID;
            horseCheckData.sceneId = GameData.instance.playerData.currentScenenId;
            HorseCheck.instance.checkBySceneId(horseCheckData,this.checkHorseBack);
         }
         if(GameData.instance.playerData.isVipTimeUp)
         {
            if(GamePersonControl.instance.isFlyIngHorse(GameData.instance.playerData.horseID))
            {
               GameData.instance.playerData.horseID = 0;
               sendMessage(MsgDoc.OP_CLIENT_HORSE_USE.send,2);
            }
            GameData.instance.playerData.isVipTimeUp = false;
            dispatch(EventConst.OPEN_CACHE_VIEW,{
               "showX":0,
               "showY":0
            },null,getQualifiedClassName(VIPNoticeView));
         }
         else if(GameData.instance.playerData.newvalue[16] == 1)
         {
            GameData.instance.playerData.newvalue[16] = 0;
            ApplicationFacade.getInstance().dispatch(EventConst.OPEN_MODULE,{"url":"assets/vip/privilege/BecomeSuperVip.swf"});
         }
         if(this.flag)
         {
            FaceView.clip.topClip.hideBtnByName("metalHeroBtn");
            FaceView.clip.topClip.hideBtnByName("battleClip");
            this.onGetServerData();
            this.flag = false;
         }
         if(CacheData.instance.palyerStateDic[2] == 1)
         {
            sendMessage(MsgDoc.OP_CLIENT_ACTIVITY_QINGYANG.send,10000,[0]);
            CacheData.instance.palyerStateDic[2] = 0;
         }
         TaskList.getInstance().freshManTaskFlag = 0;
         if(GameData.instance.playerData.nextSceneId == 20002)
         {
            dispatch(EventConst.BOBSTATECLICK,{
               "url":"assets/module/SealMonsterReelScene.swf",
               "xCoord":0,
               "yCoord":0
            });
            FaceView.clip.visible = false;
         }
         if(!(GameData.instance.playerData.isInWarCraft || GameData.instance.playerData.bobOwner == 1 || GameData.instance.playerData.bobOwner == 2 || GameData.instance.playerData.copyScene != 0))
         {
            dispatch(EventConst.BOBSTATECLICK,{
               "url":"assets/activity/201401/20140127Fuqi/Activity20140127FuqiAI.swf",
               "xCoord":0,
               "yCoord":0
            });
         }
         if(Boolean(GameData.instance.autoLookForPresuresData.isAutoNum))
         {
            ApplicationFacade.getInstance().dispatch(EventConst.OPEN_MODULE,{"url":"assets/module/lookForPresuresAuto/LookForPresuresAuto.swf"});
         }
         if(Boolean(GameData.instance.autoCollectData.isAutoNum))
         {
            ApplicationFacade.getInstance().dispatch(EventConst.OPEN_MODULE,{"url":"assets/module/CollectAuto/CollectAuto.swf"});
         }
         if(GameData.instance.playerData.nextSceneId == 22008 && GlobalConfig.otherObj["ACT_672_zy"] == 1)
         {
            GlobalConfig.otherObj["ACT_672_zy"] = 0;
            FaceView.clip.topClip.showRedPointByName("escortGoodsBtn",false);
            ApplicationFacade.getInstance().dispatch(EventConst.BOBSTATECLICK,{
               "url":"assets/activity/zkz25/Act672Escort/Act672EscortEntrance.swf",
               "moduleParams":{"flag":1}
            });
         }
      }
      
      private function onGetServerData() : void
      {
         sendMessage(MsgDoc.OP_CLIENT_ACTIVITY_QINGYANG.send,198,[1]);
         sendMessage(MsgDoc.OP_CLIENT_ACTIVITY_QINGYANG.send,224,[3,0]);
         sendMessage(MsgDoc.OP_CLIENT_ACTIVITY_QINGYANG.send,294,[2]);
         sendMessage(MsgDoc.OP_CLIENT_ACTIVITY_QINGYANG.send,402,[1]);
         sendMessage(MsgDoc.OP_CLIENT_ACTIVITY_QINGYANG.send,405,[1]);
         sendMessage(1185428,406,[1]);
         sendMessage(MsgDoc.OP_CLIENT_ACTIVITY_QINGYANG.send,500,[1]);
         sendMessage(MsgDoc.OP_CLIENT_ACTIVITY_QINGYANG_NEW.send,601,["open_ui"]);
         sendMessage(MsgDoc.OP_CLIENT_ACTIVITY_QINGYANG_NEW.send,603,["ui_info"]);
         sendMessage(MsgDoc.OP_CLIENT_ACTIVITY_QINGYANG_NEW.send,604,["ui_info"]);
         sendMessage(MsgDoc.OP_CLIENT_ACTIVITY_QINGYANG_NEW.send,632,["ui_info"]);
         sendMessage(MsgDoc.OP_CLIENT_ACTIVITY_QINGYANG_NEW.send,764,["login"]);
         sendMessage(MsgDoc.OP_CLIENT_ACTIVITY_QINGYANG_NEW.send,750,["progress"]);
         sendMessage(MsgDoc.OP_CLIENT_ACTIVITY_QINGYANG_NEW.send,758,["get_red"]);
         sendMessage(MsgDoc.OP_CLIENT_ACTIVITY_QINGYANG_NEW.send,776,["sweep_info"]);
         sendMessage(MsgDoc.OP_CLIENT_ACTIVITY_QINGYANG_NEW.send,777,["open_ui"]);
         if(GameData.instance.playerData.isNewHand >= 9)
         {
            CacheData.instance.onlineIntros;
            CacheData.instance.kabuOnline.requestInfo();
            sendMessage(MsgDoc.OP_CLIENT_ACTIVITY_QINGYANG.send,276,[1]);
            sendMessage(MsgDoc.OP_CLIENT_ACTIVITY_QINGYANG_NEW.send,774,["open_ui"]);
            sendMessage(MsgDoc.OP_CLIENT_ACTIVITY_QINGYANG_NEW.send,784,["ui_info"]);
         }
      }
      
      private function checkHorseBack(checkData:HorseCheckVo) : void
      {
         if(!checkData.checkResult)
         {
            GameData.instance.playerData.horseID = 0;
            sendMessage(MsgDoc.OP_CLIENT_HORSE_USE.send,2);
         }
      }
      
      private function onRequestPlayerListBack(event:MessageEvent) : void
      {
         var obj:Object = null;
         DelayShowUtil.instance.systemControl = true;
         if(GameData.instance.playerData.isNewHand < 7)
         {
            DelayShowUtil.instance.systemControl = false;
            return;
         }
         if(GameData.instance.playerData.isInWarCraft)
         {
            return;
         }
         var list:Array = event.body.playerlist as Array;
         GameData.instance.playerLists = GameData.instance.playerLists.concat(list);
         if(GameData.instance.playerData.myTeamData != null)
         {
            GameData.instance.playerData.myTeamData.setNotSaveScene();
            for each(obj in GameData.instance.playerLists)
            {
               GameData.instance.playerData.myTeamData.updateSaveScene(obj.userId,true,true);
            }
            dispatch(EventConst.TEAM_UPDATE_SAVE_SCENE);
         }
         DelayShowUtil.instance.showPlayers();
      }
      
      private function onUserEnterScene(event:MessageEvent) : void
      {
         if(GameData.instance.playerData.isNewHand < 7)
         {
            return;
         }
         if(GameData.instance.playerData.isInWarCraft)
         {
            return;
         }
         var params:ShowData = event.body as ShowData;
         DelayShowUtil.instance.f_addPlayer(params);
         if(GameData.instance.playerData.myTeamData != null)
         {
            if(GameData.instance.playerData.myTeamData.updateSaveScene(params.userId,true))
            {
               dispatch(EventConst.TEAM_UPDATE_SAVE_SCENE);
            }
         }
      }
      
      private function onUserLeave(event:MessageEvent) : void
      {
         DelayShowUtil.instance.f_delPlayer(int(event.body));
         if(GameData.instance.playerData.myTeamData != null)
         {
            if(GameData.instance.playerData.myTeamData.updateSaveScene(int(event.body),false))
            {
               dispatch(EventConst.TEAM_UPDATE_SAVE_SCENE);
            }
         }
      }
      
      private function onUserMove(event:MessageEvent) : void
      {
         this.view.userMove(event.body);
      }
      
      private function onSendActionBack(evt:MessageEvent) : void
      {
         dispatch(EventConst.UPDATE_MAGIC_NUM,evt.body);
         new MagicSendManager().sendActionBack(this.view,this,evt.body);
      }
      
      private function onMonsterOperation(event:MessageEvent) : void
      {
         var role:GamePerson = this.view.findGameSprite(event.body.userId) as GamePerson;
         if(Boolean(role))
         {
            role.showData.mstate = event.body.ope;
            if(event.body.ope == 0)
            {
               role.showData.mid = 0;
            }
            else
            {
               role.showData.mid = event.body.mid;
            }
            role.showData.msid = event.body.msid;
            role.showData.mname = event.body.name;
            role.showData.mstateCount = event.body.mstateCount;
            role.updataMM();
         }
         if(event.body.userId == GlobalConfig.userId)
         {
            GameData.instance.playerData.mstate = event.body.ope;
            GameData.instance.playerData.mid = event.body.mid;
            GameData.instance.playerData.msid = event.body.msid;
            GameData.instance.playerData.mname = event.body.name;
            GameData.instance.playerData.mstateCount = event.body.mstateCount;
         }
         if(event.body.userId == GlobalConfig.userId && event.body.ope == 0)
         {
            GameData.instance.playerData.mid = 0;
            GameData.instance.playerData.msid = -1;
         }
      }
      
      private function onGcMonsterSetFollowBack(event:MessageEvent) : void
      {
         var role:GamePerson = this.view.findGameSprite(event.body.userId) as GamePerson;
         if(Boolean(role))
         {
            role.showData.mstate = event.body.ope;
            if(event.body.ope == 0)
            {
               role.showData.mid = 0;
            }
            else
            {
               role.showData.mid = event.body.mid;
            }
            role.showData.msid = event.body.msid;
            role.showData.mname = event.body.name;
            role.updataMM();
         }
      }
      
      private function onDressChanged(params:Object) : void
      {
         var role:GamePerson = this.view.findGameSprite(params.userId) as GamePerson;
         if(role != null)
         {
         }
      }
      
      private function someOneChangeBody(evt:MessageEvent) : void
      {
         if(evt.body.roleid != -4)
         {
            this.view.masterPerson.changeBody(evt.body.roleid,evt.body.callback);
         }
         else
         {
            this.view.masterPerson.backToInitRoleFace(null);
         }
      }
      
      private function onSomeOneCardPassTime(params:Object) : void
      {
         var role:GamePerson = this.view.findGameSprite(params.userId) as GamePerson;
         if(role != null)
         {
         }
      }
      
      private function onSendMsgBack(event:MessageEvent) : void
      {
         var body:Object = null;
         var params:Object = event.body;
         var role:* = this.view.findGameSprite(params.id);
         if(params.flag == 0)
         {
            if(role != null)
            {
               role.msg = params.content;
               body = {
                  "roleType":role.showData.roleType,
                  "hatId":role.showData.hatId,
                  "faceId":role.showData.faceId,
                  "footId":role.showData.footId,
                  "clothId":role.showData.clothId
               };
               if(GameData.instance.playerData.isInWarCraft)
               {
                  params.from_name = role.spriteName;
                  dispatch(EventConst.SHOW_PUBLIC_MSG_IN_WARCRAFT,params);
               }
               else
               {
                  FaceView.clip.chatClip.sceneChatData({
                     "roleid":params.id,
                     "name":role.spriteName,
                     "message":params.content,
                     "body":body
                  });
               }
            }
         }
         else if(role != null)
         {
            role.face = int(params.content);
         }
      }
      
      private function onGetNpcListBack(evt:MessageEvent) : void
      {
         var params:Object = evt.body;
         if(params.hasOwnProperty("npcList"))
         {
            this.toLoadNPC(params);
         }
         if(Boolean(this.newHandBraveData))
         {
            if(Boolean(this.newHandBraveData.npcid))
            {
               ApplicationFacade.getInstance().dispatch(EventConst.ONCLICKNPC,{
                  "id":this.newHandBraveData.npcid,
                  "type":this.newHandBraveData.npcType
               });
            }
            else
            {
               ApplicationFacade.getInstance().dispatch(EventConst.ADDDYNAMICUIONMAINUI,{
                  "type":this.newHandBraveData.type,
                  "x":this.newHandBraveData.x,
                  "y":this.newHandBraveData.y,
                  "uiname":this.newHandBraveData.uiname,
                  "container":this.newHandBraveData.container
               });
            }
            this.newHandBraveData = {};
         }
      }
      
      private function toLoadNPC(params:Object) : void
      {
         var sceneMaterial:* = undefined;
         var i:int = 0;
         var node:XML = null;
         var param:NPCVo = null;
         var isForbitYuangu:Boolean = false;
         var npcList:Array = params.npcList;
         var len:int = int(npcList.length);
         if(len != 0)
         {
            for(i = 0; i < len; i++)
            {
               node = XMLLocator.getInstance().getNPC(npcList[i]);
               param = NpcXMLParser.parse(npcList[i]);
               if(param == null)
               {
                  continue;
               }
               if(this.view.findGameSprite(param.sequenceID) != null)
               {
                  this.view.delGameSpirit(param.sequenceID);
               }
               if(param.hasOwnProperty("removeNPCList"))
               {
                  this.deleteGameSpriteOnAddSomeon(param.removeNPCList);
               }
               if(param.mapid != GameData.instance.playerData.currentScenenId && npcList[i] != 10033)
               {
                  continue;
               }
               isForbitYuangu = this.isFobbitYuanguCondition(npcList[i]);
               if(isForbitYuangu)
               {
                  continue;
               }
               if(int(node.type) == 1 || int(node.type) == 2 || int(node.type) == 3)
               {
                  sceneMaterial = new MultipleNPC(param);
                  this.view.addGameSprite(sceneMaterial);
                  (sceneMaterial as MultipleNPC).load();
                  continue;
               }
               if(int(node.type) == 14)
               {
                  sceneMaterial = new MoveableNPC(param);
                  this.view.addGameSprite(sceneMaterial);
                  continue;
               }
               if(param.type == 6)
               {
                  if(!GlobalConfig.otherObj.hasOwnProperty("MapNpcList"))
                  {
                     GlobalConfig.otherObj["MapNpcList"] = [];
                  }
                  GlobalConfig.otherObj["MapNpcList"].push(npcList[i]);
                  ApplicationFacade.getInstance().dispatch(EventConst.MAP_NPC_LIST_UPDATE);
                  continue;
               }
               sceneMaterial = SceneAIFactory.instance.produce(int(node.type),param);
               if(sceneMaterial == undefined)
               {
                  continue;
               }
               this.view.addGameSprite(sceneMaterial);
               switch(int(node.type))
               {
                  case 4:
                     (sceneMaterial as DynamicBuild).load();
                     break;
                  case 7:
                     if(npcList[i] == 21509)
                     {
                        (sceneMaterial as ActionAI).load(this.sendClickNPC);
                     }
                     else
                     {
                        (sceneMaterial as ActionAI).load();
                     }
                     break;
                  case 8:
                     if(param.special == 2)
                     {
                        (sceneMaterial as SceneAIClick).load(true);
                     }
                     else
                     {
                        (sceneMaterial as SceneAIClick).load();
                     }
                     break;
                  case 9:
                     (sceneMaterial as SpecialArea).load();
                     break;
                  case 10:
                     (sceneMaterial as MouseCursorAI).load();
                     break;
                  case 13:
                     (sceneMaterial as WalkableNPC).load();
                     break;
                  case 16:
                     (sceneMaterial as NPC14017).load();
                     break;
                  case 17:
                     (sceneMaterial as NPC161706).load();
                     break;
                  case 18:
                     (sceneMaterial as OrderClickNPC).load();
                     break;
                  case 19:
                     (sceneMaterial as NPC22013).load();
                     break;
                  case 20:
                     (sceneMaterial as NPC211409).load();
               }
            }
         }
      }
      
      private function isFobbitYuanguCondition($id:int) : Boolean
      {
         var isCopy:Boolean = GameData.instance.playerData.currentScenenId == 3000;
         var isFitLv:Boolean = GameData.instance.playerData.lastcopylevel == 66;
         if($id == 1055010)
         {
            if(isCopy && !isFitLv)
            {
               return true;
            }
         }
         return false;
      }
      
      private function sendUserToOtherScene(evt:MessageEvent) : void
      {
         var param:int = evt.body as int;
         GameData.instance.playerData.currentScenenId = param;
         if(Boolean(GameData.instance.playerData.bobOwner))
         {
            new Alert().showSureOrCancel("是否离开擂台",this.leaveBob,param);
            return;
         }
         if(GameData.instance.playerData.refineState)
         {
            new Alert().showSureOrCancel("确定停止炼制？",this.onRefineAlerClose);
            return;
         }
         dispatch(EventConst.ENTERSCENE,param);
      }
      
      private function leaveBob(str:String, sceneID:int) : void
      {
         if(str == "确定")
         {
            dispatch(EventConst.ENTERSCENE,sceneID);
         }
      }
      
      private function onRefineAlerClose(... rest) : void
      {
         if("确定" == rest[0])
         {
            GameData.instance.playerData.refineState = false;
            this.dispatch(EventConst.STOPREFINE);
         }
      }
      
      private function onGetNpcStateBack(evt:MessageEvent) : void
      {
         var gs:GameSprite = null;
         var obj:Object = null;
         var params:Object = evt.body;
         try
         {
            gs = this.view.findGameSprite(params.npcid);
            if(gs is MultipleNPC)
            {
               (gs as MultipleNPC).updateState(params.npcState + 1);
            }
            else
            {
               (this.view.findGameSprite(IdName.npc(params.npcid)) as Npc).changeNPCState(params.npcState + 1);
            }
         }
         catch(e:*)
         {
            trace("这货不是NPC.....MapControl -> onGetNpcStateBack");
         }
         if(params.hasOwnProperty("monsterID"))
         {
            obj = {};
            obj.monsterID = params.monsterID;
            obj.level = params.level;
            GameData.instance.playerData.dailyTask = obj;
         }
      }
      
      private function lingquBack(event:MessageEvent) : void
      {
         var obj:Object = event.body;
         if(obj.mParams == -1)
         {
            new Alert().show("很遗憾,领取失败!");
         }
         else if(obj.mParams == -2)
         {
            new Alert().show("你已经领取过一次了,下周再来吧(*^__^*)");
         }
         else if(obj.money > 0)
         {
            new AwardAlert().showMoneyAward(obj.money,this.view.stage);
         }
         else if(obj.exp > 0)
         {
            new AwardAlert().showExpAward(obj.exp,this.view.stage);
         }
      }
      
      private function onEnterRoomBack(event:MessageEvent) : void
      {
         if(GameData.instance.playerData.isInGardon)
         {
            sendMessage(MsgDoc.OP_CLIENT_REQ_ENTER_SCENE.send,1002);
         }
         else
         {
            this.changeScene(1002);
         }
      }
      
      private function enterFamilyRoom(evt:MessageEvent) : void
      {
         this.changeScene(1040 + GameData.instance.playerData.family_map_star);
      }
      
      private function onOpenTreasureHouse() : void
      {
         this.changeScene(125);
      }
      
      private function trumpBack(params:Object) : void
      {
         if(Boolean(params.body.hasOwnProperty("userId")))
         {
            this.view.addTrump(params.body,true);
         }
         else
         {
            trace(params);
         }
      }
      
      private function onEnterScene(event:MessageEvent) : void
      {
         if(int(event.body) == 30006 && TaskList.getInstance().getStateOfSpecifiedSubtask(3019001) > 0 && (30007 == int(event.body) && !TaskList.getInstance().hasBeenComplete(3019001)))
         {
            new Alert().show("想进去？那就去找傲来海岸上摘椰子的老猴子吧！");
            return;
         }
         if(GameData.instance.playerData.bobOwner > 0)
         {
            if(GameData.instance.playerData.bobOwner == 2)
            {
               sendMessage(MsgDoc.OP_CLIENT_BATTLE_DBOB.send);
            }
            else
            {
               sendMessage(MsgDoc.OP_CLIENT_BATTLE_BOB.send);
            }
            GameData.instance.playerData.bobOwner = 0;
         }
         if(this.afterBeFinish.indexOf(int(event.body)) != -1 && (GameData.instance.playerData.magicstate & 1) <= 0)
         {
            new Alert().showOne("你还没有学会化鱼术哦，赶紧前往傲来海岸的老猴子那里去学习吧!~");
            return;
         }
         if(this.isNeedSpecialOperate())
         {
            this.showSpecialOperate(int(event.body));
         }
         else
         {
            this.changeScene(int(event.body));
         }
      }
      
      private function changeScene(code:int) : void
      {
         var nt:int;
         var ct:int;
         if(code == 0)
         {
            return;
         }
         GameData.instance.playerData.isInCrazyRecordRoom = false;
         if(GameData.instance.playerData.bobOwner > 0)
         {
            if(GameData.instance.playerData.bobOwner == 2)
            {
               sendMessage(MsgDoc.OP_CLIENT_BATTLE_DBOB.send);
            }
            else
            {
               sendMessage(MsgDoc.OP_CLIENT_BATTLE_BOB.send);
            }
            GameData.instance.playerData.bobOwner = 0;
         }
         nt = int(XMLLocator.getInstance().mapdic[code]["type"]);
         ct = GameData.instance.playerData.sceneType;
         if(GameData.instance.playerData.currentScenenId == 1018 && CacheUtil.pool[FarmView] != null)
         {
            CacheUtil.pool[FarmView]["disport"]();
         }
         else if(GameData.instance.playerData.currentScenenId == 1013 && CacheUtil.pool[ShenshouView] != null)
         {
            CacheUtil.pool[ShenshouView]["disport"]();
         }
         GameData.instance.playerData.currentScenenId = code;
         if(nt != ct && GameData.instance.playerData.isInHouse && nt != 4 && code != 1013 && code != 1018 && code != 1023 && code != 1024 && code != 1002)
         {
            dispatch(EventConst.EXITWORLD,code);
            GameData.instance.playerData.isInHouse = false;
            GameData.instance.playerData.isInFamily = false;
            return;
         }
         if(nt != 4 && ct == 4 && GameData.instance.playerData.isInFamily && code != 1013 && code != 1018 && code != 1023 && code != 1024 && code != 1002)
         {
            sendMessage(MsgDoc.OP_CLIENT_REQ_LEAVE_FAMILY_BASE.send,GameData.instance.playerData.serverId);
            GameData.instance.playerData.isInFamily = false;
            GameData.instance.playerData.isInHouse = false;
            return;
         }
         try
         {
            if(TaskList.getInstance().isSpecialFreshManFlag())
            {
               switch(code)
               {
                  case 1005:
                     dispatch(EventConst.MASTERISOUTSPECIALAREA,{
                        "npcid":11002,
                        "dialogID":100300102,
                        "freshman":1
                     });
                     break;
                  case 2005:
                     dispatch(EventConst.MASTERISOUTSPECIALAREA,{
                        "npcid":13002,
                        "dialogID":100300109,
                        "freshman":1
                     });
               }
            }
            if(nt != 4 && ct == 4)
            {
               GameData.instance.playerData.isInFamily = false;
            }
            this.view.loadMap(code);
         }
         catch(e:*)
         {
            view.loadMap(2001);
         }
      }
      
      private function onGotoNextLevel(evt:MessageEvent) : void
      {
         this.pa = evt.body;
         this.onArrive();
      }
      
      private function onArrive() : void
      {
         if(GameData.instance.playerData.currentCopyType == 0)
         {
            this.changeScene(2000);
            GameData.instance.playerData.lastcopylevel = this.pa.level;
         }
         if(GameData.instance.playerData.currentCopyType == 1)
         {
            this.changeScene(3000);
            GameData.instance.playerData.lastcopylevel = this.pa.level;
         }
         if(GameData.instance.playerData.currentCopyType == 2)
         {
            this.changeScene(4000);
            GameData.instance.playerData.lastcopylevel = this.pa.level;
         }
      }
      
      private function enterCopySence(event:MessageEvent) : void
      {
         if(event.body.mParams == 0)
         {
            this.changeScene(2000);
            GameData.instance.playerData.copyScene = 1;
         }
         else if(event.body.mParams == 1)
         {
            this.changeScene(3000);
            GameData.instance.playerData.copyScene = 2;
         }
         else if(event.body.mParams == 2)
         {
            this.changeScene(4000);
            GameData.instance.playerData.copyScene = 3;
         }
         else if(event.body.mParams == 3)
         {
            this.changeScene(14000);
            GameData.instance.playerData.copyScene = 4;
         }
         else if(event.body.mParams == -1)
         {
            new Alert().show("进入副本失败");
            dispatch(EventConst.CLEANCOPY);
         }
         else if(event.body.mParams == 6)
         {
            this.changeScene(3007);
            GameData.instance.playerData.copyScene = 6;
         }
      }
      
      private function onLeftCopy(evt:MessageEvent) : void
      {
         GameData.instance.playerData.currentScenenId = evt.body.id;
         O.o("MapControl/onLeftCopy/GameData.instance.playerData.currentScenenId:" + GameData.instance.playerData.currentScenenId);
         sendMessage(MsgDoc.OP_CLIENT_PLAYER_START_MOVING.send,0,[evt.body.steerX,evt.body.steerY,GlobalConfig.userId]);
         this.view.masterPerson.moveto(evt.body.steerX,evt.body.steerY,this.justLeftCopy);
      }
      
      private function onGotoYunzhandong(evt:MessageEvent) : void
      {
         sendMessage(MsgDoc.OP_CLIENT_PLAYER_START_MOVING.send,0,[evt.body.steerX,evt.body.steerY,GlobalConfig.userId]);
         this.view.masterPerson.moveto(evt.body.steerX,evt.body.steerY,this.justGotoYzd2104);
      }
      
      private function onGotoLiandanfang(evt:MessageEvent) : void
      {
         sendMessage(MsgDoc.OP_CLIENT_PLAYER_START_MOVING.send,0,[evt.body.steerX,evt.body.steerY,GlobalConfig.userId]);
         this.view.masterPerson.moveto(evt.body.steerX,evt.body.steerY,this.justGotoLdg2006);
      }
      
      private function justGotoLdg2006() : void
      {
         MapView.instance.loadMap(2006);
      }
      
      private function justGotoYzd2104() : void
      {
         MapView.instance.loadMap(2104);
      }
      
      private function justLeftCopy() : void
      {
         O.o("MapControl/justLeftCopy/GameData.instance.playerData.currentScenenId:" + GameData.instance.playerData.currentScenenId);
         GameData.instance.playerData.isInMazeIsland = false;
         sendMessage(MsgDoc.CLIENT_COPY_LEAVE.send,GameData.instance.playerData.serverId);
         dispatch(EventConst.CLEARUI);
         dispatch(EventConst.CLEANCOPY);
         GameData.instance.playerData.copyScene = 0;
      }
      
      private function onClickDoor(event:MessageEvent) : void
      {
         var point:Point = null;
         if(event.body.hasOwnProperty("steerX"))
         {
            this.backdoorMapId = event.body.id;
            if(this.view.masterPerson.ui.parent == null)
            {
               return;
            }
            point = this.view.masterPerson.ui.parent.localToGlobal(new Point(event.body.steerX,event.body.steerY));
            sendMessage(MsgDoc.OP_CLIENT_PLAYER_START_MOVING.send,0,[point.x,point.y,GlobalConfig.userId]);
            MapView.instance.masterPerson.moveto(point.x,point.y,this.gotoBackDoor);
         }
         else
         {
            dispatch(EventConst.ENTERSCENE,event.body.id);
         }
      }
      
      private function gotoElephent(event:MessageEvent) : void
      {
         if(event.body.hasOwnProperty("x"))
         {
            sendMessage(MsgDoc.OP_CLIENT_PLAYER_START_MOVING.send,0,[event.body.x,event.body.y - 40,GlobalConfig.userId]);
            MapView.instance.masterPerson.moveto(event.body.x,event.body.y - 40,this.gotoBaoxiangguo);
         }
      }
      
      private function gotoBaoxiangguo() : void
      {
         ScreenSprite.instance.show(true);
         this.backdoorMapId = 4001;
         GameSpriteAction.instance.moveLeft(this.view.masterPerson,this.gotoBackDoor,350,1,1.01,"elephent",null,-105,-42);
         MapView.instance.masterPerson.setDirection(0);
         (this.view.scene.bg["getChildAt"](0)["getChildAt"](0)["getChildByName"]("elephentBtn") as SimpleButton).visible = false;
      }
      
      private function onClickNpc(params:Object) : void
      {
         if(Boolean(params.hasOwnProperty("type")) && params.type == -1)
         {
            this.sendMessage(MsgDoc.OP_CLIENT_NPC_WITH_SERVER_CONTROL.send,params.id - 16001000);
         }
         else
         {
            this.dispatch(EventConst.MASTERISINSPECIALAREA,params.id);
         }
      }
      
      private function onClickNPCNew(evt:MessageEvent) : void
      {
         this.onClickNpc(evt.body);
      }
      
      private function onRemoveGameSprite(evt:MessageEvent) : void
      {
         var str:String = null;
         if(evt.body is String)
         {
            str = evt.body as String;
         }
         else if(this.view.findGameSprite(IdName.npc(evt.body as int)) != null)
         {
            str = IdName.npc(evt.body as int);
         }
         else if(this.view.findGameSprite(IdName.sceneAI(evt.body as int)) != null)
         {
            str = IdName.sceneAI(evt.body as int);
         }
         this.view.delGameSpirit(str);
      }
      
      private function enableRobot(evt:MessageEvent) : void
      {
         var robot:GamePerson;
         this.view.scene.bg.getChildAt(0)["getChildAt"](0)["gotoAndPlay"](3);
         robot = this.view.findGameSprite(-1) as GamePerson;
         if(robot != null)
         {
            try
            {
               robot.ui.visible = false;
               robot.dispos();
            }
            catch(e:*)
            {
               trace("enableRobot::" + e);
            }
         }
         robot = null;
         try
         {
            this.view.masterPerson.ui.visible = false;
         }
         catch(e:*)
         {
            trace("enableRobot::" + e);
         }
         dispatch(EventConst.FACEUIOPERATE,{"code":3});
         ScreenSprite.instance.show(true);
      }
      
      private function updatePlayerName(evt:MessageEvent) : void
      {
         this.view.masterPerson.setPeronName(GameData.instance.playerData.userName);
      }
      
      private function onRemoveMasterAboveAI(evt:MessageEvent) : void
      {
         this.view.delGameSpirit(this.view.masterPerson.sequenceID);
      }
      
      private function onPlayEffectByTask(evt:MessageEvent) : void
      {
         var count:int;
         var effectCallback:Function = null;
         var id:int = 0;
         var targetName:String = null;
         var gs:GameSprite = null;
         if(GameData.instance.playerData.copyScene <= 0)
         {
            FaceView.clip.showBottom();
         }
         count = 0;
         if(evt.body.hasOwnProperty("callback"))
         {
            effectCallback = evt.body.callback as Function;
         }
         for each(id in evt.body.id)
         {
            targetName = "";
            switch(evt.body.type)
            {
               case 3:
                  targetName = IdName.npc(id);
                  break;
               case 4:
                  targetName = IdName.build(id);
                  break;
               case 7:
                  targetName = IdName.npc(id);
                  break;
               case 8:
                  targetName = IdName.sceneAI(id);
                  break;
               case 9:
                  targetName = IdName.specialArea(id);
            }
            if(!(targetName.length == 0 || targetName == ""))
            {
               try
               {
                  gs = this.view.findGameSprite(targetName);
                  if(gs == null)
                  {
                     continue;
                  }
                  count++;
                  if(gs is SceneAIBase)
                  {
                     if(effectCallback != null && count == 1)
                     {
                        SceneAIBase(gs).playEffect(effectCallback);
                     }
                     else
                     {
                        SceneAIBase(gs).playEffect();
                     }
                  }
                  else if(gs is MultipleNPC)
                  {
                     if(Boolean(evt.body.hasOwnProperty("efname")) && evt.body.efname != "")
                     {
                        switch(evt.body.efname)
                        {
                           case "replay":
                              MultipleNPC(gs).gotoAndPlay(1);
                              if(effectCallback != null && count == 1)
                              {
                                 effectCallback.apply(null,[]);
                              }
                        }
                     }
                     else if(effectCallback != null && count == 1)
                     {
                        MultipleNPC(gs).playEffect(effectCallback);
                     }
                     else
                     {
                        MultipleNPC(gs).playEffect(null);
                     }
                  }
               }
               catch(e:*)
               {
                  effectCallback.apply(null,[]);
                  continue;
               }
            }
         }
         if(count == 0 && evt.body.id.length > 0)
         {
            effectCallback.apply(null,[]);
         }
         effectCallback = null;
      }
      
      private function onNeedListenMouseCursorai(evt:MessageEvent) : void
      {
         this.targetMouseCursorAIId = evt.body as int;
      }
      
      private function onClickMouseCursorAi(evt:MessageEvent) : void
      {
         if(MouseManager.getInstance().mouseEvent.target.name == IdName.specialArea(this.targetMouseCursorAIId))
         {
            (this.view.findGameSprite(IdName.specialArea(this.targetMouseCursorAIId)) as MouseCursorAI).update(null);
         }
         else
         {
            this.dispatch(EventConst.MASTERISOUTSPECIALAREA,{
               "npcid":this.targetMouseCursorAIId,
               "dialogID":this.targetMouseCursorAIId
            });
         }
      }
      
      private function clickNpcWithOutCheckScene(evt:MessageEvent) : void
      {
         this.sendMessage(MsgDoc.OP_CLIENT_NPCLIST_WITHOUT_SCENE.send,evt.body.type,[evt.body.npcid,evt.body.actionID]);
      }
      
      private function zhiyinOver(evt:MessageEvent) : void
      {
         ApplicationFacade.getInstance().dispatch(EventConst.PERSON_CAN_OR_NOT_MOVE,true);
         this.view.masterPerson.setDirection(0);
         this.view.masterPerson.x = 645;
         this.view.masterPerson.y = 436;
         ScreenSprite.instance.hide();
      }
      
      private function gotoZiyuanCang(evt:MessageEvent) : void
      {
         sendMessage(MsgDoc.OP_CLIENT_PLAYER_START_MOVING.send,0,[185,300,GlobalConfig.userId]);
         this.view.masterPerson.moveto(185,300,this.onArrivalZiyuanCang);
      }
      
      private function onArrivalZiyuanCang() : void
      {
         this.changeScene(1006);
      }
      
      private function onMoveStoneToRightPlace(evt:MessageEvent) : void
      {
         if(this.stoneAccount == null)
         {
            this.stoneAccount = {};
            this.stoneAccount.num = 1;
         }
         else
         {
            ++this.stoneAccount.num;
         }
         this.view.delGameSpirit(evt.body.id);
         var param:Object = {};
         param.x = evt.body.x;
         param.y = evt.body.y;
         param.special = 1;
         param.enname = "";
         param.istask = 1;
         param.mapid = 2005;
         param.url = "assets/build/" + evt.body.id;
         param.watchURL = "null";
         param.sequenceID = evt.body.id;
         var gs2:DynamicBuild = SceneAIFactory.instance.produce(4,param);
         gs2.dymaicY = -20;
         gs2.load(14);
         this.view.addGameSprite(gs2);
         if(this.stoneAccount.num == 5)
         {
            this.sendMessage(MsgDoc.OP_CLIENT_CLICK_NPC.send,21507,[0]);
         }
      }
      
      private function sendClickNPC(spriteName:String) : void
      {
         this.sendMessage(MsgDoc.OP_CLIENT_CLICK_NPC.send,IdName.id(spriteName),[0]);
      }
      
      private function onTrigerSceneAI(evt:MessageEvent) : void
      {
         var p:Point = null;
         var clip:MovieClip = null;
         var clip2:MovieClip = null;
         var rect:Rectangle = null;
         var fmid:int = 0;
         var params:Object = evt.body;
         this.tmpClickObject = params;
         if(Boolean(params.hasOwnProperty("moveX")) && Boolean(params.hasOwnProperty("moveY")))
         {
            if(Boolean(params.hasOwnProperty("send")) && Boolean(params.send))
            {
               this.sendMessage(MsgDoc.OP_CLIENT_PLAYER_START_MOVING.send,0,[params.moveX,params.moveY,GlobalConfig.userId]);
            }
            if(Boolean(params.hasOwnProperty("npcId")) && params.npcId != 0)
            {
               p = this.view.masterPerson.ui.parent.localToGlobal(new Point(params.moveX,params.moveY));
               this.view.masterPerson.moveto(p.x,p.y,this.onArriveClickDest);
               return;
            }
         }
         trace("params.id = " + params.id + "    params.type = " + params.type);
         if(params.id == 1003)
         {
            if(params.type == 1)
            {
               if(GameData.instance.playerData.isNewHand < 8)
               {
                  return;
               }
               sendMessage(MsgDoc.OP_CLIENT_PLAYER_START_MOVING.send,0,[495,330,GlobalConfig.userId]);
               GameSpriteAction.instance.forceMoveTo(this.view.masterPerson,495,330,0);
            }
            else if(params.type == 2)
            {
               this.backdoorMapId = 1004;
               GameSpriteAction.instance.moveDown(this.view.masterPerson,this.gotoBackDoor,120,0.8,1.002,null,new Rectangle(330,100,250,250));
            }
         }
         else if(params.id == 1005)
         {
            if(params.type == 1)
            {
               sendMessage(MsgDoc.OP_CLIENT_PLAYER_START_MOVING.send,0,[488,336,GlobalConfig.userId]);
               GameSpriteAction.instance.forceMoveTo(this.view.masterPerson,488,336,0);
            }
            else if(params.type == 2)
            {
               this.backdoorMapId = 1006;
               GameSpriteAction.instance.moveDown(this.view.masterPerson,this.gotoBackDoor,120,0.9,1.009,null,new Rectangle(310,90,300,250));
            }
         }
         else if(params.id == 1004)
         {
            if(params.type == 1)
            {
               sendMessage(MsgDoc.OP_CLIENT_PLAYER_START_MOVING.send,0,[480,270,GlobalConfig.userId]);
               GameSpriteAction.instance.forceMoveTo(this.view.masterPerson,480,270,0);
            }
            else if(params.type == 2)
            {
               this.backdoorMapId = 1003;
               GameSpriteAction.instance.moveUp(this.view.masterPerson,this.gotoBackDoor,180,1.1,1.037);
            }
         }
         else if(params.id == 1008)
         {
            if(params.type == 1)
            {
               sendMessage(MsgDoc.OP_CLIENT_PLAYER_START_MOVING.send,0,[468,215,GlobalConfig.userId]);
               GameSpriteAction.instance.forceMoveTo(this.view.masterPerson,468,215,0);
            }
            else if(params.type == 2)
            {
               this.backdoorMapId = 1009;
               GameSpriteAction.instance.moveDown(this.view.masterPerson,this.gotoBackDoor,120,1,1.009,null,new Rectangle(300,0,250,223));
            }
         }
         else if(params.id == 1009)
         {
            if(params.type == 1)
            {
               sendMessage(MsgDoc.OP_CLIENT_PLAYER_START_MOVING.send,0,[490,285,GlobalConfig.userId]);
               GameSpriteAction.instance.forceMoveTo(this.view.masterPerson,490,285,0);
            }
            else if(params.type == 2)
            {
               this.backdoorMapId = 1008;
               GameSpriteAction.instance.moveUp(this.view.masterPerson,this.gotoBackDoor,280,1.35,1.037);
            }
         }
         else if(params.id == 1006)
         {
            if(params.type == 1)
            {
               trace("新手阶段是" + GameData.instance.playerData.isNewHand);
               if(GameData.instance.playerData.isNewHand < 7)
               {
                  return;
               }
               sendMessage(MsgDoc.OP_CLIENT_PLAYER_START_MOVING.send,0,[490,420,GlobalConfig.userId]);
               GameSpriteAction.instance.forceMoveTo(this.view.masterPerson,490,420,0);
            }
            else if(params.type == 2)
            {
               this.backdoorMapId = 1005;
               GameSpriteAction.instance.moveUp(this.view.masterPerson,this.gotoBackDoor,360,1.9,1.032);
            }
         }
         else if(params.id == 4003)
         {
            if(params.type == 3)
            {
               this.view.masterPerson.moveto(375,475);
            }
         }
         else if(params.id == 41311)
         {
            clip = this.view.scene.bg["getChildAt"](0)["getChildByName"]("taxianclip") as MovieClip;
            GameAction.instance.playExistMovieClip(clip,this.removeClip);
            this.view.masterPerson.moveto(120,188);
         }
         else if(params.id == 7003)
         {
            if(GameData.instance.playerData.isAutoBattle)
            {
               return;
            }
            clip2 = this.view.scene.bg["getChildAt"](0)["getChildAt"](1) as MovieClip;
            GameAction.instance.shirenhuaPlay(clip2,this.eatMasterPerson,this.waitEatOut);
         }
         else if(params.id == 41313)
         {
            ScreenSprite.instance.show(true);
            this.backdoorMapId = 5003;
            GameSpriteAction.instance.moveDown(this.view.masterPerson,this.gotoBackDoor,300,1,1.01,"boat",null,-85,-80);
            (this.view.scene.bg["getChildAt"](0)["getChildAt"](1) as MovieClip).visible = false;
         }
         else if(params.id == 2004)
         {
            rect = new Rectangle(530,307,64,54);
            if(rect.contains(this.view.masterPerson.x,this.view.masterPerson.y))
            {
               this.backdoorMapId = 2005;
               GameSpriteAction.instance.moveUp(this.view.masterPerson,this.gotoBackDoor,500,5,1.5);
            }
         }
         else if(params.id == 2005)
         {
            this.rect2 = new Rectangle(32,400,92,47);
            this.view.addEventListener(Event.ENTER_FRAME,this.cheakFall);
         }
         else if(params.id == 10002)
         {
            if(params.type == 2)
            {
               sendMessage(MsgDoc.OP_CLIENT_PLAYER_START_MOVING.send,0,[615,295,GlobalConfig.userId]);
               GameSpriteAction.instance.forceMoveTo(this.view.masterPerson,615,295,0);
            }
            else if(params.type == 0)
            {
               this.backdoorMapId = 10003;
               GameSpriteAction.instance.moveUp(this.view.masterPerson,this.gotoBackDoor,1700,8,1.7);
            }
         }
         else if(params.id == 10003)
         {
            if(params.type == 2)
            {
               sendMessage(MsgDoc.OP_CLIENT_PLAYER_START_MOVING.send,0,[590,350,GlobalConfig.userId]);
               GameSpriteAction.instance.forceMoveTo(this.view.masterPerson,590,350,0);
            }
            else if(params.type == 0)
            {
               this.backdoorMapId = 10002;
               GameSpriteAction.instance.moveUp(this.view.masterPerson,this.gotoBackDoor,1700,8,1.7);
            }
         }
         else if(params.id == 3003)
         {
            if(params.type == 11)
            {
               sendMessage(MsgDoc.OP_CLIENT_PLAYER_START_MOVING.send,0,[415,293,GlobalConfig.userId]);
               GameSpriteAction.instance.forceMoveTo(this.view.masterPerson,415,293,1111);
            }
            else if(params.type == 12)
            {
               GameSpriteAction.instance.forceDrifting(this.view.masterPerson,this.getOffBoat,65,0.9,415,293,710,370);
            }
            else if(params.type == 21)
            {
               sendMessage(MsgDoc.OP_CLIENT_PLAYER_START_MOVING.send,0,[488,422,GlobalConfig.userId]);
               GameSpriteAction.instance.forceMoveTo(this.view.masterPerson,488,422,2222);
            }
            else if(params.type == 22)
            {
               GameSpriteAction.instance.forceDrifting(this.view.masterPerson,this.getOffBoat,60,1,470,415,275,310);
            }
         }
         else if(params.id == 10004)
         {
            if(params.type == 1)
            {
               fmid = GameData.instance.playerData.mid;
               if(fmid == 19 || fmid == 20 || fmid == 21)
               {
                  ++this.currentSceneCount;
                  if(this.currentSceneCount == 5)
                  {
                     this.onClickNpc({"id":101402});
                  }
                  else if(this.currentSceneCount > 5)
                  {
                     this.currentSceneCount = 0;
                  }
               }
               else
               {
                  this.currentSceneCount = 0;
               }
            }
         }
         else if(params.id == 21903)
         {
            this.view.masterPerson.moveto(330,462,this.jumpOnPlan);
            sendMessage(MsgDoc.OP_CLIENT_PLAYER_START_MOVING.send,0,[330,462,GlobalConfig.userId]);
         }
         else if(params.id == 2103)
         {
            if(params.type === 1)
            {
               this.view.masterPerson.moveto(373,262,this.clickXiaoshuihe);
            }
         }
         else if(params.id == 2101)
         {
            if(params.type == 1)
            {
               this.view.masterPerson.moveto(220,365,this.clickRobSalt);
            }
         }
         else if(params.id == 30006)
         {
            if(params.type == 1)
            {
               this.view.masterPerson.moveto(400,310,this.clickShijie);
            }
         }
         else if(params.id == 30007)
         {
            if(params.type == 1)
            {
               GameSpriteAction.instance.forceDrifting(this.view.masterPerson,this.gotoAndClickBSDTXuanwo,60,1,this.view.masterPerson.x,this.view.masterPerson.y,515,465);
            }
            else
            {
               if(params.type == 4)
               {
                  return;
               }
               if(params.type == 2 || params.type == 3)
               {
                  this.dispatch(EventConst.OPENPOPUPINDIALOG,{"opdata":{
                     "opName":"extension22ai",
                     "item":params.type - 1
                  }});
               }
               else if(params.type == 5)
               {
                  this.dispatch(EventConst.OPENPOPUPINDIALOG,{
                     "opdata":{
                        "opName":"extension22ai",
                        "item":3
                     },
                     "callback":this.gotoAndClickBSDT
                  });
               }
            }
         }
         else if(params.id == 700301)
         {
            if(params.type == 1)
            {
               this.onClickNpc({"id":71304});
            }
         }
         else if(params.id == 1017)
         {
            if(params.type == 1)
            {
               this.dispatch(EventConst.SENDUSERTOOTHERSCENE,1017);
            }
         }
         else if(params.id == 3004)
         {
            if(params.type == 1)
            {
               this.view.masterPerson.moveto(536,360,this.onArriveBaiGuDong);
            }
         }
         else if(params.id == 80001)
         {
            if(params.type == 1)
            {
               this.dispatch(EventConst.STARTTOPLAYANIMATION,{
                  "npcid":0,
                  "x":-1,
                  "y":-1,
                  "url":"assets/animation/60050100401.swf",
                  "effectName":"",
                  "targetFunction":null,
                  "type":0
               });
            }
         }
      }
      
      private function cheakFall(evt:Event) : void
      {
         if(this.rect2.contains(this.view.masterPerson.x,this.view.masterPerson.y))
         {
            this.backdoorMapId = 2004;
            GameSpriteAction.instance.moveDown(this.view.masterPerson,this.gotoBackDoor,500,2,1.5,"leaf",null,-60,-25);
            (this.view.scene.bg["getChildAt"](0)["getChildAt"](0) as MovieClip)["leafMc"].visible = false;
            this.view.removeEventListener(Event.ENTER_FRAME,this.cheakFall);
         }
      }
      
      private function eatMasterPerson() : void
      {
         trace(" view.masterPerson.ui.visible=true;");
         GameDynamicUI.addUI(this.view,523,195,"shirenhua");
         this.view.masterPerson.ui.visible = false;
      }
      
      private function waitEatOut() : void
      {
         (this.view.scene.bg["getChildAt"](0)["getChildAt"](1) as MovieClip).stop();
         ScreenSprite.instance.show(true,true,3);
      }
      
      private function eatOutMasterPerson(evt:MessageEvent) : void
      {
         ScreenSprite.instance.show(true);
         (this.view.scene.bg["getChildAt"](0)["getChildAt"](1) as MovieClip).gotoAndPlay(59);
         (this.view.scene.bg["getChildAt"](0)["getChildAt"](1) as MovieClip).addFrameScript(113,this.showMasterPerson);
      }
      
      private function showMasterPerson() : void
      {
         GameDynamicUI.removeUI("shirenhua");
         this.view.masterPerson.ui.visible = true;
         this.view.masterPerson.x -= 100;
         ScreenSprite.instance.show(false);
         (this.view.scene.bg["getChildAt"](0)["getChildAt"](1) as MovieClip).stop();
         SpecialAreaManager.instance.eatBool = false;
      }
      
      private function gotoBackDoor() : void
      {
         if(this.backdoorMapId == 1015)
         {
            this.changeScene(1050 + GameData.instance.playerData.family_map_star);
         }
         else if(this.backdoorMapId == 1014)
         {
            this.changeScene(1040 + GameData.instance.playerData.family_map_star);
         }
         else
         {
            dispatch(EventConst.ENTERSCENE,this.backdoorMapId);
         }
      }
      
      private function getOffBoat() : void
      {
         ScreenSprite.instance.show(false);
      }
      
      private function removeClip() : void
      {
         GameSpriteAction.instance.fellDown(this.view.masterPerson,null,30,20,70);
         this.view.scene.bg["getChildAt"](0)["getChildByName"]("taxianclip")["stop"]();
         this.changeScene(5001);
      }
      
      private function onDressChangeBack(evt:MessageEvent) : void
      {
         var body:Object = evt.body;
         var role:GamePerson = this.view.findGameSprite(body.userId) as GamePerson;
         if(role != null)
         {
            role.updateDress(body);
         }
      }
      
      private function addGameDynamicUI(evt:MessageEvent) : void
      {
         var param:Object = evt.body;
         if(!param.hasOwnProperty("scale"))
         {
            param.scale = 1;
         }
         if(!param.hasOwnProperty("container"))
         {
            param.container = this.view.stage;
         }
         else if(param.container is int)
         {
            if(Boolean(this.view.findGameSprite(IdName.npc(param.container))))
            {
               param.container = this.view.findGameSprite(IdName.npc(param.container)).ui as Sprite;
            }
            else
            {
               param.container = this.view;
            }
         }
         if(param.type == 1)
         {
            GameDynamicUI.addUI(param.container,param.x,param.y,param.uiname,param.scale);
         }
         else if(param.type == 2)
         {
            GameDynamicUI.addFrameScritUI(param.container,param.x,param.y,param.uiname,param.lastFrame,param.scale);
         }
         else if(param.type == 3)
         {
            GameDynamicUI.addMouseFrameScritUI(param.container,param.x,param.y,param.uiname,"",null,null,param.scale,param.index,param.lastFrame);
         }
      }
      
      private function nonsenseNPCSaySomething(evt:MessageEvent) : void
      {
         var npcsay:Object = null;
         var spNpc:GameSprite = null;
         var obj:* = evt.body;
         if(obj is Array)
         {
            if((obj as Array).length == 0)
            {
               this.dispatch(EventConst.NONSENSE_NPC_SAY_OVER);
               return;
            }
            npcsay = (obj as Array).shift();
            spNpc = this.view.findGameSprite(IdName.npc(npcsay.id));
            if(spNpc == null)
            {
               return;
            }
            (spNpc as MultipleNPC).needMeSaySomething(npcsay.msg,obj);
         }
      }
      
      private function onEnterSceneFailed(evt:MessageEvent) : void
      {
         if(this.tempcount == 0 && this.enterSceneFaildList.indexOf(this.tempareaid) != -1)
         {
            this.changeScene(1004);
            ++this.tempcount;
         }
         else
         {
            this.changeScene(this.tempareaid);
         }
         GameData.instance.playerData.currentScenenId = this.tempareaid;
         this.view.onEnterSceneFailed();
      }
      
      private function battleOver(evt:MessageEvent) : void
      {
         MonsterPolling.instance.disposAiMonster();
         if(GameData.instance.playerData.copyScene > 0 && !Boolean(evt.body.win & 0x80000000))
         {
            return;
         }
         MonsterManger.instance.deleteAIMonster(evt.body.win & 0x80000000);
         if(GameData.instance.playerData.copyScene == 0)
         {
            MonsterManger.instance.initAIMonster(1);
         }
      }
      
      private function jumpOnPlan() : void
      {
         this.view.masterPerson.setDirection(2);
         GameSpriteAction.instance.forceDrifting(this.view.masterPerson,this.startToMoveOut,15,1,330,462,415,416);
      }
      
      private function startToMoveOut() : void
      {
         new Message("startplane").sendToChannel("sceneAI");
         var tnpc:GameSprite = this.view.findGameSprite(IdName.npc(21901));
         if(tnpc == null)
         {
            return;
         }
         (tnpc as MultipleNPC).playEffect(null);
         this.onClickNpc({"id":21903});
         GameSpriteAction.instance.forceDrifting(this.view.masterPerson,this.sendToGLZ,35,1.5,this.view.masterPerson.x,this.view.masterPerson.y,867,390);
      }
      
      private function sendToGLZ() : void
      {
         this.changeScene(2103);
      }
      
      private function clickXiaoshuihe() : void
      {
         this.dispatch(EventConst.SHOW_LITTLE_GAME_START,6);
      }
      
      private function clickRobSalt() : void
      {
         this.dispatch(EventConst.SHOW_LITTLE_GAME_START,1002);
      }
      
      private function onArriveClickDest() : void
      {
         if(this.tmpClickObject != null)
         {
            if(this.tmpClickObject.hasOwnProperty("npcId"))
            {
               this.onClickNpc({"id":this.tmpClickObject.npcId});
            }
         }
         this.tmpClickObject = null;
      }
      
      private function clickShijie() : void
      {
         this.dispatch(EventConst.OPENSWFWINDOWS,{
            "url":"assets/material/shijieduilian.swf",
            "xCoord":130,
            "yCoord":0
         });
      }
      
      private function onShowTraingMonsters(evt:MessageEvent) : void
      {
         var obj:Object = null;
         MonsterManger.instance.homeAIM = [];
         var list:Array = evt.body as Array;
         for each(obj in list)
         {
            if(Boolean(obj) && Boolean(obj.hasOwnProperty("id")))
            {
               MonsterManger.instance.addAIMonsterAtHome(obj);
            }
         }
      }
      
      private function onSendXiYouPerson(evt:MessageEvent) : void
      {
         this.sendMessage(MsgDoc.OP_CLIENT_SENDXIYOUPERSON.send,int(evt.body));
      }
      
      private function gotoAndClickBSDTXuanwo() : void
      {
         this.dispatch(EventConst.STARTTOPLAYANIMATION,{
            "npcid":0,
            "x":-1,
            "y":-1,
            "effectName":"",
            "url":"assets/animation/60050100401.swf",
            "targetFunction":null,
            "type":0
         });
      }
      
      private function gotoAndClickBSDT(param:Object = null) : void
      {
         this.onClickNpc({"id":301702});
      }
      
      private function onClickEmployee() : void
      {
         this.dispatch(EventConst.OPENSWFWINDOWS,{
            "url":"assets/material/employee.swf",
            "xCoord":130,
            "yCoord":0
         });
         this.view.masterPerson.ui.visible = false;
      }
      
      private function onChangeNameBorder(evt:MessageEvent) : void
      {
         var params:Object = evt.body;
         var role:GamePerson = this.view.findGameSprite(params.userId) as GamePerson;
         if(Boolean(role))
         {
            if(params.hasOwnProperty("familyName"))
            {
               role.updateFlagName(params.familyName);
               return;
            }
            role.updateNameBorder(params.borderId);
            if(role.showData.familyName != "")
            {
               role.updateFlagName(role.showData.familyName);
            }
         }
      }
      
      private function onUseClickDailyTaskMsg(evt:MessageEvent) : void
      {
         this.sendMessage(MsgDoc.OP_CLIENT_CLICK_DAILY_TASK.send,evt.body as int);
      }
      
      private function onOpBallonActive(evt:MessageEvent) : void
      {
         var item:NPCVo = null;
         var index:int = 0;
         var sceneMaterial:MultipleNPC = null;
         var role:GamePerson = null;
         var param:Object = evt.body;
         trace("【我在踩气球呀...】" + param.type);
         var i:int = 0;
         var len:int = 0;
         switch(param.type)
         {
            case 1:
               if(this.independentList == null || this.independentList.length == 0 || this.independentList.indexOf(param.ballid) == -1)
               {
                  trace("【踩气球...】\t已经没有这个球了呀...威哥");
               }
               else
               {
                  this.view.delGameSpirit(IdName.npc(16001000 + param.ballid));
                  len = int(this.independentList.length);
                  for(i = 0; i < len; i++)
                  {
                     if(this.independentList[i] == param.ballid)
                     {
                        this.independentList.splice(i,1);
                        break;
                     }
                  }
                  if(this.independentList.length == 0)
                  {
                     this.independentList = null;
                  }
               }
               if(param.playerid != 0)
               {
                  role = this.view.findGameSprite(param.playerid) as GamePerson;
                  if(role != null)
                  {
                     GameAction.instance.playEffect(this.view,role.x,role.y - role.ui.height,"addonefloat");
                  }
               }
               break;
            case 2:
               if(this.independentList.length > 0)
               {
                  len = int(this.independentList.length);
                  for(i = 0; i < len; i++)
                  {
                     this.view.delGameSpirit(IdName.npc(16001000 + this.independentList[i]));
                  }
                  this.independentList.length = 0;
               }
               this.independentList = null;
               break;
            case 3:
               if(this.independentList == null)
               {
                  this.independentList = [];
               }
               len = int(param.balllist.length);
               index = 0;
               for(i = 0; i < len; i++)
               {
                  this.independentList.push(param.balllist[i].ballid);
                  item = new NPCVo();
                  item.x = param.balllist[i].posx;
                  item.y = param.balllist[i].posy;
                  item.mapid = param.sceneId;
                  index = Math.random() * 4 + 1 >> 0;
                  item.url = "assets/npc/activeballon" + index;
                  item.name = "气球";
                  item.enname = "";
                  item.special = 1;
                  item.istask = 3;
                  item.type = -1;
                  item.watchURL = "";
                  item.dymaicY = 0;
                  item.sequenceID = 16001000 + param.balllist[i].ballid;
                  sceneMaterial = new MultipleNPC(item);
                  this.view.addGameSprite(sceneMaterial);
                  (sceneMaterial as MultipleNPC).load();
               }
         }
      }
      
      private function showAwardByMaterial(evt:MessageEvent) : void
      {
         var subxml:XML = null;
         var item:Object = null;
         var tlist:Array = evt.body as Array;
         var url:String = "";
         var namestr:String = "";
         var num:int = 0;
         for each(item in tlist)
         {
            if(item.type == 1)
            {
               subxml = XMLLocator.getInstance().tooldic[item.id];
               if(subxml != null)
               {
                  namestr = subxml.name.toString();
                  url = "assets/tool/" + item.id + ".swf";
                  num = int(item.num);
                  new AwardAlert().showGoodsAward(url,this.view.stage,"获得 " + HtmlUtil.getHtmlText(12,"#FF0000",namestr),true);
               }
            }
            else if(item.type == 2)
            {
               subxml = XMLLocator.getInstance().getSprited(item.id);
               if(subxml != null)
               {
                  namestr = subxml.name.toString();
                  url = "assets/monsterimg/" + item.id + ".swf";
                  num = int(item.num);
                  new AwardAlert().showMonsterAward(url,this.view.stage,"获得 " + HtmlUtil.getHtmlText(12,"#FF0000",namestr),true);
               }
            }
            else if(item.type == 3)
            {
               new AwardAlert().showMoneyAward(item.num,this.view.stage);
            }
            else if(item.type == 4)
            {
               new AwardAlert().showExpAward(item.num,this.view.stage);
            }
            else if(item.type == 5)
            {
               new Alert().show(item.msg);
            }
            else if(item.type == 6)
            {
               new Alert().showOne(item.msg);
            }
         }
      }
      
      private function onClickHuaLan() : void
      {
         this.dispatch(EventConst.OPENSWFWINDOWS,{
            "url":"assets/material/swfviewchahua.swf",
            "xCoord":0,
            "yCoord":0
         });
      }
      
      private function hideMasterPerson(evt:MessageEvent) : void
      {
         var obj:Object = evt.body;
         if(Boolean(obj.hasOwnProperty("type")) && obj.type == 1)
         {
            this.view.masterPerson.ui.visible = false;
            this.view.masterPerson.retakeMM();
            if(Boolean(this.view.masterPerson.trump) && Boolean(this.view.masterPerson.trump.ui))
            {
               this.view.masterPerson.trump.ui.visible = false;
            }
         }
         else if(Boolean(obj.hasOwnProperty("type")) && obj.type == 2)
         {
            this.view.masterPerson.ui.visible = true;
            this.view.masterPerson.updataMM();
            if(Boolean(this.view.masterPerson.trump) && Boolean(this.view.masterPerson.trump.ui))
            {
               this.view.masterPerson.trump.ui.visible = true;
            }
         }
      }
      
      private function onUseTaishanglingBack(evt:MessageEvent) : void
      {
         var tFlag:int = evt.body as int;
         if(tFlag == -1)
         {
            new Alert().show("太上令只能在紫竹林使用哦！～");
         }
         else if(tFlag == 0)
         {
            new Alert().showOne("你今天已经使用过5次太上令了，今天不能再使用了哦 ~0_0~。");
         }
         else if(tFlag == 1)
         {
            this.dispatch(EventConst.HIDE_GAMEPERSON,{"type":1});
            this.dispatch(EventConst.OPENSWFWINDOWS,{
               "url":"assets/material/swfviewflyout.swf",
               "xCoord":0,
               "yCoord":0,
               "callback":this.onPlayFlyOutBack
            });
         }
      }
      
      private function onPlayFlyOutBack(param:*) : void
      {
         dispatch(EventConst.SENDUSERTOOTHERSCENE,50001);
      }
      
      private function isNeedSpecialOperate() : Boolean
      {
         if(this.haveSpecialOperateList.indexOf(GameData.instance.playerData.sceneId) == -1)
         {
            return false;
         }
         return true;
      }
      
      private function showSpecialOperate(code:int) : void
      {
         this.haveSpecialOperateTargetID = code;
         if(this.isInCrazyRecordRoom())
         {
            new Alert().showSureOrCancel("确定要离开疯狂档案室吗？",this.onSpecialOperate);
         }
         else
         {
            this.changeScene(code);
         }
      }
      
      private function onSpecialOperate(... rest) : void
      {
         if(this.isInCrazyRecordRoom())
         {
            if(rest[0] == "确定" && this.haveSpecialOperateTargetID != 0)
            {
               this.changeScene(this.haveSpecialOperateTargetID);
            }
            this.haveSpecialOperateTargetID = 0;
         }
      }
      
      private function makeCrazyRecordRoomList(evt:MessageEvent) : void
      {
         var tempStatus:Boolean = Boolean(evt.body);
         if(tempStatus)
         {
            this.crazyRecordRoom = [1019,1020,1021];
         }
         else
         {
            GameData.instance.playerData.isInCrazyRecordRoom = false;
            this.crazyRecordRoom.length = 0;
            this.crazyRecordRoom = [];
         }
      }
      
      private function isInCrazyRecordRoom() : Boolean
      {
         if(this.crazyRecordRoom.indexOf(GameData.instance.playerData.sceneId) != -1)
         {
            return true;
         }
         return false;
      }
      
      private function deleteGameSpriteOnAddSomeon(removelist:Array) : void
      {
         var tmpid:int = 0;
         for each(tmpid in removelist)
         {
            if(Boolean(this.view.findGameSprite(tmpid)))
            {
               this.view.delGameSpirit(tmpid);
            }
         }
      }
      
      private function makeRemoveList(str:String) : Array
      {
         var rtmparr:Array = str.split(",");
         var i:int = 0;
         var len:int = int(rtmparr.length);
         for(i = 0; i < len; i++)
         {
            rtmparr[i] = int(rtmparr[i]);
         }
         return rtmparr;
      }
      
      private function onPlayerChangeNameBack(event:MessageEvent) : void
      {
         var roledata:ShowData = null;
         var len:int = int(GameData.instance.playerLists.length);
         for(var r:int = 0; r < len; r++)
         {
            roledata = GameData.instance.playerLists[r];
            if(roledata.userId == event.body.uid)
            {
               GameData.instance.playerLists[r].userName = event.body.uname + "";
            }
         }
         var role:GamePerson = this.view.findGameSprite(event.body.uid) as GamePerson;
         if(Boolean(role))
         {
            role.showData.userName = event.body.uname;
            role.setPeronName(event.body.uname + "");
         }
      }
      
      private function onPlayerBadgeMovie(event:MessageEvent) : void
      {
         if((ApplicationFacade.getInstance().retrieveViewLogic(BattleControl.NAME) as BattleControl).battleView == null)
         {
            new SwfAction().loadAndPlay(this.view,"assets/badge/swf/" + int(event.body) + ".swf",0,0);
         }
      }
      
      private function onAllPersonInScene(event:MessageEvent) : void
      {
         if(GameData.instance.playerData.currentScenenId == 6004)
         {
            sendMessage(1186355,0,[0]);
         }
         if(GameData.instance.playerData.currentScenenId == 11002)
         {
            sendMessage(1185795,0,[0]);
         }
      }
      
      private function onPlayerActionBack(evt:MessageEvent) : void
      {
         if(GameData.instance.playerData.currentScenenId == 15000)
         {
            return;
         }
         var actionId:int = int(evt.body.actionId);
         var uid:int = int(evt.body.uid);
         var role:GamePerson = this.view.findGameSprite(uid) as GamePerson;
         if(role != null)
         {
            role.playPersonAction(actionId);
         }
      }
      
      private function onArriveBaiGuDong() : void
      {
         this.dispatch(EventConst.ONGETDIALOGBACK,{
            "type":2,
            "dialogId":36,
            "subtaskID":0,
            "taskID":0
         });
      }
      
      private function onGetSignalOfAddAIBack(evt:MessageEvent) : void
      {
         evt.stopImmediatePropagation();
         var obj:ActivityEventBody = evt.body as ActivityEventBody;
         this.toLoadNPC({"npcList":obj.getValues()});
         obj.destroy();
      }
      
      private function onActivityMessageHandler(evt:MessageEvent) : void
      {
         var mastPersion:GamePerson = null;
         var flag:Boolean = false;
         var obj:Object = evt.body;
         if(obj.head == 8 && obj.type == 6)
         {
            mastPersion = this.view.findGameSprite(obj.playerId) as GamePerson;
            if(Boolean(mastPersion) && Boolean(mastPersion.statusClip))
            {
               flag = obj.playerFlag == 2 ? true : false;
               mastPersion.statusClip.updateBattle(flag);
            }
         }
      }
      
      private function onRegEnterRoom(e:MessageEvent) : void
      {
         if(GameData.instance.playerData.isInFishState)
         {
            return;
         }
         var data:Object = e.body;
         GameData.instance.friendData.userId = data.userId;
         GameData.instance.playerData.houseName = data.userName;
         GameData.instance.playerData.houseId = data.houseId;
         sendMessage(MsgDoc.OP_CLIENT_REQ_ENTER_ROOM.send,data.userId);
      }
      
      private function onUpdateShowHandler(e:MessageEvent) : void
      {
         var params:Object = e.body;
         var gamePersion:GamePerson = MapView.instance.findGameSprite(params.uid) as GamePerson;
         if(gamePersion != null)
         {
            switch(params.index)
            {
               case 1:
               case 3:
                  gamePersion.showData.titleIndex = params.id;
                  gamePersion.updateShowTilte();
                  break;
               case 2:
                  gamePersion.showData.setShowFamily(params.id);
                  gamePersion.updateFamilyLabel();
            }
         }
      }
      
      private function onNewHandBraveGuide(evt:MessageEvent) : void
      {
         var params:Object = evt.body;
         this.newHandBraveData.type = params.type;
         this.newHandBraveData.x = params.x;
         this.newHandBraveData.y = params.y;
         this.newHandBraveData.uiname = params.uiname;
         this.newHandBraveData.container = params.container;
         this.newHandBraveData.npcid = params.npcid;
         this.newHandBraveData.npcType = params.npcType;
      }
   }
}

