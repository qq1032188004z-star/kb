package com.xygame.module.battle.battleItem
{
   import com.game.modules.view.battle.BattleViewManager;
   import com.game.modules.view.battle.item.ItemTip;
   import com.publiccomponent.loading.data.BufInfoTypeData;
   import com.xygame.module.battle.data.BufData;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   
   public class BufIcon extends Sprite
   {
      
      private var _data:Object;
      
      private var _tipString:String = "";
      
      private var _bufid:int;
      
      private var _sid:int;
      
      private var _monsterID:int;
      
      private var _loaderOK:Boolean;
      
      private var _loader:Loader;
      
      private var _bitmap:Bitmap;
      
      private var _icon0:DisplayObject;
      
      private var _icon1:DisplayObject;
      
      public function BufIcon(obj:* = null)
      {
         super();
         if(obj)
         {
            this.init(obj);
         }
      }
      
      public function init(obj:*) : void
      {
         this.cleanup();
         if(obj is BufInfoTypeData)
         {
            this.loadFromURL(BufInfoTypeData(obj).url);
         }
         else if(obj is BufData)
         {
            this.loadFromBufData(BufData(obj));
         }
         else if(obj is DisplayObject)
         {
            addChild(DisplayObject(obj));
            this.loaderOK = true;
         }
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
         this.addHoverListeners();
      }
      
      private function loadFromURL(url:String) : void
      {
         this._loader = new Loader();
         this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoadComplete);
         this._loader.load(new URLRequest(url));
      }
      
      private function loadFromBufData(bd:BufData) : void
      {
         var pairID:int = 0;
         this._icon0 = this.createBufIcon(bd.bufIconId);
         if(Boolean(this._icon0))
         {
            addChild(this._icon0);
         }
         var index:int = int(bd.SPECIALID_ARR.indexOf(bd.bufIconId));
         if(index >= 0)
         {
            pairID = int(bd.SPECIALID_ARR[index + (index % 2 == 0 ? 1 : -1)]);
            this._icon1 = this.createBufIcon(pairID);
            if(Boolean(this._icon1))
            {
               this._icon1.name = pairID.toString();
               addChild(this._icon1);
            }
         }
         this.loaderOK = true;
      }
      
      private function createBufIcon(bufIconId:int) : DisplayObject
      {
         var className:String = "buf" + bufIconId;
         if(!ApplicationDomain.currentDomain.hasDefinition(className))
         {
            return null;
         }
         var IconClass:Class = ApplicationDomain.currentDomain.getDefinition(className) as Class;
         return new IconClass();
      }
      
      private function onMouseOverBufIcon(event:MouseEvent) : void
      {
         ItemTip.instance.show({
            "toolname":this.tipString,
            "tooldesc":""
         },BattleViewManager.getInstance().tipView,this.x + 5,this.y + 8);
      }
      
      private function onMouseOutBufIcon(event:MouseEvent) : void
      {
         ItemTip.instance.hide();
      }
      
      public function update(td:BufInfoTypeData) : void
      {
         if(Boolean(this._loader) && Boolean(td))
         {
            this._loader.load(new URLRequest(td.url));
         }
      }
      
      private function onLoadComplete(event:Event) : void
      {
         if(Boolean(this._bitmap) && contains(this._bitmap))
         {
            removeChild(this._bitmap);
         }
         this._bitmap = event.target.content as Bitmap;
         addChild(this._bitmap);
         this.loaderOK = true;
      }
      
      private function cleanup() : void
      {
         if(Boolean(this._bitmap))
         {
            if(Boolean(this._bitmap.bitmapData))
            {
               this._bitmap.bitmapData.dispose();
            }
            if(contains(this._bitmap))
            {
               removeChild(this._bitmap);
            }
            this._bitmap = null;
         }
         if(Boolean(this._loader))
         {
            this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoadComplete);
            try
            {
               this._loader.close();
            }
            catch(e:Error)
            {
            }
            this._loader.unloadAndStop(true);
            this._loader = null;
         }
         while(numChildren > 0)
         {
            removeChildAt(0);
         }
      }
      
      private function onRemovedFromStage(event:Event) : void
      {
         removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
         this.removeHoverListeners();
         this.cleanup();
      }
      
      private function addHoverListeners() : void
      {
         if(!hasEventListener(MouseEvent.MOUSE_OVER))
         {
            addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOverBufIcon);
         }
         if(!hasEventListener(MouseEvent.MOUSE_OUT))
         {
            addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOutBufIcon);
         }
      }
      
      private function removeHoverListeners() : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,this.onMouseOverBufIcon);
         removeEventListener(MouseEvent.MOUSE_OUT,this.onMouseOutBufIcon);
      }
      
      public function setData(bd:BufData, monsterID:int) : void
      {
         this._monsterID = monsterID;
         this.data = bd;
      }
      
      public function get data() : Object
      {
         return this._data;
      }
      
      public function set data(value:Object) : void
      {
         if(Boolean(value) && Boolean(value.hasOwnProperty("tipString")))
         {
            this._tipString = this._monsterID != 0 && value is BufData ? BufData(value).getOtherTip(this._monsterID) : value.tipString;
         }
         else
         {
            this._tipString = "";
         }
         if("bufid" in value)
         {
            this._bufid = value["bufid"];
         }
         if(Boolean(this._icon1))
         {
            this._icon1.visible = this._icon1.name == String(value["bufIconId"]);
            if(Boolean(this._icon0))
            {
               this._icon0.visible = !this._icon1.visible;
            }
         }
         this._data = value;
      }
      
      public function get tipString() : String
      {
         return this._tipString;
      }
      
      public function get bufid() : int
      {
         return this._bufid;
      }
      
      public function set bufid(value:int) : void
      {
         this._bufid = value;
      }
      
      public function get sid() : int
      {
         return this._sid;
      }
      
      public function set sid(value:int) : void
      {
         this._sid = value;
      }
      
      public function set loaderOK(value:Boolean) : void
      {
         this._loaderOK = value;
         this.addHoverListeners();
      }
   }
}

