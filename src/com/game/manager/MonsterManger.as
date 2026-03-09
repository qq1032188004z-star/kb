package com.game.manager
{
   import com.core.observer.MessageEvent;
   import com.game.event.EventConst;
   import com.game.locators.*;
   import com.game.modules.view.MapView;
   import com.game.modules.view.battle.AIMonster;
   import com.game.modules.view.collect.ScenePlugin;
   import com.game.modules.view.collect.Stone;
   import com.game.util.IdName;
   import com.publiccomponent.loading.HurlLoader;
   import com.publiccomponent.loading.XMLLocator;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.net.URLLoaderDataFormat;
   import flash.utils.ByteArray;
   import org.engine.frame.FrameTimer;
   
   public class MonsterManger extends EventDispatcher
   {
      
      private static var _instance:MonsterManger;
      
      private var monsterList:Array = [];
      
      private var aiList:Array = [];
      
      private var config:XML;
      
      public var scenespirits:XMLList;
      
      private var scenespiritsloader:HurlLoader;
      
      private var count:int = 0;
      
      private var firstMarr:Array = [];
      
      private var secondMarr:Array = [];
      
      private var thirdMarr:Array = [];
      
      private var fourMarr:Array = [];
      
      private var initalRandom:Number;
      
      private var arrArr:Array = [this.firstMarr,this.secondMarr,this.thirdMarr,this.fourMarr];
      
      private var count1:int;
      
      private var count2:int;
      
      private var count3:int;
      
      private var count4:int;
      
      public var homeAIM:Array = [];
      
      public function MonsterManger(target:IEventDispatcher = null)
      {
         super(target);
      }
      
      public static function get instance() : MonsterManger
      {
         if(_instance == null)
         {
            _instance = new MonsterManger();
         }
         return _instance;
      }
      
      public function changScene(config:XML) : void
      {
         FrameTimer.getInstance().removeCallBack(this.reFreshone);
         FrameTimer.getInstance().removeCallBack(this.reFreshtwo);
         FrameTimer.getInstance().removeCallBack(this.reFreshthree);
         FrameTimer.getInstance().removeCallBack(this.reFreshfour);
         this.config = config;
         this.monsterList = [];
         if(Boolean(this.scenespirits))
         {
            this.AddMonsterToSence();
         }
         else
         {
            this.loaderssxml();
         }
         this.initStuff(config);
         this.initPlugin(config);
      }
      
      private function loaderssxml() : void
      {
         var url:String = null;
         if(this.scenespiritsloader == null)
         {
            url = CacheData.instance.formatUrl("config/scenespirit");
            this.scenespiritsloader = new HurlLoader(url,null,URLLoaderDataFormat.BINARY);
            this.scenespiritsloader.addEventListener(Event.COMPLETE,this.onScenespiritsCompHandler);
         }
      }
      
      private function onScenespiritsCompHandler(event:Event) : void
      {
         this.scenespiritsloader.removeEventListener(Event.COMPLETE,this.onScenespiritsCompHandler);
         var ba:ByteArray = ByteArray(this.scenespiritsloader.data);
         if(Boolean(ba))
         {
            ba.uncompress();
            this.scenespirits = new XMLList(ba);
            this.AddMonsterToSence();
         }
         this.scenespiritsloader.disport();
         this.scenespiritsloader = null;
         this.dispatchEvent(new Event(EventConst.SCENE_SPIRITS_CONFIG_LOADED));
      }
      
      private function AddMonsterToSence() : void
      {
         this.initAIMonster();
      }
      
      private function initPlugin(config:XML) : void
      {
         var node:XMLList = null;
         var i:int = 0;
         var obj:Object = null;
         var plugin:ScenePlugin = null;
         var tempxml:XML = config;
         if(tempxml != null)
         {
            node = tempxml.child("node").(@type == 10) as XMLList;
            for(i = 0; i < node.length(); i++)
            {
               if(node != null)
               {
                  obj = new Object();
                  obj.x = node[i].@x;
                  obj.y = node[i].@y;
                  obj.sequenceID = node[i].@id;
                  obj.url = node[i].@url;
                  obj.goObj = node[i].@goObj;
                  plugin = new ScenePlugin(obj);
                  plugin.load(node[i].@url);
                  MapView.instance.addGameSprite(plugin);
               }
            }
         }
      }
      
      private function initStuff(config:XML) : void
      {
         var node:XMLList = null;
         var i:int = 0;
         var obj:Object = null;
         var stone:Stone = null;
         var tempxml:XML = config;
         if(tempxml != null)
         {
            node = tempxml.child("node").(@type == 6) as XMLList;
            for(i = 0; i < node.length(); i++)
            {
               if(node != null)
               {
                  obj = new Object();
                  obj.x = node[i].@x;
                  obj.y = node[i].@y;
                  obj.sequenceID = node[i].@id;
                  obj.url = node[i].@url;
                  stone = new Stone(obj);
                  stone.load(node[i].@url);
                  MapView.instance.addGameSprite(stone);
               }
            }
            if(Boolean(GameData.instance.autoCollectData.isAutoNum))
            {
               GameData.instance.autoCollectData.isGoNpc = true;
            }
            GameData.instance.dispatchEvent(new MessageEvent(EventDefine.NPC_COLLECT_LOAD_OK));
         }
      }
      
      private function addMonster(iscopy:Object = null) : void
      {
         var i:int = 0;
         var monster:AIMonster = null;
         this.aiList.length = 0;
         var l:int = int(this.monsterList.length);
         for(i = 0; i < l; i++)
         {
            if(this.monsterList[i].randomShow == 0 && this.isTimeToShow(this.monsterList[i].showTime))
            {
               monster = new AIMonster(this.monsterList[i]);
               monster.name = IdName.monster(this.monsterList[i].monsterId);
               MapView.instance.addGameSprite(monster);
               this.aiList.push(monster);
            }
         }
      }
      
      public function combine1(type:int, val:int, spiritid:int, level:int) : int
      {
         return int(type << 28 & 0xF0000000) | val << 22 & 0x0FB00000 | spiritid << 8 & 0x3FFF00 | level;
      }
      
      public function combine2(type:int, spiritid:int) : int
      {
         return int(type << 28 & 0xF0000000 | spiritid & 0x0FFFFFFF);
      }
      
      public function initAIMonster(timeCount:int = 1000) : void
      {
         var ssxml:XML;
         var itemList:XMLList = null;
         var i:int = 0;
         var total:int = 0;
         var c:int = 0;
         var obj2:Object = null;
         this.firstMarr.splice(0,this.firstMarr.length);
         this.secondMarr.splice(0,this.secondMarr.length);
         this.thirdMarr.splice(0,this.thirdMarr.length);
         this.fourMarr.splice(0,this.fourMarr.length);
         if(this.scenespirits == null)
         {
            return;
         }
         ssxml = this.scenespirits.children().(@id == GameData.instance.playerData.sceneId)[0];
         if(Boolean(ssxml))
         {
            itemList = ssxml.children();
         }
         if(itemList != null)
         {
            for(i = 0; i < itemList.length(); i++)
            {
               if(itemList[i].@id != -1 && (GameData.instance.playerData.copyScene == 0 || GameData.instance.playerData.copyScene > 0 && int(itemList[i].@copy_level) == GameData.instance.playerData.lastcopylevel))
               {
                  total = int(itemList[i].@counts);
                  for(c = 0; c < total; c++)
                  {
                     obj2 = this.readMonster(itemList[i],timeCount);
                     this.monsterList.push(obj2);
                     this.putMMinArr(0,obj2);
                  }
               }
            }
         }
         this.addMonster();
         if(this.firstMarr.length != 0)
         {
            FrameTimer.getInstance().addCallBack(this.reFreshone);
         }
         if(this.secondMarr.length != 0)
         {
            FrameTimer.getInstance().addCallBack(this.reFreshtwo);
         }
         if(this.thirdMarr.length != 0)
         {
            FrameTimer.getInstance().addCallBack(this.reFreshthree);
         }
         if(this.fourMarr.length != 0)
         {
            FrameTimer.getInstance().addCallBack(this.reFreshfour);
         }
      }
      
      private function putMMinArr(i:int, obj2:Object) : void
      {
         if(this.arrArr[i].length == 0 || this.arrArr[i][0].monsterId == obj2.monsterId)
         {
            this.arrArr[i].push(obj2);
         }
         else if(i + 1 < this.arrArr.length)
         {
            this.putMMinArr(i + 1,obj2);
         }
      }
      
      private function readMonster(item:XML, timeCount:int = 1000) : Object
      {
         var mathNum:Number = NaN;
         var random:Number = Boolean(item.hasOwnProperty("@random")) ? Number(item.@random) : 0;
         var showTime:String = Boolean(item.hasOwnProperty("@time")) ? item.@time : "";
         if(random != 0)
         {
            mathNum = Math.random();
            if(mathNum < random)
            {
               random = 0;
            }
         }
         var obj2:Object = new Object();
         obj2.israte = int(Boolean(item.hasOwnProperty("@israte")) ? item.@israte : 0);
         obj2.counts = int(item.@counts);
         obj2.randomShow = random;
         obj2.showTime = showTime;
         obj2.initalRandom = Number(Boolean(item.hasOwnProperty("@random")) ? item.@random : 0);
         if(Boolean(item.hasOwnProperty("@place")))
         {
            obj2.placeList = item.@place.split(",");
         }
         obj2.monsterId = int(item.@id);
         obj2.monsterType = int(item.@type);
         obj2.levelList = item.@level.split(",");
         obj2.monsterLevel = int(item.@level.split(",")[int(Math.random() * 3)]);
         obj2.iscontinuemove = int(item.@iscontinuemove);
         obj2.sid = this.combine1(int(obj2.monsterType),0,int(obj2.monsterId),int(obj2.monsterLevel));
         obj2.monsterName = IdName.monster(Math.random() * 10 + Math.random() * 100 + Math.random() * 1000);
         obj2.labelName = item.@name;
         obj2.isCopySence = GameData.instance.playerData.copyScene > 0;
         obj2.count = timeCount;
         if(Boolean(item.hasOwnProperty("@scope")))
         {
            obj2.scope = item.@scope.split(",");
         }
         return obj2;
      }
      
      private function isTimeToShow(showTime:String) : Boolean
      {
         if(showTime == null || showTime.length < 2)
         {
            return true;
         }
         var timeList:Array = showTime.split(",");
         if(timeList.length < 2)
         {
            return true;
         }
         var d:Date = new Date();
         d.setTime(GameData.instance.playerData.systemTimes * 1000);
         var hours:int = d.hours;
         O.o("【妖怪服务器时间：】" + hours);
         if(hours >= timeList[0] && hours < timeList[1])
         {
            return true;
         }
         if(timeList.length > 2 && hours >= timeList[2] && hours < timeList[3])
         {
            return true;
         }
         if(timeList.length > 4 && hours >= timeList[4] && hours < timeList[5])
         {
            return true;
         }
         if(timeList.length > 6 && hours >= timeList[6] && hours < timeList[7])
         {
            return true;
         }
         return false;
      }
      
      private function reFreshone() : void
      {
         ++this.count1;
         if(this.count1 > 180)
         {
            this.count1 = 0;
            this.deleteAndReAddMonster(this.firstMarr);
         }
      }
      
      private function reFreshtwo() : void
      {
         ++this.count2;
         if(this.count2 > 190)
         {
            this.count2 = 0;
            this.deleteAndReAddMonster(this.secondMarr);
         }
      }
      
      private function reFreshthree() : void
      {
         ++this.count3;
         if(this.count3 > 200)
         {
            this.count3 = 0;
            this.deleteAndReAddMonster(this.thirdMarr);
         }
      }
      
      private function reFreshfour() : void
      {
         ++this.count4;
         if(this.count4 > 210)
         {
            this.count4 = 0;
            this.deleteAndReAddMonster(this.fourMarr);
         }
      }
      
      public function deleteAndReAddMonster(arr:Array) : void
      {
         var aiM:AIMonster = null;
         var monster:AIMonster = null;
         if(GameData.instance.playerData.copyScene == 2 || GameData.instance.playerData.copyScene == 1 || GameData.instance.playerData.copyScene == 3)
         {
            return;
         }
         var tempvar:int = Math.round(Math.random() * (arr.length - 1)) + 0;
         for each(aiM in this.aiList)
         {
            if(aiM.data.monsterId == arr[tempvar].monsterId)
            {
               this.aiList.splice(this.aiList.indexOf(aiM),1);
               aiM.dispos();
               break;
            }
         }
         monster = new AIMonster(arr[tempvar]);
         if(monster.data.initalRandom != 0)
         {
            if(this.isTimeToShow(monster.data.showTime) && Math.random() < monster.data.initalRandom)
            {
               monster.name = IdName.monster(arr[tempvar].monsterId);
               MapView.instance.addGameSprite(monster);
               this.aiList.push(monster);
            }
         }
         else
         {
            monster.name = IdName.monster(arr[tempvar].monsterId);
            MapView.instance.addGameSprite(monster);
            this.aiList.push(monster);
         }
      }
      
      public function deleteAIMonster(value:* = null) : void
      {
         var aiM:AIMonster = null;
         while(this.aiList.length > 0)
         {
            aiM = this.aiList.shift() as AIMonster;
            aiM.dispos();
         }
         this.count = 0;
         this.monsterList.length = 0;
      }
      
      public function addAIMonsterAtHome(params:Object) : void
      {
         var monster:AIMonster = null;
         var obj2:Object = null;
         var aiMonster:AIMonster = null;
         if(!params)
         {
            return;
         }
         for each(monster in MonsterManger.instance.homeAIM)
         {
            if(monster.data.id == params.id)
            {
               return;
            }
         }
         obj2 = {};
         obj2 = params;
         obj2.monsterType = 1;
         obj2.iscontinuemove = 0;
         obj2.monsterName = IdName.monster(Math.random() * 10 + Math.random() * 100 + Math.random() * 1000);
         obj2.isCopySence = false;
         obj2.count = 1;
         obj2.monsterflag = 1;
         obj2.CountGeniuscount = params.CountGeniuscount;
         aiMonster = new AIMonster(obj2,true);
         aiMonster.name = IdName.monster(obj2.iid);
         MapView.instance.addGameSprite(aiMonster);
         this.homeAIM.push(aiMonster);
      }
      
      public function deleteAIMonsterAtHome(params:Object) : void
      {
         var i:int = 0;
         var len:int = int(this.homeAIM.length);
         for(i = 0; i < len; i++)
         {
            if(Boolean(this.homeAIM[i].data) && Boolean(this.homeAIM[i].data.id) && this.homeAIM[i].data.id == params.id)
            {
               this.homeAIM[i].dispos();
               this.homeAIM.splice(i,1);
               break;
            }
         }
      }
      
      public function deleteAllMonsterAtHome() : void
      {
         var i:int = 0;
         if(this.homeAIM == null)
         {
            return;
         }
         var len:int = int(this.homeAIM.length);
         for(i = 0; i < len; i++)
         {
            this.homeAIM[i].dispos();
         }
         this.homeAIM = null;
      }
      
      public function addServerMonsterList(mList:Array) : void
      {
         var ssxml:XML;
         var itemList:XMLList = null;
         var i:int = 0;
         var id:int = 0;
         var item:XML = null;
         var obj2:Object = null;
         var xml:XML = null;
         var aiMonster:AIMonster = null;
         if(this.scenespirits == null)
         {
            return;
         }
         ssxml = this.scenespirits.children().(@id == GameData.instance.playerData.sceneId)[0];
         if(Boolean(ssxml))
         {
            itemList = ssxml.children();
         }
         if(Boolean(itemList))
         {
            for(i = 0; i < mList.length; i++)
            {
               id = int(mList[i]);
               item = itemList.(@id == id)[0];
               if(Boolean(item))
               {
                  obj2 = this.readMonster(item,1000);
                  obj2.monsterId = id;
                  obj2.monsterType = 1;
                  if(id == 1102 || id == 1271 || id == 1351)
                  {
                     obj2.levelList = [8,10,9];
                  }
                  obj2.monsterLevel = int(obj2.levelList[int(Math.random() * 3)]);
                  obj2.sid = this.combine1(int(obj2.monsterType),0,int(obj2.monsterId),int(obj2.monsterLevel));
                  obj2.monsterName = IdName.monster(Math.random() * 10 + Math.random() * 100 + Math.random() * 1000);
                  xml = XMLLocator.getInstance().getSprited(id);
                  if(xml == null)
                  {
                     obj2.labelName = "胡文鼎";
                  }
                  else
                  {
                     obj2.labelName = xml.name;
                  }
                  obj2.isCopySence = false;
                  this.monsterList.push(obj2);
                  aiMonster = new AIMonster(obj2);
                  aiMonster.name = IdName.monster(obj2.monsterId);
                  this.aiList.push(aiMonster);
                  MapView.instance.addGameSprite(aiMonster);
                  this.aiList.push(aiMonster);
               }
            }
         }
      }
      
      public function getMonsterById(monsterId:int) : AIMonster
      {
         var aiMon:AIMonster = null;
         var mon:AIMonster = null;
         var ran:Number = Math.random();
         if(ran > 0.5)
         {
            this.aiList.reverse();
         }
         for each(mon in this.aiList)
         {
            if(mon.data.monsterId == monsterId)
            {
               aiMon = mon;
               break;
            }
         }
         return aiMon;
      }
   }
}

