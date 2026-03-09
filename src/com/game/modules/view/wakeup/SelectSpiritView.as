package com.game.modules.view.wakeup
{
   import com.core.observer.MessageEvent;
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.global.GlobalConfig;
   import com.game.locators.GameData;
   import com.game.manager.EventManager;
   import com.game.modules.control.wakeup.SelectSpiritControl;
   import com.game.modules.view.trump.TrumpInfoview;
   import com.game.modules.view.wakeup.item.PetItem;
   import com.game.util.CacheUtil;
   import com.game.util.FloatAlert;
   import com.game.util.HLoaderSprite;
   import com.publiccomponent.alert.Alert;
   import com.publiccomponent.loading.GreenLoading;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.utils.getQualifiedClassName;
   
   public class SelectSpiritView extends HLoaderSprite
   {
      
      public static var OPEN_WAKEUP_WINDOWN:String = "openwakeipskillwindow";
      
      public var monster:MovieClip;
      
      public var templist:Array;
      
      public var params:Object;
      
      private var selectData:Object;
      
      private var monsterList:Array;
      
      private var petList:Array;
      
      public function SelectSpiritView()
      {
         GreenLoading.loading.visible = true;
         super();
         this.url = "assets/wakeskill/selectspirit.swf";
      }
      
      override public function setShow() : void
      {
         ApplicationFacade.getInstance().registerViewLogic(new SelectSpiritControl(this));
         GreenLoading.loading.visible = false;
      }
      
      public function removeEvents() : void
      {
         EventManager.removeEvent(this.bg["closeBtn"],MouseEvent.CLICK,this.onClickCloseBtn);
         EventManager.removeEvent(this.bg["sureBtn"],MouseEvent.CLICK,this.onClickSureBtn);
      }
      
      private function onClickCloseBtn(event:MouseEvent) : void
      {
         var len:int = 0;
         var i:int = 0;
         if(Boolean(GlobalConfig.otherObj.hasOwnProperty("IsOpenTrumpInfo")) && Boolean(GlobalConfig.otherObj["IsOpenTrumpInfo"]))
         {
            ApplicationFacade.getInstance().dispatch(EventConst.OPEN_CACHE_VIEW,{
               "body":GameData.instance.playerData.userId,
               "params":GameData.instance.playerData,
               "showX":0,
               "showY":0
            },null,getQualifiedClassName(TrumpInfoview));
            GlobalConfig.otherObj["IsOpenTrumpInfo"] = false;
         }
         if(this.petList != null)
         {
            len = int(this.petList.length);
            for(i = 1; i < len; i++)
            {
               this.petList[i].clearLoader();
               this.petList[i].removeEventListener(MouseEvent.CLICK,this.onClickSpiritBtn);
               this.removeChild(this.petList[i]);
            }
            this.petList = null;
         }
         this.selectData = null;
         this.parent.removeChild(this);
         this.disport();
      }
      
      private function onClickSureBtn(event:MouseEvent) : void
      {
         this.onSelectOk(event);
      }
      
      private function onClickSpiritBtn(event:MouseEvent) : void
      {
         var len:int = int(this.petList.length);
         for(var i:int = 0; i < len; i++)
         {
            this.petList[i]["bg"].gotoAndStop(1);
         }
         event.currentTarget["bg"].gotoAndStop(2);
         this.selectData = this.monsterList[(event.currentTarget as PetItem).index];
      }
      
      private function onSelectOk(event:MouseEvent) : void
      {
         if(this.selectData != null)
         {
            EventManager.dispatch(this,new MessageEvent(OPEN_WAKEUP_WINDOWN,this.selectData));
         }
         else
         {
            new FloatAlert().show(this.stage,300,400,"请选择要进行技能替换的宠物！");
         }
      }
      
      public function build(param:Object) : void
      {
         var i:int = 0;
         var len:int = 0;
         var petitem:PetItem = null;
         if(param.mcount == 0)
         {
            new Alert().show("你的背包里面没有宠物哦...");
            this.onClickCloseBtn(null);
         }
         if(bg)
         {
            EventManager.attachEvent(this.bg["closeBtn"],MouseEvent.CLICK,this.onClickCloseBtn);
            EventManager.attachEvent(this.bg["sureBtn"],MouseEvent.CLICK,this.onClickSureBtn);
            this.petList = [];
            i = 1;
            len = int(param.monsterlist.length);
            this.monsterList = param.monsterlist;
            for(i = 0; i < len; i++)
            {
               petitem = new PetItem();
               petitem.data = this.monsterList[i];
               petitem.index = i;
               this.addChild(petitem);
               petitem.x = i % 2 == 0 ? 245 : 490;
               petitem.y = 189 + int(i / 2) * 94;
               this.petList.push(petitem);
               petitem.addEventListener(MouseEvent.CLICK,this.onClickSpiritBtn);
            }
         }
      }
      
      override public function disport() : void
      {
         ApplicationFacade.getInstance().removeViewLogic(SelectSpiritControl.NAME);
         CacheUtil.deleteObject(SelectSpiritView);
         super.disport();
      }
   }
}

