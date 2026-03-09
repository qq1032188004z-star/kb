package com.game.modules.view.battle.pop
{
   import com.game.locators.GameData;
   import com.game.util.HLoaderSprite;
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.loading.XMLLocator;
   import com.xygame.module.battle.data.LevelUpData;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class WinLevelView extends HLoaderSprite
   {
      
      private var sid:uint;
      
      private var data:LevelUpData;
      
      private var iloader:Loader;
      
      public function WinLevelView(value:LevelUpData)
      {
         super();
         this.data = value;
         this.init();
      }
      
      private function init() : void
      {
         this.url = "assets/battle/battlebg/battleLevelUp.swf";
      }
      
      override public function setShow() : void
      {
         var xml:XML = XMLLocator.getInstance().getSprited(this.data.spiritid);
         if(Boolean(xml))
         {
            this.bg.desc.text = "" + xml.name + "获得" + this.data.realexp + "历练,升级到" + this.data.level + "级";
            this.bg.spiritname.text = "" + xml.name;
            this.bg.okbtn.addEventListener(MouseEvent.CLICK,this.onClickOkBtnHandler);
            if(GameData.instance.playerData.isAutoBattle)
            {
               this.sid = setTimeout(this.onClickOkBtnHandler,1000);
            }
            this.bg.oh.text = "" + this.data.omaxhp;
            this.bg.ch.text = "" + this.data.maxhp;
            this.bg.ah.text = "" + (this.data.maxhp - this.data.omaxhp);
            this.bg.oa.text = "" + this.data.oattack;
            this.bg.ca.text = "" + this.data.attack;
            this.bg.aa.text = "" + (this.data.attack - this.data.oattack);
            this.bg.od.text = "" + this.data.odefack;
            this.bg.cd.text = "" + this.data.defack;
            this.bg.ad.text = "" + (this.data.defack - this.data.odefack);
            this.bg.om.text = "" + this.data.omagicatk;
            this.bg.cm.text = "" + this.data.magicatk;
            this.bg.am.text = "" + (this.data.magicatk - this.data.omagicatk);
            this.bg.ok.text = "" + this.data.omagicdef;
            this.bg.ck.text = "" + this.data.magicdef;
            this.bg.ak.text = "" + (this.data.magicdef - this.data.omagicdef);
            this.bg.os.text = "" + this.data.ospeed;
            this.bg.cs.text = "" + this.data.speed;
            this.bg["as"].text = "" + (this.data.speed - this.data.ospeed);
         }
         this.loaderIcon();
      }
      
      private function loaderIcon() : void
      {
         this.iloader = new Loader();
         this.iloader.load(new URLRequest(URLUtil.getSvnVer("assets/monsterswf/" + this.data.spiritid + ".swf")));
         this.iloader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.iconLoaderComp);
         this.iloader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onIOerrorHandler);
      }
      
      private function iconLoaderComp(event:Event) : void
      {
         this.iloader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.iconLoaderComp);
         this.iloader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOerrorHandler);
         this.iloader.scaleX = this.iloader.scaleY = 1.2;
         this.iloader.y = 96;
         this.iloader.x = 48;
         this.addChild(this.iloader);
      }
      
      private function onIOerrorHandler(event:IOErrorEvent) : void
      {
         O.o("精魂升级窗口【精魂头像】加载失败" + event);
         this.iloader.load(new URLRequest(URLUtil.getSvnVer("assets/monsterswf/10.swf")));
      }
      
      private function onClickOkBtnHandler(event:MouseEvent = null) : void
      {
         clearTimeout(this.sid);
         dispatchEvent(new Event(Event.CLOSE));
         if(Boolean(this.parent) && this.parent.contains(this))
         {
            this.parent.removeChild(this);
         }
         this.disport();
      }
      
      override public function disport() : void
      {
         if(Boolean(this.iloader))
         {
            clearTimeout(this.sid);
            this.iloader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.iconLoaderComp);
            this.iloader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOerrorHandler);
            if(this.contains(this.iloader))
            {
               this.removeChild(this.iloader);
            }
            this.iloader.unload();
            this.iloader = null;
         }
         super.disport();
      }
   }
}

