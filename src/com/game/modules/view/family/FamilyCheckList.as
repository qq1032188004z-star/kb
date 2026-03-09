package com.game.modules.view.family
{
   import com.game.manager.EventManager;
   import com.game.util.HLoaderSprite;
   import com.publiccomponent.list.TileList;
   import com.publiccomponent.loading.GreenLoading;
   import flash.events.MouseEvent;
   
   public class FamilyCheckList extends HLoaderSprite
   {
      
      private var tlist:TileList;
      
      private var currentPage:int = 1;
      
      private var totalPage:int = 5;
      
      public var showList:Array = [];
      
      public function FamilyCheckList()
      {
         super();
      }
      
      override public function initParams(params:Object = null) : void
      {
         var date:Date = null;
         var dateWeekDay:int = 0;
         var flag:Boolean = false;
         var week:int = 0;
         var j:int = 0;
         GreenLoading.loading.visible = true;
         this.showList = params.list != null ? params.list : [];
         var len:int = int(this.showList.length);
         var now:Date = new Date();
         var nowWeekDay:int = now.day == 0 ? 7 : int(now.day);
         for(var i:int = 0; i < len; i++)
         {
            flag = false;
            date = new Date(this.showList[i].time * 1000);
            dateWeekDay = date.day == 0 ? 7 : int(date.day);
            if(nowWeekDay < dateWeekDay)
            {
               flag = true;
            }
            else if(now.time - date.time > 7 * 24 * 60 * 60 * 1000)
            {
               flag = true;
            }
            if(this.showList[i].time > 0 && flag)
            {
               this.showList[i].record = 0;
            }
            week = 0;
            for(j = 1; j < 8; j++)
            {
               if((this.showList[i].record & Math.pow(2,j - 1)) != 0)
               {
                  week++;
               }
            }
            this.showList[i].week = week;
         }
         this.url = "assets/family/family_check_list.swf";
      }
      
      override public function setShow() : void
      {
         this.bg.cacheAsBitmap = true;
         this.initEvents();
         this.initList();
         this.bg["pageTxt"].mouseEnabled = false;
         GreenLoading.loading.visible = false;
      }
      
      private function initEvents() : void
      {
         for(var i:int = 0; i <= 2; i++)
         {
            EventManager.attachEvent(bg["btn" + i],MouseEvent.CLICK,this.on_mc);
         }
         EventManager.attachEvent(bg["closeBtn"],MouseEvent.CLICK,this.on_closeBtn);
         EventManager.attachEvent(bg["leftBtn"],MouseEvent.CLICK,this.on_leftBtn);
         EventManager.attachEvent(bg["rightBtn"],MouseEvent.CLICK,this.on_rightBtn);
      }
      
      private function initList() : void
      {
         this.tlist = new TileList(468,45);
         this.tlist.build(1,10,549,28.6,8,8,FamilyCheckItem);
         this.addChild(this.tlist);
         this.on_mc(null);
      }
      
      private function on_mc(evt:MouseEvent) : void
      {
         var index:String = "0";
         if(evt != null)
         {
            index = (evt.target.name as String).substr(3,1);
         }
         if(bg["mc" + index].currentFrame == 2)
         {
            return;
         }
         for(var i:int = 0; i <= 2; i++)
         {
            bg["mc" + i].gotoAndStop(1);
         }
         bg["mc" + index].gotoAndStop(2);
         var sort:Array = ["level","week","times",Array.DESCENDING,Array.NUMERIC,Array.NUMERIC];
         this.showList = this.showList.sortOn(sort[int(index)],sort[int(index) + 3]);
         this.showList = this.showList.reverse();
         this.totalPage = this.showList.length / 10 + (this.showList.length % 10 > 0);
         this.render(1);
      }
      
      private function on_closeBtn(evt:MouseEvent) : void
      {
         this.disport();
      }
      
      private function on_leftBtn(evt:MouseEvent) : void
      {
         if(this.currentPage > 1)
         {
            this.render(this.currentPage - 1);
         }
      }
      
      private function on_rightBtn(evt:MouseEvent) : void
      {
         if(this.currentPage < this.totalPage)
         {
            this.render(this.currentPage + 1);
         }
      }
      
      private function render(index:int) : void
      {
         this.currentPage = index;
         var list:Array = this.showList.slice((index - 1) * 10,index * 10);
         list = list != null ? list : [];
         this.tlist.rowCount = list.length;
         this.tlist.dataProvider = list;
         this.bg["pageTxt"].text = this.currentPage + "/" + this.totalPage;
         if(this.currentPage <= 1)
         {
            this.bg["leftBtn"].mouseEnabled = false;
         }
         else
         {
            this.bg["leftBtn"].mouseEnabled = true;
         }
         if(this.currentPage >= this.totalPage)
         {
            this.bg["rightBtn"].mouseEnabled = false;
         }
         else
         {
            this.bg["rightBtn"].mouseEnabled = true;
         }
      }
      
      override public function disport() : void
      {
         for(var i:int = 0; i <= 2; i++)
         {
            EventManager.removeEvent(bg["btn" + i],MouseEvent.CLICK,this.on_mc);
         }
         EventManager.removeEvent(bg["closeBtn"],MouseEvent.CLICK,this.on_closeBtn);
         EventManager.removeEvent(bg["leftBtn"],MouseEvent.CLICK,this.on_leftBtn);
         EventManager.removeEvent(bg["rightBtn"],MouseEvent.CLICK,this.on_rightBtn);
         if(Boolean(this.parent) && this.parent.contains(this))
         {
            this.parent.removeChild(this);
         }
         super.disport();
      }
   }
}

