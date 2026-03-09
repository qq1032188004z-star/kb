package com.game.modules.view.pop
{
   import com.game.locators.GameData;
   import com.game.util.HLoaderSprite;
   import flash.events.MouseEvent;
   import flash.external.ExternalInterface;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   
   public class CloseServer extends HLoaderSprite
   {
      
      private const FATHERKNOW:String = "assets/login/bigperson.swf";
      
      private const REGISTERCOUNT:String = "problemassets/registercount.swf";
      
      private const CLOSE_SERVER:String = "assets/pop/closeserver.swf";
      
      private const MAINTAIN_SERVER:String = "assets/pop/maintainserver.swf";
      
      private var _curType:int;
      
      private var _oldType:int;
      
      public function CloseServer()
      {
         super();
         this.init();
      }
      
      public function init() : void
      {
         if(GameData.instance.playerData.playerStatus == 8)
         {
            this.curType = 1;
         }
         else
         {
            this.curType = 0;
         }
      }
      
      public function set curType(value:int) : void
      {
         this._oldType = this._curType;
         this._curType = value;
         switch(this._curType)
         {
            case 0:
               this.url = this.CLOSE_SERVER;
               break;
            case 1:
               this.url = this.MAINTAIN_SERVER;
               break;
            case 2:
               this.url = this.FATHERKNOW;
               break;
            case 3:
               this.url = this.REGISTERCOUNT;
         }
      }
      
      override public function setShow() : void
      {
         switch(this._curType)
         {
            case 0:
            case 1:
               bg["fatherknow"].addEventListener(MouseEvent.CLICK,this.onFatherKnowHandler);
               bg["setdesk"].addEventListener(MouseEvent.CLICK,this.onSetdeskKnowHandler);
               bg["savegame"].addEventListener(MouseEvent.CLICK,this.onSaveGameKnowHandler);
               bg["creatcount"].addEventListener(MouseEvent.CLICK,this.onCreatCountKnowHandler);
               break;
            case 2:
               bg["closeBtn"].addEventListener(MouseEvent.CLICK,this.onClickCloseFatherKnow);
               break;
            case 3:
               bg["closeBtn"].addEventListener(MouseEvent.CLICK,this.onClickCloseFatherKnow);
         }
      }
      
      private function onFatherKnowHandler(event:MouseEvent) : void
      {
         this.loader = null;
         this.curType = 2;
      }
      
      private function onSetdeskKnowHandler(event:MouseEvent) : void
      {
         navigateToURL(new URLRequest("javascript:window.location.href=\'http://enter.wanwan4399.com/bin-debug/shortcut.php\'"),"_self");
      }
      
      private function onSaveGameKnowHandler(event:MouseEvent) : void
      {
         if(ExternalInterface.available)
         {
            ExternalInterface.call("addCookie");
         }
      }
      
      private function getURL(url:String, window:String = "_blank") : void
      {
         ExternalInterface.call("window.open(\"" + url + "\",\"" + window + "\")");
      }
      
      private function onCreatCountKnowHandler(event:MouseEvent) : void
      {
         this.loader = null;
         this.getURL("//news.4399.com/login/kbxy.html?reg=1&pass=1&v=" + new Date().valueOf().toString(),"_self");
      }
      
      private function onClickCloseFatherKnow(event:MouseEvent) : void
      {
         this.loader = null;
         this.curType = this._oldType;
      }
   }
}

