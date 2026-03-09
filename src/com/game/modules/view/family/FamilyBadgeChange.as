package com.game.modules.view.family
{
   import com.core.observer.MessageEvent;
   import com.game.event.EventConst;
   import com.game.manager.AlertManager;
   import com.game.manager.EventManager;
   import com.game.util.HLoaderSprite;
   import com.publiccomponent.events.ItemClickEvent;
   import com.publiccomponent.list.TileList;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class FamilyBadgeChange extends HLoaderSprite
   {
      
      private var midBadgeTile:TileList;
      
      private var midBadgeList:Array;
      
      private var midBadgeBar:FamilyBar;
      
      private var midColorTile:TileList;
      
      private var midColorList:Array;
      
      private var midColorBar:FamilyBar;
      
      private var smallBadgeTile:TileList;
      
      private var smallBadgeList:Array;
      
      private var smallBadgeBar:FamilyBar;
      
      private var smallColorTile:TileList;
      
      private var smallColorBar:FamilyBar;
      
      private var badge:FamilyBadge;
      
      public function FamilyBadgeChange()
      {
         super();
         this.initParams(null);
      }
      
      override public function initParams(params:Object = null) : void
      {
         this.midBadgeList = [{"mid_id":1},{"mid_id":2},{"mid_id":3},{"mid_id":4}];
         this.midColorList = [{"color_id":1},{"color_id":2},{"color_id":3},{"color_id":4},{"color_id":5},{"color_id":6},{"color_id":7},{"color_id":8},{"color_id":9}];
         this.smallBadgeList = [{"small_id":1},{"small_id":2},{"small_id":3},{"small_id":4},{"small_id":5},{"small_id":6},{"small_id":7},{"small_id":8},{"small_id":9}];
         this.url = "assets/family/familyBadgeChange.swf";
      }
      
      override public function setShow() : void
      {
         this.bg.cacheAsBitmap = true;
         bg["huiTxt"].restrict = "a-zA-Z一-龥";
         this.initTileList();
         this.initEvents();
      }
      
      private function initTileList() : void
      {
         this.midBadgeTile = new TileList(432,160);
         this.midBadgeTile.build(3,1,84,66,-12,5,FamilyBadgeItem);
         this.midBadgeTile.dataProvider = this.midBadgeList;
         this.addChildAt(this.midBadgeTile,this.numChildren);
         this.midBadgeBar = new FamilyBar(this.midBadgeTile,this.midBadgeList,bg["bar11"],bg["bar13"],bg["bar12"],true);
         this.midColorTile = new TileList(483,285);
         this.midColorTile.build(5,1,84,66,-51,5,FamilyBadgeItem);
         this.midColorTile.dataProvider = this.midColorList;
         this.addChildAt(this.midColorTile,this.numChildren);
         this.midColorBar = new FamilyBar(this.midColorTile,this.midColorList,bg["bar21"],bg["bar23"],bg["bar22"],true);
         this.smallBadgeTile = new TileList(323,285);
         this.smallBadgeTile.build(3,3,84,66,-42,-24,FamilyBadgeItem);
         this.smallBadgeTile.dataProvider = this.smallBadgeList;
         this.addChildAt(this.smallBadgeTile,this.numChildren);
         this.smallBadgeBar = new FamilyBar(this.smallBadgeTile,this.smallBadgeList,bg["bar41"],bg["bar43"],bg["bar42"],false);
         this.smallColorTile = new TileList(483,361);
         this.smallColorTile.build(5,1,84,66,-51,5,FamilyBadgeItem);
         this.smallColorTile.dataProvider = this.midColorList;
         this.addChildAt(this.smallColorTile,this.numChildren);
         this.smallColorBar = new FamilyBar(this.smallColorTile,this.midColorList,bg["bar31"],bg["bar33"],bg["bar32"],true);
         this.badge = new FamilyBadge();
         this.badge.x = 315.5;
         this.badge.y = 151;
         this.badge.setBadge(1,1,"",1,1);
         this.addChildAt(this.badge,this.numChildren);
      }
      
      private function initEvents() : void
      {
         EventManager.attachEvent(bg["closeBtn"],MouseEvent.CLICK,this.on_closeBtn);
         EventManager.attachEvent(bg["doneBtn"],MouseEvent.CLICK,this.on_doneBtn);
         EventManager.attachEvent(bg["huiTxt"],Event.CHANGE,this.on_hui_txt);
         EventManager.attachEvent(this.midBadgeTile,ItemClickEvent.ITEMCLICKEVENT,this.on_midBadgeItem,true);
         EventManager.attachEvent(this.midColorTile,ItemClickEvent.ITEMCLICKEVENT,this.on_midColorItem,true);
         EventManager.attachEvent(this.smallBadgeTile,ItemClickEvent.ITEMCLICKEVENT,this.on_smallBadgeItem,true);
         EventManager.attachEvent(this.smallColorTile,ItemClickEvent.ITEMCLICKEVENT,this.on_smallColorItem,true);
      }
      
      private function removeEvents() : void
      {
         EventManager.removeEvent(bg["closeBtn"],MouseEvent.CLICK,this.on_closeBtn);
         EventManager.removeEvent(bg["doneBtn"],MouseEvent.CLICK,this.on_doneBtn);
         EventManager.removeEvent(bg["huiTxt"],Event.CHANGE,this.on_hui_txt);
         EventManager.removeEvent(this.midBadgeTile,ItemClickEvent.ITEMCLICKEVENT,this.on_midBadgeItem);
         EventManager.removeEvent(this.midColorTile,ItemClickEvent.ITEMCLICKEVENT,this.on_midColorItem);
         EventManager.attachEvent(this.smallBadgeTile,ItemClickEvent.ITEMCLICKEVENT,this.on_smallBadgeItem);
         EventManager.removeEvent(this.smallColorTile,ItemClickEvent.ITEMCLICKEVENT,this.on_smallColorItem);
      }
      
      private function on_closeBtn(evt:MouseEvent) : void
      {
         this.disport();
      }
      
      private function on_doneBtn(evt:MouseEvent) : void
      {
         var body:Object = this.badge.getBadgeObject();
         body._name = body._name;
         if(body._name == "")
         {
            AlertManager.instance.showTipAlert({
               "systemid":1065,
               "flag":1,
               "stage":this
            });
            return;
         }
         if((body._name as String).indexOf("*") != -1)
         {
            AlertManager.instance.showTipAlert({
               "systemid":1065,
               "flag":2,
               "stage":this
            });
            return;
         }
         this.dispatchEvent(new MessageEvent(EventConst.RECORD_CHANGE_BADGE,body));
         this.disport();
      }
      
      private function on_hui_txt(evt:Event) : void
      {
         this.badge.changeName(bg["huiTxt"].text);
      }
      
      private function on_midBadgeItem(evt:ItemClickEvent) : void
      {
         this.badge.changeByMidId(evt.params.mid_id);
      }
      
      private function on_midColorItem(evt:ItemClickEvent) : void
      {
         this.badge.mid_mc.gotoAndStop(evt.params.color_id);
      }
      
      private function on_smallBadgeItem(evt:ItemClickEvent) : void
      {
         this.badge.changeBySmallId(evt.params.small_id);
         this.badge.changeName(bg["huiTxt"].text);
      }
      
      private function on_smallColorItem(evt:ItemClickEvent) : void
      {
         this.badge.circle_mc.gotoAndStop(evt.params.color_id);
         this.badge.changeName(bg["huiTxt"].text);
      }
      
      override public function disport() : void
      {
         this.midBadgeTile.dataProvider = [];
         this.midBadgeTile = null;
         this.midBadgeList = null;
         this.midBadgeBar.dipos();
         this.midColorTile.dataProvider = [];
         this.midColorTile = null;
         this.midColorList = null;
         this.midColorBar.dipos();
         this.smallBadgeTile.dataProvider = [];
         this.smallBadgeTile = null;
         this.smallBadgeList = null;
         this.smallBadgeBar.dipos();
         this.smallColorTile.dataProvider = [];
         this.smallColorTile = null;
         this.smallColorBar.dipos();
         this.badge.dispos();
         this.badge = null;
         this.removeEvents();
         if(Boolean(this.parent) && this.parent.contains(this))
         {
            this.parent.removeChild(this);
         }
         super.disport();
      }
   }
}

