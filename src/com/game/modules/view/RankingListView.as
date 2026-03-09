package com.game.modules.view
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.locators.GameData;
   import com.game.manager.EventManager;
   import com.game.modules.control.RankingListControl;
   import com.game.modules.view.item.RankingItem;
   import com.game.util.HLoaderSprite;
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.alert.Alert;
   import com.publiccomponent.list.TileList;
   import com.publiccomponent.loading.GreenLoading;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   
   public class RankingListView extends HLoaderSprite
   {
      
      private var rankClip:MovieClip;
      
      private var rankList:TileList;
      
      private var showList:Array = [];
      
      private var currentPage:int = 1;
      
      private var totalPage:int = 20;
      
      private var gameId:int;
      
      private var imgLoader:Loader;
      
      private var scenceId:int;
      
      private const list:Array = [{
         "gid":2,
         "sid":1003
      },{
         "gid":2,
         "sid":1003
      },{
         "gid":7,
         "sid":1005
      },{
         "gid":6,
         "sid":2103
      },{
         "gid":10,
         "sid":40001
      },{
         "gid":11,
         "sid":8003
      },{
         "gid":1002,
         "sid":2101
      },{
         "gid":4,
         "sid":8001
      },{
         "gid":5,
         "sid":3004
      },{
         "gid":1004,
         "sid":40001
      }];
      
      private const len:int = this.list.length;
      
      public function RankingListView()
      {
         GreenLoading.loading.visible = true;
         super();
         this.url = "assets/material/rankingListView.swf";
      }
      
      override public function setShow() : void
      {
         this.rankClip = this.bg;
         this.rankClip.titlemc.gotoAndStop(1);
         this.rankClip.cacheAsBitmap = true;
         addChild(this.rankClip);
         this.imgLoader = new Loader();
         addChild(this.imgLoader);
         this.imgLoader.x = 140;
         this.imgLoader.y = 145;
         this.initList();
         ApplicationFacade.getInstance().registerViewLogic(new RankingListControl(this));
         GreenLoading.loading.visible = false;
      }
      
      private function initList() : void
      {
         this.rankList = new TileList(356,152);
         this.rankList.build(1,10,460,25,0,6.9,RankingItem);
         addChildAt(this.rankList,numChildren);
         this.initVisible();
      }
      
      public function initEvents() : void
      {
         EventManager.attachEvent(this.rankClip.closeBtn,MouseEvent.CLICK,this.onClose);
         EventManager.attachEvent(this.rankClip.leftBtn,MouseEvent.CLICK,this.onLeftBtn);
         EventManager.attachEvent(this.rankClip.rightBtn,MouseEvent.CLICK,this.onRightBtn);
         EventManager.attachEvent(this.rankClip.rankmc2.backBtn,MouseEvent.CLICK,this.onBackBtn);
         for(var i:int = 1; i < this.len; i++)
         {
            if(i <= 8)
            {
               EventManager.attachEvent(this.rankClip["rankmc1"]["transBtn" + i],MouseEvent.CLICK,this.onTransBtn);
               EventManager.attachEvent(this.rankClip["rankmc1"]["lookBtn" + i],MouseEvent.CLICK,this.onLook);
            }
            else
            {
               EventManager.attachEvent(this.rankClip["rankmc3"]["transBtn" + i],MouseEvent.CLICK,this.onTransBtn);
               EventManager.attachEvent(this.rankClip["rankmc3"]["lookBtn" + i],MouseEvent.CLICK,this.onLook);
            }
         }
      }
      
      public function removeEvents() : void
      {
         EventManager.removeEvent(this.rankClip.closeBtn,MouseEvent.CLICK,this.onClose);
         EventManager.removeEvent(this.rankClip.leftBtn,MouseEvent.CLICK,this.onLeftBtn);
         EventManager.removeEvent(this.rankClip.rightBtn,MouseEvent.CLICK,this.onRightBtn);
         EventManager.removeEvent(this.rankClip.rankmc2.backBtn,MouseEvent.CLICK,this.onBackBtn);
         for(var i:int = 1; i < this.len; i++)
         {
            if(i <= 8)
            {
               EventManager.removeEvent(this.rankClip["rankmc1"]["transBtn" + i],MouseEvent.CLICK,this.onTransBtn);
               EventManager.removeEvent(this.rankClip["rankmc1"]["lookBtn" + i],MouseEvent.CLICK,this.onLook);
            }
            else
            {
               EventManager.removeEvent(this.rankClip["rankmc3"]["transBtn" + i],MouseEvent.CLICK,this.onTransBtn);
               EventManager.removeEvent(this.rankClip["rankmc3"]["lookBtn" + i],MouseEvent.CLICK,this.onLook);
            }
         }
      }
      
      private function onClose(evt:MouseEvent) : void
      {
         this.onBackBtn(null);
         this.parent.removeChild(this);
      }
      
      private function onTransBtn(evt:MouseEvent) : void
      {
         var i:int = int(evt.currentTarget.name.substring(8,evt.currentTarget.name.length));
         this.scenceId = this.list[i].sid;
         new Alert().showSureOrCancel("你确定要传送吗？",this.transferOrNot);
      }
      
      private function transferOrNot(str:String, data:Object) : void
      {
         if(str == "确定")
         {
            GameData.instance.playerData.currentScenenId = this.scenceId;
            ApplicationFacade.getInstance().dispatch(EventConst.ENTERSCENE,this.scenceId);
            ApplicationFacade.getInstance().dispatch(EventConst.CLEARUI);
            if(Boolean(this.parent))
            {
               this.parent.removeChild(this);
            }
         }
      }
      
      private function onLook(evt:MouseEvent) : void
      {
         var i:int = int(evt.currentTarget.name.substring(7,evt.currentTarget.name.length));
         this.gameId = this.list[i].gid;
         this.currentPage = 1;
         this.rankClip.titlemc.gotoAndStop(2);
         this.initVisible();
         dispatchEvent(new Event(EventConst.GETRANKINFO));
      }
      
      private function onLeftBtn(evt:MouseEvent) : void
      {
         if(this.currentPage > 1 && this.currentPage <= this.totalPage)
         {
            --this.currentPage;
            if(this.rankClip.titlemc.currentFrame == 2)
            {
               dispatchEvent(new Event(EventConst.GETRANKINFO));
            }
            else
            {
               this.rankClip.rankmc1.visible = true;
               this.rankClip.rankmc2.visible = false;
               this.rankClip.rankmc3.visible = false;
               this.rankClip.leftBtn.mouseEnabled = false;
               this.rankClip.rightBtn.mouseEnabled = true;
               this.rankClip.pageTxt.text = this.currentPage + "/" + this.totalPage;
            }
         }
      }
      
      private function onRightBtn(evt:MouseEvent) : void
      {
         if(this.currentPage > 0 && this.currentPage < this.totalPage)
         {
            ++this.currentPage;
            if(this.rankClip.titlemc.currentFrame == 2)
            {
               dispatchEvent(new Event(EventConst.GETRANKINFO));
            }
            else
            {
               this.rankClip.rankmc1.visible = false;
               this.rankClip.rankmc2.visible = false;
               this.rankClip.rankmc3.visible = true;
               this.rankClip.leftBtn.mouseEnabled = true;
               this.rankClip.rightBtn.mouseEnabled = false;
               this.rankClip.pageTxt.text = this.currentPage + "/" + this.totalPage;
            }
         }
      }
      
      private function onBackBtn(evt:MouseEvent) : void
      {
         this.rankClip.titlemc.gotoAndStop(1);
         this.initVisible();
      }
      
      private function initVisible() : void
      {
         if(this.rankClip.titlemc.currentFrame == 2)
         {
            this.rankClip.rankmc1.visible = false;
            this.rankClip.rankmc2.visible = true;
            this.rankClip.rankmc3.visible = false;
            this.rankList.visible = true;
            this.imgLoader.unload();
            this.imgLoader.load(new URLRequest(URLUtil.getSvnVer("assets/littlegame/gameImage/" + this.gameId + ".swf")));
         }
         else
         {
            this.rankClip.rankmc1.visible = true;
            this.rankClip.rankmc2.visible = false;
            this.rankClip.rankmc3.visible = false;
            this.rankClip.leftBtn.mouseEnabled = false;
            this.rankClip.rightBtn.mouseEnabled = true;
            this.currentPage = 1;
            this.totalPage = 2;
            this.rankClip.pageTxt.text = this.currentPage + "/" + this.totalPage;
            this.rankList.visible = false;
            this.imgLoader.unload();
         }
      }
      
      private function render() : void
      {
         this.rankList.rowCount = this.showList.length;
         this.rankList.dataProvider = this.showList;
         this.rankClip.pageTxt.text = this.currentPage + "/" + this.totalPage;
         if(this.currentPage <= 1)
         {
            this.rankClip.leftBtn.mouseEnabled = false;
         }
         else
         {
            this.rankClip.leftBtn.mouseEnabled = true;
         }
         if(this.currentPage >= this.totalPage)
         {
            this.rankClip.rightBtn.mouseEnabled = false;
         }
         else
         {
            this.rankClip.rightBtn.mouseEnabled = true;
         }
         if(this.currentPage == 1)
         {
            if(this.showList.length >= 3)
            {
               this.rankClip.rankmc2.no1.visible = true;
               this.rankClip.rankmc2.no2.visible = true;
               this.rankClip.rankmc2.no3.visible = true;
            }
            else if(this.showList.length >= 2)
            {
               this.rankClip.rankmc2.no1.visible = true;
               this.rankClip.rankmc2.no2.visible = true;
               this.rankClip.rankmc2.no3.visible = false;
            }
            else if(this.showList.length >= 1)
            {
               this.rankClip.rankmc2.no1.visible = true;
               this.rankClip.rankmc2.no2.visible = false;
               this.rankClip.rankmc2.no3.visible = false;
            }
            else
            {
               this.rankClip.rankmc2.no1.visible = false;
               this.rankClip.rankmc2.no2.visible = false;
               this.rankClip.rankmc2.no3.visible = false;
            }
         }
         else
         {
            this.rankClip.rankmc2.no1.visible = false;
            this.rankClip.rankmc2.no2.visible = false;
            this.rankClip.rankmc2.no3.visible = false;
         }
      }
      
      public function transferByResult(result:int) : void
      {
         if(result == 1)
         {
            GameData.instance.playerData.currentScenenId = this.scenceId;
            ApplicationFacade.getInstance().dispatch(EventConst.ENTERSCENE,this.scenceId);
            ApplicationFacade.getInstance().dispatch(EventConst.CLEARUI);
         }
         else
         {
            new Alert().show("你的条件不足，不能传送哦！",null);
         }
      }
      
      public function setData(params:Object) : void
      {
         if(params.hasOwnProperty("total_page_num"))
         {
            this.totalPage = params.total_page_num;
         }
         if(this.totalPage <= 0 || this.totalPage > 20)
         {
            return;
         }
         if(params.hasOwnProperty("list"))
         {
            this.showList = Boolean(params.list) ? params.list : [];
         }
         var i:int = 0;
         var len:int = int(this.showList.length);
         while(i < len)
         {
            if(Boolean(this.showList[i]) && Boolean(this.showList[i].uname) && this.showList[i].uname != "")
            {
               this.showList[i].rank = (this.currentPage - 1) * 10 + i + 1;
               i++;
            }
            else
            {
               this.showList.splice(i,1);
               len--;
            }
         }
         this.render();
      }
      
      public function getGameId() : int
      {
         return this.gameId;
      }
      
      public function getCurrentPage() : int
      {
         return this.currentPage;
      }
   }
}

