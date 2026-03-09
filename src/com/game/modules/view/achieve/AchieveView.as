package com.game.modules.view.achieve
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.modules.control.achieve.AchieveControl;
   import com.game.util.CacheUtil;
   import com.game.util.HLoaderSprite;
   import flash.events.Event;
   import org.green.server.data.ByteArray;
   
   public class AchieveView extends HLoaderSprite
   {
      
      public var id:int;
      
      private var sex:int;
      
      public var ba:ByteArray;
      
      public function AchieveView()
      {
         super();
      }
      
      override public function initParams(params:Object = null) : void
      {
         if(params.hasOwnProperty("id"))
         {
            this.id = int(params.id);
         }
         else
         {
            this.id = 0;
         }
         if(params.hasOwnProperty("sex"))
         {
            this.sex = int(params.sex);
         }
         else
         {
            this.sex = -1;
         }
         if(ApplicationFacade.getInstance().hasViewLogic(AchieveControl.NAME))
         {
            this.disport();
            return;
         }
         ApplicationFacade.getInstance().registerViewLogic(new AchieveControl(this));
      }
      
      public function startload() : void
      {
         this.url = "assets/achieve/Achieve.swf";
      }
      
      override public function setShow() : void
      {
         bg.cacheAsBitmap = true;
         this.init(this.ba);
      }
      
      private function init(ba:ByteArray) : void
      {
         bg.addEventListener(EventConst.ACHIEVEMENT_REQ_AWARD_GET_ONE,this.onReqGetAward);
         bg.addEventListener(EventConst.ACHIEVEMENT_REQ_INFO_ONE,this.onReqAchieveInfo);
         bg["initdata"](ba,this.sex,this.id);
      }
      
      public function achievementAwardInfoBack(msg:Object) : void
      {
         if(bg)
         {
            bg["updateAwardInfo"](msg);
         }
      }
      
      public function achievementAwardGetBack(msg:Object) : void
      {
         if(bg)
         {
            bg["getAchieveAwardBack"](msg);
         }
      }
      
      private function onReqAchieveInfo(evt:Event) : void
      {
         dispatchEvent(new Event(EventConst.ACHIEVEMENT_AWARD_REQ_INFO));
      }
      
      private function onReqGetAward(evt:Event) : void
      {
         dispatchEvent(new Event(EventConst.ACHIEVEMENT_REQ_AWARD_GET_TWO));
      }
      
      override public function disport() : void
      {
         this.graphics.clear();
         if(bg)
         {
            bg.removeEventListener(EventConst.ACHIEVEMENT_REQ_AWARD_GET_ONE,this.onReqGetAward);
         }
         this.ba = null;
         CacheUtil.deleteObject(AchieveView);
         ApplicationFacade.getInstance().removeViewLogic(AchieveControl.NAME);
         super.disport();
      }
   }
}

