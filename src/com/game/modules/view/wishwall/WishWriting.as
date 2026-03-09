package com.game.modules.view.wishwall
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.locators.GameData;
   import com.game.manager.EventManager;
   import com.game.util.ChatUtil;
   import com.game.util.ChractorFilter;
   import com.game.util.ColorUtil;
   import com.game.util.HLoaderSprite;
   import com.publiccomponent.alert.Alert;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   
   public class WishWriting extends HLoaderSprite
   {
      
      private var body:Object;
      
      private var tid:int;
      
      private var date:Date;
      
      public function WishWriting()
      {
         super();
      }
      
      public function init() : void
      {
         this.body = {};
         this.url = "assets/wishwall/wishWriting.swf";
      }
      
      override public function setShow() : void
      {
         var i:int = 0;
         this.bg.cacheAsBitmap = true;
         bg["nameTxt"].text = "许愿者：" + GameData.instance.playerData.userName;
         this.tid = setInterval(this.loopCount,1000);
         EventManager.attachEvent(bg["contentTxt"],MouseEvent.MOUSE_DOWN,this.onTxt);
         EventManager.attachEvent(bg["sureBtn"],MouseEvent.MOUSE_DOWN,this.onSure);
         EventManager.attachEvent(bg["cancelBtn"],MouseEvent.MOUSE_DOWN,this.onCancel);
         EventManager.attachEvent(bg["btn01"],MouseEvent.MOUSE_DOWN,this.onShare);
         EventManager.attachEvent(bg["btn02"],MouseEvent.MOUSE_DOWN,this.onSecret);
         EventManager.attachEvent(bg["lookBtn"],MouseEvent.MOUSE_DOWN,this.onLook);
         for(i = 0; i < 5; i++)
         {
            EventManager.attachEvent(bg["color" + i],MouseEvent.MOUSE_DOWN,this.onColor);
            EventManager.attachEvent(bg["form" + i],MouseEvent.MOUSE_DOWN,this.onForm);
            EventManager.attachEvent(bg["deco" + i],MouseEvent.MOUSE_DOWN,this.onDecorate);
         }
         this.onShare(null);
         this.bg["color0"].filters = ColorUtil.setGrowFilter(16711680);
         this.body.color = 0;
         this.bg["form0"].filters = ColorUtil.setGrowFilter(16711680);
         this.body.form = 0;
         this.bg["deco0"].filters = ColorUtil.setGrowFilter(16711680);
         this.body.deco = 0;
         this.body.status = 1;
         this.body.content = "" + bg["contentTxt"].text;
         this.body.uname = GameData.instance.playerData.userName;
      }
      
      private function loopCount() : void
      {
         this.date = new Date();
         bg["timeTxt"].text = "" + this.date.fullYear + "/" + (this.date.month + 1) + "/" + this.date.date + "/" + this.date.hours + ":" + this.date.minutes + ":" + this.date.seconds;
      }
      
      override public function disport() : void
      {
         var i:int = 0;
         clearInterval(this.tid);
         EventManager.removeEvent(bg["contentTxt"],MouseEvent.MOUSE_DOWN,this.onTxt);
         EventManager.removeEvent(bg["sureBtn"],MouseEvent.MOUSE_DOWN,this.onSure);
         EventManager.removeEvent(bg["cancelBtn"],MouseEvent.MOUSE_DOWN,this.onCancel);
         EventManager.removeEvent(bg["btn01"],MouseEvent.MOUSE_DOWN,this.onShare);
         EventManager.removeEvent(bg["btn02"],MouseEvent.MOUSE_DOWN,this.onSecret);
         EventManager.removeEvent(bg["lookBtn"],MouseEvent.MOUSE_DOWN,this.onLook);
         for(i = 0; i < 5; i++)
         {
            EventManager.removeEvent(bg["color" + i],MouseEvent.MOUSE_DOWN,this.onColor);
            EventManager.removeEvent(bg["form" + i],MouseEvent.MOUSE_DOWN,this.onForm);
            EventManager.removeEvent(bg["deco" + i],MouseEvent.MOUSE_DOWN,this.onDecorate);
         }
         this.date = null;
         if(Boolean(this.parent) && this.parent.contains(this))
         {
            this.parent.removeChild(this);
         }
         super.disport();
      }
      
      private function onTxt(evt:MouseEvent) : void
      {
         EventManager.removeEvent(bg["contentTxt"],MouseEvent.MOUSE_DOWN,this.onTxt);
         bg["contentTxt"].text = "";
      }
      
      private function onSure(evt:MouseEvent) : void
      {
         this.body.content = bg["contentTxt"].text;
         this.body.time = this.date.time;
         if(GameData.instance.playerData.coin < 40)
         {
            new Alert().showTwo("你的铜钱不够许一次愿哦~");
         }
         else if(ChractorFilter.allSpace(bg["contentTxt"].text) == "")
         {
            new Alert().showTwo("愿望不能为空！");
         }
         else if(!this.body.hasOwnProperty("content") || this.body.content == "请在此处写上你的愿望或祝福" || this.body.content == "")
         {
            new Alert().showTwo("你还没写愿望呢！");
         }
         else if(!this.body.hasOwnProperty("share"))
         {
            new Alert().showTwo("请选择与大家分享还是秘密！");
         }
         else if(!this.body.hasOwnProperty("color"))
         {
            new Alert().showTwo("请选择许愿纸的背景颜色！");
         }
         else if(!this.body.hasOwnProperty("form"))
         {
            new Alert().showTwo("请选择许愿纸的形状！");
         }
         else if(!this.body.hasOwnProperty("deco"))
         {
            new Alert().showTwo("请选择许愿纸的装饰！");
         }
         else if(ChatUtil.isOpenChat())
         {
            ChatUtil.onCompanyCheck(bg["contentTxt"].text,this.onCompanyCheckHandler,1);
         }
      }
      
      private function onCancel(evt:MouseEvent) : void
      {
         this.disport();
      }
      
      private function onColor(evt:MouseEvent) : void
      {
         var i:int = 0;
         for(i = 0; i < 5; i++)
         {
            bg["color" + i].filters = [];
         }
         (evt.target as SimpleButton).filters = ColorUtil.setGrowFilter(16711680);
         this.body.color = (evt.target as SimpleButton).name.substr(5,1);
      }
      
      private function onForm(evt:MouseEvent) : void
      {
         var i:int = 0;
         for(i = 0; i < 5; i++)
         {
            bg["form" + i].filters = [];
         }
         (evt.target as SimpleButton).filters = ColorUtil.setGrowFilter(16711680);
         this.body.form = (evt.target as SimpleButton).name.substr(4,1);
      }
      
      private function onDecorate(evt:MouseEvent) : void
      {
         var i:int = 0;
         for(i = 0; i < 5; i++)
         {
            bg["deco" + i].filters = [];
         }
         (evt.target as SimpleButton).filters = ColorUtil.setGrowFilter(16711680);
         this.body.deco = (evt.target as SimpleButton).name.substr(4,1);
      }
      
      private function onShare(evt:MouseEvent) : void
      {
         bg["btn0"].gotoAndStop(2);
         bg["btn1"].gotoAndStop(1);
         this.body.share = 1;
      }
      
      private function onSecret(evt:MouseEvent) : void
      {
         bg["btn0"].gotoAndStop(1);
         bg["btn1"].gotoAndStop(2);
         this.body.share = 0;
      }
      
      private function onLook(evt:MouseEvent) : void
      {
         if(ChatUtil.isOpenChat())
         {
            ChatUtil.onCompanyCheck(bg["contentTxt"].text,this.onCompanyCheckHandler,0);
         }
      }
      
      private function onCompanyCheckHandler(key:String, con:String, other:Object) : void
      {
         var preview:WishPaperPreview = null;
         switch(int(other))
         {
            case 0:
               this.body.content = con;
               preview = new WishPaperPreview(this.body);
               preview.show(this.stage,0,0);
               break;
            case 1:
               this.body.content = con;
               EventManager.removeEvent(bg["sureBtn"],MouseEvent.MOUSE_DOWN,this.onSure);
               ApplicationFacade.getInstance().dispatch(EventConst.REQMAKEAWISH,this.body);
               this.disport();
         }
      }
   }
}

