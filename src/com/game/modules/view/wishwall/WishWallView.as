package com.game.modules.view.wishwall
{
   import com.game.facade.ApplicationFacade;
   import com.game.manager.EventManager;
   import com.game.modules.control.wishwall.WishWallControl;
   import com.game.util.ColorUtil;
   import com.game.util.HLoaderSprite;
   import com.publiccomponent.alert.Alert;
   import com.publiccomponent.list.TileList;
   import com.publiccomponent.loading.GreenLoading;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   
   public class WishWallView extends HLoaderSprite
   {
      
      public static const GETWISHLIST:String = "getwishlist";
      
      public static const GETMYWISHES:String = "getmywishes";
      
      public static const GETAWARDSLIST:String = "getawardslist";
      
      public static const GETFOUNDWISHES:String = "getfoundwishes";
      
      public static const GETFOUNDPAGE:String = "getfoundpage";
      
      private var writingView:WishWriting;
      
      private var showList:Array;
      
      private var papersView:WishPaper;
      
      private var awardList:TileList;
      
      private var award_list:Array;
      
      private var flag:int;
      
      public var currentPage:int = 1;
      
      private var index:int = 0;
      
      public var findName:String;
      
      private var report:WishReport;
      
      public function WishWallView()
      {
         super();
         GreenLoading.loading.visible = true;
         this.writingView = new WishWriting();
         this.papersView = new WishPaper();
         this.awardList = new TileList(345,170);
         this.url = "assets/wishwall/wishWallView.swf";
      }
      
      override public function setShow() : void
      {
         GreenLoading.loading.visible = false;
         this.bg.cacheAsBitmap = true;
         bg["makeawish"].gotoAndStop(1);
         bg["maskbg"].mouseEnabled = false;
         bg["paperbg"].addChild(this.papersView);
         bg["paperbg"].mask = bg["maskbg"];
         this.addChild(this.awardList);
         this.awardList.build(1,10,800,27,5,5,WishAwardItem);
         ApplicationFacade.getInstance().registerViewLogic(new WishWallControl(this));
      }
      
      public function initEvents() : void
      {
         this.setButtons(1,10);
         EventManager.attachEvent(bg["closeBtn"],MouseEvent.CLICK,this.onClose);
         EventManager.attachEvent(bg["findBtn"],MouseEvent.CLICK,this.onFind);
         EventManager.attachEvent(bg["findTxt"],KeyboardEvent.KEY_DOWN,this.onKeyDown);
         EventManager.attachEvent(bg["mywishes"],MouseEvent.CLICK,this.onShowMyWishes);
         EventManager.attachEvent(bg["allwishes"],MouseEvent.CLICK,this.onShowAllWishes);
         EventManager.attachEvent(bg["makeawish"],MouseEvent.CLICK,this.onMakeAWish);
         EventManager.attachEvent(bg["awards"],MouseEvent.CLICK,this.onAwards);
         EventManager.attachEvent(bg["left"],MouseEvent.CLICK,this.onLeft);
         EventManager.attachEvent(bg["right"],MouseEvent.CLICK,this.onRight);
         EventManager.attachEvent(bg["reportBtn"],MouseEvent.MOUSE_DOWN,this.onReport);
      }
      
      public function removeEvents() : void
      {
         var i:int = 0;
         for(i = 0; i < 10; i++)
         {
            EventManager.removeEvent(bg["btn" + i],MouseEvent.CLICK,this.onPages);
         }
         EventManager.removeEvent(bg["closeBtn"],MouseEvent.CLICK,this.onClose);
         EventManager.removeEvent(bg["findBtn"],MouseEvent.CLICK,this.onFind);
         EventManager.removeEvent(bg["findTxt"],KeyboardEvent.KEY_DOWN,this.onKeyDown);
         EventManager.removeEvent(bg["mywishes"],MouseEvent.CLICK,this.onShowMyWishes);
         EventManager.removeEvent(bg["allwishes"],MouseEvent.CLICK,this.onShowAllWishes);
         EventManager.removeEvent(bg["makeawish"],MouseEvent.CLICK,this.onMakeAWish);
         EventManager.removeEvent(bg["awards"],MouseEvent.CLICK,this.onAwards);
         EventManager.removeEvent(bg["left"],MouseEvent.CLICK,this.onLeft);
         EventManager.removeEvent(bg["right"],MouseEvent.CLICK,this.onRight);
         EventManager.removeEvent(bg["reportBtn"],MouseEvent.MOUSE_DOWN,this.onReport);
      }
      
      override public function disport() : void
      {
         if(Boolean(this.parent) && this.parent.contains(this))
         {
            this.parent.removeChild(this);
         }
      }
      
      private function setButtons(first:int, len:int) : void
      {
         var i:int = 0;
         if(first < 0 || len > 10)
         {
            new Alert().show("error!");
            return;
         }
         for(i = 0; i < len; i++)
         {
            EventManager.attachEvent(bg["btn" + i],MouseEvent.CLICK,this.onPages);
            bg["btn" + i].filters = [];
            bg["txt" + i].mouseEnabled = false;
            bg["txt" + i].text = "" + (first + i);
         }
         bg["btn0"].filters = ColorUtil.getColorMatrixFilterGray();
      }
      
      private function onClose(evt:MouseEvent) : void
      {
         this.parent.removeChild(this);
      }
      
      private function onFind(evt:MouseEvent) : void
      {
         var list:Array = null;
         var show:Array = null;
         if(bg["findTxt"].text == "")
         {
            new Alert().showTwo("请输入你要搜索的名字！");
            return;
         }
         if(this.flag == 4)
         {
            if(this.award_list == null)
            {
               return;
            }
            list = this.award_list;
            show = list.filter(this.HasSubStr);
            this.currentPage = 1;
            this.setButtons(1,10);
            this.awardList.dataProvider = show;
         }
         else if(this.flag != 3)
         {
            this.findName = bg["findTxt"].text + "";
            this.dispatchEvent(new Event(WishWallView.GETFOUNDWISHES));
            this.flag = -1;
         }
      }
      
      private function HasSubStr(item:*, index:int, arr:Array) : Boolean
      {
         return item.uname == bg["findTxt"].text;
      }
      
      private function onKeyDown(evt:KeyboardEvent) : void
      {
         if(evt.keyCode == 13)
         {
            this.onFind(null);
         }
      }
      
      public function onShowMyWishes(evt:MouseEvent) : void
      {
         this.writingView.visible = false;
         this.awardList.visible = false;
         this.papersView.visible = true;
         bg["reportBtn"].visible = true;
         this.flag = 2;
         this.currentPage = 1;
         this.setButtons(1,10);
         this.dispatchEvent(new Event(WishWallView.GETMYWISHES));
      }
      
      public function onShowAllWishes(evt:MouseEvent) : void
      {
         this.writingView.visible = false;
         this.awardList.visible = false;
         this.papersView.visible = true;
         bg["reportBtn"].visible = true;
         this.flag = 1;
         this.currentPage = 1;
         this.setButtons(1,10);
         this.dispatchEvent(new Event(WishWallView.GETWISHLIST));
      }
      
      private function onMakeAWish(evt:MouseEvent) : void
      {
         if(1 == bg["makeawish"].currentFrame)
         {
            if(this.writingView.bg == null)
            {
               this.writingView.init();
               this.writingView.show(bg["findBtn"].parent,45,135);
            }
            this.papersView.visible = false;
            this.awardList.visible = false;
            this.writingView.visible = true;
            bg["reportBtn"].visible = false;
            this.flag = 3;
            return;
         }
         new Alert().showTwo("你今天已经许过一次愿了，\n不要太贪心了哦~");
      }
      
      private function onAwards(evt:MouseEvent) : void
      {
         this.papersView.visible = false;
         this.writingView.visible = false;
         this.awardList.visible = true;
         bg["reportBtn"].visible = false;
         this.flag = 4;
         this.dispatchEvent(new Event(WishWallView.GETAWARDSLIST));
      }
      
      private function onLeft(evt:MouseEvent) : void
      {
         if(this.currentPage < 11)
         {
            return;
         }
         this.currentPage -= 10;
         this.currentPage = int(this.currentPage / 10) * 10 + 1;
         this.setButtons(this.currentPage,10);
         this.gotoFuck();
      }
      
      private function onRight(evt:MouseEvent) : void
      {
         if(this.currentPage > 990)
         {
            return;
         }
         this.currentPage += 10;
         this.currentPage = int(this.currentPage / 10) * 10 + 1;
         this.setButtons(this.currentPage,10);
         this.gotoFuck();
      }
      
      private function onPages(evt:MouseEvent) : void
      {
         var i:int = 0;
         var index:String = (evt.currentTarget.name as String).substr(3,1);
         for(i = 0; i < 10; i++)
         {
            (bg["btn" + i] as SimpleButton).filters = [];
         }
         bg["btn" + index].filters = ColorUtil.getColorMatrixFilterGray();
         this.currentPage = int(bg["txt" + index].text);
         this.gotoFuck();
      }
      
      private function gotoFuck() : void
      {
         var list:Array = null;
         if(this.flag == 1)
         {
            this.dispatchEvent(new Event(WishWallView.GETWISHLIST));
         }
         else if(this.flag == 2)
         {
            this.dispatchEvent(new Event(WishWallView.GETMYWISHES));
         }
         else if(this.flag == 4)
         {
            list = this.award_list.slice((this.currentPage - 1) * 10,this.currentPage * 10);
            this.awardList.dataProvider = list;
         }
         else if(this.flag == -1)
         {
            this.dispatchEvent(new Event(WishWallView.GETFOUNDPAGE));
         }
      }
      
      private function onReport(evt:MouseEvent) : void
      {
         if(!WishPaperItem.ReportObject)
         {
            new Alert().showTwo("请选择你要举报的许愿纸！");
            return;
         }
         if(WishPaperItem.ReportObject.share == 0)
         {
            new Alert().showTwo("这张许愿纸是私密的哦~");
            return;
         }
         if(WishPaperItem.ReportObject.pass == 1)
         {
            new Alert().showTwo("这张许愿纸已经通过审核了哦~");
            return;
         }
         if(WishPaperItem.ReportObject.status == 0)
         {
            new Alert().showTwo("这张许愿纸已经在审核中了哦~");
            return;
         }
         if(!this.report)
         {
            this.report = new WishReport();
            this.report.init();
            this.report.show(this,355,150);
         }
         else
         {
            this.report.show(this,355,150);
         }
         this.report.param = WishPaperItem.ReportObject;
         this.report.param.msg = "";
      }
      
      public function setPapers(list:Array) : void
      {
         var i:int = 0;
         this.papersView.removeAll();
         this.showList = null;
         this.showList = list;
         var count:int = int(this.showList.length);
         for(i = 0; i < count; i++)
         {
            this.papersView.addItem(this.showList[i]);
         }
         this.papersView.rankItems();
      }
      
      public function setAwardList(list:Array) : void
      {
         this.award_list = list == null ? [] : list;
         list = this.award_list.slice(0,10);
         this.setButtons(1,10);
         this.awardList.dataProvider = list;
      }
   }
}

