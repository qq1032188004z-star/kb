package com.game.modules.view.monster
{
   import com.core.observer.MessageEvent;
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.locators.GameData;
   import com.game.manager.AlertManager;
   import com.game.manager.EventManager;
   import com.game.modules.ai.SpecialAreaManager;
   import com.game.modules.control.monster.MonsterListControl;
   import com.game.modules.control.monster.MonsterListEvent;
   import com.game.modules.control.task.TaskList;
   import com.game.modules.control.trump.TrumpEvent;
   import com.game.modules.view.HorseTipManager;
   import com.game.modules.view.item.MonsterItem;
   import com.game.modules.view.item.PackItem;
   import com.game.modules.view.item.SkillItem;
   import com.game.modules.view.trump.TrumpTrainCourse;
   import com.game.util.ArrayPageIterator;
   import com.game.util.BitValueUtil;
   import com.game.util.CacheUtil;
   import com.game.util.ColorUtil;
   import com.game.util.FarmServerUtil;
   import com.game.util.GamePersonControl;
   import com.game.util.HLoaderSprite;
   import com.game.util.HtmlUtil;
   import com.game.util.PropertyPool;
   import com.game.util.TimeTransform;
   import com.kb.util.CommonDefine;
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.alert.Alert;
   import com.publiccomponent.events.ItemClickEvent;
   import com.publiccomponent.list.CircleList;
   import com.publiccomponent.list.ItemRender;
   import com.publiccomponent.list.TileList;
   import com.publiccomponent.loading.GreenLoading;
   import com.publiccomponent.loading.XMLLocator;
   import com.publiccomponent.ui.Label;
   import com.publiccomponent.ui.ToolTip;
   import com.xygame.module.battle.util.DeepCopy;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.utils.clearTimeout;
   import flash.utils.getQualifiedClassName;
   import flash.utils.setTimeout;
   import sound.SoundManager;
   
   public class MonsterListView extends HLoaderSprite
   {
      
      public static var currentHp:int;
      
      public static var maxHp:int;
      
      public static var ff:Boolean;
      
      public static var curerentId:int;
      
      public static var plist:TileList;
      
      public var monster:MovieClip;
      
      public var templist:Array;
      
      public var params:Object;
      
      private var mList:CircleList;
      
      private var skillList:TileList;
      
      private var unableskillList:TileList;
      
      private var symmList:TileList;
      
      public var selectData:Object;
      
      private var menuStatus:Number = 1;
      
      private var mloader:Loader;
      
      private var mcarr:Array = [];
      
      private var daojuList:Array = [];
      
      private var currentPageList:Array = [];
      
      private var propsId:int;
      
      private const pageNum:int = 12;
      
      private var label:Label;
      
      private var btnControl:int = 1118481;
      
      private var selectIndex:int = -1;
      
      private var monsterToolXml:XML;
      
      private var symmType:int = 0;
      
      private var symmData:Array;
      
      private var currentIte:ArrayPageIterator;
      
      private var currentWear:Array = [];
      
      private var currentPropPage:int = 1;
      
      private var countPropPage:int;
      
      private var toolus:int = 0;
      
      private var predata:Object;
      
      private var aftdata:Object;
      
      private var usePropState:Boolean = true;
      
      private var useStateCd:int;
      
      private var chooseCourseView:TrumpTrainCourse;
      
      public var selectTrainData:Object;
      
      private var usedtoolbool:Boolean = false;
      
      private var dealShow:Boolean = true;
      
      private var isAlertShowing:Boolean;
      
      private var allskillcount:int;
      
      private var tempallskilllist:Array = [];
      
      private var tempid:int;
      
      public function MonsterListView()
      {
         super();
         GreenLoading.loading.visible = true;
         this.mList = new CircleList(138,408);
         this.mList.build(6,1,110,110,-11,-11,MonsterItem);
         this.skillList = new TileList(385,152);
         this.skillList.build(2,2,140,40,13,2,SkillItem);
         this.unableskillList = new TileList(385,242);
         this.unableskillList.build(2,2,140,40,13,2,SkillItem);
         this.cacheAsBitmap = true;
         plist = new TileList(386,150);
         plist.build(4,3,68,58,1,13,PackItem);
         plist.addEventListener(ItemClickEvent.ITEMCLICKEVENT,this.onItemClick,true);
         this.symmList = new TileList(387,195);
         this.symmList.build(4,2,68,58,1,13,PackItem);
         this.symmList.addEventListener(ItemClickEvent.ITEMCLICKEVENT,this.onItemClick,true);
         this.visible = false;
         this.loadToolConfig();
      }
      
      private function loadToolConfig() : void
      {
         PropertyPool.instance.getXML("config/","monster_tool",this.loadXmlComplete);
      }
      
      private function loadXmlComplete(... params) : void
      {
         this.monsterToolXml = params[0];
         this.url = "assets/material/monsterlist.swf";
      }
      
      override public function setShow() : void
      {
         this.monster = this.bg;
         this.monster.cacheAsBitmap = true;
         this.label = new Label(85,190);
         this.label.mouseChildren = false;
         this.label.mouseEnabled = false;
         this.label.labelTxt.width = 220;
         this.label.labelTxt.height = 140;
         this.label.labelTxt.wordWrap = true;
         this.addChild(this.monster);
         this.addChild(this.mList);
         this.addChild(this.skillList);
         this.addChild(this.unableskillList);
         this.addChild(plist);
         this.addChild(this.symmList);
         this.addChild(this.label);
         this.mloader = new Loader();
         this.mloader.mouseChildren = false;
         this.mloader.mouseEnabled = false;
         this.monster.infoMc.symm.skill.mouseEnabled = false;
         this.monster.infoMc.symm.tary.mouseEnabled = false;
         this.monster.taryIcon.visible = false;
         this.monster.skillIcon.visible = false;
         this.monster.nataveIcon.gotoAndStop(7);
         this.mcarr = [this.monster.infoMc.infoitem1,this.monster.infoMc.infoitem2,this.monster.infoMc.infoitem3,this.monster.infoMc.propsMc,this.monster.infoMc.symm];
         this.monster.infoMc.symm.mouseEnabled = false;
         this.initEvent();
         this.initmcStop();
         ApplicationFacade.getInstance().registerViewLogic(new MonsterListControl(this));
         GreenLoading.loading.visible = false;
         this.monster.infoMc.infoitem1.needExpTxt.scaleX = 0.9;
         this.monster.infoMc.infoitem1.needExpTxt.scaleY = 0.9;
      }
      
      public function setdata(daoju:Object) : void
      {
         var tl:Array = null;
         if(daoju != null)
         {
            tl = daoju.goods;
            this.daojuList = tl.filter(this.isNotZero);
            this.toolFenyeShow();
            return;
         }
      }
      
      private function isNotZero(element:*, index:int, arr:Array) : Boolean
      {
         return element.id !== 0;
      }
      
      public function setSymmData(symmObj:Array) : void
      {
         this.symmData = symmObj;
         this.setSymmStyle(this.symmType);
      }
      
      private function setSymmStyle(type:int) : void
      {
         var currentList:Array = null;
         var symmObj:Object = null;
         if(this.symmData == null)
         {
            dispatchEvent(new MonsterListEvent(MonsterListEvent.GETSYMMPAKAGELIST));
         }
         else
         {
            currentList = [];
            for each(symmObj in this.symmData)
            {
               if(symmObj.symmFlag == 0 && SymmEnum.getSymmTye(symmObj.symmType) == this.symmType)
               {
                  currentList.push(symmObj);
               }
            }
            this.currentIte = new ArrayPageIterator(currentList,8);
            this.symmRender(this.currentIte.curentPageList());
         }
      }
      
      public function symmOffandWear(id:int, newSymm:int = 0, oldSymm:int = 0) : void
      {
         if(this.symmData == null)
         {
            return;
         }
         var flag:Boolean = true;
         flag = newSymm == 0 ? false : this.setSymmOff(newSymm,id);
         flag = oldSymm == 0 ? false : this.setSymmOff(oldSymm);
         if(!flag)
         {
            this.setSymmStyle(this.symmType);
         }
      }
      
      private function setSymmOff(symmIndex:int, symmFlag:int = 0) : Boolean
      {
         var symmObj:Object = null;
         if(symmIndex == 0)
         {
            return true;
         }
         for each(symmObj in this.symmData)
         {
            if(symmObj.symmIndex == symmIndex)
            {
               symmObj.symmFlag = symmFlag;
               return false;
            }
         }
         return true;
      }
      
      private function symmNext() : void
      {
         if(this.currentIte == null)
         {
            return;
         }
         if(this.currentIte.hasNextPage())
         {
            this.symmRender(this.currentIte.nextPage());
         }
      }
      
      private function symmFront() : void
      {
         if(this.currentIte == null)
         {
            return;
         }
         if(this.currentIte.hasFrontPage())
         {
            this.symmRender(this.currentIte.frontPage());
         }
      }
      
      private function symmRender(data:Array) : void
      {
         this.monster.infoMc.symm.pageTxt.text = this.currentIte.currentPage + "";
         this.monster.infoMc.symm.accountPageTxt.text = this.currentIte.totalPageLength + "";
         this.symmList.dataProvider = data;
      }
      
      public function setSelectedData(list:Array) : void
      {
         var symmObj:Object = null;
         var backObj:Object = null;
         if(this.selectData == null)
         {
            return;
         }
         if(this.selectData.hasOwnProperty("symmList"))
         {
            for each(symmObj in this.selectData.symmList)
            {
               for each(backObj in list)
               {
                  if(symmObj.symmIndex == backObj.symmIndex)
                  {
                     symmObj.nativeList = backObj.nativeList;
                     if(symmObj.symmPlace == 2)
                     {
                        this.setNative(symmObj,true);
                        break;
                     }
                  }
               }
            }
         }
      }
      
      private function onNativeIconMouseDown(e:MouseEvent) : void
      {
         var list:Array = null;
         var symmObj:Object = null;
         e.stopImmediatePropagation();
         if(this.selectData == null)
         {
            return;
         }
         if(e.currentTarget.currentFrame == e.currentTarget.totalFrames)
         {
            return;
         }
         if(this.selectData.hasOwnProperty("symmList"))
         {
            list = this.selectData.symmList;
            for each(symmObj in list)
            {
               if(symmObj.symmPlace == 2 && e.currentTarget == this.monster.nataveIcon)
               {
                  dispatchEvent(new MessageEvent(MonsterListEvent.SYMM_WEAR_OR_OFF,{
                     "code":2,
                     "iid":this.selectData.id,
                     "symmIndex":symmObj.symmIndex
                  }));
                  return;
               }
            }
         }
      }
      
      private function toolFenyeShow() : void
      {
         var minIndex:int = (this.currentPropPage - 1) * 12;
         var maxIndex:int = this.currentPropPage * 12;
         this.countPropPage = Math.ceil(this.daojuList.length / this.pageNum);
         if(Boolean(this.daojuList))
         {
            this.daojuList.sortOn("sortValue",Array.NUMERIC);
         }
         if(maxIndex > this.daojuList.length && minIndex < this.daojuList.length)
         {
            this.currentPageList = this.daojuList.slice(minIndex);
         }
         else if(maxIndex <= this.daojuList.length)
         {
            maxIndex = this.currentPropPage * 12;
            this.currentPageList = this.daojuList.slice(minIndex,maxIndex);
         }
         else
         {
            if(minIndex >= 12)
            {
               minIndex -= 12;
               maxIndex = (this.currentPropPage - 1) * 12;
               this.currentPropPage -= 1;
            }
            this.currentPageList = this.daojuList.slice(minIndex,maxIndex);
         }
         if(Boolean(this.currentPageList))
         {
            plist.dataProvider = this.currentPageList;
         }
      }
      
      private function getToolnameById(id:int) : String
      {
         var toolname:String = "";
         var xml:XML = XMLLocator.getInstance().getTool(id);
         if(Boolean(xml))
         {
            toolname = xml.name + "";
            this.toolus = int(xml.useState);
         }
         return toolname;
      }
      
      private function onItemClick(evt:ItemClickEvent) : void
      {
         var canuser:Boolean = false;
         var toolType:int = 0;
         var xml:XML = null;
         var item:MonsterItem = null;
         var num:int = 0;
         var j:int = 0;
         var obj:MonsterItem = null;
         var symmItem:ItemRender = null;
         SoundManager.instance.iconClick(5);
         if(evt.currentTarget == plist)
         {
            evt.stopImmediatePropagation();
            this.propsId = evt.params.id;
            if(this.selectData == null)
            {
               AlertManager.instance.showTipAlert({
                  "systemid":1058,
                  "flag":1
               });
               return;
            }
            if(evt.params.count <= 0)
            {
               AlertManager.instance.showTipAlert({
                  "systemid":1058,
                  "flag":2
               });
               return;
            }
            canuser = true;
            if(this.propsId == 100037 && this.selectData.level == 1)
            {
               AlertManager.instance.showTipAlert({
                  "systemid":1058,
                  "flag":7
               });
               canuser = false;
            }
            else if(this.propsId == 100453 || this.propsId == 100454)
            {
               if(this.selectData.forbitItem == this.propsId)
               {
                  AlertManager.instance.showTipAlert({
                     "systemid":1058,
                     "flag":this.propsId,
                     "params":this.selectData.forbitItem
                  });
               }
               else
               {
                  AlertManager.instance.showTipAlert({
                     "systemid":1058,
                     "flag":this.propsId,
                     "params":this.selectData.forbitItem,
                     "defaultTip":true,
                     "callback":this.useProps,
                     "data":evt.params
                  });
               }
               canuser = false;
            }
            else if(this.propsId == 100455)
            {
               if(this.selectData.forbitItem == 100453 || this.selectData.forbitItem == 100454)
               {
                  AlertManager.instance.showTipAlert({
                     "systemid":1058,
                     "flag":this.propsId,
                     "params":this.selectData.forbitItem,
                     "defaultTip":true,
                     "callback":this.useProps,
                     "data":evt.params
                  });
               }
               else
               {
                  AlertManager.instance.showTipAlert({
                     "systemid":1058,
                     "flag":this.propsId,
                     "params":this.selectData.forbitItem,
                     "defaultTip":true
                  });
               }
               canuser = false;
            }
            else if((this.propsId == 100035 || this.propsId >= 100111 && this.propsId <= 100116 || this.propsId >= 100210 && this.propsId <= 100215 || this.propsId >= 100504 && this.propsId <= 100509) && this.selectData.level == 100)
            {
               AlertManager.instance.showTipAlert({
                  "systemid":1058,
                  "flag":5
               });
               canuser = false;
            }
            else
            {
               xml = this.monsterToolXml.children().(@id == propsId)[0];
               if(Boolean(xml))
               {
                  toolType = int(xml.type);
                  if(toolType == 1)
                  {
                     if(MonsterListView.currentHp == MonsterListView.maxHp)
                     {
                        AlertManager.instance.showTipAlert({
                           "systemid":1058,
                           "flag":3
                        });
                        canuser = false;
                     }
                  }
                  else if(toolType == 2)
                  {
                     if(!this.checkSkill())
                     {
                        AlertManager.instance.showTipAlert({
                           "systemid":1058,
                           "flag":4
                        });
                        canuser = false;
                     }
                  }
                  else if(toolType == 3 || toolType == 4 || toolType == 5)
                  {
                     if(this.selectData.level >= 100)
                     {
                        AlertManager.instance.showTipAlert({
                           "systemid":1058,
                           "flag":6
                        });
                        canuser = false;
                     }
                  }
               }
            }
            if(canuser)
            {
               if(BitValueUtil.getBitValue(evt.params.usableStatus,23))
               {
                  if(this.selectData.forbitItem == 100453)
                  {
                     this.toolus = 0;
                     AlertManager.instance.showTipAlert({
                        "systemid":1058,
                        "flag":8
                     });
                  }
                  else if(this.selectData.forbitItem == 100454 && this.propsId != 100036)
                  {
                     this.toolus = 0;
                     AlertManager.instance.showTipAlert({
                        "systemid":1058,
                        "flag":9
                     });
                  }
                  else
                  {
                     this.userPropsAlert(evt.params);
                  }
               }
               else if(BitValueUtil.getBitValue(evt.params.usableStatus,22))
               {
                  this.toolus = 0;
                  this.useProps("确定",evt.params);
               }
               else
               {
                  this.userPropsAlert(evt.params);
               }
            }
         }
         if(evt.currentTarget == this.mList)
         {
            evt.preventDefault();
            item = evt.target as MonsterItem;
            if(item == null)
            {
               return;
            }
            num = this.mList.numChildren;
            for(j = 0; j < num; j++)
            {
               obj = this.mList.getChildAt(j) as MonsterItem;
               if(obj.data.id != item.data.id)
               {
                  this.monster["m" + j].gotoAndStop(1);
                  if(obj.data.isfirst == 1)
                  {
                     obj.setSelect(3);
                  }
                  else
                  {
                     obj.setSelect(1);
                  }
               }
               else
               {
                  this.selectIndex = obj.data.id;
                  this.monster["m" + j].gotoAndStop(2);
                  if(obj.data.isfirst == 1)
                  {
                     obj.setSelect(3);
                     this.enableBtn();
                     this.monster.firstBtn.filters = ColorUtil.getColorMatrixFilterGray();
                     this.monster.firstBtn.mouseEnabled = false;
                  }
                  else
                  {
                     this.monster.firstBtn.filters = [];
                     this.monster.firstBtn.mouseEnabled = true;
                     this.enableBtn();
                     obj.setSelect(2);
                  }
               }
            }
            this.setMonsterInfo(item.data);
         }
         else if(evt.currentTarget == this.symmList)
         {
            evt.stopImmediatePropagation();
            symmItem = evt.target as ItemRender;
            if(symmItem == null)
            {
               return;
            }
            if(this.selectData == null)
            {
               AlertManager.instance.showTipAlert({
                  "systemid":1058,
                  "flag":1
               });
            }
            else
            {
               dispatchEvent(new MessageEvent(MonsterListEvent.SYMM_WEAR_OR_OFF,{
                  "code":1,
                  "iid":this.selectData.id,
                  "symmIndex":symmItem.data.symmIndex
               }));
            }
         }
      }
      
      private function userPropsAlert(data:Object) : void
      {
         var name:String = this.getToolnameById(this.propsId);
         new Alert().showSureOrCancel("确定要对" + this.selectData.name + "使用" + name + "?",this.useProps,data);
      }
      
      private function useProps(str:String, data:Object) : void
      {
         if(this.usePropState && str == "确定")
         {
            this.usePropState = false;
            clearTimeout(this.useStateCd);
            this.useStateCd = setTimeout(this.changeUseState,1000);
            this.predata = DeepCopy.copy(this.selectData);
            if(BitValueUtil.getBitValue(this.toolus,15))
            {
               this.menuStatus = 1;
            }
            else if(BitValueUtil.getBitValue(this.toolus,16))
            {
               this.menuStatus = 2;
            }
            else if(BitValueUtil.getBitValue(this.toolus,17))
            {
               this.menuStatus = 3;
            }
            this.usedtoolbool = true;
            if(BitValueUtil.getBitValue(data.usableStatus,21))
            {
               ApplicationFacade.getInstance().dispatch(EventConst.USEPROPS,{
                  "prosid":this.propsId,
                  "jinghunid":MonsterListView.curerentId,
                  "gongneng":1,
                  "temp1":this.selectData.iid,
                  "temp2":1
               });
            }
            else
            {
               ApplicationFacade.getInstance().dispatch(EventConst.USEPROPS,{
                  "prosid":this.propsId,
                  "jinghunid":MonsterListView.curerentId,
                  "gongneng":1,
                  "temp1":this.selectData.iid,
                  "temp2":0
               });
            }
            if(this.menuStatus == 4)
            {
               this.propsShow(null);
            }
         }
         else
         {
            this.propsId = 0;
         }
      }
      
      private function changeUseState() : void
      {
         clearTimeout(this.useStateCd);
         this.usePropState = true;
      }
      
      private function initmcStop() : void
      {
         this.hideMC(this.monster.infoMc.infoitem1);
         this.monster.btnMc.gotoAndStop(1);
         this.monster.groupClip.gotoAndStop(1);
      }
      
      private function initMcStop() : void
      {
         EventManager.attachEvent(this.monster.infoMc.infoitem3.lastPageBtn,MouseEvent.MOUSE_DOWN,this.lastpageHandle);
         EventManager.attachEvent(this.monster.infoMc.infoitem3.nextPageBtn,MouseEvent.MOUSE_DOWN,this.nextpageHandle);
      }
      
      public function initToolTip() : void
      {
         TaskList.getInstance().checkUrlAndFreshManTask(url);
         if(this.monster != null)
         {
            if(this.monster.changeClip.currentFrame == 1)
            {
               ToolTip.setDOInfo(this.monster.changeClip,HtmlUtil.getHtmlText(12,"#000000","放入背包"));
            }
            else
            {
               ToolTip.setDOInfo(this.monster.changeClip,HtmlUtil.getHtmlText(12,"#000000","跟随"));
            }
            ToolTip.setDOInfo(this.monster.cureBtn,HtmlUtil.getHtmlText(12,"#000000","治疗妖怪"));
            ToolTip.setDOInfo(this.monster.gcBtn,HtmlUtil.getHtmlText(12,"#000000","放入仓库"));
            ToolTip.setDOInfo(this.monster.firstBtn,HtmlUtil.getHtmlText(12,"#000000","设为首选"));
            ToolTip.setDOInfo(this.monster.farmHoldBtn,HtmlUtil.getHtmlText(12,"#000000","驻守庄园"));
            ToolTip.setDOInfo(this.monster.storageBtn,HtmlUtil.getHtmlText(12,"#000000","妖怪仓库"));
            ToolTip.setDOInfo(this.monster.trainBtn,HtmlUtil.getHtmlText(12,"#000000","训练"));
            ToolTip.setDOInfo(this.monster.nataveIcon,"属性灵玉装备槽");
            ToolTip.BindDO(this.monster.dragClip,"点击可拖动界面");
         }
      }
      
      private function initEvent() : void
      {
         EventManager.attachEvent(this.mList,ItemClickEvent.ITEMCLICKEVENT,this.onItemClick,true);
         EventManager.attachEvent(this.monster.closeBtn,MouseEvent.CLICK,this.closeWindow);
         EventManager.attachEvent(this.monster.infoMc.propsMc.lastPropBtn,MouseEvent.CLICK,this.lastPropHandle);
         EventManager.attachEvent(this.monster.infoMc.propsMc.nextPropBtn,MouseEvent.CLICK,this.nextPropHandle);
         EventManager.attachEvent(this.monster.nataveIcon,MouseEvent.MOUSE_DOWN,this.onNativeIconMouseDown);
      }
      
      private function removeEvent() : void
      {
         ToolTip.removeToolTip();
         EventManager.removeEvent(this.mList,ItemClickEvent.ITEMCLICKEVENT,this.onItemClick);
         EventManager.removeEvent(this.monster.closeBtn,MouseEvent.CLICK,this.closeWindow);
         EventManager.removeEvent(this.monster.infoMc.propsMc.lastPropBtn,MouseEvent.CLICK,this.lastPropHandle);
         EventManager.removeEvent(this.monster.infoMc.propsMc.nextPropBtn,MouseEvent.CLICK,this.nextPropHandle);
         EventManager.removeEvent(this.monster.infoMc.infoitem3.lastPageBtn,MouseEvent.MOUSE_DOWN,this.lastpageHandle);
         EventManager.removeEvent(this.monster.infoMc.infoitem3.nextPageBtn,MouseEvent.MOUSE_DOWN,this.nextpageHandle);
         EventManager.removeEvent(this.monster.storageBtn,MouseEvent.MOUSE_DOWN,this.openStorage);
         EventManager.removeEvent(this.monster.changeClip,MouseEvent.MOUSE_DOWN,this.changeMonsterState);
         EventManager.removeEvent(this.monster.cureBtn,MouseEvent.MOUSE_DOWN,this.cureAllMonster);
         EventManager.removeEvent(this.monster.farmHoldBtn,MouseEvent.MOUSE_DOWN,this.farmHold);
         EventManager.removeEvent(this.monster.gcBtn,MouseEvent.MOUSE_DOWN,this.gcMonster);
         EventManager.removeEvent(this.monster.firstBtn,MouseEvent.MOUSE_DOWN,this.setFirst);
         EventManager.removeEvent(this.monster.trainBtn,MouseEvent.MOUSE_DOWN,this.trainMonster);
         EventManager.removeEvent(this.monster.btnInfo,MouseEvent.MOUSE_DOWN,this.onMouseDownHandler);
         EventManager.removeEvent(this.monster.btnItem,MouseEvent.MOUSE_DOWN,this.onMouseDownHandler);
         EventManager.removeEvent(this.monster.btnSkill,MouseEvent.MOUSE_DOWN,this.onMouseDownHandler);
         EventManager.removeEvent(this.monster.toolBtn,MouseEvent.MOUSE_DOWN,this.onMouseDownHandler);
         EventManager.removeEvent(this.monster.symmBtn,MouseEvent.MOUSE_DOWN,this.onMouseDownHandler);
         EventManager.removeEvent(this.monster.infoMc.symm,MouseEvent.MOUSE_DOWN,this.onSymmMouseDown);
         EventManager.removeEvent(this.chooseCourseView,TrumpEvent.TRAINSETCOURSEBACK,this.onTrainCourseBack);
      }
      
      private function onMouseDownHandler(e:MouseEvent) : void
      {
         e.stopImmediatePropagation();
         HorseTipManager.getBatchUseTip().onRollOutHandler(null);
         switch(e.currentTarget)
         {
            case this.monster.btnInfo:
               this.infoShow(e);
               break;
            case this.monster.btnItem:
               this.itemShow(e);
               break;
            case this.monster.btnSkill:
               this.skillShow(e);
               break;
            case this.monster.toolBtn:
               this.propsShow(e);
               break;
            case this.monster.symmBtn:
               this.symmShow(e);
         }
      }
      
      private function lastPropHandle(evt:Event) : void
      {
         if(this.currentPropPage - 1 > 0)
         {
            --this.currentPropPage;
            this.toolFenyeShow();
         }
      }
      
      private function nextPropHandle(evt:Event) : void
      {
         if(this.currentPropPage + 1 <= this.countPropPage)
         {
            ++this.currentPropPage;
            this.toolFenyeShow();
         }
      }
      
      private function lastpageHandle(evt:Event) : void
      {
         var m:int = 0;
         var n:int = 0;
         if(int(this.monster.infoMc.infoitem3.pageTxt.text) > 1)
         {
            m = int(this.monster.infoMc.infoitem3.pageTxt.text);
            n = --m;
            this.monster.infoMc.infoitem3.pageTxt.text = n + "";
            this.setunableSkillList(this.tempallskilllist);
            return;
         }
      }
      
      private function nextpageHandle(evt:Event) : void
      {
         var i:int = 0;
         var j:int = 0;
         if(int(this.monster.infoMc.infoitem3.pageTxt.text) < this.allskillcount)
         {
            i = int(this.monster.infoMc.infoitem3.pageTxt.text);
            j = ++i;
            this.monster.infoMc.infoitem3.pageTxt.text = j + "";
            this.setunableSkillList(this.tempallskilllist);
            return;
         }
      }
      
      private function enableBtn() : void
      {
         var temp:int = 0;
         if(GameData.instance.playerData.isInWarCraft)
         {
            this.btnControl &= 1118208;
         }
         else if(GameData.instance.playerData.bobOwner == 1)
         {
            this.btnControl &= 69632;
         }
         else if(GameData.instance.playerData.bobOwner == 2)
         {
            this.btnControl &= 1118208;
         }
         else if(GameData.instance.playerData.copyScene != 0)
         {
            this.btnControl &= 1118208;
         }
         var btnArr:Array = [this.monster.firstBtn,this.monster.changeClip,this.monster.cureBtn,this.monster.storageBtn,this.monster.trainBtn,this.monster.gcBtn];
         for(var i:int = 0; i < btnArr.length; i++)
         {
            temp = this.btnControl >> (5 - i) * 4;
            if(Boolean(temp & 1 != 0))
            {
               btnArr[i].filters = [];
               btnArr[i].mouseEnabled = true;
            }
            else
            {
               btnArr[i].filters = ColorUtil.getColorMatrixFilterGray();
               btnArr[i].mouseEnabled = false;
            }
         }
         this.monster.infoMc.infoitem1.expBarMc.visible = true;
      }
      
      private function trainMonster(evt:MouseEvent) : void
      {
         var flag:int = 0;
         if(this.params.monsterlist.length <= 1)
         {
            AlertManager.instance.showTipAlert({
               "systemid":1059,
               "flag":1
            });
            return;
         }
         if(this.selectData == null || this.selectData.iid == null)
         {
            AlertManager.instance.showTipAlert({
               "systemid":1059,
               "flag":2
            });
            return;
         }
         if(int(this.selectData.level) >= 100)
         {
            flag = this.selectData.hpLearnValue + this.selectData.attackLearnValue + this.selectData.defenceLearnValue + this.selectData.magicLearnValue + this.selectData.resistanceLearnValue + this.selectData.speedLearnVale;
            if(flag >= 510)
            {
               AlertManager.instance.showTipAlert({
                  "systemid":1059,
                  "flag":3
               });
               return;
            }
         }
         this.selectTrainData = {};
         this.selectTrainData = this.selectData;
         this.chooseCourseView = new TrumpTrainCourse();
         this.chooseCourseView.initParams(this.selectTrainData);
         this.chooseCourseView.x = -115;
         this.chooseCourseView.y = 25;
         addChild(this.chooseCourseView);
         EventManager.attachEvent(this.chooseCourseView,TrumpEvent.TRAINSETCOURSEBACK,this.onTrainCourseBack);
      }
      
      private function onTrainCourseBack(evt:MessageEvent) : void
      {
         EventManager.removeEvent(this.chooseCourseView,TrumpEvent.TRAINSETCOURSEBACK,this.onTrainCourseBack);
         var course:Array = evt.body.course as Array;
         var list:Array = [];
         list[0] = this.selectTrainData.id;
         list[1] = course.length;
         list = list.concat(course);
         this.dispatchEvent(new MessageEvent(EventConst.TRIPODTRAIN,list));
      }
      
      private function openStorage(evt:Event) : void
      {
         var obj:Object = {
            "showX":-10,
            "showY":-30
         };
         ApplicationFacade.getInstance().dispatch(EventConst.BOBSTATECLICK,{
            "url":"assets/module/MonsterStorageModule.swf",
            "xCoord":0,
            "yCoord":0
         });
      }
      
      private function farmHold(evt:MouseEvent) : void
      {
         if(this.selectData == null || this.selectData.iid == null)
         {
            AlertManager.instance.showTipAlert({
               "systemid":1060,
               "flag":1
            });
         }
         else
         {
            AlertManager.instance.showTipAlert({
               "systemid":1060,
               "flag":2,
               "replace":this.selectData.name,
               "callback":this.holdFarmHandler
            });
         }
      }
      
      private function holdFarmHandler(... rest) : void
      {
         if(rest[0] == "确定")
         {
            if(this.monster.changeClip.currentFrame == 1)
            {
               EventManager.dispatch(this,new MonsterListEvent(MonsterListEvent.GETMONSTERINLIST,this.selectData));
            }
            this.clearSelect();
            FarmServerUtil.Instance.sendCmd(FarmServerUtil.REQ_MONSTER_HOLD.send,[this.selectData.id],this.closeWindow);
         }
      }
      
      private function infoShow(evt:Event) : void
      {
         if(Boolean(evt) || this.dealShow)
         {
            this.dealShow = false;
            this.menuStatus = 1;
            this.monster.btnMc.gotoAndStop(1);
            this.monster.infoMc.visible = true;
            this.monster.btnMc.gotoAndStop(1);
            this.hideMC(this.monster.infoMc.infoitem1);
            plist.visible = false;
            this.skillList.visible = false;
            this.symmList.visible = false;
            this.unableskillList.visible = false;
            if(this.selectData != null)
            {
               this.setMonsterInfo(this.selectData);
            }
         }
      }
      
      public function openBatchUseProp($itemVo:Object) : void
      {
         var toolCfg:XML = null;
         var monsterList:Array = this.params.monsterlist;
         if(Boolean(monsterList) && monsterList.length > 0)
         {
            toolCfg = this.monsterToolXml.children().(@id == $itemVo.id)[0];
            if(Boolean(toolCfg))
            {
               ApplicationFacade.getInstance().dispatch(EventConst.OPEN_MODULE,{
                  "url":"assets/module/BatchUsePropView.swf",
                  "xCoord":0,
                  "yCoord":0,
                  "params":{
                     "monsterlist":monsterList,
                     "itemVo":$itemVo,
                     "select":this.selectData,
                     "toolCfg":toolCfg
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
      
      private function hideMC(mc:MovieClip) : void
      {
         for(var i:int = 0; i < this.mcarr.length; i++)
         {
            if(this.mcarr[i] == mc)
            {
               mc.visible = true;
            }
            else
            {
               this.mcarr[i].visible = false;
            }
         }
      }
      
      private function itemShow(evt:Event) : void
      {
         this.monster.infoMc.visible = true;
         this.hideMC(this.monster.infoMc.infoitem2);
         this.monster.btnMc.gotoAndStop(2);
         this.menuStatus = 2;
         plist.visible = false;
         this.skillList.visible = false;
         this.unableskillList.visible = false;
         this.symmList.visible = false;
         if(this.selectData != null)
         {
            this.setMonsterInfo(this.selectData);
         }
      }
      
      private function skillShow(evt:Event) : void
      {
         this.monster.infoMc.visible = true;
         this.hideMC(this.monster.infoMc.infoitem3);
         this.monster.btnMc.gotoAndStop(3);
         this.menuStatus = 3;
         this.skillList.visible = true;
         this.initMcStop();
         plist.visible = false;
         this.symmList.visible = false;
         this.unableskillList.visible = true;
         if(this.selectData != null)
         {
            this.setMonsterInfo(this.selectData);
         }
      }
      
      private function propsShow(evt:Event) : void
      {
         this.skillList.visible = false;
         this.unableskillList.visible = false;
         this.symmList.visible = false;
         plist.visible = true;
         this.hideMC(this.monster.infoMc.propsMc);
         this.monster.btnMc.gotoAndStop(4);
         this.menuStatus = 4;
         if(evt != null)
         {
            this.propsId = 0;
            ApplicationFacade.getInstance().dispatch(EventConst.GETPROPSLIST,513);
         }
      }
      
      private function symmShow(evt:Event = null) : void
      {
         this.skillList.visible = false;
         this.unableskillList.visible = false;
         plist.visible = false;
         this.symmList.visible = true;
         this.hideMC(this.monster.infoMc.symm);
         this.monster.btnMc.gotoAndStop(5);
         this.monster.infoMc.symm.title.gotoAndStop(1);
         this.menuStatus = 5;
         this.symmType = 2;
         dispatchEvent(new MonsterListEvent(MonsterListEvent.GETSYMMPAKAGELIST));
      }
      
      private function onSymmMouseDown(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         switch(evt.target)
         {
            case this.monster.infoMc.symm.natave:
               this.symmType = 2;
               this.setSymmStyle(this.symmType);
               this.monster.infoMc.symm.title.gotoAndStop(1);
               break;
            case this.monster.infoMc.symm.skill:
               this.symmType = 1;
               this.setSymmStyle(this.symmType);
               this.monster.infoMc.symm.title.gotoAndStop(2);
               break;
            case this.monster.infoMc.symm.tary:
               this.symmType = 4;
               this.setSymmStyle(this.symmType);
               this.monster.infoMc.symm.title.gotoAndStop(3);
               break;
            case this.monster.infoMc.symm.front:
               this.symmFront();
               break;
            case this.monster.infoMc.symm.next:
               this.symmNext();
               break;
            case this.monster.infoMc.symm.symmRemark:
               ApplicationFacade.getInstance().dispatch(EventConst.OPEN_CACHE_VIEW,{
                  "showX":0,
                  "showY":0
               },null,getQualifiedClassName(SymmRemarkView));
               break;
            case this.monster.infoMc.symm.symmBtn:
               if(GameData.instance.playerData.copyScene > 0)
               {
                  AlertManager.instance.showTipAlert({
                     "systemid":1061,
                     "flag":2
                  });
               }
               else
               {
                  ApplicationFacade.getInstance().dispatch(EventConst.BOBSTATECLICK,{
                     "url":"assets/module/modules39.swf",
                     "xCoord":0,
                     "yCoord":0
                  });
               }
         }
      }
      
      private function disableBtn() : void
      {
         this.monster.changeClip.filters = ColorUtil.getColorMatrixFilterGray();
         this.monster.changeClip.mouseEnabled = false;
         this.monster.cureBtn.filters = ColorUtil.getColorMatrixFilterGray();
         this.monster.cureBtn.mouseEnabled = false;
         this.monster.gcBtn.filters = ColorUtil.getColorMatrixFilterGray();
         this.monster.gcBtn.mouseEnabled = false;
         this.monster.firstBtn.filters = ColorUtil.getColorMatrixFilterGray();
         this.monster.firstBtn.mouseEnabled = false;
         switch(this.menuStatus)
         {
            case 1:
               this.monster.infoMc.infoitem1.nameTxt.text = "";
               this.monster.infoMc.infoitem1.levelTxt.text = "";
               this.monster.infoMc.infoitem1.needExpTxt.text = "";
               this.monster.infoMc.infoitem1.modoTxt.text = "";
               this.monster.infoMc.infoitem1.timeTxt.text = "";
               this.monster.infoMc.infoitem1.geniusTxt.text = "";
               this.monster.infoMc.infoitem1.descTxt.text = "";
               this.monster.infoMc.infoitem1.idTxt.text = "";
               this.monster.nameTxt.text = "";
               this.monster.groupClip.visible = false;
               this.monster.infoMc.infoitem1.sexTxt.visible = false;
               this.monster.infoMc.infoitem1.sexClip.visible = false;
               this.monster.infoMc.infoitem1.expBarMc.visible = false;
               this.label.labelTxt.text = "你的背包中没有任何妖怪\n\n\n\n你可以将家园中训练的或仓库的\n妖怪放入背包中";
         }
      }
      
      private function setFirst(evt:MouseEvent) : void
      {
         if(this.selectData.isfirst == 1 || GameData.instance.playerData.bobOwner == 1)
         {
            return;
         }
         this.clearSelect();
         EventManager.dispatch(this,new MonsterListEvent(MonsterListEvent.SETFIRST,this.selectData));
      }
      
      public function cureMonsterAllState(id:int) : void
      {
         ApplicationFacade.getInstance().dispatch(EventConst.GETMONSTERLIST);
      }
      
      private function changeMonsterState(evt:MouseEvent) : void
      {
         if(this.monster.changeClip.currentFrame == 1)
         {
            this.clearSelect();
            EventManager.dispatch(this,new MonsterListEvent(MonsterListEvent.GETMONSTERINLIST,this.selectData));
         }
         else
         {
            if(GamePersonControl.instance.isInPetArearList())
            {
               AlertManager.instance.showTipAlert({
                  "systemid":1061,
                  "flag":3
               });
               return;
            }
            this.clearSelect();
            EventManager.dispatch(this,new MonsterListEvent(MonsterListEvent.GETMONSTEROUTLIST,this.selectData));
         }
      }
      
      private function gcMonster(evt:MouseEvent) : void
      {
         this.clearSelect();
         EventManager.dispatch(this,new MonsterListEvent(MonsterListEvent.GCMONSTER,this.selectData));
      }
      
      private function cureAllMonster(evt:MouseEvent) : void
      {
         var tempmaxHp:Boolean = false;
         if(GameData.instance.playerData.coin < 40)
         {
            this.onNewHandTask();
            AlertManager.instance.showTipAlert({
               "systemid":1061,
               "flag":4
            });
            return;
         }
         if(this.params.monsterlist.length == 0)
         {
            this.onNewHandTask();
            return;
         }
         tempmaxHp = this.checkSkill();
         if(currentHp != maxHp || tempmaxHp)
         {
            if(!this.isAlertShowing)
            {
               this.isAlertShowing = true;
               AlertManager.instance.showTipAlert({
                  "systemid":1061,
                  "flag":5,
                  "callback":this.sureUseProps
               });
            }
         }
         else
         {
            this.onNewHandTask();
            AlertManager.instance.showTipAlert({
               "systemid":1061,
               "flag":6
            });
         }
      }
      
      private function sureUseProps(str:String, data:Object) : void
      {
         if(str == "确定")
         {
            this.onNewHandTask();
            EventManager.dispatch(this,new MonsterListEvent(MonsterListEvent.CUREALLMONSTER));
         }
         this.isAlertShowing = false;
      }
      
      private function onNewHandTask() : void
      {
         SpecialAreaManager.instance.removeNewHandMask();
         TaskList.getInstance().sendTalkBack();
      }
      
      private function showPropsPanel(evt:MouseEvent) : void
      {
         if(this.monster.propsMc.visible == false)
         {
            this.monster.btnMc.gotoAndStop(4);
            this.monster.infoMc.visible = false;
            this.monster.tempMc.visible = false;
            this.monster.btnMc.visible = false;
            this.skillList.visible = false;
            this.unableskillList.visible = false;
            plist.visible = true;
            ApplicationFacade.getInstance().dispatch(EventConst.GETPROPSLIST,513);
         }
         else
         {
            this.monster.propsMc.visible = false;
            this.monster.infoMc.visible = true;
            this.monster.tempMc.visible = true;
            this.monster.btnMc.visible = true;
            plist.visible = false;
            if(this.menuStatus == 3)
            {
               this.skillList.visible = true;
               this.unableskillList.visible = true;
            }
         }
         this.initToolTip();
      }
      
      private function setSelectData(params:Object, selectIndex:int) : Object
      {
         var select:Object = null;
         if(selectIndex == -1 || params == null || !params.hasOwnProperty("monsterlist"))
         {
            return null;
         }
         for each(select in params.monsterlist)
         {
            if(select.id == selectIndex)
            {
               return select;
            }
         }
         return null;
      }
      
      public function build(params:Object, isNew:Boolean = true) : void
      {
         var select:Object = null;
         this.params = params;
         this.initMList(isNew);
         if(params.hasOwnProperty("monsterlist"))
         {
            if(params.monsterCurrentLength >= params.monsterTotalLenght)
            {
               this.bg.storageTips.gotoAndStop(2);
               this.bg.storageTips.visible = true;
            }
            else if(params.monsterCurrentLength > 949)
            {
               this.bg.storageTips.visible = true;
               this.bg.storageTips.gotoAndStop(1);
            }
            else
            {
               this.bg.storageTips.visible = false;
            }
            if(this.selectIndex == -1)
            {
               this.aftdata = DeepCopy.copy(params.monsterlist[0]);
               if(Boolean(this.aftdata))
               {
                  this.aftdata.name = String(params.monsterlist[0].name);
               }
               this.setMonsterInfo(params.monsterlist[0]);
            }
            else
            {
               select = this.setSelectData(params,this.selectIndex);
               this.aftdata = DeepCopy.copy(select);
               if(Boolean(this.aftdata))
               {
                  this.aftdata.name = String(select.name);
               }
               this.setMonsterInfo(select == null ? params.monsterlist[0] : select);
            }
            if(params.monsterlist.length == 0)
            {
               this.visible = true;
               this.disableBtn();
            }
            else
            {
               this.label.labelTxt.text = "";
               this.enableBtn();
            }
         }
         if(!params.hasOwnProperty("monsterlist"))
         {
            this.visible = true;
         }
         this.monster.firstBtn.filters = ColorUtil.getColorMatrixFilterGray();
         this.monster.firstBtn.mouseEnabled = false;
         EventManager.attachEvent(this.monster.storageBtn,MouseEvent.MOUSE_DOWN,this.openStorage);
         EventManager.attachEvent(this.monster.farmHoldBtn,MouseEvent.MOUSE_DOWN,this.farmHold);
         EventManager.attachEvent(this.monster.changeClip,MouseEvent.MOUSE_DOWN,this.changeMonsterState);
         EventManager.attachEvent(this.monster.cureBtn,MouseEvent.MOUSE_DOWN,this.cureAllMonster);
         EventManager.attachEvent(this.monster.gcBtn,MouseEvent.MOUSE_DOWN,this.gcMonster);
         EventManager.attachEvent(this.monster.firstBtn,MouseEvent.MOUSE_DOWN,this.setFirst);
         EventManager.attachEvent(this.monster.trainBtn,MouseEvent.MOUSE_DOWN,this.trainMonster);
         EventManager.attachEvent(this.monster.btnInfo,MouseEvent.MOUSE_DOWN,this.onMouseDownHandler);
         EventManager.attachEvent(this.monster.btnItem,MouseEvent.MOUSE_DOWN,this.onMouseDownHandler);
         EventManager.attachEvent(this.monster.btnSkill,MouseEvent.MOUSE_DOWN,this.onMouseDownHandler);
         EventManager.attachEvent(this.monster.toolBtn,MouseEvent.MOUSE_DOWN,this.onMouseDownHandler);
         EventManager.attachEvent(this.monster.symmBtn,MouseEvent.MOUSE_DOWN,this.onMouseDownHandler);
         EventManager.attachEvent(this.monster.infoMc.symm,MouseEvent.MOUSE_DOWN,this.onSymmMouseDown);
         this.showWhichNative();
      }
      
      private function showWhichNative() : void
      {
         if(!this.usedtoolbool || this.usedtoolbool && this.menuStatus == 1)
         {
            this.dealShow = true;
            this.infoShow(null);
         }
         else if(this.usedtoolbool && this.menuStatus == 2)
         {
            this.itemShow(null);
         }
         else if(this.usedtoolbool && this.menuStatus == 3)
         {
            this.skillShow(null);
         }
         else if(this.usedtoolbool && this.menuStatus == 4)
         {
            this.propsShow(null);
         }
         if(this.usedtoolbool && this.propsId != 0)
         {
            if(BitValueUtil.getBitValue(this.toolus,18))
            {
               this.propsId = 0;
               this.toolus = 0;
               if(Boolean(this.aftdata) && Boolean(this.predata))
               {
                  ApplicationFacade.getInstance().dispatch(EventConst.BOBSTATECLICK,{
                     "url":"assets/material/SpiritAttrChangeView.swf",
                     "xCoord":280,
                     "yCoord":50,
                     "moduleParams":{
                        "no":this.aftdata,
                        "oo":this.predata
                     }
                  });
               }
            }
            if(this.propsId == 100036)
            {
               this.propsId = 0;
               if(Boolean(this.aftdata) && Boolean(this.predata))
               {
                  ApplicationFacade.getInstance().dispatch(EventConst.BOBSTATECLICK,{
                     "url":"assets/material/MoldChangeView.swf",
                     "xCoord":230,
                     "yCoord":175,
                     "moduleParams":{
                        "no":this.aftdata,
                        "oo":this.predata
                     }
                  });
               }
            }
         }
      }
      
      public function cureSingleMonster(par:Object, $propsId:int) : void
      {
         var target:Object = this.getMonsterItemById(par.monsterid);
         if(Boolean(target))
         {
            this.effect(target,$propsId,par);
         }
      }
      
      private function effect(target:Object, $propsId:int, par:Object) : void
      {
         var test:Object = null;
         var toolType:int = 0;
         var inItem:Boolean = false;
         var flagbool:Boolean = false;
         var toolCfg:XML = null;
         var value:int = 0;
         var type:int = 0;
         var pvalue:int = 0;
         test = par;
         inItem = false;
         flagbool = true;
         toolCfg = this.monsterToolXml.children().(@id == $propsId)[0];
         if(toolCfg != null)
         {
            value = int(toolCfg.value);
            type = int(toolCfg.type);
            if(type == 1)
            {
               this.addMonsterHealth(target,value);
            }
            else if(type == 2)
            {
               this.addSkillCount(target,value);
            }
            else if(type == 3)
            {
               flagbool = this.addMonsterExp(target,value);
            }
            else if(type == 4)
            {
               pvalue = value * int(target.data.needExp) / 100;
               flagbool = this.addMonsterExp(target,pvalue);
            }
         }
         else
         {
            flagbool = false;
            ApplicationFacade.getInstance().dispatch(EventConst.GETMONSTERLIST);
         }
         this.updateParams(target);
         this.mList.dataProvider = this.params.monsterlist;
         this.setSkillList(this.params.monsterlist[0].skilllist);
         this.setunableSkillList(this.params.monsterlist[0].allSkillList);
         this.setMonsterInfo(target.data);
         this.delUseItem($propsId);
         if(flagbool)
         {
            this.showWhichNative();
         }
      }
      
      private function addMonsterHealth(target:Object, value:int) : void
      {
         target.data.hp += value;
         if(target.data.hp > target.data.strength)
         {
            target.data.hp = target.data.strength;
            AlertManager.instance.showTipAlert({
               "systemid":1062,
               "flag":1
            });
         }
         else
         {
            AlertManager.instance.showTipAlert({
               "systemid":1062,
               "flag":2,
               "replace":value
            });
         }
         var qq:int = int(target.data.hp / target.data.strength * 100);
         var ww:int = Math.floor(qq);
         target.hpMc.gotoAndStop(100 - ww + 1);
         target.hpTxt.text = target.data.hp + "";
      }
      
      private function addSkillCount(target:Object, value:int) : void
      {
         var obj:Object = null;
         for each(obj in target.data.skilllist)
         {
            obj.skillnum += value;
            if(obj.skillnum > obj.skillmaxnum)
            {
               obj.skillnum = obj.skillmaxnum;
            }
         }
         AlertManager.instance.showTipAlert({
            "systemid":1062,
            "flag":3,
            "replace":value
         });
      }
      
      private function addMonsterExp(target:Object, value:int) : Boolean
      {
         var level:int = 0;
         if(target.data.exp + value >= target.data.needExp)
         {
            ApplicationFacade.getInstance().dispatch(EventConst.GETMONSTERLIST);
            return false;
         }
         target.data.exp += value;
         level = int(this.monster.infoMc.infoitem1.levelTxt.text);
         if(level >= 100)
         {
            this.monster.infoMc.infoitem1.needExpTxt.text = "已满级";
         }
         else
         {
            this.monster.infoMc.infoitem1.needExpTxt.text = target.data.exp + "/" + target.data.needExp;
         }
         this.monster.infoMc.infoitem1.expBarMc.gotoAndStop(this.transNeedExp(target.data.needExp,target.data.exp));
         AlertManager.instance.showTipAlert({
            "systemid":1062,
            "flag":4,
            "replace":value
         });
         return true;
      }
      
      public function batchUseProp($data:Object) : void
      {
         var target:Object = null;
         this.delUseItem($data.itemid,$data.useNum);
         if($data.state == 0)
         {
            target = this.getMonsterItemById($data.monsterid);
            target.data.exp += $data.addExp;
            this.setMonsterInfo(target.data);
            AlertManager.instance.showTipAlert({
               "systemid":1062,
               "flag":4,
               "replace":$data.addExp
            });
         }
         else
         {
            ApplicationFacade.getInstance().dispatch(EventConst.GETMONSTERLIST);
         }
      }
      
      private function delPropFromDaoju($propid:int) : void
      {
         var leng:int = int(this.daojuList.length);
         for(var i:int = 0; i < leng; i++)
         {
            if(this.daojuList[i].id == $propid)
            {
               this.daojuList.splice(i,1);
               break;
            }
         }
         this.toolFenyeShow();
      }
      
      private function delUseItem($propsId:int, $count:int = 1) : void
      {
         var item:PackItem = this.getToolItemById($propsId);
         if(Boolean(item))
         {
            if(item.data.count <= $count)
            {
               this.delPropFromDaoju($propsId);
            }
            else
            {
               item.setCount(item.data.count - $count);
               if(Boolean(item.data) && BitValueUtil.getBitValue(item.data.usableStatus,22))
               {
                  item.showCD();
               }
               else
               {
                  item.hideCD();
               }
            }
         }
      }
      
      private function initMList(isNew:Boolean) : void
      {
         if(!isNew)
         {
            this.setFirstInFirst();
         }
         this.visible = true;
         this.mList.dataProvider = this.params.monsterlist;
      }
      
      private function setFirstInFirst() : void
      {
         var temp:Object = null;
         var list:Array = null;
         var firstMonster:Object = null;
         var item:Object = null;
         if(this.params.monsterlist.length > 0)
         {
            temp = this.params.monsterlist[0];
            if(temp.isfirst != 1)
            {
               list = [];
               for each(item in this.params.monsterlist)
               {
                  if(item.isfirst == 1 && firstMonster == null)
                  {
                     firstMonster = item;
                  }
                  else
                  {
                     list.push(item);
                  }
               }
               if(firstMonster != null)
               {
                  list.push(firstMonster);
               }
               this.params.monsterlist = list.reverse();
            }
         }
      }
      
      private function getToolItemById(id:int) : PackItem
      {
         var pItem:PackItem = null;
         var tempitem:PackItem = null;
         var num:int = plist.numChildren;
         for(var i:int = 0; i < num; i++)
         {
            tempitem = plist.getChildAt(i) as PackItem;
            if(tempitem.data.id == id)
            {
               pItem = tempitem;
               break;
            }
         }
         return pItem;
      }
      
      private function getMonsterItemById(id:int) : MonsterItem
      {
         var mItem:MonsterItem = null;
         var tempItem:MonsterItem = null;
         var num:int = this.mList.numChildren;
         for(var i:int = 0; i < num; i++)
         {
            tempItem = this.mList.getChildAt(i) as MonsterItem;
            if(tempItem.data.id == id)
            {
               mItem = this.mList.getChildAt(i) as MonsterItem;
               break;
            }
         }
         return mItem;
      }
      
      private function updateParams(item:Object) : void
      {
         var num:int = int(this.params.monsterlist.length);
         for(var i:int = 0; i < num; i++)
         {
            if(this.params.monsterlist[i].id == item.data.id)
            {
               this.params.monsterlist[i].mold = item.data.mold;
               this.params.monsterlist[i].level = item.data.level;
               this.params.monsterlist[i].CountGeniuscount = item.data.CountGeniuscount;
               this.params.monsterlist[i].strength = item.data.strength;
               this.params.monsterlist[i].attack = item.data.attack;
               this.params.monsterlist[i].magic = item.data.magic;
               this.params.monsterlist[i].speed = item.data.speed;
               this.params.monsterlist[i].defence = item.data.defence;
               this.params.monsterlist[i].resistance = item.data.resistance;
               this.params.monsterlist[i].attackLearnValue = item.data.attackLearnValue;
               this.params.monsterlist[i].defenceLearnValue = item.data.defenceLearnValue;
               this.params.monsterlist[i].magicLearnValue = item.data.magicLearnValue;
               this.params.monsterlist[i].resistanceLearnValue = item.data.resistanceLearnValue;
               this.params.monsterlist[i].hpLearnValue = item.data.hpLearnValue;
               this.params.monsterlist[i].speedLearnVale = item.data.speedLearnVale;
               this.params.monsterlist[i].hpGenius = item.data.hpGenius;
               this.params.monsterlist[i].attackGenius = item.data.attackGenius;
               this.params.monsterlist[i].defenceGenius = item.data.defenceGenius;
               this.params.monsterlist[i].speedGenius = item.data.speedGenius;
               this.params.monsterlist[i].magicGenius = item.data.magicGenius;
               this.params.monsterlist[i].resistanceGenius = item.data.resistanceGenius;
               this.params.monsterlist[i].allSkillList = item.data.allSkillList;
               break;
            }
         }
      }
      
      private function clearSelect() : void
      {
         for(var i:int = 0; i < 6; i++)
         {
            this.monster["m" + i].gotoAndStop(1);
         }
      }
      
      private function setMonsterInfo(itemData:Object) : void
      {
         var onLoaderCompHandler:Function;
         var xml:XML = null;
         if(itemData != null)
         {
            if(Boolean(itemData.hasOwnProperty("iid")) && this.tempid != itemData.iid)
            {
               onLoaderCompHandler = function(event:Event):void
               {
                  mloader.scaleX = 1.8;
                  mloader.scaleY = 1.8;
                  mloader.x = 107;
                  mloader.y = 140;
                  addChild(mloader);
                  this.visible = true;
               };
               this.tempid = itemData.iid;
               this.mloader.unload();
               this.mloader.load(new URLRequest(URLUtil.getSvnVer("assets/monsterswf/" + itemData.iid + ".swf")));
               this.mloader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoaderCompHandler);
            }
         }
         else
         {
            this.mloader.unloadAndStop();
            this.clearSelect();
            if(this.contains(this.mloader))
            {
               this.removeChild(this.mloader);
            }
            this.monster.nataveIcon.gotoAndStop(7);
            SymmTip.LooseDO(this.monster.nataveIcon);
            ToolTip.setDOInfo(this.monster.nataveIcon,"属性灵玉装备槽");
         }
         this.selectData = itemData;
         if(itemData != null)
         {
            this.monster.typeClip.gotoAndStop(itemData == null ? 1 : itemData.type + 1);
            this.monster.groupClip.gotoAndStop(itemData == null ? 1 : itemData.group + 1);
            this.monster.groupClip.visible = true;
            ToolTip.setDOInfo(this.monster.groupClip,HtmlUtil.getHtmlText(12,"#000000",CommonDefine.groupList[int(itemData.group)]));
            this.monster.nameTxt.text = itemData == null ? "" : itemData.name;
            currentHp = itemData == null ? 0 : int(itemData.hp);
            maxHp = itemData == null ? 0 : int(itemData.strength);
            if(itemData.skilllist != null)
            {
               this.templist = itemData.skilllist;
            }
            if(itemData.allSkillList != null)
            {
               this.tempallskilllist = itemData.allSkillList;
            }
            curerentId = itemData == null ? -1 : int(itemData.id);
            this.initSymmNative(itemData);
            switch(this.menuStatus)
            {
               case 1:
                  this.monster.infoMc.infoitem1.nameTxt.text = itemData == null ? "" : itemData.name;
                  this.monster.infoMc.infoitem1.sexTxt.visible = true;
                  this.monster.infoMc.infoitem1.sexClip.visible = true;
                  this.monster.infoMc.infoitem1.sexTxt.text = CommonDefine.sexList[itemData.sex];
                  this.monster.infoMc.infoitem1.sexClip.gotoAndStop(itemData.sex);
                  this.monster.infoMc.infoitem1.levelTxt.text = itemData == null ? "" : itemData.level;
                  this.monster.infoMc.infoitem1.needExpTxt.text = itemData == null ? "" : this.getNeedExp(itemData.needExp,itemData.exp);
                  this.monster.infoMc.infoitem1.modoTxt.text = itemData == null ? "" : CommonDefine.moldList[itemData.mold - 1];
                  this.monster.infoMc.infoitem1.timeTxt.text = itemData == null ? "" : TimeTransform.getInstance().transDate(int(itemData.timetxt));
                  this.monster.infoMc.infoitem1.geniusTxt.text = itemData == null ? "" : itemData.CountGeniuscount;
                  xml = XMLLocator.getInstance().getSprited(itemData.iid);
                  this.monster.infoMc.infoitem1.descTxt.text = itemData == null ? "" : xml.introduce;
                  this.monster.infoMc.infoitem1.idTxt.text = itemData == null ? "" : xml.sequence;
                  this.monster.infoMc.infoitem1.expBarMc.gotoAndStop(itemData == null ? 1 : this.transNeedExp(itemData.needExp,itemData.exp));
                  break;
               case 2:
                  this.monster.infoMc.infoitem2.hpTxt.htmlText = itemData == null ? "" : (SymmEnum.hasNative(itemData,25) == -1 ? itemData.strength : SymmEnum.getContentColor(itemData.strength));
                  this.monster.infoMc.infoitem2.attackTxt.htmlText = itemData == null ? "" : (SymmEnum.hasNative(itemData,21) == -1 ? itemData.attack : SymmEnum.getContentColor(itemData.attack));
                  this.monster.infoMc.infoitem2.magicTxt.htmlText = itemData == null ? "" : (SymmEnum.hasNative(itemData,23) == -1 ? itemData.magic : SymmEnum.getContentColor(itemData.magic));
                  this.monster.infoMc.infoitem2.speedTxt.htmlText = itemData == null ? "" : (SymmEnum.hasNative(itemData,26) == -1 ? itemData.speed : SymmEnum.getContentColor(itemData.speed));
                  this.monster.infoMc.infoitem2.defenceTxt.htmlText = itemData == null ? "" : (SymmEnum.hasNative(itemData,22) == -1 ? itemData.defence : SymmEnum.getContentColor(itemData.defence));
                  this.monster.infoMc.infoitem2.strTxt.htmlText = itemData == null ? "" : (SymmEnum.hasNative(itemData,24) == -1 ? itemData.resistance : SymmEnum.getContentColor(itemData.resistance));
                  this.monster.infoMc.infoitem2.hppotentialTxt.text = itemData == null ? "" : itemData.hpLearnValue;
                  this.monster.infoMc.infoitem2.attpotentialTxt.text = itemData == null ? "" : itemData.attackLearnValue;
                  this.monster.infoMc.infoitem2.magicpotentialTxt.text = itemData == null ? "" : itemData.magicLearnValue;
                  this.monster.infoMc.infoitem2.speedpotentialTxt.text = itemData == null ? "" : itemData.speedLearnVale;
                  this.monster.infoMc.infoitem2.defpotentialTxt.text = itemData == null ? "" : itemData.defenceLearnValue;
                  this.monster.infoMc.infoitem2.strpotentialTxt.text = itemData == null ? "" : itemData.resistanceLearnValue;
                  if(itemData != null && itemData.hpGeniusValue == 31)
                  {
                     this.monster.infoMc.infoitem2.hpMc.gotoAndStop(7);
                  }
                  else
                  {
                     this.monster.infoMc.infoitem2.hpMc.gotoAndStop(itemData == null ? 1 : itemData.hpGenius);
                  }
                  if(itemData != null && itemData.attackGeniusValue == 31)
                  {
                     this.monster.infoMc.infoitem2.attMc.gotoAndStop(7);
                  }
                  else
                  {
                     this.monster.infoMc.infoitem2.attMc.gotoAndStop(itemData == null ? 1 : itemData.attackGenius);
                  }
                  if(itemData != null && itemData.defenceGeniusValue == 31)
                  {
                     this.monster.infoMc.infoitem2.defMc.gotoAndStop(7);
                  }
                  else
                  {
                     this.monster.infoMc.infoitem2.defMc.gotoAndStop(itemData == null ? 1 : itemData.defenceGenius);
                  }
                  if(itemData != null && itemData.speedGeniusValue == 31)
                  {
                     this.monster.infoMc.infoitem2.speedMc.gotoAndStop(7);
                  }
                  else
                  {
                     this.monster.infoMc.infoitem2.speedMc.gotoAndStop(itemData == null ? 1 : itemData.speedGenius);
                  }
                  if(itemData != null && itemData.magicGeniusValue == 31)
                  {
                     this.monster.infoMc.infoitem2.magicMc.gotoAndStop(7);
                  }
                  else
                  {
                     this.monster.infoMc.infoitem2.magicMc.gotoAndStop(itemData == null ? 1 : itemData.magicGenius);
                  }
                  if(itemData != null && itemData.resistanceGeniusValue == 31)
                  {
                     this.monster.infoMc.infoitem2.strMc.gotoAndStop(7);
                  }
                  else
                  {
                     this.monster.infoMc.infoitem2.strMc.gotoAndStop(itemData == null ? 1 : itemData.resistanceGenius);
                  }
                  ToolTip.setDOInfo(this.monster.infoMc.infoitem2.hpMc,HtmlUtil.getHtmlText(12,"#000000","资质"));
                  ToolTip.setDOInfo(this.monster.infoMc.infoitem2.attMc,HtmlUtil.getHtmlText(12,"#000000","资质"));
                  ToolTip.setDOInfo(this.monster.infoMc.infoitem2.defMc,HtmlUtil.getHtmlText(12,"#000000","资质"));
                  ToolTip.setDOInfo(this.monster.infoMc.infoitem2.speedMc,HtmlUtil.getHtmlText(12,"#000000","资质"));
                  ToolTip.setDOInfo(this.monster.infoMc.infoitem2.magicMc,HtmlUtil.getHtmlText(12,"#000000","资质"));
                  ToolTip.setDOInfo(this.monster.infoMc.infoitem2.strMc,HtmlUtil.getHtmlText(12,"#000000","资质"));
                  ToolTip.setDOInfo(this.monster.infoMc.infoitem2.xiuwei1,HtmlUtil.getHtmlText(12,"#000000","修为"));
                  ToolTip.setDOInfo(this.monster.infoMc.infoitem2.xiuwei2,HtmlUtil.getHtmlText(12,"#000000","修为"));
                  ToolTip.setDOInfo(this.monster.infoMc.infoitem2.xiuwei3,HtmlUtil.getHtmlText(12,"#000000","修为"));
                  ToolTip.setDOInfo(this.monster.infoMc.infoitem2.xiuwei4,HtmlUtil.getHtmlText(12,"#000000","修为"));
                  ToolTip.setDOInfo(this.monster.infoMc.infoitem2.xiuwei5,HtmlUtil.getHtmlText(12,"#000000","修为"));
                  ToolTip.setDOInfo(this.monster.infoMc.infoitem2.xiuwei6,HtmlUtil.getHtmlText(12,"#000000","修为"));
                  break;
               case 3:
                  this.monster.infoMc.infoitem3.pageTxt.text = 1 + "";
                  this.monster.infoMc.infoitem3.accountPageTxt.text = this.tempallskilllist.length % 4 == 0 ? Math.floor(this.tempallskilllist.length / 4) : Math.floor(this.tempallskilllist.length / 4) + 1;
                  this.allskillcount = int(this.monster.infoMc.infoitem3.accountPageTxt.text);
                  this.setSkillList(this.templist);
                  this.setunableSkillList(this.tempallskilllist);
                  break;
               case 4:
                  plist.visible = true;
            }
            if(itemData != null && itemData.state == 1)
            {
               ToolTip.setDOInfo(this.monster.changeClip,HtmlUtil.getHtmlText(12,"#000000","放入背包"));
               this.monster.changeClip.gotoAndStop(1);
            }
            else
            {
               ToolTip.setDOInfo(this.monster.changeClip,HtmlUtil.getHtmlText(12,"#000000","跟随"));
               this.monster.changeClip.gotoAndStop(2);
            }
         }
      }
      
      private function initSymmNative(itemData:Object) : void
      {
         var list:Array = null;
         var symmSendList:Array = null;
         var symmObj:Object = null;
         var bool:Boolean = false;
         if(itemData.hasOwnProperty("symmList"))
         {
            list = itemData.symmList;
            symmSendList = [];
            if(list.length > 0)
            {
               for each(symmObj in list)
               {
                  if(symmObj.symmPlace == 2)
                  {
                     bool = this.setNative(symmObj);
                     if(bool)
                     {
                        symmSendList.push(symmObj.symmIndex);
                     }
                  }
                  else if(symmObj.symmPlace != 1)
                  {
                     if(symmObj.symmPlace == 4)
                     {
                     }
                  }
               }
               if(bool)
               {
                  dispatchEvent(new MessageEvent(MonsterListEvent.SYMM_WEAR_OR_OFF,{
                     "code":3,
                     "symmSendList":symmSendList
                  }));
               }
            }
            else
            {
               this.monster.nataveIcon.gotoAndStop(7);
               SymmTip.LooseDO(this.monster.nataveIcon);
               ToolTip.setDOInfo(this.monster.nataveIcon,"属性灵玉装备槽");
            }
         }
         else
         {
            this.monster.nataveIcon.gotoAndStop(7);
            SymmTip.LooseDO(this.monster.nataveIcon);
            ToolTip.setDOInfo(this.monster.nataveIcon,"属性灵玉装备槽");
         }
      }
      
      private function setNative(data:Object, isServer:Boolean = false) : Boolean
      {
         var nativeList:Array = null;
         var bool:Boolean = false;
         ToolTip.LooseDO(this.monster.nataveIcon);
         if(data.symmId == 103001)
         {
            this.monster.nataveIcon.gotoAndStop(1);
         }
         else if(data.symmId == 103002)
         {
            this.monster.nataveIcon.gotoAndStop(2);
         }
         else if(data.symmId == 103003)
         {
            this.monster.nataveIcon.gotoAndStop(3);
         }
         else if(data.symmId == 103004)
         {
            this.monster.nataveIcon.gotoAndStop(4);
         }
         else if(data.symmId == 103005)
         {
            this.monster.nataveIcon.gotoAndStop(5);
         }
         else
         {
            if(data.symmId != 103006)
            {
               this.monster.nataveIcon.gotoAndStop(7);
               ToolTip.setDOInfo(this.monster.nataveIcon,"属性灵玉装备槽");
               return false;
            }
            this.monster.nataveIcon.gotoAndStop(6);
         }
         if(data.hasOwnProperty("nativeList"))
         {
            SymmTip.setDOInfo(this.monster.nataveIcon,SymmEnum.getTips(data));
            bool = false;
         }
         else
         {
            nativeList = this.getSymmNativeById(data.symmIndex);
            bool = nativeList == null ? true : false;
            if(!bool)
            {
               data.nativeList = nativeList;
               SymmTip.setDOInfo(this.monster.nataveIcon,SymmEnum.getTips(data));
            }
         }
         return bool;
      }
      
      private function getSymmNativeById(symmIndex:int) : Array
      {
         var symmObj:Object = null;
         if(this.symmData == null)
         {
            return null;
         }
         for each(symmObj in this.symmData)
         {
            if(symmObj.symmIndex == symmIndex)
            {
               return symmObj.nativeList;
            }
         }
         return null;
      }
      
      public function checkSkill() : Boolean
      {
         if(this.templist == null)
         {
            return true;
         }
         for(var i:int = 0; i < this.templist.length; i++)
         {
            if(this.templist[i].skillmaxnum != this.templist[i].skillnum)
            {
               ff = true;
               break;
            }
            ff = false;
         }
         return ff;
      }
      
      private function getNeedExp(needExp:int, currentExp:int) : String
      {
         var exp:String = null;
         var level:int = int(this.monster.infoMc.infoitem1.levelTxt.text);
         if(level >= 100)
         {
            exp = "已满级";
         }
         else
         {
            exp = currentExp + "/" + needExp;
         }
         return exp;
      }
      
      private function transNeedExp(needExp:int, currentExp:int) : int
      {
         return Math.floor(currentExp / needExp * 100);
      }
      
      private function setSkillList(list:Array) : void
      {
         this.skillList.dataProvider = list;
         this.templist = list;
         this.checkSkill();
      }
      
      private function setunableSkillList(list:Array) : void
      {
         var jj:int = (int(this.monster.infoMc.infoitem3.pageTxt.text) - 1) * 4;
         var ll:int = int(this.monster.infoMc.infoitem3.pageTxt.text) * 4;
         if(int(this.monster.infoMc.infoitem3.pageTxt.text) == this.allskillcount)
         {
            this.unableskillList.dataProvider = this.tempallskilllist.slice(jj);
         }
         else
         {
            this.unableskillList.dataProvider = this.tempallskilllist.slice(jj,ll);
         }
      }
      
      public function setMonsterState(iid:int, state:int, id:int) : void
      {
         var obj:MonsterItem = null;
         var num:int = this.mList.numChildren;
         for(var i:int = 0; i < num; i++)
         {
            obj = this.mList.getChildAt(i) as MonsterItem;
            if(obj.data.iid == iid && obj.data.id == id)
            {
               if(state == 1)
               {
                  obj.data.state = 1;
                  ToolTip.setDOInfo(this.monster.changeClip,HtmlUtil.getHtmlText(12,"#000000","放入背包"));
                  this.monster.changeClip.gotoAndStop(1);
               }
               else
               {
                  obj.data.state = 0;
                  ToolTip.setDOInfo(this.monster.changeClip,HtmlUtil.getHtmlText(12,"#000000","跟随"));
                  this.monster.changeClip.gotoAndStop(2);
               }
            }
            else
            {
               obj.data.state = 0;
            }
         }
      }
      
      private function closeWindow(evt:MouseEvent) : void
      {
         FarmServerUtil.Instance.depos();
         this.dealShow = true;
         this.btnControl = 1118481;
         this.disposTrainCourseView();
         this.tempid = 0;
         this.monster.btnMc.gotoAndStop(1);
         ToolTip.LooseDO(this.monster.nataveIcon);
         SymmTip.LooseDO(this.monster.nataveIcon);
         CacheUtil.deleteObject(SymmRemarkView);
         this.infoShow(null);
         if(Boolean(this.mloader) && this.contains(this.mloader))
         {
            this.removeChild(this.mloader);
            this.mloader.unload();
         }
         if(this.parent != null)
         {
            if(this.parent.contains(this))
            {
               this.parent.removeChild(this);
            }
         }
         this.monster.infoMc.visible = true;
         this.monster.btnMc.visible = true;
         plist.visible = false;
         if(this.menuStatus == 3)
         {
            this.skillList.visible = true;
            this.unableskillList.visible = true;
         }
         this.mList.dataProvider = [];
         plist.dataProvider = [];
         this.skillList.dataProvider = [];
         this.symmList.dataProvider = [];
         this.unableskillList.dataProvider = [];
      }
      
      override public function disport() : void
      {
         this.removeEvent();
         this.disposTrainCourseView();
         ApplicationFacade.getInstance().removeViewLogic(MonsterListControl.NAME);
         CacheUtil.deleteObject(MonsterListView);
         this.closeWindow(null);
         super.disport();
      }
      
      private function disposTrainCourseView() : void
      {
         if(Boolean(this.chooseCourseView))
         {
            EventManager.removeEvent(this.chooseCourseView,TrumpEvent.TRAINSETCOURSEBACK,this.onTrainCourseBack);
            this.chooseCourseView.disport();
            this.chooseCourseView = null;
         }
      }
   }
}

