package com.game.modules.view.monsteridentify
{
   import com.game.util.HLoaderSprite;
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.loading.XMLLocator;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.utils.ByteArray;
   
   public class MonidResult extends HLoaderSprite
   {
      
      private var imgloader:Loader;
      
      public var tempData:Object;
      
      public var packiid:int;
      
      private var resultMc:MovieClip;
      
      private var urlloader:URLLoader;
      
      private var xmldate:XML;
      
      private var growxml:XMLList;
      
      private var moldxml:XMLList;
      
      private var textxml:XMLList;
      
      private var shapMask:Shape;
      
      public function MonidResult()
      {
         super();
         this.graphics.beginFill(0,0);
         this.graphics.drawRect(-1000,-1000,2000,2000);
         this.graphics.endFill();
         this.imgloader = new Loader();
         this.url = "assets/monsteridentify/monsteridentify3.swf";
         this.shapMask = new Shape();
         this.shapMask.graphics.beginFill(16711680,1);
         this.shapMask.graphics.drawCircle(239.5,180,32);
         this.shapMask.graphics.endFill();
      }
      
      override public function setShow() : void
      {
         this.resultMc = bg;
         this.resultMc.cacheAsBitmap = true;
         this.addChild(this.imgloader);
         this.imgloader.x = 211;
         this.imgloader.y = 148;
         this.addChild(this.shapMask);
         this.imgloader.mask = this.shapMask;
         this.resultMc.guanbi.addEventListener(MouseEvent.CLICK,this.closeWindow);
         this.urlloader = new URLLoader();
         this.urlloader.dataFormat = URLLoaderDataFormat.BINARY;
         this.urlloader.load(new URLRequest(URLUtil.getSvnVer("config/monsterresult")));
         this.urlloader.addEventListener(Event.COMPLETE,this.onURLComplete);
      }
      
      override public function initParams(params:Object = null) : void
      {
         this.tempData = params.monsterdetail;
         this.packiid = params.packIID;
         this.showimg();
      }
      
      private function onURLComplete(evt:Event) : void
      {
         this.urlloader.removeEventListener(Event.COMPLETE,this.onURLComplete);
         var byte:ByteArray = ByteArray(this.urlloader.data);
         byte.uncompress();
         this.xmldate = new XML(byte.readUTFBytes(byte.bytesAvailable));
         this.growxml = this.xmldate.growids.children();
         this.moldxml = this.xmldate.moldids.children();
         this.textxml = this.xmldate.texts.children();
         this.build();
      }
      
      public function build() : void
      {
         var hp:Number = NaN;
         var attack:Number = NaN;
         var magic:Number = NaN;
         var speed:Number = NaN;
         var defence:Number = NaN;
         var resistance:Number = NaN;
         var hpgrowup:int = 0;
         var attackgrowup:int = 0;
         var magicgrowup:int = 0;
         var speedgrowup:int = 0;
         var defencegrowup:int = 0;
         var resistancegrowup:int = 0;
         var modo:String = null;
         var nextmonsterid:int = 0;
         var xml:XML = null;
         var nextid:int = 0;
         var groupid:int = 0;
         var genius:int = 0;
         var sumstar:int = 0;
         if(this.resultMc != null)
         {
            this.resultMc.spiritname.text = this.tempData == null ? "" : this.tempData.name;
            this.resultMc.zizhi.text = this.tempData == null ? "" : this.tempData.CountGeniuscount;
            xml = XMLLocator.getInstance().getSprited(this.tempData.iid);
            nextid = int(xml.nextmonsterid);
            groupid = int(xml.growup);
            while(nextid != 0)
            {
               groupid = int(xml.growup);
               nextid = int(xml.nextmonsterid);
            }
            hpgrowup = int(this.growxml.(@id == groupid).strength);
            attackgrowup = int(this.growxml.(@id == groupid).attack);
            magicgrowup = int(this.growxml.(@id == groupid).magic);
            speedgrowup = int(this.growxml.(@id == groupid).speed);
            defencegrowup = int(this.growxml.(@id == groupid).defence);
            resistancegrowup = int(this.growxml.(@id == groupid).resistance);
            hp = hpgrowup * 2 + this.tempData.hpGeniusValue + 110;
            attack = (attackgrowup * 2 + this.tempData.attackGeniusValue + 5) * this.moldxml.(@id == tempData.mold).attack;
            magic = (magicgrowup * 2 + this.tempData.magicGeniusValue + 5) * this.moldxml.(@id == tempData.mold).magic;
            speed = (speedgrowup * 2 + this.tempData.speedGeniusValue + 5) * this.moldxml.(@id == tempData.mold).speed;
            defence = (defencegrowup * 2 + this.tempData.defenceGeniusValue + 5) * this.moldxml.(@id == tempData.mold).defence;
            resistance = (resistancegrowup * 2 + this.tempData.resistanceGeniusValue + 5) * this.moldxml.(@id == tempData.mold).resistance;
            this.resultMc.tilistar.gotoAndStop(this.getstar("hp",hp));
            this.resultMc.gongjistar.gotoAndStop(this.getstar("attack",attack));
            this.resultMc.fangyustar.gotoAndStop(this.getstar("defence",defence));
            this.resultMc.sudustar.gotoAndStop(this.getstar("speed",speed));
            this.resultMc.fashustar.gotoAndStop(this.getstar("magic",magic));
            this.resultMc.kangxingstar.gotoAndStop(this.getstar("resistance",resistance));
            switch(this.tempData.CountGeniuscount)
            {
               case "泛泛之辈":
                  genius = 1;
                  break;
               case "璞玉之质":
                  genius = 2;
                  break;
               case "百里挑一":
                  genius = 3;
                  break;
               case "千载难逢":
                  genius = 4;
                  break;
               case "万众瞩目":
                  genius = 5;
                  break;
               case "绝代妖王":
                  genius = 5;
            }
            sumstar = genius + this.getstar("hp",hp) - 1 + this.getstar("attack",attack) - 1 + this.getstar("defence",defence) - 1 + this.getstar("speed",speed) - 1 + this.getstar("magic",magic) - 1 + this.getstar("resistance",resistance) - 1;
            if(0 < sumstar && sumstar <= 14)
            {
               this.resultMc.star.gotoAndStop(1);
            }
            if(14 < sumstar && sumstar <= 18)
            {
               this.resultMc.star.gotoAndStop(2);
            }
            if(18 < sumstar && sumstar <= 22)
            {
               this.resultMc.star.gotoAndStop(3);
            }
            if(22 < sumstar)
            {
               this.resultMc.star.gotoAndStop(4);
            }
            this.resultMc.tili.text = this.gettext("hp",this.getstar("hp",hp));
            this.resultMc.gongji.text = this.gettext("attack",this.getstar("attack",attack));
            this.resultMc.fangyu.text = this.gettext("defence",this.getstar("defence",defence));
            this.resultMc.sudu.text = this.gettext("speed",this.getstar("speed",speed));
            this.resultMc.fashu.text = this.gettext("magic",this.getstar("magic",magic));
            this.resultMc.kangxing.text = this.gettext("resistance",this.getstar("resistance",resistance));
         }
      }
      
      public function showimg() : void
      {
         this.imgloader.unload();
         this.imgloader.load(new URLRequest(URLUtil.getSvnVer("assets/monsterimg/" + this.packiid + ".swf")));
         this.build();
      }
      
      private function gettext(value:String, i:int) : String
      {
         return this.textxml.(@id == value).children().(@id == i).text;
      }
      
      private function getstar(name:String, value:Number) : int
      {
         switch(name)
         {
            case "hp":
               if(0 < value && value <= 280)
               {
                  return 2;
               }
               if(280 < value && value <= 300)
               {
                  return 3;
               }
               if(300 < value && value <= 320)
               {
                  return 4;
               }
               if(320 < value && value <= 340)
               {
                  return 5;
               }
               if(340 < value)
               {
                  return 6;
               }
            case "attack":
               if(0 < value && value <= 195)
               {
                  return 2;
               }
               if(195 < value && value <= 215)
               {
                  return 3;
               }
               if(215 < value && value <= 235)
               {
                  return 4;
               }
               if(235 < value && value <= 255)
               {
                  return 5;
               }
               if(255 < value)
               {
                  return 6;
               }
            case "defence":
               if(0 < value && value <= 175)
               {
                  return 2;
               }
               if(175 < value && value <= 195)
               {
                  return 3;
               }
               if(195 < value && value <= 215)
               {
                  return 4;
               }
               if(215 < value && value <= 235)
               {
                  return 5;
               }
               if(235 < value)
               {
                  return 6;
               }
            case "magic":
               if(0 < value && value <= 195)
               {
                  return 2;
               }
               if(195 < value && value <= 215)
               {
                  return 3;
               }
               if(215 < value && value <= 235)
               {
                  return 4;
               }
               if(235 < value && value <= 255)
               {
                  return 5;
               }
               if(255 < value)
               {
                  return 6;
               }
            case "resistance":
               if(0 < value && value <= 175)
               {
                  return 2;
               }
               if(175 < value && value <= 195)
               {
                  return 3;
               }
               if(195 < value && value <= 215)
               {
                  return 4;
               }
               if(215 < value && value <= 235)
               {
                  return 5;
               }
               if(235 < value)
               {
                  return 6;
               }
            case "speed":
               if(0 < value && value <= 175)
               {
                  return 2;
               }
               if(175 < value && value <= 195)
               {
                  return 3;
               }
               if(195 < value && value <= 215)
               {
                  return 4;
               }
               if(215 < value && value <= 235)
               {
                  return 5;
               }
               if(235 < value)
               {
                  return 6;
               }
         }
         return 1;
      }
      
      private function closeWindow(evt:MouseEvent) : void
      {
         if(Boolean(this.imgloader))
         {
            this.imgloader.unloadAndStop(false);
         }
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
      
      override public function disport() : void
      {
         if(Boolean(this.imgloader))
         {
            this.imgloader.unloadAndStop(false);
         }
         if(Boolean(this.parent) && this.parent.contains(this))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

