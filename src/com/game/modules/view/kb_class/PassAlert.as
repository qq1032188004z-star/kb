package com.game.modules.view.kb_class
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.util.CacheUtil;
   import com.game.util.HLoaderSprite;
   import flash.events.MouseEvent;
   
   public class PassAlert extends HLoaderSprite
   {
      
      private var exp:int;
      
      public function PassAlert()
      {
         super();
      }
      
      override public function initParams(params:Object = null) : void
      {
         this.exp = params.exp;
         this.url = "assets/kbclass/passgame/pass_alert.swf";
      }
      
      override public function setShow() : void
      {
         bg.cacheAsBitmap = true;
         var i:int = 1;
         while(i <= 3)
         {
            bg["btn" + i].addEventListener(MouseEvent.CLICK,this.onbtn);
            i++;
         }
         bg.txt1.text = this.exp + "";
         bg.mc.gotoAndStop(KB_Class_Pass.Flag);
         if(KB_Class_Pass.Times == 1)
         {
            bg.mc.gotoAndStop(3);
            bg.btn3.x += 65;
            bg.btn2.x += 65;
            bg.btn3.mouseEnabled = true;
            bg.btn3.visible = true;
         }
         else
         {
            bg.btn3.mouseEnabled = false;
            bg.btn3.visible = false;
         }
      }
      
      private function onbtn(evt:MouseEvent) : void
      {
         if(bg.mc.currentFrame == 3 && evt.currentTarget.name == "btn3")
         {
            ApplicationFacade.getInstance().dispatch(EventConst.REQ_DENGLONG_INFO,{"param":1});
         }
         this.disport();
      }
      
      override public function disport() : void
      {
         var i:int = 1;
         while(i <= 3)
         {
            bg["btn" + i].removeEventListener(MouseEvent.CLICK,this.onbtn);
            i++;
         }
         if(Boolean(this.parent) && this.parent.contains(this))
         {
            this.parent.removeChild(this);
         }
         if(CacheUtil.pool[KB_Class_Pass] != null)
         {
            CacheUtil.pool[KB_Class_Pass]["disport"]();
         }
         super.disport();
      }
   }
}

