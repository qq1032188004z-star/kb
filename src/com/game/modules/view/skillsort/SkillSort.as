package com.game.modules.view.skillsort
{
   import com.core.observer.MessageEvent;
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.manager.EventManager;
   import com.game.modules.control.skillsort.SkillSortControl;
   import com.game.modules.view.replace.ReplaceItem;
   import com.game.util.CacheUtil;
   import com.game.util.HLoaderSprite;
   import com.publiccomponent.events.ItemClickEvent;
   import com.publiccomponent.list.TileList;
   import com.publiccomponent.loading.GreenLoading;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class SkillSort extends HLoaderSprite
   {
      
      private var replaceMc:MovieClip;
      
      private var mList:TileList;
      
      private var packID:int;
      
      public function SkillSort()
      {
         GreenLoading.loading.visible = true;
         super();
         this.url = "assets/material/SkillSort.swf";
      }
      
      override public function setShow() : void
      {
         this.replaceMc = bg;
         this.replaceMc.cacheAsBitmap = true;
         this.mList = new TileList(114,128);
         this.mList.build(2,3,154,54,-10,10,ReplaceItem);
         this.addChild(this.mList);
         ApplicationFacade.getInstance().registerViewLogic(new SkillSortControl(this));
         GreenLoading.loading.visible = false;
      }
      
      public function initEvents() : void
      {
         EventManager.attachEvent(this.mList,ItemClickEvent.ITEMCLICKEVENT,this.onItemClick,true);
         EventManager.attachEvent(this.replaceMc.closeBtn,MouseEvent.CLICK,this.closeWindow);
         EventManager.attachEvent(this.replaceMc.replaceBtn,MouseEvent.CLICK,this.openSortView);
      }
      
      public function removeEvents() : void
      {
         EventManager.removeEvent(this.mList,ItemClickEvent.ITEMCLICKEVENT,this.onItemClick);
         EventManager.removeEvent(this.replaceMc.closeBtn,MouseEvent.CLICK,this.closeWindow);
         EventManager.removeEvent(this.replaceMc.replaceBtn,MouseEvent.CLICK,this.openSortView);
      }
      
      private function onItemClick(evt:ItemClickEvent) : void
      {
         var tempItem:ReplaceItem = null;
         this.packID = evt.params.id;
         for(var i:int = 0; i < this.mList.numChildren; i++)
         {
            tempItem = this.mList.getChildAt(i) as ReplaceItem;
            if(this.packID == tempItem.data.id)
            {
               tempItem.bg2.visible = true;
               tempItem.bg1.visible = false;
            }
            else
            {
               tempItem.bg2.visible = false;
               tempItem.bg1.visible = true;
            }
         }
      }
      
      public function closeWindow(evt:Event) : void
      {
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
      
      public function build(params:Object) : void
      {
         this.mList.dataProvider = params.monsterList;
      }
      
      private function openSortView(evt:Event) : void
      {
         this.dispatchEvent(new MessageEvent(EventConst.OPENSORTVIEW,{"packID":this.packID}));
      }
      
      override public function disport() : void
      {
         CacheUtil.deleteObject(SkillSort);
         ApplicationFacade.getInstance().removeViewLogic(SkillSortControl.NAME);
      }
   }
}

