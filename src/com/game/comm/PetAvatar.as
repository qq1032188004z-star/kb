package com.game.comm
{
   import com.publiccomponent.URLUtil;
   import flash.display.Loader;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.net.URLRequest;
   
   public class PetAvatar extends Sprite
   {
      
      private var _iid:int;
      
      private var _loader:Loader;
      
      private var _scaleX:Number;
      
      private var _scaleY:Number;
      
      public function PetAvatar()
      {
         super();
         mouseChildren = false;
         mouseEnabled = false;
         this._loader = new Loader();
         this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoaderCompHandler);
      }
      
      public function iid(value:int, scaleX:Number = 1, scaleY:Number = 1) : void
      {
         if(value == this._iid)
         {
            return;
         }
         this._scaleX = scaleX;
         this._scaleY = scaleY;
         this._iid = value;
         this.loadPet();
      }
      
      private function loadPet() : void
      {
         this._loader.unload();
         this._loader.load(new URLRequest(URLUtil.getSvnVer("assets/monsterswf/" + this._iid + ".swf")));
      }
      
      private function onLoaderCompHandler(event:Event) : void
      {
         this._loader.scaleX = this._scaleX;
         this._loader.scaleY = this._scaleY;
         addChild(this._loader);
      }
      
      public function dispose() : void
      {
         if(Boolean(this._loader))
         {
            this._loader.unload();
            if(Boolean(this._loader.parent))
            {
               this._loader.parent.removeChild(this._loader);
            }
         }
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

