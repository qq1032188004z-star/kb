package com.game.modules.view.wakeup
{
   import com.game.Tools.AttributeCharacterIcon;
   import com.game.cue.base.CueEnum;
   import com.game.cue.util.KabuCueUtil;
   import com.game.facade.ApplicationFacade;
   import com.game.locators.GameData;
   import com.game.manager.AlertManager;
   import com.game.manager.EventManager;
   import com.game.modules.control.battle.WinSkillControl;
   import com.game.modules.view.item.SkillItem;
   import com.game.modules.view.monster.Props;
   import com.game.util.CacheUtil;
   import com.game.util.ColorUtil;
   import com.game.util.HLoaderSprite;
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.alert.Alert;
   import com.publiccomponent.events.ItemClickEvent;
   import com.publiccomponent.list.TileList;
   import com.publiccomponent.loading.GreenLoading;
   import com.publiccomponent.ui.ToolTip;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import flash.net.URLRequest;
   
   public class WakeSkillView extends HLoaderSprite
   {
      
      private var _attIcon:AttributeCharacterIcon;
      
      private var skillNewList:TileList;
      
      private var skillOldList:TileList;
      
      private var rowLength:int = 0;
      
      private var haveBg:Boolean = false;
      
      private var redf:GlowFilter = new GlowFilter(16711680,1,2,2,50,5,false,false);
      
      private var selectOld:SkillItem;
      
      private var selectNew:SkillItem;
      
      private var _spiritData:Object;
      
      private var spiriticonloader:Loader;
      
      public var changdata:Object = {};
      
      private var newSkillData:Object;
      
      private var currentPage:int = 0;
      
      private var leftState:Boolean = false;
      
      private var rightState:Boolean = false;
      
      public function WakeSkillView()
      {
         GreenLoading.loading.visible = true;
         super();
         this.skillOldList = new TileList(155,345);
         this.skillOldList.build(2,2,-1,-1,165,60,SkillItem);
         this.skillNewList = new TileList(515,155);
         this.skillNewList.build(2,4,-1,-1,165,70,SkillItem);
         this.rowLength = this.skillNewList.rowCount * this.skillNewList.columnCount;
         this.skillNewList.addEventListener(ItemClickEvent.ITEMCLICKEVENT,this.onItemClick,true);
         this.skillOldList.addEventListener(ItemClickEvent.ITEMCLICKEVENT,this.onItemClick,true);
         this.url = "assets/wakeskill/wakeskill.swf";
         this.graphics.beginFill(111111,0);
         this.graphics.drawRect(0,0,970,570);
         this.graphics.endFill();
      }
      
      override public function setShow() : void
      {
         this.bg.cacheAsBitmap = true;
         this.haveBg = true;
         this._attIcon = new AttributeCharacterIcon();
         bg["spAtt"].addChild(this._attIcon);
         if(this._spiritData != null)
         {
            this.loadSpiritIcon();
            this.showSpiritInfo();
            this.showOldSkill();
         }
         ApplicationFacade.getInstance().registerViewLogic(new WinSkillControl(this));
         GreenLoading.loading.visible = false;
         this.initEvents();
      }
      
      override public function initParams(params:Object = null) : void
      {
         this.spiritData = params.body;
      }
      
      public function initEvents() : void
      {
         EventManager.attachEvent(bg["closeBtn"],MouseEvent.CLICK,this.closeWindow);
         EventManager.attachEvent(bg["backBtn"],MouseEvent.CLICK,this.closeWindow);
         EventManager.attachEvent(bg["changeBtn"],MouseEvent.CLICK,this.onClickOkBtn);
         EventManager.attachEvent(bg["learnBtn"],MouseEvent.CLICK,this.onClickOkBtn);
         EventManager.attachEvent(bg["pagemc"]["leftbtn"],MouseEvent.CLICK,this.onMouseClickLeft);
         EventManager.attachEvent(bg["pagemc"]["rightbtn"],MouseEvent.CLICK,this.onMouseClickRight);
      }
      
      public function removeEvents() : void
      {
         EventManager.removeEvent(bg["closeBtn"],MouseEvent.CLICK,this.closeWindow);
         EventManager.removeEvent(bg["backBtn"],MouseEvent.CLICK,this.closeWindow);
         EventManager.removeEvent(bg["changeBtn"],MouseEvent.CLICK,this.onClickOkBtn);
         EventManager.removeEvent(bg["learnBtn"],MouseEvent.CLICK,this.onClickOkBtn);
         EventManager.removeEvent(bg["pagemc"]["leftbtn"],MouseEvent.CLICK,this.onMouseClickLeft);
         EventManager.removeEvent(bg["pagemc"]["rightbtn"],MouseEvent.CLICK,this.onMouseClickRight);
      }
      
      private function onItemClick(event:ItemClickEvent) : void
      {
         try
         {
            this.getSkillItem(event.params.skillid).filters = [this.redf];
         }
         catch(e:*)
         {
            trace("获取的skillitem为null");
         }
      }
      
      private function getSkillItem(id:int) : SkillItem
      {
         var sItem:SkillItem = null;
         var j:int = 0;
         var n:int = 0;
         for(var i:int = 0; i < this.skillOldList.numChildren; i++)
         {
            sItem = this.skillOldList.getChildAt(i) as SkillItem;
            if(Boolean(sItem) && sItem.data.skillid == id)
            {
               for(j = 0; j < this.skillOldList.numChildren; j++)
               {
                  if(this.skillOldList.getChildAt(j) is SkillItem)
                  {
                     this.skillOldList.getChildAt(j).filters = [];
                  }
               }
               this.selectOld = sItem;
               return sItem;
            }
         }
         for(i = 0; i < this.skillNewList.numChildren; i++)
         {
            sItem = this.skillNewList.getChildAt(i) as SkillItem;
            if(Boolean(sItem) && sItem.data.skillid == id)
            {
               for(n = 0; n < this.skillNewList.numChildren; n++)
               {
                  if(this.skillNewList.getChildAt(n) is SkillItem)
                  {
                     this.skillNewList.getChildAt(n).filters = [];
                  }
               }
               this.selectNew = sItem;
               return sItem;
            }
         }
         return null;
      }
      
      public function set spiritData(value:Object) : void
      {
         this._spiritData = value;
         if(this.newSkillData == null)
         {
            this.newSkillData = {};
            this.newSkillData.osd = {};
            this.newSkillData.nsd = {};
         }
         this.newSkillData.osd.skillarr = this._spiritData.skilllist;
         this.newSkillData.nsd.skillarr = this._spiritData.allSkillList;
         this.loadSpiritIcon();
         this.showSpiritInfo();
         if(this.bg != null && this.contains(this.bg))
         {
            this.showOldSkill();
         }
      }
      
      public function get spiritData() : Object
      {
         return this._spiritData;
      }
      
      private function showSpiritInfo() : void
      {
         if(this.spiritData == null || this.haveBg == false)
         {
            return;
         }
         this._attIcon.id = this._spiritData.type;
         bg["spiritname"].text = "" + this.spiritData.name;
         bg["level"].text = "" + this.spiritData.level;
         bg["hp"].text = "" + this.spiritData.strength;
         bg["atk"].text = "" + this.spiritData.attack;
         bg["def"].text = "" + this.spiritData.defence;
         bg["magatk"].text = "" + this.spiritData.magic;
         bg["magdef"].text = "" + this.spiritData.resistance;
         bg["speed"].text = "" + this.spiritData.speed;
         bg.groupClip.gotoAndStop(int(this.spiritData.group) + 1);
         if(Boolean(this.spiritData.hasOwnProperty("symmList")) && this.spiritData.symmList.length > 0)
         {
            bg["symm"].filters = [];
            ToolTip.setDOInfo(bg["symm"],"已装备灵玉");
         }
         else
         {
            bg["symm"].filters = ColorUtil.getColorMatrixFilterGray();
            ToolTip.setDOInfo(bg["symm"],"未装备灵玉");
         }
      }
      
      private function loadSpiritIcon() : void
      {
         if(this.spiriticonloader != null && this.contains(this.spiriticonloader))
         {
            this.removeChild(this.spiriticonloader);
            this.spiriticonloader = null;
         }
         this.spiriticonloader = new Loader();
         this.spiriticonloader.load(new URLRequest(URLUtil.getSvnVer("assets/monsterswf/" + this.spiritData.iid + ".swf")));
         this.spiriticonloader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoadswfComp);
         this.spiriticonloader.scaleX = 1.25;
         this.spiriticonloader.scaleY = 1.25;
         this.spiriticonloader.x = 210;
         this.spiriticonloader.y = 150;
         this.addChild(this.spiriticonloader);
      }
      
      private function onLoadswfComp(evt:Event) : void
      {
      }
      
      private function onClickOkBtn(event:MouseEvent) : void
      {
         var id:int = 0;
         var obj:Object = null;
         if(this.selectNew == null)
         {
            new Alert().show("请选你要替换或学习的新技能。");
            return;
         }
         if(this.selectOld == null && this.bg["changeBtn"].visible == true)
         {
            new Alert().show("请选你要替换掉的技能。");
            return;
         }
         var oldID:int = this.selectOld != null ? this.selectOld.getSkillId() : -1;
         var ary:Array = this.selectNew.getRepel();
         var curAry:Array = this.newSkillData.osd.skillarr;
         if(ary.length > 0)
         {
            for each(id in ary)
            {
               if(oldID == id)
               {
                  break;
               }
               for each(obj in curAry)
               {
                  if(obj["skillid"] == id)
                  {
                     AlertManager.instance.addTipAlert({
                        "tip":this.selectNew.getName() + "和" + String(obj["skillname"]) + "互斥了，只能同时携带1个哦！",
                        "type":2
                     });
                     return;
                  }
               }
            }
         }
         new Alert().showSureOrCancel("替换技能需要花费50铜钱，是否继续？",this.makesureWakeUpSkill);
      }
      
      private function makesureWakeUpSkill(str:String, data:Object) : void
      {
         if(str == "确定")
         {
            if(GameData.instance.playerData.coin < 50)
            {
               KabuCueUtil.instance.showOtherCue(CueEnum.CUE_NOT_COIN,"skillSwapNotCoin.swf");
            }
            else
            {
               this.wakeUpSkill();
            }
         }
      }
      
      private function wakeUpSkill() : void
      {
         var i:int = 0;
         var len:int = 0;
         if(this.selectOld != null)
         {
            for(i = 0; i < this.newSkillData.osd.skillarr.length; i++)
            {
               if(this.newSkillData.osd.skillarr[i].skillid == this.selectOld.data.skillid)
               {
                  this.newSkillData.osd.skillarr[i] = this.selectNew.data;
                  break;
               }
            }
            for(i = 0; i < this.newSkillData.nsd.skillarr.length; i++)
            {
               if(this.newSkillData.nsd.skillarr[i].skillid == this.selectNew.data.skillid)
               {
                  break;
               }
            }
            new Alert().show("技能替换成功");
         }
         else if(this.newSkillData.osd.skillarr.length < 4)
         {
            this.newSkillData.osd.skillarr.push(this.selectNew.data);
            len = int((this.newSkillData.nsd.skillarr as Array).length);
            for(i = 0; i < len; i++)
            {
               if(this.newSkillData.nsd.skillarr[i].skillid == this.selectNew.data.skillid)
               {
                  (this.newSkillData.nsd.skillarr as Array).splice(i,1);
                  break;
               }
            }
         }
         else
         {
            new Alert().show("请选你要替换的旧技能。");
         }
         this.selectNew = null;
         this.selectOld = null;
         this.showNewSkill();
         this.showOldSkill();
         this.changdata.uniqueid = this.spiritData.id;
         this.changdata.newskillarr = this.newSkillData.osd.skillarr;
         this.changdata.key = this.newSkillData.key;
         this.dispatchEvent(new Event("clickwakeupbtn"));
      }
      
      public function newOldSkillBack(obj:Object) : void
      {
         this.newSkillData = obj;
         if(bg != null)
         {
            this.showNewSkill();
            this.showOldSkill();
         }
      }
      
      private function showOldSkill() : void
      {
         if(this.newSkillData != null && Boolean(this.newSkillData.hasOwnProperty("osd")))
         {
            this.skillOldList.dataProvider = this.newSkillData.osd.skillarr;
            if(this.newSkillData.osd.skillarr.length < 4)
            {
               this.bg["changeBtn"].visible = false;
               this.bg["learnBtn"].visible = true;
            }
            else
            {
               this.bg["changeBtn"].visible = true;
               this.bg["learnBtn"].visible = false;
            }
         }
         if(!this.contains(this.skillOldList))
         {
            this.addChild(this.skillOldList);
         }
      }
      
      private function showNewSkill() : void
      {
         var list:Array = null;
         if(this.newSkillData != null && Boolean(this.newSkillData.hasOwnProperty("nsd")) && Boolean(this.newSkillData.nsd.skillarr))
         {
            list = (this.newSkillData.nsd.skillarr as Array).filter(this.skillFilter);
            list = list.filter(this.fillter2);
            list.sortOn("skillid",Array.NUMERIC);
            if(list.length <= this.rowLength)
            {
               this.bg["pagemc"].visible = false;
               this.skillNewList.dataProvider = list;
            }
            else
            {
               this.bg["pagemc"].visible = true;
               this.hideLeft();
               this.showRight();
               this.getFiveData();
            }
         }
         if(!this.contains(this.skillNewList))
         {
            this.addChild(this.skillNewList);
         }
      }
      
      private function hideLeft() : void
      {
         this.showLeft();
         this.leftState = false;
         this.bg.pagemc.leftbtn.filters = ColorUtil.getColorMatrixFilterGray();
      }
      
      private function showLeft() : void
      {
         this.leftState = true;
         this.bg.pagemc.leftbtn.filters = null;
      }
      
      private function hideRight() : void
      {
         this.showRight();
         this.rightState = false;
         this.bg.pagemc.rightbtn.filters = ColorUtil.getColorMatrixFilterGray();
      }
      
      private function showRight() : void
      {
         this.rightState = true;
         this.bg.pagemc.rightbtn.filters = null;
      }
      
      private function onMouseClickLeft(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         if(!this.leftState)
         {
            return;
         }
         --this.currentPage;
         this.getFiveData();
      }
      
      private function onMouseClickRight(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         if(!this.rightState)
         {
            return;
         }
         ++this.currentPage;
         this.getFiveData();
      }
      
      private function getFiveData() : void
      {
         var list:Array = (this.newSkillData.nsd.skillarr as Array).filter(this.skillFilter);
         list = list.filter(this.fillter2);
         list.sortOn("skillid",Array.NUMERIC);
         var tempArr:Array = [];
         tempArr = list.slice(this.currentPage * this.rowLength,this.currentPage * this.rowLength + this.rowLength);
         this.skillNewList.dataProvider = tempArr;
         this.bg["pagemc"]["pageTxt"].text = this.currentPage + 1 + "/" + Math.ceil(list.length / this.rowLength);
         if(this.currentPage != 0)
         {
            this.showLeft();
         }
         else
         {
            this.hideLeft();
         }
         if(this.currentPage == Math.ceil(list.length / this.rowLength) - 1)
         {
            this.hideRight();
         }
         else
         {
            this.showRight();
         }
      }
      
      private function skillFilter(element:*, index:int, arr:Array) : Boolean
      {
         return element.skillid == 0 ? false : true;
      }
      
      private function fillter2(element:*, index:int, arr:Array) : Boolean
      {
         var obj:Object = null;
         for each(obj in this.newSkillData.osd.skillarr)
         {
            if(obj.skillid == element.skillid)
            {
               return false;
            }
         }
         return true;
      }
      
      private function filter3(element:*, index:int, arr:Array) : Boolean
      {
         var obj:Object = null;
         for each(obj in this.newSkillData.nsd.skillarr)
         {
            if(obj.skillid == element.skillid)
            {
               return false;
            }
         }
         return true;
      }
      
      private function closeWindow(evt:MouseEvent) : void
      {
         ApplicationFacade.getInstance().removeViewLogic(WinSkillControl.NAME);
         if(CacheUtil.pool[Props] as DisplayObject != null)
         {
            if(this.parent.contains(CacheUtil.pool[Props] as DisplayObject))
            {
               this.parent.removeChild(CacheUtil.pool[Props] as DisplayObject);
            }
         }
         if(Boolean(this._attIcon))
         {
            this._attIcon.dispose();
            this._attIcon = null;
         }
         CacheUtil.deleteObject(WakeSkillView);
         this.showLeft();
         this.showRight();
         ToolTip.LooseDO(bg["symm"]);
         this.parent.removeChild(this);
         this.selectNew = null;
         this.selectOld = null;
         this.currentPage = 0;
         this.disport();
      }
      
      override public function disport() : void
      {
         ApplicationFacade.getInstance().removeViewLogic(WinSkillControl.NAME);
         CacheUtil.deleteObject(WakeSkillView);
         super.disport();
      }
   }
}

