package com.game.modules.view.family
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.global.GlobalConfig;
   import com.game.locators.GameData;
   import com.game.util.ColorUtil;
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.alert.Alert;
   import com.publiccomponent.list.ItemRender;
   import com.publiccomponent.ui.ToolTip;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol690")]
   public class FamilyMemberItem extends ItemRender
   {
      
      public var nameTxt:TextField;
      
      public var headClip:MovieClip;
      
      public var headBtn:SimpleButton;
      
      public var bgClip:MovieClip;
      
      public var btnClip:MovieClip;
      
      private var loader:Loader;
      
      private const Level:Array = ["游民","族长","副族长","护法","精英","族员"];
      
      private var gfbLoader:Loader;
      
      public function FamilyMemberItem()
      {
         super();
         this.mouseEnabled = false;
         this.removeChild(this.nameTxt);
         this.removeChild(this.headClip);
         this.removeChild(this.headBtn);
         this.removeChild(this.btnClip);
         this.bgClip.gotoAndStop(1);
         this.nameTxt = null;
         this.headClip = null;
         this.headBtn = null;
         this.btnClip = null;
         this.gfbLoader = new Loader();
         this.gfbLoader.addEventListener(MouseEvent.MOUSE_DOWN,this.onOpenTransView);
         this.loader = new Loader();
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onComplete);
         this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
         this.loader.load(new URLRequest(URLUtil.getSvnVer("assets/family/familyMemberItem.swf")));
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoved);
      }
      
      private function onOpenTransView(evt:MouseEvent) : void
      {
         if(data.uid == GameData.instance.playerData.userId)
         {
            ApplicationFacade.getInstance().dispatch(EventConst.OPEN_MODULE,{
               "url":"assets/module/FamilyGoForBattleModule.swf",
               "xCoord":0,
               "yCoord":0,
               "params":{"flag":2}
            });
         }
      }
      
      private function onComplete(evt:Event) : void
      {
         this.bgClip = evt.currentTarget.content as MovieClip;
         this.bgClip.head_mc.gotoAndStop(data.sex + 1);
         this.bgClip.name_txt.text = data.uname;
         this.bgClip.name_txt.mouseEnabled = false;
         this.bgClip.name_txt.x -= 2;
         this.bgClip.level_txt.x -= 18;
         this.bgClip.level_txt.text = this.Level[data.level];
         this.bgClip.level_txt.mouseEnabled = false;
         this.bgClip.bg_mc.gotoAndStop(1);
         this.bgClip.bg_mc.mouseEnabled = false;
         this.addChild(this.bgClip);
         if(GameData.instance.playerData.family_id != GameData.instance.playerData.family_base_id)
         {
            this.bgClip.chatBtn.visible = false;
         }
         if(Boolean(this.loader))
         {
            this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onComplete);
            this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
         }
         this.bgClip.head_mc.addEventListener(MouseEvent.MOUSE_DOWN,this.onHead);
         this.bgClip.chatBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.onChat);
         this.mouseEnabled = true;
         if(Boolean(this.gfbLoader))
         {
            addChild(this.gfbLoader);
         }
      }
      
      private function onChat(evt:MouseEvent) : void
      {
         var sendBody:Object = null;
         if(this.data.uid == GlobalConfig.userId)
         {
            new Alert().showOne("不能自言自语哦(*^__^*) ");
            return;
         }
         if(this.data.isOnline == 0)
         {
            new Alert().showOne("族员不在线，不能聊天哦，快去叫他上线吧(*^__^*) ");
         }
         else
         {
            sendBody = {};
            sendBody.isBlack = 0;
            sendBody.isOnline = data.isOnline;
            sendBody.sex = data.sex;
            sendBody.userId = data.uid;
            sendBody.userName = data.uname;
            sendBody.vip = 0;
            sendBody.family = 0;
            ApplicationFacade.getInstance().dispatch(EventConst.CHATWITHFRIEND,sendBody);
         }
      }
      
      private function onIOError(evt:IOErrorEvent) : void
      {
         this.loader.unloadAndStop(false);
         this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onComplete);
         this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
      }
      
      override public function set data(params:Object) : void
      {
         if(params == null)
         {
            return;
         }
         this.buttonMode = true;
         super.data = params;
         if(data.level > 5 || data.level < 1)
         {
            data.level = 0;
         }
         this.gfbLoader.x = 168;
         if(params.token == 1)
         {
            this.gfbLoader.load(new URLRequest("assets/family/gfbitem.swf"));
            if(params.uid == GameData.instance.playerData.userId)
            {
               ToolTip.BindDO(this.gfbLoader,"出征令，拥有申请家族战场的权力。（点击可转移给其他族员）。");
            }
            else
            {
               ToolTip.BindDO(this.gfbLoader,"出征令，拥有申请家族战场的权力。");
            }
         }
         this.changeState(data.isOnline);
      }
      
      public function changeState(isOnline:int) : void
      {
         super.data.isOnline = isOnline;
         if(isOnline == 0)
         {
            this.filters = ColorUtil.getColorMatrixFilterGray();
         }
         else
         {
            this.filters = [];
         }
         if(data.uid == GlobalConfig.userId)
         {
            this.filters = [];
         }
      }
      
      private function onRemoved(evt:Event) : void
      {
         if(this.bgClip.hasOwnProperty("chatBtn"))
         {
            this.bgClip.chatBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.onChat);
         }
         if(this.bgClip.hasOwnProperty("head_mc"))
         {
            this.bgClip.head_mc.removeEventListener(MouseEvent.MOUSE_DOWN,this.onHead);
         }
         if(this.bgClip != null && this.contains(this.bgClip))
         {
            this.removeChild(this.bgClip);
         }
         this.bgClip = null;
         this.loader.unload();
         this.loader = null;
         if(Boolean(this.gfbLoader))
         {
            this.gfbLoader.removeEventListener(MouseEvent.MOUSE_DOWN,this.onOpenTransView);
            this.gfbLoader.unloadAndStop(false);
            ToolTip.LooseDO(this.gfbLoader);
            if(Boolean(this.gfbLoader.parent))
            {
               this.gfbLoader.parent.removeChild(this.gfbLoader);
            }
         }
         this.gfbLoader = null;
         this.removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemoved);
         super.dispos();
      }
      
      public function onDown() : void
      {
         this.bgClip.bg_mc.gotoAndStop(2);
      }
      
      public function onUp() : void
      {
         this.bgClip.bg_mc.gotoAndStop(1);
      }
      
      private function onHead(evt:MouseEvent) : void
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

