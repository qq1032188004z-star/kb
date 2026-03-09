package com.game.modules.control
{
   import com.core.observer.MessageEvent;
   import com.core.view.ViewConLogic;
   import com.game.event.EventConst;
   import com.game.global.GlobalConfig;
   import com.game.locators.CacheData;
   import com.game.locators.GameData;
   import com.game.locators.MsgDoc;
   import com.game.manager.AlertManager;
   import com.game.manager.EventManager;
   import com.game.modules.view.MapView;
   import com.game.modules.view.PackView;
   import com.game.modules.view.achieve.AchieveView;
   import com.game.modules.view.family.FamilyInfoRead;
   import com.game.modules.view.family.FamilySn;
   import com.game.modules.view.pack.HorseUseTool;
   import com.game.modules.view.pack.PackUseTool;
   import com.game.modules.vo.HorseCheckVo;
   import com.game.util.BitValueUtil;
   import com.game.util.FloatAlert;
   import com.game.util.GamePersonControl;
   import com.game.util.HorseCheck;
   import flash.events.Event;
   import flash.utils.getQualifiedClassName;
   import org.engine.core.GameSprite;
   
   public class PackControl extends ViewConLogic
   {
      
      public static const NAME:String = "packmediator";
      
      private var familyInfo:Object;
      
      public function PackControl(viewComponent:Object)
      {
         super(NAME,viewComponent);
         EventManager.attachEvent(this.view,Event.ADDED_TO_STAGE,this.onAddtoStage);
         this.onAddtoStage(null);
      }
      
      private function onAddtoStage(evt:Event) : void
      {
         this.view.initEvents();
         CacheData.instance.openState = 1;
         sendMessage(MsgDoc.OP_CLIENT_REQ_KB_COIN_INFO.send,GameData.instance.playerData.userId);
         sendMessage(MsgDoc.OP_CLIENT_REQ_PACK_TOKEN.send);
         sendMessage(MsgDoc.OP_CLIENT_REQ_ZHUANGBEI.send);
         sendMessage(MsgDoc.OP_CLIENT_REQ_PACKAGE_DATA.send,4294967295);
         if(GameData.instance.playerData.family_id > 0)
         {
            sendMessage(MsgDoc.OP_CLIENT_REQ_FAMILY_INFO.send,0,[FamilySn.PACKCONTROL_SN,GameData.instance.playerData.family_id]);
         }
         EventManager.attachEvent(this.view,PackView.OPEN_ACHIEVE,this.onOpenAchieve);
         EventManager.attachEvent(this.view,PackView.OPEN_SHIP_GUIDE,this.onOpenShipGuide);
         EventManager.attachEvent(this.view,PackView.OPEN_GONGGAO,this.onGongGao);
         EventManager.attachEvent(this.view,PackView.CLICK_ZUOQI,this.onZuoQi);
         EventManager.attachEvent(this.view,PackView.OPENFAMILYINFO,this.onFamilyInfo);
         EventManager.attachEvent(this.view,PackView.SENDCHANGEDRESS,this.onDressChange);
         EventManager.attachEvent(this.view,PackView.SENDUSEPROPS,this.onUseProps);
         EventManager.attachEvent(this.view,PackView.OPENUIBYUSEGOOD,this.onOpenUIByUseGood);
         EventManager.attachEvent(this.view,PackView.CHANGENAMEBORDER,this.onChangeNameBorder);
         EventManager.attachEvent(this.view,PackView.ONCLICK_ZUOQI_TYPE,this.onClickZuoQiType);
         EventManager.attachEvent(this.view,PackView.GET_PRESURES,this.onGetPresures);
         EventManager.attachEvent(this.view,PackView.GET_SPIRIT_EQUIP,this.onGetSpiritEquip);
         EventManager.attachEvent(this.view,PackView.TURN_OFF_SPIRIT_EQUIP,this.onTurnOffSpiritEquip);
         EventManager.attachEvent(this.view,PackView.GET_LIMITS,this.onGetLimits);
         EventManager.attachEvent(this.view,Event.REMOVED_FROM_STAGE,this.onRemoveFromStage);
         this.onGetLimits(null);
      }
      
      private function onRemoveFromStage(evt:Event) : void
      {
         this.view.removeEvents();
         EventManager.removeEvent(this.view,PackView.OPEN_ACHIEVE,this.onOpenAchieve);
         EventManager.removeEvent(this.view,PackView.OPEN_SHIP_GUIDE,this.onOpenShipGuide);
         EventManager.removeEvent(this.view,PackView.OPEN_GONGGAO,this.onGongGao);
         EventManager.removeEvent(this.view,PackView.CLICK_ZUOQI,this.onZuoQi);
         EventManager.removeEvent(this.view,PackView.OPENFAMILYINFO,this.onFamilyInfo);
         EventManager.removeEvent(this.view,PackView.SENDCHANGEDRESS,this.onDressChange);
         EventManager.removeEvent(this.view,PackView.SENDUSEPROPS,this.onUseProps);
         EventManager.removeEvent(this.view,PackView.OPENUIBYUSEGOOD,this.onOpenUIByUseGood);
         EventManager.removeEvent(this.view,PackView.CHANGENAMEBORDER,this.onChangeNameBorder);
         EventManager.removeEvent(this.view,PackView.ONCLICK_ZUOQI_TYPE,this.onClickZuoQiType);
         EventManager.removeEvent(this.view,PackView.GET_PRESURES,this.onGetPresures);
         EventManager.removeEvent(this.view,PackView.GET_SPIRIT_EQUIP,this.onGetSpiritEquip);
         EventManager.removeEvent(this.view,PackView.TURN_OFF_SPIRIT_EQUIP,this.onTurnOffSpiritEquip);
         EventManager.removeEvent(this.view,PackView.GET_LIMITS,this.onGetLimits);
         EventManager.removeEvent(this.view,Event.REMOVED_FROM_STAGE,this.onRemoveFromStage);
      }
      
      private function onGetLimits(evt:Event) : void
      {
         if(GameData.instance.playerData.isNewHand < 9)
         {
            return;
         }
         sendMessage(MsgDoc.OP_CLIENT_REQ_LIMITS_LIST.send);
      }
      
      private function onTurnOffSpiritEquip(evt:MessageEvent) : void
      {
         if(Boolean(evt.body.symmFlag) && Boolean(evt.body.symmIndex))
         {
            sendMessage(MsgDoc.OP_CLIENT_SPIRIT_EQUIP_TAKEOFF.send,evt.body.symmFlag,[evt.body.symmIndex]);
         }
      }
      
      private function onGetPresures(evt:Event) : void
      {
         sendMessage(MsgDoc.OP_CLIENT_REQ_PRESURES.send);
      }
      
      private function onGetSpiritEquip(evt:Event) : void
      {
         sendMessage(MsgDoc.OP_CLIENT_SPIRIT_EQUIP_ALL.send,GameData.instance.playerData.userId,[1]);
      }
      
      private function onClickZuoQiType(evt:Event) : void
      {
         if(GameData.instance.playerData.isNewHand < 9)
         {
            return;
         }
         sendMessage(MsgDoc.OP_CLIENT_REQ_ZUOQILIST.send);
      }
      
      private function onChangeNameBorder(evt:MessageEvent) : void
      {
         var code:int = int(evt.body);
         if(code == GameData.instance.playerData.nameBorderId)
         {
            AlertManager.instance.showTipAlert({
               "systemid":1049,
               "flag":1,
               "stage":this.view.stage
            });
            return;
         }
         sendMessage(MsgDoc.OP_CLIENT_USE_PROPS.send,code,[0,1,0,0]);
      }
      
      private function onOpenAchieve(evt:Event) : void
      {
         dispatch(EventConst.OPEN_CACHE_VIEW,{
            "showX":0,
            "showY":0
         },null,getQualifiedClassName(AchieveView));
      }
      
      private function onOpenShipGuide(evt:Event) : void
      {
         this.dispatch(EventConst.OPEN_MODULE,{
            "url":"assets/module/SpaceShipGuideModule.swf",
            "xCoord":0,
            "yCoord":0
         });
      }
      
      private function onGongGao(evt:Event) : void
      {
         dispatch(EventConst.BOBSTATECLICK,{
            "url":"assets/material/20110707.swf",
            "xCoord":0,
            "yCoord":0
         });
      }
      
      private function onZuoQi(evt:MessageEvent) : void
      {
         var horse:HorseCheckVo = null;
         if(GameData.instance.playerData.sceneId == 11005)
         {
            new FloatAlert().show(MapView.instance.stage,320,300,"此地有封印，无法使用坐骑");
            return;
         }
         if(GameData.instance.playerData.isDance)
         {
            AlertManager.instance.showTipAlert({
               "systemid":1049,
               "flag":2,
               "stage":MapView.instance.stage
            });
            return;
         }
         var horsep:Object = evt.body;
         var isSpecial:Boolean = GameData.instance.playerData.currentScenenId == 2008;
         if(GameData.instance.playerData.currentScenenId != 15000 && !MapView.instance.masterPerson.isInMoveAbleMoveArea(isSpecial))
         {
            if(GameData.instance.playerData.chorse == horsep.id)
            {
               if(GameData.instance.playerData.currentScenenId == 5003 || GameData.instance.playerData.currentScenenId == 30007)
               {
                  AlertManager.instance.showTipAlert({
                     "systemid":1049,
                     "flag":3,
                     "stage":MapView.instance.stage
                  });
               }
               else
               {
                  AlertManager.instance.showTipAlert({
                     "systemid":1049,
                     "flag":4,
                     "stage":MapView.instance.stage
                  });
               }
               return;
            }
            if(!GamePersonControl.instance.isFlyIngHorse(horsep.iid))
            {
               AlertManager.instance.showTipAlert({
                  "systemid":1049,
                  "flag":5,
                  "stage":MapView.instance.stage
               });
               return;
            }
         }
         if(GamePersonControl.instance.isFlyIngHorse(horsep.iid) && !GamePersonControl.instance.isInSpecialSceneList())
         {
            if(horsep.isuse == 2 && (GameData.instance.playerData.currentScenenId == 5003 || GameData.instance.playerData.currentScenenId == 30007))
            {
               AlertManager.instance.showTipAlert({
                  "systemid":1049,
                  "flag":6,
                  "stage":MapView.instance.stage
               });
               return;
            }
         }
         if(GameData.instance.playerData.isInChange == 1 && GameData.instance.playerData.bodyID != 0)
         {
            AlertManager.instance.showTipAlert({
               "systemid":1049,
               "flag":7
            });
            return;
         }
         if(Boolean(horsep.hasOwnProperty("cssj")) && horsep.cssj > 0)
         {
            AlertManager.instance.showTipAlert({
               "systemid":1049,
               "flag":8
            });
            return;
         }
         if(Boolean(GameData.instance.playerData.magicStatus))
         {
            switch(GameData.instance.playerData.magicStatus)
            {
               case 14:
                  AlertManager.instance.showTipAlert({
                     "systemid":1049,
                     "flag":9,
                     "stage":this.view.stage
                  });
                  break;
               case 26:
                  AlertManager.instance.showTipAlert({
                     "systemid":1049,
                     "flag":15,
                     "stage":this.view.stage
                  });
                  break;
               case 29:
                  AlertManager.instance.showTipAlert({
                     "systemid":1049,
                     "flag":16,
                     "stage":this.view.stage
                  });
            }
            return;
         }
         if(horsep.iid != 0)
         {
            if(GameData.instance.playerData.chorse != horsep.id || GameData.instance.playerData.horseID == 0)
            {
               horse = new HorseCheckVo();
               horse.horseId = horsep.iid;
               horse.keyId = horsep.id;
               horse.sceneId = GameData.instance.playerData.currentScenenId;
               HorseCheck.instance.checkBySceneId(horse,this.checkHorseBack);
            }
            else
            {
               GameData.instance.playerData.chorse = -1;
               sendMessage(MsgDoc.OP_CLIENT_HORSE_USE.send,2,[horsep.id]);
            }
         }
      }
      
      private function checkHorseBack(checkData:HorseCheckVo) : void
      {
         if(checkData.sceneId == GameData.instance.playerData.currentScenenId)
         {
            if(checkData.checkResult)
            {
               if(BitValueUtil.getBitValue(checkData.userState,1) && !GameData.instance.playerData.isVip)
               {
                  AlertManager.instance.showTipAlert({
                     "systemid":1049,
                     "flag":10,
                     "stage":MapView.instance.stage
                  });
               }
               else
               {
                  GameData.instance.playerData.chorse = checkData.keyId;
                  sendMessage(MsgDoc.OP_CLIENT_HORSE_USE.send,1,[checkData.keyId]);
               }
            }
            else if(Boolean(CacheData.instance.scenceHorseTips))
            {
               HorseUseTool.instance.getTipsMsg([CacheData.instance.scenceHorseTips],this.showHorseFailTips);
            }
            else
            {
               HorseUseTool.instance.getTipsMsg([checkData.horseId,CacheData.instance.scenceHorseLimited],this.showHorseFailTips);
            }
         }
      }
      
      private function showHorseFailTips(msg:String) : void
      {
         if(msg != null && msg != "")
         {
            new FloatAlert().show(MapView.instance.stage,320,300,msg);
         }
      }
      
      private function onFamilyInfo(evt:Event) : void
      {
         if(this.familyInfo != null)
         {
            dispatch(EventConst.OPEN_CACHE_VIEW,this.familyInfo,null,getQualifiedClassName(FamilyInfoRead));
         }
      }
      
      private function onDressChange(evt:MessageEvent) : void
      {
         if(GameData.instance.playerData.isDance)
         {
            AlertManager.instance.showTipAlert({
               "systemid":1049,
               "flag":11,
               "stage":MapView.instance.stage
            });
            return;
         }
         var params:Object = evt.body;
         sendMessage(MsgDoc.OP_CLIENT_CHANGE_DRESS.send,0,[params.hatid,params.clothid,params.footid,params.weaponid,params.taozhuangId,params.glassid,params.faceid,params.wingid,params.leftWeapon]);
      }
      
      private function onUseProps(evt:MessageEvent) : void
      {
         if(evt.body.prosid == 400197)
         {
            if(GameData.instance.playerData.currentScenenId != 2005)
            {
               AlertManager.instance.showTipAlert({
                  "systemid":1049,
                  "flag":12
               });
            }
            else
            {
               MapView.instance.masterPerson.moveto(630,240,this.onArrideHandler);
               dispatch(MapView.ROLEMOVE,{
                  "newx":630,
                  "newy":240,
                  "flag":1
               });
            }
         }
         else
         {
            PackUseTool.Instance.useTool(evt.body);
         }
      }
      
      private function onArrideHandler() : void
      {
         var maataskai:GameSprite = MapView.instance.findGameSprite(20120112);
         if(maataskai != null)
         {
            maataskai.ui["content"]["onStartTask"]();
            dispatch(EventConst.MAA_TASK_ACTION,1);
         }
      }
      
      private function onOpenUIByUseGood(evt:MessageEvent) : void
      {
         var url:String = "";
         var useGoodID:int = evt.body as int;
         if(useGoodID >= 400259 && useGoodID <= 400264)
         {
            url = "assets/module/JuneActivity.swf";
            dispatch(EventConst.OPEN_MODULE,{
               "url":url,
               "xCoord":0,
               "yCoord":0
            });
         }
         else
         {
            url = "assets/material/usegood" + (evt.body as int) + ".swf";
            dispatch(EventConst.OPENSWFWINDOWS,{
               "url":url,
               "xCoord":0,
               "yCoord":0
            });
         }
      }
      
      public function get view() : PackView
      {
         return this.getViewComponent() as PackView;
      }
      
      override public function listEvents() : Array
      {
         return [[EventConst.GETPACKINFOBACK,this.getPackInfoBack],[EventConst.GETZHUANGBEIBACK,this.getZhuangbeiBack],[EventConst.USEPROPSBACK_PACK,this.usePropsBackPack],[EventConst.REQ_FAMILY_INFO_BACK,this.getFamilyInfoBack],[EventConst.ZUOQILIST_BACK,this.getZuoListBack],[EventConst.ZUOQISTATE_BACK,this.getZuoQiStateBack],[EventConst.USE_HORSE_TOOL_BACK,this.useHorseToolBack],[EventConst.PACK_TOKEN_BACK,this.getPackTokenBack],[EventConst.GET_PRESURES_BACK,this.getPresuresBack],[EventConst.SYMM_PAKAGE_LIST_BACK,this.getSpiritEquipBack],[EventConst.SYMM_TAKEOFF_BACK,this.onSymmTakeOffBack],[EventConst.GETLIMITSBACK,this.onLimitsBack],[EventConst.REQRENEWLIMITS,this.reqRenewLimits],[EventConst.RENEWLIMITSBACK,this.onRenewLimitsBack],[EventConst.S_BATCHUSEPROP_PACK,this.handlerOpenBatchUseView]];
      }
      
      private function handlerOpenBatchUseView(event:MessageEvent) : void
      {
         var itemVO:Object = event.body;
         this.view.openToolBatchUseView(itemVO);
      }
      
      private function getPackInfoBack(event:MessageEvent) : void
      {
         this.view.setData();
      }
      
      private function getZhuangbeiBack(event:MessageEvent) : void
      {
         var list:Array = event.body as Array;
         this.view.showZhuangbeiList(list);
      }
      
      private function usePropsBackPack(evt:MessageEvent) : void
      {
         sendMessage(MsgDoc.OP_CLIENT_REQ_PACKAGE_DATA.send,4294967295);
      }
      
      private function getFamilyInfoBack(evt:MessageEvent) : void
      {
         if(evt.body != null && evt.body.sn != null && evt.body.sn == 1111)
         {
            this.view.setBadge(evt.body);
            this.familyInfo = evt.body;
         }
         else
         {
            this.familyInfo = null;
         }
      }
      
      private function getZuoListBack(evt:MessageEvent) : void
      {
         this.view.onZuoQiListBack(evt.body);
         if(GameData.instance.playerData.horseID != 0)
         {
            sendMessage(MsgDoc.OP_CLIENT_REQ_HORSE_STATE.send,GlobalConfig.userId);
         }
      }
      
      private function getZuoQiStateBack(evt:MessageEvent) : void
      {
         this.view.getHorseStateBack(evt.body);
      }
      
      private function useHorseToolBack(evt:MessageEvent) : void
      {
         var params:Object = evt.body;
         if(params.code < 0)
         {
            AlertManager.instance.showTipAlert({
               "systemid":1049,
               "flag":13
            });
         }
         else
         {
            AlertManager.instance.showTipAlert({
               "systemid":1049,
               "flag":14
            });
            this.view.useZuoQiToolBack(params);
         }
      }
      
      private function getPackTokenBack(evt:MessageEvent) : void
      {
         this.view.initToken(evt.body);
      }
      
      private function getPresuresBack(evt:MessageEvent) : void
      {
         this.view.initPresures();
      }
      
      private function getSpiritEquipBack(evt:MessageEvent) : void
      {
         if(evt.body.type == 1)
         {
            this.view.initSpiritEquip(evt.body);
         }
      }
      
      private function onSymmTakeOffBack(evt:MessageEvent) : void
      {
         this.onGetSpiritEquip(null);
      }
      
      private function onLimitsBack(evt:MessageEvent) : void
      {
         this.view.initLimitsList(evt.body);
         sendMessage(MsgDoc.OP_CLIENT_REQ_ZUOQILIST.send);
      }
      
      private function reqRenewLimits(evt:MessageEvent) : void
      {
         var slist:Array = evt.body as Array;
         sendMessage(MsgDoc.OP_CLIENT_REQ_LIMITS_RENEW.send,0,slist);
      }
      
      private function onRenewLimitsBack(evt:MessageEvent) : void
      {
         this.view.renewLimitsBack(evt.body);
         this.onGetLimits(null);
      }
   }
}

