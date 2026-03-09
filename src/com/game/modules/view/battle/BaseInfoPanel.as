package com.game.modules.view.battle
{
   import com.game.Tools.AttributeCharacterIcon;
   import com.game.locators.GameData;
   import com.kb.util.CommonDefine;
   import com.publiccomponent.loading.XMLLocator;
   import com.publiccomponent.loading.data.BufInfoTypeData;
   import com.xygame.module.battle.battleItem.BufIcon;
   import com.xygame.module.battle.data.BattleDefine;
   import com.xygame.module.battle.data.BufData;
   import com.xygame.module.battle.data.SpiritData;
   import com.xygame.module.battle.util.DeepCopy;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.text.TextField;
   import flash.utils.Dictionary;
   
   public class BaseInfoPanel extends MovieClip
   {
      
      protected var inforPanelMc:MovieClip;
      
      protected var playerName:TextField;
      
      protected var playerHpNum:TextField;
      
      protected var playerHpBar:MovieClip;
      
      protected var playerLevel:TextField;
      
      protected var playerMask:Sprite;
      
      protected var otherName:TextField;
      
      protected var otherHpNum:TextField;
      
      protected var otherHpBar:MovieClip;
      
      protected var otherLevel:TextField;
      
      protected var otherMask:Sprite;
      
      protected var attrinfo:MovieClip;
      
      protected var _playerAttIcon:AttributeCharacterIcon;
      
      protected var _otherAttIcon:AttributeCharacterIcon;
      
      protected var playerinfo:*;
      
      protected var otherinfo:*;
      
      protected var playerBufArr:Array = [];
      
      protected var otherBufArr:Array = [];
      
      protected var pIconLoader:Loader;
      
      protected var oIconLoader:Loader;
      
      private var newdeal:Boolean = false;
      
      private var arraydeal:Boolean = false;
      
      private var _playerIcon:Vector.<BufIcon>;
      
      private var _otherIcon:Vector.<BufIcon>;
      
      public function BaseInfoPanel(mc:MovieClip)
      {
         super();
         this.inforPanelMc = mc;
         this.playerBufArr = [];
         this.otherBufArr = [];
         this._playerIcon = new Vector.<BufIcon>();
         this._otherIcon = new Vector.<BufIcon>();
         this.init();
      }
      
      protected function init() : void
      {
         this.playerName = this.inforPanelMc["playername"];
         this.otherName = this.inforPanelMc["othername"];
         this.playerLevel = this.inforPanelMc["playerLevel"];
         this.otherLevel = this.inforPanelMc["otherLevel"];
         this.playerHpNum = this.inforPanelMc["playerHpNum"];
         this.otherHpNum = this.inforPanelMc["otherHpNum"];
         this.playerHpBar = this.inforPanelMc["playerHP"];
         this.otherHpBar = this.inforPanelMc["otherHP"];
         this.attrinfo = this.inforPanelMc["attrinfo"];
         this.attrinfo.gotoAndStop(2);
         this.attrinfo.visible = false;
         this._playerAttIcon = new AttributeCharacterIcon();
         this._playerAttIcon.isShowAttWord = false;
         this.inforPanelMc["spPlayerAttr"].addChild(this._playerAttIcon);
         this._otherAttIcon = new AttributeCharacterIcon();
         this._otherAttIcon.isShowAttWord = false;
         this.inforPanelMc["spOtherAttr"].addChild(this._otherAttIcon);
         for(var i:int = 1; i < 7; i++)
         {
            this.inforPanelMc["s" + i].gotoAndStop(1);
            this.inforPanelMc["o" + i].gotoAndStop(1);
         }
         this.playerHpBar.gotoAndStop(1);
         this.otherHpBar.gotoAndStop(1);
         this.playerMask = this.inforPanelMc["playerMask"];
         this.otherMask = this.inforPanelMc["otherMask"];
      }
      
      public function setResult(playerobj:SpiritData, otherobj:SpiritData) : void
      {
         this.playerinfo = DeepCopy.copy(playerobj);
         this.otherinfo = DeepCopy.copy(otherobj);
         this.playerName.text = playerobj.name;
         this.otherName.text = otherobj.name;
         if(playerobj.hp < 0)
         {
            playerobj.hp = 0;
         }
         if(otherobj.hp < 0)
         {
            otherobj.hp = 0;
         }
         if(playerobj.hp > playerobj.maxhp)
         {
            playerobj.hp = playerobj.maxhp;
         }
         if(otherobj.hp > otherobj.maxhp)
         {
            otherobj.hp = otherobj.maxhp;
         }
         this.initOtherShowBool();
         this.initPlayerShowBool();
         this.playerHpBar.gotoAndStop(int(100 - 100 * playerobj.hp / playerobj.maxhp));
         var f:int = int(100 - 100 * otherobj.hp / otherobj.maxhp);
         f = f < 4 && f > 0 ? 4 : f;
         this.otherHpBar.gotoAndStop(f);
         this.addIcon();
         this._playerAttIcon.id = playerobj.elem;
         this._otherAttIcon.id = otherobj.elem;
         this.showBuf();
      }
      
      protected function initOtherShowBool() : void
      {
      }
      
      protected function initPlayerShowBool() : void
      {
      }
      
      protected function showBuf() : void
      {
         this.newdeal = true;
         if(!this.arraydeal)
         {
            this.newdeal = false;
            this.arraydeal = true;
            this.filterdIcon(this.playerBufArr,true);
            this.filterdIcon(this.otherBufArr,false);
            this.updateBuf();
            if(GameData.instance.lookBattle != 1)
            {
               this.countChange();
            }
            this.arraydeal = false;
            if(this.newdeal)
            {
               this.showBuf();
            }
         }
      }
      
      public function updateBuf() : void
      {
         this.addBufIcon(this.playerBufArr,true,this.playerinfo.spiritid);
         this.addBufIcon(this.otherBufArr,false,this.otherinfo.spiritid);
      }
      
      private function filterdIcon(ary:Array, isPayer:Boolean) : void
      {
         var item:BufData = null;
         var filteredAry:Vector.<BufIcon> = null;
         var filterAry:Vector.<BufIcon> = null;
         var icon:BufIcon = null;
         var idSet:Object = {};
         for each(item in ary)
         {
            idSet[item.bufIconId] = true;
         }
         filteredAry = new Vector.<BufIcon>();
         filterAry = isPayer ? this._playerIcon : this._otherIcon;
         for each(icon in filterAry)
         {
            if(Boolean(idSet[icon.bufid]))
            {
               filteredAry.push(icon);
            }
            else if(Boolean(icon.parent))
            {
               icon.parent.removeChild(icon);
            }
         }
         if(isPayer)
         {
            this._playerIcon = filteredAry;
         }
         else
         {
            this._otherIcon = filteredAry;
         }
      }
      
      private function addBufIcon(ary:Array, isPayer:Boolean, monsterID:int = 0) : void
      {
         var cached:BufIcon = null;
         var dir:int = 0;
         var item:BufData = null;
         var icon:BufIcon = null;
         var isNew:Boolean = false;
         var row:int = 0;
         var col:int = 0;
         var td:BufInfoTypeData = null;
         var showIndex:int = BattleDefine.instance.getBufShowIndex(isPayer ? 0 : 1);
         var icons:Vector.<BufIcon> = isPayer ? this._playerIcon : this._otherIcon;
         var iconMap:Dictionary = new Dictionary();
         for each(cached in icons)
         {
            iconMap[cached.bufid] = cached;
         }
         dir = isPayer ? 1 : -1;
         var baseX:int = isPayer ? 250 : 700;
         for each(item in ary)
         {
            if(!(item == null || item.bufName == null || item.bufName == ""))
            {
               icon = iconMap[item.bufIconId] as BufIcon;
               isNew = false;
               if(icon == null)
               {
                  if(ApplicationDomain.currentDomain.hasDefinition("buf" + item.bufIconId))
                  {
                     icon = new BufIcon(item);
                     isNew = true;
                  }
                  else
                  {
                     td = XMLLocator.getInstance().getBufInfo(item.bufIconId);
                     if(td == null || td.hide == 1)
                     {
                        continue;
                     }
                     icon = new BufIcon(td);
                     isNew = true;
                  }
               }
               row = int(showIndex / 4);
               col = showIndex % 4;
               icon.y = row * 40 + 50;
               icon.x = dir * (col * 50) + baseX;
               icon.setData(item,monsterID);
               icon.mouseChildren = false;
               this.inforPanelMc.addChild(icon);
               showIndex++;
               if(isNew)
               {
                  icons.push(icon);
                  iconMap[item.bufIconId] = icon;
               }
            }
         }
      }
      
      protected function countChange() : void
      {
      }
      
      protected function addIcon() : void
      {
         if(Boolean(this.pIconLoader) && this.inforPanelMc.contains(this.pIconLoader))
         {
            this.inforPanelMc.removeChild(this.pIconLoader);
         }
         if(this.pIconLoader == null)
         {
            this.pIconLoader = new Loader();
            this.pIconLoader.scaleY = 1.1;
            this.pIconLoader.scaleX = 1.1;
            this.pIconLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onPIconLoaderComp);
            this.pIconLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onTitleLoadError);
         }
         this.pIconLoader.load(new URLRequest("assets/monsterimg/" + this.playerinfo.srcid + ".swf"));
         if(Boolean(this.oIconLoader) && this.inforPanelMc.contains(this.oIconLoader))
         {
            this.inforPanelMc.removeChild(this.oIconLoader);
         }
         if(this.oIconLoader == null)
         {
            this.oIconLoader = new Loader();
            this.oIconLoader.scaleY = 1.1;
            this.oIconLoader.scaleX = 1.1;
            this.oIconLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onOIconLoaderComp);
            this.oIconLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onTitleLoadError);
         }
         this.oIconLoader.load(new URLRequest("assets/monsterimg/" + this.otherinfo.srcid + ".swf"));
      }
      
      private function onPIconLoaderComp(event:Event) : void
      {
         this.pIconLoader.x = this.playerMask.x;
         this.pIconLoader.y = this.playerMask.y;
         if(!this.inforPanelMc.contains(this.playerMask))
         {
            this.inforPanelMc.addChild(this.playerMask);
         }
         this.pIconLoader.mask = this.playerMask;
         if(Boolean(this.pIconLoader.content))
         {
            this.pIconLoader.content.scaleX = -this.pIconLoader.content.scaleX;
         }
         this.pIconLoader.x += this.pIconLoader.width;
         this.inforPanelMc.addChild(this.pIconLoader);
      }
      
      private function onOIconLoaderComp(event:Event) : void
      {
         this.oIconLoader.x = this.otherMask.x;
         this.oIconLoader.y = this.otherMask.y;
         if(!this.inforPanelMc.contains(this.otherMask))
         {
            this.inforPanelMc.addChild(this.otherMask);
         }
         this.oIconLoader.mask = this.otherMask;
         this.inforPanelMc.addChild(this.oIconLoader);
      }
      
      private function onTitleLoadError(event:IOErrorEvent) : void
      {
         O.o("加载的精魂头像不存在【发生在战斗里面】");
      }
      
      protected function removeBuf() : void
      {
         var child:DisplayObject = null;
         for(var i:int = this.inforPanelMc.numChildren - 1; i >= 0; i--)
         {
            child = this.inforPanelMc.getChildAt(i);
            if(child is BufIcon)
            {
               this.inforPanelMc.removeChildAt(i);
            }
         }
      }
      
      public function delBadBuf(self:Boolean) : void
      {
         var o:int = 0;
         var b:Boolean = false;
         if(self)
         {
            for(o = 0; o < this.playerBufArr.length; o++)
            {
               if(this.playerBufArr[o].bufid == 29 || 34 == this.playerBufArr[o].bufid || this.playerBufArr[o].bufid == 5 || this.playerBufArr[o].bufid == 7)
               {
                  this.playerBufArr.splice(o,1);
                  b = true;
               }
            }
         }
         else
         {
            for(o = 0; o < this.otherBufArr.length; o++)
            {
               if(this.otherBufArr[o].bufid == 29 || 34 == this.otherBufArr[o].bufid || 5 == this.otherBufArr[o].bufid || 7 == this.otherBufArr[o].bufid)
               {
                  this.otherBufArr.splice(o,1);
                  b = true;
               }
            }
         }
         if(b)
         {
            this.showBuf();
         }
      }
      
      public function attrInfo(value:int) : void
      {
         switch(value)
         {
            case 0:
               this.attrinfo.visible = false;
               break;
            default:
               this.attrinfo.visible = true;
               this.attrinfo.gotoAndStop(value);
         }
      }
      
      public function addblood(playerhp:int, otherhp:int) : void
      {
         this.playerinfo.hp = playerhp;
         this.otherinfo.hp = otherhp;
         this.initOtherShowBool();
         this.initPlayerShowBool();
         this.playerHpBar.gotoAndStop(int(100 - 100 * this.playerinfo.hp / this.playerinfo.maxhp));
         var f:int = int(100 - 100 * this.otherinfo.hp / this.otherinfo.maxhp);
         f = f < 4 && f > 0 ? 4 : f;
         this.otherHpBar.gotoAndStop(f);
         if(playerhp <= 0)
         {
            this.delAllBuf(this.playerinfo.sid);
         }
         if(otherhp <= 0)
         {
            this.delAllBuf(this.otherinfo.sid);
         }
      }
      
      public function otherHpChange(otherObj:SpiritData) : int
      {
         if(this.otherinfo)
         {
            return otherObj.hp - this.otherinfo.hp;
         }
         return 100000000;
      }
      
      public function playerHpChange(playerObj:SpiritData) : int
      {
         if(this.playerinfo)
         {
            return playerObj.hp - this.playerinfo.hp;
         }
         return 100000000;
      }
      
      public function delAllBuf(sid:int) : void
      {
         if(this.playerinfo == null)
         {
            return;
         }
         if(this.playerinfo.sid == sid)
         {
            this.playerBufArr = [];
         }
         if(this.otherinfo.sid == sid)
         {
            this.otherBufArr = [];
         }
         this.showBuf();
      }
      
      public function addBuf(value:Object) : void
      {
         var ov:int = 0;
         var p:int = 0;
         var o:int = 0;
         var bool:Boolean = true;
         if(value.bufid != 24)
         {
            if(value.defid == this.playerinfo.sid)
            {
               ov = int(value.offsetvalue);
               if(this.playerBufArr == null)
               {
                  this.playerBufArr = new Array();
               }
               for(p = 0; p < this.playerBufArr.length; p++)
               {
                  if(this.playerBufArr[p].bufid == value.bufid)
                  {
                     this.playerBufArr[p] = value;
                     bool = false;
                  }
                  else if(ov != 0 && this.playerBufArr[p].bufid == value.bufid + ov)
                  {
                     this.playerBufArr[p] = value;
                     bool = false;
                  }
               }
               if(bool)
               {
                  this.playerBufArr.push(value);
               }
            }
            else if(value.defid == this.otherinfo.sid)
            {
               ov = int(value.offsetvalue);
               if(this.otherBufArr == null)
               {
                  this.otherBufArr = new Array();
               }
               for(o = 0; o < this.otherBufArr.length; o++)
               {
                  if(this.otherBufArr[o].bufid == value.bufid)
                  {
                     this.otherBufArr[o] = value;
                     bool = false;
                  }
                  else if(ov != 0 && this.otherBufArr[o].bufid == value.bufid + ov)
                  {
                     this.otherBufArr[o] = value;
                     bool = false;
                  }
               }
               if(bool)
               {
                  this.otherBufArr.push(value);
               }
            }
            this.showBuf();
         }
      }
      
      public function delBuf(value:Object) : void
      {
         if(!value)
         {
            return;
         }
         var defId:int = int(value.defid);
         var bufId:int = int(value.bufid);
         if(this.playerinfo && this.playerinfo.sid == defId)
         {
            this.removeBufFromArray(this.playerBufArr,bufId);
         }
         if(this.otherinfo && this.otherinfo.sid == defId)
         {
            this.removeBufFromArray(this.otherBufArr,bufId);
         }
         this.showBuf();
      }
      
      private function removeBufFromArray(arr:Array, bufId:int) : void
      {
         var isBuff:Boolean = false;
         var d:BufData = null;
         if(!arr || arr.length == 0)
         {
            return;
         }
         isBuff = CommonDefine.BUF.indexOf(bufId) != -1;
         var isDebuff:Boolean = !isBuff && CommonDefine.DEBUFF.indexOf(bufId) != -1;
         for(var i:int = arr.length - 1; i >= 0; i--)
         {
            d = arr[i] as BufData;
            if(d)
            {
               if(!(d.bufid != bufId && d.bufIconId != bufId))
               {
                  if(isBuff)
                  {
                     if(d.param1 > 0)
                     {
                        arr.splice(i,1);
                     }
                  }
                  else if(isDebuff)
                  {
                     if(d.param1 < 0)
                     {
                        arr.splice(i,1);
                     }
                  }
                  else
                  {
                     arr.splice(i,1);
                  }
                  break;
               }
            }
         }
      }
      
      public function destroy() : void
      {
         if(Boolean(this._playerAttIcon))
         {
            this._playerAttIcon.dispose();
            this._playerAttIcon = null;
         }
         if(Boolean(this._otherAttIcon))
         {
            this._otherAttIcon.dispose();
            this._otherAttIcon = null;
         }
         this.removeBuf();
         if(Boolean(this.pIconLoader))
         {
            this.pIconLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onPIconLoaderComp);
            this.pIconLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onPIconLoaderComp);
            this.pIconLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onTitleLoadError);
         }
         this.pIconLoader = null;
         if(Boolean(this.oIconLoader))
         {
            this.oIconLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onOIconLoaderComp);
            this.oIconLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onOIconLoaderComp);
            this.oIconLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onTitleLoadError);
         }
         this.oIconLoader = null;
         this.playerinfo = null;
         this.otherinfo = null;
         while(this.inforPanelMc.numChildren > 0)
         {
            if(this.inforPanelMc.getChildAt(0) is MovieClip)
            {
               MovieClip(this.inforPanelMc.getChildAt(0)).stop();
            }
            this.inforPanelMc.removeChildAt(0);
         }
         this.inforPanelMc.stop();
         this.inforPanelMc = null;
      }
      
      public function getBuf(isPlayer:Boolean) : Vector.<BufIcon>
      {
         if(isPlayer)
         {
            return this._playerIcon;
         }
         return this._otherIcon;
      }
   }
}

