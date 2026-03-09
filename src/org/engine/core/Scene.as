package org.engine.core
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.utils.ByteArray;
   import org.engine.game.MoveSprite;
   import org.engine.util.ConfigLoader;
   import org.engine.util.LoaderUtil;
   
   public class Scene
   {
      
      private var scene_bg:*;
      
      private var old_bg:*;
      
      public var spriteList:Array = [];
      
      public var map:GridMap;
      
      public var config:XML;
      
      public var isScroll:Boolean;
      
      private var configLoader:ConfigLoader;
      
      private var loaderUtil:LoaderUtil;
      
      public var bottom:Number = 0;
      
      public var right:Number = 0;
      
      public var isAllDisplay:Boolean = true;
      
      public function Scene(gw:Number = 0, gh:Number = 0, gs:Number = 0)
      {
         super();
         this.map = new GridMap(gw,gh,gs);
         this.configLoader = new ConfigLoader();
         this.loaderUtil = new LoaderUtil();
      }
      
      public function changeGridSize(gw:int, gh:int, gs:int) : void
      {
         this.map.initGrids(gw,gh,gs);
      }
      
      public function changeConfig(configURL:String) : void
      {
         this.configLoader.loadConfig(configURL,this.onConfigLoaded);
      }
      
      private function onConfigLoaded(byte:ByteArray) : void
      {
         var xml:XML = new XML(byte.readUTFBytes(byte.bytesAvailable));
         this.map.setBlocks(xml.path);
      }
      
      public function changeBg(url:String) : void
      {
         this.loaderUtil.load(url,this.onBgLoaded);
      }
      
      private function onBgLoaded(disPlay:Loader) : void
      {
         disPlay.x = this.scene_bg.x;
         disPlay.y = this.scene_bg.y;
         this.scene_bg = disPlay;
      }
      
      public function add(s:GameSprite, lastSceneId:int = 0) : void
      {
         s.scene = this;
         this.spriteList.push(s);
      }
      
      public function get isBig() : Boolean
      {
         if(Boolean(this.config) && Boolean(this.config.hasOwnProperty("@isBig")))
         {
            return int(this.config.@isBig) != 0;
         }
         return false;
      }
      
      public function set bg(disPlay:DisplayObject) : void
      {
         this.scene_bg = disPlay;
         this.bottom = Math.round(disPlay.height - 570);
         this.right = Math.round(disPlay.width - 970);
      }
      
      public function scalescene(value:Number) : void
      {
         this.bottom = Math.round(this.scene_bg.height * value - 570);
         this.right = Math.round(this.scene_bg.width * value - 970);
      }
      
      public function get bg() : *
      {
         return this.scene_bg;
      }
      
      public function getStaticBg() : BitmapData
      {
         var bitdata:BitmapData = null;
         if(this.scene_bg)
         {
            bitdata = new BitmapData(this.scene_bg.width,this.scene_bg.height);
            bitdata.draw(this.scene_bg);
            return bitdata;
         }
         return null;
      }
      
      public function stop() : void
      {
         var bitMap:Bitmap = new Bitmap();
         bitMap.bitmapData = this.getStaticBg();
         this.scene_bg = bitMap;
      }
      
      public function play() : void
      {
         this.scene_bg = this.old_bg;
      }
      
      public function setBlocks(bitmapstr:String) : void
      {
         this.map.setBlocks(bitmapstr);
      }
      
      public function clear() : void
      {
         var item:GameSprite = null;
         var obj:MoveSprite = null;
         while(this.spriteList.length > 0)
         {
            item = this.spriteList.shift() as GameSprite;
            if(item is MoveSprite)
            {
               while(MoveSprite(item).followers.length > 0)
               {
                  obj = MoveSprite(item).followers.shift();
                  obj["dispos"]();
               }
            }
            if(item != null)
            {
               item.dispos();
            }
            item = null;
         }
         this.spriteList = [];
         if(Boolean(this.configLoader))
         {
            this.configLoader.dispos();
         }
         this.configLoader = null;
         if(Boolean(this.loaderUtil))
         {
            this.loaderUtil.dispos();
         }
         this.loaderUtil = null;
      }
      
      public function findBySequenceId(sequenceId:int) : GameSprite
      {
         var item:GameSprite = null;
         for each(item in this.spriteList)
         {
            if(item.sequenceID == sequenceId)
            {
               return item;
            }
         }
         return null;
      }
      
      public function findByName(name:String) : GameSprite
      {
         var item:GameSprite = null;
         for each(item in this.spriteList)
         {
            if(item.spriteName == name)
            {
               return item;
            }
         }
         return null;
      }
      
      public function findLinkdGameSprites(linkName:String) : Array
      {
         var item:GameSprite = null;
         var result:Array = [];
         for each(item in this.spriteList)
         {
            if(item.spriteName.indexOf(linkName) != -1)
            {
               result.push(item);
            }
         }
         return result;
      }
      
      public function removeBySequenceId(sequenceId:int) : void
      {
         var item:GameSprite = null;
         for(var i:int = 0; i < this.spriteList.length; i++)
         {
            item = this.spriteList[i] as GameSprite;
            if(item.sequenceID == sequenceId)
            {
               this.spriteList.splice(i,1);
               item.dispos();
               break;
            }
         }
      }
      
      public function removeByName(name:String) : void
      {
         var item:GameSprite = null;
         for(var i:int = 0; i < this.spriteList.length; i++)
         {
            item = this.spriteList[i] as GameSprite;
            if(item.spriteName == name)
            {
               this.spriteList.splice(i,1);
               item.dispos();
               break;
            }
         }
      }
      
      public function setSomePlaceCanMove(s:GameSprite) : void
      {
         var j:int = 0;
         var indexList:Array = [];
         var minx:int = s.x;
         var miny:int = s.y;
         var maxx:int = s.maxX;
         var maxy:int = s.maxY;
         for(var i:int = minx; i < maxx; i++)
         {
            for(j = miny; j < maxy; j++)
            {
               indexList[indexList.length] = this.map.getIndexObjByPos(i,j);
            }
         }
         this.map.enableSomePlace(indexList);
      }
      
      public function setSomePlaceCanNotMove(s:GameSprite) : void
      {
         var j:int = 0;
         var indexList:Array = [];
         var minx:int = s.x;
         var miny:int = s.y;
         var maxx:int = s.maxX;
         var maxy:int = s.maxY;
         for(var i:int = minx; i < maxx; i++)
         {
            for(j = miny; j < maxy; j++)
            {
               indexList[indexList.length] = this.map.getIndexObjByPos(i,j);
            }
         }
         this.map.diableSomePlace(indexList);
      }
      
      public function remove(s:GameSprite) : void
      {
         var index:int = int(this.spriteList.indexOf(s));
         if(index < 0)
         {
            return;
         }
         this.spriteList.splice(index,1);
      }
      
      public function loadSingleBuild(params:Object) : void
      {
         var item:GameSprite = this.findBySequenceId(123456);
         if(item != null)
         {
            item.dispos();
         }
         item = new GameSprite();
         item.scene = this;
         item.spriteName = params.name;
         item.sequenceID = params.id;
         item.url = params.url;
         item.x = params.x;
         item.y = params.y;
         if(params.mouseValue == 1)
         {
            item.isSupportMouse = false;
         }
         if(params.dy != null)
         {
            item.dymaicY = params.dy;
         }
         this.spriteList.push(item);
      }
      
      public function initSceneSpriteByXml() : void
      {
         var nodes:XMLList = null;
         var nodelen:int = 0;
         var i:int = 0;
         var node:XML = null;
         var item:GameSprite = null;
         if(this.config != null)
         {
            nodes = this.config.child("node");
            if(nodes == null)
            {
               return;
            }
            nodelen = int(nodes.length());
            for(i = 0; i < nodelen; i++)
            {
               node = nodes[i] as XML;
               if(node.@type == 4)
               {
                  item = new GameSprite();
                  item.scene = this;
                  item.spriteName = node.@name;
                  item.sequenceID = node.@id;
                  item.url = node.@url;
                  item.x = node.@x;
                  item.y = node.@y;
                  if(node.@mouseValue == 1)
                  {
                     item.isSupportMouse = false;
                  }
                  if(node.@dy != null)
                  {
                     item.dymaicY = node.@dy;
                  }
                  this.spriteList.push(item);
               }
            }
         }
      }
   }
}

