package com.game.modules.view
{
   import com.core.observer.MessageEvent;
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.global.GlobalConfig;
   import com.game.locators.GameData;
   import com.game.manager.EventManager;
   import com.game.util.FloatAlert;
   import com.game.util.GameDynamicUI;
   import com.game.util.HLoaderSprite;
   import com.game.util.PropertyPool;
   import com.game.util.ShareLocalUtil;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.external.ExternalInterface;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class SelectServer extends HLoaderSprite
   {
      
      private var serverClip:MovieClip;
      
      private var totalList:Array;
      
      private var currentPageList:Array;
      
      private var totalPage:int = 1;
      
      private var currentPage:int = 1;
      
      private var pageNum:int = 8;
      
      private var tuiJianList:Array = [];
      
      private var currentSid:int;
      
      private var len:int;
      
      private var start:int;
      
      private var end:int;
      
      private var tid:int = 0;
      
      private var lsid1:int = 0;
      
      private var lsid2:int = 0;
      
      private var le:int = 0;
      
      public function SelectServer()
      {
         super();
         this.addEventListener(Event.ADDED_TO_STAGE,this.onAddToStage);
         this.url = "assets/material/serverselect.swf";
         this.len = GameData.instance.playerData.totalServerNum;
         GameData.instance.playerData.nextSceneId = 0;
      }
      
      private function onAddToStage(evt:Event) : void
      {
         GameDynamicUI.addUI(stage,200,200,"loading");
         this.removeEventListener(Event.ADDED_TO_STAGE,this.onAddToStage);
      }
      
      override public function setShow() : void
      {
         GameDynamicUI.removeUI("loading");
         this.serverClip = this.bg;
         this.hidebtn();
         this.serverClip.cacheAsBitmap = true;
         this.serverClip.pageTxt.text = "";
         this.serverClip.pageTxt.visible = false;
         this.serverClip.leftBtn.visible = false;
         this.serverClip.rightBtn.visible = false;
         this.serverClip.checkAll.gotoAndStop(1);
         this.serverClip.tipClip.gotoAndStop(1);
         this.initEvent();
         var obj:Object = ShareLocalUtil.instance.check(GlobalConfig.userName);
         if(Boolean(obj))
         {
            if(Boolean(obj.enterSid1))
            {
               this.lsid1 = obj.enterSid1;
            }
            if(Boolean(obj.enterSid2))
            {
               this.lsid2 = obj.enterSid2;
            }
         }
         ApplicationFacade.getInstance().dispatch(EventConst.GETTUIJIANSERVERLIST,{
            "sid1":this.lsid1,
            "sid2":this.lsid2
         });
      }
      
      private function getTuiJianList() : void
      {
         var start:int = 0;
         var end:int = 0;
         if(this.len < 8)
         {
            ApplicationFacade.getInstance().dispatch(EventConst.GETSERVERLIST,{
               "start":0,
               "end":8
            });
         }
         else
         {
            start = this.len / this.pageNum;
            start = (start - 1) * 8;
            end = this.len / this.pageNum;
            end *= 8;
            ApplicationFacade.getInstance().dispatch(EventConst.GETSERVERLIST,{
               "start":start,
               "end":end
            });
         }
      }
      
      private function initEvent() : void
      {
         this.serverClip.title.gotoAndStop(1);
         this.serverClip.serverTxt.restrict = "0-9";
         EventManager.attachEvent(this.serverClip.quickEnterBtn,MouseEvent.MOUSE_DOWN,this.searchServer);
         EventManager.attachEvent(this.serverClip.rightBtn,MouseEvent.MOUSE_DOWN,this.moveRight);
         EventManager.attachEvent(this.serverClip.leftBtn,MouseEvent.MOUSE_DOWN,this.moveLeft);
         EventManager.attachEvent(this.serverClip.addFavorute,MouseEvent.MOUSE_DOWN,this.addMyFavorute);
         EventManager.attachEvent(this.serverClip.checkAll,MouseEvent.MOUSE_DOWN,this.showAllServer);
         EventManager.attachEvent(this.serverClip.serverTxt,FocusEvent.FOCUS_IN,this.focusIn);
         EventManager.attachEvent(this.serverClip.serverTxt,FocusEvent.FOCUS_OUT,this.focusOut);
         EventManager.attachEvent(this.serverClip.mathenter,MouseEvent.MOUSE_DOWN,this.enterRander);
         var i:int = 8;
         while(i > 0)
         {
            this.serverClip["s" + i].visible = false;
            this.serverClip["s" + i].gotoAndStop(1);
            this.serverClip["s" + i].smc.gotoAndStop(1);
            this.serverClip["s" + i].buttonMode = true;
            this.serverClip["s" + i].snum.mouseEnabled = false;
            this.serverClip["s" + i].sname.mouseEnabled = false;
            this.serverClip["s" + i].addEventListener(MouseEvent.CLICK,this.onClickSitem);
            this.serverClip["s" + i].addEventListener(MouseEvent.ROLL_OVER,this.onOverSitem);
            this.serverClip["s" + i].addEventListener(MouseEvent.ROLL_OUT,this.onOutSitem);
            i--;
         }
         this.serverClip.tipClip.okbtn2.addEventListener(MouseEvent.CLICK,this.onok2Handler);
         this.serverClip.tipClip.okbtn3.addEventListener(MouseEvent.CLICK,this.onok3Handler);
         this.serverClip.tipClip.okbtn4.addEventListener(MouseEvent.CLICK,this.onok4Handler);
         this.serverClip.tipClip.nobtn3.addEventListener(MouseEvent.CLICK,this.onno3Handler);
      }
      
      private function focusIn(evt:FocusEvent) : void
      {
         if(!this.serverClip.serverTxt.hasEventListener(KeyboardEvent.KEY_DOWN))
         {
            this.serverClip.serverTxt.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         }
         this.serverClip.serverTxt.text = "";
         this.currentSid = 0;
      }
      
      private function onKeyDown(evt:KeyboardEvent) : void
      {
         if(evt.keyCode == 13)
         {
            EventManager.removeEvent(this.serverClip.serverTxt,FocusEvent.FOCUS_OUT,this.focusOut);
            this.currentSid = int(this.serverClip.serverTxt.text);
            this.searchServer(null);
         }
      }
      
      private function focusOut(evt:FocusEvent) : void
      {
         if(Boolean(this.serverClip))
         {
            this.currentSid = int(this.serverClip.serverTxt.text);
            if(this.currentSid == 0)
            {
               this.serverClip.serverTxt.text = "请输入服务器编号";
            }
         }
      }
      
      private function searchServer(evt:MouseEvent) : void
      {
         if(this.currentSid == 0)
         {
            this.currentSid = int(this.serverClip.serverTxt.text);
            if(this.currentSid == 0)
            {
               new FloatAlert().show(stage,300,300,"请输入编号..");
            }
            return;
         }
         this.enterServer(this.currentSid);
      }
      
      private function selectServer(evt:MessageEvent) : void
      {
         this.enterServer(int(evt.body.sid),String(evt.body.serverName));
      }
      
      private function showAllServer(evt:MouseEvent) : void
      {
         GameDynamicUI.addUI(stage,200,200,"loading");
         if(this.serverClip.checkAll.currentFrame == 1)
         {
            this.currentPage = 1;
            this.serverClip.title.gotoAndStop(2);
            this.serverClip.checkAll.gotoAndStop(2);
            ApplicationFacade.getInstance().dispatch(EventConst.GETSERVERLIST,{
               "start":0,
               "end":8
            });
         }
         else
         {
            this.currentPage = 1;
            this.serverClip.title.gotoAndStop(1);
            this.serverClip.checkAll.gotoAndStop(1);
            ApplicationFacade.getInstance().dispatch(EventConst.GETTUIJIANSERVERLIST,{
               "sid1":this.lsid1,
               "sid2":this.lsid2
            });
         }
      }
      
      private function addMyFavorute(evt:MouseEvent) : void
      {
         if(ExternalInterface.available)
         {
            ExternalInterface.call("addCookie");
         }
      }
      
      private function moveRight(evt:MouseEvent) : void
      {
         var startIndex:int = 0;
         var endIndex:int = 0;
         if(this.currentPage < this.totalPage)
         {
            ++this.currentPage;
            startIndex = (this.currentPage - 1) * 8;
            endIndex = this.currentPage * 8;
            if(endIndex > this.totalList.length)
            {
               endIndex = int(this.totalList.length);
            }
            this.currentPageList = this.totalList.slice(startIndex,endIndex);
            this.render();
         }
      }
      
      private function moveLeft(evt:MouseEvent) : void
      {
         var startIndex:int = 0;
         var endIndex:int = 0;
         if(this.currentPage > 1)
         {
            --this.currentPage;
            startIndex = (this.currentPage - 1) * 8;
            endIndex = this.currentPage * 8;
            if(endIndex < 0)
            {
               endIndex = 0;
            }
            this.currentPageList = this.totalList.slice(startIndex,endIndex);
            this.render();
         }
      }
      
      public function dispos() : void
      {
         var i:int = 0;
         clearTimeout(this.tid);
         if(Boolean(this.serverClip))
         {
            this.serverClip.stop();
            this.serverClip.tipClip.okbtn2.addEventListener(MouseEvent.CLICK,this.onok2Handler);
            this.serverClip.tipClip.okbtn3.addEventListener(MouseEvent.CLICK,this.onok3Handler);
            this.serverClip.tipClip.okbtn4.addEventListener(MouseEvent.CLICK,this.onok4Handler);
            this.serverClip.tipClip.nobtn3.addEventListener(MouseEvent.CLICK,this.onno3Handler);
         }
         if(this.serverClip != null)
         {
            i = 8;
            while(i > 0)
            {
               this.serverClip["s" + i].removeEventListener(MouseEvent.CLICK,this.onClickSitem);
               this.serverClip["s" + i].removeEventListener(MouseEvent.ROLL_OVER,this.onOverSitem);
               this.serverClip["s" + i].removeEventListener(MouseEvent.ROLL_OUT,this.onOutSitem);
               i--;
            }
            if(Boolean(this.serverClip.serverTxt))
            {
               EventManager.removeEvent(this.serverClip.serverTxt,FocusEvent.FOCUS_IN,this.focusIn);
               EventManager.removeEvent(this.serverClip.serverTxt,FocusEvent.FOCUS_OUT,this.focusOut);
            }
            EventManager.removeEvent(this.serverClip.mathenter,MouseEvent.MOUSE_DOWN,this.enterRander);
            EventManager.removeEvent(this.serverClip.viewAllBtn,MouseEvent.MOUSE_DOWN,this.showAllServer);
            EventManager.removeEvent(this.serverClip.addFavorute,MouseEvent.MOUSE_DOWN,this.addMyFavorute);
            EventManager.removeEvent(this.serverClip.searchBtn,MouseEvent.MOUSE_DOWN,this.searchServer);
            EventManager.removeEvent(this.serverClip.rightBtn,MouseEvent.MOUSE_DOWN,this.moveRight);
            EventManager.removeEvent(this.serverClip.leftBtn,MouseEvent.MOUSE_DOWN,this.moveLeft);
            if(this.contains(this.serverClip))
            {
               this.removeChild(this.serverClip);
            }
         }
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
         this.serverClip = null;
      }
      
      public function setData(params:Object) : void
      {
         GameDynamicUI.removeUI("loading");
         if(this.serverClip.checkAll.currentFrame == 1)
         {
            this.serverClip.pageTxt.visible = false;
         }
         else
         {
            this.serverClip.pageTxt.visible = true;
         }
         if(Boolean(this.serverClip) && Boolean(this.serverClip.hasOwnProperty("tipClip")))
         {
            this.serverClip.tipClip.visible = false;
         }
         if(params.worldList == null || this.serverClip == null)
         {
            return;
         }
         if(Boolean(this.serverClip.title) && this.serverClip.title.currentFrame == 1)
         {
            this.showTuiJianServerList(params.worldList as Array);
         }
         else
         {
            this.showSelectList(params.worldList as Array);
         }
      }
      
      private function showTuiJianServerList(list:Array) : void
      {
         this.tuiJianList = this.filterList(list);
         this.serverClip.pageTxt.text = "";
         this.serverClip.rightBtn.visible = false;
         this.serverClip.leftBtn.visible = false;
         this.currentPageList = this.tuiJianList;
         this.totalPage = 1;
         this.render();
      }
      
      private function filterList(list:Array) : Array
      {
         var l:int = 0;
         var i:int = 0;
         var t:Array = null;
         var r:Array = null;
         if(list == null)
         {
            list = [];
         }
         if(Boolean(list))
         {
            l = int(list.length);
            i = 0;
            r = [];
            if(this.lsid1 > 10 || this.lsid2 > 10)
            {
               for(i = 0; i < l; i++)
               {
                  if(this.lsid2 == list[i].sid)
                  {
                     t = list.splice(i,1);
                     l--;
                     break;
                  }
               }
               for(i = 0; i < l; i++)
               {
                  if(this.lsid1 == list[i].sid)
                  {
                     r = list.splice(i,1);
                     if(Boolean(t))
                     {
                        r = r.concat(t);
                     }
                     break;
                  }
               }
            }
            if(Boolean(list) && list.length > 0)
            {
               r = r.concat(list);
            }
         }
         return r;
      }
      
      private function showSelectList(list:Array) : void
      {
         this.totalList = list;
         this.totalList.sortOn("sid",Array.NUMERIC);
         this.serverClip.leftBtn.visible = true;
         this.serverClip.rightBtn.visible = true;
         var len:int = GameData.instance.playerData.totalServerNum;
         if(len > this.pageNum)
         {
            this.currentPageList = this.totalList;
            if(this.currentPage <= 0)
            {
               this.currentPage = 1;
            }
            this.totalPage = Math.ceil(len / this.pageNum);
         }
         else
         {
            this.currentPageList = this.totalList;
            this.currentPage = 1;
            this.totalPage = 1;
         }
         this.render();
         clearTimeout(this.tid);
         this.tid = setTimeout(this.timeout60,60000);
      }
      
      private function timeout60() : void
      {
         clearTimeout(this.tid);
         this.enterRander(null);
      }
      
      private function render() : void
      {
         this.serverClip.pageTxt.text = this.currentPage + "/" + this.totalPage;
         var i:int = 8;
         while(i > 0)
         {
            if(Boolean(this.currentPageList[i - 1]) && Boolean(this.serverClip))
            {
               this.serverClip["s" + i].snum.text = "" + this.currentPageList[i - 1].sid;
               this.serverClip["s" + i].sname.text = "" + this.currentPageList[i - 1].serverName;
               this.serverClip["s" + i].gotoAndStop(1);
               if(this.currentPageList[i - 1].onlineNumber < 7 && this.currentPageList[i - 1].onlineNumber > 0)
               {
                  this.serverClip["s" + i].smc.gotoAndStop(this.currentPageList[i - 1].onlineNumber);
               }
               else
               {
                  this.serverClip["s" + i].smc.gotoAndStop(1);
               }
               if(i == 1 && this.currentPageList[i - 1].sid == this.lsid1)
               {
                  this.serverClip["s" + i].gotoAndStop(3);
               }
               else if(i == 2 && this.currentPageList[i - 1].sid == this.lsid2)
               {
                  this.serverClip["s" + i].gotoAndStop(3);
               }
               this.serverClip["s" + i].visible = true;
            }
            else if(Boolean(this.serverClip))
            {
               this.serverClip["s" + i].visible = false;
            }
            i--;
         }
      }
      
      private function setLastServer(sid:int) : void
      {
      }
      
      private function onClickSitem(evt:MouseEvent) : void
      {
         this.enterServer(int(evt.currentTarget.snum.text),String(evt.currentTarget.sname.text));
      }
      
      private function onOverSitem(evt:MouseEvent) : void
      {
         evt.currentTarget.gotoAndStop(evt.currentTarget.currentFrame + 1);
      }
      
      private function onOutSitem(evt:MouseEvent) : void
      {
         evt.currentTarget.gotoAndStop(evt.currentTarget.currentFrame - 1);
      }
      
      private function enterRander(evt:MouseEvent) : void
      {
         this.enterServer(this.currentPageList[int(Math.random() * this.currentPageList.length)].sid);
      }
      
      private function enterServer(sid:int, sname:String = "") : void
      {
         if(sid > 0)
         {
            if(Boolean(this.serverClip))
            {
               this.hidebtn();
               this.serverClip.tipClip.gotoAndStop(1);
               this.serverClip.tipClip.visible = true;
            }
            GameData.instance.playerData.enterSid = sid;
            GameData.instance.playerData.serverName = sname;
            ApplicationFacade.getInstance().dispatch("selectserver",GameData.instance.playerData.enterSid);
            if(sname == "")
            {
               PropertyPool.instance.getXML("config/","server",this.xmlLoaded);
            }
         }
      }
      
      private function xmlLoaded(xml:XML) : void
      {
         var sid:int = 0;
         var adds:String = null;
         sid = GameData.instance.playerData.enterSid;
         adds = "";
         if(sid > 621)
         {
            sid -= 621;
            adds = "2";
         }
         xml = xml.children().(@id == sid)[0];
         if(Boolean(xml))
         {
            GameData.instance.playerData.serverName = xml.attribute("name") + adds;
         }
         else
         {
            GameData.instance.playerData.serverName = sid + ".";
         }
      }
      
      private function hidebtn() : void
      {
         if(Boolean(this.serverClip))
         {
            this.serverClip.tipClip.okbtn2.visible = false;
            this.serverClip.tipClip.okbtn3.visible = false;
            this.serverClip.tipClip.okbtn4.visible = false;
            this.serverClip.tipClip.nobtn3.visible = false;
         }
      }
      
      public function enterServerBack(value:int) : void
      {
         this.serverClip.tipClip.gotoAndStop(3);
         this.serverClip.tipClip.visible = true;
         this.hidebtn();
         this.serverClip.tipClip.okbtn3.visible = true;
         this.serverClip.tipClip.nobtn3.visible = true;
      }
      
      private function onno3Handler(evt:MouseEvent) : void
      {
         this.serverClip.tipClip.visible = false;
      }
      
      private function onok3Handler(evt:MouseEvent) : void
      {
         this.enterRander(null);
      }
      
      private function onok2Handler(evt:MouseEvent) : void
      {
         this.serverClip.tipClip.visible = false;
      }
      
      private function onok4Handler(evt:MouseEvent) : void
      {
      }
   }
}

