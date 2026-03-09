package com.game.modules.view
{
   import com.core.observer.MessageEvent;
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.global.GlobalConfig;
   import com.game.global.ItemType;
   import com.game.locators.GameData;
   import com.game.manager.AlertManager;
   import com.game.manager.EventManager;
   import com.game.manager.MouseManager;
   import com.game.modules.ai.SpecialAreaManager;
   import com.game.modules.control.PackControl;
   import com.game.modules.control.task.TaskList;
   import com.game.modules.view.family.FamilyBadge;
   import com.game.modules.view.item.PackItem;
   import com.game.modules.view.monster.SymmTip;
   import com.game.modules.view.pack.PackClothesTool;
   import com.game.modules.view.pack.PackRenewTool;
   import com.game.util.BitValueUtil;
   import com.game.util.CacheUtil;
   import com.game.util.FloatAlert;
   import com.game.util.GamePersonControl;
   import com.game.util.HLoaderSprite;
   import com.game.util.HtmlUtil;
   import com.game.util.PropertyPool;
   import com.publiccomponent.alert.Alert;
   import com.publiccomponent.events.ItemClickEvent;
   import com.publiccomponent.list.TileList;
   import com.publiccomponent.loading.GreenLoading;
   import com.publiccomponent.loading.XMLLocator;
   import com.publiccomponent.ui.ToolTip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import org.dress.ui.RoleFace;
   
   public class PackView extends HLoaderSprite
   {
      
      private static var ZuoQiFlag:Boolean = true;
      
      public static const OPEN_GONGGAO:String = "open_gonggao";
      
      public static const CLICK_ZUOQI:String = "click_zuoqi";
      
      public static const OPENFAMILYINFO:String = "openfamilyinfo";
      
      public static const GETSERVERDATA:String = "getserverdate";
      
      public static const SENDCHANGEDRESS:String = "sendchangdress";
      
      public static const CHANGEBODYCARD:String = "changgebodycard";
      
      public static const SENDUSEPROPS:String = "useprops";
      
      public static const OPENUIBYUSEGOOD:String = "openuibyusegood";
      
      public static const CHANGENAMEBORDER:String = "changenameborder";
      
      public static const ONCLICK_ZUOQI_TYPE:String = "onclick_zuoqi_type";
      
      public static const OPEN_ACHIEVE:String = "open_achieve";
      
      public static const OPEN_SHIP_GUIDE:String = "open_ship_guide";
      
      public static const GET_PRESURES:String = "get_presures";
      
      public static const GET_SPIRIT_EQUIP:String = "get_spirit_equip";
      
      public static const TURN_OFF_SPIRIT_EQUIP:String = "turn_off_spirit_equip";
      
      public static const GET_LIMITS:String = "get_limits";
      
      private var list:TileList;
      
      private var currentPageList:Array = [];
      
      private var currentTotalList:Array = [];
      
      private var currentPage:int = 1;
      
      private var totalPage:int;
      
      private var zhuangbeiList:Array = [];
      
      private var daojuList:Array = [];
      
      private var materialList:Array = [];
      
      private var presuresList:Array = [];
      
      private var zuoqiList:Array = [];
      
      private var spiritEquipList:Array = [];
      
      private var limitsList:Array = [];
      
      private var pageNum:int = 12;
      
      private var roleFace:RoleFace;
      
      private var isChange:Boolean;
      
      private var dressParams:Object = {};
      
      private var cardId:int;
      
      private var clockBtn:SimpleButton;
      
      private var xml:XML;
      
      private var ostime:int;
      
      private var horseRoundView:HorseRoundView;
      
      private var isOpen:Boolean;
      
      private var tempParams:Object;
      
      private var navigationIndex:int = 1;
      
      private var badge:FamilyBadge;
      
      private const alist:Array = ["","服装","道具","材料","精魄","坐骑","灵玉","限时物品"];
      
      private const blist:Array = [[],["全部","套装","VIP套装","头部","身体","手部","脚部","饰品","面部"],["全部","战斗","任务","名字外框","精元","代币","其它"],["全部","矿石","植物","气体"],["全部","培育获得","获赠获得","其它获得"],["全部","飞行","陆行"],["全部","属性灵玉"],["全部","限时服装","限时物品","限时材料","限时精魄","限时坐骑","限时灵玉"]];
      
      private var type_list:Array = [];
      
      private var bgmcH:Number;
      
      public function PackView()
      {
         super();
         this.newHandStep3Verify();
         GreenLoading.loading.visible = true;
         this.url = "assets/material/pack.swf";
      }
      
      override public function setShow() : void
      {
         this.loader.loader.unloadAndStop(false);
         this.bg.cacheAsBitmap = true;
         this.bg.vipClip.stop();
         this.bg.vipClip.visible = false;
         this.bg.turnOffClip.visible = false;
         this.bg.turnOffClip.txt.mouseEnabled = false;
         this.initList();
         this.roleFace = new RoleFace(400,400,1);
         this.roleFace.mouseEnabled = false;
         this.addChild(this.roleFace);
         this.horseRoundView = new HorseRoundView(409,385);
         addChild(this.horseRoundView);
         ApplicationFacade.getInstance().registerViewLogic(new PackControl(this));
         GameData.instance.addEventListener("coinupdate",this.onCoinChangeHandler);
         GameData.instance.addEventListener("vipcoinupdate",this.onKbcionChangeHandler);
         GreenLoading.loading.visible = false;
      }
      
      private function onCoinChangeHandler(event:Event) : void
      {
         if(bg)
         {
            bg.coinTxt.text = GameData.instance.playerData.coin + "";
         }
      }
      
      private function onKbcionChangeHandler(evt:Event) : void
      {
         if(bg)
         {
            bg.kbcoinTxt.text = GameData.instance.playerData.vipCoin + "";
         }
      }
      
      private function newHandStep3Verify() : void
      {
         if(GameData.instance.playerData.isNewHand == 3)
         {
            SpecialAreaManager.instance.loadNewHandMask("closemask");
         }
      }
      
      private function initList() : void
      {
         bg.menuTxt.mouseEnabled = false;
         this.bgmcH = this.bg.menu.bgmc.height;
         bg.nameTxt.text = GameData.instance.playerData.userName;
         bg.idTxt.text = "(" + GameData.instance.playerData.userId + ")";
         bg.coinTxt.text = GameData.instance.playerData.coin;
         bg.kbcoinTxt.text = GameData.instance.playerData.vipCoin + "";
         bg.gcoinTxt.text = "0";
         this.list = new TileList(526,104);
         this.list.build(3,4,84,66,2,5,PackItem);
         bg.addChildAt(this.list,bg.numChildren);
         this.initTypeList();
         this.menuDown();
      }
      
      public function initEvents() : void
      {
         this.bg.dragClip.addEventListener(MouseEvent.MOUSE_DOWN,this.onDownDragClip);
         EventManager.attachEvent(this.bg.closeBtn,MouseEvent.CLICK,this.closeWindow);
         EventManager.attachEvent(this.bg.leftBtn,MouseEvent.MOUSE_DOWN,this.moveLeft);
         EventManager.attachEvent(this.bg.rightBtn,MouseEvent.MOUSE_DOWN,this.moveRight);
         EventManager.attachEvent(this.bg.achievebtn,MouseEvent.CLICK,this.openAchieve);
         EventManager.attachEvent(this.bg.shipBtn,MouseEvent.CLICK,this.onShipGuide);
         EventManager.attachEvent(this.list,ItemClickEvent.ITEMCLICKEVENT,this.itemClick,true);
         EventManager.attachEvent(this.bg.turnOffClip,MouseEvent.CLICK,this.onTurnOffClip);
         EventManager.attachEvent(this.roleFace,MouseEvent.MOUSE_DOWN,this.onClickPerson);
         EventManager.attachEvent(this.bg.menuBtn,MouseEvent.MOUSE_DOWN,this.onMenuBtn);
         for(var i:int = 0; i < 9; i++)
         {
            if(i > 0 && i < 8)
            {
               EventManager.attachEvent(bg["rbtn" + i],MouseEvent.MOUSE_DOWN,this.onRBtns);
            }
            EventManager.attachEvent(bg.menu["btn" + i],MouseEvent.MOUSE_DOWN,this.onBtns);
            EventManager.attachEvent(bg.menu["btn" + i],MouseEvent.ROLL_OVER,this.onOverBtns);
            EventManager.attachEvent(bg.menu["btn" + i],MouseEvent.ROLL_OUT,this.onOutBtns);
            bg.menu["txt" + i].mouseEnabled = false;
         }
      }
      
      public function removeEvents() : void
      {
         var i:int = 0;
         if(bg)
         {
            this.bg.dragClip.removeEventListener(MouseEvent.MOUSE_DOWN,this.onDownDragClip);
            EventManager.removeEvent(this.bg.closeBtn,MouseEvent.CLICK,this.closeWindow);
            EventManager.removeEvent(this.bg.leftBtn,MouseEvent.MOUSE_DOWN,this.moveLeft);
            EventManager.removeEvent(this.bg.rightBtn,MouseEvent.MOUSE_DOWN,this.moveRight);
            EventManager.removeEvent(this.bg.achievebtn,MouseEvent.CLICK,this.openAchieve);
            EventManager.removeEvent(this.bg.shipBtn,MouseEvent.CLICK,this.onShipGuide);
            EventManager.removeEvent(this.list,ItemClickEvent.ITEMCLICKEVENT,this.itemClick);
            EventManager.removeEvent(this.bg.turnOffClip,MouseEvent.CLICK,this.onTurnOffClip);
            EventManager.removeEvent(this.roleFace,MouseEvent.MOUSE_DOWN,this.onClickPerson);
            EventManager.removeEvent(this.bg.menuBtn,MouseEvent.MOUSE_DOWN,this.onMenuBtn);
            for(i = 0; i < 9; i++)
            {
               if(i > 0 && i < 8)
               {
                  EventManager.removeEvent(bg["rbtn" + i],MouseEvent.MOUSE_DOWN,this.onRBtns);
               }
               EventManager.removeEvent(bg.menu["btn" + i],MouseEvent.MOUSE_DOWN,this.onBtns);
               EventManager.removeEvent(bg.menu["btn" + i],MouseEvent.ROLL_OVER,this.onOverBtns);
               EventManager.removeEvent(bg.menu["btn" + i],MouseEvent.ROLL_OUT,this.onOutBtns);
            }
         }
         this.disposBadge();
      }
      
      private function onDownDragClip(evt:MouseEvent) : void
      {
         bg.turnOffClip.visible = false;
         PackRenewTool.Instance.parentRemove();
      }
      
      private function closeWindow(evt:MouseEvent) : void
      {
         PackRenewTool.Instance.parentRemove();
         bg.chooseClip.gotoAndStop(1);
         this.isOpen = false;
         if(GameData.instance.playerData.isNewHand == 3)
         {
            SpecialAreaManager.instance.removeNewHandMask();
            ApplicationFacade.getInstance().dispatch(EventConst.FRESHMANGUIDETOTASK,{"step":3});
         }
         var body:Object = {
            "hatid":this.dressParams.hatId,
            "clothid":this.dressParams.clothId,
            "weaponid":this.dressParams.weaponId,
            "footid":this.dressParams.footId,
            "wingid":this.dressParams.wingId,
            "faceid":this.dressParams.faceId,
            "glassid":this.dressParams.glassId,
            "leftWeapon":this.dressParams.leftWeapon,
            "taozhuangId":this.dressParams.taozhuangId
         };
         if(this.isChange)
         {
            EventManager.dispatch(this,new MessageEvent(PackView.SENDCHANGEDRESS,body));
         }
         this.dressParams = GameData.instance.playerData;
         this.list.dataProvider = [];
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
      
      private function anlysisDataAndShow(targetList:Array) : void
      {
         this.currentTotalList = targetList;
         var len:int = int(targetList.length);
         this.totalPage = Math.ceil(targetList.length / this.pageNum);
         if(this.totalPage == 0)
         {
            this.currentPage = 0;
         }
         else if(this.currentPage > this.totalPage || this.currentPage == 0)
         {
            this.currentPage = 1;
         }
         this.showList();
         this.menuDown();
      }
      
      private function render() : void
      {
         PackRenewTool.Instance.parentRemove();
         bg.turnOffClip.visible = false;
         this.bg.pageTxt.text = this.currentPage + "/" + this.totalPage;
         this.list.dataProvider = this.currentPageList;
      }
      
      private function showList() : void
      {
         var index:int = 0;
         if(this.currentPage == 0)
         {
            this.currentPageList = [];
         }
         else
         {
            index = (this.currentPage - 1) * this.pageNum;
            this.currentPageList = this.getCurrentList(index);
         }
         this.render();
      }
      
      private function getCurrentList(index:int, totalNum:int = 12) : Array
      {
         var i:int = 0;
         var len:int = int(this.currentTotalList.length);
         var needs:Array = [];
         var total:int = index + totalNum;
         if(total >= this.currentTotalList.length)
         {
            total = int(this.currentTotalList.length);
         }
         if(index < len)
         {
            for(i = index; i < total; i++)
            {
               needs.push(this.currentTotalList[i]);
            }
         }
         return needs;
      }
      
      private function moveLeft(evt:MouseEvent) : void
      {
         if(this.currentPage > 1)
         {
            this.currentPage -= 1;
         }
         else
         {
            this.currentPage = this.totalPage;
         }
         this.showList();
      }
      
      private function moveRight(evt:MouseEvent) : void
      {
         if(this.currentPage < this.totalPage)
         {
            this.currentPage += 1;
         }
         else if(this.totalPage == 0)
         {
            this.currentPage = 0;
         }
         else
         {
            this.currentPage = 1;
         }
         this.showList();
      }
      
      private function openAchieve(evt:MouseEvent) : void
      {
         this.dispatchEvent(new Event(PackView.OPEN_ACHIEVE));
      }
      
      private function onShipGuide(evt:MouseEvent) : void
      {
         this.dispatchEvent(new Event(PackView.OPEN_SHIP_GUIDE));
      }
      
      private function gotoPage(page:int) : void
      {
         this.currentPage = page;
         var index:int = (this.currentPage - 1) * this.pageNum;
         this.currentPageList = this.currentTotalList.slice(index,index + this.pageNum);
         this.render();
      }
      
      private function onTurnOffClip(evt:MouseEvent) : void
      {
         this.dispatchEvent(new MessageEvent(PackView.TURN_OFF_SPIRIT_EQUIP,this.tempParams));
         bg.turnOffClip.visible = false;
      }
      
      private function itemClick(evt:ItemClickEvent) : void
      {
         var body:Object = null;
         var usedBoderId:int = 0;
         var boderData:Object = null;
         var obj:Object = null;
         if(GameData.instance.playerData.isNewHand < 4)
         {
            return;
         }
         this.tempParams = evt.params;
         bg.turnOffClip.visible = false;
         if(Boolean(this.tempParams.symmFlag) && this.tempParams.symmFlag > 0)
         {
            bg.turnOffClip.visible = true;
            bg.turnOffClip.x = stage.mouseX;
            bg.turnOffClip.y = stage.mouseY;
            bg.setChildIndex(bg.turnOffClip,bg.numChildren - 1);
            SymmTip.hideCurrentTip();
            return;
         }
         if(this.tempParams.hasOwnProperty("expiretime"))
         {
            if(this.tempParams.systemtime >= this.tempParams.expiretime)
            {
               PackRenewTool.Instance.initParams(this.tempParams);
               if(Boolean(PackRenewTool.Instance.parent))
               {
                  PackRenewTool.Instance.x = stage.mouseX;
                  PackRenewTool.Instance.y = stage.mouseY;
               }
               else
               {
                  PackRenewTool.Instance.show(WindowLayer.instance,stage.mouseX,stage.mouseY);
               }
               return;
            }
         }
         if(this.tempParams.packid == ItemType.toolType)
         {
            if(BitValueUtil.getBitValue(this.tempParams.usableStatus,1))
            {
               if(this.tempParams.id == 400219 || this.tempParams.id == 400220 || this.tempParams.id == 400221)
               {
                  GameData.instance.playerData.activeTmpData.christmasGoodid = this.tempParams.id;
               }
               body = {
                  "prosid":this.tempParams.id,
                  "jinghunid":0,
                  "gongneng":0,
                  "temp1":0,
                  "temp2":0
               };
               if(body.prosid == 100279)
               {
                  body.temp1 = GameData.instance.playerData.nameBorderId;
               }
               if(body.prosid == 103013)
               {
                  body.temp2 = 1;
               }
               EventManager.dispatch(this,new MessageEvent(PackView.SENDUSEPROPS,body));
               if(BitValueUtil.getBitValue(this.tempParams.usableStatus,20))
               {
                  this.closeWindow(null);
               }
            }
            else if(BitValueUtil.getBitValue(this.tempParams.usableStatus,2))
            {
               switch(this.tempParams.id)
               {
                  case 400076:
                     MouseManager.getInstance().setCursor("chanzi");
                     break;
                  case 400077:
                     MouseManager.getInstance().setCursor("zhongzi");
                     break;
                  case 400122:
                     MouseManager.getInstance().setCursor("jinnang");
                     break;
                  default:
                     MouseManager.getInstance().setCursor("packmouse" + this.tempParams.id);
                     if(this.tempParams.id == 400174)
                     {
                        EventManager.dispatch(this,new MessageEvent(PackView.SENDUSEPROPS,{
                           "prosid":this.tempParams.id,
                           "jinghunid":0,
                           "gongneng":0,
                           "temp1":0,
                           "temp2":0
                        }));
                     }
               }
               this.closeWindow(null);
            }
            else if(BitValueUtil.getBitValue(this.tempParams.usableStatus,3))
            {
               EventManager.dispatch(this,new MessageEvent(PackView.OPENUIBYUSEGOOD,this.tempParams.id));
               this.closeWindow(null);
            }
            else if(BitValueUtil.getBitValue(this.tempParams.usableStatus,4))
            {
               usedBoderId = GameData.instance.playerData.nameBorderId;
               boderData = XMLLocator.getInstance()["tooldic"][usedBoderId] as XML;
               if(BitValueUtil.getBitValue(boderData.useState,25))
               {
                  new Alert().showSureOrCancel("确定换上这个名字外框吗?",this.onSureOrNo,this.tempParams.id);
               }
               else
               {
                  new Alert().showSureOrCancel("确定换上这个名字外框吗?\n(换上后原外框将不会被保留)",this.onSureOrNo,this.tempParams.id);
               }
            }
         }
         else
         {
            if(this.tempParams.id == 0 || this.tempParams.packid == ItemType.materialType)
            {
               return;
            }
            if(this.tempParams.packid == ItemType.zuoqiType)
            {
               this.dispatchEvent(new MessageEvent(PackView.CLICK_ZUOQI,this.tempParams));
               this.closeWindow(null);
               return;
            }
         }
         if(BitValueUtil.getBitValue(this.tempParams.usableStatus,9))
         {
            if(GameData.instance.playerData.taozhuangId != this.tempParams.id)
            {
               GameData.instance.playerData.taozhuangId = this.dressParams.taozhuangId = this.tempParams.id;
            }
            else
            {
               GameData.instance.playerData.taozhuangId = this.dressParams.taozhuangId = 0;
            }
            this.isChange = true;
            this.closeWindow(null);
            return;
         }
         for(var i:int = 0; i < this.zhuangbeiList.length; i++)
         {
            obj = this.zhuangbeiList[i];
            if(obj.id == this.tempParams.id)
            {
               GameData.instance.playerData.taozhuangId = this.dressParams.taozhuangId = 0;
               this.renderEquipMent(obj,obj.id,i);
               break;
            }
         }
      }
      
      private function onSureOrNo(str:String, datapp:Object) : void
      {
         if(str == "确定")
         {
            EventManager.dispatch(this,new MessageEvent(PackView.CHANGENAMEBORDER,int(datapp)));
            this.closeWindow(null);
         }
      }
      
      private function sureOrCancel(str:String) : void
      {
         if(str == "确定")
         {
            this.parent.removeChild(this);
         }
      }
      
      private function useBianShenKa(id:int) : void
      {
         this.cardId = id;
         new Alert().showSureOrCancel("你确定使用变身卡吗?",this.closeHandler);
      }
      
      private function closeHandler(str:String) : void
      {
         if(str == "确定")
         {
            this.isOpen = false;
            this.parent.removeChild(this);
         }
      }
      
      private function renderEquipMent(obj:Object, id:int, index:int) : void
      {
         this.xml = XMLLocator.getInstance().getTool(id);
         if(this.xml == null)
         {
            return;
         }
         var left:int = this.xml.type % 10;
         if(left == 1)
         {
            if(Boolean(this.dressParams.hasOwnProperty("hatId")) && this.dressParams.hatId != 0)
            {
               if(this.dressParams.hatId == id)
               {
                  this.dressParams.hatId = 0;
               }
               else
               {
                  obj.id = id;
                  this.dressParams.hatId = id;
               }
            }
            else
            {
               this.dressParams.hatId = id;
            }
         }
         if(left == 2)
         {
            if(Boolean(this.dressParams.hasOwnProperty("clothId")) && this.dressParams.clothId != 0)
            {
               if(this.dressParams.clothId == id)
               {
                  this.dressParams.clothId = 0;
               }
               else
               {
                  obj.id = id;
                  this.dressParams.clothId = id;
               }
            }
            else
            {
               this.dressParams.clothId = id;
            }
         }
         if(left == 4)
         {
            if(Boolean(this.dressParams.hasOwnProperty("footId")) && this.dressParams.footId != 0)
            {
               if(this.dressParams.footId == id)
               {
                  this.dressParams.footId = 0;
               }
               else
               {
                  obj.id = id;
                  this.dressParams.footId = id;
               }
            }
            else
            {
               this.dressParams.footId = id;
            }
         }
         if(left == 3)
         {
            if(Boolean(this.dressParams.hasOwnProperty("weaponId")) && this.dressParams.weaponId != 0)
            {
               if(this.dressParams.weaponId == id)
               {
                  this.dressParams.weaponId = 0;
               }
               else
               {
                  obj.id = id;
                  this.dressParams.weaponId = id;
               }
            }
            else
            {
               this.dressParams.weaponId = id;
            }
         }
         if(left == 8)
         {
            if(Boolean(this.dressParams.hasOwnProperty("wingId")) && this.dressParams.wingId != 0)
            {
               if(this.dressParams.wingId == id)
               {
                  this.dressParams.wingId = 0;
               }
               else
               {
                  obj.id = id;
                  this.dressParams.wingId = id;
               }
            }
            else
            {
               this.dressParams.wingId = id;
            }
         }
         if(left == 6)
         {
            if(Boolean(this.dressParams.hasOwnProperty("glassId")) && this.dressParams.glassId != 0)
            {
               if(this.dressParams.glassId == id)
               {
                  this.dressParams.glassId = 0;
               }
               else
               {
                  obj.id = id;
                  this.dressParams.glassId = id;
               }
            }
            else
            {
               this.dressParams.glassId = id;
            }
         }
         if(left == 9)
         {
            if(Boolean(this.dressParams.hasOwnProperty("leftWeapon")) && this.dressParams.leftWeapon != 0)
            {
               if(this.dressParams.leftWeapon == id)
               {
                  this.dressParams.leftWeapon = 0;
               }
               else
               {
                  obj.id = id;
                  this.dressParams.leftWeapon = id;
               }
            }
            else
            {
               this.dressParams.leftWeapon = id;
            }
         }
         var flag:Boolean = GamePersonControl.instance.isFlyIngHorse(GameData.instance.playerData.horseID);
         flag = GameData.instance.playerData.horseID != 0 && !flag;
         this.roleFace.setRole(this.dressParams,"big",flag);
         this.isChange = true;
         this.gotoPage(this.currentPage);
      }
      
      public function setData() : void
      {
         if(GameData.instance.playerData.isVip)
         {
            if(GameData.instance.playerData.isSupertrump)
            {
               this.bg.vipClip.gotoAndStop("supervip");
            }
            else
            {
               this.bg.vipClip.gotoAndStop(GameData.instance.playerData.vipLevel);
            }
            this.bg.vipClip.visible = true;
         }
         else
         {
            this.bg.vipClip.visible = false;
         }
         if(bg)
         {
            this.bg.nameTxt.text = GameData.instance.playerData.userName;
         }
         this.initToolTip();
         if(GameData.instance.playerData.timeleft > 0 && GameData.instance.playerData.roleType > 9)
         {
            this.clockBtn.visible = true;
         }
         this.isChange = false;
         this.dressParams = GameData.instance.playerData;
         var flag:Boolean = GamePersonControl.instance.isFlyIngHorse(GameData.instance.playerData.horseID);
         flag = GameData.instance.playerData.horseID != 0 && !flag;
         this.roleFace.setRole(this.dressParams,"big",flag);
         this.horseRoundView.loadHorse(GameData.instance.playerData.horseID,GlobalConfig.userId);
         this.daojuList = GameData.instance.playerData.toolArr;
         this.materialList = GameData.instance.playerData.goodArr;
         this.presuresList = GameData.instance.playerData.presuresArr;
         this.zuoqiList = GameData.instance.playerData.zuoqiArr;
         this.daojuList.sortOn("sortValue",Array.NUMERIC);
         this.materialList.sortOn("sortValue",Array.NUMERIC);
         this.zuoqiList.sortOn("sortValue",Array.NUMERIC);
         bg.chooseClip.gotoAndStop(2);
         bg.coinTxt.text = GameData.instance.playerData.coin;
         var mlen:int = int(this.daojuList.length);
         for(var i:int = 0; i < mlen; i++)
         {
            if(this.daojuList[i].id == 100030)
            {
               bg.gcoinTxt.text = this.daojuList[i].count + "";
               this.daojuList.splice(i,1);
               break;
            }
         }
         this.onRBtns(null);
      }
      
      public function showZhuangbeiList(list:Array) : void
      {
         this.zhuangbeiList = list;
         this.zhuangbeiList.sortOn("sortValue",Array.NUMERIC);
      }
      
      private function fiilterHasDress(item:Object, idx:int, arr:Array) : Boolean
      {
         if(item.id == this.dressParams.hatid || item.id == this.dressParams.clothid || item.id == this.dressParams.footid || item.id == this.dressParams.weaponid || this.dressParams.faceId == item.id)
         {
            return false;
         }
         return true;
      }
      
      private function onClickPerson(evt:MouseEvent) : void
      {
         O.o(evt.currentTarget + "  " + evt.target);
      }
      
      private function onMenuBtn(evt:MouseEvent) : void
      {
         if(bg.getChildIndex(bg.menu) == 0)
         {
            this.menuUP();
         }
         else
         {
            this.menuDown();
         }
      }
      
      private function menuUP() : void
      {
         var tlist:Array = this.blist[bg.chooseClip.currentFrame];
         if(tlist.length <= 0)
         {
            return;
         }
         for(var j:int = 0; j < 9; j++)
         {
            bg.menu["btn" + j].visible = tlist[j] != null ? true : false;
            bg.menu["txt" + j].visible = tlist[j] != null ? true : false;
            bg.menu["txt" + j].text = tlist[j] != null ? tlist[j] : "";
         }
         bg.menu.bgmc.height = this.bgmcH - 24 * (9 - tlist.length);
         bg.setChildIndex(bg.menu,bg.numChildren - 1);
      }
      
      private function menuDown() : void
      {
         bg.setChildIndex(bg.menu,0);
         this.removePackClothesTool();
      }
      
      private function onRBtns(evt:MouseEvent) : void
      {
         var clist:Array = null;
         if(GameData.instance.playerData.sceneId == 10005 || GameData.instance.playerData.sceneId == 14000 || GameData.instance.playerData.sceneId == 1013 || GameData.instance.playerData.sceneId == 1018)
         {
            new FloatAlert().show(MapView.instance.stage,350,300,"当前场景无法查看背包道具(⊙o⊙)");
            return;
         }
         if(evt != null)
         {
            this.navigationIndex = int(evt.currentTarget.name.substring(4));
            this.currentPage = 1;
         }
         bg.chooseClip.gotoAndStop(this.navigationIndex);
         bg.menuTxt.text = this.alist[this.navigationIndex];
         if(this.navigationIndex == 7)
         {
            this.dispatchEvent(new Event(PackView.GET_LIMITS));
         }
         else if(this.navigationIndex == 6)
         {
            this.dispatchEvent(new Event(PackView.GET_SPIRIT_EQUIP));
         }
         else if(this.navigationIndex == 5)
         {
            this.dispatchEvent(new Event(PackView.ONCLICK_ZUOQI_TYPE));
         }
         else if(this.navigationIndex == 4)
         {
            this.dispatchEvent(new Event(PackView.GET_PRESURES));
         }
         else
         {
            clist = [this.zhuangbeiList,this.daojuList,this.materialList,this.presuresList,this.zuoqiList,this.spiritEquipList,this.limitsList];
            this.anlysisDataAndShow(clist[this.navigationIndex - 1]);
         }
      }
      
      public function onZuoQiListBack(obj:Object) : void
      {
         var zuoqi:Object = null;
         var limit:Object = null;
         var horseTip:HorseTip = HorseTipManager.getHorseTip();
         horseTip.ostime = obj.ostime;
         this.isOpen = true;
         this.zuoqiList = GameData.instance.playerData.zuoqiArr;
         this.zuoqiList.sortOn("sortValue",Array.NUMERIC);
         if(obj.flag == 0 && !GameData.instance.playerData.isInWarCraft && TaskList.getInstance().getStateOfSpecifiedTask(7012000) != 1)
         {
            if(GameData.instance.playerData.sceneType != 3)
            {
               this.dispatchEvent(new Event(PackView.OPEN_GONGGAO));
               return;
            }
         }
         for each(zuoqi in this.zuoqiList)
         {
            for each(limit in this.limitsList)
            {
               if(zuoqi.id == limit.sn && zuoqi.iid == limit.iid)
               {
                  zuoqi.ttype = limit.ttype;
                  zuoqi.sn = limit.sn;
                  zuoqi.expiretime = limit.expiretime;
                  zuoqi.systemtime = limit.systemtime;
               }
            }
         }
         if(TaskList.getInstance().getTaskBitStatus(1))
         {
            bg.chooseClip.gotoAndStop(5);
         }
         if(bg && bg.chooseClip.currentFrame == 5)
         {
            this.anlysisDataAndShow(this.zuoqiList);
         }
      }
      
      private function onBtns(evt:MouseEvent) : void
      {
         var obj:Object = null;
         var i:int = int(evt.currentTarget.name.substring(3));
         bg.menuTxt.text = bg.menu["txt" + i].text;
         var clist:Array = [this.zhuangbeiList,this.daojuList,this.materialList,this.presuresList,this.zuoqiList,this.spiritEquipList,this.limitsList];
         var target:Array = clist[bg.chooseClip.currentFrame - 1];
         var show_list:Array = [];
         for each(obj in target)
         {
            if(obj.hasOwnProperty("expiretime"))
            {
               this.xml = XMLLocator.getInstance().getTool(obj.iid);
            }
            else if(obj.hasOwnProperty("symmId"))
            {
               this.xml = XMLLocator.getInstance().getTool(obj.symmId);
            }
            else if(obj.hasOwnProperty("zuoId"))
            {
               this.xml = XMLLocator.getInstance().getTool(obj.zuoId);
            }
            else
            {
               this.xml = XMLLocator.getInstance().getTool(obj.id);
            }
            if(obj.type != null)
            {
               if(this.type_list[obj.type].indexOf(bg["menu"]["txt" + i].text) != -1)
               {
                  show_list.push(obj);
               }
            }
            else if(this.xml != null && this.xml.type != null && this.type_list[this.xml.type] != null)
            {
               if(this.type_list[this.xml.type].indexOf(bg["menu"]["txt" + i].text) != -1)
               {
                  show_list.push(obj);
               }
            }
         }
         this.anlysisDataAndShow(show_list);
      }
      
      private function onOverBtns(evt:MouseEvent) : void
      {
         var param:Object = null;
         var i:int = int(evt.currentTarget.name.substring(3));
         bg.menu["btn" + i].gotoAndStop(2);
         if(bg.menu["txt" + i].text == this.blist[1][1] || bg.menu["txt" + i].text == this.blist[1][2])
         {
            param = {};
            param.type = 0;
            param.list = GameData.instance.playerData.armsArr;
            if(bg.menu["txt" + i].text == this.blist[1][2])
            {
               param.type = 1;
            }
            PackClothesTool.Instance.initParams(param);
            if(Boolean(PackClothesTool.Instance.parent))
            {
               PackClothesTool.Instance.x = 700;
               PackClothesTool.Instance.y = 105;
            }
            else
            {
               PackClothesTool.Instance.show(this,700,105);
            }
            PackClothesTool.Instance.addEventListener("ShowSelectClothes",this.selectClothesHandler);
         }
         else
         {
            this.removePackClothesTool();
         }
      }
      
      private function selectClothesHandler(evt:MessageEvent) : void
      {
         var list:Array = evt.body as Array;
         if(list == null)
         {
            list = [];
         }
         this.anlysisDataAndShow(list);
      }
      
      private function removePackClothesTool() : void
      {
         PackClothesTool.Instance.parentRemove();
         PackClothesTool.Instance.removeEventListener("ShowSelectClothes",this.selectClothesHandler);
      }
      
      private function onOutBtns(evt:MouseEvent) : void
      {
         var i:int = int(evt.currentTarget.name.substring(3));
         bg.menu["btn" + i].gotoAndStop(1);
         if(!PackClothesTool.Instance.hitTestPoint(this.mouseX + 5,this.mouseY))
         {
            this.removePackClothesTool();
         }
      }
      
      public function openToolBatchUseView($toolData:Object) : void
      {
         var luopan:Object = null;
         var openedLuopan:Object = null;
         var obj:Object = null;
         if(Boolean(this.daojuList) && this.daojuList.length > 0)
         {
            for each(obj in this.daojuList)
            {
               if(obj.id == 103013)
               {
                  luopan = obj;
                  if(Boolean(openedLuopan))
                  {
                     break;
                  }
               }
               else if(obj.id == 103014)
               {
                  openedLuopan = obj;
                  if(Boolean(luopan))
                  {
                     break;
                  }
               }
            }
            if(Boolean(luopan))
            {
               ApplicationFacade.getInstance().dispatch(EventConst.OPEN_MODULE,{
                  "url":"assets/module/PackViewBatchUseView.swf",
                  "xCoord":0,
                  "yCoord":0,
                  "params":{
                     "luopan":luopan,
                     "openedLuopan":openedLuopan
                  }
               });
            }
            else
            {
               AlertManager.instance.showTipAlert({
                  "systemid":1063,
                  "flag":1
               });
            }
         }
         else
         {
            AlertManager.instance.showTipAlert({
               "systemid":1063,
               "flag":2
            });
         }
      }
      
      override public function disport() : void
      {
         if(GameData.instance.playerData.isNewHand == 3)
         {
            SpecialAreaManager.instance.removeNewHandMask();
            ApplicationFacade.getInstance().dispatch(EventConst.FRESHMANGUIDETOTASK,{"step":3});
         }
         this.disposBadge();
         CacheUtil.deleteObject(PackView);
         ApplicationFacade.getInstance().removeViewLogic(PackControl.NAME);
         super.disport();
      }
      
      public function setBadge(body:Object) : void
      {
         this.badge = new FamilyBadge();
         this.badge.setBadge(body.midid,body.smallid,body._name,body.midcolor,body.circolor,0.6);
         this.addChildAt(this.badge,this.numChildren);
         this.badge.x = 205;
         this.badge.y = 73;
         EventManager.attachEvent(this.badge,MouseEvent.CLICK,this.on_Click_Badge);
         var tips:String = HtmlUtil.getHtmlText(14,"#FF0000","【" + body.f_name + "】");
         ToolTip.setDOInfo(this.badge,tips);
      }
      
      private function on_Click_Badge(evt:MouseEvent) : void
      {
         if(GameData.instance.playerData.isInWarCraft)
         {
            new FloatAlert().show(MapView.instance.stage,350,300,"亲爱的小卡布,战场中是不可以进入家族基地哦(⊙o⊙)");
            return;
         }
         this.dispatchEvent(new Event(PackView.OPENFAMILYINFO));
      }
      
      private function disposBadge() : void
      {
         if(Boolean(this.badge) && this.contains(this.badge))
         {
            ToolTip.LooseDO(this.badge);
            EventManager.removeEvent(this.badge,MouseEvent.CLICK,this.on_Click_Badge);
            this.badge.dispos();
            this.badge = null;
         }
      }
      
      public function getHorseStateBack(obj:Object) : void
      {
         var i:int = 0;
         var len:int = 0;
         var item:PackItem = null;
         if(this.isOpen)
         {
            this.isOpen = false;
            for(i = 0; i < this.list.numChildren; i++)
            {
               item = this.list.getChildAt(i) as PackItem;
               if(item.data.packid == ItemType.zuoqiType)
               {
                  if(item.data.id == obj.id)
                  {
                     item.changeHp(obj.hp);
                     return;
                  }
               }
            }
            len = int(this.zuoqiList.length);
            for(i = 0; i < len; i++)
            {
               if(this.zuoqiList[i].id == obj.id)
               {
                  this.zuoqiList[i].hp = obj.hp;
                  break;
               }
            }
         }
      }
      
      public function useZuoQiToolBack(params:Object) : void
      {
         var zuoObj:Object = null;
         var item:PackItem = null;
         for(var i:int = 0; i < this.list.numChildren; i++)
         {
            item = this.list.getChildAt(i) as PackItem;
            if(item.data.packid == ItemType.zuoqiType)
            {
               if(item.data.id == params.zid)
               {
                  item.changeHp(params.code);
                  break;
               }
            }
         }
         for each(zuoObj in this.zuoqiList)
         {
            if(zuoObj.id == params.zid)
            {
               zuoObj.hp = params.code;
               break;
            }
         }
      }
      
      public function initToken(params:Object) : void
      {
         if(params != null && params.token != null)
         {
            bg.tokenTxt.text = params.token;
         }
      }
      
      public function initPresures() : void
      {
         PropertyPool.instance.getXML("config/","spirit_egg",this.loadEggCfgBack);
      }
      
      private function loadEggCfgBack(... args) : void
      {
         if(this.navigationIndex == 4)
         {
            this.presuresList = GameData.instance.playerData.presuresArr;
            this.anlysisDataAndShow(this.presuresList);
         }
      }
      
      public function initSpiritEquip(params:Object) : void
      {
         this.spiritEquipList = params.list;
         this.spiritEquipList.sortOn("sortValue",Array.NUMERIC);
         this.anlysisDataAndShow(this.spiritEquipList);
      }
      
      public function initLimitsList(params:Object) : void
      {
         this.limitsList = params.list;
         this.limitsList.sortOn("sortValue",Array.NUMERIC);
         if(bg && bg.chooseClip.currentFrame == 7)
         {
            this.anlysisDataAndShow(this.limitsList);
         }
      }
      
      public function renewLimitsBack(params:Object) : void
      {
         PackRenewTool.Instance.parentRemove();
      }
      
      private function initToolTip() : void
      {
         ToolTip.BindDO(this.bg.coinClip,"铜钱");
         ToolTip.BindDO(this.bg.kbcoinClip,"卡布币");
         ToolTip.BindDO(this.bg.gcoinClip,"娱乐币");
         ToolTip.BindDO(this.bg.tokenClip,"点券");
         ToolTip.BindDO(this.bg.leftBtn,"查看上一页");
         ToolTip.BindDO(this.bg.rightBtn,"查看下一页");
         ToolTip.BindDO(this.bg.rbtn1,"查看服装");
         ToolTip.BindDO(this.bg.rbtn2,"查看道具");
         ToolTip.BindDO(this.bg.rbtn3,"查看材料");
         ToolTip.BindDO(this.bg.rbtn4,"查看精魄");
         ToolTip.BindDO(this.bg.rbtn5,"查看坐骑");
         ToolTip.BindDO(this.bg.rbtn6,"查看灵玉");
         ToolTip.BindDO(this.bg.rbtn7,"查看限时物品");
         ToolTip.BindDO(this.bg.achievebtn,"打开成就界面");
         ToolTip.BindDO(this.bg.shipBtn,"打开飞船指引");
      }
      
      private function initTypeList() : void
      {
         this.type_list[0] = "全部";
         this.type_list[1] = "全部、头部";
         this.type_list[2] = "全部、身体";
         this.type_list[3] = "全部、手部";
         this.type_list[4] = "全部、脚部";
         this.type_list[6] = "全部、面部";
         this.type_list[8] = "全部、饰品";
         this.type_list[9] = "全部、手部";
         this.type_list[10] = "全部、套装";
         this.type_list[11] = "全部、套装、头部";
         this.type_list[12] = "全部、套装、身体";
         this.type_list[13] = "全部、套装、手部";
         this.type_list[14] = "全部、套装、脚部";
         this.type_list[16] = "全部、套装、面部";
         this.type_list[18] = "全部、套装、饰品";
         this.type_list[19] = "全部、套装、手部";
         this.type_list[20] = "全部、VIP套装";
         this.type_list[21] = "全部、VIP套装、头部";
         this.type_list[22] = "全部、VIP套装、身体";
         this.type_list[23] = "全部、VIP套装、手部";
         this.type_list[24] = "全部、VIP套装、脚部";
         this.type_list[26] = "全部、VIP套装、面部";
         this.type_list[28] = "全部、VIP套装、饰品";
         this.type_list[29] = "全部、VIP套装、手部";
         this.type_list[31] = "全部、战斗";
         this.type_list[32] = "全部、任务";
         this.type_list[33] = "全部、名字外框";
         this.type_list[34] = "全部、精元";
         this.type_list[35] = "全部、代币";
         this.type_list[36] = "全部、其它";
         this.type_list[41] = "全部、矿石";
         this.type_list[42] = "全部、植物";
         this.type_list[43] = "全部、气体";
         this.type_list[51] = "全部、陆行";
         this.type_list[52] = "全部、飞行";
         this.type_list[61] = "全部、培育获得";
         this.type_list[62] = "全部、获赠获得";
         this.type_list[63] = "全部、其它获得";
         this.type_list[71] = "全部、属性灵玉";
         this.type_list[72] = "全部、技能灵玉";
         this.type_list[81] = "全部、限时服装";
         this.type_list[82] = "全部、限时物品";
         this.type_list[83] = "全部、限时材料";
         this.type_list[84] = "全部、限时精魄";
         this.type_list[85] = "全部、限时坐骑";
         this.type_list[86] = "全部、限时灵玉";
      }
   }
}

