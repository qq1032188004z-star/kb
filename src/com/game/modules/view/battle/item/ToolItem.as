package com.game.modules.view.battle.item
{
   import com.publiccomponent.loading.Hloader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class ToolItem extends Sprite
   {
      
      public var data:Object;
      
      private var iconloader:Hloader;
      
      public function ToolItem(data:Object = null)
      {
         super();
         this.iconloader = new Hloader();
         this.iconloader.addEventListener(Event.COMPLETE,this.onIconComp);
         if(data != null)
         {
            this.setData(data);
         }
      }
      
      public function setData(data:Object) : void
      {
         this.data = data;
         this.init();
      }
      
      private function initPoint() : void
      {
         this.x = 90 + this.data.indexid * 81.3 - 23;
         switch(this.data.indexid + 1)
         {
            case 1:
               this.x = 36;
               this.y = 5;
               break;
            case 2:
               this.x = 119;
               this.y = 18;
               break;
            case 3:
               this.x = 199;
               this.y = 3;
               break;
            case 4:
               this.x = 278;
               this.y = 7;
               break;
            case 5:
               this.x = 358;
               this.y = 16;
               break;
            case 6:
               this.x = 438;
               this.y = 4;
         }
      }
      
      public function init() : void
      {
         this.buttonMode = true;
         if(this.data.hasOwnProperty("toolid"))
         {
            this.iconloader.url = "assets/tool/" + this.data.toolid + ".swf";
         }
         if(this.data.hasOwnProperty("name"))
         {
            this.name = this.data.name;
         }
         if(this.data.hasOwnProperty("indexid"))
         {
            this.initPoint();
         }
      }
      
      private function onIconComp(event:Event) : void
      {
         this.iconloader.loader.mouseChildren = false;
         this.iconloader.loader.mouseEnabled = false;
         this.addChild(this.iconloader.loader);
      }
      
      public function destroy() : void
      {
         if(Boolean(this.iconloader))
         {
            this.iconloader.removeEventListener(Event.COMPLETE,this.onIconComp);
            if(Boolean(this.iconloader.loader) && this.contains(this.iconloader.loader))
            {
               this.removeChild(this.iconloader.loader);
            }
            this.iconloader.unloadAndStop();
            this.iconloader = null;
         }
         while(this.numChildren > 0)
         {
            if(this.getChildAt(0) is MovieClip)
            {
               this.getChildAt(0)["stop"]();
            }
            this.removeChildAt(0);
         }
      }
   }
}

