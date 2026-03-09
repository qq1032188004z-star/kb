package com.publiccomponent.ui
{
   import caurina.transitions.Tweener;
   import com.core.observer.MessageEvent;
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.locators.GameData;
   import com.publiccomponent.events.ItemClickEvent;
   import com.publiccomponent.list.TileList;
   import com.publiccomponent.smile.ColumnItem;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class MiddleClip extends Sprite
   {
      
      public var lastBtn:SimpleButton;
      
      public var nextBtn:SimpleButton;
      
      public var openBtn:MovieClip;
      
      public var isOpen:Boolean = false;
      
      private var tileList:TileList;
      
      private var curIndex:int = 0;
      
      private var propList:Array = [];
      
      private var startIndex:int;
      
      private var endIndex:int;
      
      public function MiddleClip()
      {
         super();
      }
      
      public function init(clip:MovieClip) : void
      {
         clip.cacheAsBitmap = true;
         this.addChild(clip);
         this.lastBtn = clip.effectColumn.lastBtn;
         this.nextBtn = clip.effectColumn.nextBtn;
         this.openBtn = clip.effectColumn.openBtn;
         this.openBtn.buttonMode = true;
         this.close();
         this.tileList = new TileList(10,30);
         this.addChild(this.tileList);
         this.tileList.build(1,3,65,57,2,3,ColumnItem);
         this.tileList.dataProvider = [];
         this.initEvents();
      }
      
      public function setDataList(list:Array, open:Boolean = false) : void
      {
         var listRender:Array = null;
         this.propList = list;
         if(list.length >= 3)
         {
            listRender = this.propList.slice(0,3);
            this.startIndex = 0;
            this.endIndex = 3;
         }
         else
         {
            listRender = list;
            this.startIndex = 0;
            this.endIndex = list.length;
            if(this.endIndex < 0)
            {
               this.endIndex = 0;
            }
         }
         this.tileList.dataProvider = listRender;
         if(listRender.length > 0 && !GameData.instance.isCantCopyScene)
         {
            this.show();
         }
         else
         {
            this.hide();
         }
         if(open && !this.isOpen)
         {
            this.onOpenOrCloseHandler();
         }
      }
      
      private function hide() : void
      {
         this.visible = false;
      }
      
      private function show() : void
      {
         this.visible = true;
      }
      
      private function initEvents() : void
      {
         this.openBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.onOpenOrCloseHandler);
         this.tileList.addEventListener(ItemClickEvent.ITEMCLICKEVENT,this.onItemClickHandler,true);
         this.lastBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.handlerLastBtn);
         this.nextBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.handlerNextBtn);
      }
      
      protected function handlerNextBtn(event:MouseEvent) : void
      {
         if(this.endIndex < this.propList.length)
         {
            ++this.endIndex;
            ++this.startIndex;
            this.renderTileListByUpDown(this.propList.slice(this.startIndex,this.endIndex));
         }
      }
      
      protected function handlerLastBtn(event:MouseEvent) : void
      {
         if(this.startIndex > 0)
         {
            --this.startIndex;
            --this.endIndex;
            this.renderTileListByUpDown(this.propList.slice(this.startIndex,this.endIndex));
         }
      }
      
      private function renderTileListByUpDown(list:Array) : void
      {
         this.tileList.dataProvider = list;
      }
      
      private function onItemClickHandler(e:ItemClickEvent) : void
      {
         var obj:Object = null;
         var data:Object = null;
         e.stopImmediatePropagation();
         if(e.params.itemId == 103014)
         {
            obj = {};
            obj.count = e.params.itemNum;
            obj.isuse = 1;
            obj.packcode = 1;
            obj.packid = 111111;
            obj.position = 93;
            obj.prosid = e.params.itemId;
            obj.jinghunid = 0;
            obj.gongneng = 0;
            obj.temp1 = 0;
            obj.temp2 = 0;
            ApplicationFacade.getInstance().dispatch(EventConst.USEPROPS,obj);
         }
         else if(e.params.itemId == GameData.instance.playerData.effectList.hasCollectId)
         {
            ApplicationFacade.getInstance().dispatch(EventConst.OPEN_MODULE,{
               "url":"assets/module/CollectAuto/CollectAuto.swf",
               "xCoord":0,
               "yCoord":0,
               "params":{"isMainSelect":1}
            });
         }
         else
         {
            data = e.params;
            this.dispatchEvent(new MessageEvent("effect_request_change_state",data));
         }
      }
      
      public function open() : void
      {
         this.isOpen = true;
         this.openBtn.gotoAndStop(2);
      }
      
      public function close() : void
      {
         this.isOpen = false;
         this.openBtn.gotoAndStop(1);
      }
      
      public function onOpenOrCloseHandler(e:MouseEvent = null) : void
      {
         if(this.isOpen)
         {
            Tweener.addTween(this,{
               "x":-66.6,
               "time":0.5,
               "onStart":this.close,
               "onComplete":this.onComplete
            });
         }
         else
         {
            Tweener.addTween(this,{
               "x":0,
               "time":0.5,
               "onStart":this.open,
               "onComplete":this.onComplete
            });
         }
      }
      
      private function onComplete() : void
      {
         Tweener.removeTweens(this);
      }
   }
}

