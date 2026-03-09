package com.game.modules.view.item
{
   import com.game.util.ColorUtil;
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.list.ItemRender;
   import com.publiccomponent.ui.ToolTip;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.net.URLRequest;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol937")]
   public class MonsterItem extends ItemRender
   {
      
      public var nameTxt:TextField;
      
      public var levelTxt:TextField;
      
      public var hpTxt:TextField;
      
      public var hpMc:MovieClip;
      
      public var sealClip:MovieClip;
      
      private var loader:Loader;
      
      private var imgMc:MovieClip;
      
      private var innerMask:Sprite;
      
      public function MonsterItem()
      {
         super();
         this.stop();
         this.hpMc.stop();
         this.loader = new Loader();
         this.loader.x = 15;
         this.loader.y = 10;
         this.mouseChildren = true;
         this.mouseEnabled = true;
         this.buttonMode = true;
         this.nameTxt.selectable = false;
         this.levelTxt.selectable = false;
         this.hpTxt.selectable = false;
         this.sealClip.gotoAndStop(3);
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoveFromStage);
      }
      
      private function showSeal() : void
      {
         ToolTip.LooseDO(this.sealClip);
         if(Boolean(data) && data.forbitItem == 100453)
         {
            this.sealClip.gotoAndStop(1);
            ToolTip.BindDO(this.sealClip,"这只妖怪已被封印，无法使用各类洗髓丹或造化丹。");
         }
         else if(Boolean(data) && data.forbitItem == 100454)
         {
            this.sealClip.gotoAndStop(2);
         }
         else
         {
            this.sealClip.gotoAndStop(3);
         }
      }
      
      override public function set data(params:Object) : void
      {
         var qq:int = 0;
         var ww:int = 0;
         super.data = params;
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
               if(params.isfirst == 1)
               {
                  this.setSelect(3);
               }
               this.filters = [];
            }
         }
         if(params.hasOwnProperty("currentexp"))
         {
            this.hpTxt.text = "";
         }
         try
         {
            this.loader.load(new URLRequest(URLUtil.getSvnVer("assets/monsterimg/" + params.iid + ".swf")));
            this.loader.scaleX = 1;
            this.loader.scaleY = 1;
            addChild(this.loader);
            this.setCircleMask(this.loader,28,params.shadeX,params.shadeY);
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
      
      private function onRemoveFromStage(evt:Event) : void
      {
         this.removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemoveFromStage);
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
         super.dispos();
      }
      
      public function setSelect(frame:int) : void
      {
         if(frame == 3)
         {
            this["gotoAndStop"](2);
         }
         if(frame == 2)
         {
            this["gotoAndStop"](3);
         }
         if(frame == 1)
         {
            this["gotoAndStop"](1);
         }
         super.data.select = frame;
      }
   }
}

