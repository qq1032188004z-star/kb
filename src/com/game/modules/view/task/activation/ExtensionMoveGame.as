package com.game.modules.view.task.activation
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.publiccomponent.loading.GreenLoading;
   import com.publiccomponent.loading.Hloader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.system.ApplicationDomain;
   
   public class ExtensionMoveGame extends Sprite
   {
      
      private var loader:Hloader;
      
      private var mc:MovieClip;
      
      private var item:Class;
      
      private var over:Class;
      
      private var currentLevel:int = 0;
      
      private var callback:Function;
      
      private var gameList:Array;
      
      private var itemList:Array;
      
      private var cellX:int = 50;
      
      private var cellY:int = 50;
      
      private var speed:int = 5;
      
      private var count:int = 0;
      
      private var stopCount:int = 0;
      
      public function ExtensionMoveGame()
      {
         super();
         GreenLoading.loading.visible = true;
         this.loader = new Hloader("assets/material/extensiongame.swf");
         this.loader.addEventListener(Event.COMPLETE,this.onLoadComplete);
      }
      
      private function onLoadComplete(evt:Event) : void
      {
         evt.stopImmediatePropagation();
         GreenLoading.loading.visible = false;
         this.mc = (this.loader.content as MovieClip).getChildAt(0) as MovieClip;
         var domain:ApplicationDomain = this.loader.contentLoaderInfo.applicationDomain;
         this.item = domain.getDefinition("item") as Class;
         this.over = domain.getDefinition("over") as Class;
         this.loader.removeEventListener(Event.COMPLETE,this.onLoadComplete);
         this.addChild(this.mc);
         this.mc.x = 0;
         this.mc.y = 0;
         this.mc.alert.gotoAndStop(1);
         this.mc.alert.visible = false;
         this.mc.alert.addFrameScript(0,this.alertFun1);
         this.mc.alert.addFrameScript(1,this.alertFun2);
         this.initGame();
      }
      
      private function initGame() : void
      {
         var i:int = 0;
         this.itemList = [];
         this.initGameData(0);
         this.mc.start.addEventListener(MouseEvent.CLICK,this.onClickStart);
         this.mc.menu.addEventListener(MouseEvent.CLICK,this.onClickMenu);
         this.mc.closebtn.addEventListener(MouseEvent.CLICK,this.onClickClose);
      }
      
      private function initGameData(level:int = 0) : void
      {
         this.releaseList();
         switch(level)
         {
            case 0:
               this.gameList[0] = {
                  "_x":0,
                  "_y":0,
                  "type":1
               };
               this.gameList[1] = {
                  "_x":0,
                  "_y":3,
                  "type":4
               };
               this.gameList[2] = {
                  "_x":0,
                  "_y":5,
                  "type":2
               };
               this.gameList[3] = {
                  "_x":0,
                  "_y":8,
                  "type":1
               };
               this.gameList[4] = {
                  "_x":1,
                  "_y":4,
                  "type":1
               };
               this.gameList[5] = {
                  "_x":2,
                  "_y":2,
                  "type":1
               };
               this.gameList[6] = {
                  "_x":2,
                  "_y":6,
                  "type":1
               };
               this.gameList[7] = {
                  "_x":3,
                  "_y":0,
                  "type":3
               };
               this.gameList[8] = {
                  "_x":3,
                  "_y":3,
                  "type":5
               };
               this.gameList[9] = {
                  "_x":3,
                  "_y":5,
                  "type":3
               };
               this.gameList[10] = {
                  "_x":3,
                  "_y":8,
                  "type":3
               };
               this.gameList[11] = {
                  "_x":6,
                  "_y":1,
                  "type":2
               };
               this.gameList[12] = {
                  "_x":6,
                  "_y":4,
                  "type":1
               };
               this.gameList[13] = {
                  "_x":6,
                  "_y":7,
                  "type":3
               };
               this.gameList[14] = {
                  "_x":7,
                  "_y":3,
                  "type":1
               };
               this.gameList[15] = {
                  "_x":7,
                  "_y":5,
                  "type":1
               };
         }
         this.initView();
      }
      
      private function releaseList() : void
      {
         var len:int = 0;
         var i:int = 0;
         var j:int = 0;
         if(this.gameList != null)
         {
            len = int(this.gameList.length);
            for(i = 0; i < len; i++)
            {
               this.gameList[i] = 0;
            }
         }
         else
         {
            this.gameList = [];
         }
         if(this.itemList != null)
         {
            len = int(this.itemList.length);
            for(i = 0; i < len; i++)
            {
               this.mc.bg.removeChild(this.itemList[i]);
            }
            this.itemList.length = 0;
            this.itemList = null;
            this.itemList = [];
         }
         else
         {
            this.itemList = [];
         }
      }
      
      private function initView() : void
      {
         var obj:ExtensionMoveItem = null;
         var cur:Object = null;
         if(this.itemList == null)
         {
            this.itemList = [];
         }
         this.count = 0;
         var i:int = 0;
         var j:int = 0;
         var len:int = int(this.gameList.length);
         for(i = 0; i < len; i++)
         {
            cur = this.gameList[i];
            if(cur.type == 1)
            {
               obj = new ExtensionMoveItem(this.over,1,false,cur._y,cur._x);
            }
            else
            {
               obj = new ExtensionMoveItem(this.item,cur.type - 1,true,cur._y,cur._x);
               ++this.count;
            }
            obj.removed = false;
            this.mc.bg.addChild(obj);
            obj.x = cur._y * this.cellX;
            obj.y = cur._x * this.cellY;
            this.itemList.push(obj);
         }
      }
      
      private function onClickStart(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         var i:int = 0;
         var len:int = int(this.itemList.length);
         for(i = 0; i < len; i++)
         {
            this.itemList[i].removeClick(this.speed);
         }
         this.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      private function onEnterFrame(evt:Event) : void
      {
         var itemA:ExtensionMoveItem = null;
         var itemB:ExtensionMoveItem = null;
         evt.stopImmediatePropagation();
         var i:int = 0;
         var j:int = 0;
         var len:int = int(this.itemList.length);
         for(i = 0; i < len; i++)
         {
            itemA = this.itemList[i];
            if(!(!itemA.flag || itemA.removed))
            {
               j = 0;
               this.stopCount = 0;
               for(j = 0; j < len; j++)
               {
                  itemB = this.itemList[j];
                  if(itemB.stoped)
                  {
                     ++this.stopCount;
                  }
                  if(!itemB.removed)
                  {
                     if(i != j)
                     {
                        if(Math.sqrt((itemA.x - itemB.x) * (itemA.x - itemB.x) + (itemA.y - itemB.y) * (itemA.y - itemB.y)) < 50)
                        {
                           if(itemB.flag)
                           {
                              itemA.win();
                              itemB.win();
                              this.count -= 2;
                              if(this.count == 0)
                              {
                                 this.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
                                 this.clearAll();
                                 this.win();
                                 return;
                              }
                           }
                           else
                           {
                              itemA.stop();
                           }
                        }
                     }
                  }
               }
               if(this.stopCount == this.itemList.length)
               {
                  this.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
                  this.clearAll();
                  this.mc.alert.gotoAndStop(1);
                  this.mc.alert.visible = true;
                  return;
               }
            }
         }
         this.itemList = this.itemList.filter(this.removeFilter);
      }
      
      private function removeFilter(item:*, index:*, array:Array) : Boolean
      {
         return !item.removed;
      }
      
      private function clearAll() : void
      {
         var obj:ExtensionMoveItem = null;
         for each(obj in this.itemList)
         {
            obj.dispos();
            obj = null;
         }
         this.itemList.length = 0;
         this.itemList = null;
      }
      
      private function onClickMenu(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         this.mc.alert.gotoAndStop(2);
         this.mc.alert.visible = true;
      }
      
      private function onClickClose(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         this.mc.closebtn.removeEventListener(MouseEvent.CLICK,this.onClickClose);
         if(this.callback != null)
         {
            this.callback.apply(null,["closedialog"]);
         }
         this.dispos();
      }
      
      private function win() : void
      {
         if(this.callback != null)
         {
            this.callback.apply(null,[false]);
         }
         ApplicationFacade.getInstance().dispatch(EventConst.REMOVEDYNAMICTASKNPC,91206);
         this.dispos();
      }
      
      private function alertFun1() : void
      {
         this.mc.alert.again.addEventListener(MouseEvent.CLICK,this.onMouseClickAgain);
      }
      
      private function alertFun2() : void
      {
         this.mc.alert.ok.addEventListener(MouseEvent.CLICK,this.onMouseClickOK);
      }
      
      private function onMouseClickAgain(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         this.mc.alert.again.removeEventListener(MouseEvent.CLICK,this.onMouseClickAgain);
         this.mc.alert.gotoAndStop(2);
         this.mc.alert.visible = false;
         this.initGameData(0);
      }
      
      private function onMouseClickOK(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         this.mc.alert.ok.removeEventListener(MouseEvent.CLICK,this.onMouseClickOK);
         this.mc.alert.gotoAndStop(1);
         this.mc.alert.visible = false;
      }
      
      public function setData(param:Object) : void
      {
         this.callback = param.callback;
      }
      
      public function dispos() : void
      {
         var obj:ExtensionMoveItem = null;
         if(this.loader != null)
         {
            this.loader.removeEventListener(Event.COMPLETE,this.onLoadComplete);
            this.loader.unloadAndStop();
            this.loader = null;
         }
         this.currentLevel = 0;
         this.callback = null;
         if(this.gameList != null)
         {
            this.gameList.length = 0;
            this.gameList = null;
         }
         if(this.itemList != null)
         {
            for each(obj in this.itemList)
            {
               obj.dispos();
               obj = null;
            }
            this.itemList.length = 0;
            this.itemList = null;
         }
         this.count = 0;
         this.stopCount = 0;
         if(this.hasEventListener(Event.ENTER_FRAME))
         {
            this.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         }
         if(this.mc != null)
         {
            this.mc.alert.visible = false;
            this.mc.start.removeEventListener(MouseEvent.CLICK,this.onClickStart);
            this.mc.menu.removeEventListener(MouseEvent.CLICK,this.onClickMenu);
            this.mc.closebtn.removeEventListener(MouseEvent.CLICK,this.onClickClose);
            this.mc.alert.addFrameScript(0,null);
            this.mc.alert.addFrameScript(1,null);
            this.item = null;
            this.over = null;
            this.removeChild(this.mc);
            this.mc = null;
         }
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

