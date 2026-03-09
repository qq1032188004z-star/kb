package com.game.modules.view.monsteridentify
{
   import com.game.Tools.AttributeCharacterIcon;
   import com.game.facade.ApplicationFacade;
   import com.game.manager.EventManager;
   import com.game.modules.control.monsteridentify.MonsterShowControl;
   import com.game.modules.view.item.MonsterIdentifyItem;
   import com.game.util.CacheUtil;
   import com.game.util.ColorUtil;
   import com.game.util.HLoaderSprite;
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
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   
   public class MonsterShowView extends HLoaderSprite
   {
      
      public static const SURECHECKMONSTER:String = "surecheckmonster";
      
      private var mList:TileList;
      
      private var replaceMc:MovieClip;
      
      public var packID:int;
      
      private var imgloader:Loader;
      
      public var packIID:int;
      
      public var monsterdetail:Object;
      
      private var _attIcon:AttributeCharacterIcon;
      
      public var flag:int = 1;
      
      public function MonsterShowView()
      {
         super();
         GreenLoading.loading.visible = true;
         this.imgloader = new Loader();
         this.url = "assets/monsteridentify/monsteridentify1.swf";
         this.mList = new TileList(298,252);
         this.mList.build(2,3,150,65,-5,10,MonsterIdentifyItem);
         this.mList.addEventListener(ItemClickEvent.ITEMCLICKEVENT,this.onItemClick,true);
      }
      
      override public function setShow() : void
      {
         this.replaceMc = bg;
         this.replaceMc.cacheAsBitmap = true;
         this.addChild(this.mList);
         this.addChild(this.imgloader);
         this._attIcon = new AttributeCharacterIcon();
         this._attIcon.isShowAttWord = false;
         bg["spAtt"].addChild(this._attIcon);
         this.imgloader.x = 520;
         this.imgloader.y = 190;
         this.initEvents();
         this.replaceMc.symm.visible = false;
         ApplicationFacade.getInstance().registerViewLogic(new MonsterShowControl(this));
         GreenLoading.loading.visible = false;
      }
      
      public function initEvents() : void
      {
         EventManager.attachEvent(this.replaceMc.guanbi,MouseEvent.CLICK,this.closeWindow);
         EventManager.attachEvent(this.replaceMc.queren,MouseEvent.CLICK,this.onsureAlertHandler);
         EventManager.attachEvent(this.replaceMc.qvxiao,MouseEvent.CLICK,this.closeWindow);
         EventManager.attachEvent(this,Event.REMOVED_FROM_STAGE,this.onRemoveFromStage);
      }
      
      public function bigbuild(tempData:Object) : void
      {
         var xml:XML = null;
         if(this.replaceMc != null)
         {
            this.replaceMc.nameTxt.text = tempData == null ? "" : tempData.name;
            this.replaceMc.levelTxt.text = tempData == null ? "" : tempData.level;
            this.replaceMc.needExpTxt.text = tempData == null ? "" : this.getNeedExp(tempData.needExp,tempData.exp);
            this.replaceMc.modoTxt.text = tempData == null ? "" : CommonDefine.moldList[tempData.mold - 1];
            this.replaceMc.timeTxt.text = tempData == null ? "" : TimeTransform.getInstance().transDate(int(tempData.timetxt));
            this.replaceMc.geniusTxt.text = tempData == null ? "" : tempData.CountGeniuscount;
            xml = XMLLocator.getInstance().getSprited(tempData.iid);
            this.replaceMc.idTxt.text = tempData == null ? "" : xml.sequence;
            this.replaceMc.expBarMc.gotoAndStop(tempData == null ? 1 : this.transNeedExp(tempData.needExp,tempData.exp));
            this._attIcon.id = tempData == null ? 1 : int(tempData.type);
            this.replaceMc.tili.text = tempData == null ? "" : tempData.strength;
            this.replaceMc.gongji.text = tempData == null ? "" : tempData.attack;
            this.replaceMc.fashu.text = tempData == null ? "" : tempData.magic;
            this.replaceMc.sudu.text = tempData == null ? "" : tempData.speed;
            this.replaceMc.fangyu.text = tempData == null ? "" : tempData.defence;
            this.replaceMc.kangxing.text = tempData == null ? "" : tempData.resistance;
            if(tempData != null && Boolean(tempData.hasOwnProperty("symmList")) && tempData.symmList.length > 0)
            {
               ToolTip.setDOInfo(this.replaceMc.symm,"已装备灵玉");
               this.replaceMc.symm.filters = [];
               this.replaceMc.symm.visible = true;
            }
            else
            {
               ToolTip.setDOInfo(this.replaceMc.symm,"未装备灵玉");
               this.replaceMc.symm.filters = ColorUtil.getColorMatrixFilterGray();
               this.replaceMc.symm.visible = true;
            }
            this.imgloader.unload();
            if(tempData != null)
            {
               this.imgloader.load(new URLRequest(URLUtil.getSvnVer("assets/monsterswf/" + tempData.iid + ".swf")));
               this.imgloader.scaleX = 1.2;
               this.imgloader.scaleY = 1.2;
            }
         }
         this.monsterdetail = tempData;
      }
      
      private function onItemClick(evt:ItemClickEvent) : void
      {
         var tempItem:MonsterIdentifyItem = null;
         if(this.flag == 0)
         {
            return;
         }
         this.packID = evt.params.id;
         this.packIID = evt.params.iid;
         for(var i:int = 0; i < this.mList.numChildren; i++)
         {
            tempItem = this.mList.getChildAt(i) as MonsterIdentifyItem;
            if(this.packID == tempItem.data.id)
            {
               tempItem.bg.gotoAndStop(2);
            }
            else
            {
               tempItem.bg.gotoAndStop(1);
            }
         }
         this.bigbuild(evt.params);
      }
      
      public function build(params:Object) : void
      {
         if(Boolean(params.monsterlist) && params.monsterlist.length > 0)
         {
            this.mList.dataProvider = params.monsterlist;
         }
         else
         {
            this.mList.dataProvider = [];
            new Alert().show("你的宠物背包没有宠物了~");
         }
         this.bigbuild(params.monsterlist[0]);
      }
      
      private function getNeedExp(needExp:int, currentExp:int) : String
      {
         return currentExp + "/" + needExp;
      }
      
      private function transNeedExp(needExp:int, currentExp:int) : int
      {
         return Math.floor(currentExp / needExp * 100);
      }
      
      public function closeWindow(evt:MouseEvent) : void
      {
         if(Boolean(this.imgloader))
         {
            this.imgloader.unloadAndStop(false);
         }
         this.mList.dataProvider = [];
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
      
      private function onsureAlertHandler(event:MouseEvent) : void
      {
         if(Boolean(this.packID) && this.flag == 1)
         {
            new Alert().showSureOrCancel("对妖怪进行潜力鉴定需要花费50铜钱，是否继续进行鉴定？",this.sureHandler);
            this.flag = 0;
         }
         else if(this.packID == 0)
         {
            new Alert().show("请选择你所需要进行潜力鉴定的妖怪！");
         }
      }
      
      private function onRemoveFromStage(evt:Event) : void
      {
         if(this.replaceMc != null)
         {
            this.replaceMc.nameTxt.text = "";
            this.replaceMc.levelTxt.text = "";
            this.replaceMc.needExpTxt.text = "";
            this.replaceMc.modoTxt.text = "";
            this.replaceMc.timeTxt.text = "";
            this.replaceMc.geniusTxt.text = "";
            this.replaceMc.idTxt.text = "";
            this.replaceMc.expBarMc.gotoAndStop(1);
            this.replaceMc.tili.text = "";
            this.replaceMc.gongji.text = "";
            this.replaceMc.fashu.text = "";
            this.replaceMc.sudu.text = "";
            this.replaceMc.fangyu.text = "";
            this.replaceMc.kangxing.text = "";
            ToolTip.LooseDO(this.replaceMc.symm);
         }
         EventManager.removeEvent(this.replaceMc.guanbi,MouseEvent.CLICK,this.closeWindow);
         EventManager.removeEvent(this.replaceMc.queren,MouseEvent.CLICK,this.onsureAlertHandler);
         EventManager.removeEvent(this.replaceMc.qvxiao,MouseEvent.CLICK,this.closeWindow);
         EventManager.removeEvent(this,Event.REMOVED_FROM_STAGE,this.onRemoveFromStage);
      }
      
      private function sureHandler(str:String, data:Object) : void
      {
         if(str == "确定")
         {
            dispatchEvent(new Event(MonsterShowView.SURECHECKMONSTER));
         }
         if(str == "取消")
         {
            this.flag = 1;
         }
      }
      
      override public function disport() : void
      {
         if(Boolean(this._attIcon))
         {
            this._attIcon.dispose();
            this._attIcon = null;
         }
         CacheUtil.deleteObject(MonsterShowView);
         ApplicationFacade.getInstance().removeViewLogic(MonsterShowControl.NAME);
         super.disport();
      }
   }
}

