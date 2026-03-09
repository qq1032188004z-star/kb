package com.game.modules.view.battle.pop
{
   import com.game.Tools.AttributeCharacterIcon;
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.modules.control.monster.SpiritGenius;
   import com.game.modules.vo.WinPetVo;
   import com.game.util.DateUtil;
   import com.game.util.HLoaderSprite;
   import com.kb.util.CommonDefine;
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.loading.XMLLocator;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.net.URLRequest;
   
   public class WinPetView extends HLoaderSprite
   {
      
      private var _attIcon:AttributeCharacterIcon;
      
      private var data:WinPetVo;
      
      private var iloader:Loader;
      
      private var il:int;
      
      private var ii:int;
      
      private var f:ColorMatrixFilter = new ColorMatrixFilter([0.3,0.6,0,0,0,0.3,0.6,0,0,0,0.3,0.6,0,0,0,0,0,0,1,0]);
      
      public function WinPetView(value:WinPetVo)
      {
         super();
         this.data = value;
         this.init();
      }
      
      private function init() : void
      {
         this.url = "assets/battle/battlebg/winpet.swf";
      }
      
      override public function setShow() : void
      {
         var v1:int = 0;
         var v2:int = 0;
         var v3:int = 0;
         var v4:int = 0;
         var v5:int = 0;
         var v6:int = 0;
         this.bg.spCode.visible = DateUtil.isOpenCode();
         this.bg.spiritname.text = "" + this.data.spiritName;
         this.showpageInfo();
         this.bg.spiritlevel.text = "" + this.data.spiritLevel;
         this.bg.spirittype.text = "" + CommonDefine.moldList[this.data.spiritType - 1];
         this.bg.spirithp.text = "" + this.data.spiritHp;
         this.bg.spiritatk.text = "" + this.data.spiritAtk;
         this.bg.spiritdef.text = "" + this.data.spiritDef;
         this.bg.spiritmagatk.text = "" + this.data.spiritMagAtk;
         this.bg.spiritmagdef.text = "" + this.data.spiritMagDef;
         this.bg.spiritspeed.text = "" + this.data.spiritSpeed;
         this._attIcon = new AttributeCharacterIcon();
         this.bg.spAtt.addChild(this._attIcon);
         this._attIcon.id = this.data.spiritAttr;
         this.bg.sexMc.gotoAndStop(this.data.spiritsex);
         var xml:XML = XMLLocator.getInstance().spriteitem(this.data.spiritId);
         this.bg.groupClip.gotoAndStop(int(xml == null ? 1 : int(xml.group) + 1));
         v1 = SpiritGenius.cheakGenius(this.data.hpGeniusValue);
         v2 = SpiritGenius.cheakGenius(this.data.attackGeniusValue);
         v3 = SpiritGenius.cheakGenius(this.data.defenceGeniusValue);
         v4 = SpiritGenius.cheakGenius(this.data.speedGeniusValue);
         v5 = SpiritGenius.cheakGenius(this.data.magicGeniusValue);
         v6 = SpiritGenius.cheakGenius(this.data.resistanceGeniusValue);
         if(this.data != null && this.data.hpGeniusValue == 31)
         {
            this.bg.hpMc.gotoAndStop(7);
         }
         else
         {
            this.bg.hpMc.gotoAndStop(this.data == null ? 1 : v1);
         }
         if(this.data != null && this.data.attackGeniusValue == 31)
         {
            this.bg.attMc.gotoAndStop(7);
         }
         else
         {
            this.bg.attMc.gotoAndStop(this.data == null ? 1 : v2);
         }
         if(this.data != null && this.data.defenceGeniusValue == 31)
         {
            this.bg.defMc.gotoAndStop(7);
         }
         else
         {
            this.bg.defMc.gotoAndStop(this.data == null ? 1 : v3);
         }
         if(this.data != null && this.data.speedGeniusValue == 31)
         {
            this.bg.speedMc.gotoAndStop(7);
         }
         else
         {
            this.bg.speedMc.gotoAndStop(this.data == null ? 1 : v4);
         }
         if(this.data != null && this.data.magicGeniusValue == 31)
         {
            this.bg.magicMc.gotoAndStop(7);
         }
         else
         {
            this.bg.magicMc.gotoAndStop(this.data == null ? 1 : v5);
         }
         if(this.data != null && this.data.resistanceGeniusValue == 31)
         {
            this.bg.strMc.gotoAndStop(7);
         }
         else
         {
            this.bg.strMc.gotoAndStop(this.data == null ? 1 : v6);
         }
         this.bg.spiritindex.text = "" + SpiritGenius.countGenius(v1,v2,v3,v4,v5,v6);
         if(this.data.spiritsid == -1)
         {
            this.bg.nobtn.visible = false;
         }
         this.bg.okbtn.addEventListener(MouseEvent.CLICK,this.onClickOkHandler);
         this.bg.nobtn.addEventListener(MouseEvent.CLICK,this.onClickNoHandler);
         if(Boolean(this.data) && this.data.CaptureCode != null)
         {
            this.updateCode(this.data.CaptureCode);
         }
         this.loaderIcon();
      }
      
      public function updateCode(str:String) : void
      {
         if(DateUtil.isOpenCode())
         {
            this.bg.addChild(this.bg.spCode);
            this.bg.spCode["txtCode"].text = "编码：" + str;
         }
      }
      
      private function loaderIcon() : void
      {
         this.iloader = new Loader();
         this.iloader.load(new URLRequest(URLUtil.getSvnVer("assets/monsterswf/" + this.data.spiritId + ".swf")));
         this.iloader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.iconLoaderComp);
         this.iloader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onIOerrorHandler);
      }
      
      private function iconLoaderComp(event:Event) : void
      {
         this.iloader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.iconLoaderComp);
         this.iloader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOerrorHandler);
         if(this.iloader.height > 120)
         {
            this.iloader.scaleX = 109 / this.iloader.height;
            this.iloader.scaleY = 109 / this.iloader.height;
         }
         this.iloader.y = 73 + 3 - 10 + 55;
         this.iloader.x = 50 + 10 + 40;
         this.addChild(this.iloader);
      }
      
      private function onIOerrorHandler(event:IOErrorEvent) : void
      {
         O.o("精魂升级窗口【精魂头像】加载失败" + event);
         this.iloader.load(new URLRequest(URLUtil.getSvnVer("assets/monsterswf/10.swf")));
      }
      
      private function onClickOkHandler(event:MouseEvent) : void
      {
         this.dispatchEvent(new Event(Event.CLOSE));
         if(Boolean(this.parent) && this.parent.contains(this))
         {
            this.parent.removeChild(this);
         }
         this.disport();
      }
      
      private function showpageInfo() : void
      {
         this.il = this.data.spiritInfo.length;
         if(this.il <= 50)
         {
            this.bg.spiritinfo.text = "" + this.data.spiritInfo;
            this.bg["lb"].visible = false;
            this.bg["rb"].visible = false;
         }
         else
         {
            this.bg["lb"].filters = [this.f];
            this.bg["lb"].mouseEnabled = false;
            this.bg.spiritinfo.text = "" + this.data.spiritInfo.substr(0,50);
            this.bg["lb"].addEventListener(MouseEvent.CLICK,this.onClickLbHandler);
            this.bg["rb"].addEventListener(MouseEvent.CLICK,this.onClickRbHandler);
         }
      }
      
      private function onClickLbHandler(event:MouseEvent) : void
      {
         if(this.ii > 0)
         {
            --this.ii;
            this.bg.spiritinfo.text = "" + this.data.spiritInfo.substr(this.ii * 50,(this.ii + 1) * 50);
         }
         this.showLRB();
      }
      
      private function onClickRbHandler(event:MouseEvent) : void
      {
         if((this.ii + 1) * 50 < this.il)
         {
            ++this.ii;
            this.bg.spiritinfo.text = "" + this.data.spiritInfo.substr(this.ii * 50,(this.ii + 1) * 50);
         }
         this.showLRB();
      }
      
      private function showLRB() : void
      {
         if(this.ii * 50 < this.il && this.il < (this.ii + 1) * 50)
         {
            this.bg["rb"].filters = [this.f];
            this.bg["rb"].mouseEnabled = false;
         }
         else if((this.ii + 1) * 50 < this.il)
         {
            this.bg["rb"].filters = [];
            this.bg["rb"].mouseEnabled = true;
         }
         if(this.ii > 0)
         {
            this.bg["lb"].filters = [];
            this.bg["lb"].mouseEnabled = true;
         }
         else if(this.ii == 0)
         {
            this.bg["lb"].filters = [this.f];
            this.bg["lb"].mouseEnabled = false;
         }
      }
      
      private function onClickNoHandler(event:MouseEvent) : void
      {
         ApplicationFacade.getInstance().dispatch(EventConst.RELEASE_CATCH_SPIRIT,this.data);
         this.dispatchEvent(new Event(Event.CLOSE));
         if(Boolean(this.parent) && this.parent.contains(this))
         {
            this.parent.removeChild(this);
         }
         this.disport();
      }
      
      override public function disport() : void
      {
         if(Boolean(this._attIcon))
         {
            this._attIcon.dispose();
            this._attIcon = null;
         }
         if(bg && Boolean(bg.hasOwnProperty("okbtn")))
         {
            this.bg.okbtn.removeEventListener(MouseEvent.CLICK,this.onClickOkHandler);
            this.bg.nobtn.removeEventListener(MouseEvent.CLICK,this.onClickNoHandler);
            this.bg["lb"].removeEventListener(MouseEvent.CLICK,this.onClickLbHandler);
            this.bg["rb"].removeEventListener(MouseEvent.CLICK,this.onClickRbHandler);
         }
         if(Boolean(this.iloader))
         {
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

