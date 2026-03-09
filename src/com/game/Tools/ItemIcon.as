package com.game.Tools
{
   import com.game.util.NewTipManager;
   import com.game.util.ToolTipStringUtil;
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.loading.XMLLocator;
   import flash.display.Loader;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.filters.GlowFilter;
   import flash.net.URLRequest;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   
   public class ItemIcon extends Sprite
   {
      
      public static const TIPS_TYPE_0:int = 0;
      
      public static const TIPS_TYPE_1:int = 1;
      
      public static const TIPS_TYPE_2:int = 2;
      
      public static const TIPS_TYPE_3:int = 3;
      
      public static const TIPS_TYPE_4:int = 4;
      
      private var loader:Loader;
      
      private var _txtNum:TextField;
      
      private var _curData:Object;
      
      private var _preID:int;
      
      private var _tipsType:int;
      
      private var _isTool:Boolean;
      
      private var _iconName:String;
      
      private var _loaderURL:String;
      
      public function ItemIcon(tips_type:int = 0, isListenerRemove:Boolean = true)
      {
         super();
         this._tipsType = tips_type;
         this._txtNum = new TextField();
         this._txtNum.defaultTextFormat = new TextFormat("宋体",18,16777215);
         this._txtNum.width = 62;
         this._txtNum.x = 0;
         this._txtNum.y = 40;
         this._txtNum.autoSize = TextFieldAutoSize.RIGHT;
         this._txtNum.mouseEnabled = false;
         this._txtNum.filters = [new GlowFilter(26316,10,5,5)];
         this.addChild(this._txtNum);
         this.loader = new Loader();
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onComplete);
         this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onIoerror);
         if(isListenerRemove)
         {
            this.addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoveFromStage);
         }
      }
      
      public function setMonster(id:int) : void
      {
         this.setData(id,1,false);
      }
      
      public function setObjData(obj:Object) : void
      {
         if(obj.hasOwnProperty("itemId"))
         {
            this.setData(obj["itemId"],obj["amount"]);
         }
         else if(obj.hasOwnProperty("toolId"))
         {
            this.setData(obj["toolId"],obj["amount"]);
         }
         else if(obj.hasOwnProperty("monsterid"))
         {
            this.setMonster(obj["monsterid"]);
         }
         else if(obj.hasOwnProperty("spirit_id"))
         {
            this.setMonster(obj["spirit_id"]);
         }
      }
      
      public function setData(tool_id:int, amount:int, isTool:Boolean = true, isShowNum:Boolean = true) : void
      {
         this._curData = {
            "tool_id":tool_id,
            "amount":amount
         };
         this._isTool = isTool;
         if(isTool && isShowNum && amount > 0)
         {
            this._txtNum.text = amount.toString();
         }
         else
         {
            this._txtNum.text = "";
         }
         if(this._preID == 0 || this._preID != tool_id)
         {
            this._preID = tool_id;
            if(this._isTool)
            {
               this.onLoader("assets/tool/" + tool_id + ".swf");
               this._iconName = String(XMLLocator.getInstance().getTool(tool_id).name);
            }
            else
            {
               this.onLoader("assets/monsterimg/" + tool_id + ".swf");
               this._iconName = String(XMLLocator.getInstance().getSprited(tool_id).name);
            }
            this.setTips(this.itemDesc);
         }
      }
      
      public function setIconData(url:String) : void
      {
         this.onLoader(url);
      }
      
      private function onLoader(url:String) : void
      {
         if(this._loaderURL != url)
         {
            this._loaderURL = url;
            this.loader.load(new URLRequest(URLUtil.getSvnVer(this._loaderURL)));
         }
      }
      
      private function onComplete(evt:Event) : void
      {
         if(this.loader == null)
         {
            return;
         }
         this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onComplete);
         addChildAt(this.loader,0);
      }
      
      public function setTips(desc:String = null) : void
      {
         if(!desc || desc == "")
         {
            NewTipManager.getInstance().removeToolTip(this);
         }
         else
         {
            NewTipManager.getInstance().addToolTip(this,desc);
         }
      }
      
      public function get itemDesc() : String
      {
         var desc:String = "";
         switch(this._tipsType)
         {
            case TIPS_TYPE_0:
               desc = this._isTool ? ToolTipStringUtil.toPackTipString(this._curData["tool_id"]) : ToolTipStringUtil.toSpriteTipString(this._curData["tool_id"]);
               break;
            case TIPS_TYPE_1:
               desc = this._isTool ? ToolTipStringUtil.getToolName(this._curData["tool_id"]) + "x" + this._curData["amount"] : ToolTipStringUtil.getSpriteName(this._curData["tool_id"]);
               break;
            case TIPS_TYPE_3:
               desc = this._isTool ? ToolTipStringUtil.getToolDesc(this._curData["tool_id"]) : ToolTipStringUtil.getSpriteName(this._curData["tool_id"]);
               break;
            case TIPS_TYPE_4:
               desc = this._isTool ? ToolTipStringUtil.getToolName(this._curData["tool_id"]) : ToolTipStringUtil.getSpriteName(this._curData["tool_id"]);
         }
         return desc;
      }
      
      public function get iconName() : String
      {
         return this._iconName;
      }
      
      private function onIoerror(evt:IOErrorEvent) : void
      {
         if(Boolean(this._curData))
         {
            O.o("ItemIcon::onIoerror -- tool_id = " + this._curData["tool_id"]);
         }
      }
      
      public function get tool_id() : int
      {
         return this._curData["tool_id"];
      }
      
      public function set preID(value:int) : void
      {
         this._preID = value;
      }
      
      private function onRemoveFromStage(evt:Event) : void
      {
         if(this.hasEventListener(Event.REMOVED_FROM_STAGE))
         {
            this.removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemoveFromStage);
         }
         if(this.loader != null)
         {
            this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onComplete);
            this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onIoerror);
            this.loader.unloadAndStop(false);
            if(contains(this.loader))
            {
               removeChild(this.loader);
            }
         }
         this.loader = null;
         NewTipManager.getInstance().removeToolTip(this);
      }
      
      public function setTipsType(tipsType:int) : void
      {
         this._tipsType = tipsType;
      }
      
      public function setNum(amount:String) : void
      {
         this._txtNum.text = "" + amount;
      }
      
      public function get txtNum() : TextField
      {
         return this._txtNum;
      }
      
      public function dispose() : void
      {
         this.onRemoveFromStage(null);
      }
   }
}

