package com.game.modules.view.replace
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.locators.GameData;
   import com.game.manager.EventManager;
   import com.game.modules.control.replace.ReplaceEvent;
   import com.game.modules.control.replace.ReplaceMonsterControl;
   import com.game.modules.view.MapView;
   import com.game.util.CacheUtil;
   import com.game.util.HLoaderSprite;
   import com.publiccomponent.events.ItemClickEvent;
   import com.publiccomponent.list.TileList;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class ReplaceMonsterView extends HLoaderSprite
   {
      
      private var replaceMc:MovieClip;
      
      private var mList:TileList;
      
      private var storeID:int;
      
      private var packID:int;
      
      private var spiritId:int;
      
      public function ReplaceMonsterView()
      {
         super();
         this.url = "assets/material/replace.swf";
         this.mList = new TileList(34,128);
         this.mList.build(2,3,154,54,-10,10,ReplaceItem);
         this.mList.addEventListener(ItemClickEvent.ITEMCLICKEVENT,this.onItemClick,true);
      }
      
      private function onItemClick(evt:ItemClickEvent) : void
      {
         var tempItem:ReplaceItem = null;
         this.packID = evt.params.id;
         this.spiritId = evt.params.iid;
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
      
      override public function initParams(params:Object = null) : void
      {
         this.build(params);
      }
      
      override public function setShow() : void
      {
         this.replaceMc = bg;
         this.addChild(this.mList);
         this.replaceMc.closeBtn.addEventListener(MouseEvent.CLICK,this.closeWindow);
         this.replaceMc.replaceBtn.addEventListener(MouseEvent.CLICK,this.replaceMonster);
         ApplicationFacade.getInstance().registerViewLogic(new ReplaceMonsterControl(this));
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
         this.storeID = params.storeID;
         this.mList.dataProvider = params.monsterList;
      }
      
      private function replaceMonster(evt:Event) : void
      {
         var params:Object = null;
         EventManager.dispatch(this,new ReplaceEvent(ReplaceEvent.REPLACEEVENT,{
            "storeID":this.storeID,
            "packID":this.packID
         }));
         if(Boolean(MapView.instance.masterPerson) && Boolean(MapView.instance.masterPerson.showData))
         {
            if(this.packID == MapView.instance.masterPerson.showData.msid)
            {
               params = {};
               params.ope = 0;
               params.userId = GameData.instance.playerData.userId;
               params.msid = this.packID;
               params.mid = this.spiritId;
               params.name = "";
               ApplicationFacade.getInstance().dispatch(EventConst.MONSTEROPERATION,params);
            }
         }
      }
      
      override public function disport() : void
      {
         CacheUtil.deleteObject(ReplaceMonsterView);
         ApplicationFacade.getInstance().removeViewLogic(ReplaceMonsterControl.NAME);
         if(Boolean(this.parent) && this.parent.contains(this))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

