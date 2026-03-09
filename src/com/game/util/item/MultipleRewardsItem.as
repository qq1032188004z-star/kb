package com.game.util.item
{
   import com.game.util.ToolTipStringUtil;
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.ui.ToolTip;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLRequest;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol366")]
   public class MultipleRewardsItem extends Sprite
   {
      
      public static var ITEM_TYPE_EXP:int = 1;
      
      public static var ITEM_TYPE_COIN:int = 2;
      
      public static var ITEM_TYPE_PROP_NORMAL:int = 3;
      
      public static var ITEM_TYPE_PROP_SGHALL:int = 4;
      
      public static var ITEM_TYPE_PROP_FARM:int = 5;
      
      public static var ITEM_TYPE_MONSTER:int = 6;
      
      public static var ITEM_TYPE_SXXSD:int = 7;
      
      public static var ITEM_TYPE_PRACTICE:int = 8;
      
      public static var ITEM_TYPE_RAND_PRACTICE:int = 9;
      
      public static var ITEM_TYPE_RAND_HLD:int = 10;
      
      public var txtNum:TextField;
      
      public var spIcon:Sprite;
      
      private var loader:Loader;
      
      private var _itemType:int;
      
      private var _itemID:int;
      
      private var _itemNum:int;
      
      private var _curAry:Array;
      
      public function MultipleRewardsItem(ary:Array)
      {
         super();
         this.loader = new Loader();
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onComplete);
         this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onIoerror);
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoveFromStage);
         this.txtNum.mouseEnabled = false;
         if(Boolean(ary) && ary.length > 2)
         {
            this.setData(ary);
         }
      }
      
      private function onComplete(evt:Event) : void
      {
         if(this.loader == null)
         {
            return;
         }
         this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onComplete);
         this.loader.scaleX = this.loader.scaleY = 0.9;
         this.spIcon.addChild(this.loader);
      }
      
      private function onIoerror(evt:IOErrorEvent) : void
      {
         O.o("MultipleRewardsItem::onIoerror // id = " + this._itemID + "\ntype = " + this._itemType);
      }
      
      private function onRemoveFromStage(evt:Event) : void
      {
         this.removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemoveFromStage);
         if(this.loader != null)
         {
            this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onComplete);
            this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onIoerror);
            this.loader.unloadAndStop(false);
            if(this.loader.parent is DisplayObjectContainer)
            {
               this.loader.parent.removeChild(this.loader);
            }
         }
         this.loader = null;
         ToolTip.LooseDO(this);
      }
      
      public function dispose() : void
      {
         this.onRemoveFromStage(null);
      }
      
      public function setData(arr:Array) : void
      {
         if(arr == null || arr.length < 3)
         {
            O.o("MultipleRewardsItem::setDataError");
         }
         this._itemType = arr[0];
         this._itemID = arr[1];
         this._itemNum = arr[2];
         if(this._itemType != ITEM_TYPE_MONSTER)
         {
            this.txtNum.text = this.formatNumber(this._itemNum);
         }
         else
         {
            this.txtNum.text = "";
         }
         if(this._itemType == ITEM_TYPE_MONSTER)
         {
            this.loader.load(new URLRequest(URLUtil.getSvnVer("assets/monsterimg/" + this._itemID + ".swf")));
            ToolTip.setDOInfo(this.spIcon,ToolTipStringUtil.toSpriteTipString(this._itemID));
         }
         else
         {
            switch(this._itemType)
            {
               case ITEM_TYPE_COIN:
                  this._itemID = 201;
                  break;
               case ITEM_TYPE_EXP:
                  this._itemID = 202;
                  break;
               case ITEM_TYPE_RAND_PRACTICE:
                  this._itemID = 203;
                  break;
               case ITEM_TYPE_SXXSD:
                  this._itemID = 204;
                  break;
               case ITEM_TYPE_RAND_HLD:
                  this._itemID = 205;
                  break;
               case ITEM_TYPE_PRACTICE:
                  this._itemID += 207;
            }
            ToolTip.setDOInfo(this.spIcon,ToolTipStringUtil.toPackTipString(this._itemID));
            this.loader.load(new URLRequest(URLUtil.getSvnVer("assets/tool/" + this._itemID + ".swf")));
         }
      }
      
      private function formatNumber(num:Number) : String
      {
         var result:Number = NaN;
         var largeResult:Number = NaN;
         if(num < 1000000)
         {
            return num.toString();
         }
         if(num < 10000000)
         {
            result = num / 10000;
            if(result % 1 == 0)
            {
               return result.toString() + "万";
            }
            return result.toFixed(2) + "万";
         }
         if(num < 100000000)
         {
            largeResult = num / 10000;
            if(largeResult % 1 == 0)
            {
               return largeResult.toString() + "万";
            }
            return largeResult.toFixed(1) + "万";
         }
         return num.toString();
      }
   }
}

