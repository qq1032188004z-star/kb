package com.game.modules.view.task
{
   import com.game.locators.GameData;
   import com.game.util.GameDynamicUI;
   import com.publiccomponent.loading.GreenLoading;
   import com.publiccomponent.loading.Hloader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   
   public class CellPhoneToLuote extends Sprite
   {
      
      private var loader:Hloader;
      
      private var mc:MovieClip;
      
      private var data:Object;
      
      private var currentDia:String;
      
      private var id:int;
      
      private var callback:Function;
      
      private var usernameRegExp:RegExp = /username/g;
      
      public function CellPhoneToLuote()
      {
         super();
         GreenLoading.loading.visible = true;
         this.loader = new Hloader("assets/material/phonetoluote.swf");
         this.loader.addEventListener(Event.COMPLETE,this.onLoadComplete);
         this.loader.addEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
      }
      
      private function onLoadComplete(evt:Event) : void
      {
         evt.stopImmediatePropagation();
         GreenLoading.loading.visible = false;
         if(this.loader == null)
         {
            if(this.callback != null)
            {
               this.callback.apply(null,[null]);
            }
            this.dispos();
            return;
         }
         this.mc = this.loader.content as MovieClip;
         this.mc.gotoAndStop(1);
         this.addChild(this.mc);
         this.mc.x = 0;
         this.mc.y = 0;
         this.loader.removeEventListener(Event.COMPLETE,this.onLoadComplete);
         this.loader.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
         if(this.callback != null)
         {
            this.init();
         }
      }
      
      private function onLoadError(evt:IOErrorEvent) : void
      {
         evt.stopImmediatePropagation();
         GreenLoading.loading.visible = false;
         if(this.callback != null)
         {
            this.callback.apply(null,[null]);
         }
         this.dispos();
      }
      
      private function animationOver() : void
      {
         (this.mc.progressbar as MovieClip).addFrameScript((this.mc.progressbar as MovieClip).totalFrames - 1,null);
         this.uiPrepared();
      }
      
      private function uiPrepared() : void
      {
         try
         {
            this.mc.progressbar.stop();
            this.mc.strMC.stop();
            this.mc.screenMC.stop();
            this.mc.gotoAndStop(2);
         }
         catch(e:*)
         {
            if(this.callback != null)
            {
               this.callback.apply(null,[null]);
            }
            this.dispos();
            return;
         }
         if((this.data.desc as Array).length > 0)
         {
            this.showDia();
            if(!this.mc.next.hasEventListener(MouseEvent.CLICK))
            {
               GameDynamicUI.addMouseEventUI(this.mc,this.mc.next.x - 15,this.mc.next.y,"texiao",MouseEvent.CLICK,this.onClickNext,1);
               this.mc.next.buttonMode = true;
               this.mc.next.addEventListener(MouseEvent.CLICK,this.onClickNext);
            }
         }
      }
      
      private function init() : void
      {
         if(this.data == null)
         {
            if(this.callback != null)
            {
               this.callback.apply(null,[null]);
            }
            this.dispos();
            return;
         }
         try
         {
            this.mc.gotoAndStop(1);
            this.mc.progressbar.play();
            this.mc.strMC.play();
            this.mc.screenMC.play();
            (this.mc.progressbar as MovieClip).addFrameScript((this.mc.progressbar as MovieClip).totalFrames - 1,this.animationOver);
         }
         catch(e:*)
         {
            if(this.callback != null)
            {
               this.callback.apply(null,[null]);
            }
            this.dispos();
            return;
         }
      }
      
      private function showDia() : void
      {
         if(this.data.desc.length == 0)
         {
            GameDynamicUI.removeUI("texiao");
            GameDynamicUI.addMouseEventUI(this.mc,this.mc.close.x - 15,this.mc.close.y,"texiao",MouseEvent.CLICK,this.onClickClose,1);
            this.mc.next.removeEventListener(MouseEvent.CLICK,this.onClickNext);
            this.mc.close.addEventListener(MouseEvent.CLICK,this.onClickClose);
            this.mc.next.buttonMode = false;
            this.mc.close.buttonMode = true;
            this.mc.next.visible = false;
            return;
         }
         this.currentDia = (this.data.desc as Array).shift();
         this.mc.dia.text = this.nameFilter(this.currentDia);
         if(this.data.desc.length == 0)
         {
            this.mc.next.removeEventListener(MouseEvent.CLICK,this.onClickNext);
            this.mc.close.addEventListener(MouseEvent.CLICK,this.onClickClose);
            this.mc.next.visible = false;
            this.mc.close.buttonMode = true;
            GameDynamicUI.removeUI("texiao");
            GameDynamicUI.addMouseEventUI(this.mc,this.mc.close.x - 15,this.mc.close.y,"texiao",MouseEvent.CLICK,this.onClickClose,1);
         }
      }
      
      private function nameFilter(str:String) : String
      {
         return str.replace(this.usernameRegExp,GameData.instance.playerData.userName);
      }
      
      private function onClickNext(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         this.showDia();
      }
      
      private function onClickClose(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         GameDynamicUI.removeUI("texiao");
         if(this.callback != null)
         {
            this.callback.apply(null,[null]);
         }
         this.dispos();
      }
      
      public function dispos() : void
      {
         if(this.loader != null)
         {
            this.loader.removeEventListener(Event.COMPLETE,this.onLoadComplete);
            this.loader.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
            this.loader.unloadAndStop();
            this.loader = null;
         }
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
         if(Boolean(this.mc.next))
         {
            this.mc.next.buttonMode = false;
            this.mc.next.stop();
         }
         if(Boolean(this.mc.close))
         {
            this.mc.close.stop();
            this.mc.close.removeEventListener(MouseEvent.CLICK,this.onClickClose);
            this.mc.close.buttonMode = false;
         }
         this.callback = null;
      }
      
      public function setData(params:Object) : void
      {
         if(Boolean(params))
         {
            if(this.mc != null)
            {
               this.callback = params.callback;
               this.data = params.opdata;
               if(this.data.desc.length > 0)
               {
                  this.mc.next.visible = true;
               }
               this.init();
               return;
            }
            this.callback = params.callback;
            this.data = params.opdata;
         }
         else
         {
            if(this.callback != null)
            {
               this.callback.apply(null,[null]);
            }
            this.dispos();
         }
      }
   }
}

