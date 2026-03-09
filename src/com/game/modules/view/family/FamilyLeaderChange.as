package com.game.modules.view.family
{
   import com.core.observer.MessageEvent;
   import com.game.event.EventConst;
   import com.game.locators.GameData;
   import com.game.manager.AlertManager;
   import com.game.manager.EventManager;
   import com.game.util.HLoaderSprite;
   import com.publiccomponent.events.ItemClickEvent;
   import com.publiccomponent.list.TileList;
   import flash.events.MouseEvent;
   
   public class FamilyLeaderChange extends HLoaderSprite
   {
      
      private var mlist:TileList;
      
      private var members:Array = [];
      
      private var mbar:FamilyBar;
      
      private var body:Object;
      
      public function FamilyLeaderChange()
      {
         super();
      }
      
      override public function initParams(params:Object = null) : void
      {
         this.members = params as Array;
         this.url = "assets/family/familyLeaderChange.swf";
      }
      
      override public function setShow() : void
      {
         this.bg.cacheAsBitmap = true;
         this.mlist = new TileList(358,169);
         this.mlist.build(1,8,230,30,1,1,FamilyMemberItem);
         this.mlist.dataProvider = this.members;
         this.addChildAt(this.mlist,this.numChildren);
         this.mbar = new FamilyBar(this.mlist,this.members,bg["bar1"],bg["bar3"],bg["bar2"],false);
         EventManager.attachEvent(this.mlist,ItemClickEvent.ITEMCLICKEVENT,this.on_clickItem,true);
         EventManager.attachEvent(bg["closeBtn"],MouseEvent.CLICK,this.on_closeBtn);
         EventManager.attachEvent(bg["sureBtn"],MouseEvent.CLICK,this.on_sureBtn);
      }
      
      private function on_clickItem(evt:ItemClickEvent) : void
      {
         var i:int = 0;
         var item:FamilyMemberItem = null;
         this.body = evt.params;
         var len:int = this.mlist.numChildren;
         for(i = 0; i < len; i++)
         {
            item = this.mlist.getChildAt(i) as FamilyMemberItem;
            if(item.data == evt.params)
            {
               item.onDown();
            }
            else
            {
               item.onUp();
            }
         }
      }
      
      private function on_closeBtn(evt:MouseEvent) : void
      {
         this.disport();
      }
      
      private function on_sureBtn(evt:MouseEvent) : void
      {
         if(this.body != null && this.body.uid != null && GameData.instance.playerData.family_level == 1)
         {
            if(this.body.uid == GameData.instance.playerData.userId)
            {
               AlertManager.instance.showTipAlert({
                  "systemid":1065,
                  "flag":11,
                  "stage":this
               });
            }
            else
            {
               AlertManager.instance.showTipAlert({
                  "systemid":1065,
                  "flag":12,
                  "replace":this.body.uname,
                  "callback":this.sureOrNot,
                  "data":this.body
               });
               AlertManager.instance.showTipAlert({
                  "systemid":1065,
                  "flag":13
               });
            }
         }
      }
      
      private function sureOrNot(str:String, data:Object) : void
      {
         if(str == "确定")
         {
            this.dispatchEvent(new MessageEvent(EventConst.RECORD_TRANSFORM_LEADER,data));
            this.disport();
         }
      }
      
      override public function disport() : void
      {
         EventManager.removeEvent(this.mlist,ItemClickEvent.ITEMCLICKEVENT,this.on_clickItem);
         EventManager.removeEvent(bg["closeBtn"],MouseEvent.CLICK,this.on_closeBtn);
         EventManager.removeEvent(bg["sureBtn"],MouseEvent.CLICK,this.on_sureBtn);
         this.mlist.dataProvider = [];
         this.mlist = null;
         this.mbar.dipos();
         this.mbar = null;
         if(Boolean(this.parent) && this.parent.contains(this))
         {
            this.parent.removeChild(this);
         }
         super.disport();
      }
   }
}

