package com.game.modules.view.monster
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.modules.view.item.PackItem;
   import com.kb.util.CommonDefine;
   import com.publiccomponent.alert.Alert;
   import com.publiccomponent.events.ItemClickEvent;
   import com.publiccomponent.list.TileList;
   import com.publiccomponent.loading.GreenLoading;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class Props extends Sprite
   {
      
      public static var list:TileList;
      
      public static var currentTotalList:Array = [];
      
      public static var items:Array = new Array();
      
      private var propsClip:MovieClip;
      
      private var currentPageList:Array = [];
      
      private var daojuList:Array = [];
      
      private var currentPage:int;
      
      private var pageNum:int = 12;
      
      private var totalPage:int;
      
      private var propsId:int;
      
      public function Props()
      {
         super();
         GreenLoading.loading.loadModule(CommonDefine.READY_OPEN,"assets/material/Props.swf",this.onLoadComplement);
         this.initToolConfig();
      }
      
      private function initToolConfig() : void
      {
         items.push({
            "id":6,
            "name":"蟠桃",
            "type":1,
            "value":100,
            "exp":"恢复妖怪150体力"
         });
         items.push({
            "id":7,
            "name":"大金创药",
            "type":1,
            "value":80,
            "exp":"恢复妖怪80体力"
         });
         items.push({
            "id":8,
            "name":"中金创药",
            "type":1,
            "value":40,
            "exp":"恢复妖怪50体力"
         });
         items.push({
            "id":9,
            "name":"小金创药",
            "type":1,
            "value":20,
            "exp":"恢复妖怪20体力"
         });
         items.push({
            "id":10,
            "name":"天仙玉露",
            "type":2,
            "value":5,
            "exp":"恢复妖怪招式使用次数5次"
         });
         items.push({
            "id":11,
            "name":"法术金丹",
            "type":3,
            "value":1,
            "exp":"食用后能增加妖怪的法术"
         });
         items.push({
            "id":12,
            "name":"防御金丹",
            "type":4,
            "value":1,
            "exp":"食用后能增加妖怪的防御"
         });
         items.push({
            "id":13,
            "name":"攻击金丹",
            "type":5,
            "value":1,
            "exp":"食用后能增加妖怪的攻击"
         });
         items.push({
            "id":14,
            "name":"抗性金丹",
            "type":6,
            "value":1,
            "exp":"食用后能增加妖怪的抗性"
         });
         items.push({
            "id":15,
            "name":"速度金丹",
            "type":7,
            "value":1,
            "exp":"食用后能增加妖怪的速度"
         });
         items.push({
            "id":16,
            "name":"舍利子",
            "type":8,
            "value":2,
            "exp":"食用后能永久增加妖怪的体力"
         });
      }
      
      private function onLoadComplement(disPlay:Loader) : void
      {
         GreenLoading.loading.visible = false;
         this.propsClip = disPlay.getChildAt(0) as MovieClip;
         this.addChild(this.propsClip);
         disPlay.unloadAndStop(false);
         this.init();
         this.initEvent();
         ApplicationFacade.getInstance().dispatch(EventConst.GETPROPSLIST,513);
      }
      
      private function init() : void
      {
         list = new TileList(64,40);
         list.build(3,4,60,58,5,5,PackItem);
         this.addChild(list);
      }
      
      public function setdata(daoju:Object) : void
      {
         var tempList:Array = daoju[0].goods;
         this.daojuList = tempList.filter(this.isNotZero);
         this.anlysisDataAndShow(this.daojuList);
      }
      
      private function isNotZero(element:*, index:int, arr:Array) : Boolean
      {
         return element.id !== 0;
      }
      
      private function anlysisDataAndShow(targetList:Array) : void
      {
         currentTotalList = targetList;
         var len:int = int(targetList.length);
         if(len > this.pageNum)
         {
            this.currentPageList = targetList.slice(0,this.pageNum);
            this.currentPage = 1;
            this.totalPage = Math.ceil(targetList.length / this.pageNum);
         }
         else
         {
            this.currentPageList = targetList;
            this.currentPage = 1;
            this.totalPage = 1;
         }
         this.render();
      }
      
      private function render() : void
      {
         this.propsClip.pageTxt.text = this.currentPage + "/" + this.totalPage;
         list.dataProvider = this.currentPageList;
         trace(list.numChildren);
      }
      
      private function initEvent() : void
      {
         this.propsClip.closeBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.closeWindow);
         this.addEventListener(Event.ADDED_TO_STAGE,this.onAddToStage);
         this.propsClip.leftBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.moveLeft);
         this.propsClip.rightBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.moveRight);
         this.addEventListener(ItemClickEvent.ITEMCLICKEVENT,this.onItemClick,true);
      }
      
      private function onAddToStage(evt:Event) : void
      {
         ApplicationFacade.getInstance().dispatch(EventConst.GETPROPSLIST,513);
      }
      
      private function moveLeft(evt:MouseEvent) : void
      {
         var index:int = 0;
         if(this.currentPage > 1)
         {
            index = (this.currentPage - 1) * this.pageNum;
            this.currentPage -= 1;
            this.currentPageList = currentTotalList.slice(index - this.pageNum,index);
            this.render();
         }
      }
      
      private function moveRight(evt:MouseEvent) : void
      {
         var index:int = 0;
         if(this.currentPage < this.totalPage)
         {
            index = this.currentPage * this.pageNum;
            this.currentPage += 1;
            this.currentPageList = currentTotalList.slice(index,index + this.pageNum);
            this.render();
         }
      }
      
      private function closeWindow(evt:MouseEvent) : void
      {
         this.dispos();
      }
      
      public function dispos() : void
      {
         if(this.parent != null)
         {
            if(this.parent.contains(this))
            {
               this.parent.removeChild(this);
            }
         }
      }
      
      private function onItemClick(evt:ItemClickEvent) : void
      {
         var toolType:int = 0;
         evt.stopImmediatePropagation();
         this.propsId = evt.params.id;
         for(var i:int = 0; i < items.length; i++)
         {
            if(items[i].id == this.propsId)
            {
               toolType = int(items[i].type);
            }
         }
         if(evt.params.count <= 0)
         {
            new Alert().show("道具用完啦~~~");
         }
         else if(toolType == 1 && MonsterListView.currentHp == MonsterListView.maxHp)
         {
            new Alert().show("你已经满血！");
         }
         else if(toolType == 2 && MonsterListView.ff == false)
         {
            new Alert().show("你没有消耗掉技能！");
         }
         else
         {
            new Alert().showSureOrCancel("你是否确定要使用此道具?",this.useProps);
         }
      }
      
      private function useProps(str:String, data:Object) : void
      {
         if(str == "确定")
         {
            trace(MonsterListView.curerentId);
            ApplicationFacade.getInstance().dispatch(EventConst.USEPROPS,{
               "prosid":this.propsId,
               "jinghunid":MonsterListView.curerentId,
               "gongneng":1,
               "temp1":0,
               "temp2":0
            });
         }
      }
   }
}

