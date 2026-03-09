package com.game.modules.view.exchange
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.manager.EventManager;
   import com.game.manager.cursor.ViewEvent;
   import com.game.modules.control.exchange.ExchangeControl;
   import com.game.util.HLoaderSprite;
   import com.publiccomponent.alert.Alert;
   import com.publiccomponent.list.TileList;
   import com.publiccomponent.loading.GreenLoading;
   import com.publiccomponent.loading.XMLLocator;
   import com.publiccomponent.ui.ToolTip;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class ExchangeView extends HLoaderSprite
   {
      
      private var exchangeClip:MovieClip;
      
      private var totalList:Array = [];
      
      private var tileList:TileList;
      
      private var currentIndex:int;
      
      private var currentObject:Object;
      
      private var currentPageList:Array = [];
      
      public function ExchangeView()
      {
         GreenLoading.loading.visible = true;
         super();
         this.url = "assets/material/duihuan.swf";
      }
      
      override public function setShow() : void
      {
         this.exchangeClip = this.bg;
         this.exchangeClip.cacheAsBitmap = true;
         addChild(this.exchangeClip);
         this.exchangeClip.numTxt.restrict = "0-9";
         this.initList();
         ApplicationFacade.getInstance().registerViewLogic(new ExchangeControl(this));
         GreenLoading.loading.visible = false;
      }
      
      private function initList() : void
      {
         this.tileList = new TileList(315,195);
         this.tileList.build(3,1,84,66,60,0,ExchangeItem);
         this.addChild(this.tileList);
      }
      
      public function initEvents() : void
      {
         ToolTip.BindDO(this.exchangeClip.titleClip,"按下这里可拖动能源转换仪界面");
         EventManager.attachEvent(this.exchangeClip.titleClip,MouseEvent.MOUSE_DOWN,this.onStartDrag);
         EventManager.attachEvent(this.exchangeClip.titleClip,MouseEvent.MOUSE_UP,this.onStopDrag);
         EventManager.attachEvent(this.exchangeClip.closeBtn,MouseEvent.CLICK,this.closeWindow);
         EventManager.attachEvent(this.exchangeClip.leftBtn,MouseEvent.MOUSE_DOWN,this.moveLeft);
         EventManager.attachEvent(this.exchangeClip.rightBtn,MouseEvent.MOUSE_DOWN,this.moveRight);
         EventManager.attachEvent(this.exchangeClip.numTxt,Event.CHANGE,this.onDataChange);
         EventManager.attachEvent(this.exchangeClip.reduceBtn,MouseEvent.MOUSE_DOWN,this.reduce);
         EventManager.attachEvent(this.exchangeClip.addBtn,MouseEvent.MOUSE_DOWN,this.add);
         EventManager.attachEvent(this.exchangeClip.duihuanBtn,MouseEvent.MOUSE_DOWN,this.onClickDuihuan);
         EventManager.attachEvent(this.exchangeClip.cancelBtn,MouseEvent.MOUSE_DOWN,this.onClickCancel);
      }
      
      public function removeEvents() : void
      {
         EventManager.removeEvent(this.exchangeClip.titleClip,MouseEvent.MOUSE_DOWN,this.onStartDrag);
         EventManager.removeEvent(this.exchangeClip.titleClip,MouseEvent.MOUSE_UP,this.onStopDrag);
         EventManager.removeEvent(this.exchangeClip.closeBtn,MouseEvent.CLICK,this.closeWindow);
         EventManager.removeEvent(this.exchangeClip.leftBtn,MouseEvent.MOUSE_DOWN,this.moveLeft);
         EventManager.removeEvent(this.exchangeClip.rightBtn,MouseEvent.MOUSE_DOWN,this.moveRight);
         EventManager.removeEvent(this.exchangeClip.numTxt,Event.CHANGE,this.onDataChange);
         EventManager.removeEvent(this.exchangeClip.reduceBtn,MouseEvent.MOUSE_DOWN,this.reduce);
         EventManager.removeEvent(this.exchangeClip.addBtn,MouseEvent.MOUSE_DOWN,this.add);
         EventManager.removeEvent(this.exchangeClip.duihuanBtn,MouseEvent.MOUSE_DOWN,this.onClickDuihuan);
         EventManager.removeEvent(this.exchangeClip.cancelBtn,MouseEvent.MOUSE_DOWN,this.onClickCancel);
      }
      
      public function duihuanBack(param:Object) : void
      {
         var item:Object = null;
         var len:int = int(this.totalList.length);
         for(var i:int = 0; i < len; i++)
         {
            item = this.totalList[i];
            if(item != null && item.id == param.id)
            {
               item.count -= param.count;
               if(item.count <= 0)
               {
                  this.totalList.splice(i,1);
               }
            }
         }
         if(this.totalList.length == 2)
         {
            this.currentPageList = this.totalList;
            this.exchangeClip.nameTxt.text = "";
            this.exchangeClip.numTxt.text = "";
            this.exchangeClip.priceTxt.text = "";
            this.exchangeClip.totalTxt.text = "";
            this.currentObject = null;
            this.render();
            return;
         }
         if(this.currentIndex + 3 > this.totalList.length)
         {
            this.currentPageList = this.totalList.slice(this.currentIndex - 1,this.currentIndex + 1);
            this.currentIndex -= 1;
         }
         else
         {
            this.currentPageList = this.totalList.slice(this.currentIndex,this.currentIndex + 3);
         }
         this.render();
      }
      
      public function setData(params:Object) : void
      {
         var obj:Object = null;
         var xml:XML = null;
         this.totalList = [];
         this.currentPageList = [];
         this.totalList = params.list[0].goods;
         for each(obj in this.totalList)
         {
            xml = XMLLocator.getInstance().getTool(obj.id);
            if(xml != null)
            {
               obj.name = xml.name;
               obj.price = xml.saleprice;
               obj.desc = xml.desc;
            }
         }
         this.totalList.push(null);
         this.totalList.reverse();
         this.totalList.push(null);
         this.totalList.reverse();
         if(this.totalList != null && this.totalList.length > 2)
         {
            this.currentPageList = this.totalList.slice(this.currentIndex,this.currentIndex + 3);
         }
         this.render();
      }
      
      private function render() : void
      {
         var i:int = 0;
         var item:ExchangeItem = null;
         this.currentObject = this.currentPageList[1];
         if(this.currentObject != null)
         {
            this.exchangeClip.nameTxt.text = this.currentObject.name + "";
            this.exchangeClip.numTxt.text = this.currentObject.count + "";
            this.exchangeClip.priceTxt.text = this.currentObject.price + "";
            this.exchangeClip.totalTxt.text = this.currentObject.count * int(this.currentObject.price) + "";
         }
         else
         {
            this.exchangeClip.nameTxt.text = "";
            this.exchangeClip.numTxt.text = "";
            this.exchangeClip.priceTxt.text = "";
            this.exchangeClip.totalTxt.text = "";
         }
         this.tileList.dataProvider = this.currentPageList;
         var len:int = this.tileList.numChildren;
         for(i = 0; i < len; i++)
         {
            item = this.tileList.getChildAt(i) as ExchangeItem;
            if(item.params.name == this.currentObject.name)
            {
               item.setScale();
            }
         }
      }
      
      private function onStartDrag(evt:MouseEvent) : void
      {
         this.startDrag();
         stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMoveHandler);
      }
      
      private function onMouseMoveHandler(event:MouseEvent) : void
      {
         if(stage == null)
         {
            this.stopDrag();
            return;
         }
         if(stage.mouseX < 0 || stage.mouseX > 970 || stage.mouseY < 0 || stage.mouseY > 570)
         {
            stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMoveHandler);
            this.stopDrag();
         }
      }
      
      private function onStopDrag(evt:MouseEvent) : void
      {
         this.stopDrag();
      }
      
      private function closeWindow(evt:MouseEvent) : void
      {
         if(this.parent != null)
         {
            if(this.parent.contains(this))
            {
               this.parent.removeChild(this);
            }
         }
      }
      
      private function moveLeft(evt:MouseEvent) : void
      {
         if(this.currentIndex <= 0)
         {
            return;
         }
         --this.currentIndex;
         if(this.currentIndex <= 0)
         {
            this.currentIndex = 0;
         }
         this.currentPageList = this.totalList.slice(this.currentIndex,this.currentIndex + 3);
         this.render();
      }
      
      private function moveRight(evt:MouseEvent) : void
      {
         if(this.totalList.length >= this.currentIndex + 4)
         {
            ++this.currentIndex;
            this.currentPageList = this.totalList.slice(this.currentIndex,this.currentIndex + 3);
            this.render();
         }
      }
      
      private function onDataChange(evt:Event) : void
      {
         var num:int = 0;
         if(this.currentObject != null)
         {
            num = int(this.exchangeClip.numTxt.text);
            if(num > this.currentObject.count)
            {
               num = int(this.currentObject.count);
            }
            if(num <= 0)
            {
               num = 1;
            }
            this.exchangeClip.numTxt.text = num + "";
            this.exchangeClip.totalTxt.text = this.exchangeClip.numTxt.text * int(this.currentObject.price);
         }
      }
      
      private function reduce(evt:MouseEvent) : void
      {
         if(this.currentObject == null)
         {
            return;
         }
         var count:int = int(this.exchangeClip.numTxt.text);
         if(count > 1)
         {
            count--;
            this.exchangeClip.numTxt.text = count + "";
            this.exchangeClip.totalTxt.text = count * int(this.exchangeClip.priceTxt.text) + "";
         }
      }
      
      private function add(evt:MouseEvent) : void
      {
         if(this.currentObject == null)
         {
            return;
         }
         var count:int = int(this.exchangeClip.numTxt.text);
         if(count < this.currentObject.count)
         {
            count++;
            this.exchangeClip.numTxt.text = count + "";
            this.exchangeClip.totalTxt.text = count * int(this.exchangeClip.priceTxt.text) + "";
         }
      }
      
      private function onClickDuihuan(evt:MouseEvent) : void
      {
         var body:Object = {};
         if(this.currentObject == null)
         {
            new Alert().show("你没有物品可以兑换");
            return;
         }
         body.id = this.currentObject.id;
         body.count = int(this.exchangeClip.numTxt.text);
         dispatchEvent(new ViewEvent(EventConst.STARTDUIHUAN,body));
      }
      
      private function onClickCancel(evt:MouseEvent) : void
      {
         if(this.parent != null)
         {
            if(this.parent.contains(this))
            {
               this.parent.removeChild(this);
            }
         }
      }
   }
}

