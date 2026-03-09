package com.game.modules.view.task.activation
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.locators.GameData;
   import com.publiccomponent.loading.GreenLoading;
   import com.publiccomponent.loading.Hloader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class ChildrensDay extends Sprite
   {
      
      private var uiLoader:Hloader;
      
      private var mc:MovieClip;
      
      private var targetSceneList:Array;
      
      public function ChildrensDay()
      {
         super();
         GreenLoading.loading.visible = true;
         this.mouseEnabled = false;
         this.uiLoader = new Hloader("assets/material/summervacationlogin.swf");
         this.uiLoader.addEventListener(Event.COMPLETE,this.onLoadComplete);
      }
      
      private function onLoadComplete(evt:Event) : void
      {
         evt.stopImmediatePropagation();
         this.mc = this.uiLoader.content as MovieClip;
         this.addChild(this.mc);
         this.mc.x = 0;
         this.mc.y = 0;
         this.uiLoader.removeEventListener(Event.COMPLETE,this.onLoadComplete);
         if(this.targetSceneList != null && this.targetSceneList.length > 0)
         {
            this.initView();
         }
         GreenLoading.loading.visible = false;
      }
      
      private function initView() : void
      {
         this.mc.closebtn.addEventListener(MouseEvent.CLICK,this.onClickClose);
         this.mc.goto1.addEventListener(MouseEvent.CLICK,this.onClickGoto);
         this.mc.goto2.addEventListener(MouseEvent.CLICK,this.onClickGoto);
         this.mc.goto3.addEventListener(MouseEvent.CLICK,this.onClickGoto);
         this.mc.goto4.addEventListener(MouseEvent.CLICK,this.onClickGoto);
         this.mc.goto5.addEventListener(MouseEvent.CLICK,this.onClickGoto);
      }
      
      private function releaseView() : void
      {
         this.mc.closebtn.removeEventListener(MouseEvent.CLICK,this.onClickClose);
         this.mc.goto1.removeEventListener(MouseEvent.CLICK,this.onClickGoto);
         this.mc.goto2.removeEventListener(MouseEvent.CLICK,this.onClickGoto);
         this.mc.goto3.removeEventListener(MouseEvent.CLICK,this.onClickGoto);
         this.mc.goto4.removeEventListener(MouseEvent.CLICK,this.onClickGoto);
         this.mc.goto5.removeEventListener(MouseEvent.CLICK,this.onClickGoto);
      }
      
      private function onClickClose(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         this.disport();
      }
      
      private function onClickGoto(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         var str:String = evt.currentTarget.name;
         var index:int = this.getIndexOfName(str);
         index -= 1;
         if(this.targetSceneList != null && this.targetSceneList.length > index && index >= 0)
         {
            if(this.targetSceneList[index] == 1013)
            {
               ApplicationFacade.getInstance().dispatch(EventConst.ENTERSHENSHOU);
            }
            else
            {
               ApplicationFacade.getInstance().dispatch(EventConst.SENDUSERTOOTHERSCENE,this.targetSceneList[index]);
            }
            this.disport();
         }
      }
      
      private function onClickOpen(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         ApplicationFacade.getInstance().dispatch(EventConst.ENTER_FAMILY_BASE,GameData.instance.playerData.family_id);
      }
      
      private function getIndexOfName(str:String) : int
      {
         return int(str.charAt(str.length - 1));
      }
      
      public function setData() : void
      {
         this.targetSceneList = [2103,1009,1013,1012,1017];
         if(this.mc != null)
         {
            this.initView();
         }
      }
      
      public function disport() : void
      {
         this.releaseView();
         if(this.uiLoader != null)
         {
            this.uiLoader.removeEventListener(Event.COMPLETE,this.onLoadComplete);
            this.uiLoader.unloadAndStop();
            this.uiLoader = null;
         }
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

