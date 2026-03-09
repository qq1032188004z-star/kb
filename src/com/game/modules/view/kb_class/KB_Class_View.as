package com.game.modules.view.kb_class
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.locators.GameData;
   import com.game.modules.view.gamehall.GameHallView;
   import com.game.util.CacheUtil;
   import com.game.util.HLoaderSprite;
   import com.publiccomponent.loading.GreenLoading;
   import flash.events.MouseEvent;
   import flash.net.URLVariables;
   import flash.utils.getQualifiedClassName;
   import phpcon.PhpConnection;
   import phpcon.PhpEvent;
   import phpcon.PhpEventConst;
   
   public class KB_Class_View extends HLoaderSprite
   {
      
      private var type:int = 0;
      
      public function KB_Class_View()
      {
         GreenLoading.loading.visible = true;
         super();
         this.url = "assets/kbclass/passgame/home.swf";
      }
      
      override public function setShow() : void
      {
         bg.cacheAsBitmap = true;
         bg.btn0.addEventListener(MouseEvent.CLICK,this.on_btn0);
         bg.btn1.addEventListener(MouseEvent.CLICK,this.on_btn1);
         bg.btn2.addEventListener(MouseEvent.CLICK,this.on_btn2);
         bg.btn3.addEventListener(MouseEvent.CLICK,this.on_btn3);
         bg.btn4.addEventListener(MouseEvent.CLICK,this.on_btn4);
         PhpConnection.instance().addEventListener(PhpEventConst.FIRST_QUESETION,this.onPhpBack);
         GreenLoading.loading.visible = false;
      }
      
      private function on_btn0(evt:MouseEvent) : void
      {
         this.disport();
      }
      
      private function on_btn1(evt:MouseEvent) : void
      {
         this.type = 1;
         this.getData();
      }
      
      private function on_btn2(evt:MouseEvent) : void
      {
         this.type = 2;
         this.getData();
      }
      
      private function on_btn3(evt:MouseEvent) : void
      {
         this.type = 3;
         this.getData();
      }
      
      private function getData() : void
      {
         var urlvar:URLVariables = new URLVariables();
         urlvar.uid = GameData.instance.playerData.userId;
         urlvar.type = this.type;
         urlvar.selectType = 1;
         PhpConnection.instance().getdata("knowledge/question.php",urlvar);
      }
      
      private function onPhpBack(evt:PhpEvent) : void
      {
         var body:Object = {};
         body.data = evt.data;
         body.showX = 0;
         body.showY = 0;
         ApplicationFacade.getInstance().dispatch(EventConst.JUSTSENDTOSERVER,{"type":1});
         ApplicationFacade.getInstance().dispatch(EventConst.OPEN_CACHE_VIEW,body,null,getQualifiedClassName(KB_Class_Choose));
         this.disport();
      }
      
      private function on_btn4(evt:MouseEvent) : void
      {
         ApplicationFacade.getInstance().dispatch(EventConst.OPEN_CACHE_VIEW,{
            "showX":0,
            "showY":-5,
            "onlineid":2100
         },null,getQualifiedClassName(GameHallView));
         this.disport();
      }
      
      override public function disport() : void
      {
         bg.btn0.removeEventListener(MouseEvent.CLICK,this.on_btn0);
         bg.btn1.removeEventListener(MouseEvent.CLICK,this.on_btn1);
         bg.btn2.removeEventListener(MouseEvent.CLICK,this.on_btn2);
         bg.btn3.removeEventListener(MouseEvent.CLICK,this.on_btn3);
         bg.btn4.removeEventListener(MouseEvent.CLICK,this.on_btn4);
         PhpConnection.instance().removeEventListener(PhpEventConst.FIRST_QUESETION,this.onPhpBack);
         CacheUtil.deleteObject(KB_Class_View);
         if(Boolean(this.parent) && this.parent.contains(this))
         {
            this.parent.removeChild(this);
         }
         super.disport();
      }
   }
}

