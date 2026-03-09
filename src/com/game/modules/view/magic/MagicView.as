package com.game.modules.view.magic
{
   import com.core.observer.MessageEvent;
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.locators.GameData;
   import com.game.manager.AlertManager;
   import com.game.manager.EventManager;
   import com.game.manager.MouseManager;
   import com.game.modules.control.magic.MagicControl;
   import com.game.modules.view.MapView;
   import com.game.modules.view.WindowLayer;
   import com.game.util.FloatAlert;
   import com.game.util.GamePersonControl;
   import com.game.util.HLoaderSprite;
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.alert.Alert;
   import com.publiccomponent.events.ItemClickEvent;
   import com.publiccomponent.list.TileList;
   import com.publiccomponent.loading.XMLLocator;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   
   public class MagicView extends HLoaderSprite
   {
      
      private static const closeActionList:Array = [26,29];
      
      public static const QUANPINGMAGIC:String = "quanpingmagic";
      
      private var currentPage:int = 1;
      
      private var totalPage:int = 1;
      
      private var clip:MovieClip;
      
      private var list:TileList;
      
      private var magicList:Array = [];
      
      private var changeList:Array = [];
      
      private var currentTotalList:Array = [];
      
      private var currentPageList:Array = [];
      
      private var pageNum:int = 10;
      
      private var xml:XML;
      
      private var urlLoader:URLLoader;
      
      private var xmlURL:String;
      
      private var isFixed:Boolean = false;
      
      private var closeAction26:Array = [[551494,551495,551493,551492,551491,551172],[551489,551490,551488,551492,551491,551172]];
      
      private var closeAction29:Array = [[553522,553523,553521,553527,553526,553525],[553518,553519,553517,553527,553526,553525]];
      
      public function MagicView()
      {
         super();
         this.url = "assets/magic/magic.swf";
         this.urlLoader = new URLLoader();
         this.urlLoader.addEventListener(Event.COMPLETE,this.onLoadedXML);
         this.urlLoader.addEventListener(IOErrorEvent.IO_ERROR,this.ioError);
         this.xmlURL = URLUtil.getSvnVer("config/magictip.xml");
      }
      
      private function onLoadedXML(evt:Event) : void
      {
         this.urlLoader.removeEventListener(Event.COMPLETE,this.onLoadedXML);
         this.urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.ioError);
         this.xml = new XML(this.urlLoader.data);
         this.clip = this.bg["clip"];
         this.addChild(this.clip);
         this.clip.menuClip.stop();
         this.clip.clickTipClip.gotoAndStop(1);
         this.list = new TileList(134,49);
         this.list.build(5,2,40,42,-2,-2,MagicUseItem);
         addChild(this.list);
         ApplicationFacade.getInstance().registerViewLogic(new MagicControl(this));
      }
      
      private function ioError(evt:Event) : void
      {
         this.urlLoader.load(new URLRequest(this.xmlURL));
      }
      
      override public function setShow() : void
      {
         this.bg.cacheAsBitmap = true;
         this.urlLoader.load(new URLRequest(this.xmlURL));
      }
      
      public function ininEvents() : void
      {
         this.clip.tipClip.stop();
         this.clip.tipClip.visible = false;
         EventManager.attachEvent(this,MouseEvent.ROLL_OUT,this.onRollOut);
         EventManager.attachEvent(stage,MouseEvent.MOUSE_DOWN,this.onRollOut,false);
         EventManager.attachEvent(stage,KeyboardEvent.KEY_DOWN,this.onKeyDown);
         EventManager.attachEvent(this.clip.shootClip,MouseEvent.MOUSE_DOWN,this.changeMenu);
         EventManager.attachEvent(this.clip.bianshenClip,MouseEvent.MOUSE_DOWN,this.changeMenu);
         EventManager.attachEvent(this.clip.leftBtn,MouseEvent.MOUSE_DOWN,this.moveLeft);
         EventManager.attachEvent(this.clip.rightBtn,MouseEvent.MOUSE_DOWN,this.moveRight);
         EventManager.attachEvent(this.clip.clickTipClip,MouseEvent.MOUSE_DOWN,this.onClickTipClip);
         EventManager.attachEvent(this.clip.clickTipClip,MouseEvent.ROLL_OUT,this.onRollOutClip);
         EventManager.attachEvent(this.clip.clickTipClip,MouseEvent.ROLL_OVER,this.onRollOverClip);
         EventManager.attachEvent(this.list,ItemClickEvent.ITEMCLICKEVENT,this.itemClick,true);
         stage.focus = stage;
      }
      
      public function removeEvents() : void
      {
         EventManager.removeEvent(this,MouseEvent.ROLL_OUT,this.onRollOut);
         EventManager.removeEvent(stage,MouseEvent.MOUSE_DOWN,this.onRollOut);
         EventManager.removeEvent(stage,KeyboardEvent.KEY_DOWN,this.onKeyDown);
         EventManager.removeEvent(this.clip.shootClip,MouseEvent.MOUSE_DOWN,this.changeMenu);
         EventManager.removeEvent(this.clip.bianshenClip,MouseEvent.MOUSE_DOWN,this.changeMenu);
         EventManager.removeEvent(this.clip.leftBtn,MouseEvent.MOUSE_DOWN,this.moveLeft);
         EventManager.removeEvent(this.clip.rightBtn,MouseEvent.MOUSE_DOWN,this.moveRight);
         EventManager.removeEvent(this.clip.clickTipClip,MouseEvent.MOUSE_DOWN,this.onClickTipClip);
         EventManager.removeEvent(this.clip.clickTipClip,MouseEvent.ROLL_OUT,this.onRollOutClip);
         EventManager.removeEvent(this.clip.clickTipClip,MouseEvent.ROLL_OVER,this.onRollOverClip);
         EventManager.removeEvent(this.list,ItemClickEvent.ITEMCLICKEVENT,this.itemClick);
      }
      
      private function onRollOutClip(evt:MouseEvent) : void
      {
         this.clip.tipClip.stop();
         this.clip.tipClip.visible = false;
      }
      
      private function onRollOverClip(evt:MouseEvent) : void
      {
         this.clip.tipClip.visible = true;
         if(this.clip.clickTipClip.currentFrame == 1)
         {
            this.clip.tipClip.gotoAndStop(1);
         }
         else
         {
            this.clip.tipClip.gotoAndStop(2);
         }
      }
      
      public function updatMagicNum(params:Object) : void
      {
         var k:int = 0;
         var mItem:MagicUseItem = null;
         if(params.userid != GameData.instance.playerData.userId)
         {
            return;
         }
         if(Boolean(this.list))
         {
            for(k = 0; k < this.list.numChildren; k++)
            {
               mItem = this.list.getChildAt(k) as MagicUseItem;
               if(mItem.data.actionId == params.actionid)
               {
                  mItem.updateMagicNum();
                  if(mItem.data.num == 0)
                  {
                     this.deleteData(mItem.data);
                  }
               }
               mItem.startCount();
            }
         }
      }
      
      private function deleteData(data:Object) : void
      {
         var dataArr:Array = null;
         if(this.clip.menuClip.currentFrame == 1)
         {
            dataArr = this.magicList;
         }
         else
         {
            dataArr = this.changeList;
         }
         var index:int = int(dataArr.indexOf(data));
         if(index != -1)
         {
            dataArr.splice(index,1);
            this.render();
         }
      }
      
      private function onKeyDown(evt:KeyboardEvent) : void
      {
         var k:int = 0;
         var keyItem:MagicUseItem = null;
         if(evt.keyCode == 229)
         {
            new FloatAlert().show(WindowLayer.instance,320,300,"输入法有问题，请切换到英文模式");
            return;
         }
         if(stage == null || stage.focus != null)
         {
            return;
         }
         if(this.clip.menuClip.currentFrame == 2)
         {
            return;
         }
         var keycode:int = evt.keyCode - 48;
         if(keycode <= 9)
         {
            for(k = 0; k < this.list.numChildren; k++)
            {
               keyItem = this.list.getChildAt(k) as MagicUseItem;
               if(keyItem.data.index == keycode)
               {
                  if(Boolean(this.list))
                  {
                     this.itemClick(new ItemClickEvent(ItemClickEvent.ITEMCLICKEVENT,keyItem.data));
                  }
                  break;
               }
            }
         }
      }
      
      private function moveLeft(evt:MouseEvent) : void
      {
         if(this.currentPage > 1)
         {
            --this.currentPage;
            this.currentPageList = this.currentTotalList.slice((this.currentPage - 1) * this.pageNum,this.currentPage * this.pageNum);
            this.list.dataProvider = this.currentPageList;
         }
      }
      
      private function moveRight(evt:MouseEvent) : void
      {
         if(this.currentPage < this.totalPage)
         {
            ++this.currentPage;
            if(this.currentTotalList.length < this.currentPage * this.pageNum)
            {
               this.currentPageList = this.currentTotalList.slice((this.currentPage - 1) * this.pageNum,this.currentTotalList.length);
            }
            else
            {
               this.currentPageList = this.currentTotalList.slice((this.currentPage - 1) * this.pageNum,this.currentPage * this.pageNum);
            }
            this.list.dataProvider = this.currentPageList;
         }
      }
      
      private function onClickTipClip(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         if(this.clip.clickTipClip.currentFrame == 1)
         {
            this.clip.clickTipClip.gotoAndStop(2);
            this.isFixed = true;
         }
         else
         {
            this.clip.clickTipClip.gotoAndStop(1);
            this.isFixed = false;
         }
      }
      
      public function setMagicIndex(magicArr:Array, changeArr:Array) : void
      {
         var tempXML:XML = null;
         var item:Object = null;
         var item2:Object = null;
         for each(item in magicArr)
         {
            tempXML = this.xml.child("magic").(@id == item.id)[0] as XML;
            item.actionId = item.id;
            if(tempXML != null)
            {
               item.tip = tempXML.tip;
               item.useType = int(tempXML.@useType);
               item.alert = tempXML.alert;
               item.sortValue = tempXML.sortValue;
            }
            else
            {
               item.tip = "";
            }
         }
         for each(item2 in changeArr)
         {
            tempXML = this.xml.child("change").(@id == item2.id)[0] as XML;
            item2.actionId = item2.id + 98;
            if(tempXML != null)
            {
               item2.tip = tempXML.tip;
               item2.useType = int(tempXML.@useType);
               item2.alert = tempXML.alert;
               item2.sortValue = tempXML.sortValue;
            }
            else
            {
               item2.tip = "";
            }
         }
         this.magicList = magicArr;
         this.changeList = changeArr;
         this.magicList.sortOn("sortValue",Array.NUMERIC);
         this.changeList.sortOn("sortValue",Array.NUMERIC);
         this.clip.menuClip.gotoAndStop(1);
         this.render();
      }
      
      private function render() : void
      {
         if(this.clip.menuClip.currentFrame == 1)
         {
            this.currentTotalList = this.magicList;
         }
         else
         {
            this.currentTotalList = this.changeList;
         }
         this.currentPage = 1;
         this.totalPage = Math.ceil(this.currentTotalList.length / this.pageNum);
         if(this.totalPage > 1)
         {
            this.currentPageList = this.currentTotalList.slice(0,10);
         }
         else
         {
            this.currentPageList = this.currentTotalList;
         }
         this.list.dataProvider = this.currentPageList;
      }
      
      public function changeMenu(evt:Event) : void
      {
         evt.stopImmediatePropagation();
         switch(evt.currentTarget)
         {
            case this.clip.shootClip:
               this.clip.menuClip.gotoAndStop(1);
               this.render();
               break;
            case this.clip.bianshenClip:
               this.clip.menuClip.gotoAndStop(2);
               this.render();
         }
      }
      
      private function itemClick(evt:ItemClickEvent) : void
      {
         var code:int = 0;
         var id:int = 0;
         if(GameData.instance.playerData.currentScenenId == 1028)
         {
            new FloatAlert().show(MapView.instance.stage,320,300,"这里不可以使用法术(⊙o⊙)哦");
            return;
         }
         var params:Object = evt.params;
         if(Boolean(params.isInMask))
         {
            return;
         }
         switch(params.id)
         {
            case 1:
               if(params.type == 2)
               {
                  dispatchEvent(new MessageEvent(EventConst.CHANGEFISH));
               }
               else
               {
                  code = 1;
               }
               break;
            default:
               if(params.type == 2)
               {
                  if(GamePersonControl.instance.isInSpecialSceneList())
                  {
                     new Alert().showOne("海里面不可以使用变身术哦(⊙o⊙)");
                     return;
                  }
               }
               if(params.state == 0)
               {
                  if(closeActionList.indexOf(params.actionId) >= 0)
                  {
                     this.clickCloseAction(params);
                     break;
                  }
                  new Alert().showOne(params.alert);
                  break;
               }
               if(params.useType == 2)
               {
                  if(params.actionId == 25)
                  {
                     AlertManager.instance.addTipAlert({
                        "tip":"玫瑰香花术正在维护，请等维护完成后使用。",
                        "type":1
                     });
                  }
                  else
                  {
                     this.dispatchEvent(new MessageEvent(MagicView.QUANPINGMAGIC,{
                        "id":params.actionId,
                        "type":params.type
                     }));
                  }
                  O.o("MagicView.QUANPINGMAGIC:",params.actionId,params.type);
                  break;
               }
               code = int(params.actionId);
         }
         if(code != 0)
         {
            MouseManager.getInstance().setCursor("CursorTool200" + code);
         }
         this.onRollOut(null);
      }
      
      private function onRollOut(evt:MouseEvent) : void
      {
         if(!this.isFixed)
         {
            this.clip.menuClip.gotoAndStop(1);
            if(Boolean(this.parent))
            {
               this.parent.removeChild(this);
            }
         }
      }
      
      private function clickCloseAction(params:Object) : void
      {
         var list:Array = this["closeAction" + params.actionId][GameData.instance.playerData.sex];
         var missNum:int = 0;
         var missStr:String = "";
         var clothId:int = Boolean(list[0]) ? int(list[0]) : 0;
         var footId:int = Boolean(list[1]) ? int(list[1]) : 0;
         var hatId:int = Boolean(list[2]) ? int(list[2]) : 0;
         var rightWeapon:int = Boolean(list[3]) ? int(list[3]) : 0;
         var leftWeapon:int = Boolean(list[4]) ? int(list[4]) : 0;
         var wingId:int = Boolean(list[5]) ? int(list[5]) : 0;
         if(Boolean(clothId) && GameData.instance.playerData.clothId != clothId)
         {
            missStr += String(XMLLocator.getInstance().getTool(clothId).name);
            missNum++;
         }
         if(Boolean(footId) && GameData.instance.playerData.footId != footId)
         {
            if(missNum > 0)
            {
               missStr += "、";
            }
            missStr += String(XMLLocator.getInstance().getTool(footId).name);
            missNum++;
         }
         if(Boolean(hatId) && GameData.instance.playerData.hatId != hatId)
         {
            if(missNum > 0)
            {
               missStr += "、";
            }
            missStr += String(XMLLocator.getInstance().getTool(hatId).name);
            missNum++;
         }
         if(Boolean(rightWeapon) && GameData.instance.playerData.weaponId != rightWeapon)
         {
            if(missNum > 0)
            {
               missStr += "、";
            }
            missStr += String(XMLLocator.getInstance().getTool(rightWeapon).name);
            missNum++;
         }
         if(Boolean(leftWeapon) && GameData.instance.playerData.leftWeapon != leftWeapon)
         {
            if(missNum > 0)
            {
               missStr += "、";
            }
            missStr += String(XMLLocator.getInstance().getTool(leftWeapon).name);
            missNum++;
         }
         if(Boolean(wingId) && GameData.instance.playerData.wingId != wingId)
         {
            if(missNum > 0)
            {
               missStr += "、";
            }
            missStr += String(XMLLocator.getInstance().getTool(wingId).name);
            missNum++;
         }
         if(missNum < list.length)
         {
            new Alert().showOne("你还没装备" + missStr);
         }
         else
         {
            new Alert().showOne(params.alert);
         }
      }
   }
}

