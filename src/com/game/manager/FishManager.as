package com.game.manager
{
   import com.core.view.ViewConLogic;
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.locators.GameData;
   import com.game.locators.MsgDoc;
   import com.game.modules.view.MapView;
   import com.game.modules.view.person.GamePerson;
   import com.game.util.ScreenSprite;
   import com.publiccomponent.alert.Alert;
   import com.publiccomponent.loading.XMLLocator;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class FishManager extends ViewConLogic
   {
      
      public static var fishmanager:FishManager;
      
      private static const noFishState:int = 1;
      
      private static const getFishState:int = 2;
      
      private static const fishOverState:int = 3;
      
      public var temprole:GamePerson;
      
      private var timeid:int;
      
      private var fishstate:int;
      
      private var paramObj:Object;
      
      private var fishname:String;
      
      public function FishManager()
      {
         super();
      }
      
      public static function getInstance() : FishManager
      {
         if(fishmanager == null)
         {
            fishmanager = new FishManager();
         }
         return fishmanager;
      }
      
      public function gotoCheakFish(obj:Object) : void
      {
         var params:Object = {
            "x":obj.x,
            "y":obj.y
         };
         if(MapView.instance.masterPerson.moveto(params.x,params.y,this.gotoAndStart))
         {
            ApplicationFacade.getInstance().dispatch(EventConst.ROLEMOVE,{
               "newx":params.x,
               "newy":params.y,
               "path":null
            });
         }
      }
      
      private function gotoAndStart() : void
      {
         if(GameData.instance.playerData.isInFishState == false)
         {
            this.sendMessage(MsgDoc.CHEAKFISHINGORNOT.send,1);
         }
      }
      
      public function startFishing(obj:Object) : void
      {
         if(GameData.instance.playerData.currentScenenId != 30007)
         {
            return;
         }
         this.temprole = MapView.instance.findGameSprite(obj.personid) as GamePerson;
         if(this.temprole == null)
         {
            return;
         }
         this.temprole.playStatus = "fishing";
         if(this.temprole.sequenceID == MapView.instance.masterPerson.sequenceID)
         {
            clearTimeout(this.timeid);
            this.timeid = setTimeout(this.getFish,Math.round(Math.random() * 4 + 4) * 1000);
            this.fishstate = noFishState;
            sendMessage(MsgDoc.OP_GATEWAY_FISH_RANDOM.send,0);
            ScreenSprite.instance.show(true,false,30007);
         }
      }
      
      public function overFishing(obj:Object) : void
      {
         this.temprole = MapView.instance.findGameSprite(obj.personid) as GamePerson;
         if(Boolean(this.temprole))
         {
            this.temprole.removeStatus();
         }
      }
      
      public function setParams(params:Object) : void
      {
         this.paramObj = params;
         params.fishname = String(XMLLocator.getInstance().spriteitem(this.paramObj.monsterid).name);
      }
      
      private function getFish() : void
      {
         clearTimeout(this.timeid);
         this.fishstate = getFishState;
         MapView.instance.masterPerson.removeStatus();
         MapView.instance.masterPerson.playStatus = "getfish";
         this.fishstate = fishOverState;
         ScreenSprite.instance.fishStatus = 2;
         this.timeid = setTimeout(this.fishIsGone,2000);
      }
      
      private function fishIsGone() : void
      {
         ScreenSprite.instance.fishStatus = 3;
         clearTimeout(this.timeid);
         this.timeid = setTimeout(this.stopFishing,3000);
      }
      
      public function stopFishing(i:Boolean = false) : void
      {
         clearTimeout(this.timeid);
         this.fishstate = fishOverState;
         MapView.instance.masterPerson.removeStatus();
         ScreenSprite.instance.hide();
         this.sendMessage(MsgDoc.CHEAKFISHINGORNOT.send,2);
         if(!i)
         {
            new Alert().show("真可惜，上钩的妖怪已经逃跑了……下次记得拉快点哦！");
         }
      }
      
      public function chooseFish() : void
      {
         if(this.paramObj == null || this.paramObj.fishbool != 1)
         {
            this.stopFishing();
         }
         else
         {
            clearTimeout(this.timeid);
            this.stopFishing(true);
            GameData.instance.playerData.isInFishState = true;
            new Alert().showBattleOrNo("吖！钓到了一只" + this.paramObj.fishname + "，它正充满敌意的看着你。怎么办呢？",this.startBattle);
         }
      }
      
      private function startBattle(str:String, params:*) : void
      {
         GameData.instance.playerData.isInFishState = false;
         if("确定" == str)
         {
            sendMessage(MsgDoc.OP_GATEWAY_FISH_HIT.send);
         }
         this.paramObj = null;
      }
   }
}

