package com.game.modules.view.pop
{
   import com.publiccomponent.alert.Alert;
   import com.publiccomponent.loading.GreenLoading;
   import com.publiccomponent.loading.Hloader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import flash.system.ApplicationDomain;
   
   public class TrigramesGame extends Sprite
   {
      
      private var loader:Hloader;
      
      private var mc:MovieClip;
      
      private var firstClick:int;
      
      private var secondClick:int;
      
      private var win:int = 0;
      
      private var highLight:GlowFilter = new GlowFilter(16711680,1,10,10,3,1);
      
      private var bingoFilter:GlowFilter = new GlowFilter(16763904,1,7,7,3);
      
      private var initList:Array = [1,6,4,8,3,7,2,5];
      
      private var changeCount:int = 10;
      
      private var callback:Function;
      
      public function TrigramesGame()
      {
         super();
         GreenLoading.loading.visible = true;
         this.loader = new Hloader("assets/material/extension25ai.swf");
         this.loader.addEventListener(Event.COMPLETE,this.onLoadComplete);
      }
      
      private function onLoadComplete(evt:Event) : void
      {
         evt.stopImmediatePropagation();
         var domain:ApplicationDomain = this.loader.contentLoaderInfo.applicationDomain;
         var cls:* = domain.getDefinition("bagua") as Class;
         this.mc = new cls() as MovieClip;
         this.addChild(this.mc);
         this.mc.x = 0;
         this.mc.y = 0;
         GreenLoading.loading.visible = false;
         this.initEvent();
      }
      
      public function setData(param:Object) : void
      {
         this.callback = param.callback;
      }
      
      public function initEvent() : void
      {
         var i:int = 1;
         for(i = 1; i <= 8; i++)
         {
            this.mc["bg" + i].gotoAndStop(this.initList[i - 1]);
            this.mc["bg" + i].buttonMode = true;
            if(i != this.initList[i - 1])
            {
               this.mc["bg" + i].addEventListener(MouseEvent.CLICK,this.onClickBg);
            }
            else
            {
               this.mc["bg" + i].filters = [this.bingoFilter];
               this.win |= 1 << i - 1;
            }
         }
         this.mc.closebtn.addEventListener(MouseEvent.CLICK,this.onClickClose);
      }
      
      private function onClickBg(evt:MouseEvent) : void
      {
         var temp:int = 0;
         var count:int = 0;
         evt.stopImmediatePropagation();
         var str:String = evt.currentTarget.name;
         var index:int = int(str.charAt(str.length - 1));
         if(this.firstClick == 0)
         {
            this.firstClick = index;
         }
         else if(this.secondClick == 0)
         {
            this.secondClick = index;
         }
         if(this.firstClick != 0 && this.secondClick != 0)
         {
            temp = int(this.mc["bg" + this.firstClick].currentFrame);
            this.mc["bg" + this.firstClick].gotoAndStop(this.mc["bg" + this.secondClick].currentFrame);
            this.mc["bg" + this.secondClick].gotoAndStop(temp);
            count = 0;
            if(this.mc["bg" + this.firstClick].currentFrame == this.firstClick)
            {
               this.mc["bg" + this.firstClick].removeEventListener(MouseEvent.CLICK,this.onClickBg);
               count |= 1;
            }
            if(this.mc["bg" + this.secondClick].currentFrame == this.secondClick)
            {
               this.mc["bg" + this.secondClick].removeEventListener(MouseEvent.CLICK,this.onClickBg);
               count |= 2;
            }
            if((count & 1) > 0)
            {
               this.win |= 1 << this.firstClick - 1;
            }
            if((count & 2) > 0)
            {
               this.win |= 1 << this.secondClick - 1;
            }
            this.firstClick = 0;
            this.secondClick = 0;
            --this.changeCount;
            if(this.win == 255)
            {
               this.applyCallback(2);
               return;
            }
            if(this.changeCount == 0)
            {
               this.applyCallback();
               return;
            }
         }
         this.updateFilter();
      }
      
      private function updateFilter(flag:Boolean = false) : void
      {
         var i:int = 1;
         for(i = 1; i <= 8; i++)
         {
            this.mc["bg" + i].filters = [];
            if((this.win & 1 << i - 1) > 0 && !flag)
            {
               this.mc["bg" + i].filters = [this.bingoFilter];
            }
         }
         if(!flag)
         {
            if(this.firstClick != 0 && (this.win & 1 << this.firstClick - 1) <= 0)
            {
               this.mc["bg" + this.firstClick].filters = [this.highLight];
            }
            if(this.secondClick != 0 && (this.win & 1 << this.secondClick - 1) <= 0)
            {
               this.mc["bg" + this.secondClick].filters = [this.highLight];
            }
         }
      }
      
      private function releaseEvent() : void
      {
         this.mc.closebtn.removeEventListener(MouseEvent.CLICK,this.onClickClose);
         var i:int = 1;
         for(i = 1; i <= 8; i++)
         {
            this.mc["bg" + i].removeEventListener(MouseEvent.CLICK,this.onClickBg);
         }
      }
      
      private function onClickClose(evt:MouseEvent) : void
      {
         this.applyCallback();
      }
      
      private function applyCallback(src:int = 1) : void
      {
         if(src == 1)
         {
            new Alert().show("很遗憾，这次没能破开大阵！",this.clickHandler);
         }
         else
         {
            this.disport(true);
         }
      }
      
      private function clickHandler(txt:String, param:*) : void
      {
         if(txt == "确定")
         {
            this.disport(false);
         }
      }
      
      public function disport(flag:Boolean) : void
      {
         this.firstClick = 0;
         this.secondClick = 0;
         this.updateFilter(true);
         this.releaseEvent();
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
         if(flag)
         {
            if(this.callback != null)
            {
               this.callback.apply(null,[true]);
            }
         }
         else if(this.callback != null)
         {
            this.callback.apply(null,["closedialog"]);
         }
         this.callback = null;
      }
   }
}

