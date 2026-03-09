package com.game.modules.view
{
   import com.game.locators.GameData;
   import com.game.manager.AlertManager;
   import com.game.manager.EventManager;
   import com.game.util.HLoaderSprite;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class OnlineAwardView extends HLoaderSprite
   {
      
      private static const AwardList:Array = [{},{},{
         "type":3,
         "award":100008,
         "count":1
      },{
         "type":3,
         "award":100010,
         "count":1
      },{
         "type":3,
         "award":100001,
         "count":2
      },{
         "type":1,
         "award":500
      },{
         "type":3,
         "award":100010,
         "count":1
      },{
         "type":3,
         "award":100007,
         "count":3
      },{
         "type":3,
         "award":100001,
         "count":3
      },{
         "type":1,
         "award":1000
      },{
         "type":3,
         "award":100011,
         "count":2
      },{
         "type":3,
         "award":100006,
         "count":2
      },{
         "type":3,
         "award":100001,
         "count":5
      },{
         "type":1,
         "award":1500
      },{
         "type":3,
         "award":100002,
         "count":2
      },{
         "type":3,
         "award":100008,
         "count":2
      },{
         "type":3,
         "award":100006,
         "count":5
      },{
         "type":1,
         "award":2000
      },{
         "type":3,
         "award":100002,
         "count":3
      },{
         "type":3,
         "award":100011,
         "count":2
      },{
         "type":3,
         "award":100006,
         "count":5
      },{
         "type":1,
         "award":3000
      },{
         "type":3,
         "award":100029,
         "count":1
      },{
         "type":3,
         "award":100028,
         "count":1
      },{
         "type":3,
         "award":100030,
         "count":1
      },{
         "type":3,
         "award":100030,
         "count":2
      },{
         "type":3,
         "award":800041,
         "count":1
      },{
         "type":3,
         "award":800048,
         "count":1
      },{
         "type":3,
         "award":100030,
         "count":3
      }];
      
      private var awardData:Object;
      
      public function OnlineAwardView()
      {
         super();
      }
      
      override public function initParams(params:Object = null) : void
      {
         if(Boolean(params))
         {
            this.awardData = params;
         }
         if(this.bg)
         {
            this.setShow();
         }
         else
         {
            this.url = "assets/material/onlineAwardView.swf";
         }
      }
      
      override public function setShow() : void
      {
         if(!this.awardData)
         {
            return;
         }
         (bg["numTxt"] as TextField).text = "" + (this.awardData.nextId - 1);
         var index1:int = this.frameCounter(this.awardData.awards[0]);
         var index2:int = this.frameCounter(this.awardData.awards[1]);
         (bg["award1"] as MovieClip).gotoAndStop(index1);
         (bg["award2"] as MovieClip).gotoAndStop(index2);
         if(this.awardData.awards[0].type == 2)
         {
            GameData.instance.playerData.coin += this.awardData.awards[0].award;
         }
         if(this.awardData.awards[1].type == 2)
         {
            GameData.instance.playerData.coin += this.awardData.awards[1].award;
         }
         EventManager.attachEvent(this.bg["getBtn"],MouseEvent.CLICK,this.onClickGet);
         this.awardData = null;
      }
      
      private function onClickGet(evt:MouseEvent) : void
      {
         EventManager.removeEvent(this.bg["getBtn"],MouseEvent.CLICK,this.onClickGet);
         AlertManager.instance.showTipAlert({
            "systemid":1005,
            "flag":1
         });
         this.parent.removeChild(this);
      }
      
      private function frameCounter(obj:Object) : int
      {
         var i:int = 2;
         for(i = 2; i <= 28; i++)
         {
            if(obj.hasOwnProperty("count"))
            {
               if(AwardList[i].type == obj.type && AwardList[i].award == obj.award && AwardList[i].count == obj.count)
               {
                  return i;
               }
            }
            else if(AwardList[i].type == obj.type && AwardList[i].award == obj.award)
            {
               return i;
            }
         }
         return 1;
      }
      
      override public function disport() : void
      {
         EventManager.removeEvent(this.bg["getBtn"],MouseEvent.CLICK,this.onClickGet);
         AlertManager.instance.showTipAlert({
            "systemid":1005,
            "flag":1
         });
         if(Boolean(this.parent) && this.parent.contains(this))
         {
            this.parent.removeChild(this);
         }
         super.disport();
      }
   }
}

