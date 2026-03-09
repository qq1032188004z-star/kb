package com.game.modules.view.battle.pvp
{
   import com.game.locators.GameData;
   import com.game.util.HLoaderSprite;
   import com.publiccomponent.loading.GreenLoading;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class PvpWait extends HLoaderSprite
   {
      
      private var palyername:String = "";
      
      private var othername:String = "";
      
      private var othersex:int;
      
      private var pvptype:int;
      
      public function PvpWait(str:String, sex:int, type:int)
      {
         super();
         this.othername = str;
         this.othersex = sex;
         this.pvptype = type;
         this.init();
      }
      
      private function init() : void
      {
         GreenLoading.loading.visible = true;
         this.url = "assets/pvp/pvpwait.swf";
      }
      
      override public function setShow() : void
      {
         GreenLoading.loading.visible = false;
         bg["closeBtn"].addEventListener(MouseEvent.CLICK,this.onClickCloseBtn);
         bg["playername"].text = GameData.instance.playerData.userName;
         bg["othername"].text = this.othername;
         bg["player"].gotoAndStop(Boolean(GameData.instance.playerData.roleType & 1) ? 2 : 3);
         bg["other"].gotoAndStop(this.othersex == 1 ? 2 : 3);
         if(Boolean(bg["title"]))
         {
            bg["title"].gotoAndStop(this.pvptype);
         }
      }
      
      private function onClickCloseBtn(event:MouseEvent) : void
      {
         dispatchEvent(new Event(Event.CLOSE));
         this.disport();
      }
      
      override public function disport() : void
      {
         GreenLoading.loading.visible = false;
         if(Boolean(this.parent) && this.parent.contains(this))
         {
            this.parent.removeChild(this);
         }
         super.disport();
      }
   }
}

