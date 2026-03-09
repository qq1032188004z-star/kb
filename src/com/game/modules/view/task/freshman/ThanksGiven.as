package com.game.modules.view.task.freshman
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.util.AwardAlert;
   import com.game.util.HtmlUtil;
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.loading.GreenLoading;
   import com.publiccomponent.loading.Loading;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class ThanksGiven extends Sprite
   {
      
      private var mc:MovieClip;
      
      private var loading:Loading;
      
      public function ThanksGiven()
      {
         super();
         this.graphics.beginFill(0,0);
         this.graphics.drawRect(-1000,-1000,2000,2000);
         this.graphics.endFill();
         this.loading = GreenLoading.loading;
         this.loading.visible = true;
         this.loading.setCloseBtnShow(false);
         this.loading.loadModule("正在加载感恩活动...",URLUtil.getSvnVer("assets/material/thanksgiven.swf"),this.onLoadComplete);
      }
      
      private function onLoadComplete(display:Loader) : void
      {
         this.mc = display.content as MovieClip;
         this.loading.visible = false;
         this.addChild(this.mc);
         this.mc.accept.addEventListener(MouseEvent.CLICK,this.onClickAccept);
      }
      
      private function onClickAccept(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         this.mc.accept.removeEventListener(MouseEvent.CLICK,this.onClickAccept);
         new AwardAlert().showGoodsAward("assets/tool/100010.swf",this.stage,"获得 " + HtmlUtil.getHtmlText(12,"#FF0000","3个小型法力药剂"),true,this.clickOver);
         new AwardAlert().showGoodsAward("assets/tool/100008.swf",this.stage,"获得 " + HtmlUtil.getHtmlText(12,"#FF0000","5个小金创药"),true);
         new AwardAlert().showGoodsAward("assets/tool/100001.swf",this.stage,"获得 " + HtmlUtil.getHtmlText(12,"#FF0000","3个普通葫芦"),true);
         new AwardAlert().showGoodsAward("assets/tool/300028.swf",this.stage,"获得 " + HtmlUtil.getHtmlText(12,"#FF0000","5瓶天地灵气"),true);
         new AwardAlert().showMoneyAward(1000,this.stage);
      }
      
      private function clickOver(param:Object = null) : void
      {
         ApplicationFacade.getInstance().dispatch(EventConst.ACTIVE_TASK_BY_DAILY_TASK,{
            "type":3,
            "taskID":6004001,
            "actionID":3
         });
         this.dispos();
      }
      
      public function dispos() : void
      {
         this.graphics.clear();
         if(this.mc != null)
         {
            if(Boolean(this.mc.accept.hasEventListener(MouseEvent.CLICK)))
            {
               this.mc.accept.removeEventListener(MouseEvent.CLICK,this.onClickAccept);
            }
            this.removeChild(this.mc);
         }
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

