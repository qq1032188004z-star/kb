package com.game.modules.view.gameexchange
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.modules.control.exchange.EnterDoorControl;
   import com.game.modules.view.gamehall.GameHallView;
   import com.game.util.CacheUtil;
   import com.game.util.HLoaderSprite;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.utils.getQualifiedClassName;
   
   public class EnterDoorView extends HLoaderSprite
   {
      
      private var mc:MovieClip;
      
      private var enterToGame:Boolean = false;
      
      public function EnterDoorView()
      {
         super();
         if(!ApplicationFacade.getInstance().hasViewLogic(EnterDoorControl.NAME))
         {
            ApplicationFacade.getInstance().registerViewLogic(new EnterDoorControl(this));
         }
      }
      
      override public function setShow() : void
      {
         this.mc = this.bg;
         if(this.mc.hasOwnProperty("okbtn"))
         {
            this.mc.okbtn.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDownOkbtn);
            this.mc.nobtn.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDownNobtn);
         }
         else
         {
            MovieClip(this.mc.getChildAt(0)).mcdoor.mcdoor.addFrameScript(70,this.overMcDoorHandler);
            MovieClip(this.mc.getChildAt(0)).mcdoor.mcdoor.gotoAndPlay(1);
         }
      }
      
      override public function initParams(params:Object = null) : void
      {
         this.enterToGame = params.enter;
      }
      
      private function onMouseDownOkbtn(event:MouseEvent) : void
      {
         this.closeWindow();
         ApplicationFacade.getInstance().dispatch(EventConst.OPEN_CACHE_VIEW,{
            "showX":0,
            "showY":0
         },null,getQualifiedClassName(GameExchange));
      }
      
      private function onMouseDownNobtn(event:MouseEvent) : void
      {
         this.closeWindow();
      }
      
      public function checkCoinBack(obj:Object) : void
      {
         if(int(obj) == 0)
         {
            this.url = "assets/material/enterhall.swf";
         }
         else
         {
            this.url = "assets/material/enterhallalert.swf";
         }
      }
      
      private function overMcDoorHandler() : void
      {
         MovieClip(this.mc.getChildAt(0)).mcdoor.mcdoor.gotoAndStop(70);
         this.closeWindow();
         ApplicationFacade.getInstance().dispatch(EventConst.CLEARUI);
         if(this.enterToGame)
         {
            ApplicationFacade.getInstance().dispatch(EventConst.OPEN_CACHE_VIEW,{
               "enter":true,
               "showX":0,
               "showY":-5,
               "onlineid":2000
            },null,getQualifiedClassName(GameHallView));
         }
         else
         {
            ApplicationFacade.getInstance().dispatch(EventConst.OPEN_CACHE_VIEW,{
               "showX":0,
               "showY":-5,
               "onlineid":2000
            },null,getQualifiedClassName(GameHallView));
         }
      }
      
      public function closeWindow() : void
      {
         if(Boolean(this.mc) && Boolean(this.mc.hasOwnProperty("okbtn")))
         {
            this.mc.okbtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDownOkbtn);
            this.mc.nobtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDownNobtn);
         }
         else if(Boolean(this.mc))
         {
            MovieClip(this.mc.getChildAt(0)).mcdoor.mcdoor.addFrameScript(70,null);
            MovieClip(this.mc.getChildAt(0)).mcdoor.mcdoor.gotoAndPlay(1);
         }
         if(this.parent != null)
         {
            if(this.parent.contains(this))
            {
               this.parent.removeChild(this);
            }
         }
         this.disport();
      }
      
      override public function disport() : void
      {
         CacheUtil.deleteObject(EnterDoorView);
         ApplicationFacade.getInstance().removeViewLogic(EnterDoorControl.NAME);
         this.mc = null;
         super.disport();
      }
   }
}

