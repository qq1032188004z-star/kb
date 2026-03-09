package com.game.modules.view.stgcopy
{
   import com.core.observer.MessageEvent;
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.locators.GameData;
   import com.game.modules.control.stgcopy.StgCopyHeadControl;
   import com.game.util.CacheUtil;
   import com.game.util.ColorUtil;
   import com.game.util.HLoaderSprite;
   import com.publiccomponent.events.ItemClickEvent;
   import com.publiccomponent.list.TileList;
   import com.publiccomponent.loading.GreenLoading;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.URLVariables;
   import org.dress.ui.RoleFace;
   import phpcon.PhpConnection;
   import phpcon.PhpEvent;
   import phpcon.PhpEventConst;
   
   public class StgCopyRank extends HLoaderSprite
   {
      
      public static const CHECKEXCHANGE:String = "checkexchange";
      
      public static const STGEXCHANGE:String = "stgexchange";
      
      private var stglist:TileList;
      
      private var page:int;
      
      private var threearr:Array;
      
      private var roleface1:RoleFace;
      
      private var roleface2:RoleFace;
      
      private var roleface3:RoleFace;
      
      private var close:Boolean;
      
      private var long:int;
      
      public function StgCopyRank()
      {
         super();
         GreenLoading.loading.visible = true;
         this.url = "assets/material/STGrank.swf";
      }
      
      override public function setShow() : void
      {
         this.bg.cacheAsBitmap = true;
         ApplicationFacade.getInstance().registerViewLogic(new StgCopyHeadControl(this));
         this.initList();
         this.initEvents();
         this.getPhpdata(this.page = 1);
         this.init();
         GreenLoading.loading.visible = false;
      }
      
      private function init() : void
      {
         this.roleface1 = new RoleFace(297,216,4);
         this.roleface1.mouseEnabled = false;
         this.roleface2 = new RoleFace(131,243,4);
         this.roleface2.mouseEnabled = false;
         this.roleface3 = new RoleFace(460,257,4);
         this.roleface3.mouseEnabled = false;
         this.bg.firstmc.addChild(this.roleface1);
         this.bg.firstmc.addChild(this.roleface2);
         this.bg.firstmc.addChild(this.roleface3);
         this.bg.titlemc.stop();
         this.bg.descmc.visible = false;
         this.bg.firstmc.visible = true;
         this.bg.bgmc.visible = false;
         this.bg.exchangemc.visible = false;
         this.stglist.visible = false;
         for(var i:int = 1; i < 4; i++)
         {
            this.bg["mc" + i].visible = false;
         }
      }
      
      private function initEvents() : void
      {
         this.bg.valuebtn.addEventListener(MouseEvent.CLICK,this.onvalue);
         this.bg.btn1.addEventListener(MouseEvent.CLICK,this.onbtn);
         this.bg.btn2.addEventListener(MouseEvent.CLICK,this.onbtn);
         this.bg.btn3.addEventListener(MouseEvent.CLICK,this.onbtn);
         this.bg.btn4.addEventListener(MouseEvent.CLICK,this.onbtn);
         this.bg.btn5.addEventListener(MouseEvent.CLICK,this.onbtn);
         this.bg.closebtn.addEventListener(MouseEvent.CLICK,this.onclose);
         this.bg.bgmc.leftbtn.addEventListener(MouseEvent.MOUSE_DOWN,this.onleft);
         this.bg.bgmc.rightbtn.addEventListener(MouseEvent.MOUSE_DOWN,this.onright);
         this.bg.firstmc.tobtn2.addEventListener(MouseEvent.CLICK,this.tobtn2);
         this.stglist.addEventListener(ItemClickEvent.ITEMCLICKEVENT,this.onclicklist,true);
         PhpConnection.instance().addEventListener(PhpEventConst.RANKINGLISTBACK,this.onachieveback);
         for(var i:int = 1; i < 9; i++)
         {
            this.bg.exchangemc["obtainbtn" + i].addEventListener(MouseEvent.CLICK,this.onExchange);
            this.bg.exchangemc["hasobtainbtn" + i].visible = false;
         }
      }
      
      private function removeEvents() : void
      {
         this.bg.valuebtn.removeEventListener(MouseEvent.CLICK,this.onvalue);
         this.bg.btn1.removeEventListener(MouseEvent.CLICK,this.onbtn);
         this.bg.btn2.removeEventListener(MouseEvent.CLICK,this.onbtn);
         this.bg.btn3.removeEventListener(MouseEvent.CLICK,this.onbtn);
         this.bg.btn4.removeEventListener(MouseEvent.CLICK,this.onbtn);
         this.bg.btn5.removeEventListener(MouseEvent.CLICK,this.onbtn);
         this.bg.closebtn.removeEventListener(MouseEvent.CLICK,this.onclose);
         this.bg.bgmc.leftbtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.onleft);
         this.bg.bgmc.rightbtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.onright);
         this.bg.firstmc.tobtn2.addEventListener(MouseEvent.CLICK,this.tobtn2);
         this.stglist.removeEventListener(ItemClickEvent.ITEMCLICKEVENT,this.onclicklist,true);
         PhpConnection.instance().removeEventListener(PhpEventConst.RANKINGLISTBACK,this.onachieveback);
         for(var i:int = 1; i < 9; i++)
         {
            this.bg.exchangemc["obtainbtn" + i].removeEventListener(MouseEvent.CLICK,this.onExchange);
         }
      }
      
      private function initList() : void
      {
         this.stglist = new TileList(224,178.5);
         this.stglist.build(1,10,557,26,0,0,StgCopyRankItem);
         this.bg.addChild(this.stglist);
      }
      
      private function getPhpdata(page:int) : void
      {
         var i:int = 0;
         this.bg.bgmc.pagetxt.text = page + "/30";
         for(i = 1; i < 4; i++)
         {
            this.bg["mc" + i].visible = false;
         }
         if(page == 1)
         {
            for(i = 1; i < 4; i++)
            {
               this.bg["mc" + i].visible = true;
               this.bg.setChildIndex(this.bg["mc" + i],this.bg.numChildren - 1);
            }
         }
         var urlvar:URLVariables = new URLVariables();
         urlvar.page = page;
         if(this.bg.titlemc.currentFrame == 3)
         {
            PhpConnection.instance().getdata("stg_explorer/total_ranking.php",urlvar);
         }
         else
         {
            PhpConnection.instance().getdata("stg_explorer/game_ranking.php",urlvar);
         }
      }
      
      private function onvalue(evt:MouseEvent) : void
      {
         ApplicationFacade.getInstance().dispatch(EventConst.GET_STGCOPY_SCORE);
      }
      
      private function onbtn(evt:MouseEvent) : void
      {
         var i:int = 0;
         var str:String = evt.currentTarget.name.substring(3);
         this.bg.titlemc.gotoAndStop(int(str));
         if(this.bg.titlemc.currentFrame == 2 || this.bg.titlemc.currentFrame == 3)
         {
            this.bg.bgmc.visible = true;
            this.bg.descmc.visible = false;
            this.stglist.visible = true;
            this.bg.firstmc.visible = false;
            this.bg.exchangemc.visible = false;
            this.page = 1;
            this.onback();
         }
         else if(this.bg.titlemc.currentFrame == 5)
         {
            this.bg.bgmc.visible = false;
            this.bg.descmc.visible = true;
            this.stglist.visible = false;
            this.bg.firstmc.visible = false;
            this.bg.exchangemc.visible = false;
            for(i = 1; i < 4; i++)
            {
               this.bg["mc" + i].visible = false;
            }
         }
         else if(this.bg.titlemc.currentFrame == 1)
         {
            this.bg.firstmc.visible = true;
            this.bg.bgmc.visible = false;
            this.bg.descmc.visible = false;
            this.stglist.visible = false;
            this.bg.exchangemc.visible = false;
            for(i = 1; i < 4; i++)
            {
               this.bg["mc" + i].visible = false;
            }
         }
         else
         {
            this.bg.firstmc.visible = false;
            this.bg.bgmc.visible = false;
            this.bg.descmc.visible = false;
            this.stglist.visible = false;
            this.bg.exchangemc.visible = true;
            for(i = 1; i < 4; i++)
            {
               this.bg["mc" + i].visible = false;
            }
            this.dispatchEvent(new Event(CHECKEXCHANGE));
         }
      }
      
      private function onclose(evt:MouseEvent) : void
      {
         this.disport();
      }
      
      private function onback() : void
      {
         this.getPhpdata(this.page);
      }
      
      private function onleft(evt:MouseEvent) : void
      {
         if(this.page <= 1)
         {
            return;
         }
         --this.page;
         this.getPhpdata(this.page);
      }
      
      private function onright(evt:MouseEvent) : void
      {
         if(this.page >= 30)
         {
            return;
         }
         ++this.page;
         this.getPhpdata(this.page);
      }
      
      private function tobtn2(evt:MouseEvent) : void
      {
         this.bg.btn2.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
      }
      
      private function onclicklist(evt:ItemClickEvent) : void
      {
         var item:StgCopyRankItem = null;
         var data:Object = evt.params;
         var len:int = this.stglist.numChildren;
         for(var i:int = 0; i < len; i++)
         {
            item = this.stglist.getChildAt(i) as StgCopyRankItem;
            if(data == item.data)
            {
               if(data.uid != GameData.instance.playerData.userId)
               {
                  ApplicationFacade.getInstance().dispatch(EventConst.OPENPERSONINFOVIEW,{
                     "userId":data.uid,
                     "isOnline":0,
                     "source":0,
                     "userName":data.uname,
                     "sex":1,
                     "body":data,
                     "infoShield":1
                  });
               }
               else
               {
                  ApplicationFacade.getInstance().dispatch(EventConst.OPENPERSONDETAILVIEW,{
                     "userId":data.uid,
                     "isOnline":0,
                     "source":0,
                     "userName":data.uname,
                     "sex":GameData.instance.playerData.roleType & 1,
                     "body":GameData.instance.playerData
                  });
               }
            }
         }
      }
      
      private function onachieveback(evt:PhpEvent) : void
      {
         var showList:Array = evt.data.list != null ? evt.data.list : [];
         var len:int = int(showList.length);
         if(len == 0 || len == 1 && showList[0] == null)
         {
            return;
         }
         for(var i:int = 0; i < len; i++)
         {
            showList[i].rank = (this.page - 1) * 10 + i + 1;
         }
         if(this.page == 1 && this.bg.titlemc.currentFrame == 1)
         {
            this.close = false;
            this.threearr = showList.slice(0,3);
            if(this.threearr.length >= 1)
            {
               this.bg.firstmc.txt1.text = this.threearr[0].uname;
               this.long = 1;
            }
            if(this.threearr.length >= 2)
            {
               this.bg.firstmc.txt2.text = this.threearr[1].uname;
               this.long = 2;
            }
            if(this.threearr.length >= 3)
            {
               this.bg.firstmc.txt3.text = this.threearr[2].uname;
               this.long = 3;
            }
            this.showthree();
         }
         this.stglist.dataProvider = showList;
      }
      
      private function showthree() : void
      {
         if(this.threearr.length == 0)
         {
            this.close = true;
            return;
         }
         ApplicationFacade.getInstance().dispatch(EventConst.STG_GETHEAD,this.threearr.shift().uid);
      }
      
      public function showhead(data:Object) : void
      {
         if(this.close)
         {
            return;
         }
         var index:int = this.long - this.threearr.length;
         this.setHeadImage(this["roleface" + index],data);
         this.showthree();
      }
      
      private function setHeadImage(roleFace:RoleFace, checkParams:Object) : void
      {
         roleFace.setRole(checkParams);
      }
      
      private function onExchange(evt:MouseEvent) : void
      {
         var index:int = int(evt.currentTarget.name.substring(9));
         this.dispatchEvent(new MessageEvent(STGEXCHANGE,{"index":index}));
         this.bg.exchangemc["hasobtainbtn" + index].visible = true;
      }
      
      public function checkExchange(data:Object) : void
      {
         var i:int = 0;
         var exchangeFlag:int = int(data.exchange);
         for(i = 1; i < 9; i++)
         {
            this.bg.exchangemc["hasobtainbtn" + i].visible = true;
         }
         for(i = 0; i < 8; i++)
         {
            if((exchangeFlag & 1 << i) == 0)
            {
               this.bg.exchangemc["hasobtainbtn" + (i + 1)].visible = false;
            }
         }
         var totalValue:int = int(data.total);
         var visibleFlag:int = 0;
         if(totalValue < 20000)
         {
            visibleFlag = 1;
         }
         if(totalValue < 10000)
         {
            visibleFlag = 2;
         }
         if(totalValue < 5000)
         {
            visibleFlag = 3;
         }
         if(totalValue < 2000)
         {
            visibleFlag = 4;
         }
         if(totalValue < 1000)
         {
            visibleFlag = 5;
         }
         if(totalValue < 500)
         {
            visibleFlag = 6;
         }
         if(totalValue < 350)
         {
            visibleFlag = 7;
         }
         if(totalValue < 100)
         {
            visibleFlag = 8;
         }
         for(i = 8; i > 8 - visibleFlag; i--)
         {
            if(Boolean(this.bg.exchangemc["obtainbtn" + i]))
            {
               this.bg.exchangemc["obtainbtn" + i].filters = ColorUtil.getColorMatrixFilterGray();
               this.bg.exchangemc["obtainbtn" + i].mouseEnabled = false;
            }
         }
      }
      
      override public function disport() : void
      {
         CacheUtil.deleteObject(StgCopyRank);
         ApplicationFacade.getInstance().removeViewLogic(StgCopyHeadControl.name);
         this.removeEvents();
         this.roleface1.dispos();
         this.roleface1 = null;
         this.roleface2.dispos();
         this.roleface2 = null;
         this.roleface3.dispos();
         this.roleface3 = null;
         this.stglist.dataProvider = [];
         if(Boolean(this.stglist))
         {
            if(Boolean(this.stglist.parent))
            {
               this.stglist.parent.removeChild(this.stglist);
            }
            this.stglist = null;
         }
         super.disport();
      }
   }
}

