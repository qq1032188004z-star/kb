package com.game.modules.view.task.activation
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.modules.view.wakeup.item.PetItem;
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.alert.Alert;
   import com.publiccomponent.loading.GreenLoading;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   
   public class GetFreshManPet extends Sprite
   {
      
      private var loader:Loader;
      
      private var loadCount:int = 4;
      
      private var mc:MovieClip;
      
      private var monsterArr:Array;
      
      private var alreadyMonster:int = -1;
      
      private var petList:Array;
      
      private var selectID:int;
      
      public function GetFreshManPet()
      {
         super();
         GreenLoading.loading.visible = true;
         this.loader = new Loader();
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoadComplete);
         this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
         this.loader.load(new URLRequest(URLUtil.getSvnVer("assets/material/getfreshpet.swf")));
      }
      
      private function onLoadComplete(evt:Event) : void
      {
         evt.stopImmediatePropagation();
         this.mc = this.loader.content as MovieClip;
         this.addChild(this.mc);
         this.mc.x = 0;
         this.mc.y = 0;
         this.releaseLoader();
         GreenLoading.loading.visible = false;
         if(this.alreadyMonster != -1)
         {
            this.init();
         }
      }
      
      private function onLoadError(evt:IOErrorEvent) : void
      {
         evt.stopImmediatePropagation();
         --this.loadCount;
         if(this.loadCount > 0)
         {
            this.loader.load(new URLRequest(URLUtil.getSvnVer("assets/material/getfreshpet.swf")));
            return;
         }
         GreenLoading.loading.visible = false;
         this.dispos();
      }
      
      private function releaseLoader() : void
      {
         if(this.loader != null)
         {
            this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoadComplete);
            this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
            this.loader.unloadAndStop();
            this.loader = null;
         }
      }
      
      private function init() : void
      {
         var petItem:PetItem = null;
         this.mc["closeBtn"].addEventListener(MouseEvent.CLICK,this.onClickClose);
         this.mc["sureBtn"].addEventListener(MouseEvent.CLICK,this.onClickSure);
         this.monsterArr = [{
            "id":1001,
            "name":"猫咪"
         },{
            "id":1004,
            "name":"叶螳螂"
         },{
            "id":1007,
            "name":"小水鹤"
         },{
            "id":1010,
            "name":"小火蛇"
         },{
            "id":1013,
            "name":"小石猴"
         }];
         this.monsterArr = this.monsterArr.filter(this.filtAlreadyGet);
         this.petList = [];
         var i:int = 0;
         for(i = 0; i < 4; i++)
         {
            petItem = new PetItem();
            petItem.data = {
               "id":this.monsterArr[i].id,
               "level":1,
               "hp":"???",
               "strength":"???",
               "iid":this.monsterArr[i].id,
               "name":this.monsterArr[i].name
            };
            petItem.index = i;
            petItem.spirithp.gotoAndStop(100);
            this.mc.addChild(petItem);
            petItem.x = i % 2 == 0 ? 348 : 489;
            petItem.y = i / 2 >> 0 == 0 ? 224 : 298.5;
            this.petList.push(petItem);
            petItem.addEventListener(MouseEvent.CLICK,this.onClickPetItem);
         }
      }
      
      private function onClickSure(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         if(this.selectID == 0)
         {
            new Alert().show("你还没有选择你要选择的宠物！");
            return;
         }
         ApplicationFacade.getInstance().dispatch(EventConst.MASTERISOUTSPECIALAREA,{
            "npcid":13001,
            "dialogID":this.selectID
         });
         this.dispos();
      }
      
      private function onClickClose(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         this.dispos();
      }
      
      private function filtAlreadyGet(item:*, index:int, array:Array) : Boolean
      {
         return item.id == this.alreadyMonster ? false : true;
      }
      
      private function onClickPetItem(evt:MouseEvent) : void
      {
         var len:int = int(this.petList.length);
         var i:int = 0;
         for(i = 0; i < len; i++)
         {
            this.petList[i]["bg"].gotoAndStop(1);
         }
         evt.currentTarget["bg"].gotoAndStop(2);
         this.selectID = this.monsterArr[(evt.currentTarget as PetItem).index].id;
      }
      
      public function setData(monsterid:int, monsternum:int) : void
      {
         if(monsternum > 0)
         {
            this.alreadyMonster = monsterid;
            if(this.mc != null)
            {
               this.init();
            }
         }
      }
      
      public function dispos() : void
      {
         var i:int = 0;
         var len:int = 0;
         this.releaseLoader();
         this.alreadyMonster = -1;
         this.selectID = 0;
         if(this.petList != null && this.mc != null)
         {
            i = 0;
            len = int(this.petList.length);
            for(i = 0; i < len; i++)
            {
               this.mc.removeChild(this.petList[i]);
            }
            this.petList.length = 0;
            this.petList = null;
         }
         if(this.mc != null)
         {
            this.mc["closeBtn"].removeEventListener(MouseEvent.CLICK,this.onClickClose);
            this.mc["sureBtn"].removeEventListener(MouseEvent.CLICK,this.onClickSure);
         }
         this.monsterArr = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

