package com.game.modules.view.battle.item
{
   import com.game.global.GlobalConfig;
   import com.xygame.module.battle.data.SpiritData;
   import com.xygame.module.battle.util.SpiritXmlData;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol824")]
   public class BattleSpirit extends MovieClip
   {
      
      public var nameText:TextField;
      
      public var levelText:TextField;
      
      public var hpText:TextField;
      
      public var hpbar:MovieClip;
      
      public var battleState:MovieClip;
      
      public var bgstate:MovieClip;
      
      public var mcRestraint:MovieClip;
      
      private var loader:Loader;
      
      private var loaderUrl:String;
      
      private var innerBorder:Shape;
      
      private var _curData:SpiritData;
      
      private var _defElem:int = -1;
      
      public function BattleSpirit(index:int = 0)
      {
         name = "spirit" + index;
         super();
         this.init();
      }
      
      private function init() : void
      {
         this.bgstate.gotoAndStop(1);
         this.mcRestraint.gotoAndStop(1);
         this.innerBorder = new Shape();
         this.innerBorder.graphics.clear();
         this.innerBorder.graphics.beginFill(16711680,1);
         this.innerBorder.graphics.drawCircle(0,0,25);
         this.innerBorder.graphics.endFill();
         this.innerBorder.x = 45;
         this.innerBorder.y = 70;
         this.buttonMode = true;
      }
      
      public function set spiritUrl(value:String) : void
      {
         this.loaderUrl = value;
         this.loaderSource();
      }
      
      private function loaderSource() : void
      {
         if(Boolean(this.loader) && this.contains(this.loader))
         {
            this.removeChild(this.loader);
            this.loader = null;
         }
         this.loader = new Loader();
         this.loader.load(new URLRequest(this.loaderUrl));
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onCompHandler);
         this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onIoErrorHandler);
      }
      
      private function onCompHandler(event:Event) : void
      {
         this.loader.x = 17;
         this.loader.y = 43;
         this.addChildAt(this.loader,this.numChildren - 1);
         this.loader.mask = this.innerBorder;
         this.addChild(this.innerBorder);
         this.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOverHandler);
         this.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOutHandler);
      }
      
      private function onIoErrorHandler(event:IOErrorEvent) : void
      {
         O.o("加载错误：战斗出战头像" + event);
      }
      
      private function onMouseOverHandler(event:MouseEvent) : void
      {
         this.bgstate.gotoAndStop(2);
      }
      
      private function onMouseOutHandler(event:MouseEvent) : void
      {
         this.bgstate.gotoAndStop(1);
      }
      
      private function setShow(showobj:Object) : void
      {
         this.nameText.text = showobj.name;
         this.levelText.text = "Lv." + showobj.level;
         this.hpText.text = showobj.hp + "/" + showobj.maxhp;
         this.hpbar.gotoAndStop(int(showobj.hp / showobj.maxhp * 100));
      }
      
      public function setData(data:SpiritData) : void
      {
         this._curData = data;
         this.nameText.text = this._curData.name;
         var isBoss:Boolean = this._curData.spiritid < 10000;
         this.levelText.text = "Lv." + (isBoss ? this._curData.level : "???");
         this.hpText.text = isBoss ? (this._curData.hp < 0 ? "0" : this._curData.hp) + "/" + this._curData.maxhp : "??/??";
         this.spiritUrl = "assets/monsterimg/" + this._curData.srcid + ".swf";
         this.hpbar.gotoAndStop(int((this._curData.hp < 0 ? 0 : this._curData.hp) / this._curData.maxhp * 100));
         mouseChildren = false;
         filters = [];
         if(this._curData.state == 1)
         {
            this.battleState.visible = true;
            this.battleState.gotoAndStop(1);
         }
         else if(this._curData.hp <= 0)
         {
            this.battleState.visible = true;
            this.battleState.gotoAndStop(2);
         }
         else
         {
            this.battleState.visible = false;
         }
         this.attrInfo();
      }
      
      public function attrInfo(defElem:int = -1) : void
      {
         if(GlobalConfig.is_show_restraint == 1)
         {
            this.mcRestraint.gotoAndStop(1);
            return;
         }
         if(defElem != -1)
         {
            this._defElem = defElem;
         }
         if(this._curData == null || this._defElem == -1)
         {
            return;
         }
         var value:int = SpiritXmlData.instance.attrInfo(this._curData.elem,this._defElem);
         this.mcRestraint.gotoAndStop(value + 1);
      }
      
      public function destroy() : void
      {
         if(Boolean(this.loader))
         {
            this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onCompHandler);
            this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onIoErrorHandler);
            if(this.contains(this.loader))
            {
               this.removeChild(this.loader);
            }
            this.loader.unloadAndStop();
         }
         this.loader = null;
         while(this.numChildren > 0)
         {
            this.removeChildAt(0);
         }
         this.removeEventListener(MouseEvent.MOUSE_OVER,this.onMouseOverHandler);
         this.removeEventListener(MouseEvent.MOUSE_OUT,this.onMouseOutHandler);
      }
   }
}

