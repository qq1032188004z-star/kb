package com.game.modules.view.battle.pop
{
   import com.game.locators.GameData;
   import com.xygame.module.battle.data.LevelUpData;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol361")]
   public class WinExpView extends Sprite
   {
      
      public var bg:MovieClip;
      
      public var title:MovieClip;
      
      public var okBtn:SimpleButton;
      
      public var bottommc:MovieClip;
      
      public var failTitle:MovieClip;
      
      private var titlebool:Boolean;
      
      private var failbool:Boolean;
      
      private var sid:uint;
      
      private var spiritsarr:Array;
      
      private var itemNum:int = 0;
      
      public function WinExpView(spiritsArr:Array, bool:Boolean, failtitle:Boolean = false)
      {
         super();
         this.spiritsarr = spiritsArr;
         this.titlebool = bool;
         this.failbool = failtitle;
         this.initListen();
      }
      
      public function addItem(item:PetItem) : void
      {
         item.x = 30;
         item.y = this.itemNum * 50 + 75;
         ++this.itemNum;
         this.addChild(item);
         this.setHeight();
      }
      
      private function initListen() : void
      {
         this.bottommc.okBtn.addEventListener(MouseEvent.CLICK,this.onClickOkBtnHandler);
         if(GameData.instance.playerData.isAutoBattle)
         {
            this.sid = setTimeout(this.onClickOkBtnHandler,2000);
         }
         this.showInfo();
         this.title.visible = !this.titlebool && !this.failbool;
         this.failTitle.visible = this.failbool;
      }
      
      private function showInfo() : void
      {
         var i:int = 0;
         var obj:LevelUpData = null;
         var l:int = int(this.spiritsarr.length);
         for(i = 0; i < l; i++)
         {
            obj = this.spiritsarr[i];
            if(obj.realexp > 0 || obj.level == 100 || !this.failbool)
            {
               this.addItem(new PetItem(obj));
            }
         }
      }
      
      private function onClickOkBtnHandler(event:MouseEvent = null) : void
      {
         clearTimeout(this.sid);
         this.dispatchEvent(new Event(Event.CLOSE));
         if(Boolean(this.parent) && this.parent.contains(this))
         {
            this.parent.removeChild(this);
         }
         this.disport();
      }
      
      private function setHeight() : void
      {
         this.bg.bgout.height = 140 + this.itemNum * 42;
         this.bg.bgin.height = this.bg.bgout.height - 118;
         if(this.itemNum == 1)
         {
            this.bottommc.y = this.height - 30 - 50 + 5;
         }
         else if(this.itemNum == 2)
         {
            this.bottommc.y = this.height - 40;
         }
         else
         {
            this.bottommc.y = this.height - 30;
         }
      }
      
      public function show(parent:DisplayObjectContainer) : void
      {
         parent.addChild(this);
      }
      
      private function disport() : void
      {
         clearTimeout(this.sid);
         while(this.numChildren > 0)
         {
            if(this.getChildAt(0) is PetItem)
            {
               this.getChildAt(0)["disport"]();
            }
            this.removeChildAt(0);
         }
         this.bg.stop();
         this.bg = null;
         this.bottommc.stop();
         this.bottommc = null;
         this.title.stop();
         this.title = null;
      }
   }
}

