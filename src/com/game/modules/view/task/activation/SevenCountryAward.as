package com.game.modules.view.task.activation
{
   import com.game.util.AwardAlert;
   import com.game.util.HtmlUtil;
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.loading.GreenLoading;
   import com.publiccomponent.loading.Loading;
   import com.publiccomponent.loading.XMLLocator;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class SevenCountryAward extends Sprite
   {
      
      private var loading:Loading;
      
      private var mc:MovieClip;
      
      private var awardIndex:int = -1;
      
      private var sid:uint = 0;
      
      private var goodList:Array;
      
      public function SevenCountryAward()
      {
         super();
         this.goodList = [100003,100034,300028];
         this.loading = GreenLoading.loading;
         GreenLoading.loading.visible = true;
         this.loading.loadModule("正在加载奖励框...",URLUtil.getSvnVer("assets/material/sevencountryaward.swf"),this.onLoadComplete);
      }
      
      private function onLoadComplete(loader:Loader) : void
      {
         this.mc = loader.content as MovieClip;
         this.mc["good1"].gotoAndStop(1);
         this.mc["good2"].gotoAndStop(1);
         this.mc["good3"].gotoAndStop(1);
         loader.unloadAndStop();
         this.addChild(this.mc);
         this.mc.x = 0;
         this.mc.y = 0;
         if(this.awardIndex != -1)
         {
            this.init();
         }
      }
      
      private function initEvent() : void
      {
         if(this.mc != null)
         {
            this.mc.surebtn.addEventListener(MouseEvent.CLICK,this.onClickSure);
         }
      }
      
      private function removeEvent() : void
      {
         if(this.mc != null)
         {
            this.mc.surebtn.removeEventListener(MouseEvent.CLICK,this.onClickSure);
         }
      }
      
      private function onClickSure(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         this.removeEvent();
         if(this.mc != null && Boolean(this.mc.hasOwnProperty("good" + this.awardIndex)))
         {
            this.mc["good" + this.awardIndex].gotoAndStop(2);
            this.sid = setTimeout(this.timeOut,1000);
         }
      }
      
      private function timeOut() : void
      {
         if(this.sid != 0)
         {
            clearTimeout(this.sid);
         }
         this.sid = 0;
         if(this.goodList == null)
         {
            this.dispos();
            return;
         }
         if(this.awardIndex <= 0)
         {
            this.awardIndex = 1;
         }
         var xml:XML = XMLLocator.getInstance().getTool(this.goodList[this.awardIndex - 1]);
         if(xml == null)
         {
            xml = XMLLocator.getInstance().getTool(10003);
         }
         var str:String = xml.name.toString();
         new AwardAlert().showGoodsAward("assets/tool/" + this.goodList[this.awardIndex - 1] + ".swf",this.stage,"获得" + HtmlUtil.getHtmlText(12,"#FF0000",str),true,this.awardComplete);
      }
      
      private function awardComplete(param:Object = null) : void
      {
         this.dispos();
      }
      
      private function init() : void
      {
         GreenLoading.loading.visible = false;
         this.initEvent();
      }
      
      public function setData(param:Object) : void
      {
         GreenLoading.loading.visible = true;
         this.awardIndex = param.account;
         if(this.mc != null)
         {
            this.init();
         }
      }
      
      public function dispos() : void
      {
         if(this.sid != 0)
         {
            clearTimeout(this.sid);
         }
         this.sid = 0;
         if(this.mc != null)
         {
            this.mc["good1"].gotoAndStop(1);
            this.mc["good2"].gotoAndStop(1);
            this.mc["good3"].gotoAndStop(1);
         }
         this.removeEvent();
         this.awardIndex = -1;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

