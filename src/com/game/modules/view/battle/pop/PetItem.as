package com.game.modules.view.battle.pop
{
   import com.game.locators.GameData;
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.loading.XMLLocator;
   import com.xygame.module.battle.data.LevelUpData;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLRequest;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol655")]
   public class PetItem extends Sprite
   {
      
      private var data:LevelUpData;
      
      public var hpbar:MovieClip;
      
      public var getexp:TextField;
      
      public var nextexp:TextField;
      
      public var vipicon:MovieClip;
      
      public var testicon:MovieClip;
      
      public var supervipicon:MovieClip;
      
      private var loader:Loader;
      
      private var url:String;
      
      public function PetItem(value:LevelUpData)
      {
         super();
         this.data = value;
         this.setShow();
      }
      
      public function setShow() : void
      {
         var xml:XML = XMLLocator.getInstance().getSprited(this.data.spiritid);
         this.hpbar.gotoAndStop(int(100 * this.data.currentHp / this.data.maxhp));
         if(Boolean(xml))
         {
            this.getexp.text = "[" + xml.name + "]获得" + this.data.realexp + "历练,当前等级" + this.data.level;
            this.nextexp.text = "下次升级还需历练:" + this.data.expnow + "点";
            if(this.data.level >= 100)
            {
               this.getexp.text = "[" + xml.name + "]" + "当前等级" + this.data.level + "已经满级！";
               this.nextexp.visible = false;
            }
            this.addIcon();
         }
         if(Boolean(this.vipicon))
         {
            if(GameData.instance.playerData.isVip)
            {
               if(GameData.instance.playerData.isSupertrump && Boolean(this.supervipicon))
               {
                  this.supervipicon.visible = true;
                  this.vipicon.visible = false;
               }
               else
               {
                  this.vipicon.visible = true;
                  this.supervipicon.visible = false;
               }
            }
            else
            {
               this.vipicon.visible = false;
               this.supervipicon.visible = false;
            }
         }
      }
      
      private function addIcon() : void
      {
         this.url = "assets/monsterimg/" + this.data.spiritid + ".swf";
         this.loader = new Loader();
         this.loader.load(new URLRequest(URLUtil.getSvnVer(this.url)));
         this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onIoErrorHandler);
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoaderComp);
         this.addChild(this.loader);
      }
      
      private function onIoErrorHandler(event:IOErrorEvent) : void
      {
         O.o("petItem" + event);
      }
      
      private function onLoaderComp(event:Event) : void
      {
         this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoaderComp);
         this.loader.scaleX = 30 / this.loader.width;
         this.loader.scaleY = 30 / this.loader.height;
         this.loader.x = 10;
         this.loader.y = 8;
         var innerBorder:Sprite = new Sprite();
         innerBorder.graphics.clear();
         innerBorder.graphics.beginFill(16711680,1);
         innerBorder.graphics.drawCircle(0,0,17);
         innerBorder.graphics.endFill();
         this.loader.mask = innerBorder;
         innerBorder.x = 25;
         innerBorder.y = 19;
         this.addChild(innerBorder);
      }
      
      public function disport() : void
      {
         this.getexp = null;
         this.nextexp = null;
         this.hpbar.stop();
         if(Boolean(this.loader))
         {
            this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoaderComp);
            this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onIoErrorHandler);
            this.loader.unload();
         }
         this.loader = null;
      }
   }
}

