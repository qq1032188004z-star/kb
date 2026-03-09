package com.game.modules.view
{
   import com.core.observer.MessageEvent;
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.global.GlobalConfig;
   import com.game.locators.*;
   import com.game.manager.AlertManager;
   import com.game.manager.EventManager;
   import com.game.manager.MonsterManger;
   import com.game.manager.MouseManager;
   import com.game.modules.ai.NewHandJudge;
   import com.game.modules.ai.SpecialAreaManager;
   import com.game.modules.control.MapControl;
   import com.game.modules.control.collect.StoneControl;
   import com.game.modules.view.monster.MonsterPolling;
   import com.game.modules.view.person.GamePerson;
   import com.game.modules.view.person.INPC;
   import com.game.modules.view.person.MultipleNPC;
   import com.game.modules.view.trump.TrumpView;
   import com.game.modules.vo.NPCVo;
   import com.game.modules.vo.ShowData;
   import com.game.util.DelayShowUtil;
   import com.game.util.DictionaryCla;
   import com.game.util.FloatAlert;
   import com.game.util.GameAction;
   import com.game.util.GameDynamicUI;
   import com.game.util.MagicSprite;
   import com.game.util.NpcXMLParser;
   import com.game.util.ResetPersonPosition;
   import com.game.util.SceneSoundManager;
   import com.game.util.ScreenSprite;
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.alert.Alert;
   import com.publiccomponent.loading.GreenLoading;
   import com.publiccomponent.loading.Loading;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.net.URLRequest;
   import flash.utils.clearTimeout;
   import flash.utils.getTimer;
   import flash.utils.setTimeout;
   import org.engine.core.GameSprite;
   import org.engine.core.Render;
   import org.engine.core.Scene;
   import org.engine.core.Viewport;
   import org.engine.event.LoaderEvent;
   import org.engine.frame.FrameTimer;
   import org.engine.map.MapLoader;
   import org.plat.monitor.PlatMonitorLog;
   
   public class MapView extends Sprite
   {
      
      public static var instance:MapView = new MapView();
      
      public static const DANCE_LEVEL:String = "dance_level";
      
      public static const ACTIONEVENT:String = "actionevent";
      
      public static const ROLEMOVE:String = "rolemove";
      
      public static const MAPLOADED:String = "maploaded";
      
      public static const GCMONSTER:String = "gcmonster";
      
      public static const LEAVEBOB:String = "leavebob";
      
      public static const REQ_HOUHUA_DATA:String = "req_houhua_data";
      
      private var timerCheckList:Array = [];
      
      public var masterPerson:GamePerson;
      
      public var scene:Scene;
      
      private var viewport:Viewport;
      
      private var render:Render;
      
      private var nextScene:Scene;
      
      private var loading:Loading;
      
      private var mapLoader:MapLoader;
      
      private var lastClickTime:int;
      
      private var trump:TrumpView;
      
      private var loadList:DictionaryCla = new DictionaryCla();
      
      private var timeid:int;
      
      public function MapView()
      {
         super();
         this.name = "mapview";
         EventManager.attachEvent(this,Event.ADDED_TO_STAGE,this.onAddtoStage);
      }
      
      private function onAddtoStage(event:Event) : void
      {
         EventManager.removeEvent(this,Event.ADDED_TO_STAGE,this.onAddtoStage);
         this.viewport = new Viewport(970,570);
         this.viewport.container = this;
         this.render = new Render();
         this.loading = GreenLoading.loading;
         this.mapLoader = new MapLoader();
         EventManager.attachEvent(this.mapLoader,LoaderEvent.PROGRESS,this.onLoaderProgress);
         EventManager.attachEvent(this.mapLoader,LoaderEvent.COMPLEMENT,this.onLoadComplement);
         EventManager.attachEvent(this.mapLoader,LoaderEvent.ERROR,this.onLoadError);
         EventManager.attachEvent(this,MouseEvent.MOUSE_DOWN,this.onMouseDown);
         EventManager.attachEvent(this,MouseEvent.MOUSE_MOVE,this.onMouseMove);
         ApplicationFacade.getInstance().registerViewLogic(new MapControl(this));
         ApplicationFacade.getInstance().registerViewLogic(new StoneControl(null));
         FrameTimer.getInstance().addCallBack(this.renderMap,1);
         FrameTimer.getInstance().addCallBack(this.timerCheck,1);
         FrameTimer.getInstance().start(stage);
      }
      
      private function onBobAlerClose(... rest) : void
      {
         if("确定" == rest[0])
         {
            dispatchEvent(new MessageEvent(MapView.LEAVEBOB));
         }
      }
      
      private function onRefineAlerClose(... rest) : void
      {
         if("确定" == rest[0])
         {
            GameData.instance.playerData.refineState = false;
            ApplicationFacade.getInstance().dispatch(EventConst.STOPREFINE);
         }
      }
      
      private function onLoadError(evt:LoaderEvent) : void
      {
         PlatMonitorLog.instance.writeNewLog(401,GameData.instance.playerData.nextSceneId);
         this.loading.visible = false;
         this.loadMap(GameData.instance.playerData.nextSceneId);
      }
      
      private function onMouseMove(evt:MouseEvent) : void
      {
         var point:Point = null;
         if(this.masterPerson && this.masterPerson.ui != null && this.masterPerson.ui.parent != null)
         {
            point = this.masterPerson.ui.parent.globalToLocal(new Point(mouseX,mouseY));
            this.masterPerson.turnTo(point.x,point.y);
         }
      }
      
      public function get isLoader() : Boolean
      {
         return Boolean(this.mapLoader) && this.mapLoader.isLoader;
      }
      
      private function onMouseDown(event:MouseEvent) : void
      {
         var giant:* = undefined;
         var params:Object = null;
         var point:Point = null;
         if(GameData.instance.playerData.sceneId == 3007 && (GameData.instance.playerData.step == 1 || GameData.instance.playerData.step == 2 || GameData.instance.playerData.step == 7))
         {
            if(GameData.instance.playerData.step == 1)
            {
               new FloatAlert().show(WindowLayer.instance,350,250,"请先点选左右两边的门");
            }
            return;
         }
         if(GameData.instance.playerData.sceneId == 1028 && GameData.instance.playerData.isGetAward && GameData.instance.playerData.isDance)
         {
            return;
         }
         if(GameData.instance.playerData.sceneId == 15000)
         {
            return;
         }
         if(Boolean(GameData.instance.playerData.bobOwner))
         {
            new Alert().showSureOrCancel("确定离开擂台？",this.onBobAlerClose);
            return;
         }
         if(GameData.instance.playerData.refineState)
         {
            new Alert().showSureOrCancel("确定停止炼制？",this.onRefineAlerClose);
            return;
         }
         this.timerCheckList.length = 0;
         if(GameData.instance.playerData.sceneId == 902 || GameData.instance.playerData.sceneId == 901)
         {
            if(GameData.instance.playerData.isNewHand < 4)
            {
               return;
            }
         }
         if(GameData.instance.playerData.isDance && GameData.instance.playerData.sceneId == 1028)
         {
            EventManager.dispatch(this,new Event(EventConst.ACTIVITY_DANCE_LEVEL));
         }
         MouseManager.getInstance().mouseEvent = event;
         if(MouseManager.getInstance().cursorName == "CursorTool2")
         {
            EventManager.dispatch(this,new MessageEvent(EventConst.MOUSECURSORCLICK));
         }
         else if(MouseManager.getInstance().cursorName.substr(0,12) != "CursorTool20")
         {
            if(MouseManager.getInstance().cursorName == "jinnang" || MouseManager.getInstance().cursorName.substr(0,9) == "packmouse")
            {
               MouseManager.getInstance().setCursor("");
            }
            if(this.masterPerson.showData != null && this.masterPerson.ui != null && this.masterPerson.ui.parent != null)
            {
               this.sendToServer(mouseX,mouseY,null,this.masterPerson.showData.moveFlag);
            }
            giant = this.findGameSprite(201211002);
            if(giant && giant.MasterID == GameData.instance.playerData.userId)
            {
               giant["moveto"](mouseX,mouseY,this.giantGotoFire);
            }
         }
         else if(MouseManager.getInstance().cursorName.substr(0,12) == "CursorTool20")
         {
            params = {};
            params.actionid = int(MouseManager.getInstance().cursorName.slice(13,MouseManager.getInstance().cursorName.length));
            point = this.masterPerson.ui.parent.globalToLocal(new Point(mouseX,mouseY));
            params.destx = point.x;
            params.desty = point.y;
            EventManager.dispatch(this,new MessageEvent(MapView.ACTIONEVENT,params));
            MouseManager.getInstance().setCursor("");
         }
      }
      
      private function onIsGetAwardHandler(... rest) : void
      {
         if("确定" == rest[0])
         {
            GameData.instance.playerData.isGetAward = false;
            dispatchEvent(rest[1]);
         }
      }
      
      private function giantGotoFire() : void
      {
         var giant:* = this.findGameSprite(201211002);
         if(giant && giant.MasterID > 0 && Boolean(giant.FireData))
         {
            giant["onFire"]();
         }
      }
      
      private function sendToServer(destX:Number, destY:Number, onArraival:Function = null, moveFlag:int = 1) : void
      {
         if(Boolean(GameData.instance.playerData.magicStatus))
         {
            switch(GameData.instance.playerData.magicStatus)
            {
               case 14:
                  AlertManager.instance.showTipAlert({
                     "systemid":1049,
                     "flag":9
                  });
                  break;
               case 26:
                  AlertManager.instance.showTipAlert({
                     "systemid":1049,
                     "flag":15
                  });
                  break;
               case 29:
                  AlertManager.instance.showTipAlert({
                     "systemid":1049,
                     "flag":16
                  });
            }
            return;
         }
         var tempTime:int = getTimer();
         var flag:Boolean = this.masterPerson.moveto(destX,destY,onArraival,moveFlag);
         if(flag)
         {
            GameAction.instance.playMouseEffect(this,destX,destY);
         }
         if(tempTime - this.lastClickTime > 400 && flag)
         {
            this.dispatchEvent(new MessageEvent(MapView.ROLEMOVE,{
               "newx":destX,
               "newy":destY,
               "flag":moveFlag
            }));
            this.lastClickTime = tempTime;
         }
      }
      
      public function addTrump(params:Object, isInHouse:Boolean = false) : void
      {
         if(GameData.instance.playerData.sceneId == 1002 && this.trump == null)
         {
            params.state = 1;
            this.trump = new TrumpView();
            this.trump.x = 300;
            this.trump.y = 300;
            this.trump.setTrump(params);
            this.scene.add(this.trump);
         }
      }
      
      public function removeTrump() : void
      {
         if(Boolean(this.trump))
         {
            this.trump.dispos();
            this.scene.remove(this.trump);
            this.trump = null;
         }
      }
      
      private function onLoaderProgress(event:LoaderEvent) : void
      {
         this.loading.visible = true;
         this.loading.setProgress("正在加载...",event.bytesLoaded,event.bytesTotal);
      }
      
      private function onLoadComplement(event:LoaderEvent) : void
      {
         this.nextScene = event.scene;
         EventManager.dispatch(this,new MessageEvent(MapView.MAPLOADED,GameData.instance.playerData.nextSceneId));
      }
      
      public function loadMap(id:int) : void
      {
         var url:String = null;
         if(id == 0)
         {
            return;
         }
         if(GameData.instance.playerData.isInFishState)
         {
            return;
         }
         if(!SpecialAreaManager.instance.checkVip(id))
         {
            return;
         }
         GameData.instance.playerData.nextSceneId = id;
         GreenLoading.loading.visible = true;
         if(id == 1023)
         {
            dispatchEvent(new Event(MapView.REQ_HOUHUA_DATA));
         }
         else
         {
            GameData.instance.playerData.isInGardon = false;
            url = URLUtil.getSvnVer("assets/map/test" + id);
            this.mapLoader.load(url);
         }
      }
      
      public function reqHouHuaDataBack() : void
      {
         var url:String = URLUtil.getSvnVer("assets/map/test" + GameData.instance.playerData.nextSceneId);
         this.mapLoader.load(url);
      }
      
      public function onEnterSceneBack() : void
      {
         this.clearJobPlay();
         GameDynamicUI.clear();
         MagicSprite.instance.clean();
         MonsterManger.instance.deleteAllMonsterAtHome();
         GameData.instance.playerLists = [];
         DelayShowUtil.instance.clear();
         GameData.instance.playerData.lastSceneId = GameData.instance.playerData.sceneId;
         GameData.instance.playerData.sceneId = GameData.instance.playerData.nextSceneId;
         GameData.instance.playerData.currentScenenId = GameData.instance.playerData.nextSceneId;
         var lastSceneId:int = GameData.instance.playerData.lastSceneId;
         if(Boolean(this.scene))
         {
            this.removeTrump();
            this.scene.clear();
         }
         this.scene = this.nextScene;
         ScreenSprite.instance.show(false);
         this.scene.initSceneSpriteByXml();
         SceneSoundManager.getInstance().playSound(this.scene.config.@music);
         this.initSign(this.scene.config.child("sigh"));
         if(this.scene != null)
         {
            GameData.instance.playerData.magicStatus = 0;
            if(GameData.instance.playerData.isInWarCraft)
            {
               ApplicationFacade.getInstance().dispatch(EventConst.WARCRAFT_ADD_GAMEPERSON);
            }
            else
            {
               this.masterPerson = new GamePerson(GameData.instance.playerData);
               this.addGamePerson(this.masterPerson,GameData.instance.playerData);
               this.masterPerson.updatePersonFollwer();
               this.masterPerson.updateBodyOffset();
            }
            MonsterManger.instance.changScene(this.scene.config);
            ApplicationFacade.getInstance().dispatch(EventConst.CHANGESCENENAME,{"name":CacheData.instance.sceneName});
            if(FaceView.clip.bottomClip.y > 700)
            {
               FaceView.clip.showBottom();
            }
            if(GameData.instance.playerData.sceneType == 2)
            {
               FaceView.clip.hideBottom();
               FaceView.clip.topClip.visible = false;
            }
            else if(GameData.instance.playerData.isNewHand >= 6)
            {
               FaceView.clip.topClip.visible = true;
            }
            else
            {
               FaceView.clip.topClip.visible = false;
            }
            SceneAIGameView.instance.dispos();
            NewHandJudge.instance.judge(this.masterPerson,stage);
            SpecialAreaManager.instance.enterJudge(this.masterPerson);
            SpecialAreaManager.instance.initAlphaArea(this.scene);
            SpecialAreaManager.instance.loadAlphaClip(GameData.instance.playerData.lastSceneId);
            SpecialAreaManager.instance.checkHouhuaYuan(this.scene);
            MonsterPolling.instance.check();
            GreenLoading.loading.visible = false;
            this.addNPCBySceneXML();
         }
      }
      
      [cppcall]
      override public function addChild(child:DisplayObject) : DisplayObject
      {
         return super.addChild(child);
      }
      
      override public function addChildAt(child:DisplayObject, index:int) : DisplayObject
      {
         return super.addChildAt(child,index);
      }
      
      private function initSign(sighList:XMLList) : void
      {
         var sigh:DirectionView = null;
         var len:int = int(sighList.length());
         for(var i:int = 0; i < len; i++)
         {
            sigh = new DirectionView();
            this.scene.add(sigh);
            sigh.isBig = this.scene.config.@isBig;
            sigh.build(sighList[i] as XML);
         }
      }
      
      public function addGamePerson(role:GamePerson, params:ShowData) : void
      {
         var filt:Object = null;
         var config:XML = null;
         if(this.scene == null)
         {
            return;
         }
         if(params.x != 0 && params.userId != GameData.instance.playerData.userId || params.y != 0 && params.userId != GameData.instance.playerData.userId)
         {
            role.x = params.x;
            role.y = params.y;
         }
         else
         {
            filt = ResetPersonPosition.instance.birthPointFilter(GameData.instance.playerData.currentScenenId);
            if(filt == null)
            {
               if(params.lastSceneId == 1024 && params.sceneId == 1023)
               {
                  config = this.scene.config.child("smallhouse").(@id == GameData.instance.playerData.smallHouseID)[0];
               }
               if(!config)
               {
                  config = XML(this.scene.config.child("doorpos").(@id == params.lastSceneId)[0]);
               }
               role.x = config.@x;
               role.y = config.@y;
               if(role.x == 0 || role.y == 0)
               {
                  role.x = this.scene.config.@x;
                  role.y = this.scene.config.@y;
               }
            }
            else
            {
               role.x = filt.x;
               role.y = filt.y;
            }
         }
         this.scene.add(role,int(params.lastSceneId));
         role.update(params);
         if(role.showData.familyName != "")
         {
            role.updateFlagName(params.familyName);
         }
         if(role && role.showData.userId != GlobalConfig.userId && role.showData.isVip && (role.showData.state == 3 || role.showData.state == 2))
         {
            if(GlobalConfig.is_hide_beibei == 1)
            {
               role.reTakeFabao();
            }
            else
            {
               role.releaseFabao();
            }
         }
         NewHandJudge.instance.robotJudeg(role,this.scene);
      }
      
      public function addGameSprite(gameSprite:GameSprite) : void
      {
         if(gameSprite != null)
         {
            this.scene.add(gameSprite);
         }
      }
      
      public function delGameSpirit(value:*) : void
      {
         if(value is String && Boolean(this.scene))
         {
            this.scene.removeByName(value);
         }
         else if(value is int && Boolean(this.scene))
         {
            this.scene.removeBySequenceId(value);
         }
      }
      
      public function findGameSprite(value:*) : GameSprite
      {
         if(this.scene == null)
         {
            return null;
         }
         if(value is String)
         {
            return this.scene.findByName(value);
         }
         if(value is int)
         {
            return this.scene.findBySequenceId(value);
         }
         return null;
      }
      
      public function findLinkdGameSprites(linkName:String) : Array
      {
         return this.scene.findLinkdGameSprites(linkName);
      }
      
      public function getStaticBg() : BitmapData
      {
         var w:int = this.scene.bg.width == 0 ? 970 : int(this.scene.bg.width);
         var h:int = this.scene.bg.height == 0 ? 570 : int(this.scene.bg.height);
         var bitdata:BitmapData = new BitmapData(w,h);
         bitdata.draw(this.scene.bg);
         return bitdata;
      }
      
      public function userMove(params:Object, onArrive:Function = null) : void
      {
         var role:GamePerson = null;
         var point:Point = null;
         var userid:int = int(params.userId);
         if(this.scene == null || this.masterPerson == null)
         {
            return;
         }
         if(userid != this.masterPerson.sequenceID)
         {
            role = this.scene.findBySequenceId(userid) as GamePerson;
            if(Boolean(role))
            {
               if(role.ui.parent == null)
               {
                  return;
               }
               point = role.ui.parent.localToGlobal(new Point(params.newx,params.newy));
               role.moveto(point.x,point.y,onArrive,params.moveFlag);
            }
         }
      }
      
      public function addTimerListener(listener:Function) : void
      {
         this.timerCheckList.length = 0;
         this.timerCheckList.push(listener);
      }
      
      public function removeTimerListener(listener:Function) : void
      {
         this.timerCheckList.length = 0;
      }
      
      private function timerCheck() : void
      {
         var handler:Function = null;
         for each(handler in this.timerCheckList)
         {
            handler();
         }
      }
      
      private function renderMap(evt:Event = null) : void
      {
         if(this.scene != null)
         {
            this.render.render(this.scene,this.viewport);
         }
      }
      
      public function hideMyselfAndPlay(userid:int) : void
      {
         var role:GamePerson = null;
         role = MapView.instance.scene.findBySequenceId(userid) as GamePerson;
         if(role != null)
         {
            role.ui.visible = false;
            var palyloader:Loader = new Loader();
            if(GameData.instance.playerData.currentScenenId == 3002)
            {
               palyloader.x = role.x - 80;
               palyloader.y = role.y - 80;
               if(Boolean(role.showData.roleType & 1))
               {
                  palyloader.load(new URLRequest("assets/material/jobMale.swf"));
               }
               else
               {
                  palyloader.load(new URLRequest("assets/material/jobFemale.swf"));
               }
            }
            if(GameData.instance.playerData.currentScenenId == 6002)
            {
               if(role.x > 633)
               {
                  palyloader.x = role.x - 190;
                  palyloader.y = role.y - 77;
                  if(Boolean(role.showData.roleType & 1))
                  {
                     palyloader.load(new URLRequest("assets/material/waterjobMale.swf"));
                  }
                  else
                  {
                     palyloader.load(new URLRequest("assets/material/waterjobFemale.swf"));
                  }
               }
               else
               {
                  palyloader.x = role.x - 40;
                  palyloader.y = role.y - 87;
                  if(Boolean(role.showData.roleType & 1))
                  {
                     palyloader.load(new URLRequest("assets/material/rightwaterjobMale.swf"));
                  }
                  else
                  {
                     palyloader.load(new URLRequest("assets/material/rightwaterjobFemale.swf"));
                  }
               }
            }
            this.addChild(palyloader);
            this.loadList.pushValue(userid,palyloader);
            if(userid == GlobalConfig.userId)
            {
               if(GameData.instance.playerData.currentScenenId == 3002)
               {
                  this.timeid = setTimeout(this.playOver,60001);
               }
               if(GameData.instance.playerData.currentScenenId == 6002)
               {
                  this.timeid = setTimeout(this.playOver,120001);
               }
               ScreenSprite.instance.show(true,true,3002);
            }
            return;
         }
         O.o("这个人不是正在打工么，怎么不在场景中？");
      }
      
      private function clearJobPlay() : void
      {
         var key:String = null;
         if(this.loadList.length != 0)
         {
            for(key in this.loadList.dic)
            {
               if(this.loadList.dic[key] != null && this.contains(this.loadList.dic[key]) && this.loadList.length != 0)
               {
                  this.removeChild(this.loadList.dic[key]);
                  this.loadList.deleteValue(key);
               }
            }
         }
      }
      
      public function playOver() : void
      {
         ScreenSprite.instance.hide();
         clearTimeout(this.timeid);
         ApplicationFacade.getInstance().dispatch(EventConst.JOBAWARD);
         this.masterPerson.ui.visible = true;
         this.loadList.deleteValue(GlobalConfig.userId);
      }
      
      public function stopRoleJobStatus(userid:int) : void
      {
         O.o("停止" + userid);
         var role:GamePerson = MapView.instance.scene.findBySequenceId(userid) as GamePerson;
         if(role != null)
         {
            role.ui.visible = true;
         }
         else
         {
            O.o("这个人不是正在打工么，怎么不在场景中？");
         }
         if(userid == GlobalConfig.userId)
         {
            clearTimeout(this.timeid);
         }
         if(this.loadList.getValueByCode(userid) != null && this.contains(this.loadList.getValueByCode(userid)))
         {
            this.removeChild(this.loadList.getValueByCode(userid));
            this.loadList.deleteValue(userid);
         }
      }
      
      public function getCurrentSceneGamePersonList() : Array
      {
         var s:GameSprite = null;
         var list:Array = [];
         for each(s in this.scene.spriteList)
         {
            if(s is GamePerson)
            {
               if(s.sequenceID != GlobalConfig.userId)
               {
                  list.push(s["showData"]);
               }
            }
         }
         return list;
      }
      
      public function onEnterSceneFailed() : void
      {
         GreenLoading.loading.visible = false;
      }
      
      protected function addNPCBySceneXML() : void
      {
         var nodes:XMLList = null;
         var i:int = 0;
         var len:int = 0;
         var node:XML = null;
         var npc:INPC = null;
         var npcVO:NPCVo = null;
         if(Boolean(this.scene.config.hasOwnProperty("node")))
         {
            nodes = this.scene.config.child("node");
            if(nodes == null)
            {
               return;
            }
            i = 0;
            len = int(nodes.length());
            for(i = 0; i < len; i++)
            {
               node = nodes[i] as XML;
               if(node.@type == 1 || node.@type == 3)
               {
                  npcVO = NpcXMLParser.parse(node.@id);
                  if(npcVO != null)
                  {
                     npc = new MultipleNPC(npcVO);
                     this.addGameSprite(npc as GameSprite);
                     npc.load();
                  }
               }
            }
         }
      }
   }
}

