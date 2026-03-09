package com.game.modules.view.item
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.locators.GameData;
   import com.publiccomponent.list.ItemRender;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol431")]
   public class RankingItem extends ItemRender
   {
      
      public var rankTxt:TextField;
      
      public var nameTxt:TextField;
      
      public var scoreTxt:TextField;
      
      public var bgClip:MovieClip;
      
      public var nameBg:MovieClip;
      
      public function RankingItem()
      {
         super();
         this.bgClip.gotoAndStop(1);
         this.rankTxt.mouseEnabled = false;
         this.scoreTxt.mouseEnabled = false;
         this.nameBg.gotoAndStop(1);
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoveFromStage);
         this.nameTxt.addEventListener(MouseEvent.ROLL_OVER,this.onMouseOver);
         this.nameTxt.addEventListener(MouseEvent.ROLL_OUT,this.onMouseOut);
         this.nameTxt.addEventListener(MouseEvent.CLICK,this.onMouseClick);
      }
      
      private function onMouseOver(evt:MouseEvent) : void
      {
         this.nameBg.gotoAndStop(2);
      }
      
      private function onMouseOut(evt:MouseEvent) : void
      {
         this.nameBg.gotoAndStop(1);
      }
      
      private function onMouseClick(evt:MouseEvent) : void
      {
         if(data.uid != GameData.instance.playerData.userId)
         {
            ApplicationFacade.getInstance().dispatch(EventConst.OPENPERSONINFOVIEW,{
               "userId":data.uid,
               "isOnline":0,
               "source":0,
               "userName":data.uname,
               "sex":1,
               "body":data
            });
         }
         else
         {
            ApplicationFacade.getInstance().dispatch(EventConst.OPENPERSONDETAILVIEW,{
               "userId":data.uid,
               "isOnline":0,
               "source":0,
               "userName":data.uname,
               "sex":GameData.instance.playerData.roleType & 1,
               "body":GameData.instance.playerData
            });
         }
      }
      
      override public function set data(params:Object) : void
      {
         if(params.hasOwnProperty("rank"))
         {
            this.rankTxt.text = params.rank;
         }
         if(params.hasOwnProperty("uid"))
         {
            if(params.uid == GameData.instance.playerData.userId)
            {
               this.bgClip.gotoAndStop(2);
               this.nameBg.visible = false;
            }
         }
         if(params.hasOwnProperty("uname"))
         {
            this.nameTxt.text = params.uname + "";
         }
         if(params.hasOwnProperty("score"))
         {
            this.scoreTxt.text = params.score;
         }
         super.data = params;
      }
      
      private function onRemoveFromStage(evt:Event) : void
      {
         this.removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemoveFromStage);
         this.nameTxt.removeEventListener(MouseEvent.ROLL_OVER,this.onMouseOver);
         this.nameTxt.removeEventListener(MouseEvent.ROLL_OUT,this.onMouseOut);
         this.nameTxt.removeEventListener(MouseEvent.CLICK,this.onMouseClick);
         super.closeListener();
      }
   }
}

