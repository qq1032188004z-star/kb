package com.game.modules.view.battle
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.global.GlobalConfig;
   import com.game.locators.GameData;
   import com.game.modules.control.battle.BeforeBattleControl;
   import com.game.util.HLoaderSprite;
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.loading.GreenLoading;
   import com.xygame.module.battle.data.BattleData;
   import com.xygame.module.battle.data.BattleLookList;
   import com.xygame.module.battle.util.SpiritXmlData;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.net.URLRequest;
   
   public class BeforeBattleView extends HLoaderSprite
   {
      
      private var _battleData:BattleData;
      
      private var _battleType:int;
      
      private var _sid:int;
      
      private var _oid:int;
      
      private var _pid:int;
      
      private var _playerIcon:Loader;
      
      private var _enemyIcon:Loader;
      
      private var _loaders:Array = [];
      
      private var _bgBitMapData:BitmapData;
      
      private const MONSTER_URL:String = "assets/monsterswf/";
      
      public function BeforeBattleView(sid:int, data:Object)
      {
         this._sid = sid;
         this._battleData = data as BattleData;
         this._oid = (sid & 0xFFFF00) >> 8;
         ApplicationFacade.getInstance().registerViewLogic(new BeforeBattleControl(this));
         super();
      }
      
      public function set battleType(value:int) : void
      {
         this._battleType = value;
         GreenLoading.loading.visible = true;
         switch(value)
         {
            case 5:
               this.url = "assets/battle/battlebg/beforeBigBattle.swf";
               break;
            case 14:
            case 15:
               this.url = "assets/battle/battlebg/beforeFSBattle.swf";
               break;
            default:
               this.url = "assets/battle/battlebg/beforeBattle.swf";
         }
      }
      
      public function get battleType() : int
      {
         return this._battleType;
      }
      
      public function set bgBitMapData(value:BitmapData) : void
      {
         if(!value)
         {
            return;
         }
         this._bgBitMapData = value;
         var rect:Rectangle = new Rectangle(0,0,value.width,value.height);
         value.colorTransform(rect,new ColorTransform(0.2,0.2,0.3,1,1,1,1,0));
         addChild(new Bitmap(value));
      }
      
      override public function setShow() : void
      {
         GreenLoading.loading.visible = false;
         if(GameData.instance.lookBattle == 1)
         {
            this.setupLookBattle();
         }
         else
         {
            this.setupNormalBattle();
         }
      }
      
      private function setupLookBattle() : void
      {
         var obj:Object = null;
         switch(GameData.instance.newLookType)
         {
            case 1:
               obj = GlobalConfig.otherObj["Act703"];
               if(Boolean(obj))
               {
                  bg["playername"].text = obj["sn2"]["name"];
                  bg["othername"].text = obj["sn1"]["name"];
               }
               break;
            case 2:
               bg["playername"].text = BattleLookList.ins.playerInfo["player"]["name"];
               bg["othername"].text = BattleLookList.ins.playerInfo["other"]["name"];
         }
      }
      
      private function setupNormalBattle() : void
      {
         this._oid = this._battleData.otherArr[0].spiritid;
         if(this._battleType != 5 && this._battleType != 14 && this._battleType != 15)
         {
            bg["playername"].text = GameData.instance.playerData.userName;
            SpiritXmlData.instance.spiritXmlData(this.onSpiritXmlLoaded);
         }
         this.loadIcons();
         this.setupBattleAnimation();
      }
      
      private function onSpiritXmlLoaded(value:XMLList) : void
      {
         var sname:String = String(SpiritXmlData.spirititem(this._oid.toString()).name);
         if(bg && Boolean(bg.hasOwnProperty("othername")))
         {
            bg["othername"].text = sname;
         }
      }
      
      public function loadPercent(value:Object) : void
      {
         if(this._battleType == 5)
         {
            return;
         }
         if(!bg)
         {
            return;
         }
         if(Boolean(bg.hasOwnProperty("load_1_txt")))
         {
            bg["load_1_txt"].text = value + "%";
         }
         if(Boolean(bg.hasOwnProperty("load_2_txt")))
         {
            bg["load_2_txt"].text = value + "%";
         }
      }
      
      private function loadIcons() : void
      {
         if(this._battleType == 5)
         {
            this.loadMultipleIcons();
         }
         else
         {
            this.loadSingleIcons();
         }
      }
      
      private function loadSingleIcons() : void
      {
         this._pid = this.findActiveSpiritId(this._battleData.mySpiritArr);
         this.loadIcon(this._pid,this.onPlayerIconLoaded,true);
         this.loadIcon(this._oid,this.onEnemyIconLoaded,false);
      }
      
      private function findActiveSpiritId(arr:Array) : int
      {
         var item:Object = null;
         for each(item in arr)
         {
            if(item.state == 1)
            {
               return item.spiritid;
            }
         }
         return 0;
      }
      
      private function loadIcon(id:int, completeHandler:Function, flip:Boolean) : void
      {
         var loader:Loader = new Loader();
         loader.contentLoaderInfo.addEventListener(Event.COMPLETE,completeHandler);
         loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
         loader.load(new URLRequest(URLUtil.getSvnVer("assets/monsterimg/" + id + ".swf")));
         if(flip)
         {
            this._playerIcon = loader;
         }
         else
         {
            this._enemyIcon = loader;
         }
      }
      
      private function onPlayerIconLoaded(e:Event) : void
      {
         this.setupIcon(e.currentTarget.loader,393,200,true);
         if(bg && Boolean(bg.hasOwnProperty("playdefault")))
         {
            bg["playdefault"].visible = false;
         }
      }
      
      private function onEnemyIconLoaded(e:Event) : void
      {
         this.setupIcon(e.currentTarget.loader,585,200,false);
         if(bg && Boolean(bg.hasOwnProperty("otherdefault")))
         {
            bg["otherdefault"].visible = false;
         }
      }
      
      private function setupIcon(loader:Loader, xPos:Number, yPos:Number, flip:Boolean) : void
      {
         loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onPlayerIconLoaded);
         loader.content.scaleY = 1.2;
         if(flip)
         {
            loader.content.scaleX = -1.2;
            if(bg && Boolean(bg.hasOwnProperty("spPlayMask")))
            {
               loader.mask = bg["spPlayMask"];
            }
         }
         else
         {
            loader.content.scaleX = 1.2;
            if(bg && Boolean(bg.hasOwnProperty("spOtherMask")))
            {
               loader.mask = bg["spOtherMask"];
            }
         }
         loader.x = xPos;
         loader.y = yPos;
         addChild(loader);
      }
      
      private function onLoadError(e:IOErrorEvent) : void
      {
         trace("[BeforeBattleView] Load Error:",e.text);
      }
      
      private function loadMultipleIcons() : void
      {
         var spiritId:int = 0;
         var loader:Loader = null;
         var allSpirits:Array = this._battleData.mySpiritArr.concat(this._battleData.otherArr);
         var positions:Array = [{
            "x":300,
            "y":335
         },{
            "x":190,
            "y":335
         },{
            "x":80,
            "y":335
         },{
            "x":630,
            "y":335
         },{
            "x":740,
            "y":335
         },{
            "x":850,
            "y":335
         }];
         for(var i:int = 0; i < allSpirits.length; i++)
         {
            spiritId = int(allSpirits[i].spiritid);
            loader = new Loader();
            loader.visible = false;
            loader.x = positions[i].x;
            loader.y = positions[i].y;
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onMultiIconLoaded,false,0,true);
            loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onLoadError,false,0,true);
            loader.load(new URLRequest(URLUtil.getSvnVer(this.MONSTER_URL + spiritId + ".swf")));
            this._loaders.push(loader);
            addChild(loader);
         }
      }
      
      private function onMultiIconLoaded(e:Event) : void
      {
         var loader:Loader = e.currentTarget.loader;
         loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onMultiIconLoaded);
         var index:int = int(this._loaders.indexOf(loader));
         if(index >= 0 && index < 3)
         {
            loader.content.scaleX = -loader.content.scaleX;
            loader.x += loader.width / 2;
         }
      }
      
      private function setupBattleAnimation() : void
      {
         if(!bg)
         {
            return;
         }
         if(this._battleType != 5 && this._battleType != 14 && this._battleType != 15)
         {
            return;
         }
         if(!(bg is MovieClip))
         {
            return;
         }
         var mc:MovieClip = MovieClip(bg);
         mc.gotoAndPlay(1);
         addEventListener(Event.ENTER_FRAME,this.onWaitForBgReady);
      }
      
      private function onWaitForBgReady(e:Event) : void
      {
         if(!bg || !(bg.getChildAt(0) is MovieClip))
         {
            return;
         }
         removeEventListener(Event.ENTER_FRAME,this.onWaitForBgReady);
         var mc:MovieClip = MovieClip(bg.getChildAt(0));
         if(this._battleType == 5)
         {
            mc.addFrameScript(154,this.onBigBattleFrame154,166,this.onBigBattleFrame166,176,this.onBigBattleFrame176,249,this.onBigBattleFrame249);
         }
         else if(this._battleType == 14 || this._battleType == 15)
         {
            mc.addFrameScript(37,this.onArenaFrame37,67,this.onArenaFrame67);
         }
      }
      
      private function onBigBattleFrame154() : void
      {
         this.setLoaderVisible([this._loaders[0],this._loaders[3]],true);
      }
      
      private function onBigBattleFrame166() : void
      {
         this.setLoaderVisible([this._loaders[1],this._loaders[4]],true);
      }
      
      private function onBigBattleFrame176() : void
      {
         this.setLoaderVisible([this._loaders[2],this._loaders[5]],true);
      }
      
      private function onBigBattleFrame249() : void
      {
         ApplicationFacade.getInstance().dispatch(EventConst.BIGBATTLE_BEFOREOVER);
         this.clearFrameScripts();
      }
      
      private function onArenaFrame37() : void
      {
         this.clearFrameScript(37);
         this.toggleArenaNameVisibility(true);
      }
      
      private function onArenaFrame67() : void
      {
         this.clearFrameScript(37);
         this.clearFrameScript(67);
         if(bg && bg.getChildAt(0) is MovieClip)
         {
            MovieClip(bg.getChildAt(0)).gotoAndStop(68);
         }
      }
      
      private function setLoaderVisible(arr:Array, visible:Boolean) : void
      {
         var l:Loader = null;
         for each(l in arr)
         {
            if(Boolean(l))
            {
               l.visible = visible;
            }
         }
      }
      
      private function toggleArenaNameVisibility(visible:Boolean) : void
      {
         if(!bg)
         {
            return;
         }
         bg["playername"].visible = visible;
         bg["othername"].visible = visible;
         bg["playerTitle"].visible = visible;
         bg["otherTitle"].visible = visible;
      }
      
      private function clearFrameScript(frame:int) : void
      {
         if(bg && bg.getChildAt(0) is MovieClip)
         {
            MovieClip(bg.getChildAt(0)).addFrameScript(frame,null);
         }
      }
      
      private function clearFrameScripts() : void
      {
         if(!bg || !(bg.getChildAt(0) is MovieClip))
         {
            return;
         }
         var mc:MovieClip = MovieClip(bg.getChildAt(0));
         mc.addFrameScript(154,null,166,null,176,null,249,null,37,null,67,null);
      }
      
      public function destroy() : void
      {
         GreenLoading.loading.visible = false;
         ApplicationFacade.getInstance().removeViewLogic(BeforeBattleControl.NAME);
         this.clearFrameScripts();
         removeEventListener(Event.ENTER_FRAME,this.onWaitForBgReady);
         for(this.removeAllLoaders(); numChildren > 0; )
         {
            removeChildAt(0);
         }
         super.disport();
      }
      
      private function removeAllLoaders() : void
      {
         var ldr:Loader = null;
         var all:Array = this._loaders.concat([this._playerIcon,this._enemyIcon]);
         for each(ldr in all)
         {
            if(ldr)
            {
               try
               {
                  ldr.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onMultiIconLoaded);
                  ldr.unloadAndStop();
                  if(contains(ldr))
                  {
                     removeChild(ldr);
                  }
               }
               catch(e:Error)
               {
                  continue;
               }
            }
         }
         this._loaders = [];
         this._playerIcon = this._enemyIcon = null;
      }
   }
}

