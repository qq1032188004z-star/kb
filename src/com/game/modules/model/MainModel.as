package com.game.modules.model
{
   import com.channel.Message;
   import com.core.model.Model;
   import com.core.observer.MessageEvent;
   import com.game.comm.AlertUtil;
   import com.game.comm.item.NoticeItem;
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.global.GlobalConfig;
   import com.game.global.ItemType;
   import com.game.locators.CacheData;
   import com.game.locators.EventDefine;
   import com.game.locators.GameData;
   import com.game.locators.MsgDoc;
   import com.game.manager.AlertManager;
   import com.game.manager.FishManager;
   import com.game.manager.NoticeManager;
   import com.game.modules.action.SwfAction;
   import com.game.modules.control.battle.NewBattleControl;
   import com.game.modules.control.monster.SpiritGenius;
   import com.game.modules.parse.BobAwardParse;
   import com.game.modules.parse.RoleInfoParse;
   import com.game.modules.parse.ShowDataParse;
   import com.game.modules.parse.SingleSpiritParse;
   import com.game.modules.parse.SortParse;
   import com.game.modules.parse.SpiritParse;
   import com.game.modules.parse.StorageParse;
   import com.game.modules.parse.ToolParse;
   import com.game.modules.view.FaceView;
   import com.game.modules.view.MapView;
   import com.game.modules.view.OnlineAwardView;
   import com.game.modules.view.TimeRestView;
   import com.game.modules.view.WeedkendAward;
   import com.game.modules.view.WindowLayer;
   import com.game.modules.view.achieve.GetAchieve;
   import com.game.modules.view.kb_class.KB_Class_Train;
   import com.game.modules.view.kb_class.PassAlert;
   import com.game.modules.view.monster.SymmEnum;
   import com.game.modules.view.person.GamePerson;
   import com.game.modules.view.person.MonsterInfoPanel;
   import com.game.modules.view.replace.ReplaceMonsterView;
   import com.game.modules.view.skillsort.SortView;
   import com.game.modules.view.stgcopy.StgCopyValue;
   import com.game.modules.view.task.TaskDialog;
   import com.game.modules.view.task.activation.AwardBox;
   import com.game.modules.view.trump.TrumpTrainMonster;
   import com.game.modules.view.trump.TrumpTrainResult;
   import com.game.modules.view.trump.TrumpTrainningView;
   import com.game.modules.vo.BossRemarkData;
   import com.game.modules.vo.EffectListVo;
   import com.game.modules.vo.NewsVo;
   import com.game.modules.vo.ShowData;
   import com.game.modules.vo.monster.MonsterSkillVo;
   import com.game.modules.vo.monster.MonsterVo;
   import com.game.util.AwardAlert;
   import com.game.util.CacheUtil;
   import com.game.util.ChatUtil;
   import com.game.util.DelayShowUtil;
   import com.game.util.FloatAlert;
   import com.game.util.GameDynamicUI;
   import com.game.util.HtmlUtil;
   import com.game.util.MD5;
   import com.game.util.PhpInterFace;
   import com.game.util.PropertyPool;
   import com.game.util.ReConnectStatus;
   import com.game.util.TimeTransform;
   import com.game.util.ToolTipStringUtil;
   import com.kb.util.CommonDefine;
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.alert.Alert;
   import com.publiccomponent.loading.GreenLoading;
   import com.publiccomponent.loading.XMLLocator;
   import flash.display.Sprite;
   import flash.external.ExternalInterface;
   import flash.filters.ColorMatrixFilter;
   import flash.net.URLRequest;
   import flash.net.URLVariables;
   import flash.net.navigateToURL;
   import flash.utils.ByteArray;
   import flash.utils.getQualifiedClassName;
   import flash.utils.setTimeout;
   import org.engine.core.GameSprite;
   import org.green.server.data.MsgPacket;
   import org.green.server.events.MsgEvent;
   import org.plat.monitor.PlatMonitorLog;
   import phpcon.PhpConnection;
   
   public class MainModel extends Model
   {
      
      public static const NAME:String = "mainModel";
      
      private var sdp:ShowDataParse = new ShowDataParse();
      
      private var mallStep:int = 0;
      
      public function MainModel(modelName:String = null)
      {
         super(NAME);
      }
      
      override public function onRegister() : void
      {
         registerListener(MsgDoc.MINORS_OFF.back.toString(),this.onMinorsOffBack);
         registerListener(MsgDoc.OP_ONLINE_ANNOUNCEMENT.back.toString(),this.onOnlineAnnouncementBack);
         registerListener(MsgDoc.OP_ONLINE_ANNOUNCEMENT_SETTING.back.toString(),this.onOASettingBack);
         registerListener(MsgDoc.OP_CLIENT_ANNOUNCEMENT.back.toString(),this.onAnnouncementBack);
         registerListener(MsgDoc.OP_CLIENT_REQ_ENTER_SCENE.back.toString(),this.onEnterSceneBack);
         registerListener(MsgDoc.OP_CLIENT_REQ_ENTER_ROOM.back.toString(),this.onEnterRoomBack);
         registerListener(MsgDoc.OP_CLIENT_LINGQUPRIZE.back.toString(),this.onLingquPrizeBack);
         registerListener(MsgDoc.OP_BATTLE_AWARD.back.toString(),this.onBattleAwordBack);
         registerListener(MsgDoc.OP_QUERY_COPYP_ROGRESS.back.toString(),this.onCopyProgressBack);
         registerListener(MsgDoc.OP_CLIENT_PLAYER_START_MOVING.back.toString(),this.onPlayerMoveBack);
         registerListener(MsgDoc.OP_GATEWAY_ADD_PLAYER_TO_SCENE.back.toString(),this.onAddPlayerToScene);
         registerListener(MsgDoc.OP_CLIENT_REQ_SCENE_PLAYER_LIST.back.toString(),this.onScenePlayerList);
         registerListener(MsgDoc.OP_CLIENT_REQ_PACKAGE_DATA.back.toString(),this.onPackageDataBack);
         registerListener(MsgDoc.OP_CLIENT_REQ_SPIRIT_LIST.back.toString(),this.onSpiritListBack);
         registerListener(MsgDoc.OP_CLIENT_REQ_SPIRITSTORE_LIST.back.toString(),this.onTripodBack);
         registerListener(MsgDoc.OP_CLIENT_SPIRIT_OPERATOR.back.toString(),this.onSpiritOperator);
         registerListener(MsgDoc.OP_CLIENT_SPIRIT_PEERLESS_OPEN_OR_CLOSE.back.toString(),this.onSpiritPeerlessOpenOrClose);
         registerListener(MsgDoc.OP_CLIENT_BUY_GOODS.back.toString(),this.onBuyGoodsBack);
         registerListener(MsgDoc.OP_CLIENT_PUTTO_SPIRITSTORE.back.toString(),this.onPutSpiritStore);
         registerListener(MsgDoc.OP_CLIENT_GETFROM_SPIRITSTORE.back.toString(),this.onGetSpiritStore);
         registerListener(MsgDoc.OP_CLIENT_RELEASE_SPIRIT.back.toString(),this.onReleaseSpirit);
         registerListener(MsgDoc.OP_CLIENT_SET_FIRST.back.toString(),this.onSetFirstSpirit);
         registerListener(MsgDoc.OP_CLIENT_NPC_LIST.back.toString(),this.onNpcListBack);
         registerListener(MsgDoc.OP_GET_COLLETC_STUFF_STATUS.back.toString(),this.onColletcStuffStatus);
         registerListener(MsgDoc.OP_CLIENT_HE_TOOL.back.toString(),this.onHeChengTool);
         registerListener(MsgDoc.OP_CLIENT_DISTRIBUTE_EXP.back.toString(),this.onDistributeExp);
         registerListener(MsgDoc.OP_CLIENT_DUI_TOOL.back.toString(),this.onDuiHuanTool);
         registerListener(MsgDoc.OP_GATE_WAY_TRUMP_BACK.back.toString(),this.onTrumpBack);
         registerListener(MsgDoc.OP_CLIENT_TRUMP_OPRATION.back.toString(),this.onTrumpOpration);
         registerListener(MsgDoc.OP_GET_TRUMP_INFO.back.toString(),this.onTrumpInfoBack);
         registerListener(MsgDoc.OP_CLIENT_GET_TRAININFO.back.toString(),this.onGetTrainInfo);
         registerListener(MsgDoc.OP_CLIENT_TRAIN_MONSTER.back.toString(),this.onTrainMonsterBack);
         registerListener(MsgDoc.OP_CLIENT_STOP_TRAIN.back.toString(),this.onStopTrainBack);
         registerListener(MsgDoc.OP_GATE_WAY_TRAIN_MONSTERS.back.toString(),this.onShowTrainingMonster);
         registerListener(MsgDoc.OP_GATEWAY_GET_TRAINED_BACK.back.toString(),this.onTrainedMonsterBack);
         registerListener(MsgDoc.OP_CLIENT_REQ_ZHUANGBEI.back.toString(),this.onZhuangBeiBack);
         registerListener(MsgDoc.OP_CLIENT_NPC_STATUS.back.toString(),this.onNPCStatusBack);
         registerListener(MsgDoc.OP_GATEWAY_REMOVE_PLAYER_FROM_SCENE.back.toString(),this.onRemovePlayFromScene);
         registerListener(MsgDoc.OP_GATEWAY_INDULGE.back.toString(),this.onIndulgeBack);
         registerListener(MsgDoc.OP_CLIENT_EXIT_WORLD.back.toString(),this.onExitWordBack);
         registerListener(MsgDoc.OP_CLIENT_SEND_ACTION.back.toString(),this.sendActionBack);
         registerListener(MsgDoc.OP_GATE_WAY_SHOWALERT.back.toString(),this.onShowAlertHandler);
         registerListener(MsgDoc.OP_GATE_WAY_BROADCAST.back.toString(),this.onBroadCastCome);
         registerListener(MsgDoc.OP_CLIENT_ADD_BLACK.back.toString(),this.onAddBlackBack);
         registerListener(MsgDoc.OP_CLIENT_DELETE_BLACK.back.toString(),this.onDeleteBlackBack);
         registerListener(MsgDoc.OP_CLIENT_SPIRIT_CURE.back.toString(),this.onCureMonsterBack);
         registerListener(MsgDoc.OP_CLIENT_LITTLE_GAME.back.toString(),this.littleGameOverBack);
         registerListener(MsgDoc.OP_CLIENT_REQ_SPIRITLIB.back.toString(),this.onSpritesLibBack);
         registerListener(MsgDoc.OP_CLIENT_REQ_SKILL_LIET.back.toString(),this.onReqSkillListBack);
         registerListener(MsgDoc.OP_CLIENT_REQ_PROPERTY_LIET.back.toString(),this.onReqInfoListBack);
         registerListener(MsgDoc.OP_CLIENT_USE_PROPS.back.toString(),this.onUsePropsBack);
         registerListener(MsgDoc.OP_CLIENT_REQ_MONSTER_INFO.back.toString(),this.onGetMonsterInfoBack);
         registerListener(MsgDoc.OP_CLIENT_CHANGE_DRESS.back.toString(),this.onChangeDressBack);
         registerListener(MsgDoc.OP_CLIENT_FABAO.back.toString(),this.onGetFabaoBack);
         registerListener(MsgDoc.OP_CLIENT_DOCTOR_SPIRIT.back.toString(),this.onDoctorSpritesBack);
         registerListener(MsgDoc.OP_CLIENT_TREAT_MANY_SPIRIT.back.toString(),this.onTreatManySpiritBack);
         registerListener(MsgDoc.OP_CLIENT_GETMAGICINDEX.back.toString(),this.onGetMagicIndxeBack);
         registerListener(MsgDoc.OP_CLIENT_CHANGLINE.back.toString(),this.onChangeLineBack);
         registerListener(MsgDoc.OP_REPLACE_MONSTER_BACK.back.toString(),this.onReplaceMonsterBack);
         registerListener(MsgDoc.OP_CLIENT_GETONLINEAWARD.back.toString(),this.onGetOlineAwardBack);
         registerListener(MsgDoc.REQ_MONSTER.back.toString(),this.reqMonsterBack);
         registerListener(MsgDoc.OP_CLIENT_MONSTER_CHECK.back.toString(),this.onMonsterCheckBack);
         registerListener(MsgDoc.CHEAKFISHINGORNOT.back.toString(),this.cheakFishOrnotBack);
         registerListener(MsgDoc.REQ_XIUWEI_DATA.back.toString(),this.reqXiuweiDataBack);
         registerListener(MsgDoc.OP_CLIENT_WAKEUP_SKILL.back.toString(),this.onWakeUpSkill);
         registerListener(MsgDoc.OP_CLIENT_HE_DETAIL_TOOL.back.toString(),this.onGetToolDetailBack);
         registerListener(MsgDoc.OP_CLIENT_HE_REFINE_TOOL.back.toString(),this.onStartRefineBack);
         registerListener(MsgDoc.OP_CLIENT_HE_REFINE_TOOL_FARM.back.toString(),this.onStartRefineFarmBack);
         registerListener(MsgDoc.OP_GATEWAY_WISH_MAKE.back.toString(),this.onMakeAWishBack);
         registerListener(MsgDoc.OP_GATEWAY_WISH_REPORT.back.toString(),this.onWishReportBack);
         registerListener(MsgDoc.OP_CLIENT_DUIHUAN_TREASUREHOUSE.back.toString(),this.onDuihuanBack);
         registerListener(MsgDoc.OP_CLIENT_MSG_LEVEL_INOF.back.toString(),this.onGetHardWorkAward);
         registerListener(MsgDoc.OP_CLIENT_CHANGE_BORDER.back.toString(),this.onChangeBorderBack);
         registerListener(MsgDoc.CHECK_JOB_ORNOT.back.toString(),this.onCheckJobBack);
         registerListener(MsgDoc.OP_CLIENT_RUBBISH.back.toString(),this.onSellBack);
         registerListener(MsgDoc.REQ_USECOSIN_TO_GAMEHALL.back.toString(),this.reqEnterGamehallBack);
         registerListener(MsgDoc.GET_KEY.back.toString(),this.deductGameCoinBack);
         registerListener(MsgDoc.OP_CLIENT_HORSE_USE.back.toString(),this.horseUseBack);
         registerListener(MsgDoc.OP_CLIENT_NPC_WITH_SERVER_CONTROL.back.toString(),this.onServContNPCBack);
         registerListener(MsgDoc.OP_CLIENT_BROADCAST_ACTIVE_START.back.toString(),this.onBroadCastActiveStart);
         registerListener(MsgDoc.OP_CLIENT_BROADCAST_ACTIVE_END.back.toString(),this.onBroadCastActiveEnd);
         registerListener(MsgDoc.OP_CLIENT_ACTIVE_AWARD_BACK.back.toString(),this.onActiveAwardBack);
         registerListener(MsgDoc.OP_CLIENT_MENOLOGY.back.toString(),this.onMenologyBack);
         registerListener(MsgDoc.req_reduce_cosin.back.toString(),this.reqReduceCosinBack);
         registerListener(MsgDoc.OP_CLIENT_SHIBAO_LILIAN.back.toString(),this.onJialilian);
         registerListener(MsgDoc.OP_CLIENT_ZUOQI_TOOL.back.toString(),this.onUseZuoQiToolBack);
         registerListener(MsgDoc.OP_CLIENT_REQ_PASS_EXP.back.toString(),this.onGetPassExpBack);
         registerListener(MsgDoc.OP_CLIENT_REQ_TRAIN_INFO.back.toString(),this.onPassTrainBack);
         registerListener(MsgDoc.OP_CLIENT_ACHIEVEMENT.back.toString(),this.onAchievementBack);
         registerListener(MsgDoc.OP_CLIENT_GETACHIEVE.back.toString(),this.onGetAchieveBack);
         registerListener(MsgDoc.OP_CLIENT_BOB_AWARD.back.toString(),this.onBobAwardBack);
         registerListener(MsgDoc.OP_CLIENT_SCORE_EXCHANGE.back.toString(),this.onScoreExchangeBack);
         registerListener(MsgDoc.OP_CLIENT_GET_STGCOPY_SCORE.back.toString(),this.onGetStgcopyScore);
         registerListener(MsgDoc.OP_GATEWAY_FAMILY_BORDER.back.toString(),this.onFamilyBorderBack);
         registerListener(MsgDoc.OP_CLIENT_HOMEMESSAGE_TELLANDLISTEN.back.toString(),this.onHomeMessageListen);
         registerListener(MsgDoc.OP_RETURN_MONEY.back.toString(),this.returnMoney);
         registerListener(MsgDoc.OP_GATEWAY_INVITE_MEMBERS.back.toString(),this.onWarcraftInviteMessageCome);
         registerListener(MsgDoc.OP_CLIENT_CHANGNAME.back.toString(),this.onChangePlayerName);
         registerListener(MsgDoc.OP_GATEWATE_CHANGNAME.back.toString(),this.onChangeNameBack);
         registerListener(MsgDoc.OP_CLIENT_REQ_HOUHUA_DATA.back.toString(),this.onReqHouHuaDataBack);
         registerListener(MsgDoc.OP_CLIENT_REQ_PACK_TOKEN.back.toString(),this.onReqPackTokenBack);
         registerListener(MsgDoc.OP_CLIENT_WEEDKEND_AWARD.back.toString(),this.onWeedkendAwardBack);
         registerListener(MsgDoc.OP_CLIENT_MESSAGE_FACE.back.toString(),this.onSendActionBack);
         registerListener(MsgDoc.OP_CLIENT_ANSWER_AWARD.back.toString(),this.onGetAnswerAwardBack);
         registerListener(MsgDoc.OP_CLIENT_MAA_REQ_TASK_INVITE.back.toString(),this.onMaaTaskInviteBack);
         registerListener(MsgDoc.OP_CLIENT_MAA_REQ_TASK_CANCEL.back.toString(),this.onMaaTaskCancelBack);
         registerListener(MsgDoc.OP_CLIENT_MAA_REQ_TASK_ACTION.back.toString(),this.onMaaTaskActionBack);
         registerListener(MsgDoc.OP_CLIENT_MAA_REQ_TASK_COMPLETE.back.toString(),this.onMaaTaskCompleteBack);
         registerListener(MsgDoc.OP_GATEWAY_VIP_TIMEUP.back.toString(),this.onVipTimeUp);
         registerListener(MsgDoc.OP_CLIENT_REQ_PRESURES.back.toString(),this.onPresuresBack);
         registerListener(MsgDoc.OP_CLIENT_REQ_SEND_SPIRIT.back.toString(),this.onSendSpiritBack);
         registerListener(MsgDoc.OP_CLIENT_TEAMCOPY_ENTER.back.toString(),this.onTeamCopyEnterBack);
         registerListener(MsgDoc.OP_CLIENT_TEAMCOPY_ENTER_CONTROL.back.toString(),this.onTeamCopyControlBack);
         registerListener(MsgDoc.OP_CLIENT_SPIRIT_EQUIP_ALL.back.toString(),this.onSpiritEquipAllBack);
         registerListener(MsgDoc.OP_CLIENT_SPIRIT_EQUIP_INFO.back.toString(),this.onSpiriteEquipInfoBack);
         registerListener(MsgDoc.OP_CLIENT_SPIRIT_EQUIP_WEAR.back.toString(),this.onSpiritEquipWearBack);
         registerListener(MsgDoc.OP_CLIENT_SPIRIT_EQUIP_TAKEOFF.back.toString(),this.onSpiritTakoffBack);
         registerListener(MsgDoc.OP_GATEWAY_FISH_RANDOM.back.toString(),this.onFishRandonBack);
         registerListener(MsgDoc.OP_CLIENT_DANCE_STAGE.back.toString(),this.onChangeFaceBack);
         registerListener(MsgDoc.OP_CLIETN_SERV_STOP.back.toString(),this.onServerStopHandler);
         registerListener(MsgDoc.OP_CLIENT_EFFECT_BACK.back.toString(),this.onClientEffectBack);
         registerListener(MsgDoc.OP_CLIENT_REQ_KB_COIN_INFO.back.toString(),this.onKBCoinInfoBack);
         registerListener(MsgDoc.OP_GATEWAY_CHANGEFACE_EYE_BACK.back.toString(),this.onChangeFaceEyeBack);
         registerListener(MsgDoc.OP_CLIENT_REQ_LIMITS_LIST.back.toString(),this.onPackLimitsList);
         registerListener(MsgDoc.OP_CLIENT_REQ_LIMITS_RENEW.back.toString(),this.onPackLimitsRenew);
         registerListener(MsgDoc.OP_BATCH_USE_PROPS.back.toString(),this.onBatchUsePropsHandler);
         registerListener(MsgDoc.OP_GATEWAY_USE_SYMM_TAKEOFF.back.toString(),this.onUseSymmTakeOffHandler);
         registerListener(MsgDoc.OP_CLIENT_MSG_KABUONLINE.back.toString(),this.onKabuOnlineHandler);
         registerListener(MsgDoc.OP_CLIENT_MSG_KABUONLINE_AWARD.back.toString(),this.onKabuOnlineAwardHandler);
         registerListener(MsgDoc.OP_CLIENT_SETTITLE.back.toString(),this.onSetTitleHandler);
         registerListener(MsgDoc.OP_TRUMP_LIST_BACK.back.toString(),this.onTrumpListBack);
         registerListener(MsgDoc.OP_CLIENT_ACTIVITY_QINGYANG.back.toString(),this.onActivityProtocolBackHandler);
         registerListener(MsgDoc.OP_CLIENT_CHANGE_WARE_HOURSE_FACE.back.toString(),this.onChangeWareHouseBackHandler);
         registerListener(MsgDoc.OP_CLIENT_REQ_WARE_HOURSE_FACE.back.toString(),this.onRequestWareHouseBackHandler);
         registerListener(MsgDoc.OP_GATEWAY_CONFIRM_BOX.back.toString(),this.onGatewayConfirmBoxHandler);
         registerListener(MsgDoc.OP_CLIENT_SINGLE_SPIRIT_INFO.back.toString(),this.onSingleSpiritInfoHandler);
         registerListener(MsgDoc.OP_CLIENT_REQ_CROSS_SERVER_PLAYERDRESS.back.toString(),this.onCrossServerPlayerDressHandler);
         registerListener(MsgDoc.OP_CLIENT_ACTIVITY_QINGYANG_NEW.back.toString(),this.onActErrorCodeHandler);
         registerListener(MsgDoc.OP_RESOLVE_SPIRIT_EQUIP.back.toString(),this.onResolveHandler);
         registerListener(MsgDoc.OP_CLIENT_REQ_PLAYER_INFO.back.toString(),this.onItemNumUpdateHandler);
         registerListener(MsgDoc.OP_CLEAR_TASK_DIALOG.back.toString(),this.onClearTaskDialog);
      }
      
      private function onReqHouHuaDataBack(evt:MsgEvent) : void
      {
         var params:Object = null;
         if(evt.msg.mParams == 2001)
         {
            params = {};
            GameData.instance.playerData.houhuayuanID = params.houhuaId = evt.msg.body.readInt();
            GameData.instance.playerData.smallHouseID = params.samllHouseId = evt.msg.body.readInt();
            dispatch(EventConst.REQ_HOUHUA_DATA_BACK,params);
         }
      }
      
      private function onWarcraftInviteMessageCome(evt:MsgEvent) : void
      {
         var params:Object = {};
         params.code = evt.msg.mParams;
         if(params.code > 0)
         {
            params.id = evt.msg.body.readInt();
            params.teamId = evt.msg.body.readInt();
            dispatch(EventConst.WARCRAFT_INVITE,params);
         }
      }
      
      private function returnMoney(evt:MsgEvent) : void
      {
         var money:int = evt.msg.mParams;
         if(money > 0)
         {
            GameData.instance.playerData.coin += money;
            new Alert().showOne("由于你拍卖的布告栏已过期,系统返还" + money + "铜钱");
         }
      }
      
      private function onUseZuoQiToolBack(evt:MsgEvent) : void
      {
         O.traceSocket(evt);
         var params:Object = {};
         params.code = evt.msg.mParams;
         if(params.code > 0)
         {
            params.zid = evt.msg.body.readInt();
            params.did = evt.msg.body.readInt();
         }
         dispatch(EventConst.USE_HORSE_TOOL_BACK,params);
      }
      
      private function reqReduceCosinBack(evt:MsgEvent) : void
      {
         var param:int = evt.msg.mParams;
         if(param == 3)
         {
            new Alert().show("你还有足够的钱来发送哦！");
         }
         if(param == 0)
         {
            O.o("扣除成功！");
            GameData.instance.playerData.coin -= 10;
            dispatch(EventConst.REDUCESUCCESS);
         }
      }
      
      private function horseUseBack(evt:MsgEvent) : void
      {
         var params:Object = {};
         params.code = evt.msg.mParams;
         params.result = evt.msg.body.readInt();
         if(params.result == 1)
         {
            params.userId = evt.msg.body.readInt();
            params.horseId = evt.msg.body.readInt();
            params.horseIndex = evt.msg.body.readInt();
            params.horseSpeed = evt.msg.body.readInt();
            if(params.userId == GameData.instance.playerData.userId)
            {
               GameData.instance.playerData.chorse = params.horseIndex;
               GameData.instance.playerData.horseID = params.horseId;
               GameData.instance.playerData.horseIndex = params.horseIndex;
               GameData.instance.playerData.horseSpeed = params.horseSpeed;
            }
         }
         if(GameData.instance.playerData.currentScenenId == 15000)
         {
            dispatch(EventConst.ON_SOMEONE_USE_HORSE_IN_NEW_WAR,params);
         }
         else
         {
            dispatch(EventConst.HORSEUSEBACK,params);
         }
      }
      
      private function deductGameCoinBack(evt:MsgEvent) : void
      {
         var result:int = 0;
         var param:int = evt.msg.mParams;
         if(param == 1)
         {
            result = evt.msg.body.readInt();
            this.dispatch(EventConst.DEDUCTGAMECOINBACK,result);
         }
      }
      
      private function reqEnterGamehallBack(evt:MsgEvent) : void
      {
         var suBool:int = evt.msg.mParams;
         dispatch(EventConst.REQENTERGAMEHALLBACK,{"sb":suBool});
      }
      
      private function onChangeBorderBack(evt:MsgEvent) : void
      {
         var params:Object = {};
         params.userId = evt.msg.mParams;
         if(Boolean(evt.msg.body.bytesAvailable))
         {
            params.borderId = evt.msg.body.readInt();
            if(params.borderId > 0)
            {
               dispatch(EventConst.CHANGENAMEBORDERBACK,params);
            }
         }
      }
      
      private function onCheckJobBack(evt:MsgEvent) : void
      {
         var obj:Object = {};
         obj.params = evt.msg.mParams;
         obj.checknum = evt.msg.body.readInt();
         dispatch(EventConst.JOB_INFO_BACK,obj);
      }
      
      private function reqXiuweiDataBack(evt:MsgEvent) : void
      {
         var spritesParse:SpiritParse = null;
         var params:Object = null;
         var len:int = 0;
         var symmList:Array = null;
         var i:int = 0;
         var symmObj:Object = null;
         if(evt.msg.mParams == 1)
         {
            spritesParse = new SpiritParse();
            spritesParse.parse(evt.msg);
            spritesParse.params.gongjixiuweizhi = evt.msg.body.readInt();
            spritesParse.params.fangyuxiuweizhi = evt.msg.body.readInt();
            spritesParse.params.fashuxiuweizhi = evt.msg.body.readInt();
            spritesParse.params.kangxingxiuweizhi = evt.msg.body.readInt();
            spritesParse.params.tilixiuweizhi = evt.msg.body.readInt();
            spritesParse.params.suduxiuweizhi = evt.msg.body.readInt();
            dispatch(EventConst.REQXIUWEIBACK,spritesParse.params);
         }
         else
         {
            params = {};
            params.attack = evt.msg.body.readInt();
            params.defence = evt.msg.body.readInt();
            params.magic = evt.msg.body.readInt();
            params.resistance = evt.msg.body.readInt();
            params.hp = evt.msg.body.readInt();
            params.speed = evt.msg.body.readInt();
            len = evt.msg.body.readInt();
            params.hasSymm = len > 0 ? true : false;
            symmList = [];
            for(i = 0; i < len; i++)
            {
               symmObj = {};
               symmObj.symmPlace = evt.msg.body.readInt();
               symmObj.symmId = evt.msg.body.readInt();
               symmObj.symmIndex = evt.msg.body.readInt();
               symmList.push(symmObj);
            }
            params.symmList = symmList;
            dispatch(EventConst.DISTRIBUTEXIUWEIBACK,params);
         }
      }
      
      private function cheakFishOrnotBack(evt:MsgEvent) : void
      {
         var paramas:Object = {};
         paramas.systemid = 1022;
         paramas.flag = paramas.fishbool = evt.msg.mParams;
         paramas.personid = evt.msg.body.readInt();
         if(paramas.fishbool > 0)
         {
            if(paramas.fishbool == 1)
            {
               FishManager.getInstance().startFishing(paramas);
            }
            else
            {
               FishManager.getInstance().overFishing(paramas);
            }
         }
         else if(paramas.personid == GlobalConfig.userId)
         {
            AlertManager.instance.showTipAlert(paramas);
         }
      }
      
      private function onFishRandonBack(evt:MsgEvent) : void
      {
         var params:Object = {};
         params.fishbool = evt.msg.mParams;
         if(params.fishbool == 1)
         {
            params.monsterid = evt.msg.body.readInt();
            params.monsterlevel = evt.msg.body.readInt();
         }
         FishManager.fishmanager.setParams(params);
      }
      
      private function onChangeFaceBack(evt:MsgEvent) : void
      {
         var params:Object = {};
         params.code = evt.msg.mParams;
         if(params.code == 777)
         {
            params.userId = evt.msg.body.readInt();
            params.roleType = evt.msg.body.readInt();
            if(params.userId == GlobalConfig.userId)
            {
               new FloatAlert().show(MapView.instance.stage,320,300,"换肤成功");
            }
            dispatch(EventConst.ON_CHANGE_FACE,params);
            dispatch(EventConst.USEPROPSBACK_PACK);
         }
      }
      
      private function reqMonsterBack(event:MsgEvent) : void
      {
         var monsterList:Array = null;
         var i:int = 0;
         var obj:Object = null;
         var sortParse:SortParse = null;
         var stepid:int = event.msg.mParams;
         var params:Object = {};
         if(stepid == 1)
         {
            params.count = event.msg.body.readInt();
            monsterList = [];
            for(i = 0; i < params.count; i++)
            {
               obj = {};
               obj.id = event.msg.body.readInt();
               obj.iid = event.msg.body.readInt();
               obj.name = String(XMLLocator.getInstance().getSprited(obj.iid).name);
               obj.level = event.msg.body.readInt();
               obj.hp = event.msg.body.readInt();
               obj.strength = event.msg.body.readInt();
               monsterList.push(obj);
            }
            params.monsterList = monsterList;
            dispatch(EventConst.OPENMONSTERSORTVIEW,params);
         }
         if(stepid == 2)
         {
            new Alert().show("技能排序成功！");
            GameData.instance.playerData.coin -= 100;
            dispatch(EventConst.CLOSEMONSTERSORTVIEW);
         }
         if(stepid == 3)
         {
            sortParse = new SortParse();
            params.body = sortParse.parse(event.msg);
            params.showX = 100;
            params.showY = 50;
            dispatch(EventConst.OPEN_CACHE_VIEW,params,null,getQualifiedClassName(SortView));
         }
      }
      
      private function onReplaceMonsterBack(evt:MsgEvent) : void
      {
         var params:Object = {};
         var sucessid:int = evt.msg.mParams;
         if(sucessid == 1)
         {
            params.storeId = evt.msg.body.readInt();
            dispatch(EventConst.GETREPLACEMONSTERBACK);
            dispatch(EventConst.TELLTRIPODCHANGE,params);
            dispatch(EventConst.TELLMONSTERLISTCHANGE);
         }
      }
      
      private function onGetMagicIndxeBack(evt:MsgEvent) : void
      {
         var obj:Object = null;
         var params:Object = {};
         params.magicCount = evt.msg.mParams;
         var magicArr:Array = [];
         var changeArr:Array = [];
         var index:int = 0;
         for(var i:int = 0; i < params.magicCount; i++)
         {
            obj = {};
            obj.id = evt.msg.body.readInt();
            obj.type = evt.msg.body.readInt();
            obj.state = evt.msg.body.readInt();
            obj.num = evt.msg.body.readInt();
            if(obj.type == 1)
            {
               index++;
               if(index >= 10)
               {
                  index = 0;
               }
               obj.index = index;
               magicArr.push(obj);
            }
            else
            {
               changeArr.push(obj);
            }
            GameData.instance.playerData.magiclearnarr[obj.id] = obj.type | int(GameData.instance.playerData.magiclearnarr[obj.id]);
         }
         params.magicArr = magicArr;
         params.changeArr = changeArr;
         dispatch(EventConst.GETMAGICINDEXBACK,params);
      }
      
      private function onUsePropsBack(evt:MsgEvent) : void
      {
         var toolParse:ToolParse = null;
         var params:Object = null;
         var usable:Boolean = false;
         var mallTools:Array = null;
         var toolxml:XML = null;
         var toolId:int = 0;
         var iid:int = 0;
         var name:String = null;
         var code:int = evt.msg.mParams;
         var obj:Object = {};
         obj.systemid = 1011;
         if(code > 0)
         {
            toolParse = new ToolParse();
            params = toolParse.parse(evt.msg);
            usable = false;
            mallTools = [100206,100207,100208,100209];
            try
            {
               toolxml = XMLLocator.getInstance().tooldic[int(params.propsid)];
               if((int(toolxml.useState) & 0x0F) > 0)
               {
                  usable = true;
               }
               if(mallTools.indexOf(params.propsid) != -1)
               {
                  obj.flag = 1;
                  if(params.monsterid >= 0)
                  {
                     obj.params = 0;
                  }
                  else if(params.monsterid == -2)
                  {
                     obj.params = -2;
                  }
                  else if(params.monsterid == -1 || params.monsterid == -7)
                  {
                     obj.params = -7;
                  }
                  else if(params.monsterid == -9999)
                  {
                     obj.params = -999;
                     obj.replace = toolxml.name;
                  }
                  else if(params.propsid == 100209)
                  {
                     obj.params = 100209;
                  }
                  else
                  {
                     obj.params = -1000;
                  }
                  AlertManager.instance.showTipAlert(obj);
               }
            }
            catch(e:*)
            {
            }
            if(usable)
            {
               dispatch(EventConst.USEPROPSBACK_PACK,params);
            }
            else
            {
               dispatch(EventConst.USEPROPSBACK,params);
            }
         }
         else if(code == -10 || code == -11 || code == -12)
         {
            this.dispatch(EventConst.USE_TAI_SHANG_LING_BACK,code + 11);
         }
         else if(code == -1)
         {
            obj.flag = -1;
            toolId = evt.msg.body.readInt();
            if(toolId >= 100111 && toolId <= 100116 || toolId >= 100210 && toolId <= 100215 || toolId == 100035)
            {
               obj.params = -1;
            }
            else
            {
               obj.params = -2;
            }
            AlertManager.instance.showTipAlert(obj);
         }
         else if(code == -100)
         {
            iid = evt.msg.body.readInt();
            name = String(XMLLocator.getInstance().getTool(iid).name);
            obj.flag = -100;
            obj.replace = name;
            AlertManager.instance.showTipAlert(obj);
         }
         else
         {
            AlertManager.instance.showTipAlert({
               "systemid":1011,
               "flag":code,
               "defaultTip":true
            });
         }
      }
      
      private function onCureMonsterBack(evt:MsgEvent) : void
      {
         if(evt.msg.mParams > 0)
         {
            GameData.instance.playerData.coin -= 30;
            dispatch(EventConst.GETMONSTERLIST);
         }
         else
         {
            new Alert().show("治疗失败！是不是铜钱不够呢？！");
         }
      }
      
      private function onEnterRoomBack(event:MsgEvent) : void
      {
         GameData.instance.playerData.isInCrazyRecordRoom = false;
         this.dispatch(EventConst.MAKE_CRAZY_RECORD_SCENE_LIST,false);
         GameData.instance.playerData.isInHouse = true;
         dispatch(EventConst.ENTERROOMBACK);
      }
      
      private function onGetFabaoBack(evt:MsgEvent) : void
      {
         O.o("【20111228hodam_MainModel_onGetFabaoBack领取贝贝返回】" + evt.msg.mParams);
         var code:int = evt.msg.mParams;
         if(code == 1)
         {
            GameDynamicUI.removeUI("jiantou");
            GameData.instance.playerData.hasGetBeiBei = 1;
         }
         else
         {
            PlatMonitorLog.instance.writeNewLog(403);
         }
         AlertManager.instance.showTipAlert({
            "systemid":1017,
            "flag":code,
            "defaultTip":true
         });
      }
      
      private function onEnterSceneBack(event:MsgEvent) : void
      {
         GameDynamicUI.removeUI("loading");
         FaceView.clip.hidetip();
         if(event.msg.mParams > 0)
         {
            if(GameData.instance.playerData.isInGardon)
            {
               GameData.instance.playerData.isInGardon = false;
               con.sendCmd(MsgDoc.OP_CLIENT_REQ_HOUHUA_DATA.send,2001);
            }
            else
            {
               if(GameData.instance.playerData.nextSceneId == 1028)
               {
                  DelayShowUtil.instance.playerControl = true;
                  FaceView.clip.topMiddleClip.clearClip.gotoAndStop(1);
               }
               GameData.instance.playerData.isInCangBaoGe = GameData.instance.playerData.lastSceneId == 125 ? true : false;
               GreenLoading.loading.visible = false;
               dispatch(EventConst.ENTER_SCENE_BACK);
               dispatch(EventConst.EEQ_PLAYERS_LIST);
               dispatch(EventConst.REQ_NPCS_LIST);
               CacheData.instance.openboxscene = 0;
               CacheData.instance.perishEvilScene = 0;
               CacheData.instance.isOpenAct668BoxView = false;
               con.sendCmd(MsgDoc.OP_CLIENT_ACTIVITY_QINGYANG.send,900,[1,GameData.instance.playerData.currentScenenId]);
               con.sendCmd(MsgDoc.OP_CLIENT_ACTIVITY_QINGYANG.send,902,[1,GameData.instance.playerData.currentScenenId]);
               con.sendCmd(MsgDoc.OP_CLIENT_ACTIVITY_QINGYANG.send,325,[4]);
               if(!GameData.instance.playerData.isHasEnterScene)
               {
                  GameData.instance.playerData.isHasEnterScene = true;
                  dispatch(EventConst.LOGINGAMEBACK);
               }
            }
            ReConnectStatus.instance.SUCCESS_E_SCENE = true;
         }
         else
         {
            GameData.instance.playerData.currentScenenId = GameData.instance.playerData.sceneId;
            this.dispatch(EventConst.ENTER_SCENE_FAILED,event.msg.mParams);
            if(!ReConnectStatus.instance.SUCCESS_E_SCENE)
            {
               dispatch(EventConst.ENTERSCENE,1004);
            }
            ReConnectStatus.instance.SUCCESS_E_SCENE = true;
         }
      }
      
      private function onExitWordBack(evt:MsgEvent) : void
      {
         if(evt.msg.mParams > 0)
         {
         }
      }
      
      private function onLingquPrizeBack(event:MsgEvent) : void
      {
         var obj:Object = {};
         obj.mParams = event.msg.mParams;
         obj.money = event.msg.body.readInt();
         obj.exp = event.msg.body.readInt();
         dispatch(EventConst.LINGQUPRIZEBACK,obj);
      }
      
      private function onBattleAwordBack(event:MsgEvent) : void
      {
         var i:int = 0;
         var obj:Object = null;
         var params:Object = {};
         params.towertype = event.msg.mParams;
         params.currentlevel = event.msg.body.readInt();
         params.coin = event.msg.body.readInt();
         params.exp = event.msg.body.readInt();
         params.getthingscount = event.msg.body.readInt();
         var arr:Array = [];
         for(i = 0; i < params.getthingscount; i++)
         {
            obj = {};
            obj.type = event.msg.body.readInt();
            obj.getthingsid = event.msg.body.readInt();
            obj.getthings = event.msg.body.readInt();
            arr.push(obj);
         }
         params.thingsdata = arr;
         dispatch(EventConst.WIN_COPY_THINGS,params);
      }
      
      private function onCopyProgressBack(event:MsgEvent) : void
      {
         var lastCopyLevel:int = 0;
         var maxCopyLevel:int = 0;
         var str:String = null;
         var obj:Object = null;
         var pa:int = event.msg.mParams;
         GameData.instance.playerData.currentCopyType = pa;
         if(pa < 0)
         {
            return;
         }
         if(pa < 4 || pa == 13)
         {
            lastCopyLevel = event.msg.body.readInt();
            maxCopyLevel = event.msg.body.readInt();
            if(GameData.instance.playerData.currentCopyType == 3)
            {
               str = "";
               if(lastCopyLevel == 1)
               {
                  this.dispatch(EventConst.OPEN_MODULE,{
                     "url":"assets/mazeroad/MazeEntry.swf",
                     "xCoord":0,
                     "yCoord":0
                  });
               }
               else
               {
                  obj = {};
                  obj.systemid = 1006;
                  obj.flag = lastCopyLevel;
                  AlertManager.instance.showTipAlert(obj);
               }
            }
            else if(pa == 13)
            {
               dispatch(EventConst.OPEN_MODULE,{
                  "url":"assets/module/SealMonsterReel.swf",
                  "xCoord":0,
                  "yCoord":0
               });
            }
            else if(pa == 2)
            {
               GameData.instance.playerData.lastcopylevel = lastCopyLevel;
               GameData.instance.playerData.maxcopylevel = maxCopyLevel;
               dispatch(EventConst.BOBSTATECLICK,{"url":"assets/module/CopyProjectShuangGu.swf"});
            }
            else
            {
               GameData.instance.playerData.lastcopylevel = lastCopyLevel;
               GameData.instance.playerData.maxcopylevel = maxCopyLevel;
               dispatch(EventConst.BOBSTATECLICK,{"url":"assets/module/CopyProject.swf"});
            }
         }
      }
      
      private function onPlayerMoveBack(event:MsgEvent) : void
      {
         if(GameData.instance.playerData.currentScenenId == 15000)
         {
            return;
         }
         var params:Object = {};
         params.newx = event.msg.body.readInt();
         params.newy = event.msg.body.readInt();
         params.userId = event.msg.body.readInt();
         if(GameData.instance.playerData.sceneId == 11005 && params.newx == 150 && params.newy == 450)
         {
            dispatch(EventConst.BOSSWAR_BOSS_BEART_OVER,params);
         }
         else
         {
            if(event.msg.body.bytesAvailable > 3)
            {
               params.moveFlag = event.msg.body.readInt();
            }
            else
            {
               params.moveFlag = 1;
            }
            dispatch(EventConst.ON_USER_MOVE_BACK,params);
         }
      }
      
      private function onAddPlayerToScene(event:MsgEvent) : void
      {
         var sd:ShowData = this.sdp.myparse(event.msg);
         O.traceSocket(event);
         if(sd.userId != GameData.instance.playerData.userId)
         {
            dispatch(EventConst.ONUSERENTER,sd);
         }
      }
      
      private function onScenePlayerList(event:MsgEvent) : void
      {
         var obj:ShowData = null;
         var params:Object = {};
         var result:Array = [];
         var totalNum:int = event.msg.mParams;
         for(var i:int = 0; i < totalNum; i++)
         {
            obj = new ShowData();
            obj.x = event.msg.body.readInt();
            obj.y = event.msg.body.readInt();
            obj = this.sdp.myparse(event.msg,obj);
            result.push(obj);
         }
         dispatch(EventConst.REQUEST_PLAYERLIST_BACK,{"playerlist":result});
      }
      
      private function onPackageDataBack(event:MsgEvent) : void
      {
         var toolxml:XML = null;
         var obj:Object = null;
         var temp:Array = null;
         var j:int = 0;
         var goods:Object = null;
         var resEle:Object = null;
         var flag:Boolean = false;
         var good:Object = null;
         if(event.msg.mParams == 1048576 || event.msg.mParams == 1048576 || event.msg.mParams == 9)
         {
            return;
         }
         var params:Object = {};
         if(event.msg.body == null)
         {
            return;
         }
         params.isocode = event.msg.body.readInt();
         params.packcount = event.msg.body.readInt();
         var result:Array = [];
         for(var i:int = 0; i < params.packcount; i++)
         {
            obj = {};
            obj.packcode = event.msg.body.readInt();
            obj.packid = event.msg.body.readInt();
            obj.count = event.msg.body.readInt();
            temp = [];
            for(j = 0; j < obj.count; j++)
            {
               goods = {};
               goods.packcode = obj.packcode;
               goods.packid = obj.packid;
               goods.position = event.msg.body.readInt();
               goods.id = event.msg.body.readInt();
               if(goods.id > 0)
               {
                  goods.count = event.msg.body.readInt();
                  goods.usableStatus = 0;
                  toolxml = XMLLocator.getInstance().tooldic[goods.id];
                  if(toolxml != null)
                  {
                     goods.usableStatus = int(toolxml.useState);
                     goods.sortValue = int(toolxml.sortValue);
                  }
                  temp.push(goods);
               }
            }
            obj.goods = temp;
            result.push(obj);
         }
         var len:int = event.msg.body.readInt();
         for(i = 0; i < len; i++)
         {
            obj = {};
            obj.id = event.msg.body.readInt();
            if(obj.id != 0)
            {
               obj.count = event.msg.body.readInt();
               obj.expiretime = event.msg.body.readInt();
               for each(resEle in result)
               {
                  flag = false;
                  if(resEle.count > 0)
                  {
                     for each(good in resEle.goods)
                     {
                        if(good.id == obj.id)
                        {
                           good.expiretime = obj.expiretime;
                           if(!good.hasOwnProperty("iid"))
                           {
                              good.iid = obj.id;
                           }
                           flag = true;
                           break;
                        }
                     }
                  }
                  if(flag)
                  {
                     break;
                  }
               }
            }
         }
         params.list = result;
         if(event.msg.mParams == 257 || event.msg.mParams == 1025)
         {
            if(ApplicationFacade.getInstance().retrieveViewLogic(NewBattleControl.NAME) == null)
            {
               dispatch(EventConst.BATTLE_TOOL_BACK,params);
            }
         }
         else if(event.msg.mParams == 4194308)
         {
            new Message("get_family_farm_tools_back",params).sendToChannel("family_farm");
         }
         else if(event.msg.mParams == 513)
         {
            dispatch(EventConst.GETPROPSLISTBACK,params);
         }
         else if(event.msg.mParams == 4128)
         {
            dispatch(EventConst.GETHECHENGBACK,params);
         }
         else if(event.msg.mParams == 262176)
         {
            dispatch(EventConst.GETDUIHUANBACK,params);
         }
         else if(event.msg.mParams == 16385)
         {
            dispatch(EventConst.GETTRUMPTOOLBACK,params);
         }
         else if(event.msg.mParams == 2621440)
         {
            dispatch(EventConst.ONTREASURES,params);
         }
         else if(event.msg.mParams == 16777345)
         {
            new Message("get_props_back",params).sendToChannel("shenshou");
         }
         else if(event.msg.mParams == 33554433)
         {
            dispatch(EventConst.GET_ZUOQI_TOOL_BACK,params);
         }
         else if(event.msg.mParams == 536870913)
         {
            dispatch(EventConst.GET_PACKAGE_DATA_BACK,params);
         }
         else if(event.msg.mParams == -1)
         {
            if(Boolean(params.list) && params.list.length != 0)
            {
               if(Boolean(params.list[0]) && params.list[0].count != -1)
               {
                  GameData.instance.playerData.toolArr = params.list[0].goods;
               }
               if(Boolean(params.list[1]) && params.list[1].count != -1)
               {
                  GameData.instance.playerData.goodArr = params.list[1].goods;
               }
            }
            dispatch(EventConst.GETPACKINFOBACK);
         }
      }
      
      private function onTripodBack(event:MsgEvent) : void
      {
         var storagePrase:StorageParse = null;
         O.traceSocket(event);
         var state:int = event.msg.mParams;
         if(state > -1)
         {
            storagePrase = new StorageParse();
            storagePrase.parse(event.msg);
            dispatch(EventConst.ONGETMONSTERKINDSLISTBACK,storagePrase.storage);
         }
         else
         {
            dispatch(EventConst.STORENOCHANGE);
         }
      }
      
      private function onSpiritListBack(event:MsgEvent) : void
      {
         O.traceSocket(event);
         var spritesParse:SpiritParse = new SpiritParse();
         spritesParse.parse(event.msg);
         spritesParse.params.monsterCurrentLength = event.msg.body.readInt();
         spritesParse.params.monsterTotalLenght = event.msg.body.readInt();
         if(event.msg.mParams == 0)
         {
            dispatch(EventConst.GETMONSTERLISTBACK,spritesParse.params);
         }
      }
      
      private function onSpiritOperator(event:MsgEvent) : void
      {
         var params:Object = {};
         params.ope = event.msg.body.readInt();
         params.userId = event.msg.body.readInt();
         params.msid = event.msg.body.readInt();
         params.mid = event.msg.body.readInt();
         params.mstateCount = event.msg.body.readInt();
         params.name = event.msg.body.readUTF();
         dispatch(EventConst.MONSTEROPERATION,params);
         if(GlobalConfig.userId == params.userId && Boolean(CacheData.instance.storageList))
         {
            CacheData.instance.storageList.isChange = true;
         }
      }
      
      private function onSpiritPeerlessOpenOrClose(event:MsgEvent) : void
      {
         var params:Object = {};
         params.result = event.msg.mParams;
         params.id = event.msg.body.readInt();
         params.iid = event.msg.body.readInt();
         params.type = event.msg.body.readInt();
         dispatch(EventConst.PEERLESSOPENORCLOSE,params);
      }
      
      private function onBuyGoodsBack(event:MsgEvent) : void
      {
         var vipFlag:int = 0;
         var level:int = 0;
         var totalNum:int = 0;
         var remainNum:int = 0;
         var flag:int = event.msg.mParams;
         var obj:Object = {};
         obj.systemid = 1004;
         if(flag != 0)
         {
            switch(flag)
            {
               case -11:
                  obj.flag = flag;
                  vipFlag = event.msg.body.readInt();
                  level = event.msg.body.readInt();
                  if(0 == vipFlag)
                  {
                     obj.params = 0;
                  }
                  else
                  {
                     obj.params = -1000;
                     obj.replace = level;
                  }
                  AlertManager.instance.showTipAlert(obj);
                  break;
               case -12:
                  totalNum = event.msg.body.readInt();
                  remainNum = event.msg.body.readInt();
                  obj.flag = flag;
                  obj.replace = totalNum;
                  obj.replaceNum = remainNum;
                  AlertManager.instance.showTipAlert(obj);
                  break;
               default:
                  obj.flag = flag;
                  if(flag == -5)
                  {
                     if(Boolean(GameData.instance.playerData.roleType & 1 == 1))
                     {
                        obj.params = 1;
                     }
                  }
                  AlertManager.instance.showTipAlert(obj);
            }
         }
         else
         {
            obj.leftMoney = event.msg.body.readInt();
            obj.DaojuId = event.msg.body.readInt();
            obj.mount = event.msg.body.readInt();
            GameData.instance.playerData.coin = obj.leftMoney;
            AlertManager.instance.showAwardAlert({
               "toolid":obj.DaojuId,
               "num":obj.mount
            });
            if(obj.DaojuId == 500040)
            {
               obj.flag = -1000;
               AlertManager.instance.showTipAlert(obj);
            }
            new Message("baughtOK").sendToChannel("BuyGoods");
            if(obj.DaojuId == 400218)
            {
               new Message("buyReinforcement").sendToChannel("BuyGoods");
            }
         }
      }
      
      private function onPutSpiritStore(event:MsgEvent) : void
      {
         var monsterList:Array = null;
         var i:int = 0;
         var obj:Object = null;
         var params:Object = {};
         if(event.msg.mParams > 0)
         {
            params.id = event.msg.body.readInt();
            params.userid = event.msg.body.readInt();
            params.code = event.msg.body.readInt();
            if(params.code == 4)
            {
               dispatch(EventConst.GCMONSTERBACK,params);
            }
            else if(params.code < 4)
            {
               dispatch(EventConst.STORETRANSFERBACK,params);
            }
         }
         if(event.msg.mParams == -8)
         {
            params.storeID = event.msg.body.readInt();
            params.count = event.msg.body.readInt();
            monsterList = [];
            for(i = 0; i < params.count; i++)
            {
               obj = {};
               obj.id = event.msg.body.readInt();
               obj.iid = event.msg.body.readInt();
               obj.name = String(XMLLocator.getInstance().getSprited(obj.iid).name);
               obj.level = event.msg.body.readInt();
               obj.hp = event.msg.body.readInt();
               obj.strength = event.msg.body.readInt();
               monsterList.push(obj);
            }
            params.monsterList = monsterList;
            params.showX = 280;
            params.showY = 100;
            dispatch(EventConst.OPEN_CACHE_VIEW,params,null,getQualifiedClassName(ReplaceMonsterView));
         }
      }
      
      private function onGetSpiritStore(event:MsgEvent) : void
      {
         var obj:Object = null;
         var id:int = event.msg.body.readInt();
         if(event.msg.mParams == 1)
         {
            dispatch(EventConst.ONPUTINPACKETBACK,{"id":id});
         }
         else
         {
            obj = {};
            obj.systemid = 1012;
            if(event.msg.mParams == 0)
            {
               obj.flag = 0;
            }
            else
            {
               obj.flag = -1;
            }
            AlertManager.instance.showTipAlert(obj);
         }
      }
      
      private function onReleaseSpirit(event:MsgEvent) : void
      {
         var obj:Object = null;
         var id:int = event.msg.body.readInt();
         if(event.msg.mParams == 0 || event.msg.mParams == 1)
         {
            dispatch(EventConst.ONRELEASEMONSTERBACK,{"id":id});
         }
         else
         {
            obj = {};
            obj.systemid = 1008;
            obj.flag = event.msg.mParams;
            AlertManager.instance.showTipAlert(obj);
         }
      }
      
      private function onSetFirstSpirit(event:MsgEvent) : void
      {
         var id:int = event.msg.body.readInt();
         if(event.msg.mParams >= 0)
         {
            dispatch(EventConst.SETFIRSTBACK,{"id":id});
         }
      }
      
      private function onNpcListBack(event:MsgEvent) : void
      {
         O.traceSocket(event,"",0,2);
         var params:Object = {};
         var result:Array = [];
         params.count = event.msg.body.readInt();
         for(var i:int = 0; i < params.count; i++)
         {
            result.push(event.msg.body.readInt());
         }
         params.npcList = result;
         dispatch(EventConst.ONGETNPCLISTBACK,params);
      }
      
      private function onNPCStatusBack(evt:MsgEvent) : void
      {
         var params:Object = {};
         params.npcid = evt.msg.mParams;
         params.npcState = evt.msg.body.readInt();
         if(evt.msg.body.bytesAvailable > 0)
         {
            switch(evt.msg.body.bytesAvailable)
            {
               case 4:
                  params.autoTask = evt.msg.body.readInt();
                  break;
               case 8:
                  params.level = evt.msg.body.readInt();
                  params.monsterID = evt.msg.body.readInt();
            }
         }
         this.dispatch(EventConst.ONGETNPCSTATEBACK,params);
      }
      
      private function onColletcStuffStatus(event:MsgEvent) : void
      {
         var params:Object = {};
         params.statusid = event.msg.mParams;
         switch(event.msg.mParams)
         {
            case 2:
               params.extra = 0;
               params.stuffid = event.msg.body.readInt();
               params.stuffcount = event.msg.body.readInt();
               params.userid = event.msg.body.readInt();
               break;
            case 3:
               params.extra = 0;
               params.userid = event.msg.body.readInt();
               break;
            case 1:
               params.extra = 0;
               params.userid = event.msg.body.readInt();
               break;
            case 4:
               params.extra = 1;
               params.stuffid = event.msg.body.readInt();
               params.stuffcount = event.msg.body.readInt();
         }
         this.dispatch(EventConst.ONCHECKSTUFFBACK,params);
      }
      
      private function onHeChengTool(event:MsgEvent) : void
      {
         var params:Object = {};
         var count:int = event.msg.body.readInt();
         var idList:Array = [];
         for(var i:int = 0; i < count; i++)
         {
            idList.push(event.msg.body.readInt());
         }
         params.money = event.msg.body.readInt();
         params.list = idList;
         if(event.msg.mParams > 0)
         {
            GameData.instance.playerData.coin -= params.money;
            dispatch(EventConst.HECHENGTOOLBACK,event.msg.mParams);
         }
         else
         {
            if(event.msg.mParams == 0)
            {
               GameData.instance.playerData.coin -= params.money;
               dispatch(EventConst.HECHENGFAILURE,params.list);
            }
            AlertManager.instance.showTipAlert({
               "systemid":1013,
               "flag":event.msg.mParams
            });
         }
      }
      
      private function onDistributeExp(event:MsgEvent) : void
      {
         var spiritArr:Array = null;
         var spiritCount:int = 0;
         var i:int = 0;
         var obj:Object = null;
         var msgpack:MsgPacket = event.msg;
         var params:Object = {};
         if(msgpack.mParams == 1)
         {
            params.totalExp = msgpack.body.readInt();
            spiritArr = [];
            spiritCount = msgpack.body.readInt();
            for(i = 0; i < spiritCount; i++)
            {
               obj = {};
               obj.id = msgpack.body.readInt();
               obj.level = msgpack.body.readInt();
               obj.iid = msgpack.body.readInt();
               obj.exp = msgpack.body.readInt();
               obj.mold = msgpack.body.readInt();
               obj.time = msgpack.body.readInt();
               obj.needExp = msgpack.body.readInt();
               obj.name = String(XMLLocator.getInstance().getSprited(obj.iid).name);
               spiritArr.push(obj);
            }
            params.spiritArr = spiritArr;
         }
         if(msgpack.mParams == 2)
         {
            params.id = msgpack.body.readInt();
            params.exp = msgpack.body.readInt();
            params.needExp = msgpack.body.readInt();
            params.iid = msgpack.body.readInt();
            params.currentlevel = msgpack.body.readInt();
            params.currentExp = msgpack.body.readInt();
         }
         if(event.msg.mParams == 1)
         {
            dispatch(EventConst.STORE_EXP_BACK,params);
         }
         else
         {
            if(event.msg.mParams == 2)
            {
               dispatch(EventConst.DISTRIBUTE_EXP_BACK,params);
            }
            AlertManager.instance.showTipAlert({
               "systemid":1064,
               "flag":event.msg.mParams,
               "replace":event.msg.mParams,
               "stage":MapView.instance.stage,
               "defaultTip":true
            });
         }
      }
      
      private function onDuiHuanTool(event:MsgEvent) : void
      {
         var params:Object = {};
         params.id = event.msg.body.readInt();
         params.count = event.msg.body.readInt();
         params.money = event.msg.body.readInt();
         var code:int = event.msg.mParams;
         if(code >= 0)
         {
            dispatch(EventConst.STARTDUIHUANBACK,params);
         }
         else
         {
            AlertManager.instance.showTipAlert({
               "systemid":1007,
               "flag":code
            });
         }
      }
      
      private function onTrumpBack(event:MsgEvent) : void
      {
         var params:Object = {};
         if(event.msg.mParams != -1)
         {
            params.userId = event.msg.body.readInt();
            params.vipLevel = event.msg.body.readInt();
            params.vipScore = event.msg.body.readInt();
            params.trumpAppearance = event.msg.body.readInt();
            params.isSupertrump = event.msg.body.readInt();
            dispatch(EventConst.TRUMPBACK,params);
         }
         else
         {
            if(event.msg.mParams == -1)
            {
               if(GameData.instance.playerData.hasGetBeiBei == 0)
               {
                  new Alert().show("你还没领取贝贝哦");
               }
            }
            O.o("你没有贝贝！");
         }
      }
      
      private function onTrumpOpration(event:MsgEvent) : void
      {
         var params:Object = null;
         if(event.msg.mParams == -1)
         {
            new Alert().show("贝贝活力不够了哦!");
         }
         else
         {
            params = {};
            params.userId = event.msg.body.readInt();
            params.isVip = event.msg.body.readInt();
            params.vipLevel = event.msg.body.readInt();
            params.vipScore = event.msg.body.readInt();
            params.trumpAppearance = event.msg.body.readInt();
            params.ope = event.msg.mParams;
            dispatch(EventConst.RECALL_TRUMP_BACK,params);
         }
      }
      
      private function onTrumpInfoBack(event:MsgEvent) : void
      {
         var params:Object = {};
         if(event.msg.mParams == -1)
         {
            return;
         }
         params.id = event.msg.mParams;
         params.vipLevel = event.msg.body.readInt();
         params.masterName = ChatUtil.onCheckStr(event.msg.body.readUTF());
         params.time = event.msg.body.readInt();
         params.vipSocre = event.msg.body.readInt();
         params.issuper = event.msg.body.readInt();
         params.functionvalue = event.msg.body.readInt();
         params.trumpAppearance = event.msg.body.readInt();
         params.isSupertrump = event.msg.body.readInt();
         dispatch(EventConst.GETTRUMPINFOBACK,params);
      }
      
      private function onTrumpListBack(evt:MsgEvent) : void
      {
         var count:int = 0;
         var result:int = 0;
         var msgType:int = evt.msg.mParams;
         var params:Object = {};
         if(msgType == 1)
         {
            params.curDecor = evt.msg.body.readInt();
            params.trumpList = [];
            count = evt.msg.body.readInt();
            while(Boolean(count--))
            {
               params.trumpList.push(evt.msg.body.readInt());
            }
            dispatch(EventConst.GETTRUMPLISTBACK,params);
         }
         else if(msgType == 2)
         {
            result = evt.msg.body.readInt();
            dispatch(EventConst.CHANGETRUMPBACK,result);
         }
      }
      
      private function onGetTrainInfo(evt:MsgEvent) : void
      {
         var count:int = 0;
         var i:int = 0;
         var obj:Object = null;
         var mObj:Object = null;
         var params:Object = {};
         var list:Array = [];
         var flag:int = evt.msg.mParams;
         if(flag == 0)
         {
            count = evt.msg.body.readInt();
            if(count >= 0)
            {
               for(i = 0; i < count; i++)
               {
                  obj = {};
                  obj.time = evt.msg.body.readInt();
                  obj.id = evt.msg.body.readInt();
                  obj.iid = evt.msg.body.readInt();
                  obj.name = String(XMLLocator.getInstance().getSprited(obj.iid).name);
                  list.push(obj);
               }
            }
            params.mlist = list;
            params.showX = 0;
            params.showY = 0;
            dispatch(EventConst.OPEN_CACHE_VIEW,params,null,getQualifiedClassName(TrumpTrainningView));
         }
         else if(flag > 0)
         {
            if(evt.msg.body == null)
            {
               return;
            }
            mObj = {};
            mObj.id = evt.msg.body.readInt();
            if(mObj.id <= 0)
            {
               return;
            }
            mObj.typeid = evt.msg.body.readInt();
            mObj.iid = evt.msg.body.readInt();
            mObj.name = String(XMLLocator.getInstance().getSprited(mObj.iid).name);
            mObj.isfirst = evt.msg.body.readInt();
            mObj.level = evt.msg.body.readInt();
            mObj.exp = evt.msg.body.readInt();
            mObj.type = evt.msg.body.readInt();
            mObj.attack = evt.msg.body.readInt();
            mObj.defence = evt.msg.body.readInt();
            mObj.magic = evt.msg.body.readInt();
            mObj.resistance = evt.msg.body.readInt();
            mObj.strength = evt.msg.body.readInt();
            mObj.hp = evt.msg.body.readInt();
            mObj.speed = evt.msg.body.readInt();
            mObj.mold = evt.msg.body.readInt();
            mObj.state = evt.msg.body.readInt();
            mObj.needExp = evt.msg.body.readInt();
            mObj.timetxt = evt.msg.body.readInt();
            mObj.attackLearnValue = evt.msg.body.readInt();
            mObj.defenceLearnValue = evt.msg.body.readInt();
            mObj.magicLearnValue = evt.msg.body.readInt();
            mObj.resistanceLearnValue = evt.msg.body.readInt();
            mObj.hpLearnValue = evt.msg.body.readInt();
            mObj.speedLearnVale = evt.msg.body.readInt();
            mObj.attackGeniusValue = evt.msg.body.readInt();
            mObj.defenceGeniusValue = evt.msg.body.readInt();
            mObj.magicGeniusValue = evt.msg.body.readInt();
            mObj.resistanceGeniusValue = evt.msg.body.readInt();
            mObj.hpGeniusValue = evt.msg.body.readInt();
            mObj.speedGeniusValue = evt.msg.body.readInt();
            mObj.symmFlag = evt.msg.body.readInt();
            if(mObj.symmFlag > 0)
            {
               mObj.addAttack = evt.msg.body.readInt();
               mObj.addMagic = evt.msg.body.readInt();
               mObj.addDefence = evt.msg.body.readInt();
               mObj.addResistance = evt.msg.body.readInt();
               mObj.addStrength = evt.msg.body.readInt();
               mObj.addSpeed = evt.msg.body.readInt();
            }
            mObj.attackGenius = SpiritGenius.cheakGenius(mObj.attackGeniusValue);
            mObj.defenceGenius = SpiritGenius.cheakGenius(mObj.defenceGeniusValue);
            mObj.magicGenius = SpiritGenius.cheakGenius(mObj.magicGeniusValue);
            mObj.resistanceGenius = SpiritGenius.cheakGenius(mObj.resistanceGeniusValue);
            mObj.hpGenius = SpiritGenius.cheakGenius(mObj.hpGeniusValue);
            mObj.speedGenius = SpiritGenius.cheakGenius(mObj.speedGeniusValue);
            mObj.CountGeniuscount = SpiritGenius.countGenius(mObj.attackGenius,mObj.defenceGenius,mObj.magicGenius,mObj.resistanceGenius,mObj.hpGenius,mObj.speedGenius);
            mObj.showX = 0;
            mObj.showY = 0;
            dispatch(EventConst.OPEN_CACHE_VIEW,mObj,null,getQualifiedClassName(TrumpTrainMonster));
         }
      }
      
      private function onTrainMonsterBack(event:MsgEvent) : void
      {
         if(event.msg.mParams > 0)
         {
            dispatch(EventConst.STARTTRAINMONSTERBACK);
         }
         else
         {
            AlertManager.instance.showTipAlert({
               "systemid":1009,
               "flag":event.msg.mParams
            });
         }
      }
      
      private function onStopTrainBack(event:MsgEvent) : void
      {
         var param:Object = null;
         if(event.msg.mParams > 0)
         {
            dispatch(EventConst.STOPTRAINMONSTERBACK);
            param = {};
            param.id = event.msg.mParams;
            param.iid = event.msg.body.readInt();
            param.txt1 = String(XMLLocator.getInstance().getSprited(param.iid).name);
            param.txt5 = "+" + event.msg.body.readInt();
            param.txt6 = "+" + event.msg.body.readInt();
            param.txt7 = "+" + event.msg.body.readInt();
            param.txt8 = "+" + event.msg.body.readInt();
            param.txt3 = "+" + event.msg.body.readInt();
            param.txt4 = "+" + event.msg.body.readInt();
            param.txt2 = "+" + event.msg.body.readInt();
            param.showX = 220;
            param.showY = 60;
            dispatch(EventConst.OPEN_CACHE_VIEW,param,null,getQualifiedClassName(TrumpTrainResult));
         }
         else if(event.msg.mParams == -1)
         {
            new Alert().show("宠物背包和妖怪仓库都满了！");
         }
      }
      
      private function onShowTrainingMonster(event:MsgEvent) : void
      {
         var num:int = 0;
         var list:Array = null;
         var i:int = 0;
         var obj:Object = null;
         if(GameData.instance.playerData.currentScenenId != 1002)
         {
            return;
         }
         if(event.msg.mParams == 1)
         {
            num = event.msg.body.readInt();
            list = [];
            for(i = 0; i < num; i++)
            {
               obj = {};
               obj.id = event.msg.body.readInt();
               obj.iid = event.msg.body.readInt();
               obj.level = event.msg.body.readInt();
               obj.type = event.msg.body.readInt();
               obj.mold = event.msg.body.readInt();
               obj.time = event.msg.body.readInt();
               obj.attackGeniusValue = event.msg.body.readInt();
               obj.defenceGeniusValue = event.msg.body.readInt();
               obj.magicGeniusValue = event.msg.body.readInt();
               obj.resistanceGeniusValue = event.msg.body.readInt();
               obj.hpGeniusValue = event.msg.body.readInt();
               obj.speedGeniusValue = event.msg.body.readInt();
               obj.attackGenius = SpiritGenius.cheakGenius(obj.attackGeniusValue);
               obj.defenceGenius = SpiritGenius.cheakGenius(obj.defenceGeniusValue);
               obj.magicGenius = SpiritGenius.cheakGenius(obj.magicGeniusValue);
               obj.resistanceGenius = SpiritGenius.cheakGenius(obj.resistanceGeniusValue);
               obj.hpGenius = SpiritGenius.cheakGenius(obj.hpGeniusValue);
               obj.speedGenius = SpiritGenius.cheakGenius(obj.speedGeniusValue);
               obj.CountGeniuscount = SpiritGenius.countGenius(obj.attackGenius,obj.defenceGenius,obj.magicGenius,obj.resistanceGenius,obj.hpGenius,obj.speedGenius);
               obj.x = 300 + i * 80;
               obj.y = 300;
               obj.labelName = "正在训练中";
               obj.tid = obj.iid;
               obj.master = GameData.instance.playerData.houseName;
               list.push(obj);
            }
            dispatch(EventConst.SHOWTRAINGMONSTERSATHOME,list);
         }
      }
      
      private function onTrainedMonsterBack(evt:MsgEvent) : void
      {
         if(evt.msg.mParams == 1 || evt.msg.mParams == -1)
         {
            AlertManager.instance.showTipAlert({
               "systemid":1014,
               "flag":evt.msg.mParams
            });
         }
      }
      
      private function onZhuangBeiBack(event:MsgEvent) : void
      {
         var equipXML:XML = null;
         var obj:Object = null;
         if(event.msg.mParams != 0)
         {
            return;
         }
         var num:int = event.msg.body.readInt();
         var list:Array = [];
         for(var i:int = 0; i < num; i++)
         {
            obj = {};
            obj.id = event.msg.body.readInt();
            obj.expiretime = event.msg.body.readInt();
            obj.count = 1;
            obj.packid = ItemType.dressType;
            equipXML = XMLLocator.getInstance().tooldic[obj.id] as XML;
            if(equipXML != null)
            {
               obj.usableStatus = int(equipXML.useState);
               obj.sortValue = int(equipXML.sortValue);
               obj.type = int(equipXML.type);
            }
            if(!(obj.id >= 100083 && obj.id <= 100092))
            {
               list.push(obj);
            }
         }
         if(num != -1)
         {
            GameData.instance.playerData.armsArr = list;
         }
         dispatch(EventConst.GETZHUANGBEIBACK,GameData.instance.playerData.armsArr);
      }
      
      private function onRemovePlayFromScene(event:MsgEvent) : void
      {
         if(GameData.instance.playerData.isInWarCraft)
         {
            dispatch(EventConst.DEL_PERSON_IN_WARCRAFT,event.msg.mParams);
         }
         else
         {
            dispatch(EventConst.ONUSERLEAVE,event.msg.mParams);
         }
      }
      
      private function onIndulgeBack(event:MsgEvent) : void
      {
         var param:int = 0;
         var statetime:int = 0;
         if(event.msg.mParams == 0)
         {
            if(GameData.instance.playerData.isNewHand < 9)
            {
               dispatch(EventConst.OPEN_CACHE_VIEW,{
                  "showX":0,
                  "showY":0
               },null,getQualifiedClassName(TimeRestView));
            }
         }
         else
         {
            GameData.instance.playerData.playerStatus = event.msg.body.readInt();
            GameData.instance.playerData.playerSurplus = event.msg.body.readInt();
            param = event.msg.body.readInt();
            if(event.msg.body.bytesAvailable > 0 && GameData.instance.playerData.playerStatus != 4)
            {
               statetime = event.msg.body.readInt();
            }
            if(event.msg.body.bytesAvailable > 0)
            {
               GameData.instance.playerData.systemTimes = event.msg.body.readInt();
               O.o(event.msg.mOpcode.toString(16),GameData.instance.playerData.systemTimes);
            }
            if(event.msg.body.bytesAvailable > 0)
            {
               GameData.instance.playerData.onlineTime = event.msg.body.readInt();
            }
            dispatch(EventConst.PLAYERSTATUSCHANGE,{
               "type":param,
               "statetime":statetime
            });
            if(GameData.instance.playerData.playerStatus == 1 || GameData.instance.playerData.playerStatus == 3)
            {
               GameData.instance.playerData.doubleExpTimes = int(statetime) / 60;
            }
            dispatch(EventConst.EFFECT_STATEBACK);
         }
      }
      
      private function sendActionBack(evt:MsgEvent) : void
      {
         var params:Object = {};
         if(evt.msg.mParams == 2)
         {
            params.userId = evt.msg.body.readInt();
            params.roleType = evt.msg.body.readInt();
            params.hatId = evt.msg.body.readInt();
            params.clothId = evt.msg.body.readInt();
            params.weaponId = evt.msg.body.readInt();
            params.footId = evt.msg.body.readInt();
            params.faceId = evt.msg.body.readInt();
            params.wingId = evt.msg.body.readInt();
            params.glassId = evt.msg.body.readInt();
            params.leftWeapon = evt.msg.body.readInt();
            params.taozhuangId = evt.msg.body.readInt();
            params.backgroundId = evt.msg.body.readInt();
            dispatch(EventConst.CANCELCHANGEBACK,params);
         }
         else if(evt.msg.mParams == 1)
         {
            params.userid = evt.msg.body.readInt();
            params.actionid = evt.msg.body.readInt();
            params.destx = evt.msg.body.readInt();
            params.desty = evt.msg.body.readInt();
            params.flag = evt.msg.body.readInt();
            if(Boolean(evt.msg.body.bytesAvailable))
            {
               params.destid = evt.msg.body.readInt();
            }
            dispatch(EventConst.SENDACTIONBACK,params);
         }
         else if(evt.msg.mParams < 0)
         {
            AlertManager.instance.showTipAlert({
               "systemid":1002,
               "flag":evt.msg.mParams
            });
         }
      }
      
      private function onBroadCastCome(evt:MsgEvent) : void
      {
         var params:Object = null;
         params = {};
         params.type = evt.msg.mParams;
         try
         {
            params.noticeId = evt.msg.body.readInt();
         }
         catch(e:*)
         {
            params.noticeId = 0;
         }
         dispatch(EventConst.SERVERBROADCAST,params);
      }
      
      private function onAddBlackBack(evt:MsgEvent) : void
      {
         var code:uint = uint(evt.msg.mParams);
         if(code < 0)
         {
            AlertManager.instance.showTipAlert({
               "systemid":1015,
               "flag":code,
               "defaultTip":true
            });
         }
         else
         {
            dispatch(EventConst.MOVETOBLACKBACK,evt.msg.mParams);
         }
      }
      
      private function onDeleteBlackBack(evt:MsgEvent) : void
      {
         if(evt.msg.mParams == -1)
         {
            new Alert().show("删除黑名单失败");
         }
         else
         {
            dispatch(EventConst.DELETBLACKBACK,evt.msg.mParams);
         }
      }
      
      private function onShowAlertHandler(event:MsgEvent) : void
      {
         var arr:Array = null;
         var i:int = 0;
         O.traceSocket(event);
         var params:Object = {};
         params.type = event.msg.mParams;
         params.contant = event.msg.body.readInt();
         switch(params.type)
         {
            case 2:
               params.username = event.msg.body.readUTF();
               break;
            case 5:
               params.level = event.msg.body.readInt();
               break;
            case 10:
               if(event.msg.body.bytesAvailable > 3)
               {
                  params.itemid = event.msg.body.readInt();
               }
               break;
            case 11:
               arr = new BobAwardParse().parsefloat(event.msg);
               dispatch(EventConst.ADD_FLOAT_ARR,arr);
               break;
            case 12:
               params.temp1 = event.msg.body.readInt();
               break;
            case 13:
               for(i = 0; i < params.contant; i++)
               {
                  params["key" + i] = event.msg.body.readInt();
                  if(i + 1 < params.contant)
                  {
                     params["value" + i] = event.msg.body.readInt();
                  }
               }
               break;
            case 15:
               params.itemid = event.msg.body.readInt();
               break;
            case 10000:
               AlertManager.instance.addTipAlert({
                  "tip":"系统检测到您的IP地址登陆账号异常，请不要使用第三方非法工具异常登陆，导致账号封禁！",
                  "type":2
               });
               return;
            case 10001:
               AlertManager.instance.addTipAlert({
                  "tip":event.msg.body.readUTF(),
                  "type":params.contant
               });
               return;
         }
         switch(params.contant)
         {
            case 49:
               if(params.itemid == 0)
               {
                  params.itemid = event.msg.body.readInt();
               }
               break;
            case 105:
            case 106:
               params.ttype = event.msg.body.readInt();
               params.id = event.msg.body.readInt();
               params.itemid = params.iid = event.msg.body.readInt();
               params.expiretime = event.msg.body.readInt();
               break;
            case 187:
            case 188:
            case 192:
               params.itemid = event.msg.body.readInt();
         }
         if(params.type != 11)
         {
            dispatch(EventConst.ONSHOWALERT,params);
         }
      }
      
      private function onChangeDressBack(event:MsgEvent) : void
      {
         var params:Object = {};
         params.userId = event.msg.body.readInt();
         params.hatId = event.msg.body.readInt();
         params.clothId = event.msg.body.readInt();
         params.weaponId = event.msg.body.readInt();
         params.footId = event.msg.body.readInt();
         params.faceId = event.msg.body.readInt();
         params.wingId = event.msg.body.readInt();
         params.glassId = event.msg.body.readInt();
         params.leftWeapon = event.msg.body.readInt();
         params.taozhuangId = event.msg.body.readInt();
         params.backgroundId = event.msg.body.readInt();
         dispatch(EventConst.DRESSCHANGEBACK,params);
         if(params.userId == GameData.instance.playerData.userId)
         {
            this.updateCollect(params.weaponId,true);
         }
      }
      
      private function updateCollect(weaponId:int, isChange:Boolean = false) : void
      {
         var index:int = 0;
         var param:Object = null;
         var toolxml:XML = null;
         if(Boolean(GameData.instance.playerData.effectList.hasCollectId))
         {
            if(weaponId == 0)
            {
               GameData.instance.playerData.effectList.deleteCollect();
               dispatch(EventConst.EFFECT_SHOW);
               return;
            }
            if(GameData.instance.playerData.effectList.hasCollectId == weaponId)
            {
               return;
            }
         }
         index = int(CommonDefine.collectToolList.indexOf(weaponId));
         if(index >= 0)
         {
            param = {};
            param.itemNum = 1;
            param.type = 0;
            param.itemId = CommonDefine.collectToolList[index];
            param.itemSwitch = 1;
            if(param.itemId != 0 && param.itemNum != 0)
            {
               toolxml = XMLLocator.getInstance().tooldic[param.itemId] as XML;
               if(toolxml == null)
               {
                  param.name = "";
                  param.desc = "";
               }
               else
               {
                  param.name = toolxml.name;
                  param.desc = toolxml.desc;
               }
            }
            GameData.instance.playerData.effectList.updateCollect(param,isChange);
            dispatch(EventConst.EFFECT_SHOW);
         }
      }
      
      private function littleGameOverBack(event:MsgEvent) : void
      {
         var pkresult:int = 0;
         var act_id:int = event.msg.body.readInt();
         var result_id:int = event.msg.body.readInt();
         if(act_id == 3)
         {
            dispatch(EventConst.GETTRANSFERRESULTBACK,{"result":result_id});
         }
         if(act_id == 0 || act_id == 4)
         {
            if(Boolean(event.msg.body.bytesAvailable))
            {
               pkresult = event.msg.body.readInt();
            }
            dispatch(EventConst.LITTLE_GAME_OVER_BACK,{
               "act":act_id,
               "result":result_id,
               "pkr":pkresult
            });
         }
      }
      
      private function onSpritesLibBack(event:MsgEvent) : void
      {
         var count1:int = 0;
         var i:int = 0;
         var obj:Object = null;
         var count2:int = 0;
         var type:int = event.msg.mParams;
         var list11:Array = [];
         var list22:Array = [];
         if(0 == type)
         {
            count1 = event.msg.body.readInt();
            for(i = 0; i < count1; i++)
            {
               obj = {};
               obj.id = event.msg.body.readInt();
               obj.hasHulu = event.msg.body.readInt();
               list11.push(obj);
            }
            count2 = event.msg.body.readInt();
            for(i = 0; i < count2; i++)
            {
               obj = {};
               obj.id = event.msg.body.readInt();
               obj.hasHulu = event.msg.body.readInt();
               list22.push(obj);
            }
         }
         dispatch(EventConst.GETSHOWSPRITESBACK,{
            "list1":list11,
            "list2":list22
         });
      }
      
      private function onGetMonsterInfoBack(event:MsgEvent) : void
      {
         var params:Object = {};
         params.sn = event.msg.body.readInt();
         params.name = event.msg.body.readUTF();
         params.tid = event.msg.body.readInt();
         params.level = event.msg.body.readInt();
         params.type = event.msg.body.readInt();
         params.mold = event.msg.body.readInt();
         params.time = event.msg.body.readInt();
         params.hasSymm = event.msg.body.readInt() > 0 ? true : false;
         params.masterid = event.msg.body.readInt();
         params.masterSex = event.msg.body.readInt();
         params.starCount = event.msg.body.readInt();
         params.master = event.msg.body.readUTF();
         params.showX = 300;
         params.showY = 120;
         dispatch(EventConst.OPEN_CACHE_VIEW,params,null,getQualifiedClassName(MonsterInfoPanel));
      }
      
      private function onTreatManySpiritBack(event:MsgEvent) : void
      {
         if(event.msg.mParams == 1)
         {
            if(!GameData.instance.playerData.isVip)
            {
               GameData.instance.playerData.coin -= 50;
            }
            dispatch(EventConst.TREAT_MANY_SPIRIT_OK);
         }
         AlertManager.instance.showTipAlert({
            "systemid":1073,
            "flag":event.msg.mParams,
            "defaultTip":true
         });
      }
      
      private function onDoctorSpritesBack(event:MsgEvent) : void
      {
         if(event.msg.mParams == 1)
         {
            if(!GameData.instance.playerData.isVip)
            {
               GameData.instance.playerData.coin -= 50;
            }
         }
         AlertManager.instance.showTipAlert({
            "systemid":1016,
            "flag":event.msg.mParams,
            "defaultTip":true
         });
      }
      
      private function onChangeLineBack(evt:MsgEvent) : void
      {
         if(evt.msg.mParams == 1)
         {
            ReConnectStatus.instance.IS_IN_CHANGLINE_STATE = true;
            dispatch(EventConst.REQUESTWORLD_NUM);
         }
         else
         {
            new Alert().show("请求换线失败！");
         }
      }
      
      private function onGetOlineAwardBack(evt:MsgEvent) : void
      {
         var obj:Object = null;
         var view:AwardBox = null;
         var params:Object = {
            "showX":200,
            "showY":0
         };
         params.nextId = evt.msg.mParams;
         var flag:int = evt.msg.body.readInt();
         var list:Array = [];
         while(0 < flag && flag < 4)
         {
            obj = {};
            obj.type = flag;
            if(1 == flag || 2 == flag)
            {
               obj.award = evt.msg.body.readInt();
            }
            else if(3 == flag)
            {
               obj.award = evt.msg.body.readInt();
               obj.count = evt.msg.body.readInt();
            }
            list.push(obj);
            flag = evt.msg.body.readInt();
         }
         params.awards = list;
         if(-1 == flag)
         {
            dispatch(EventConst.OPEN_CACHE_VIEW,params,null,getQualifiedClassName(OnlineAwardView));
            view = CacheUtil.pool[AwardBox];
            if(Boolean(view))
            {
               view.onGetAwardBack();
            }
         }
      }
      
      private function onMonsterCheckBack(event:MsgEvent) : void
      {
         if(event.msg.mParams == 0)
         {
            dispatch(EventConst.HAVEMONEYTOCHECK,event.msg.mParams);
         }
      }
      
      private function onWakeUpSkill(event:MsgEvent) : void
      {
         GameData.instance.playerData.coin -= 50;
      }
      
      private function onGetToolDetailBack(evt:MsgEvent) : void
      {
         var study:Array = null;
         var danfangId:int = 0;
         var list:Array = null;
         var iid:int = 0;
         var counts:int = 0;
         var obj:Object = null;
         evt.stopImmediatePropagation();
         var params:Object = {};
         var id:int = -1;
         if(evt.msg.mParams == 1)
         {
            params.level = evt.msg.body.readInt();
            params.skillexp = evt.msg.body.readInt();
            params.power = evt.msg.body.readInt();
            study = [];
            do
            {
               id = evt.msg.body.readInt();
               if(id != 0)
               {
                  study.push(id);
               }
            }
            while(id != 0);
            
            params.study = study;
            this.dispatch(EventConst.GETREFINELEVEL,params);
         }
         else if(evt.msg.mParams == 2)
         {
            params.times = evt.msg.body.readInt();
            this.dispatch(EventConst.GETHECHENGTIMES,params);
         }
         else if(evt.msg.mParams == 3)
         {
            danfangId = evt.msg.body.readInt();
            list = [];
            do
            {
               iid = evt.msg.body.readInt();
               if(iid != 0)
               {
                  counts = evt.msg.body.readInt();
                  obj = {};
                  obj.iid = iid;
                  obj.counts = counts;
                  list.push(obj);
               }
            }
            while(iid != 0);
            
            dispatch(EventConst.ALCHEMY_GET_NEEDS_BY_ID,{
               "id":danfangId,
               "list":list
            });
         }
      }
      
      private function onStartRefineBack(evt:MsgEvent) : void
      {
         var params:Object = null;
         var url:String = null;
         var msg:String = null;
         evt.stopImmediatePropagation();
         if(evt.msg.mParams == -1)
         {
            new FloatAlert().show(WindowLayer.instance,350,250,"背包中有太多这种物品了！");
         }
         else
         {
            evt.msg.body.position = 0;
            params = {};
            params.level = evt.msg.body.readInt();
            params.skill = evt.msg.body.readInt();
            params.power = evt.msg.body.readInt();
            this.dispatch(EventConst.GETTOOLBACK,params);
            params.id = evt.msg.body.readInt();
            params.number = evt.msg.body.readInt();
            url = URLUtil.getSvnVer("assets/tool/" + params.id + ".swf");
            try
            {
               params.name = String(XMLLocator.getInstance().getTool(params.id).name);
            }
            catch(e:*)
            {
               params.name = "";
            }
            msg = "恭喜你，本次炼丹获得" + HtmlUtil.getHtmlText(12,"#FF0000",params.number + "个" + params.name);
            new AwardAlert().showGoodsAward(url,WindowLayer.instance,msg,true,null,params.id);
         }
      }
      
      private function onStartRefineFarmBack(evt:MsgEvent) : void
      {
         var params:Object = null;
         var url:String = null;
         var msg:String = null;
         evt.stopImmediatePropagation();
         if(evt.msg.mParams == -1)
         {
            new FloatAlert().show(WindowLayer.instance,350,250,"背包中有太多这种物品了！");
         }
         else
         {
            evt.msg.body.position = 0;
            params = {};
            params.level = evt.msg.body.readInt();
            params.skill = evt.msg.body.readInt();
            params.power = evt.msg.body.readInt();
            this.dispatch(EventConst.GETTOOLBACK,params);
            params.id = evt.msg.body.readInt();
            params.number = evt.msg.body.readInt();
            params.name = "神奇营养化肥";
            url = URLUtil.getSvnVer("assets/farm/seed/" + params.id + ".swf");
            O.o("炼丹获得：",params.id,params.name);
            msg = "恭喜你，本次炼丹获得" + HtmlUtil.getHtmlText(12,"#FF0000",params.number + "个" + params.name);
            new AwardAlert().showGoodsAward(url,WindowLayer.instance,msg,true);
         }
      }
      
      private function onMakeAWishBack(event:MsgEvent) : void
      {
         dispatch(EventConst.MAKEAWISHBACK,event.msg.mParams);
      }
      
      private function onWishReportBack(event:MsgEvent) : void
      {
         dispatch(EventConst.WISHREPORTBACK,event.msg.mParams);
      }
      
      private function onDuihuanBack(event:MsgEvent) : void
      {
      }
      
      private function onGetHardWorkAward(evt:MsgEvent) : void
      {
         var hist:int = 0;
         var i:int = 0;
         var len:int = 0;
         var cur:int = 0;
         var diffLevel:int = 0;
         var param:Object = {};
         param.type = evt.msg.mParams;
         if(param.type == 1)
         {
            param.list = [];
            hist = evt.msg.body.readInt();
            i = 0;
            len = 8;
            for(i = 0; i < len; i++)
            {
               param.list.push((hist & 1 << i) >> i);
            }
            param.maxLevel = evt.msg.body.readInt();
            CacheData.instance.kabuOnline.setLevelData(param);
         }
         if(param.type == 2)
         {
            param.result = evt.msg.body.readInt();
            param.awardID = evt.msg.body.readInt();
            if(param.result == 1)
            {
               CacheData.instance.kabuOnline.updateLevel(param.awardID,1);
            }
            else if(param.result == -1)
            {
               CacheData.instance.kabuOnline.updateLevel(param.awardID,0);
               diffLevel = evt.msg.body.readInt();
               new Alert().show("你的妖怪的等级还不能够领取这个奖励哦！只差" + diffLevel + "级了哦！加油吧！~");
            }
            else if(param.result == -2)
            {
               new Alert().show("已经领取过了！");
               CacheData.instance.kabuOnline.updateLevel(param.awardID,1);
            }
         }
      }
      
      private function onMagicLearn(evt:MsgEvent) : void
      {
         var param:Object = {};
         param.flag = evt.msg.mParams;
         param.id = evt.msg.body.readInt();
         param.money = evt.msg.body.readInt();
         this.dispatch(EventConst.MAGICLEARNBACK,param);
      }
      
      private function onSellBack(evt:MsgEvent) : void
      {
         var param:int = evt.msg.mParams;
         this.dispatch(EventConst.RUBBISHBACK,{"param":param});
      }
      
      private function onServContNPCBack(evt:MsgEvent) : void
      {
         var obj:Object = {};
         obj.type = 1;
         obj.ballid = evt.msg.mParams;
         obj.playerid = evt.msg.body.readInt();
         this.dispatch(EventConst.OP_THE_BALLON_ACTIVE,obj);
      }
      
      private function onBroadCastActiveEnd(evt:MsgEvent) : void
      {
         var obj:Object = {};
         obj.type = 2;
         this.dispatch(EventConst.OP_THE_BALLON_ACTIVE,obj);
      }
      
      private function onBroadCastActiveStart(evt:MsgEvent) : void
      {
         var item:Object = null;
         var obj:Object = {};
         obj.type = 3;
         obj.sceneId = evt.msg.body.readInt();
         obj.balllist = [];
         while(evt.msg.body.bytesAvailable > 0)
         {
            item = {};
            item.ballid = evt.msg.body.readInt();
            if(item.ballid == 0)
            {
               break;
            }
            item.posx = evt.msg.body.readInt();
            item.posy = evt.msg.body.readInt();
            obj.balllist.push(item);
         }
         this.dispatch(EventConst.OP_THE_BALLON_ACTIVE,obj);
      }
      
      private function onActiveAwardBack(evt:MsgEvent) : void
      {
         var obj:Object = {};
         obj.type = evt.msg.mParams;
         if(obj.type == 0)
         {
            obj.awardA = obj.awardB = obj.awardC = evt.msg.body.readInt();
            if(obj.awardA < 10000)
            {
               GameData.instance.playerData.coin += 2000;
            }
         }
         else if(obj.type != -1)
         {
            obj.awardA = evt.msg.body.readInt();
            obj.awardB = evt.msg.body.readInt();
            obj.awardC = evt.msg.body.readInt();
            if(obj.type == 1)
            {
               if(obj.awardA == obj.awardB && obj.awardB == obj.awardC)
               {
                  if(obj.awardC == 1)
                  {
                     GameData.instance.playerData.coin += 200;
                  }
                  else if(obj.awardC == 2)
                  {
                     GameData.instance.playerData.coin += 2000;
                  }
               }
            }
         }
         this.dispatch(EventConst.OP_THE_BALLON_ACTIVE_AWARD,obj);
      }
      
      private function onMenologyBack(evt:MsgEvent) : void
      {
         var flag:int = evt.msg.mParams;
         var obj:Object = {};
         switch(flag)
         {
            case 1:
               obj.result = evt.msg.body.readInt();
               break;
            case 2:
               obj.level = evt.msg.body.readInt();
               obj.flag = evt.msg.body.readInt();
               break;
            case 3:
               obj.istime = evt.msg.body.readInt();
               obj.present = evt.msg.body.readInt();
               break;
            case 4:
               obj.result = evt.msg.body.readInt();
               obj.present = evt.msg.body.readInt();
         }
         obj.params = flag;
         this.dispatch(EventConst.MENOLOGYBACK,obj);
      }
      
      private function onJialilian(evt:MsgEvent) : void
      {
         var result:int = 0;
         var reward:int = 0;
         var msg:String = null;
         var flag:int = evt.msg.mParams;
         if(flag == 1)
         {
            AlertManager.instance.showAwardAlert({"exp":3000});
         }
         else if(flag == 0)
         {
            this.dispatch(EventConst.JIALILIAN);
         }
         else if(flag == 2)
         {
            result = evt.msg.body.readInt();
            reward = evt.msg.body.readInt();
            msg = "";
            switch(result)
            {
               case 0:
                  if(reward == 0)
                  {
                     AlertManager.instance.showAwardAlert({"exp":8000});
                  }
                  else if(reward == 1)
                  {
                     AlertManager.instance.showAwardAlert({"toolid":100078});
                  }
                  else if(reward == 2)
                  {
                     AlertManager.instance.showAwardAlert({"money":1500});
                  }
                  else if(reward == 3)
                  {
                     AlertManager.instance.showAwardAlert({"toolid":100013});
                  }
            }
            AlertManager.instance.showTipAlert({
               "systemid":1025,
               "flag":result
            });
         }
      }
      
      private function onGetPassExpBack(evt:MsgEvent) : void
      {
         if(evt.msg.mParams >= 0)
         {
            dispatch(EventConst.OPEN_CACHE_VIEW,{
               "exp":evt.msg.mParams,
               "showX":0,
               "showY":0
            },null,getQualifiedClassName(PassAlert));
         }
      }
      
      private function onPassTrainBack(evt:MsgEvent) : void
      {
         var param:Object = {};
         param.systemid = 1018;
         if(evt.msg.mParams == 1)
         {
            param.flag = 1;
            param.params = evt.msg.body.readInt();
            AlertManager.instance.showTipAlert(param);
         }
         else if(evt.msg.mParams == 2)
         {
            param.id = evt.msg.body.readInt();
            param.flag = evt.msg.body.readInt();
            if(param.flag == 1)
            {
               param.showX = 0;
               param.showY = 0;
               dispatch(EventConst.OPEN_CACHE_VIEW,param,null,getQualifiedClassName(KB_Class_Train));
            }
         }
         else if(evt.msg.mParams == 3)
         {
            param.id = evt.msg.body.readInt();
            param.flag = evt.msg.body.readInt();
            if(param.flag == 1)
            {
               AlertManager.instance.showAwardAlert({
                  "toolid":param.id,
                  "name":"灯笼"
               });
            }
            else
            {
               param.flag = 3;
               AlertManager.instance.showTipAlert(param);
            }
         }
         else if(evt.msg.mParams != 4)
         {
            if(evt.msg.mParams == 5 || evt.msg.mParams == 6)
            {
               param.type = evt.msg.mParams;
               if(evt.msg.mParams == 6)
               {
                  param.flag = evt.msg.body.readInt();
                  param.count = evt.msg.body.readInt();
               }
               else
               {
                  param.index = evt.msg.body.readInt();
                  param.flag = evt.msg.body.readInt();
                  param.currentstep = evt.msg.body.readInt();
                  param.award = evt.msg.body.readInt();
                  param.study = evt.msg.body.readInt();
               }
               new Message("fightbosss2c",param).sendToChannel("datatrans");
            }
            else if(evt.msg.mParams == 8)
            {
               param.type = evt.msg.body.readInt();
               if(param.type >= 1)
               {
                  GameData.instance.playerData.ernieNum = param.type;
                  this.dispatch(EventConst.OPENSWFWINDOWS,{
                     "url":"assets/material/ballonball.swf",
                     "xCoord":0,
                     "yCoord":0
                  });
               }
               else
               {
                  param.flag = 8;
                  AlertManager.instance.showTipAlert(param);
               }
            }
         }
      }
      
      private function onAchievementBack(evt:MsgEvent) : void
      {
         var param:int = evt.msg.mParams;
         if(param == -1)
         {
            new Alert().show("亲，对方不在线，不能查看对方成就哦~");
            return;
         }
         O.traceSocket(evt);
         this.dispatch(EventConst.ACHIEVEMENT_BACK,{"ba":evt.msg.body});
      }
      
      private function onGetAchieveBack(evt:MsgEvent) : void
      {
         var id:int = evt.msg.mParams;
         dispatch(EventConst.OPEN_EXTRAL_CACHE_VIEW,{
            "id":id,
            "showX":208,
            "showY":232
         },null,getQualifiedClassName(GetAchieve));
      }
      
      private function onBobAwardBack(event:MsgEvent) : void
      {
         new BobAwardParse().parse(event.msg);
      }
      
      private function onScoreExchangeBack(evt:MsgEvent) : void
      {
         this.dispatch(EventConst.SCORE_EXCHANGE_BACK,{"result":int(evt.msg.mParams)});
      }
      
      private function onGetStgcopyScore(evt:MsgEvent) : void
      {
         var data:Object = {};
         data.params = evt.msg.mParams;
         data.id = evt.msg.body.readUnsignedInt();
         data.username = evt.msg.body.readUTF();
         data.title = evt.msg.body.readInt();
         data.total = evt.msg.body.readInt();
         data.now = evt.msg.body.readInt();
         data.exchange = evt.msg.body.readInt();
         if(int(data.params) == 1)
         {
            dispatch(EventConst.OPEN_CACHE_VIEW,{
               "showX":0,
               "showY":0,
               "data":data
            },null,getQualifiedClassName(StgCopyValue));
         }
         else
         {
            dispatch(EventConst.STGCOPYRANK_EXCHANGE_BACK,data);
         }
      }
      
      private function onFamilyBorderBack(evt:MsgEvent) : void
      {
         var obj:Object = {};
         obj.userId = evt.msg.mParams;
         obj.familyName = evt.msg.body.readUTF();
         dispatch(EventConst.CHANGENAMEBORDERBACK,obj);
      }
      
      private function onHomeMessageListen(evt:MsgEvent) : void
      {
         var o:NewsVo = new NewsVo();
         o.alertType = 7;
         o.msg = "你的留言板上有新留言哦，快回去看看吧！";
         o.type = 4;
         GameData.instance.boxMessagesArray.push(o);
         GameData.instance.showMessagesCome();
      }
      
      private function onChangePlayerName(event:MsgEvent) : void
      {
         this.dispatch(EventConst.CHANGEPLAYERNAMEBACK,{"param":event.msg.mParams});
      }
      
      private function onChangeNameBack(event:MsgEvent) : void
      {
         var name:String = event.msg.body.readUTF();
         this.dispatch(EventConst.PLAYERCHANGENAMEBACK,{
            "uid":event.msg.mParams,
            "uname":name
         });
      }
      
      private function onReqPackTokenBack(evt:MsgEvent) : void
      {
         var params:Object = {};
         params.token = evt.msg.body.readInt();
         params.integral = evt.msg.body.readInt();
         dispatch(EventConst.PACK_TOKEN_BACK,params);
      }
      
      private function onWeedkendAwardBack(evt:MsgEvent) : void
      {
         var flag:int = 0;
         var a:int = 0;
         var b:int = 0;
         var c:int = 0;
         var view:WeedkendAward = null;
         if(evt.msg.mParams == 1)
         {
            flag = evt.msg.body.readInt();
            if(flag == 5)
            {
               dispatch(EventConst.OPEN_CACHE_VIEW,{
                  "showX":0,
                  "showY":0
               },null,getQualifiedClassName(WeedkendAward));
            }
            else
            {
               new Alert().showOne("周末大礼包只能在每周的周五、周六和周日领取，每天限领一次哦！");
            }
         }
         else
         {
            a = evt.msg.body.readInt();
            if(a == 4)
            {
               b = evt.msg.body.readInt();
               c = evt.msg.body.readInt();
               view = CacheUtil.pool[WeedkendAward];
               if(Boolean(view))
               {
                  view.getAwardBack(b,c);
               }
            }
         }
      }
      
      private function onSendActionBack(evt:MsgEvent) : void
      {
         var id:int = 0;
         var uid:int = 0;
         var playerId:int = 0;
         var person:GamePerson = null;
         var url:String = null;
         var param:int = evt.msg.mParams;
         if(param == 1)
         {
            id = evt.msg.body.readInt();
            uid = evt.msg.body.readInt();
            this.dispatch(EventConst.PLAYERACTION_BACK,{
               "actionId":id,
               "uid":uid
            });
         }
         else if(param == 2)
         {
            playerId = evt.msg.body.readInt();
            person = MapView.instance.findGameSprite(playerId) as GamePerson;
            if(Boolean(person))
            {
               url = "assets/material/leijishu_dest.swf";
               if(Boolean(person))
               {
                  new SwfAction().loadAndPlay(Sprite(person.ui),url,person.bottomX,person.bottomY,this.yanhuoOk,{"person":person},this.leijishuAction,31);
               }
            }
         }
      }
      
      private function leijishuAction(params:Object) : void
      {
         var person:GamePerson = params.person;
         if(Boolean(person))
         {
            if(Boolean(person.roleFace))
            {
               person.roleFace.removeMouseHandler();
               person.roleFace.filters = [new ColorMatrixFilter([0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0.5,0.5,0.5,0.5,0])];
            }
         }
      }
      
      private function yanhuoOk(params:Object) : void
      {
         var person:GamePerson = params.person;
         if(Boolean(person))
         {
            if(Boolean(person.roleFace))
            {
               person.roleFace.filters = [];
               person.roleFace.addMouseHandler();
            }
         }
      }
      
      private function onGetAnswerAwardBack(evt:MsgEvent) : void
      {
         var params:Object = {};
         params.answerTimes = evt.msg.body.readInt();
         params.answerTime = evt.msg.body.readInt();
         params.answerId = evt.msg.body.readInt();
         var view:AwardBox = CacheUtil.pool[AwardBox];
         if(Boolean(view))
         {
            view.onGetAnswerAwardBack(params);
         }
      }
      
      private function onMaaTaskInviteBack(evt:MsgEvent) : void
      {
         var newMsg:NewsVo = null;
         var params:Object = {};
         params.systemid = 1003;
         if(evt.msg.mParams == 1)
         {
            params.masterId = evt.msg.body.readInt();
            params.masterName = evt.msg.body.readUTF();
            newMsg = new NewsVo();
            newMsg.data = params;
            newMsg.ao = {
               "s":1187322,
               "m":2,
               "l":[params.masterId,1]
            };
            newMsg.ro = {
               "s":1187322,
               "m":2,
               "l":[params.masterId,0]
            };
            newMsg.type = 6;
            newMsg.mytype = 2;
            newMsg.alertType = 1;
            newMsg.msg = "你的师父【" + params.masterName + "】邀请你前往五指山顶进行师徒任务，是否接受？";
            GameData.instance.boxMessagesArray.push(newMsg);
            GameData.instance.showMessagesCome();
         }
         else if(evt.msg.mParams == 2)
         {
            params.errorCode = evt.msg.body.readInt();
            if(params.errorCode == 0)
            {
               params.apprenticeId = evt.msg.body.readInt();
               params.apprenticeName = evt.msg.body.readUTF();
               dispatch("maa_req_task_list");
               params.flag = 2;
               params.params = 1000;
               params.replace = params.apprenticeName;
               AlertManager.instance.showTipAlert(params);
            }
            else if(params.errorCode == 1)
            {
               params.apprenticeId = evt.msg.body.readInt();
               params.apprenticeName = evt.msg.body.readUTF();
               dispatch("maa_req_task_list");
               params.flag = 2;
               params.params = 1;
               params.replace = params.apprenticeName;
               AlertManager.instance.showTipAlert(params);
            }
            else
            {
               params.flag = 2;
               params.params = params.errorCode;
               AlertManager.instance.showTipAlert(params);
            }
         }
         else if(evt.msg.mParams == 3)
         {
            params.flag = evt.msg.body.readInt();
            dispatch("maa_req_task_list");
            params.flag = 3;
            AlertManager.instance.showTipAlert(params);
         }
      }
      
      private function onMaaTaskCancelBack(evt:MsgEvent) : void
      {
         var params:Object = {};
         params.systemid = 1023;
         if(evt.msg.mParams == 1)
         {
            params.masterId = evt.msg.body.readInt();
            params.masterName = evt.msg.body.readUTF();
            dispatch("maa_req_task_list");
            params.flag = 1;
            params.replace = params.masterName;
            AlertManager.instance.showTipAlert(params);
         }
         else if(evt.msg.mParams == 2)
         {
            params.apprenticeId = evt.msg.body.readInt();
            params.apprenticeName = evt.msg.body.readUTF();
            dispatch("maa_req_task_list");
            params.flag = 2;
            params.replace = params.apprenticeName;
            AlertManager.instance.showTipAlert(params);
         }
         else if(evt.msg.mParams == 3)
         {
            params.flag = 3;
            AlertManager.instance.showTipAlert(params);
            dispatch("maa_req_task_list");
         }
      }
      
      private function onMaaTaskActionBack(evt:MsgEvent) : void
      {
         var maataskai:GameSprite = null;
         var action:int = evt.msg.body.readInt();
         if(action == 1)
         {
            MapView.instance.masterPerson.moveto(675,250,this.onArrideHandler);
            dispatch(MapView.ROLEMOVE,{
               "newx":675,
               "newy":250,
               "flag":1
            });
         }
         else
         {
            maataskai = MapView.instance.findGameSprite(20120112);
            if(maataskai != null)
            {
               maataskai.ui["content"]["onActionBack"](action);
            }
         }
      }
      
      private function onArrideHandler() : void
      {
         var maataskai:GameSprite = MapView.instance.findGameSprite(20120112);
         if(maataskai != null)
         {
            maataskai.ui["content"]["onActionBack"](1);
         }
      }
      
      private function onMaaTaskCompleteBack(evt:MsgEvent) : void
      {
         var obj:Object = {};
         obj.systemid = 1019;
         if(evt.msg.mParams == 1)
         {
            obj.flag = 1;
         }
         else
         {
            obj.flag = -1000;
         }
         AlertManager.instance.showTipAlert(obj);
         var maataskai:GameSprite = MapView.instance.findGameSprite(20120112);
         if(maataskai != null)
         {
            maataskai.ui["content"]["onCompleteBack"]();
         }
      }
      
      private function onVipTimeUp(evt:MsgEvent) : void
      {
         GameData.instance.playerData.isVipTimeUp = true;
      }
      
      private function onTeamCopyEnterBack(evt:MsgEvent) : void
      {
         var captainId:int = 0;
         var obj:Object = {};
         var params:int = evt.msg.mParams;
         var flag:int = evt.msg.body.readInt();
         var msg:String = "";
         obj.systemid = 1001;
         switch(flag)
         {
            case 1:
               captainId = evt.msg.body.readInt();
               if(GameData.instance.playerData.userId == captainId)
               {
                  if(params == 23)
                  {
                     ApplicationFacade.getInstance().dispatch(EventConst.CLEARUI);
                     dispatch(EventConst.OPEN_MODULE,{
                        "url":"assets/module/EscortModel/EscortModel.swf",
                        "xCoord":0,
                        "yCoord":0,
                        "params":{"flag":1}
                     });
                  }
                  else
                  {
                     dispatch(EventConst.TEAMCOPY_TELL_CAPTAIN_OPEN);
                  }
               }
               else
               {
                  if(GameData.instance.playerData.isAutoBattle)
                  {
                     obj.flag = flag;
                     AlertManager.instance.showTipAlert(obj);
                     return;
                  }
                  switch(params)
                  {
                     case 4:
                        dispatch(EventConst.OPEN_MODULE,{
                           "url":"assets/module/TeamCopy.swf",
                           "xCoord":0,
                           "yCoord":0,
                           "params":{"flag":1}
                        });
                        break;
                     case 9:
                        ApplicationFacade.getInstance().dispatch(EventConst.CLEARUI);
                        dispatch(EventConst.OPEN_MODULE,{
                           "url":"assets/module/TeamCopy9005.swf",
                           "xCoord":0,
                           "yCoord":0,
                           "params":{"flag":1}
                        });
                        break;
                     case 23:
                        ApplicationFacade.getInstance().dispatch(EventConst.CLEARUI);
                        dispatch(EventConst.OPEN_MODULE,{
                           "url":"assets/module/EscortModel/EscortModel.swf",
                           "xCoord":0,
                           "yCoord":0,
                           "params":{"flag":1}
                        });
                  }
               }
               break;
            default:
               obj.flag = flag;
               if(obj.flag == -3 || obj.flag == -4)
               {
                  obj.params = params;
               }
               else
               {
                  obj.params = 0;
               }
               AlertManager.instance.showTipAlert(obj);
         }
      }
      
      private function onPresuresBack(evt:MsgEvent) : void
      {
         var skillCount:int = 0;
         var j:int = 0;
         var skillId:int = 0;
         var count:int = evt.msg.mParams;
         var preList:Array = [];
         var obj:Object = {};
         GameData.instance.playerData.presuresArr.length = 0;
         for(var i:int = 0; i < count; i++)
         {
            obj = {};
            obj.eggId = evt.msg.body.readInt();
            obj.eggIid = evt.msg.body.readInt();
            obj.bornTime = evt.msg.body.readInt();
            obj.needTime = evt.msg.body.readInt();
            obj.eggType = evt.msg.body.readInt();
            obj.character = evt.msg.body.readInt();
            obj.skillList = [];
            skillCount = evt.msg.body.readInt();
            for(j = 0; j < skillCount; j++)
            {
               skillId = evt.msg.body.readInt();
               obj.skillList.push(skillId);
            }
            obj.type = int(60 + obj.eggType);
            preList.push(obj);
            preList.sortOn("bornTime");
         }
         GameData.instance.playerData.presuresArr = preList.reverse();
         PropertyPool.instance.getXML("config/","spirit_egg",this.loadEggCfgBack);
      }
      
      private function loadEggCfgBack(... args) : void
      {
         var list:Array = GameData.instance.playerData.presuresArr;
         dispatch(EventConst.GET_PRESURES_BACK);
      }
      
      private function onSendSpiritBack(evt:MsgEvent) : void
      {
         var count:int = 0;
         var time:int = 0;
         var urlvar:URLVariables = null;
         var params:Object = {};
         params.systemid = 1020;
         params.flag = evt.msg.mParams;
         O.traceSocket(evt,"",0,3,"iis");
         if(params.flag == 0)
         {
            count = evt.msg.body.readInt();
            if(count == 1)
            {
               params.params = 1;
            }
            if(count <= 3)
            {
               params.params = 3;
            }
            else
            {
               params.params = -1000;
            }
            dispatch(EventConst.REQ_SEND_SPIRIT_BACK,params);
         }
         else if(params.flag == 1)
         {
            params.friendId = evt.msg.body.readInt();
            params.eggIid = evt.msg.body.readInt();
            params.friendName = evt.msg.body.readUTF();
            params.eggName = String(XMLLocator.getInstance().getSprited(params.eggIid).name);
            params.replace = params.friendName;
            params.replaceNum = params.eggName;
            AlertManager.instance.showTipAlert(params);
            time = new Date().getTime();
            urlvar = new URLVariables();
            urlvar.uid = params.friendId;
            urlvar.uname = params.friendName;
            urlvar.getUid = GameData.instance.playerData.userId;
            urlvar.getUname = GameData.instance.playerData.userName;
            urlvar.spiritId = params.eggIid;
            urlvar.spiritName = params.eggName;
            urlvar.token = MD5.hash(urlvar.uid + "my4399" + time);
            urlvar.time = time;
            PhpConnection.instance().getdata("trainspirit/send_spirit.php",urlvar);
         }
         else
         {
            AlertManager.instance.showTipAlert(params);
         }
      }
      
      private function onTeamCopyControlBack(evt:MsgEvent) : void
      {
         var flag:int = 0;
         var va:URLVariables = null;
         var mytime:int = 0;
         var params:int = evt.msg.mParams;
         if(GameData.instance.playerData.copyScene == 0)
         {
            flag = evt.msg.body.readInt();
            evt.msg.body.position = 0;
            if(flag == 8)
            {
               switch(params)
               {
                  case 4:
                     this.dispatch(EventConst.OPEN_MODULE,{
                        "url":"assets/module/TeamCopy.swf",
                        "xCoord":0,
                        "yCoord":0,
                        "params":{"flag":2}
                     });
                     break;
                  case 9:
                     va = new URLVariables();
                     va.uid = GameData.instance.playerData.userId;
                     va.ex_name = "seventree";
                     va.type = 3;
                     mytime = new Date().time;
                     va.mtime = mytime;
                     va.token = GameData.instance.playerData.userId & 4294901760 + mytime & 0xFFFF;
                     va.token *= mytime & 0x0FFF;
                     new PhpInterFace().getData(GlobalConfig.phpserver + "gamelog/feedback.php",va);
               }
            }
            else if(flag == 6)
            {
               switch(params)
               {
                  case 23:
                     if(!CacheData.instance.isEscortModelOpen)
                     {
                        ApplicationFacade.getInstance().dispatch(EventConst.CLEARUI);
                        dispatch(EventConst.OPEN_MODULE,{
                           "url":"assets/module/EscortModel/EscortModel.swf",
                           "xCoord":0,
                           "yCoord":0,
                           "params":{"flag":2}
                        });
                     }
               }
            }
         }
      }
      
      private function onSpiritEquipAllBack(evt:MsgEvent) : void
      {
         O.traceSocket(evt);
         evt.msg.body.position = 0;
         var backFlag:int = evt.msg.body.readInt();
         var list:Array = [];
         if(backFlag == 1)
         {
            list = list.concat(this.readBytesSymm(evt.msg.body));
            list = list.concat(this.readBytesSymm(evt.msg.body));
         }
         else if(backFlag == 2)
         {
            list = list.concat(this.readBytesSymm(evt.msg.body));
         }
         else if(backFlag == 3)
         {
            list = list.concat(this.readBytesSymm(evt.msg.body));
         }
         else if(backFlag == 4)
         {
            new FloatAlert().show(WindowLayer.instance,350,250,"请求出错了");
            return;
         }
         dispatch(EventConst.SYMM_PAKAGE_LIST_BACK,{
            "type":backFlag,
            "list":list
         });
      }
      
      private function readBytesSymm(data:ByteArray) : Array
      {
         var symmObj:Object = null;
         var nativeLength:int = 0;
         var nativeList:Array = null;
         var j:int = 0;
         var nativeObj:Object = null;
         var list:Array = [];
         var length:int = data.readInt();
         for(var i:int = 0; i < length; i++)
         {
            symmObj = {};
            symmObj.symmId = data.readInt();
            symmObj.symmIndex = data.readInt();
            symmObj.symmFlag = data.readInt();
            symmObj.petName = data.readUTF();
            symmObj.symmType = data.readInt();
            symmObj.sortValue = int(XMLLocator.getInstance().getTool(symmObj.symmId).sortValue);
            nativeLength = data.readInt();
            nativeList = [];
            for(j = 0; j < nativeLength; j++)
            {
               nativeObj = {};
               nativeObj.nativeEnum = data.readInt();
               nativeObj.nativeValue = data.readInt();
               nativeObj.nativeName = SymmEnum.getName(nativeObj.nativeEnum);
               nativeList.push(nativeObj);
            }
            symmObj.nativeList = nativeList;
            list.push(symmObj);
         }
         return list;
      }
      
      private function onSpiriteEquipInfoBack(evt:MsgEvent) : void
      {
         O.traceSocket(evt);
         evt.msg.body.position = 0;
         var list:Array = this.readBytesSymm(evt.msg.body);
         dispatch(EventConst.SYMM_SINGLE_LIST_BACK,list);
      }
      
      private function onSpiritEquipWearBack(evt:MsgEvent) : void
      {
         var data:Object = null;
         evt.msg.body.position = 0;
         var flag:int = evt.msg.body.readInt();
         if(flag == 0)
         {
            data = {};
            data.id = evt.msg.mParams;
            data.newSymm = evt.msg.body.readInt();
            data.oldSymm = evt.msg.body.readInt();
            dispatch(EventConst.SYMM_WEAR_BACK,data);
         }
      }
      
      private function onSpiritTakoffBack(evt:MsgEvent) : void
      {
         var data:Object = null;
         evt.msg.body.position = 0;
         var flag:int = evt.msg.body.readInt();
         if(flag == 0)
         {
            data = {};
            data.id = evt.msg.mParams;
            data.oldSymm = evt.msg.body.readInt();
            dispatch(EventConst.SYMM_TAKEOFF_BACK,data);
         }
         else
         {
            AlertManager.instance.showTipAlert({
               "systemid":1021,
               "flag":flag
            });
         }
      }
      
      private function onServerStopHandler(e:MsgEvent) : void
      {
         O.traceSocket(e);
         if(e.msg.body == null)
         {
            return;
         }
         var data:Object = {};
         data.uid = e.msg.mParams;
         data.type = e.msg.body.readInt();
         dispatch(EventConst.TEMLEAVE_VISIBLE,data);
      }
      
      private function onClientEffectBack(e:MsgEvent) : void
      {
         var counts:int = 0;
         var i:int = 0;
         var param:Object = null;
         var toolxml:XML = null;
         var buffReturn:int = 0;
         var state:int = e.msg.mParams;
         if(state == 1)
         {
            counts = e.msg.body.readInt();
            if(GameData.instance.playerData.effectList == null)
            {
               GameData.instance.playerData.effectList = new EffectListVo();
            }
            else
            {
               GameData.instance.playerData.effectList.clear();
            }
            for(i = 0; i < counts; i++)
            {
               param = {};
               param.type = e.msg.body.readInt();
               param.itemId = e.msg.body.readInt();
               param.itemNum = e.msg.body.readInt();
               param.itemSwitch = e.msg.body.readInt();
               if(param.itemId != 0 && param.itemNum != 0)
               {
                  toolxml = XMLLocator.getInstance().tooldic[param.itemId] as XML;
                  if(toolxml == null)
                  {
                     param.name = "";
                     param.desc = "";
                  }
                  else
                  {
                     param.name = toolxml.name;
                     param.desc = toolxml.desc;
                  }
                  GameData.instance.playerData.effectList.insertEffect(param);
               }
            }
            GameData.instance.playerData.effectList.setLenth();
            con.sendCmd(MsgDoc.OP_CLIENT_ACTIVITY_QINGYANG.send,224,[2]);
         }
         else if(state == 2)
         {
            buffReturn = e.msg.body.readInt();
            trace("异常状态",buffReturn);
            if(buffReturn != 0)
            {
               new FloatAlert().show(WindowLayer.instance.stage,350,250,"状态异常" + buffReturn);
            }
         }
      }
      
      private function onKBCoinInfoBack(evt:MsgEvent) : void
      {
         var params:Object = {};
         evt.msg.body.position = 0;
         params.result = evt.msg.body.readInt();
         params.desc = evt.msg.body.readUTF();
         params.uid = evt.msg.body.readInt();
         params.iCoin = evt.msg.body.readInt();
         params.iLastchargingtime = evt.msg.body.readInt();
         params.iLastconsumetime = evt.msg.body.readInt();
         if(params.result == 1 && params.uid == GameData.instance.playerData.userId)
         {
            GameData.instance.playerData.vipCoin = params.iCoin;
         }
      }
      
      private function onChangeFaceEyeBack(evt:MsgEvent) : void
      {
         var params:Object = {};
         evt.msg.body.position = 0;
         params.code = evt.msg.mParams;
         params.result = evt.msg.body.readInt();
         if(params.result == 1)
         {
            params.faceId = evt.msg.body.readInt();
            params.uid = evt.msg.body.readInt();
         }
         dispatch(EventConst.CHANG_FACE_EYE_BACK,params);
      }
      
      private function onPackLimitsList(evt:MsgEvent) : void
      {
         var toolxml:XML = null;
         var params:Object = {};
         params.type = evt.msg.body.readInt();
         params.num = evt.msg.body.readInt();
         params.list = [];
         var obj:Object = {};
         for(var i:int = 0; i < params.num; i++)
         {
            obj = {};
            obj.iid = evt.msg.body.readInt();
            if(obj.iid != 0)
            {
               obj.sn = evt.msg.body.readInt();
               obj.expiretime = evt.msg.body.readInt();
               obj.renewcnt = evt.msg.body.readInt();
               obj.invalidtime = evt.msg.body.readInt();
               obj.systemtime = evt.msg.body.readInt();
               obj.ttype = params.type;
               if(obj.ttype == 430)
               {
                  obj.packid = ItemType.zuoqiType;
                  obj.id = obj.sn;
               }
               params.list.push(obj);
            }
         }
         params.type = evt.msg.body.readInt();
         params.num = evt.msg.body.readInt();
         for(i = 0; i < params.num; i++)
         {
            obj = {};
            obj.iid = evt.msg.body.readInt();
            if(obj.iid != 0)
            {
               obj.sn = evt.msg.body.readInt();
               obj.expiretime = evt.msg.body.readInt();
               obj.renewcnt = evt.msg.body.readInt();
               obj.invalidtime = evt.msg.body.readInt();
               obj.systemtime = evt.msg.body.readInt();
               obj.ttype = params.type;
               params.list.push(obj);
            }
         }
         params.type = evt.msg.body.readInt();
         params.num = evt.msg.body.readInt();
         for(i = 0; i < params.num; i++)
         {
            obj = {};
            obj.iid = evt.msg.body.readInt();
            if(obj.iid != 0)
            {
               obj.count = evt.msg.body.readInt();
               obj.expiretime = evt.msg.body.readInt();
               obj.ttype = params.type;
               if(obj.ttype == 450)
               {
                  obj.packid = ItemType.toolType;
                  obj.id = obj.iid;
                  toolxml = XMLLocator.getInstance().tooldic[obj.iid];
                  if(toolxml != null)
                  {
                     obj.usableStatus = int(toolxml.useState);
                  }
               }
               params.list.push(obj);
            }
         }
         dispatch(EventConst.GETLIMITSBACK,params);
      }
      
      private function onPackLimitsRenew(evt:MsgEvent) : void
      {
         var params:Object = null;
         if(evt.msg.mParams == 3)
         {
            params = {};
            params.ttype = evt.msg.body.readInt();
            params.sn = evt.msg.body.readInt();
            params.iid = evt.msg.body.readInt();
            params.renewday = evt.msg.body.readInt();
            params.kbcoin = evt.msg.body.readInt();
            GameData.instance.playerData.vipCoin -= params.kbcoin;
            dispatch(EventConst.RENEWLIMITSBACK,params);
            new Alert().showOne("恭喜你，续期成功。");
         }
         else if(evt.msg.mParams == 2)
         {
            trace("该物品已经过期了~");
         }
         else
         {
            AlertManager.instance.showTipAlert({
               "systemid":1010,
               "flag":evt.msg.mParams
            });
         }
      }
      
      private function onMallActivityBack(evt:MsgEvent) : void
      {
         var params:Object = null;
         params = {};
         params.result = evt.msg.mParams;
         params.flag = evt.msg.body.readShort();
         if(params.flag == 0)
         {
            params.time = evt.msg.body.readInt();
            params.step = evt.msg.body.readInt();
            params.times = evt.msg.body.readShort();
            GameData.instance.playerData.firstMallFlag = params.times;
            this.mallStep = params.step;
            FaceView.clip.bottomClip.onMallActivityBack(params);
         }
         else if(params.flag == 1)
         {
            params.short0 = evt.msg.body.readShort();
            params.idx1 = evt.msg.body.readShort();
            params.idx2 = evt.msg.body.readShort();
         }
         else if(params.flag == 2)
         {
            params.short1 = evt.msg.body.readShort();
            params.id = evt.msg.body.readInt();
            params.num = evt.msg.body.readInt();
            params.step = this.mallStep;
         }
         dispatch("onMallActivityBack",params);
      }
      
      private function onReqInfoListBack(e:MsgEvent) : void
      {
         var monsterVo:MonsterVo = null;
         e.stopImmediatePropagation();
         monsterVo = new MonsterVo();
         monsterVo.id = e.msg.body.readInt();
         monsterVo.iid = e.msg.body.readInt();
         monsterVo.level = e.msg.body.readInt();
         monsterVo.exp = e.msg.body.readInt();
         monsterVo.mold = e.msg.body.readInt();
         monsterVo.timetxt = e.msg.body.readInt();
         monsterVo.attack = e.msg.body.readInt();
         monsterVo.defence = e.msg.body.readInt();
         monsterVo.magic = e.msg.body.readInt();
         monsterVo.resistance = e.msg.body.readInt();
         monsterVo.strength = e.msg.body.readInt();
         monsterVo.speed = e.msg.body.readInt();
         monsterVo.type = e.msg.body.readInt();
         monsterVo.sex = e.msg.body.readInt();
         monsterVo.needExp = e.msg.body.readInt();
         monsterVo.attackLearnValue = e.msg.body.readInt();
         monsterVo.defenceLearnValue = e.msg.body.readInt();
         monsterVo.magicLearnValue = e.msg.body.readInt();
         monsterVo.resistanceLearnValue = e.msg.body.readInt();
         monsterVo.hpLearnValue = e.msg.body.readInt();
         monsterVo.speedLearnVale = e.msg.body.readInt();
         monsterVo.attackGeniusValue = e.msg.body.readInt();
         monsterVo.defenceGeniusValue = e.msg.body.readInt();
         monsterVo.magicGeniusValue = e.msg.body.readInt();
         monsterVo.resistanceGeniusValue = e.msg.body.readInt();
         monsterVo.hpGeniusValue = e.msg.body.readInt();
         monsterVo.speedGeniusValue = e.msg.body.readInt();
         monsterVo.hasSymm = e.msg.body.readInt() > 0 ? true : false;
         dispatch(EventConst.S_RESPONSE_MONSTER_INFO,monsterVo);
      }
      
      private function onReqSkillListBack(e:MsgEvent) : void
      {
         var skillVo:Object = null;
         var learnSkills:Array = null;
         var unlearnSkills:Array = null;
         var counts:int = 0;
         var skillId:int = 0;
         var tempList:Array = null;
         var monsterSkillVo:MonsterSkillVo = null;
         var i:int = 0;
         e.stopImmediatePropagation();
         skillVo = {};
         learnSkills = [];
         unlearnSkills = [];
         counts = e.msg.body.readInt();
         tempList = [];
         for(i = 0; i < counts; i++)
         {
            monsterSkillVo = new MonsterSkillVo();
            monsterSkillVo.id = e.msg.body.readInt();
            tempList.push(monsterSkillVo.id);
            monsterSkillVo.skillNum = e.msg.body.readInt();
            monsterSkillVo.skillMaxNum = e.msg.body.readInt();
            learnSkills.push(monsterSkillVo);
         }
         skillId = e.msg.body.readInt();
         while(skillId != 0)
         {
            if(tempList.indexOf(skillId) == -1)
            {
               monsterSkillVo = new MonsterSkillVo();
               monsterSkillVo.id = skillId;
               unlearnSkills.push(monsterSkillVo);
            }
            skillId = e.msg.body.readInt();
         }
         skillVo.unLearnLength = e.msg.body.readInt();
         skillId = e.msg.body.readInt();
         while(skillId != -1 && skillId != 0)
         {
            if(tempList.indexOf(skillId) == -1)
            {
               monsterSkillVo = new MonsterSkillVo();
               monsterSkillVo.id = skillId;
               unlearnSkills.push(monsterSkillVo);
            }
            skillId = e.msg.body.readInt();
         }
         skillId = e.msg.body.readInt();
         if(skillId == -1)
         {
            trace(e.msg.body.readInt());
         }
         while(skillId != -1 && skillId != 0)
         {
            if(tempList.indexOf(skillId) == -1)
            {
               monsterSkillVo = new MonsterSkillVo();
               monsterSkillVo.id = skillId;
               unlearnSkills.push(monsterSkillVo);
            }
            skillId = e.msg.body.readInt();
         }
         skillVo.learnSkills = learnSkills;
         skillVo.unlearnSkills = unlearnSkills;
         skillVo.id = e.msg.body.readInt();
         skillVo.packid = e.msg.body.readInt();
         dispatch(EventConst.S_RESPONSE_MONSTER_SKILL,skillVo);
      }
      
      private function onBatchUsePropsHandler(e:MsgEvent) : void
      {
         var data:Object = null;
         e.stopImmediatePropagation();
         data = {};
         data.monsterid = e.msg.body.readInt();
         data.addExp = e.msg.body.readInt();
         data.itemid = e.msg.body.readInt();
         data.useNum = e.msg.body.readInt();
         data.state = e.msg.body.readInt();
         dispatch(EventConst.S_BATCHUSE_PROPS,data);
      }
      
      private function onUseSymmTakeOffHandler(e:MsgEvent) : void
      {
         var data:Object = null;
         var id:int = 0;
         var monsterSn:int = 0;
         var params:Object = null;
         var ids:Array = null;
         var names:Array = null;
         var symmNames:Array = null;
         var index:int = 0;
         var name:String = null;
         e.stopImmediatePropagation();
         data = {};
         data.result = e.msg.body.readInt();
         switch(data.result)
         {
            case 1:
               id = e.msg.body.readInt();
               monsterSn = e.msg.body.readInt();
               params = {
                  "propsid":id,
                  "monsterid":monsterSn
               };
               ids = [103017,103018,103019,103020];
               names = ["3级摘玉符","4级摘玉符","5级摘玉符","6级摘玉符"];
               symmNames = ["3级灵玉","4级灵玉","5级灵玉","6级灵玉"];
               if(ids.indexOf(id) != -1)
               {
                  index = int(ids.indexOf(id));
                  name = names[index];
                  new FloatAlert().show(WindowLayer.instance,300,300,"消耗一个" + name + "，成功卸下" + symmNames[index]);
               }
               dispatch(EventConst.USEPROPSBACK,params);
               break;
            case 2:
               new Alert().showOne("抱歉，你没有足够的摘玉符");
               break;
            case 3:
               new Alert().showOne("抱歉，你用的摘玉符与妖怪身上的灵玉的级别不符，请使用对应级别的摘玉符。");
               break;
            case 0:
               new Alert().showOne("抱歉，发生未知错误");
         }
      }
      
      private function onKabuOnlineHandler(e:MsgEvent) : void
      {
         if(e.msg.body.bytesAvailable > 0)
         {
            this.readOnline(e.msg.body);
         }
      }
      
      private function onKabuOnlineAwardHandler(e:MsgEvent) : void
      {
         var result:int = 0;
         result = e.msg.body.readInt();
         if(result == 0)
         {
            this.readOnline(e.msg.body);
         }
      }
      
      private function readOnline(_byte:ByteArray) : void
      {
         var onlineTime:int = 0;
         var list:Array = null;
         var i:int = 0;
         var idx:int = 0;
         var state:int = 0;
         onlineTime = _byte.readInt();
         list = [];
         for(i = 0; i < 6; i++)
         {
            state = _byte.readInt();
            list.push(state);
         }
         idx = _byte.readInt();
         CacheData.instance.kabuOnline.getAwardBack(idx);
         CacheData.instance.kabuOnline.initializeOnline(onlineTime,list);
      }
      
      private function onSetTitleHandler(e:MsgEvent) : void
      {
         var obj:Object = null;
         e.stopImmediatePropagation();
         obj = {};
         obj.index = e.msg.mParams;
         if(obj.index == 4)
         {
            GameData.instance.playerData.familyId = e.msg.body.readInt();
            GameData.instance.playerData.familyAllName = e.msg.body.readUTF();
         }
         else if(obj.index != 0)
         {
            obj.uid = e.msg.body.readInt();
            obj.id = e.msg.body.readInt();
            if(GameData.instance.playerData.userId == obj.uid)
            {
               switch(obj.index)
               {
                  case 1:
                  case 3:
                     GameData.instance.playerData.titleIndex = obj.id;
                     break;
                  case 2:
                     GameData.instance.playerData.setShowFamily(obj.id);
               }
            }
            dispatch(EventConst.S_TITLE_UPDATE_SHOW,obj);
         }
      }
      
      private function onActivityProtocolBackHandler(evt:MsgEvent) : void
      {
         if(evt.msg.mParams == 195)
         {
            this.handlerBossWar(evt);
         }
         else if(evt.msg.mParams == 224)
         {
            this.handlerLookForpresures(evt);
         }
         else if(evt.msg.mParams == 336)
         {
            this.handlerAchieveAward(evt);
         }
      }
      
      private function handlerLookForpresures(evt:MsgEvent) : void
      {
         var operation:int = 0;
         var param:Object = null;
         var toolxml:XML = null;
         evt.msg.body.position = 0;
         operation = evt.msg.body.readInt();
         switch(operation)
         {
            case 2:
               param = {};
               param.itemNum = evt.msg.body.readInt();
               param.type = 102;
               param.itemId = 103014;
               param.itemSwitch = 1;
               if(param.itemId != 0 && param.itemNum != 0)
               {
                  toolxml = XMLLocator.getInstance().tooldic[param.itemId] as XML;
                  if(toolxml == null)
                  {
                     param.name = "";
                     param.desc = "";
                  }
                  else
                  {
                     param.name = toolxml.name;
                     param.desc = toolxml.desc;
                  }
               }
               GameData.instance.playerData.effectList.updateList(param);
               this.updateCollect(GameData.instance.playerData.weaponId);
               dispatch(EventConst.EFFECT_SHOW);
         }
      }
      
      private function handlerBossWar(evt:MsgEvent) : void
      {
         var operation:int = 0;
         var mbody:Object = null;
         var hurtValue:int = 0;
         var exp:int = 0;
         var time:int = 0;
         var str:String = null;
         var msg:String = null;
         evt.msg.body.position = 0;
         operation = evt.msg.body.readInt();
         mbody = {};
         mbody.operation = operation;
         switch(operation)
         {
            case 1:
            case 2:
            case 3:
               break;
            case 4:
               mbody.initBossHp = evt.msg.body.readInt();
               mbody.bossHp = evt.msg.body.readInt();
               BossRemarkData.instance.initBossHp = mbody.initBossHp;
               BossRemarkData.instance.bossHp = mbody.bossHp;
               if(mbody.bossHp < 1 && GameData.instance.playerData.currentScenenId != 11005)
               {
                  this.getAward();
               }
               dispatch(EventConst.BOSSREMARK_NOTIFY_DEAD,mbody);
               break;
            case 999:
               hurtValue = evt.msg.body.readInt();
               exp = evt.msg.body.readInt();
               time = evt.msg.body.readInt();
               str = TimeTransform.getInstance().transDate(time,".");
               msg = "恭喜你在 <font color=\'#ff0000\'>" + str + " </font>对噬天大帝造成了<font color=\'#ff0000\'>" + hurtValue + "</font>点伤害，获得奖励<font color=\'#ff0000\'>" + exp + "</font>历练";
               new Alert().show(msg);
               break;
            default:
               trace("数据返回时出错了吗？？？");
         }
      }
      
      private function getAward() : void
      {
         var delayTime:int = 0;
         var delayTime1:int = 0;
         delayTime = Math.random() * (60000000 - 1000) + 1000;
         delayTime1 = Math.random() * (60000000 - 1000) + 1000;
         setTimeout(this.delayGetAward,delayTime + delayTime1);
      }
      
      private function handlerAchieveAward(evt:MsgEvent) : void
      {
         var operation:int = 0;
         var mbody:Object = null;
         evt.msg.body.position = 0;
         operation = evt.msg.body.readInt();
         mbody = {};
         mbody.operation = operation;
         switch(operation)
         {
            case 1:
               mbody.achievepoint = evt.msg.body.readInt();
               mbody.awardStep = evt.msg.body.readInt();
               if(mbody.awardStep > 25)
               {
                  mbody.awardStep = 25;
               }
               dispatch(EventConst.ACHIEVEMENT_AWARD_INFO_BACK,mbody);
               break;
            case 2:
               mbody.result = evt.msg.body.readInt();
               mbody.awardStep = evt.msg.body.readInt();
               dispatch(EventConst.ACHIEVEMENT_AWARD_GET_BACK,mbody);
         }
      }
      
      private function delayGetAward() : void
      {
         con.sendCmd(MsgDoc.OP_CLIENT_ACTIVITY_QINGYANG.send,195,[1]);
      }
      
      private function onChangeWareHouseBackHandler(evt:MsgEvent) : void
      {
         var faceid:int = 0;
         evt.msg.body.position = 0;
         faceid = evt.msg.mParams;
         dispatch(EventConst.S_CHANGE_WARE_HOUSE_FACE,faceid);
         CacheData.instance.wareHouseFaceId = faceid;
      }
      
      private function onCrossServerPlayerDressHandler(evt:MsgEvent) : void
      {
         var rip:RoleInfoParse = null;
         this.traceSocket(evt);
         if(evt.msg.mParams == 0)
         {
            rip = new RoleInfoParse();
            rip.parse(evt.msg);
            dispatch(EventConst.CROSS_SERVER_PLAYERDRESS,rip.params);
         }
         else
         {
            AlertManager.instance.addTipAlert({"tip":"错误码：" + evt.msg.mParams});
         }
      }
      
      public function traceSocket(event:MsgEvent, opcode:String = "", params:int = 0) : void
      {
         var v:String = null;
         var byteArray:ByteArray = null;
         var i:int = 0;
         var curNum:int = 0;
         var bodyStr:String = null;
         if(O.debug)
         {
            v = "--------- 收到服务端消息 star ---------\n";
            v += "Code：" + (opcode == "" ? event.msg.mOpcode.toString(16) : opcode) + "\n";
            v += "Params：" + (params == 0 ? event.msg.mParams.toString() : params.toString()) + "\n";
            v += "Body：\n";
            byteArray = event.msg.body;
            byteArray.position = 0;
            i = 0;
            bodyStr = "";
            while(byteArray.position < byteArray.length)
            {
               if(i == 2)
               {
                  bodyStr += "[" + i + "]：" + byteArray.readUTF() + "\n";
               }
               else
               {
                  curNum = byteArray.readInt();
                  bodyStr += "[" + i + "]：" + curNum + "\n";
               }
               i++;
               if(i >= 21)
               {
                  break;
               }
            }
            v += bodyStr + "\n--------- 收到服务端消息 end ---------\n\n";
            trace(v);
            if(ExternalInterface.available)
            {
               ExternalInterface.call("console.log",v);
            }
            byteArray.position = 0;
         }
      }
      
      private function onSingleSpiritInfoHandler(evt:MsgEvent) : void
      {
         var spritesParse:SingleSpiritParse = null;
         O.traceSocket(evt);
         spritesParse = new SingleSpiritParse();
         spritesParse.parse(evt.msg);
         if(evt.msg.mParams == 0)
         {
            dispatch(EventConst.SINGLE_SPIRIT_INFO_LIST,spritesParse.params);
         }
      }
      
      private function onGatewayConfirmBoxHandler(evt:MsgEvent) : void
      {
         evt.msg.body.position = 0;
         AlertManager.instance.addTipAlert({
            "tip":evt.msg.body.readUTF(),
            "type":2
         });
      }
      
      private function onActErrorCodeHandler(evt:MsgEvent) : void
      {
         var str:String = null;
         var code:int = 0;
         var actId:int = 0;
         var obj:Object = null;
         var toolId:int = 0;
         var error:int = 0;
         var vo:NewsVo = null;
         evt.msg.body.position = 0;
         switch(evt.msg.mParams)
         {
            case -1:
               code = evt.msg.body.readInt();
               actId = evt.msg.body.readInt();
               toolId = evt.msg.body.readInt();
               error = evt.msg.body.readInt();
               if(Boolean(toolId))
               {
                  switch(code)
                  {
                     case 10003:
                        if(code == -1)
                        {
                           AlertManager.instance.addTipAlert({
                              "tip":"背包已满",
                              "type":1
                           });
                        }
                        else
                        {
                           str = ToolTipStringUtil.getToolName(toolId);
                           AlertManager.instance.addTipAlert({
                              "tip":"道具【" + str + "】达上限！",
                              "type":1
                           });
                        }
                        break;
                     case 10006:
                        AlertManager.instance.addTipAlert({
                           "tip":"宠物背包已满",
                           "type":1
                        });
                  }
               }
               break;
            case -2:
               code = evt.msg.body.readInt();
               str = evt.msg.body.readUTF();
               AlertManager.instance.addTipAlert({
                  "tip":str,
                  "type":code
               });
               break;
            case -3:
               evt.msg.body.readUTF();
               str = evt.msg.body.readUTF();
               obj = JSON.parse(str);
               switch(obj["act_id"])
               {
                  case 692:
                     vo = new NewsVo();
                     vo.alertType = 3;
                     vo.type = 5;
                     if(obj["option"] == 1)
                     {
                        vo.data["otherKey"] = "692Other";
                        vo.data["otherObj"] = obj["room_id"];
                        vo.data["actId"] = 692;
                        vo.data["url"] = "assets/activity/202508/Act692/Act692Entrance.swf";
                        vo.msg = "【" + obj["name"] + "】同意你加入自定义擂台，点击“知道了”进入擂台";
                     }
                     else
                     {
                        vo.msg = "【" + obj["name"] + "】拒绝了你加入自定义擂台申请。";
                     }
                     GameData.instance.boxVipMessages.push(vo);
                     GameData.instance.showMessagesCome();
               }
         }
      }
      
      private function onRequestWareHouseBackHandler(evt:MsgEvent) : void
      {
         var faceid:int = 0;
         evt.msg.body.position = 0;
         if(evt.msg.mParams == 3)
         {
            faceid = evt.msg.body.readInt();
            dispatch(EventConst.S_CHANGE_WARE_HOUSE_FACE,faceid);
            CacheData.instance.wareHouseFaceId = faceid;
         }
      }
      
      private function onOASettingBack(evt:MsgEvent) : void
      {
         var key:String = null;
         var item:NoticeItem = null;
         O.traceSocket(evt);
         key = evt.msg.body.readUTF();
         item = new NoticeItem();
         item.id = evt.msg.body.readInt();
         item.type = evt.msg.body.readInt();
         item.interval = evt.msg.body.readInt();
         item.message = evt.msg.body.readUTF();
         item.start_t = evt.msg.body.readInt();
         item.end_t = evt.msg.body.readInt();
         NoticeManager.instance.onSetting(key,item);
      }
      
      private function onMinorsOffBack(evt:MsgEvent) : void
      {
         GlobalConfig.otherObj["MinorsOff"] = true;
         O.traceSocket(evt);
         AlertManager.instance.addTipAlert({
            "tip":"根据国家防沉迷相关规定，由于您是未成年人，仅能在周五、周六、周日及法定节假日20时至21时进入游戏。",
            "type":2,
            "callback":function():void
            {
               if(ExternalInterface.available)
               {
                  if(GlobalConfig.isClient)
                  {
                     navigateToURL(new URLRequest("javascript:window.parent.location.href=\'http://enter.wanwan4399.com/bin-debug/KBgameindex.html\'"),"_self");
                  }
                  else
                  {
                     navigateToURL(new URLRequest("javascript:window.parent.location.href=\'http://www.4399.com/flash/48399.htm\'"),"_self");
                  }
               }
            }
         });
      }
      
      private function onOnlineAnnouncementBack(evt:MsgEvent) : void
      {
         var len:int = 0;
         var i:int = 0;
         var item:NoticeItem = null;
         O.traceSocket(evt);
         evt.msg.body.position = 0;
         len = evt.msg.body.readInt();
         for(i = 0; i < len; i++)
         {
            item = new NoticeItem();
            item.id = evt.msg.body.readInt();
            item.type = evt.msg.body.readInt();
            item.interval = evt.msg.body.readInt();
            item.message = evt.msg.body.readUTF();
            item.start_t = evt.msg.body.readInt();
            item.end_t = evt.msg.body.readInt();
            NoticeManager.instance.addNotice(item);
         }
      }
      
      private function onAnnouncementBack(evt:MsgEvent) : void
      {
         var str:String = null;
         evt.msg.body.position = 0;
         str = "<font color= \'#FF0000\' >" + evt.msg.body.readUTF() + "</font>";
         if(str != null && str != "")
         {
            AlertManager.instance.addTipAlert({
               "tip":str,
               "type":9,
               "speed":5000
            });
            setTimeout(function():void
            {
               AlertManager.instance.addTipAlert({
                  "tip":str,
                  "type":9,
                  "speed":5000
               });
            },8000);
            setTimeout(function():void
            {
               AlertManager.instance.addTipAlert({
                  "tip":str,
                  "type":9,
                  "speed":5000
               });
            },16000);
         }
      }
      
      private function onClearTaskDialog(e:MsgEvent) : void
      {
         var dialog:TaskDialog = null;
         dialog = CacheUtil.getObject(TaskDialog) as TaskDialog;
         if(Boolean(dialog))
         {
            dialog.dispos();
         }
      }
      
      private function onItemNumUpdateHandler(e:MsgEvent) : void
      {
         var p:int = 0;
         var obj:Object = null;
         var count:int = 0;
         var i:int = 0;
         var itemid:int = 0;
         var itemnum:int = 0;
         var maxnum:int = 0;
         O.traceSocket(e);
         e.msg.body.position = 0;
         p = e.msg.mParams;
         switch(p)
         {
            case 1:
               obj = {};
               count = e.msg.body.readInt();
               for(i = 0; i < count; i++)
               {
                  itemid = e.msg.body.readInt();
                  itemnum = e.msg.body.readInt();
                  maxnum = e.msg.body.readInt();
                  obj[itemid] = {
                     "itemnum":itemnum,
                     "maxnum":maxnum
                  };
               }
               GameData.instance.dispatchEvent(new MessageEvent(EventDefine.ITEM_NUM_UPDATE,obj));
         }
      }
      
      private function onResolveHandler(e:MsgEvent) : void
      {
         var sn:int = 0;
         var nFlag:int = 0;
         var data:Object = null;
         var nCount:int = 0;
         var list:Array = null;
         var i:int = 0;
         var obj:Object = null;
         e.msg.body.position = 0;
         sn = e.msg.mParams;
         nFlag = e.msg.body.readShort();
         if(nFlag == 1)
         {
            data = {};
            nCount = e.msg.body.readShort();
            list = [];
            for(i = 0; i < nCount; i++)
            {
               obj = {};
               obj.nType = e.msg.body.readShort();
               obj.id = e.msg.body.readInt();
               obj.num = e.msg.body.readInt();
               list.push(obj);
            }
            data.symmIndex = sn;
            data.list = list;
            this.onSymmRosHandler(data);
         }
         else if(nFlag == 2)
         {
            new Alert().show("装备在身上不能分解");
         }
         else if(nFlag == 3)
         {
            new Alert().show("没有该灵玉");
         }
         else if(nFlag == 6)
         {
            AlertUtil.showNoCopperView();
         }
      }
      
      private function onSymmRosHandler(obj:Object) : void
      {
         var list:Array = null;
         var data:Object = null;
         var url:String = null;
         var name:String = null;
         var msg:String = null;
         list = obj.list;
         for each(data in list)
         {
            if(data.nType == SymmEnum.E_Box_Type_Item)
            {
               url = URLUtil.getSvnVer("assets/tool/" + data.id + ".swf");
               name = "";
               try
               {
                  name = String(XMLLocator.getInstance().getTool(data.id).name);
               }
               catch(e:*)
               {
                  name = "";
               }
               msg = "获得" + HtmlUtil.getHtmlText(12,"#FF0000",data.num + "个" + name);
               new AwardAlert().showGoodsAward(url,WindowLayer.instance,msg,true,null,data.id);
            }
            else if(data.nType == SymmEnum.E_Box_Type_Coin)
            {
               new AwardAlert().showMoneyAward(data.num,WindowLayer.instance,null);
            }
            else if(data.nType == SymmEnum.E_Box_Type_Exp)
            {
               new AwardAlert().showExpAward(data.num,WindowLayer.instance);
            }
         }
      }
   }
}

