package com.game.modules.view.family
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.manager.AlertManager;
   import com.game.manager.EventManager;
   import com.game.util.CacheUtil;
   import com.game.util.HLoaderSprite;
   import com.publiccomponent.list.TileList;
   import com.publiccomponent.loading.GreenLoading;
   import com.publiccomponent.ui.ToolTip;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.net.URLVariables;
   import phpcon.PhpConnection;
   import phpcon.PhpEvent;
   import phpcon.PhpEventConst;
   
   public class FamilyRank extends HLoaderSprite
   {
      
      private var tlist:TileList;
      
      private var currentPage:int = 1;
      
      private const totalPage:int = 30;
      
      private var showList:Array = [];
      
      public function FamilyRank()
      {
         GreenLoading.loading.visible = true;
         super();
      }
      
      override public function initParams(params:Object = null) : void
      {
         this.url = "assets/family/family_rank.swf";
      }
      
      override public function setShow() : void
      {
         this.bg.cacheAsBitmap = true;
         bg.rankmc.modeClip.gotoAndStop(1);
         this.initEvents();
         this.initList();
         GreenLoading.loading.visible = false;
      }
      
      private function initEvents() : void
      {
         var i:int = 0;
         if(bg)
         {
            for(i = 1; i <= 2; i++)
            {
               EventManager.attachEvent(bg["btn" + i],MouseEvent.CLICK,this.on_btn);
            }
            EventManager.attachEvent(bg["closeBtn"],MouseEvent.CLICK,this.on_closeBtn);
            EventManager.attachEvent(bg["findTxt"],MouseEvent.CLICK,this.on_findTxt);
            EventManager.attachEvent(bg["findBtn"],MouseEvent.CLICK,this.on_findBtn);
            EventManager.attachEvent(bg["leftBtn"],MouseEvent.CLICK,this.on_leftBtn);
            EventManager.attachEvent(bg["rightBtn"],MouseEvent.CLICK,this.on_rightBtn);
            EventManager.attachEvent(bg["topLeftBtn"],MouseEvent.CLICK,this.on_topLeftBtn);
            EventManager.attachEvent(bg["topRightBtn"],MouseEvent.CLICK,this.on_topRightBtn);
            EventManager.attachEvent(bg["findTxt"],KeyboardEvent.KEY_DOWN,this.onKeyDown);
            bg.rankmc.addFrameScript(0,this.onOne);
            bg.rankmc.addFrameScript(1,this.onTwo);
         }
         EventManager.attachEvent(PhpConnection.instance(),PhpEventConst.FAMILY_LIST,this.on_phpBack);
         EventManager.attachEvent(PhpConnection.instance(),PhpEventConst.STAR_RANK,this.on_phpBack);
         EventManager.attachEvent(PhpConnection.instance(),PhpEventConst.LATEST_FAMILY,this.on_latestBack);
         EventManager.attachEvent(PhpConnection.instance(),PhpEventConst.FAMILY_SEARCH,this.on_searchBack);
      }
      
      private function onOne() : void
      {
         if(bg)
         {
            bg.rankmc.modeClip.gotoAndStop(1);
            bg.rankmc.modeBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.onMode);
            ToolTip.setDOInfo(bg.rankmc.modeBtn,"点击切换排行");
            bg.rankmc.modeClip.addFrameScript(0,this.onStarRank);
            bg.rankmc.modeClip.addFrameScript(1,this.onValueRank);
         }
      }
      
      private function onTwo() : void
      {
         if(bg)
         {
            this.getPhpData(1);
         }
      }
      
      private function onStarRank() : void
      {
         if(bg)
         {
            this.getPhpData(1);
         }
      }
      
      private function onValueRank() : void
      {
         if(bg)
         {
            this.getPhpData(1);
         }
      }
      
      private function onMode(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         bg.rankmc.modeClip.gotoAndStop(bg.rankmc.modeClip.currentFrame == 1 ? 2 : 1);
      }
      
      private function initList() : void
      {
         this.tlist = new TileList(145,150);
         this.tlist.build(1,10,-1,-1,33,33,FamilyRankItem);
         this.addChild(this.tlist);
         this.on_btn(null);
      }
      
      private function on_btn(evt:MouseEvent) : void
      {
         var index:String = "1";
         if(evt != null)
         {
            index = (evt.target.name as String).substr(3,1);
         }
         bg["topmc"].gotoAndStop(int(index));
         bg["rankmc"].gotoAndStop(int(index));
      }
      
      private function on_closeBtn(evt:MouseEvent) : void
      {
         this.disport();
      }
      
      private function on_findTxt(evt:MouseEvent) : void
      {
         bg["findTxt"].text = "";
         EventManager.removeEvent(bg["findTxt"],MouseEvent.CLICK,this.on_findTxt);
      }
      
      private function on_findBtn(evt:MouseEvent) : void
      {
         var urlvar:URLVariables = null;
         if(bg["findTxt"].text == "")
         {
            AlertManager.instance.showTipAlert({
               "systemid":1065,
               "flag":14,
               "stage":this
            });
         }
         else
         {
            urlvar = new URLVariables();
            urlvar.fname = bg["findTxt"].text;
            PhpConnection.instance().getdata("family/search.php",urlvar);
         }
      }
      
      private function onKeyDown(evt:KeyboardEvent) : void
      {
         if(evt.keyCode == 13)
         {
            this.on_findBtn(null);
         }
      }
      
      private function on_leftBtn(evt:MouseEvent) : void
      {
         if(this.currentPage > 1)
         {
            this.getPhpData(this.currentPage - 1);
         }
      }
      
      private function on_rightBtn(evt:MouseEvent) : void
      {
         if(this.currentPage < this.totalPage)
         {
            this.getPhpData(this.currentPage + 1);
         }
      }
      
      private function on_topLeftBtn(evt:MouseEvent) : void
      {
         var target:int = 0;
         if(this.currentPage > 1)
         {
            target = this.currentPage - 5;
            if(target < 1)
            {
               target = 1;
            }
            this.getPhpData(target);
         }
      }
      
      private function on_topRightBtn(evt:MouseEvent) : void
      {
         var target:int = 0;
         if(this.currentPage < this.totalPage)
         {
            target = this.currentPage + 5;
            if(target > this.totalPage)
            {
               target = this.totalPage;
            }
            this.getPhpData(target);
         }
      }
      
      private function getPhpData(page:int) : void
      {
         this.currentPage = page;
         var urlvar:URLVariables = new URLVariables();
         urlvar.page = page;
         if(bg["topmc"].currentFrame == 1)
         {
            if(Boolean(bg["rankmc"]) && bg["rankmc"]["modeClip"].currentFrame == 1)
            {
               PhpConnection.instance().getdata("family/star_rank.php",urlvar);
            }
            else
            {
               PhpConnection.instance().getdata("family/rank.php",urlvar);
            }
         }
         else
         {
            PhpConnection.instance().getdata("family/latest_family_list.php",urlvar);
         }
      }
      
      private function on_phpBack(evt:PhpEvent) : void
      {
         this.showList = evt.data.list != null ? evt.data.list : [];
         var len:int = int(this.showList.length);
         for(var i:int = 0; i < len; i++)
         {
            this.showList[i].rank = (this.currentPage - 1) * 10 + i + 1;
         }
         this.render();
      }
      
      private function render() : void
      {
         this.tlist.rowCount = this.showList.length;
         this.tlist.dataProvider = this.showList;
         if(bg)
         {
            if(Boolean(bg.hasOwnProperty("pageTxt")) && Boolean(bg["pageTxt"]))
            {
               this.bg["pageTxt"].text = this.currentPage + "/" + this.totalPage;
            }
            if(this.currentPage <= 1)
            {
               this.bg["leftBtn"].mouseEnabled = false;
               this.bg["topLeftBtn"].mouseEnabled = false;
               this.bg["mc"].visible = true;
            }
            else
            {
               this.bg["leftBtn"].mouseEnabled = true;
               this.bg["topLeftBtn"].mouseEnabled = true;
               this.bg["mc"].visible = false;
            }
            if(this.currentPage >= this.totalPage)
            {
               this.bg["rightBtn"].mouseEnabled = false;
               this.bg["topRightBtn"].mouseEnabled = false;
            }
            else
            {
               this.bg["rightBtn"].mouseEnabled = true;
               this.bg["topRightBtn"].mouseEnabled = true;
            }
            if(bg["topmc"].currentFrame == 2)
            {
               this.bg["mc"].visible = false;
            }
         }
      }
      
      private function on_latestBack(evt:PhpEvent) : void
      {
         this.showList = evt.data.list != null ? evt.data.list : [];
         var len:int = int(this.showList.length);
         for(var i:int = 0; i < len; i++)
         {
            this.showList[i].rank = (this.currentPage - 1) * 10 + i + 1;
         }
         this.render();
      }
      
      private function on_searchBack(evt:PhpEvent) : void
      {
         if(evt.data != null && Boolean(evt.data.hasOwnProperty("fid")))
         {
            if(evt.data.fid > 0)
            {
               ApplicationFacade.getInstance().dispatch(EventConst.REQ_FAMILY_INFO,evt.data.fid);
            }
            else
            {
               AlertManager.instance.showTipAlert({
                  "systemid":1065,
                  "flag":15,
                  "stage":this
               });
            }
         }
      }
      
      override public function disport() : void
      {
         ToolTip.removeToolTip();
         for(var i:int = 1; i <= 2; i++)
         {
            EventManager.removeEvent(bg["btn" + i],MouseEvent.CLICK,this.on_btn);
         }
         EventManager.removeEvent(bg["closeBtn"],MouseEvent.CLICK,this.on_closeBtn);
         EventManager.removeEvent(bg["findTxt"],MouseEvent.CLICK,this.on_findTxt);
         EventManager.removeEvent(bg["findBtn"],MouseEvent.CLICK,this.on_findBtn);
         EventManager.removeEvent(bg["leftBtn"],MouseEvent.CLICK,this.on_leftBtn);
         EventManager.removeEvent(bg["rightBtn"],MouseEvent.CLICK,this.on_rightBtn);
         bg.rankmc.addFrameScript(0,null);
         bg.rankmc.addFrameScript(1,null);
         EventManager.removeEvent(PhpConnection.instance(),PhpEventConst.FAMILY_LIST,this.on_phpBack);
         EventManager.removeEvent(PhpConnection.instance(),PhpEventConst.STAR_RANK,this.on_phpBack);
         EventManager.removeEvent(PhpConnection.instance(),PhpEventConst.LATEST_FAMILY,this.on_latestBack);
         EventManager.removeEvent(PhpConnection.instance(),PhpEventConst.FAMILY_SEARCH,this.on_searchBack);
         if(Boolean(this.tlist) && Boolean(this.tlist.parent))
         {
            this.tlist.dataProvider = [];
            this.tlist.parent.removeChild(this.tlist);
         }
         this.tlist = null;
         this.showList = null;
         if(Boolean(this.parent) && this.parent.contains(this))
         {
            this.parent.removeChild(this);
         }
         super.disport();
         CacheUtil.deleteObject(FamilyRank);
      }
   }
}

