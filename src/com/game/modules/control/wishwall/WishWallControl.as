package com.game.modules.control.wishwall
{
   import com.core.observer.MessageEvent;
   import com.core.view.ViewConLogic;
   import com.game.event.EventConst;
   import com.game.locators.GameData;
   import com.game.locators.MsgDoc;
   import com.game.manager.EventManager;
   import com.game.modules.view.WindowLayer;
   import com.game.modules.view.wishwall.WishPaperItem;
   import com.game.modules.view.wishwall.WishWallView;
   import com.game.util.AwardAlert;
   import com.publiccomponent.alert.Alert;
   import flash.events.Event;
   import flash.net.URLVariables;
   import phpcon.PhpConnection;
   import phpcon.PhpEvent;
   import phpcon.PhpEventConst;
   
   public class WishWallControl extends ViewConLogic
   {
      
      public static const NAME:String = "WishWallControl";
      
      public function WishWallControl(viewComponent:Object)
      {
         super(NAME,viewComponent);
         EventManager.attachEvent(this.view,Event.ADDED_TO_STAGE,this.onAdded);
         this.onAdded(null);
      }
      
      public function get view() : WishWallView
      {
         return this.getViewComponent() as WishWallView;
      }
      
      private function onAdded(evt:Event) : void
      {
         this.view.initEvents();
         EventManager.attachEvent(this.view,Event.REMOVED_FROM_STAGE,this.onRemoved);
         EventManager.attachEvent(this.view,WishWallView.GETWISHLIST,this.getWishList);
         EventManager.attachEvent(this.view,WishWallView.GETMYWISHES,this.getMyWishes);
         EventManager.attachEvent(this.view,WishWallView.GETAWARDSLIST,this.getAwardsList);
         EventManager.attachEvent(this.view,WishWallView.GETFOUNDWISHES,this.getFoundWishes);
         EventManager.attachEvent(this.view,WishWallView.GETFOUNDPAGE,this.getFoundWishPage);
         PhpConnection.instance().addEventListener(PhpEventConst.WISHWALLLISTBACK,this.onPhpListBack);
         PhpConnection.instance().addEventListener(PhpEventConst.WISHAWARDLISTBACK,this.onPhpAwardListBack);
         this.view.currentPage = 1;
         this.view.onShowAllWishes(null);
      }
      
      private function onRemoved(evt:Event) : void
      {
         this.view.removeEvents();
         EventManager.removeEvent(this.view,Event.REMOVED_FROM_STAGE,this.onRemoved);
         EventManager.removeEvent(this.view,WishWallView.GETWISHLIST,this.getWishList);
         EventManager.removeEvent(this.view,WishWallView.GETMYWISHES,this.getMyWishes);
         EventManager.removeEvent(this.view,WishWallView.GETAWARDSLIST,this.getAwardsList);
         EventManager.removeEvent(this.view,WishWallView.GETFOUNDWISHES,this.getFoundWishes);
         EventManager.removeEvent(this.view,WishWallView.GETFOUNDPAGE,this.getFoundWishPage);
         PhpConnection.instance().removeEventListener(PhpEventConst.WISHWALLLISTBACK,this.onPhpListBack);
         PhpConnection.instance().removeEventListener(PhpEventConst.WISHAWARDLISTBACK,this.onPhpAwardListBack);
      }
      
      private function getWishList(evt:Event) : void
      {
         var urlvar:URLVariables = new URLVariables();
         urlvar.page = this.view.currentPage;
         urlvar.token = "27e76ef6b60400df7c6bedfb807191d6";
         PhpConnection.instance().getdata("wish_wall/wish_list.php",urlvar);
      }
      
      private function getMyWishes(evt:Event) : void
      {
         var urlvar:URLVariables = new URLVariables();
         urlvar.uid = GameData.instance.playerData.userId;
         urlvar.page = this.view.currentPage;
         urlvar.token = "27e76ef6b60400df7c6bedfb807191d6";
         PhpConnection.instance().getdata("wish_wall/my_wishes.php",urlvar);
      }
      
      private function onPhpListBack(evt:PhpEvent) : void
      {
         var list:Array = null;
         if(Boolean(evt.data) && Boolean(evt.data.list))
         {
            list = evt.data.list as Array;
            list.reverse();
            this.view.setPapers(list);
         }
         else
         {
            this.view.setPapers([]);
         }
         WishPaperItem.ReportObject = null;
      }
      
      private function getAwardsList(evt:Event) : void
      {
         var urlvar:URLVariables = new URLVariables();
         urlvar.token = "27e76ef6b60400df7c6bedfb807191d6";
         PhpConnection.instance().getdata("wish_wall/bingo_list.php",urlvar);
      }
      
      private function onPhpAwardListBack(evt:PhpEvent) : void
      {
         var list:Array = null;
         if(Boolean(evt.data) && Boolean(evt.data.list))
         {
            list = evt.data.list as Array;
            this.view.setAwardList(list);
         }
         else
         {
            this.view.setAwardList([]);
         }
      }
      
      override public function listEvents() : Array
      {
         return [[EventConst.WISHSENDREPORT,this.onSendReport],[EventConst.REQMAKEAWISH,this.onReqMakeAWish],[EventConst.MAKEAWISHBACK,this.onMakeAWishBack],[EventConst.WISHREPORTBACK,this.onWishReportBack]];
      }
      
      private function onSendReport(evt:MessageEvent) : void
      {
         var urlvar:URLVariables = null;
         if(!WishPaperItem.ReportObject)
         {
            new Alert().showTwo("你还没选中要举报的许愿纸吧~");
         }
         else
         {
            urlvar = new URLVariables();
            urlvar.uniqid = WishPaperItem.ReportObject.uniqid;
            urlvar.reason = escape(evt.body.msg);
            urlvar.token = "27e76ef6b60400df7c6bedfb807191d6";
            sendMessage(MsgDoc.OP_GATEWAY_WISH_REPORT.send,0,[urlvar.uniqid,urlvar.reason,urlvar.token]);
            WishPaperItem.ReportObject = null;
         }
      }
      
      private function onReqMakeAWish(evt:MessageEvent) : void
      {
         if(!evt.body)
         {
            return;
         }
         var urlvar:URLVariables = new URLVariables();
         urlvar.content = escape(evt.body.content);
         urlvar.share = int(evt.body.share);
         urlvar.color = int(evt.body.color);
         urlvar.form = int(evt.body.form);
         urlvar.deco = int(evt.body.deco);
         urlvar.token = String("27e76ef6b60400df7c6bedfb807191d6");
         sendMessage(MsgDoc.OP_GATEWAY_WISH_MAKE.send,0,[urlvar.content,urlvar.share,urlvar.color,urlvar.form,urlvar.deco,urlvar.token]);
      }
      
      private function getFoundWishes(evt:Event) : void
      {
         var urlvar:URLVariables = new URLVariables();
         urlvar.uname = this.view.findName;
         urlvar.token = String("27e76ef6b60400df7c6bedfb807191d6");
         PhpConnection.instance().getdata("wish_wall/search.php",urlvar);
      }
      
      private function getFoundWishPage(evt:Event) : void
      {
         var urlvar:URLVariables = new URLVariables();
         urlvar.uname = this.view.findName;
         urlvar.page = this.view.currentPage;
         urlvar.token = String("27e76ef6b60400df7c6bedfb807191d6");
         PhpConnection.instance().getdata("wish_wall/search.php",urlvar);
      }
      
      private function onMakeAWishBack(evt:MessageEvent) : void
      {
         if(evt.body == 0)
         {
            GameData.instance.playerData.coin -= 40;
            new Alert().showTwo("许愿成功~");
            this.view.bg["makeawish"].gotoAndStop(2);
         }
         else if(evt.body == 1 || evt.body == 2 || evt.body == 3)
         {
            new Alert().showTwo("许愿失败~囧~");
         }
         else if(evt.body == 4)
         {
            GameData.instance.playerData.coin -= 40;
            new AwardAlert().showGoodsAward("assets/tool/100003.swf",WindowLayer.instance,"恭喜许愿获得了一个白银葫芦",true);
            new Alert().show("许愿成功~");
            this.view.bg["makeawish"].gotoAndStop(2);
         }
         else if(evt.body == 5)
         {
            GameData.instance.playerData.coin -= 40;
            new AwardAlert().showExpAward(1000,WindowLayer.instance);
            new Alert().show("许愿成功~");
            this.view.bg["makeawish"].gotoAndStop(2);
         }
         else if(evt.body == 6)
         {
            new Alert().showTwo("你今天已经许过一次愿了哦~");
            this.view.bg["makeawish"].gotoAndStop(2);
         }
         this.view.onShowAllWishes(null);
      }
      
      private function onWishReportBack(evt:MessageEvent) : void
      {
         if(evt.body == 0)
         {
            new Alert().showTwo("你已经成功举报该信息~");
         }
         else
         {
            new Alert().showTwo("你今天已经举报很多次了~");
         }
         this.view.onShowAllWishes(null);
      }
   }
}

