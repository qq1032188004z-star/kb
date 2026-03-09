package com.game.modules.view.item
{
   import com.game.global.GlobalConfig;
   import com.game.global.ItemType;
   import com.game.locators.CacheData;
   import com.game.locators.GameData;
   import com.game.modules.view.BatchUseClip;
   import com.game.modules.view.HorseTip;
   import com.game.modules.view.HorseTipManager;
   import com.game.modules.view.monster.SymmEnum;
   import com.game.modules.view.monster.SymmTip;
   import com.game.util.BitValueUtil;
   import com.game.util.ColorUtil;
   import com.game.util.EggSpecTipAlert;
   import com.game.util.EggTipsManager;
   import com.game.util.HtmlUtil;
   import com.game.util.PropertyPool;
   import com.game.util.TimeTransform;
   import com.game.util.ToolTipStringUtil;
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.list.ItemRender;
   import com.publiccomponent.loading.XMLLocator;
   import com.publiccomponent.ui.ToolTip;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.net.URLRequest;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol858")]
   public class PackItem extends ItemRender
   {
      
      public var packImg:MovieClip;
      
      public var yiClip:MovieClip;
      
      public var numTxt:TextField;
      
      public var bgClip:MovieClip;
      
      public var cdClip:MovieClip;
      
      private var loader:Loader;
      
      private var horseList:Array = [530001,530002];
      
      private var horseTip:HorseTip;
      
      private var batchUse:BatchUseClip;
      
      public function PackItem()
      {
         super();
         this.numTxt.selectable = false;
         if(this.yiClip != null)
         {
            this.yiClip.gotoAndStop(1);
            this.yiClip.visible = false;
         }
         this.packImg.gotoAndStop(1);
         this.setChildIndex(this.numTxt,1);
         this.numTxt.text = "";
         this.loader = new Loader();
         this.hideCD();
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.callBack);
         this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onIoerror);
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoveFromStage);
         this.addEventListener(Event.ADDED_TO_STAGE,this.onAddToStage);
      }
      
      public function hideHorseTips() : void
      {
         HorseTipManager.getBatchUseTip().onRollOutHandler(null);
      }
      
      public function showCD() : void
      {
         this.cdClip.addFrameScript(this.cdClip.totalFrames - 1,null);
         this.cdClip.addFrameScript(this.cdClip.totalFrames - 1,this.hideCD);
         this.cdClip.visible = true;
         this.mouseChildren = false;
         this.mouseEnabled = false;
         this.cdClip.gotoAndPlay(1);
      }
      
      public function hideCD() : void
      {
         this.cdClip.gotoAndStop(1);
         this.cdClip.addFrameScript(this.cdClip.totalFrames - 1,null);
         this.mouseChildren = true;
         this.mouseEnabled = true;
         this.cdClip.visible = false;
      }
      
      private function onAddToStage(evt:Event) : void
      {
         this.removeEventListener(Event.ADDED_TO_STAGE,this.onAddToStage);
         super.data.isuse = this.yiClip.visible == false ? 1 : 2;
         if(Boolean(data.hasOwnProperty("expiretime")) && data.expiretime > 0)
         {
            this.initLimit(data);
         }
         else if(data.hasOwnProperty("count"))
         {
            if(!data.hasOwnProperty("usableStatus"))
            {
               data.usableStatus = 0;
            }
            this.init(data.packid,data.id,data.count,data.usableStatus);
         }
         else if(data.hasOwnProperty("eggId"))
         {
            this.initPresure(data);
         }
         else if(data.hasOwnProperty("symmId"))
         {
            this.initSymm(data);
         }
      }
      
      public function changeState(obj:Object) : void
      {
         if(data.hasOwnProperty("expiretime"))
         {
            obj.ttype = data.ttype;
            obj.expiretime = data.expiretime;
            obj.sn = data.sn;
         }
         super.data = obj;
         if(Boolean(this.horseTip))
         {
            this.horseTip.setData(obj);
         }
      }
      
      public function changeHp(hp:Number) : void
      {
         super.data.hp = hp;
         if(Boolean(this.horseTip))
         {
            this.horseTip.setData(data);
         }
      }
      
      private function onIoErrorHandler(event:IOErrorEvent) : void
      {
         O.o("道具加载失败");
      }
      
      override public function set data(params:Object) : void
      {
         super.data = params;
         if(Boolean(this.horseTip))
         {
            this.horseTip.setData(params);
         }
         if(Boolean(params.hasOwnProperty("cssj")) && params.cssj > 0)
         {
            this.packImg.gotoAndStop(2);
         }
         else
         {
            this.packImg.gotoAndStop(1);
         }
      }
      
      private function init(packid:int, idx:int, count:int, usableStatus:int) : void
      {
         var xml:XML = null;
         var desc:String = null;
         var distance:int = 0;
         var url:String = "";
         if(packid == ItemType.dressType)
         {
            this.buttonMode = true;
            url = URLUtil.getSvnVer("assets/tool/" + idx + ".swf");
            this.numTxt.text = "";
            if(this.horseList.indexOf(idx) != -1)
            {
               this.buttonMode = false;
               super.closeListener();
            }
            else
            {
               this.panduan(idx);
            }
         }
         else if(packid == ItemType.zuoqiType)
         {
            xml = XMLLocator.getInstance().tooldic[data.iid];
            this.buttonMode = true;
            url = URLUtil.getSvnVer("assets/tool/" + data.iid + ".swf");
            this.horsePanduan(data.id);
            this.horseTip = HorseTipManager.getHorseTip();
            if(data.iid >= 610001 && data.iid <= 610019)
            {
               if(xml != null)
               {
                  desc = xml.desc;
                  if(Boolean(data.hasOwnProperty("cssj")) && data.cssj > 0)
                  {
                     distance = data.cssj - GameData.instance.playerData.systemTimes;
                     desc += "<br/>" + HtmlUtil.getHtmlText(12,"#FF0000",TimeTransform.getInstance().transToDHM(distance) + "后出售");
                  }
                  ToolTip.setDOInfo(this,desc);
               }
            }
            else
            {
               this.horseTip.setData(super.data,GlobalConfig.userId);
               stage.addChild(this.horseTip);
               this.horseTip.visible = false;
            }
            this.addEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
            if(data.hasOwnProperty("expiretime"))
            {
               this.initLimit(data);
               return;
            }
         }
         else
         {
            url = URLUtil.getSvnVer("assets/tool/" + idx + ".swf");
            this.numTxt.text = "" + count;
            if((usableStatus & 0x0F) > 0)
            {
               this.buttonMode = true;
            }
         }
         this.loader.load(new URLRequest(url));
         desc = "";
         if(packid == ItemType.zuoqiType)
         {
            desc = ToolTipStringUtil.toPackTipString(data.iid);
         }
         else
         {
            desc = ToolTipStringUtil.toPackTipString(idx);
         }
         if(packid != ItemType.zuoqiType)
         {
            ToolTip.setDOInfo(this,desc);
         }
         if(CacheData.instance.openState == 2)
         {
            this.addEventListener(MouseEvent.ROLL_OVER,this.onBatchUseHandler);
            this.buttonMode = true;
         }
         else if(CacheData.instance.openState == 1 && idx == 103013)
         {
            this.addEventListener(MouseEvent.ROLL_OVER,this.onPackViewBatchUseHandler);
            this.buttonMode = true;
         }
         else
         {
            this.removeEventListener(MouseEvent.ROLL_OVER,this.onBatchUseHandler);
            this.removeEventListener(MouseEvent.ROLL_OVER,this.onPackViewBatchUseHandler);
         }
      }
      
      private function onRollOver(evt:MouseEvent) : void
      {
         var p:Point = null;
         if(Boolean(this.horseTip))
         {
            if(data.iid >= 610001 && data.iid <= 610019)
            {
               this.horseTip.visible = false;
            }
            else
            {
               p = new Point();
               p.x = evt.currentTarget.x;
               p.y = evt.currentTarget.y + evt.currentTarget.height;
               p = this.parent.localToGlobal(p);
               if(p.x + this.horseTip.width > 900)
               {
                  p.x -= this.horseTip.width;
               }
               if(p.y + this.horseTip.height > 550)
               {
                  p.y -= this.horseTip.height + evt.currentTarget.height;
               }
               this.horseTip.x = p.x;
               this.horseTip.y = p.y;
               this.horseTip.visible = true;
               this.horseTip.setData(data,GlobalConfig.userId);
            }
         }
      }
      
      private function onPackViewBatchUseHandler(e:MouseEvent) : void
      {
         if(GameData.instance.playerData.sceneType == 0 && GameData.instance.playerData.sceneId != 15000)
         {
            if(BitValueUtil.getBitValue(data.usableStatus,21) && Boolean(data.hasOwnProperty("count")) && data.count > 1)
            {
               HorseTipManager.getBatchUseTip().setData(this,data,28,55);
            }
            else
            {
               HorseTipManager.getBatchUseTip().onRollOutHandler(null);
            }
         }
      }
      
      private function onBatchUseHandler(e:MouseEvent) : void
      {
         if(GameData.instance.playerData.sceneType == 0 && GameData.instance.playerData.sceneId != 15000)
         {
            if(BitValueUtil.getBitValue(data.usableStatus,21) && Boolean(data.hasOwnProperty("count")) && data.count > 1)
            {
               HorseTipManager.getBatchUseTip().setData(this,data,28,55);
            }
            else
            {
               HorseTipManager.getBatchUseTip().onRollOutHandler(null);
            }
         }
      }
      
      public function setCount(count:int) : void
      {
         if(count == 0)
         {
            this.filters = ColorUtil.getColorMatrixFilterGray();
            this.numTxt.text = "0";
            data.count = count;
         }
         else
         {
            this.filters = [];
            this.numTxt.text = count + "";
            data.count = count;
         }
      }
      
      private function onRemoveFromStage(evt:Event) : void
      {
         this.removeEventListener(Event.ADDED_TO_STAGE,this.onAddToStage);
         this.removeEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
         this.removeEventListener(MouseEvent.ROLL_OVER,this.onBatchUseHandler);
         this.removeEventListener(MouseEvent.ROLL_OVER,this.onPackViewBatchUseHandler);
         HorseTipManager.getBatchUseTip().onRollOutHandler(null);
         this.hideCD();
         if(Boolean(this.horseTip))
         {
            this.horseTip.dispos();
         }
         this.horseTip = null;
         this.removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemoveFromStage);
         if(this.loader != null)
         {
            this.loader.unloadAndStop(false);
            if(this.packImg.contains(this.loader))
            {
               this.packImg.removeChild(this.loader);
            }
         }
         this.loader = null;
         if(data != null && Boolean(data.hasOwnProperty("symmId")))
         {
            SymmTip.LooseDO(this);
         }
         else
         {
            ToolTip.LooseDO(this);
         }
         super.dispos();
      }
      
      public function callBack(evt:Event) : void
      {
         if(this.loader == null)
         {
            return;
         }
         this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.callBack);
         this.packImg.addChildAt(this.loader,0);
      }
      
      private function onIoerror(evt:IOErrorEvent) : void
      {
         O.o("PackItem::onIoerror -- iid = " + data.iid);
      }
      
      private function panduan(idx:int) : void
      {
         var isInTaoZhuang:Boolean = GameData.instance.playerData.taozhuangId != 0;
         this.yiClip.gotoAndStop(1);
         if(GameData.instance.playerData.taozhuangId == idx)
         {
            this.yiClip.visible = true;
            return;
         }
         if(GameData.instance.playerData.hatId == idx && !isInTaoZhuang)
         {
            this.yiClip.visible = true;
         }
         if(GameData.instance.playerData.clothId == idx && !isInTaoZhuang)
         {
            this.yiClip.visible = true;
         }
         if(GameData.instance.playerData.faceId == idx && !isInTaoZhuang)
         {
            this.yiClip.visible = true;
         }
         if(GameData.instance.playerData.footId == idx && !isInTaoZhuang)
         {
            this.yiClip.visible = true;
         }
         if(GameData.instance.playerData.weaponId == idx && !isInTaoZhuang)
         {
            this.yiClip.visible = true;
         }
         if(GameData.instance.playerData.wingId == idx && !isInTaoZhuang)
         {
            this.yiClip.visible = true;
         }
         if(GameData.instance.playerData.glassId == idx && !isInTaoZhuang)
         {
            this.yiClip.visible = true;
         }
         if(GameData.instance.playerData.leftWeapon == idx && !isInTaoZhuang)
         {
            this.yiClip.visible = true;
         }
         if(GameData.instance.playerData.backgroundId == idx)
         {
            this.yiClip.visible = true;
         }
      }
      
      private function horsePanduan(idx:int) : void
      {
         if(GameData.instance.playerData.horseID != 0)
         {
            if(GameData.instance.playerData.horseIndex == idx)
            {
               this.yiClip.gotoAndStop(2);
               this.yiClip.visible = true;
            }
         }
      }
      
      private function initPresure(params:Object) : void
      {
         var defaultEgg:Array = null;
         var xml:XML = null;
         var desc:String = null;
         var idx:int = 0;
         var name:String = "";
         var configData:XML = PropertyPool.instance.getSpecifiedProp("spirit_egg") as XML;
         var eggList:XMLList = configData.egg;
         var len:int = int(eggList.length());
         for(var i:int = 0; i < len; i++)
         {
            if(eggList[i].iid == data.eggIid)
            {
               idx = int(eggList[i].@id);
               name = eggList[i].name;
               break;
            }
         }
         if(idx == 0)
         {
            defaultEgg = String(configData.elem).split(",");
            xml = XMLLocator.getInstance().getSprited(data.eggIid);
            idx = int(defaultEgg[xml.elem]);
            name = xml.name;
         }
         if(idx == 0)
         {
            return;
         }
         var url:String = URLUtil.getSvnVer("assets/tool/" + idx + ".swf");
         this.loader.load(new URLRequest(url));
         params.name = name;
         if(params.eggType == 3)
         {
            desc = HtmlUtil.getHtmlText(12,"#FF0000","【" + name + "】" + "精魄");
            desc += "\n描述:合天地之造化，蕴无上灵力之精魄。在妖怪培育舱中使用妖怪化形仪可以化形出" + name + "。";
            this.numTxt.text = "";
            ToolTip.setDOInfo(this,desc);
         }
         else
         {
            EggTipsManager.instance.bindTips(this,params,EggSpecTipAlert);
         }
      }
      
      private function initSymm(params:Object) : void
      {
         var url:String = URLUtil.getSvnVer("assets/tool/" + params.symmId + ".swf");
         this.loader.load(new URLRequest(url));
         var desc:String = SymmEnum.getTips(params);
         ToolTip.setDOInfo(this,desc);
         if(params.symmFlag > 0)
         {
            this.yiClip.visible = true;
         }
      }
      
      private function initLimit(params:Object) : void
      {
         var date:Date = null;
         var url:String = URLUtil.getSvnVer("assets/tool/" + (params.iid || params.id) + ".swf");
         this.loader.load(new URLRequest(url));
         var desc:String = ToolTipStringUtil.toPackTipString(int(params.iid) || int(params.id));
         if(GameData.instance.playerData.systemTimes >= params.expiretime)
         {
            desc += HtmlUtil.getHtmlText(12,"#FF0000","该物品已过期\n");
            this.loader.filters = ColorUtil.getColorMatrixFilterGray();
         }
         else
         {
            this.loader.filters = [];
            date = new Date(params.expiretime * 1000);
            desc += HtmlUtil.getHtmlText(12,"#FF0000",date.fullYear + "年" + int(date.month + 1) + "月" + date.date + "日" + " 到期\n");
            if(data.type == 81)
            {
               this.panduan(data.id);
            }
            else
            {
               this.horsePanduan(params.sn);
            }
         }
         ToolTip.setDOInfo(this,desc);
      }
   }
}

