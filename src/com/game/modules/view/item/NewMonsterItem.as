package com.game.modules.view.item
{
   import com.game.util.ColorUtil;
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.events.ItemClickEvent;
   import com.publiccomponent.ui.ToolTip;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1209")]
   public class NewMonsterItem extends Sprite
   {
      
      public var nameTxt:TextField;
      
      public var levelTxt:TextField;
      
      public var hpTxt:TextField;
      
      public var hpMc:MovieClip;
      
      public var sealClip:MovieClip;
      
      private var loader:Loader;
      
      private var _data:Object;
      
      private var innerMask:Sprite;
      
      public function NewMonsterItem(isBig:Boolean)
      {
         super();
         this.hpMc.stop();
         this.loader = new Loader();
         this.loader.x = isBig ? 4 : 6;
         this.loader.y = isBig ? 21 : 35;
         this.loader.scaleY = isBig ? 1.2 : 1;
         this.loader.scaleX = isBig ? 1.2 : 1;
         this.setCircleMask(this.loader,isBig ? 32 : 28,36,isBig ? 55 : 63);
         this.levelTxt.y = isBig ? 5 : 23;
         this.sealClip.y = isBig ? 5 : 23;
         this.mouseChildren = true;
         this.mouseEnabled = true;
         this.buttonMode = true;
         this.nameTxt.selectable = false;
         this.levelTxt.selectable = false;
         this.hpTxt.selectable = false;
         this.sealClip.gotoAndStop(3);
         this.addEventListener(MouseEvent.CLICK,this.onClickHandler);
      }
      
      private function showSeal() : void
      {
         ToolTip.LooseDO(this.sealClip);
         if(Boolean(this._data) && this._data.forbitItem == 100453)
         {
            this.sealClip.gotoAndStop(1);
            ToolTip.BindDO(this.sealClip,"这只妖怪已被封印，无法使用各类洗髓丹或造化丹。");
         }
         else if(Boolean(this._data) && this._data.forbitItem == 100454)
         {
            this.sealClip.gotoAndStop(2);
         }
         else
         {
            this.sealClip.gotoAndStop(3);
         }
      }
      
      public function set data(params:Object) : void
      {
         var qq:int = 0;
         var ww:int = 0;
         var isNew:Boolean = true;
         if(this._data != null && this._data["id"] == params["id"])
         {
            isNew = false;
         }
         this._data = params;
         this.nameTxt.text = params.name;
         this.levelTxt.text = "LV." + params.level;
         if(params.hasOwnProperty("hp"))
         {
            this.hpTxt.text = params.hp + "/" + params.strength;
            qq = int(params.hp / params.strength * 100);
            ww = Math.floor(qq);
            this.hpMc.gotoAndStop(100 - ww + 1);
            if(params.hp == 0)
            {
               this.filters = ColorUtil.getColorMatrixFilterGray();
            }
            else
            {
               this.filters = [];
            }
         }
         if(params.hasOwnProperty("currentexp"))
         {
            this.hpTxt.text = "";
         }
         try
         {
            if(isNew)
            {
               this.loader.load(new URLRequest(URLUtil.getSvnVer("assets/monsterimg/" + params.iid + ".swf")));
               addChildAt(this.loader,0);
            }
         }
         catch(e:*)
         {
         }
         this.showSeal();
      }
      
      public function setCircleMask(maskParent:*, mr:int, mx:int = 0, my:int = 0, color:uint = 16711680) : void
      {
         this.innerMask = new Sprite();
         this.innerMask.graphics.clear();
         this.innerMask.graphics.beginFill(color,1);
         this.innerMask.graphics.drawCircle(mx,my,mr);
         this.innerMask.graphics.endFill();
         if(maskParent)
         {
            maskParent.mask = this.innerMask;
         }
         this.addChild(this.innerMask);
         super.hitArea = this.innerMask;
      }
      
      public function dispos() : void
      {
         if(this.loader != null)
         {
            this.loader.unloadAndStop(false);
            if(this.contains(this.loader))
            {
               this.removeChild(this.loader);
            }
            this.loader = null;
         }
         if(this.innerMask != null)
         {
            this.innerMask.graphics.clear();
            if(this.contains(this.innerMask))
            {
               this.removeChild(this.innerMask);
            }
            this.innerMask = null;
         }
         this.removeEventListener(MouseEvent.CLICK,this.onClickHandler);
      }
      
      private function onClickHandler(event:MouseEvent) : void
      {
         dispatchEvent(new ItemClickEvent(ItemClickEvent.ITEMCLICKEVENT));
      }
      
      public function get data() : Object
      {
         return this._data;
      }
   }
}

