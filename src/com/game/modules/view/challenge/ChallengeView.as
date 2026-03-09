package com.game.modules.view.challenge
{
   import com.core.observer.MessageEvent;
   import com.game.facade.ApplicationFacade;
   import com.game.locators.GameData;
   import com.game.modules.control.challenge.ChallengeControl;
   import com.game.util.CacheUtil;
   import com.game.util.HLoaderSprite;
   import com.publiccomponent.list.TileList;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class ChallengeView extends HLoaderSprite
   {
      
      public static const STARTCHA:String = "startcha";
      
      private var challegeMc:MovieClip;
      
      private var readyMc:MovieClip;
      
      private var gamelist:TileList;
      
      private var temploader:Loader;
      
      public var gameArr:Array = [];
      
      private var countPage:int;
      
      private var chaPk:ChallengePkView;
      
      public function ChallengeView()
      {
         super();
         this.url = "assets/material/challenge.swf";
      }
      
      override public function setShow() : void
      {
         this.challegeMc = bg;
         this.challegeMc.cacheAsBitmap = true;
         this.challegeMc.yinNum.text = GameData.instance.playerData.littlegameRcore;
         this.addChild(this.challegeMc);
         this.challegeMc.closeBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.closeWindows);
         this.challegeMc.lastBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.lastPageClick);
         this.challegeMc.nextBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.nextPageClick);
         this.gamelist = new TileList(5,80);
         this.gamelist.build(1,7,274,32,5,5,ChanllengeItem);
         this.gamelist.addEventListener("challegeclick",this.startChallege,true);
         this.addChild(this.gamelist);
         this.setListData();
         ApplicationFacade.getInstance().registerViewLogic(new ChallengeControl(this));
      }
      
      private function setListData() : void
      {
         if(this.gameArr.length % 7 == 0)
         {
            this.countPage = this.gameArr.length / 7;
         }
         else
         {
            this.countPage = this.gameArr.length / 7 + 1;
         }
         this.challegeMc.countTxt.text = this.countPage;
         if(this.gameArr.length < 7)
         {
            this.challegeMc.nextBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.nextPageClick);
            this.gamelist.dataProvider = this.gameArr;
         }
         else
         {
            this.gamelist.dataProvider = this.gameArr.slice(0,7);
         }
      }
      
      private function lastPageClick(evt:Event) : void
      {
         var tempint:int = int(this.challegeMc.currentTxt.text);
         if(tempint > 1)
         {
            this.challegeMc.currentTxt.text = --tempint;
            this.gamelist.dataProvider = this.gameArr.slice((tempint - 1) * 7,tempint * 7);
         }
      }
      
      private function nextPageClick(evt:Event) : void
      {
         var page:int = 0;
         if(int(this.challegeMc.currentTxt.text) < int(this.challegeMc.countTxt.text))
         {
            this.challegeMc.currentTxt.text = int(this.challegeMc.currentTxt.text) + 1;
            page = int(this.challegeMc.currentTxt.text);
            if(page * 7 > this.gameArr.length)
            {
               this.gamelist.dataProvider = this.gameArr.slice((page - 1) * 7);
            }
            else
            {
               this.gamelist.dataProvider = this.gameArr.slice((page - 1) * 7,page * 7);
            }
         }
      }
      
      private function startChallege(evt:MessageEvent) : void
      {
         this.chaPk = new ChallengePkView();
         this.chaPk.obj = evt.body;
         this.addChild(this.chaPk);
         this.chaPk.x = -440;
         this.chaPk.y = -70;
      }
      
      public function closeWindows(evt:Event = null) : void
      {
         this.disport();
      }
      
      override public function disport() : void
      {
         ApplicationFacade.getInstance().removeViewLogic(ChallengeControl.name);
         CacheUtil.deleteObject(ChallengeView);
         super.disport();
      }
   }
}

