package com.game.modules.view.skillsort
{
   import com.core.observer.MessageEvent;
   import com.game.Tools.AttributeCharacterIcon;
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.locators.GameData;
   import com.game.manager.EventManager;
   import com.game.modules.control.skillsort.SortControl;
   import com.game.modules.view.item.SkillItem;
   import com.game.util.ColorUtil;
   import com.game.util.HLoaderSprite;
   import com.game.util.HtmlUtil;
   import com.game.util.TimeTransform;
   import com.kb.util.CommonDefine;
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.alert.Alert;
   import com.publiccomponent.events.ItemClickEvent;
   import com.publiccomponent.list.TileList;
   import com.publiccomponent.loading.GreenLoading;
   import com.publiccomponent.loading.XMLLocator;
   import com.publiccomponent.ui.ToolTip;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   
   public class SortView extends HLoaderSprite
   {
      
      private var skilllist:TileList;
      
      private var tempSkillList:Array;
      
      public var tempData:Object;
      
      private var initialSkillList:Array;
      
      private var imgloader:Loader;
      
      private var _attIcon:AttributeCharacterIcon;
      
      private var currentSkillid:int;
      
      private var currentSkillindex:int;
      
      private var tempItem:SkillItem;
      
      private var flag:Boolean = true;
      
      public function SortView()
      {
         GreenLoading.loading.visible = true;
         super();
         this.url = "assets/material/SkillSortView.swf";
      }
      
      override public function setShow() : void
      {
         this.bg.cacheAsBitmap = true;
         this.imgloader = new Loader();
         this.skilllist = new TileList(465,100);
         this.skilllist.build(1,4,140,-1,13,75,SkillItem);
         this.addChild(this.skilllist);
         this.addChild(this.imgloader);
         this.imgloader.x = 120;
         this.imgloader.y = 125;
         ApplicationFacade.getInstance().registerViewLogic(new SortControl(this));
         GreenLoading.loading.visible = false;
      }
      
      override public function initParams(params:Object = null) : void
      {
         this.tempData = params.body;
      }
      
      public function initEvents() : void
      {
         EventManager.attachEvent(this.skilllist,ItemClickEvent.ITEMCLICKEVENT,this.itemClick,true);
         EventManager.attachEvent(bg.confirmBtn,MouseEvent.CLICK,this.cofirmSort);
         EventManager.attachEvent(bg.reseatBtn,MouseEvent.CLICK,this.reseatSort);
         EventManager.attachEvent(bg.upBtn,MouseEvent.CLICK,this.upSort);
         EventManager.attachEvent(bg.downBtn,MouseEvent.CLICK,this.downSort);
         EventManager.attachEvent(bg.closeBtn,MouseEvent.CLICK,this.closeWindow);
      }
      
      public function removeEvents() : void
      {
         EventManager.removeEvent(this.skilllist,ItemClickEvent.ITEMCLICKEVENT,this.itemClick);
         EventManager.removeEvent(bg.confirmBtn,MouseEvent.CLICK,this.cofirmSort);
         EventManager.removeEvent(bg.reseatBtn,MouseEvent.CLICK,this.reseatSort);
         EventManager.removeEvent(bg.upBtn,MouseEvent.CLICK,this.upSort);
         EventManager.removeEvent(bg.downBtn,MouseEvent.CLICK,this.downSort);
         EventManager.removeEvent(bg.closeBtn,MouseEvent.CLICK,this.closeWindow);
      }
      
      public function build() : void
      {
         var xml:XML = null;
         var i:int = 0;
         if(this.tempData != null && bg != null)
         {
            bg.nameTxt.text = this.tempData == null ? "" : this.tempData.name;
            bg.levelTxt.text = this.tempData == null ? "" : this.tempData.level;
            bg.needExpTxt.text = this.tempData == null ? "" : this.getNeedExp(this.tempData.needExp,this.tempData.exp);
            bg.modoTxt.text = this.tempData == null ? "" : CommonDefine.moldList[this.tempData.mold - 1];
            bg.timeTxt.text = this.tempData == null ? "" : TimeTransform.getInstance().transDate(int(this.tempData.timetxt));
            bg.geniusTxt.text = this.tempData == null ? "" : this.tempData.CountGeniuscount;
            xml = XMLLocator.getInstance().getSprited(this.tempData.iid);
            bg.idTxt.text = this.tempData == null ? "" : xml.sequence;
            bg.expBarMc.gotoAndStop(this.tempData == null ? 1 : this.transNeedExp(this.tempData.needExp,this.tempData.exp));
            if(this._attIcon == null)
            {
               this._attIcon = new AttributeCharacterIcon();
               bg["spAtt"].addChild(this._attIcon);
            }
            this._attIcon.id = this.tempData == null ? 1 : int(this.tempData.type);
            bg.hpTxt.text = this.tempData == null ? "" : this.tempData.strength;
            bg.attackTxt.text = this.tempData == null ? "" : this.tempData.attack;
            bg.magicTxt.text = this.tempData == null ? "" : this.tempData.magic;
            bg.speedTxt.text = this.tempData == null ? "" : this.tempData.speed;
            bg.defenceTxt.text = this.tempData == null ? "" : this.tempData.defence;
            bg.strTxt.text = this.tempData == null ? "" : this.tempData.resistance;
            if(Boolean(this.tempData.hasOwnProperty("symmFlag")) && Boolean(this.tempData.symmFlag))
            {
               bg["symm"].filters = [];
               ToolTip.setDOInfo(bg["symm"],"已装备灵玉");
            }
            else
            {
               bg["symm"].filters = ColorUtil.getColorMatrixFilterGray();
               ToolTip.setDOInfo(bg["symm"],"未装备灵玉");
            }
            bg.hppotentialTxt.text = this.tempData == null ? "" : this.tempData.hpLearnValue;
            bg.attpotentialTxt.text = this.tempData == null ? "" : this.tempData.attackLearnValue;
            bg.magicpotentialTxt.text = this.tempData == null ? "" : this.tempData.magicLearnValue;
            bg.speedpotentialTxt.text = this.tempData == null ? "" : this.tempData.speedLearnVale;
            bg.defpotentialTxt.text = this.tempData == null ? "" : this.tempData.defenceLearnValue;
            bg.strpotentialTxt.text = this.tempData == null ? "" : this.tempData.resistanceLearnValue;
            ToolTip.setDOInfo(bg.xiuwei1,HtmlUtil.getHtmlText(12,"#000000","修为"));
            ToolTip.setDOInfo(bg.xiuwei2,HtmlUtil.getHtmlText(12,"#000000","修为"));
            ToolTip.setDOInfo(bg.xiuwei3,HtmlUtil.getHtmlText(12,"#000000","修为"));
            ToolTip.setDOInfo(bg.xiuwei4,HtmlUtil.getHtmlText(12,"#000000","修为"));
            ToolTip.setDOInfo(bg.xiuwei5,HtmlUtil.getHtmlText(12,"#000000","修为"));
            ToolTip.setDOInfo(bg.xiuwei6,HtmlUtil.getHtmlText(12,"#000000","修为"));
            this.imgloader.unload();
            this.imgloader.load(new URLRequest(URLUtil.getSvnVer("assets/monsterswf/" + this.tempData.iid + ".swf")));
            this.imgloader.scaleX = 1.4;
            this.imgloader.scaleY = 1.4;
            for(i = 0; i < this.tempData.skilllist.length; i++)
            {
               this.tempData.skilllist[i].canclick = true;
               this.tempData.skilllist[i].arrindex = i;
               this.tempData.skilllist[i].initialindex = i;
            }
            this.skilllist.dataProvider = this.tempData.skilllist;
            this.initialSkillList = this.tempData.skilllist.concat();
            this.tempSkillList = this.tempData.skilllist;
         }
      }
      
      private function itemClick(evt:ItemClickEvent) : void
      {
         var item:SkillItem = null;
         this.currentSkillid = evt.params.skillid;
         this.currentSkillindex = evt.params.arrindex;
         var num:int = this.skilllist.numChildren;
         for(var i:int = 0; i < num; i++)
         {
            item = this.skilllist.getChildAt(i) as SkillItem;
            if(item.data.skillid == this.currentSkillid)
            {
               item.filters = ColorUtil.getGrowFilter();
            }
            else
            {
               item.filters = [];
            }
         }
      }
      
      private function getItemById(id:int) : SkillItem
      {
         for(var i:int = 0; i < this.tempSkillList.length; )
         {
            if((this.skilllist.getChildAt(i) as SkillItem).data.skillid == id)
            {
               this.tempItem = this.skilllist.getChildAt(i) as SkillItem;
            }
            i++;
         }
         return this.tempItem;
      }
      
      private function getNeedExp(needExp:int, currentExp:int) : String
      {
         return currentExp + "/" + needExp;
      }
      
      private function transNeedExp(needExp:int, currentExp:int) : int
      {
         return Math.floor(currentExp / needExp * 100);
      }
      
      public function cofirmSort(evt:MouseEvent) : void
      {
         var a:Boolean = false;
         var b:Boolean = false;
         var j:int = 0;
         var arr:Array = [];
         arr.push(this.tempData.id);
         arr.push(this.tempSkillList.length);
         var tslen:int = int(this.tempSkillList.length);
         for(var i:int = 0; i < tslen; i++)
         {
            arr[i + 2] = this.tempSkillList[i].initialindex;
         }
         if(this.flag)
         {
            b = true;
            for(j = 0; j < tslen; j++)
            {
               a = this.tempSkillList[j].skillid == this.initialSkillList[j].skillid;
               b = a && b;
            }
            if(b)
            {
               new Alert().show("你的妖怪技能顺序没变哦~");
               this.flag = true;
               this.closeWindow(null);
            }
            else if(GameData.instance.playerData.isVip)
            {
               this.flag = true;
               this.dispatchEvent(new MessageEvent(EventConst.STARTSORT,{"arrid":arr}));
            }
            else
            {
               if(GameData.instance.playerData.coin < 100)
               {
                  new Alert().show("你身上不足100铜钱，无法继续对妖怪进行技能排序。");
                  this.flag = true;
                  return;
               }
               new Alert().showSureOrCancel("完成本次技能排序需要花费100铜钱，是否确定继续？",this.sureHandler,{"arrid":arr});
               this.flag = false;
            }
         }
      }
      
      private function sureHandler(str:String, data:Object) : void
      {
         if(str == "确定")
         {
            this.dispatchEvent(new MessageEvent(EventConst.STARTSORT,data));
            this.flag = true;
         }
         if(str == "取消")
         {
            this.flag = true;
         }
      }
      
      public function reseatSort(evt:MouseEvent) : void
      {
         this.skilllist.dataProvider = this.initialSkillList.concat();
         this.tempSkillList = this.initialSkillList.concat();
         var datalen:int = int(this.skilllist.dataProvider.length);
         for(var i:int = 0; i < datalen; i++)
         {
            this.skilllist.dataProvider[i].arrindex = i;
            this.tempSkillList[i].arrindex = i;
         }
         this.currentSkillindex = -1;
         this.currentSkillid = -1;
      }
      
      public function upSort(evt:MouseEvent) : void
      {
         var tslen:int = 0;
         var i:int = 0;
         if(this.currentSkillindex == -1)
         {
            return;
         }
         if(this.currentSkillindex > 0)
         {
            tslen = int(this.tempSkillList.length);
            for(i = 0; i < tslen; i++)
            {
               if(this.tempSkillList[i].skillid == this.currentSkillid)
               {
                  --this.tempSkillList[i].arrindex;
                  --this.currentSkillindex;
                  ++this.tempSkillList[i - 1].arrindex;
                  this.tempSkillList.sortOn("arrindex",Array.NUMERIC);
                  this.skilllist.dataProvider = this.tempSkillList;
                  break;
               }
            }
         }
         this.itemMoveClick();
      }
      
      public function downSort(evt:MouseEvent) : void
      {
         var i:int = 0;
         if(this.currentSkillindex == -1)
         {
            return;
         }
         var tslen:int = int(this.tempSkillList.length);
         if(this.currentSkillindex < tslen - 1)
         {
            for(i = 0; i < tslen; i++)
            {
               if(this.tempSkillList[i].skillid == this.currentSkillid)
               {
                  ++this.tempSkillList[i].arrindex;
                  ++this.currentSkillindex;
                  --this.tempSkillList[i + 1].arrindex;
                  this.tempSkillList.sortOn("arrindex",Array.NUMERIC);
                  this.skilllist.dataProvider = this.tempSkillList;
                  break;
               }
            }
         }
         this.itemMoveClick();
      }
      
      private function itemMoveClick() : void
      {
         var item:SkillItem = null;
         var num:int = this.skilllist.numChildren;
         for(var i:int = 0; i < num; i++)
         {
            item = this.skilllist.getChildAt(i) as SkillItem;
            if(item.data.skillid == this.currentSkillid)
            {
               item.filters = ColorUtil.getGrowFilter();
            }
            else
            {
               item.filters = [];
            }
         }
      }
      
      public function closeWindow(evt:Event) : void
      {
         ToolTip.LooseDO(bg["symm"]);
         if(Boolean(this._attIcon))
         {
            this._attIcon.dispose();
            this._attIcon = null;
         }
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

