package com.game.modules.view.trump
{
   import com.core.observer.MessageEvent;
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.global.GlobalConfig;
   import com.game.locators.GameData;
   import com.game.manager.EventManager;
   import com.game.modules.control.task.TaskList;
   import com.game.modules.control.trump.TrumpEvent;
   import com.game.modules.control.trump.TrumpInfoControl;
   import com.game.modules.view.skillsort.SkillSort;
   import com.game.modules.view.wakeup.SelectSpiritView;
   import com.game.util.CacheUtil;
   import com.game.util.ColorUtil;
   import com.game.util.HLoaderSprite;
   import com.game.util.TimeTransform;
   import com.publiccomponent.alert.Alert;
   import com.publiccomponent.loading.GreenLoading;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.utils.getQualifiedClassName;
   import flash.utils.setTimeout;
   
   public class TrumpInfoview extends HLoaderSprite
   {
      
      private var trumpInfoClip:MovieClip;
      
      public var infoParams:Object;
      
      public var masterId:int;
      
      public var lastname:String;
      
      private var pageNum:int = 6;
      
      private var currentPage:int;
      
      private var totalPage:int;
      
      private var params:Object;
      
      private var trumpArr:Array;
      
      private var btnArr:Array = [];
      
      private var loaderArr:Array = [];
      
      public function TrumpInfoview()
      {
         GreenLoading.loading.visible = true;
         super();
         this.url = "assets/material/trumpInfo.swf";
      }
      
      override public function setShow() : void
      {
         this.trumpInfoClip = this.bg;
         this.pushBtnToArr();
         this.setMouseEnable(false);
         addChild(this.trumpInfoClip);
         this.trumpInfoClip.vipMc.visible = false;
         this.trumpInfoClip.vipMc.levelClip.gotoAndStop(1);
         this.trumpInfoClip.baseInfo.tipTxt.visible = false;
         this.trumpInfoClip.showClip.gotoAndStop(1);
         ApplicationFacade.getInstance().registerViewLogic(new TrumpInfoControl(this));
         GreenLoading.loading.visible = false;
      }
      
      override public function initParams(params:Object = null) : void
      {
         this.masterId = int(params.body);
         this.params = params.params;
         TaskList.getInstance().checkUrlAndFreshManTask(url);
      }
      
      private function pushBtnToArr() : void
      {
         this.btnArr.push(this.trumpInfoClip.baseInfo.btn1);
         this.btnArr.push(this.trumpInfoClip.baseInfo.btn3);
         this.btnArr.push(this.trumpInfoClip.baseInfo.btn5);
         this.btnArr.push(this.trumpInfoClip.baseInfo.btn6);
         this.btnArr.push(this.trumpInfoClip.baseInfo.btn8);
         this.btnArr.push(this.trumpInfoClip.baseInfo.btn9);
         this.btnArr.push(this.trumpInfoClip.baseInfo.btn10);
         this.btnArr.push(this.trumpInfoClip.baseInfo.btn11);
         this.btnArr.push(this.trumpInfoClip.backBtn);
         this.btnArr.push(this.trumpInfoClip.changeBtn);
         this.btnArr.push(this.trumpInfoClip.changeMc.shopBtn);
      }
      
      public function initEvents() : void
      {
         EventManager.attachEvent(this.trumpInfoClip.closeBtn,MouseEvent.CLICK,this.closeView);
         for(var i:int = 0; i < this.btnArr.length; i++)
         {
            EventManager.attachEvent(this.btnArr[i],MouseEvent.CLICK,this.onFunclick);
         }
         for(i = 0; i < 6; i++)
         {
            EventManager.attachEvent(this.trumpInfoClip.changeMc["changeBtn" + i],MouseEvent.MOUSE_DOWN,this.onChangeTrump);
         }
         EventManager.attachEvent(this.trumpInfoClip.changeMc.recoverBtn,MouseEvent.MOUSE_DOWN,this.recoverTrump);
      }
      
      public function removeEvents() : void
      {
         EventManager.removeEvent(this.trumpInfoClip.closeBtn,MouseEvent.CLICK,this.closeView);
         for(var i:int = 0; i < this.btnArr.length; i++)
         {
            EventManager.removeEvent(this.btnArr[i],MouseEvent.CLICK,this.onFunclick);
         }
         for(i = 0; i < 6; i++)
         {
            EventManager.removeEvent(this.trumpInfoClip.changeMc["changeBtn" + i],MouseEvent.MOUSE_DOWN,this.onChangeTrump);
         }
         EventManager.removeEvent(this.trumpInfoClip.changeMc.recoverBtn,MouseEvent.MOUSE_DOWN,this.recoverTrump);
      }
      
      private function recoverTrump(evt:MouseEvent) : void
      {
         if(this.infoParams.trumpAppearance != 0)
         {
            dispatchEvent(new MessageEvent(TrumpEvent.changeTrump,0));
         }
      }
      
      public function changeDecor(id:int) : void
      {
         this.infoParams.trumpAppearance = id;
         this.build();
         this.showPage(this.currentPage);
      }
      
      private function setMouseEnable(bo:Boolean) : void
      {
         for(var i:int = 0; i < this.btnArr.length; i++)
         {
            if(bo)
            {
               this.btnArr[i].mouseEnabled = true;
               this.btnArr[i].filters = [];
            }
            else
            {
               this.btnArr[i].mouseEnabled = false;
               this.btnArr[i].filters = ColorUtil.getColorMatrixFilterGray();
            }
         }
         this.trumpInfoClip.changeMc.visible = false;
         this.trumpInfoClip.backBtn.visible = false;
         this.trumpInfoClip.changeBtn.visible = true;
         this.trumpInfoClip.baseInfo.visible = true;
         if(int(this.params.state) == 1)
         {
            this.trumpInfoClip.baseInfo.btn8.visible = true;
            this.trumpInfoClip.baseInfo.btn9.visible = false;
         }
         else
         {
            this.trumpInfoClip.baseInfo.btn8.visible = false;
            this.trumpInfoClip.baseInfo.btn9.visible = true;
         }
      }
      
      private function onFunclick(evt:MouseEvent) : void
      {
         switch(evt.currentTarget)
         {
            case this.trumpInfoClip.baseInfo.btn3:
               this.cureAllMonster();
               break;
            case this.trumpInfoClip.baseInfo.btn5:
               this.openDistributeExpView();
               break;
            case this.trumpInfoClip.baseInfo.btn7:
               this.openMonsterTrainView();
               break;
            case this.trumpInfoClip.baseInfo.btn1:
               this.openSkillSortView();
               break;
            case this.trumpInfoClip.baseInfo.btn6:
               this.openDistributeXiuwei();
               break;
            case this.trumpInfoClip.baseInfo.btn8:
               this.trumpInfoClip.baseInfo.btn8.visible = false;
               this.trumpInfoClip.baseInfo.btn9.visible = true;
               if(GameData.instance.playerData.isInHouse && GlobalConfig.userId == GameData.instance.playerData.houseId)
               {
                  ApplicationFacade.getInstance().dispatch(EventConst.REQ_RECALL_TRUMP,2);
               }
               else
               {
                  ApplicationFacade.getInstance().dispatch(EventConst.REQ_RECALL_TRUMP,3);
               }
               break;
            case this.trumpInfoClip.baseInfo.btn9:
               this.trumpInfoClip.baseInfo.btn8.visible = true;
               this.trumpInfoClip.baseInfo.btn9.visible = false;
               ApplicationFacade.getInstance().dispatch(EventConst.REQ_RECALL_TRUMP,1);
               break;
            case this.trumpInfoClip.baseInfo.btn10:
               if(GameData.instance.playerData.isVip)
               {
                  ApplicationFacade.getInstance().dispatch(EventConst.BOBSTATECLICK,{
                     "url":"assets/module/AlchemyModule.swf",
                     "xCoord":0,
                     "yCoord":0
                  });
               }
               else
               {
                  new Alert().showVip("只有VIP才可以远程打开炼丹炉哦！");
               }
               break;
            case this.trumpInfoClip.baseInfo.btn11:
               if(GameData.instance.playerData.isVip)
               {
                  ApplicationFacade.getInstance().dispatch(EventConst.OPEN_CACHE_VIEW,{
                     "showX":0,
                     "showY":0
                  },null,getQualifiedClassName(SelectSpiritView));
                  GlobalConfig.otherObj["IsOpenTrumpInfo"] = true;
                  setTimeout(function():void
                  {
                     closeView(null);
                  },300);
               }
               else
               {
                  new Alert().showVip("只有VIP才可以远程替换技能哦！");
               }
               break;
            case this.trumpInfoClip.backBtn:
               this.onBack();
               break;
            case this.trumpInfoClip.changeBtn:
               this.onChange();
               break;
            case this.trumpInfoClip.changeMc.shopBtn:
               this.onShop();
         }
      }
      
      private function onShop() : void
      {
         ApplicationFacade.getInstance().dispatch(EventConst.BOBSTATECLICK,{
            "url":"assets/mall/MallUI.swf",
            "xCoord":0,
            "yCoord":0,
            "moduleParams":{"actTab":"trump"}
         });
         this.closeView(null);
      }
      
      private function onBack() : void
      {
         this.trumpInfoClip.changeBtn.visible = true;
         this.trumpInfoClip.changeMc.visible = false;
         this.trumpInfoClip.baseInfo.visible = true;
         this.trumpInfoClip.backBtn.visible = false;
      }
      
      private function onChange() : void
      {
         if(GameData.instance.playerData.isVip)
         {
            this.trumpInfoClip.backBtn.visible = true;
            this.trumpInfoClip.changeBtn.visible = false;
            this.trumpInfoClip.changeMc.visible = true;
            this.trumpInfoClip.baseInfo.visible = false;
         }
         else
         {
            ApplicationFacade.getInstance().dispatch(EventConst.OPEN_MODULE,{"url":"assets/vipprivilege/TrumpAlert.swf"});
         }
      }
      
      private function openDistributeXiuwei() : void
      {
         if(this.infoParams.id != GlobalConfig.userId)
         {
            return;
         }
         ApplicationFacade.getInstance().dispatch(EventConst.OPEN_CACHE_VIEW,{
            "showX":100,
            "showY":50
         },null,getQualifiedClassName(XiuweiView));
      }
      
      public function setData(params:Object) : void
      {
         this.infoParams = params;
         if(this.infoParams.id == GlobalConfig.userId)
         {
            this.setMouseEnable(true);
         }
         else
         {
            this.setMouseEnable(false);
         }
         this.build();
      }
      
      public function setTrumpList(params:Object) : void
      {
         this.trumpArr = params.trumpList;
         this.initTrumpList();
      }
      
      private function initTrumpList() : void
      {
         if(this.trumpArr.length == 0)
         {
            this.totalPage = 1;
            this.showPage(1);
         }
         else
         {
            this.totalPage = Math.ceil(this.trumpArr.length / this.pageNum);
            this.showPage(1);
         }
      }
      
      private function onChangeTrump(evt:MouseEvent) : void
      {
         var index:int = int(evt.currentTarget.name.charAt(9));
         dispatchEvent(new MessageEvent(TrumpEvent.changeTrump,this.trumpArr[index + (this.currentPage - 1) * 6]));
      }
      
      private function showPage(index:int) : void
      {
         if(index < 1)
         {
            index = 1;
         }
         if(index > this.totalPage)
         {
            index = this.totalPage;
         }
         this.currentPage = index;
         var itemIndex:int = (this.currentPage - 1) * 6;
         this.trumpInfoClip.changeMc.shopBtn.visible = false;
         this.trumpInfoClip.changeMc.usingMc.visible = false;
         for(var i:int = 0; i < 6; i++)
         {
            if(itemIndex >= this.trumpArr.length)
            {
               break;
            }
            this.showIcon(i,this.trumpArr[itemIndex]);
            if(this.trumpArr[itemIndex] == this.infoParams.trumpAppearance)
            {
               this.trumpInfoClip.changeMc.usingMc.visible = true;
               this.trumpInfoClip.changeMc.addChild(this.trumpInfoClip.changeMc.usingMc);
               this.trumpInfoClip.changeMc.usingMc.x = this.trumpInfoClip.changeMc["icon" + i].x + 20;
               this.trumpInfoClip.changeMc.usingMc.y = this.trumpInfoClip.changeMc["icon" + i].y + 70;
               this.trumpInfoClip.changeMc["changeBtn" + i].visible = false;
            }
            else
            {
               this.trumpInfoClip.changeMc["changeBtn" + i].visible = true;
            }
            itemIndex++;
         }
         if(i < 6)
         {
            this.trumpInfoClip.changeMc.shopBtn.visible = true;
            this.trumpInfoClip.changeMc.shopBtn.x = this.trumpInfoClip.changeMc["icon" + i].x + 25;
            for(this.trumpInfoClip.changeMc.shopBtn.y = this.trumpInfoClip.changeMc["icon" + i].y + 24; i < 6; )
            {
               this.trumpInfoClip.changeMc["changeBtn" + i].visible = false;
               this.hideIcon(i);
               i++;
            }
         }
         this.trumpInfoClip.changeMc.pageTxt.text = this.currentPage + "/" + this.totalPage;
      }
      
      private function showIcon(index:int, id:int) : void
      {
         var loader:Loader = null;
         if(this.loaderArr[index] == null)
         {
            loader = new Loader();
            loader.x = this.trumpInfoClip.changeMc["icon" + index].x + 10;
            loader.y = this.trumpInfoClip.changeMc["icon" + index].y + 10;
            this.trumpInfoClip.changeMc.addChild(loader);
            this.loaderArr[index] = loader;
         }
         else
         {
            loader = this.loaderArr[index];
         }
         loader.visible = true;
         loader.load(new URLRequest("assets/vipprivilege/" + id + ".swf"));
      }
      
      private function hideIcon(index:int) : void
      {
         if(Boolean(this.loaderArr[index]))
         {
            this.loaderArr[index].unload;
            this.loaderArr[index].visible = false;
         }
      }
      
      private function build() : void
      {
         this.trumpInfoClip.baseInfo.scoreTxt.text = this.infoParams.vipSocre + "";
         this.trumpInfoClip.baseInfo.masterTxt.text = this.infoParams.masterName;
         this.trumpInfoClip.baseInfo.barMc.gotoAndStop(this.setBar(this.infoParams.vipLevel));
         this.trumpInfoClip.baseInfo.timeTxt.text = TimeTransform.getInstance().transDate(int(this.infoParams.time));
         if(this.infoParams.issuper == 1 && this.infoParams.vipLevel >= 1)
         {
            this.trumpInfoClip.vipMc.visible = true;
            if(Boolean(this.infoParams.isSupertrump))
            {
               this.trumpInfoClip.vipMc.levelClip.gotoAndStop("supervip");
            }
            else
            {
               this.trumpInfoClip.vipMc.levelClip.gotoAndStop(this.infoParams.vipLevel);
            }
            this.trumpInfoClip.baseInfo.tipTxt.visible = true;
            this.trumpInfoClip.baseInfo.speedTxt.text = "10点/天";
         }
         else if(this.infoParams.vipSocre > 0 && this.infoParams.issuper == 0)
         {
            this.trumpInfoClip.vipMc.visible = true;
            this.trumpInfoClip.vipMc.levelClip.gotoAndStop(this.infoParams.vipLevel);
            this.trumpInfoClip.vipMc.filters = ColorUtil.getColorMatrixFilterGray();
            this.trumpInfoClip.baseInfo.speedTxt.text = "-8点/天";
         }
         else
         {
            this.trumpInfoClip.vipMc.visible = false;
            this.trumpInfoClip.baseInfo.speedTxt.text = "0点/天";
         }
         if(this.infoParams.vipLevel != 0)
         {
            if(this.infoParams.trumpAppearance > 0)
            {
               this.trumpInfoClip.showClip.gotoAndStop("frame" + this.infoParams.trumpAppearance);
            }
            else if(Boolean(this.infoParams.isSupertrump))
            {
               this.trumpInfoClip.showClip.gotoAndStop("framesupervip");
            }
            else if(this.infoParams.vipLevel >= 1 && this.infoParams.vipLevel <= 3)
            {
               this.trumpInfoClip.showClip.gotoAndStop(2);
            }
            else if(this.infoParams.vipLevel >= 4 && this.infoParams.vipLevel <= 5)
            {
               this.trumpInfoClip.showClip.gotoAndStop(3);
            }
            else if(this.infoParams.vipLevel >= 6)
            {
               this.trumpInfoClip.showClip.gotoAndStop(4);
            }
         }
         else
         {
            this.trumpInfoClip.showClip.gotoAndStop(1);
         }
      }
      
      private function setBar(index:int) : int
      {
         var arr:Array = [0,15,38,65,101,140,194];
         return int(arr[index]);
      }
      
      private function cureAllMonster() : void
      {
         if(this.infoParams.id != GlobalConfig.userId)
         {
            return;
         }
         if(GameData.instance.playerData.isVip)
         {
            ApplicationFacade.getInstance().dispatch(EventConst.REQ_DOCTOR_SPIRIT);
         }
         else
         {
            new Alert().showSureOrCancel("你确定花50铜钱治疗所有妖怪吗?",this.closeHandler);
         }
      }
      
      private function closeHandler(str:String, data:Object) : void
      {
         if(str == "确定")
         {
            ApplicationFacade.getInstance().dispatch(EventConst.REQ_DOCTOR_SPIRIT);
         }
      }
      
      private function openSkillSortView() : void
      {
         if(this.infoParams.id != GlobalConfig.userId)
         {
            return;
         }
         ApplicationFacade.getInstance().dispatch(EventConst.OPEN_CACHE_VIEW,{
            "showX":265,
            "showY":83
         },null,getQualifiedClassName(SkillSort));
      }
      
      private function openDistributeExpView() : void
      {
         if(this.infoParams.id != GlobalConfig.userId)
         {
            return;
         }
         ApplicationFacade.getInstance().dispatch(EventConst.OPEN_CACHE_VIEW,{
            "showX":200,
            "showY":100
         },null,getQualifiedClassName(DisExpView));
      }
      
      private function openMonsterTrainView() : void
      {
         if(this.infoParams.id != GlobalConfig.userId)
         {
            return;
         }
         dispatchEvent(new MessageEvent(TrumpEvent.openmonsterTrainWindow));
      }
      
      private function openTrumpToolView(evt:MouseEvent) : void
      {
         if(this.infoParams.id != GlobalConfig.userId)
         {
            return;
         }
         dispatchEvent(new MessageEvent(TrumpEvent.opentrumptoolview));
      }
      
      private function closeView(evt:MouseEvent) : void
      {
         dispatchEvent(new MessageEvent(TrumpEvent.closetrumpinfoview));
      }
      
      public function dispos() : void
      {
         if(this.parent != null)
         {
            if(this.parent.contains(this))
            {
               this.parent.removeChild(this);
            }
         }
      }
      
      private function openTriopdView() : void
      {
         ApplicationFacade.getInstance().dispatch(EventConst.OPEN_MODULE,{
            "url":"assets/module/MonsterStorageModule.swf",
            "xCoord":0,
            "yCoord":0
         });
      }
      
      override public function disport() : void
      {
         this.params = null;
         CacheUtil.deleteObject(TrumpInfoview);
         ApplicationFacade.getInstance().removeViewLogic(TrumpInfoControl.NAME);
         if(Boolean(this.trumpInfoClip) && Boolean(this.trumpInfoClip.parent))
         {
            this.trumpInfoClip.parent.removeChild(this.trumpInfoClip);
         }
         this.trumpInfoClip = null;
         super.disport();
      }
   }
}

