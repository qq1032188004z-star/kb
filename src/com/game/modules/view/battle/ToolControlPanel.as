package com.game.modules.view.battle
{
   import com.game.facade.ApplicationFacade;
   import com.game.locators.GameData;
   import com.game.modules.control.battle.BattleControl;
   import com.game.modules.view.battle.item.ItemTip;
   import com.game.modules.view.battle.item.ToolItem;
   import com.game.util.BitValueUtil;
   import com.publiccomponent.loading.XMLLocator;
   import com.xygame.module.battle.event.BattleEvent;
   import com.xygame.module.battle.util.BattleAlert;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.text.TextField;
   
   public class ToolControlPanel extends Sprite
   {
      
      private var toolControlMc:MovieClip;
      
      private var toolArr:Array;
      
      private var battleToolArr:Array;
      
      private var prePage:* = this.toolControlMc.prebtn;
      
      private var nextPage:* = this.toolControlMc.nextbtn;
      
      private var startIndex:int;
      
      private var perPageNum:int = 6;
      
      private var pageText:TextField = this.toolControlMc.pageText;
      
      private var currentpage:int;
      
      private var totalpage:int;
      
      private var toolType:int;
      
      private var _canTool:Boolean = true;
      
      public var catchType:int;
      
      private var _battleType:int;
      
      public var canBattle:Boolean = false;
      
      private var mediator:BattleControl = ApplicationFacade.getInstance().retrieveViewLogic(BattleControl.NAME) as BattleControl;
      
      private var _toolList:Vector.<ToolItem>;
      
      private var f:ColorMatrixFilter = new ColorMatrixFilter([0.3,0.6,0,0,0,0.3,0.6,0,0,0,0.3,0.6,0,0,0,0,0,0,1,0]);
      
      public var position:int;
      
      public var packcode:int;
      
      public var toolid:int;
      
      private var currentCursorName:String = "";
      
      public function ToolControlPanel(mc:MovieClip)
      {
         this.toolControlMc = mc;
         this.nextPage.addEventListener(MouseEvent.CLICK,this.nextPageClick);
         this.prePage.addEventListener(MouseEvent.CLICK,this.prePageClick);
         this._toolList = new Vector.<ToolItem>();
         for(var i:int = 0; i < this.perPageNum; i++)
         {
            this._toolList.push(new ToolItem({"indexid":i}));
            this._toolList[i].buttonMode = true;
            this.toolControlMc.addChild(this._toolList[i]);
            this._toolList[i].addEventListener(MouseEvent.CLICK,this.onClickTool);
            this._toolList[i].addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOverTool);
            this._toolList[i].addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOutTool);
         }
         super();
      }
      
      public function get battleType() : int
      {
         return this._battleType;
      }
      
      public function set battleType(value:int) : void
      {
         this._battleType = value;
      }
      
      public function get canTool() : Boolean
      {
         return this._canTool;
      }
      
      public function set canTool(value:Boolean) : void
      {
         this._canTool = value;
      }
      
      private function showTool() : void
      {
         var curIndex:int = 0;
         var len:int = int(this.battleToolArr.length);
         for(var p:int = 0; p < this.perPageNum; p++)
         {
            curIndex = this.startIndex + p;
            this._toolList[p].visible = len > curIndex;
            if(this._toolList[p].visible)
            {
               this._toolList[p].setData({
                  "name":"tool" + this.battleToolArr[curIndex].id,
                  "toolid":this.battleToolArr[curIndex].id
               });
               this.checkToolFilter(p);
            }
         }
      }
      
      private function checkToolFilter(indexid:int) : void
      {
         var num:int = 0;
         var ntl:Array = null;
         if(this._battleType == 17 || this._battleType == 18)
         {
            num = GameData.instance.battleItemNum;
            ntl = GameData.instance.battleNoList;
            if(num < 1)
            {
               this._toolList[indexid].filters = [this.f];
            }
            else if(Boolean(ntl) && ntl.indexOf(this._toolList[indexid].data.toolid) != -1)
            {
               this._toolList[indexid].filters = [this.f];
            }
            else
            {
               this._toolList[indexid].filters = [];
            }
         }
         else if(this._canTool && this._battleType != 1 && (this._toolList[indexid].visible && this._toolList[indexid].data.toolid < 4))
         {
            this._toolList[indexid].filters = [this.f];
         }
      }
      
      public function destroy() : void
      {
         var item:ToolItem = null;
         ItemTip.instance.hide();
         if(Boolean(this._toolList))
         {
            for each(item in this._toolList)
            {
               item.removeEventListener(MouseEvent.CLICK,this.onClickTool);
               item.removeEventListener(MouseEvent.MOUSE_OVER,this.onMouseOverTool);
               item.removeEventListener(MouseEvent.MOUSE_OUT,this.onMouseOutTool);
               item.destroy();
            }
            this._toolList = null;
         }
         this.nextPage.removeEventListener(MouseEvent.CLICK,this.nextPageClick);
         this.prePage.removeEventListener(MouseEvent.CLICK,this.prePageClick);
         this.nextPage = null;
         this.pageText = null;
         this.mediator = null;
         this.toolArr = null;
         while(this.toolControlMc.numChildren > 0)
         {
            if(this.toolControlMc.getChildAt(0) is MovieClip)
            {
               MovieClip(this.toolControlMc.getChildAt(0)).stop();
            }
            this.toolControlMc.removeChildAt(0);
         }
         this.toolControlMc.stop();
         this.toolControlMc = null;
      }
      
      public function toolData(obj:Object, value:int = 5) : void
      {
         var tempgoodid:int = 0;
         var xml:XML = null;
         var id:int = 0;
         var g:int = 0;
         var tempusableStatus:int = 0;
         var c:int = 0;
         this.toolType = value;
         this.toolArr = obj.list;
         this.battleToolArr = new Array();
         for(var p:int = 0; p < this.toolArr.length; p++)
         {
            if(Boolean(this.toolArr[p].goods))
            {
               for(g = 0; g < this.toolArr[p].goods.length; g++)
               {
                  tempusableStatus = int(this.toolArr[p].goods[g].usableStatus);
                  if(this.toolArr[p].goods[g].name == null || this.toolArr[p].goods[g].name == "")
                  {
                     xml = XMLLocator.getInstance().tooldic[this.toolArr[p].goods[g].id] as XML;
                     this.toolArr[p].goods[g].name = xml.name;
                     this.toolArr[p].goods[g].desc = xml.desc;
                     if(Boolean(xml.hasOwnProperty("maxshowcount")))
                     {
                        c = int(xml.maxshowcount);
                        if(this.toolArr[p].goods[g].count > c)
                        {
                           this.toolArr[p].goods[g].count = c;
                        }
                     }
                     this.toolArr[p].goods[g].tempusableStatus = xml.useState;
                  }
                  if(this.toolType == 5 && BitValueUtil.getBitValue(tempusableStatus,6))
                  {
                     this.battleToolArr.push(this.toolArr[p].goods[g]);
                  }
                  else if(this.toolType == 2 && BitValueUtil.getBitValue(tempusableStatus,5))
                  {
                     this.battleToolArr.push(this.toolArr[p].goods[g]);
                  }
               }
            }
         }
         this.battleToolArr.sortOn("sortValue",Array.NUMERIC);
         this.totalpage = Math.ceil(this.battleToolArr.length / this.perPageNum);
         this.currentpage = 1;
         this.startIndex = 0;
         this.pageText.text = this.currentpage + "/" + this.totalpage;
         this.showTool();
      }
      
      public function useToolBack(tooid:int, param0:int = 0, succes:Boolean = true) : void
      {
         var i:int = 0;
         this.currentCursorName = "";
         if(Boolean(this.battleToolArr))
         {
            for(i = 0; i < this.battleToolArr.length; i++)
            {
               if(this.battleToolArr[i].id == tooid)
               {
                  if(succes)
                  {
                     this.battleToolArr[i].count -= 1;
                  }
               }
               if(this.battleToolArr[i].count == 0)
               {
                  this.battleToolArr.splice(i,1);
                  this.showTool();
               }
            }
         }
      }
      
      public function useTool() : void
      {
         this.currentCursorName = "";
      }
      
      public function setToolFilter() : void
      {
         var len:int = int(this._toolList.length);
         for(var i:int = 0; i < len; i++)
         {
            this.checkToolFilter(i);
         }
      }
      
      private function onClickTool(event:MouseEvent) : void
      {
         var p:int = 0;
         var item:ToolItem = null;
         var g:int = 0;
         if(!this._canTool || !this.canBattle)
         {
            return;
         }
         var clickItemId:int = int(String(event.currentTarget.name).slice(4,int(event.currentTarget.name.length)));
         if(clickItemId == 100224)
         {
            if(Boolean(this.mediator.getViewComponent()) && Boolean(this.mediator.getViewComponent().spiritsInfoPanel))
            {
               if(Boolean(this.mediator.getViewComponent().spiritsInfoPanel.otherHpShow) && Boolean(this.mediator.getViewComponent().spiritsInfoPanel.otherLevelShow))
               {
                  new BattleAlert(this.mediator.getViewComponent(),"<font color=\'#000000\' size=\'16\'>\t不需要使用这个道具!</font>");
                  return;
               }
            }
         }
         if(this._battleType != 1 && clickItemId < 4)
         {
            return;
         }
         if(event.currentTarget.filters.length > 0)
         {
            return;
         }
         if(String(event.currentTarget.name) != this.currentCursorName)
         {
            for(p = 0; p < this.toolArr.length; p++)
            {
               if(Boolean(this.toolArr[p].goods))
               {
                  for(g = 0; g < this.toolArr[p].goods.length; g++)
                  {
                     if(this.toolArr[p].goods[g].id == clickItemId)
                     {
                        this.position = this.toolArr[p].goods[g].position;
                        this.packcode = this.toolArr[p].goods[g].packcode;
                     }
                  }
               }
            }
            this.currentCursorName = String(event.currentTarget.name);
            this.toolid = clickItemId;
            dispatchEvent(new Event(BattleEvent.BATTLE_USE_TOOL));
            for each(item in this._toolList)
            {
               item.filters = [this.f];
            }
         }
         else
         {
            this.currentCursorName = "";
         }
      }
      
      private function onMouseOverTool(event:MouseEvent) : void
      {
         var goodsCount:int = 0;
         var g:int = 0;
         if(!this._canTool)
         {
            return;
         }
         var selectId:int = int(String(event.currentTarget.name).slice(4,int(event.currentTarget.name.length)));
         var name:String = "";
         var desc:String = "";
         for(var p:int = 0; p < this.toolArr.length; p++)
         {
            if(Boolean(this.toolArr[p].goods))
            {
               for(g = 0; g < this.toolArr[p].goods.length; g++)
               {
                  if(this.toolArr[p].goods[g].id == selectId)
                  {
                     goodsCount = int(this.toolArr[p].goods[g].count);
                     name = "" + this.toolArr[p].goods[g].name;
                     desc = "<font color=\'#FFFFFF\'>数量：" + goodsCount + " \n" + this.toolArr[p].goods[g].desc + "</font>";
                  }
               }
            }
         }
         var x:int = this.toolControlMc.mouseX - 30 + 230;
         var y:int = 375;
         ItemTip.instance.show({
            "toolname":name,
            "tooldesc":desc
         },this.mediator.getViewComponent() as DisplayObjectContainer,x,y);
      }
      
      private function onMouseOutTool(event:MouseEvent) : void
      {
         ItemTip.instance.hide();
      }
      
      private function prePageClick(event:MouseEvent) : void
      {
         var newsi:int = this.startIndex - this.perPageNum;
         if(newsi >= 0)
         {
            this.startIndex -= this.perPageNum;
            this.showTool();
            --this.currentpage;
            this.pageText.text = this.currentpage + "/" + this.totalpage;
         }
         else if(newsi > -this.perPageNum && newsi < 0)
         {
            this.startIndex = 0;
            this.showTool();
            this.currentpage = 1;
            this.pageText.text = this.currentpage + "/" + this.totalpage;
         }
      }
      
      private function nextPageClick(event:MouseEvent) : void
      {
         var newsi:int = this.startIndex + this.perPageNum;
         if(newsi < this.battleToolArr.length)
         {
            this.startIndex += this.perPageNum;
            this.showTool();
            ++this.currentpage;
            this.pageText.text = this.currentpage + "/" + this.totalpage;
         }
      }
      
      override public function set visible(value:Boolean) : void
      {
         this.toolControlMc.visible = value;
      }
      
      public function setfilters() : void
      {
         var item:ToolItem = null;
         for each(item in this._toolList)
         {
            item.filters = [this.f];
         }
      }
      
      public function removefilters() : void
      {
         var item:ToolItem = null;
         for each(item in this._toolList)
         {
            if(Boolean(item.data) && Boolean(item.data.toolid))
            {
               if(!this._canTool || this.catchType == 0 && item.data.toolid < 100005 || this._battleType != 1 && item.data.toolid < 100005)
               {
                  item.filters = [this.f];
               }
               else
               {
                  item.filters = [];
               }
            }
         }
      }
   }
}

