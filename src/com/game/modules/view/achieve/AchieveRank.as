package com.game.modules.view.achieve
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.locators.GameData;
   import com.game.locators.MsgDoc;
   import com.game.modules.control.achieve.AchieveRankControl;
   import com.game.util.CacheUtil;
   import com.game.util.HLoaderSprite;
   import com.publiccomponent.events.ItemClickEvent;
   import com.publiccomponent.list.TileList;
   import com.publiccomponent.loading.GreenLoading;
   import flash.events.MouseEvent;
   import flash.net.URLVariables;
   import org.green.server.manager.SocketManager;
   
   public class AchieveRank extends HLoaderSprite
   {
      
      private var achievelist:TileList;
      
      private var page:int;
      
      public function AchieveRank()
      {
         super();
         GreenLoading.loading.visible = true;
         this.url = "assets/achieve/achieverank.swf";
      }
      
      override public function setShow() : void
      {
         this.bg.cacheAsBitmap = true;
         ApplicationFacade.getInstance().registerViewLogic(new AchieveRankControl(this));
         this.initList();
         this.initEvents();
         this.getPhpdata(this.page = 1);
         GreenLoading.loading.visible = false;
      }
      
      private function initEvents() : void
      {
         this.bg.closebtn.addEventListener(MouseEvent.CLICK,this.onclose);
         this.bg.backbtn.addEventListener(MouseEvent.CLICK,this.onback);
         this.bg.leftbtn.addEventListener(MouseEvent.MOUSE_DOWN,this.onleft);
         this.bg.rightbtn.addEventListener(MouseEvent.MOUSE_DOWN,this.onright);
         this.achievelist.addEventListener(ItemClickEvent.ITEMCLICKEVENT,this.onclicklist,true);
      }
      
      private function removeEvents() : void
      {
         this.bg.closebtn.removeEventListener(MouseEvent.CLICK,this.onclose);
         this.bg.backbtn.removeEventListener(MouseEvent.CLICK,this.onback);
         this.bg.leftbtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.onleft);
         this.bg.rightbtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.onright);
         this.achievelist.removeEventListener(ItemClickEvent.ITEMCLICKEVENT,this.onclicklist,true);
      }
      
      private function initList() : void
      {
         this.achievelist = new TileList(249,170);
         this.achievelist.build(1,10,474,-1,0,23,AchieveRankItem);
         this.bg.addChild(this.achievelist);
      }
      
      private function getPhpdata(page:int) : void
      {
         var i:int = 0;
         this.bg.pagetxt.text = page + "/20";
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
         SocketManager.getGreenSocket().sendCmd(MsgDoc.OP_CLIENT_ACTIVITY_QINGYANG_NEW.send,646,["get_revrange",10000,page]);
      }
      
      private function onclose(evt:MouseEvent) : void
      {
         this.disport();
      }
      
      private function onback(evt:MouseEvent) : void
      {
         this.page = 1;
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
         if(this.page >= 20)
         {
            return;
         }
         ++this.page;
         this.getPhpdata(this.page);
      }
      
      private function onclicklist(evt:ItemClickEvent) : void
      {
         var item:AchieveRankItem = null;
         var data:Object = evt.params;
         var len:int = this.achievelist.numChildren;
         for(var i:int = 0; i < len; i++)
         {
            item = this.achievelist.getChildAt(i) as AchieveRankItem;
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
                     "body":data
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
      
      public function onAchieveback(obj:Object) : void
      {
         var showList:Array = obj.list != null ? obj.list : [];
         var len:int = int(showList.length);
         for(var i:int = 0; i < len; i++)
         {
            showList[i].rank = (this.page - 1) * 10 + i + 1;
         }
         if(Boolean(this.achievelist))
         {
            this.achievelist.dataProvider = showList;
         }
      }
      
      override public function disport() : void
      {
         CacheUtil.deleteObject(AchieveRank);
         this.removeEvents();
         this.achievelist.dataProvider = [];
         if(Boolean(this.achievelist))
         {
            if(Boolean(this.achievelist.parent))
            {
               this.achievelist.parent.removeChild(this.achievelist);
            }
            this.achievelist = null;
         }
         super.disport();
      }
   }
}

