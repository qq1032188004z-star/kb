package com.game.modules.view.trump
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.global.GlobalConfig;
   import com.game.locators.GameData;
   import com.game.manager.EventManager;
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.alert.Alert;
   import com.publiccomponent.loading.MaterialLib;
   import com.publiccomponent.ui.ToolTip;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.utils.getQualifiedClassName;
   import org.engine.game.MoveSprite;
   import org.engine.path.AStarPath;
   
   public class TrumpView extends MoveSprite
   {
      
      public var fabaoClip:MovieClip;
      
      private var functionClip:MovieClip;
      
      private var loader:Loader;
      
      public var params:Object;
      
      public function TrumpView()
      {
         super();
         this.speed = 6;
         ui = new Sprite();
         this.init();
      }
      
      private function init() : void
      {
         this.functionClip = MaterialLib.getInstance().getMaterial("functionClip") as MovieClip;
         this.loader = new Loader();
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoadComplement);
      }
      
      private function onLoadComplement(evt:Event) : void
      {
         var domain:ApplicationDomain = evt.currentTarget.applicationDomain as ApplicationDomain;
         var cls:Class = domain.getDefinition("fabao") as Class;
         if(cls != null)
         {
            this.fabaoClip = new cls() as MovieClip;
            this.fabaoClip.y -= 80;
            this.addChild(this.fabaoClip);
            this.fabaoClip.buttonMode = true;
            this.fabaoClip.gotoAndStop(1);
            ToolTip.BindDO(this.fabaoClip,"点击查看贝贝信息");
            if(this.functionClip != null)
            {
               this.functionClip.y = -108;
               this.functionClip.x = 20;
               this.addChild(this.functionClip);
               this.functionClip.visible = false;
            }
            EventManager.attachEvent(this.fabaoClip,MouseEvent.MOUSE_DOWN,this.onClickIt);
            if(this.params.userId == GlobalConfig.userId)
            {
               this.initEvent();
               this.initToolTip();
            }
            if(ui.stage != null)
            {
               ui.stage.addEventListener(MouseEvent.MOUSE_DOWN,this.hideMenuClip);
            }
         }
      }
      
      private function initEvent() : void
      {
         EventManager.attachEvent(this.ui,MouseEvent.MOUSE_OVER,this.onOverTrump);
         EventManager.attachEvent(this.ui,MouseEvent.MOUSE_OUT,this.onOutTrump);
         EventManager.attachEvent(this.functionClip.cureBtn,MouseEvent.MOUSE_DOWN,this.onClickIt);
         EventManager.attachEvent(this.functionClip.expBtn,MouseEvent.MOUSE_DOWN,this.onClickIt);
         EventManager.attachEvent(this.functionClip.takeClip,MouseEvent.MOUSE_DOWN,this.onClickIt);
         EventManager.attachEvent(this.functionClip.storeBtn,MouseEvent.MOUSE_DOWN,this.onClickIt);
      }
      
      private function onClickIt(evt:MouseEvent) : void
      {
         if(GameData.instance.playerData.giantId == GameData.instance.playerData.userId)
         {
            return;
         }
         evt.stopImmediatePropagation();
         this.functionClip.visible = false;
         switch(evt.currentTarget)
         {
            case this.fabaoClip:
               this.openTrumpInfoView();
               break;
            case this.functionClip.cureBtn:
               this.cureAllMonster();
               break;
            case this.functionClip.expBtn:
               this.openDisTributeView();
               break;
            case this.functionClip.takeClip:
               this.opeFabao();
               break;
            case this.functionClip.storeBtn:
               this.openStorage();
         }
      }
      
      private function openStorage() : void
      {
         if(!GameData.instance.playerData.isVip && GameData.instance.playerData.copyScene > 0 || Boolean(GameData.instance.playerData.bobOwner))
         {
            if(!GameData.instance.playerData.isVip && GameData.instance.playerData.copyScene > 0)
            {
               new Alert().showVip("只有vip玩家才能这里使用贝贝打开妖怪仓库");
            }
            return;
         }
         ApplicationFacade.getInstance().dispatch(EventConst.BOBSTATECLICK,{
            "url":"assets/module/MonsterStorageModule.swf",
            "xCoord":0,
            "yCoord":0
         });
      }
      
      private function openTrumpInfoView() : void
      {
         if(GameData.instance.playerData.copyScene == 1 || GameData.instance.playerData.copyScene == 2 || GameData.instance.playerData.bobOwner || GameData.instance.playerData.copyScene == 3)
         {
            return;
         }
         ApplicationFacade.getInstance().dispatch(EventConst.OPEN_CACHE_VIEW,{
            "body":this.params.userId,
            "showX":0,
            "showY":0,
            "params":this.params
         },null,getQualifiedClassName(TrumpInfoview));
         this.functionClip.visible = false;
      }
      
      private function cureAllMonster() : void
      {
         this.functionClip.visible = false;
         if(GameData.instance.playerData.isVip)
         {
            ApplicationFacade.getInstance().dispatch(EventConst.REQ_DOCTOR_SPIRIT);
         }
         else
         {
            new Alert().showSureOrCancel("你确定花50铜钱治疗所有妖怪吗?",this.closeHandler);
         }
      }
      
      private function closeHandler(str:String, data:Object) : void
      {
         if(str == "确定")
         {
            this.functionClip.visible = false;
            ApplicationFacade.getInstance().dispatch(EventConst.REQ_DOCTOR_SPIRIT);
         }
      }
      
      private function openDisTributeView() : void
      {
         if(!GameData.instance.playerData.isVip && GameData.instance.playerData.copyScene > 0 || Boolean(GameData.instance.playerData.bobOwner))
         {
            if(!GameData.instance.playerData.isVip && GameData.instance.playerData.copyScene > 0)
            {
               new Alert().showVip("只有vip玩家才能这里使用贝贝分配经验");
            }
            return;
         }
         this.functionClip.visible = false;
         ApplicationFacade.getInstance().dispatch(EventConst.OPEN_CACHE_VIEW,{
            "showX":200,
            "showY":100
         },null,getQualifiedClassName(DisExpView));
      }
      
      private function opeFabao() : void
      {
         /*
          * 反编译出错
          * 代码可能被加密
          * 提示：您可以尝试在“设置”中启用“反混淆代码”选项。
          * 错误类型: IndexOutOfBoundsException (Index -1 out of bounds for length 0)
          */
         throw new flash.errors.IllegalOperationError("由于错误未反编译");
      }
      
      private function onOverTrump(evt:MouseEvent) : void
      {
         this.functionClip.visible = true;
      }
      
      private function hideMenuClip(evt:MouseEvent) : void
      {
         if(this.functionClip != null)
         {
            this.functionClip.visible = false;
         }
      }
      
      private function onOutTrump(evt:MouseEvent) : void
      {
         this.functionClip.visible = false;
      }
      
      private function initToolTip() : void
      {
         ToolTip.BindDO(this.functionClip.cureBtn,"治疗所有妖怪");
         ToolTip.BindDO(this.functionClip.expBtn,"分配历练");
         ToolTip.BindDO(this.functionClip.takeClip,"");
         ToolTip.BindDO(this.functionClip.storeBtn,"妖怪仓库");
      }
      
      public function setTrump(params:Object) : void
      {
         if(params == null)
         {
            return;
         }
         this.params = params;
         this.changTrumpView();
         this.functionClip.takeClip.gotoAndStop(params.state);
         if(this.functionClip.takeClip.currentFrame == 1)
         {
            ToolTip.setDOInfo(this.functionClip.takeClip,"贝贝跟随");
         }
         else
         {
            ToolTip.setDOInfo(this.functionClip.takeClip,"回家休息");
         }
      }
      
      private function changTrumpView() : void
      {
         var url:String = null;
         var id:int = int(this.params.vipLevel);
         if(this.params.trumpAppearance > 0)
         {
            id = int(this.params.trumpAppearance);
            url = URLUtil.getSvnVer("assets/fabao/fabao" + id + ".swf");
         }
         else if(Boolean(this.params.isSupertrump))
         {
            url = URLUtil.getSvnVer("assets/fabao/fabaosuper.swf");
         }
         else if(id >= 1 && id <= 3)
         {
            url = URLUtil.getSvnVer("assets/fabao/fabao1.swf");
         }
         else if(id >= 4 && id <= 5)
         {
            url = URLUtil.getSvnVer("assets/fabao/fabao2.swf");
         }
         else if(id >= 6)
         {
            url = URLUtil.getSvnVer("assets/fabao/fabao3.swf");
         }
         else
         {
            url = URLUtil.getSvnVer("assets/fabao/fabao0.swf");
         }
         this.loader.load(new URLRequest(url));
      }
      
      public function move(path:AStarPath) : void
      {
         this.hideMenuClip(null);
         if(Boolean(this.fabaoClip))
         {
            try
            {
               ToolTip.LooseDO(this.fabaoClip);
            }
            catch(e:*)
            {
               ToolTip.LooseDO(functionClip.cureBtn);
               ToolTip.LooseDO(functionClip.expBtn);
               ToolTip.LooseDO(functionClip.takeClip);
               ToolTip.LooseDO(functionClip.storeBtn);
               ToolTip.LooseDO(functionClip.takeClip);
            }
         }
      }
      
      public function stop() : void
      {
         this.runner.stop();
      }
      
      override public function get sortY() : Number
      {
         return y + dymaicY;
      }
      
      private function addChild(disPlay:DisplayObject) : void
      {
         Sprite(ui).addChild(disPlay);
      }
      
      override protected function onTurnToDown() : void
      {
         if(this.fabaoClip != null)
         {
            if(this.fabaoClip.currentLabel != "rightDown")
            {
               this.fabaoClip.gotoAndStop("rightDown");
            }
         }
      }
      
      override protected function onTurnToLeft() : void
      {
         if(this.fabaoClip != null)
         {
            if(this.fabaoClip.currentLabel != "leftdown")
            {
               this.fabaoClip.gotoAndStop("leftdown");
            }
         }
      }
      
      override protected function onTurnToLeftDown() : void
      {
         if(this.fabaoClip != null)
         {
            if(this.fabaoClip.currentLabel != "leftdown")
            {
               this.fabaoClip.gotoAndStop("leftdown");
            }
         }
      }
      
      override protected function onTurnToLeftUp() : void
      {
         if(this.fabaoClip != null)
         {
            if(this.fabaoClip.currentLabel != "lefttop")
            {
               this.fabaoClip.gotoAndStop("lefttop");
            }
         }
      }
      
      override protected function onTurnToRight() : void
      {
         if(this.fabaoClip != null)
         {
            if(this.fabaoClip.currentLabel != "rightDown")
            {
               this.fabaoClip.gotoAndStop("rightDown");
            }
         }
      }
      
      override protected function onTurnToRightDown() : void
      {
         if(this.fabaoClip != null)
         {
            if(this.fabaoClip.currentLabel != "rightDown")
            {
               this.fabaoClip.gotoAndStop("rightDown");
            }
         }
      }
      
      override protected function onTurnToRightUp() : void
      {
         if(this.fabaoClip != null)
         {
            if(this.fabaoClip.currentLabel != "righttop")
            {
               this.fabaoClip.gotoAndStop("righttop");
            }
         }
      }
      
      override protected function onTurnToUp() : void
      {
         if(this.fabaoClip != null)
         {
            if(this.fabaoClip.currentLabel != "righttop")
            {
               this.fabaoClip.gotoAndStop("righttop");
            }
         }
      }
      
      private function removeChild(disPlay:DisplayObject) : void
      {
         if(disPlay != null)
         {
            if(Sprite(ui).contains(disPlay))
            {
               Sprite(ui).removeChild(disPlay);
               disPlay = null;
            }
         }
      }
      
      override public function dispos() : void
      {
         this.params = null;
         if(this.runner != null)
         {
            this.runner.stop();
         }
         this.runner = null;
         this.removeAllEvent();
         this.removeToolTip();
         if(this.functionClip != null)
         {
            this.functionClip.stop();
            if(Boolean(this.functionClip.parent))
            {
               this.functionClip.parent.removeChild(this.functionClip);
            }
            this.functionClip = null;
         }
         if(this.fabaoClip != null)
         {
            this.fabaoClip.stop();
            this.removeChild(this.fabaoClip);
            this.fabaoClip = null;
         }
         if(Boolean(ui))
         {
            if(ui.stage != null)
            {
               ui.stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.hideMenuClip);
            }
         }
         if(this.loader != null)
         {
            this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoadComplement);
            this.loader.unloadAndStop();
            this.loader = null;
         }
         super.dispos();
      }
      
      private function removeAllEvent() : void
      {
         if(this.fabaoClip != null)
         {
            EventManager.removeEvent(this.fabaoClip,MouseEvent.MOUSE_DOWN,this.onClickIt);
            EventManager.removeEvent(this.ui,MouseEvent.MOUSE_OVER,this.onOverTrump);
            EventManager.removeEvent(this.ui,MouseEvent.MOUSE_OUT,this.onOutTrump);
            if(this.functionClip != null)
            {
               EventManager.removeEvent(this.functionClip.cureBtn,MouseEvent.MOUSE_DOWN,this.onClickIt);
               EventManager.removeEvent(this.functionClip.expBtn,MouseEvent.MOUSE_DOWN,this.onClickIt);
               EventManager.removeEvent(this.functionClip.takeClip,MouseEvent.MOUSE_DOWN,this.onClickIt);
               EventManager.removeEvent(this.functionClip.storeBtn,MouseEvent.MOUSE_DOWN,this.onClickIt);
            }
         }
      }
      
      private function removeToolTip() : void
      {
         if(this.fabaoClip != null)
         {
            ToolTip.LooseDO(this.fabaoClip);
         }
         if(this.functionClip != null)
         {
            ToolTip.LooseDO(this.functionClip.cureBtn);
            ToolTip.LooseDO(this.functionClip.takeClip);
            ToolTip.LooseDO(this.functionClip.expBtn);
         }
      }
   }
}

