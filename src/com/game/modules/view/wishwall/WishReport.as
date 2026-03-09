package com.game.modules.view.wishwall
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.manager.EventManager;
   import com.game.util.ChractorFilter;
   import com.game.util.HLoaderSprite;
   import com.publiccomponent.alert.Alert;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class WishReport extends HLoaderSprite
   {
      
      public var param:Object = {};
      
      private const list:Array = ["使用不文明呢称","使用不文明用语","涉及隐私信息","传播谣言","有欺诈交易行为"];
      
      public function WishReport()
      {
         super();
      }
      
      public function init() : void
      {
         this.url = "assets/wishwall/wishReport.swf";
      }
      
      override public function setShow() : void
      {
         this.bg.cacheAsBitmap = true;
         EventManager.attachEvent(this,Event.ADDED_TO_STAGE,this.onAddToStage);
         this.onAddToStage(null);
      }
      
      override public function disport() : void
      {
         this.parent.removeChild(this);
         super.disport();
      }
      
      private function onAddToStage(evt:Event) : void
      {
         var i:int = 0;
         this.param.msg = "";
         EventManager.attachEvent(this,Event.REMOVED_FROM_STAGE,this.onRemoved);
         EventManager.attachEvent(bg["closeBtn"],MouseEvent.CLICK,this.onClose);
         EventManager.attachEvent(bg["sureBtn"],MouseEvent.CLICK,this.onSure);
         EventManager.attachEvent(bg["cancelBtn"],MouseEvent.CLICK,this.onCancel);
         for(i = 0; i < 5; i++)
         {
            bg["mc" + i].gotoAndStop(1);
            EventManager.attachEvent(bg["btn" + i],MouseEvent.CLICK,this.onBtn);
         }
      }
      
      private function onRemoved(evt:Event) : void
      {
         var i:int = 0;
         EventManager.removeEvent(this,Event.REMOVED_FROM_STAGE,this.onRemoved);
         EventManager.removeEvent(bg["closeBtn"],MouseEvent.CLICK,this.onClose);
         EventManager.removeEvent(bg["sureBtn"],MouseEvent.CLICK,this.onSure);
         EventManager.removeEvent(bg["cancelBtn"],MouseEvent.CLICK,this.onCancel);
         for(i = 0; i < 5; i++)
         {
            EventManager.removeEvent(bg["btn" + i],MouseEvent.CLICK,this.onBtn);
         }
      }
      
      private function onClose(evt:MouseEvent) : void
      {
         if(Boolean(this.parent) && this.parent.contains(this))
         {
            this.parent.removeChild(this);
         }
      }
      
      private function onSure(evt:MouseEvent) : void
      {
         if(bg["inputTxt"].text == "" || bg["inputTxt"].text == "请输入举报原因" || ChractorFilter.allSpace(bg["inputTxt"].text))
         {
            new Alert().showTwo("请选择或者输入举报原因！");
            return;
         }
         this.param.msg = "" + bg["inputTxt"].text;
         ApplicationFacade.getInstance().dispatch(EventConst.WISHSENDREPORT,this.param);
         this.onClose(null);
      }
      
      private function onCancel(evt:MouseEvent) : void
      {
         this.onClose(null);
      }
      
      private function onBtn(evt:MouseEvent) : void
      {
         var i:int = 0;
         for(i = 0; i < 5; i++)
         {
            bg["mc" + i].gotoAndStop(1);
         }
         var str:String = (evt.target.name as String).substr(3,1);
         bg["mc" + str].gotoAndStop(2);
         bg["inputTxt"].text = "" + this.list[str];
      }
   }
}

