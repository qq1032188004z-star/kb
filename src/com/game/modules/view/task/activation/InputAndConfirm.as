package com.game.modules.view.task.activation
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.util.AwardAlert;
   import com.game.util.FloatAlert;
   import com.game.util.GameDynamicUI;
   import com.game.util.HtmlUtil;
   import com.publiccomponent.loading.GreenLoading;
   import com.publiccomponent.loading.XMLLocator;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   
   public class InputAndConfirm extends Sprite
   {
      
      private var _loader:Loader;
      
      private var _mc:MovieClip;
      
      public function InputAndConfirm()
      {
         super();
         this.graphics.beginFill(16777215,0);
         this.graphics.drawRect(0,0,970,570);
         this.graphics.endFill();
         this.mouseEnabled = false;
         this.cacheAsBitmap = true;
         GreenLoading.loading.visible = true;
         this._loader = new Loader();
         this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoadComplete);
         this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
         this._loader.load(new URLRequest("assets/material/activationcode.swf"));
      }
      
      private function onLoadComplete(evt:Event) : void
      {
         evt.stopImmediatePropagation();
         GreenLoading.loading.visible = false;
         this._mc = (this._loader.content as MovieClip).getChildAt(0) as MovieClip;
         this._mc.cacheAsBitmap = true;
         this._mc.stop();
         this.releaseLoader();
         this.addChild(this._mc);
         this._mc.x = 206;
         this._mc.y = 127;
         this._mc["sureBtn"].addEventListener(MouseEvent.CLICK,this.onMouseClickSure);
         this._mc["closebtn"].addEventListener(MouseEvent.CLICK,this.onMouseClickClose);
         this._mc["inputtf"].restrict = "A-Za-z0-9";
         this._mc["inputtf"].text = "input code: ";
         this._mc["inputtf"].addEventListener(FocusEvent.FOCUS_IN,this.onFocusInTF);
         this._mc["getAct"].addEventListener(MouseEvent.CLICK,this.onMouseClickGetAct);
      }
      
      private function onLoadError(evt:IOErrorEvent) : void
      {
         evt.stopImmediatePropagation();
         GreenLoading.loading.visible = false;
         this.releaseLoader();
         this.dispos();
      }
      
      private function releaseLoader() : void
      {
         if(this._loader == null)
         {
            return;
         }
         this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoadComplete);
         this._loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
         this._loader.unloadAndStop();
         this._loader = null;
      }
      
      private function onFocusInTF(evt:FocusEvent) : void
      {
         evt.stopImmediatePropagation();
         this._mc["inputtf"].text = "";
      }
      
      private function onMouseClickSure(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         if(this._mc["inputtf"].length != 16)
         {
            new FloatAlert().show(this.stage,380,400,"你输入的激活码无效哦！",5,300);
            return;
         }
         GameDynamicUI.addUI(this.stage,200,200,"loading");
         ApplicationFacade.getInstance().dispatch(EventConst.POPUP_WINDOW_TO_CONTROL,this._mc["inputtf"].text);
      }
      
      private function onMouseClickClose(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         this.dispos();
      }
      
      private function getMonsterBack(param:Object = null) : void
      {
         this.dispos();
      }
      
      private function onMouseClickGetAct(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         navigateToURL(new URLRequest("http://huodong.4399.com/kabuxiyou/jihuoma/"),"_blank");
      }
      
      public function show() : void
      {
         if(this._mc != null)
         {
            this._mc["sureBtn"].addEventListener(MouseEvent.CLICK,this.onMouseClickSure);
            this._mc["closebtn"].addEventListener(MouseEvent.CLICK,this.onMouseClickClose);
            this._mc["inputtf"].addEventListener(FocusEvent.FOCUS_IN,this.onFocusInTF);
            this._mc["getAct"].addEventListener(MouseEvent.CLICK,this.onMouseClickGetAct);
         }
      }
      
      public function showTips(type:int, monster:int) : void
      {
         var xml:XML = null;
         GameDynamicUI.removeUI("loading");
         switch(type)
         {
            case 1:
               xml = new XML();
               xml = XMLLocator.getInstance().getSprited(int(monster));
               new AwardAlert().showMonsterAward("assets/monsterimg/" + monster + ".swf",this.stage,"获得" + HtmlUtil.getHtmlText(12,"#FF0000",xml.name.toString()),false,this.getMonsterBack);
               break;
            case 0:
               new FloatAlert().show(this.stage,380,400,"激活码已被使用，请重新输入。",5,300);
               break;
            case -1:
               new FloatAlert().show(this.stage,380,400,"激活码不存在，请重新输入。",5,300);
               break;
            case -2:
               new FloatAlert().show(this.stage,380,400,"你的妖怪等级还未达到30级，不能兑换奖励，赶快去练级吧！",5,300);
               break;
            case -3:
               new FloatAlert().show(this.stage,380,400,"你已经获得奖励了，不能再兑换奖励！",5,300);
               break;
            case -4:
               new FloatAlert().show(this.stage,380,400,"亲爱的小卡布，你今天的激活次数已满，明天才能继续激活了哦！",5,300);
         }
      }
      
      public function dispos() : void
      {
         if(this._mc == null)
         {
            return;
         }
         this._mc["inputtf"].text = "input code: ";
         this._mc["sureBtn"].removeEventListener(MouseEvent.CLICK,this.onMouseClickSure);
         this._mc["closebtn"].removeEventListener(MouseEvent.CLICK,this.onMouseClickClose);
         this._mc["inputtf"].removeEventListener(FocusEvent.FOCUS_IN,this.onFocusInTF);
         this._mc["getAct"].removeEventListener(MouseEvent.CLICK,this.onMouseClickGetAct);
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

