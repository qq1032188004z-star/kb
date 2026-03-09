package com.game.modules.view.trump
{
   import com.core.observer.MessageEvent;
   import com.game.facade.ApplicationFacade;
   import com.game.locators.GameData;
   import com.game.manager.EventManager;
   import com.game.modules.control.trump.TrumpEvent;
   import com.game.modules.control.trump.TrumpTrainControl;
   import com.game.util.CacheUtil;
   import com.game.util.HLoaderSprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class TrumpTrainningView extends HLoaderSprite
   {
      
      public static const OPENMONSTERLISTVIEW:String = "openmonsterlistview";
      
      public static const OPENTRIPODVIEW:String = "opentripodview";
      
      public static const OPENGONGLVE:String = "opengonglve";
      
      public var monsters:Array;
      
      public function TrumpTrainningView()
      {
         super();
         ApplicationFacade.getInstance().registerViewLogic(new TrumpTrainControl(this));
      }
      
      override public function initParams(params:Object = null) : void
      {
         this.monsters = params.mlist;
         this.url = "assets/fabao/trumptrainingview.swf";
      }
      
      override public function setShow() : void
      {
         var maxCount:int = 0;
         var i:int = 0;
         var monster:Object = null;
         var item2:TrumpTrainingItem = null;
         var item3:TrumpTrainingItem = null;
         var item1:TrumpTrainingItem = null;
         bg.bg.cacheAsBitmap = true;
         var vipList:Array = [2,3,3,4,4,5,5];
         if(GameData.instance.playerData.isSupertrump)
         {
            maxCount = 6;
         }
         else
         {
            maxCount = int(vipList[GameData.instance.playerData.vipLevel]);
         }
         var len:int = int(this.monsters.length);
         for(i = 0; i < 6; i++)
         {
            if(i < len)
            {
               monster = this.monsters[i];
               monster.trainId = i;
               if(monster.time > 0)
               {
                  monster.frame = 2;
                  item2 = new TrumpTrainingItem(monster);
                  item2.show(this,250 + (i & 1) * 335,50 + 97 * (int(i / 2) + 1));
                  item2.addEventListener(TrumpEvent.TRAINGETBACKMONSTER,this.onStopOrGet);
               }
               else
               {
                  monster.frame = 3;
                  item3 = new TrumpTrainingItem(monster);
                  item3.show(this,250 + (i & 1) * 335,50 + 97 * (int(i / 2) + 1));
                  item3.addEventListener(TrumpEvent.TRAINGETBACKMONSTER,this.onStopOrGet);
               }
            }
            else if(i <= maxCount - 1)
            {
               item1 = new TrumpTrainingItem({"frame":1});
               item1.show(this,250 + (i & 1) * 335,50 + 97 * (int(i / 2) + 1));
               item1.addEventListener(TrumpTrainningView.OPENMONSTERLISTVIEW,this.onMonsters);
               item1.addEventListener(TrumpTrainningView.OPENTRIPODVIEW,this.onTripod);
            }
            else
            {
               new TrumpTrainingItem({"frame":4}).show(this,250 + (i & 1) * 335,50 + 97 * (int(i / 2) + 1));
            }
         }
         bg.txt0.htmlText = "你还可以训练" + (maxCount - len) + "只妖怪";
         if(maxCount <= len)
         {
            bg.txt0.htmlText = "你还可以训练0只妖怪";
         }
         EventManager.attachEvent(bg.btn0,MouseEvent.CLICK,this.on_btn0);
         EventManager.attachEvent(bg.btn1,MouseEvent.CLICK,this.on_btn1);
      }
      
      private function on_btn0(evt:MouseEvent) : void
      {
         this.disport();
      }
      
      private function on_btn1(evt:MouseEvent) : void
      {
         this.dispatchEvent(new Event(TrumpTrainningView.OPENGONGLVE));
      }
      
      private function onMonsters(evt:Event) : void
      {
         this.dispatchEvent(new Event(TrumpTrainningView.OPENMONSTERLISTVIEW));
      }
      
      private function onTripod(evt:Event) : void
      {
         this.dispatchEvent(new Event(TrumpTrainningView.OPENTRIPODVIEW));
      }
      
      private function onStopOrGet(evt:MessageEvent) : void
      {
         this.dispatchEvent(new MessageEvent(TrumpEvent.TRAINGETBACKMONSTER,{"trainId":evt.body}));
      }
      
      override public function disport() : void
      {
         var i:int = 0;
         var item:TrumpTrainingItem = null;
         if(bg == null)
         {
            return;
         }
         for(i = numChildren - 1; i > 0; i--)
         {
            item = this.getChildAt(i) as TrumpTrainingItem;
            if(Boolean(item))
            {
               item.removeEventListener(TrumpTrainningView.OPENMONSTERLISTVIEW,this.onMonsters);
               item.removeEventListener(TrumpTrainningView.OPENTRIPODVIEW,this.onTripod);
               item.removeEventListener(TrumpEvent.TRAINGETBACKMONSTER,this.onStopOrGet);
               item.disport();
            }
         }
         EventManager.removeEvent(bg.btn0,MouseEvent.CLICK,this.on_btn0);
         EventManager.removeEvent(bg.btn1,MouseEvent.CLICK,this.on_btn1);
         CacheUtil.deleteObject(TrumpTrainningView);
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
         super.disport();
      }
   }
}

