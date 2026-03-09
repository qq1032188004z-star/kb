package com.game.modules.view.kb_class
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.util.CacheUtil;
   import com.game.util.HLoaderSprite;
   import com.publiccomponent.alert.Alert;
   import com.publiccomponent.loading.GreenLoading;
   import flash.events.MouseEvent;
   import flash.utils.getQualifiedClassName;
   
   public class KB_Class_Choose extends HLoaderSprite
   {
      
      public var data:Object;
      
      public function KB_Class_Choose()
      {
         super();
      }
      
      override public function initParams(params:Object = null) : void
      {
         if(params == null)
         {
            return;
         }
         this.data = params.data;
         GreenLoading.loading.visible = true;
         this.url = "assets/kbclass/passgame/choose.swf";
      }
      
      override public function setShow() : void
      {
         bg.cacheAsBitmap = true;
         bg.btn1.addEventListener(MouseEvent.CLICK,this.on_btn1);
         bg.btn2.addEventListener(MouseEvent.CLICK,this.on_btn2);
         bg.btn3.addEventListener(MouseEvent.CLICK,this.on_btn3);
         bg.mc0.gotoAndStop(1);
         if(this.data.list == null)
         {
            this.disport();
            GreenLoading.loading.visible = false;
            return;
         }
         bg.txt1.text = "" + this.data.list[0].question;
         GreenLoading.loading.visible = false;
      }
      
      private function on_btn1(evt:MouseEvent) : void
      {
         this.disport();
      }
      
      private function on_btn2(evt:MouseEvent) : void
      {
         if(this.data.done >= 5)
         {
            new Alert().showOne("你今天已经闯关五次了，明天再来吧。");
            return;
         }
         this.data.done = int(this.data.done) + 1;
         ApplicationFacade.getInstance().dispatch(EventConst.OPEN_CACHE_VIEW,this.data,null,getQualifiedClassName(KB_Class_Pass));
         this.disport();
      }
      
      private function on_btn3(evt:MouseEvent) : void
      {
         ApplicationFacade.getInstance().dispatch(EventConst.OPEN_CACHE_VIEW,this.data,null,getQualifiedClassName(KB_Class_Submit));
         this.disport();
      }
      
      override public function disport() : void
      {
         bg.btn1.removeEventListener(MouseEvent.CLICK,this.on_btn1);
         bg.btn2.removeEventListener(MouseEvent.CLICK,this.on_btn2);
         bg.btn3.removeEventListener(MouseEvent.CLICK,this.on_btn3);
         CacheUtil.deleteObject(KB_Class_Choose);
         if(Boolean(this.parent) && this.parent.contains(this))
         {
            this.parent.removeChild(this);
         }
         super.disport();
      }
   }
}

