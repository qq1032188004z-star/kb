package com.game.modules.view.pack
{
   import com.core.observer.MessageEvent;
   import com.game.locators.CacheData;
   import com.game.locators.GameData;
   import com.game.manager.EventManager;
   import com.game.util.HLoaderSprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.utils.ByteArray;
   
   public class PackClothesTool extends HLoaderSprite
   {
      
      public static var Instance:PackClothesTool = new PackClothesTool();
      
      private var myType:int = 0;
      
      private var myList:Array = [];
      
      private var myXmlList:XML;
      
      private var urlloader:URLLoader;
      
      private var Cloths:Array = [];
      
      private const PageNum:int = 8;
      
      private var Page:int;
      
      private var currentPage:int = 0;
      
      public function PackClothesTool()
      {
         super();
         this.showloading = false;
      }
      
      override public function initParams(params:Object = null) : void
      {
         this.myType = int(params.type);
         this.myList = params.list;
         if(!bg)
         {
            this.url = "assets/material/pack_clothes_tool.swf";
         }
         else
         {
            this.setShow();
         }
      }
      
      override public function setShow() : void
      {
         bg.cacheAsBitmap = true;
         for(var i:int = 0; i < this.PageNum; i++)
         {
            bg["txt" + i].mouseEnabled = false;
            EventManager.attachEvent(bg["btn" + i],MouseEvent.MOUSE_DOWN,this.btnsHandler);
         }
         EventManager.attachEvent(bg.upBtn,MouseEvent.CLICK,this.upBtnHandler);
         EventManager.attachEvent(bg.downBtn,MouseEvent.CLICK,this.downBtnHandler);
         if(!this.myXmlList)
         {
            if(this.urlloader == null)
            {
               this.urlloader = new URLLoader();
               this.urlloader.dataFormat = URLLoaderDataFormat.BINARY;
               this.urlloader.addEventListener(Event.COMPLETE,this.onLoaded);
               this.urlloader.load(new URLRequest(CacheData.instance.formatUrl("config/clothes")));
            }
         }
         else
         {
            this.setClothes();
         }
      }
      
      private function onLoaded(evt:Event) : void
      {
         var bytes:ByteArray = this.urlloader.data as ByteArray;
         bytes.uncompress();
         bytes.position = 0;
         var str:String = bytes.readUTFBytes(bytes.bytesAvailable);
         var xmllist:XMLList = new XMLList(str);
         this.myXmlList = xmllist[0] as XML;
         this.setClothes();
      }
      
      private function setClothes() : void
      {
         var xml:XML = null;
         var obj:Object = null;
         var item:Object = null;
         this.Cloths = [];
         var itemStr:String = "";
         var itemId:int = 0;
         for each(xml in this.myXmlList.children())
         {
            obj = {};
            obj.name = String(xml.name);
            obj.sex = int(xml.sex);
            obj.vip = int(xml.vip);
            obj.list = [];
            itemStr = String(xml.subitem);
            do
            {
               itemId = int(itemStr.substr(0,6));
               item = this.checkCloth(itemId);
               if(item != null)
               {
                  obj.list.push(item);
               }
               itemStr = itemStr.substr(7);
            }
            while(itemStr.length > 0);
            
            if(obj.list.length > 0 && obj.vip == this.myType)
            {
               if(GameData.instance.playerData.sex == 0)
               {
                  if(obj.sex != 0)
                  {
                     this.Cloths.push(obj);
                  }
               }
               else if(obj.sex != 1)
               {
                  this.Cloths.push(obj);
               }
            }
         }
         this.Page = int(Math.ceil(this.Cloths.length / this.PageNum)) - 1;
         this.showClothes(0);
      }
      
      private function checkCloth(id:int) : Object
      {
         var cloth:Object = null;
         for each(cloth in this.myList)
         {
            if(cloth.id == id)
            {
               return cloth;
            }
         }
         return null;
      }
      
      private function btnsHandler(evt:MouseEvent) : void
      {
         var index:int = int(String(evt.currentTarget.name).charAt(3));
         if(this.Cloths[index + this.currentPage * this.PageNum] != null)
         {
            this.dispatchEvent(new MessageEvent("ShowSelectClothes",this.Cloths[index + this.currentPage * this.PageNum].list));
         }
      }
      
      private function upBtnHandler(evt:MouseEvent) : void
      {
         if(this.currentPage > 0)
         {
            this.showClothes(this.currentPage - 1);
         }
      }
      
      private function downBtnHandler(evt:MouseEvent) : void
      {
         if(this.currentPage < this.Page)
         {
            this.showClothes(this.currentPage + 1);
         }
      }
      
      private function showClothes(current:int) : void
      {
         var clothes:Object = null;
         this.currentPage = current;
         for(var i:int = 0; i < this.PageNum; i++)
         {
            clothes = this.Cloths[i + this.currentPage * this.PageNum];
            if(clothes != null)
            {
               bg["btn" + i].visible = true;
               bg["txt" + i].visible = true;
               bg["txt" + i].text = clothes.name + "";
            }
            else
            {
               bg["btn" + i].visible = false;
               bg["txt" + i].visible = false;
               bg["txt" + i].text = "";
            }
         }
      }
      
      override public function disport() : void
      {
         var i:int = 0;
         if(bg)
         {
            for(i = 0; i < this.PageNum; i++)
            {
               EventManager.removeEvent(bg["btn" + i],MouseEvent.MOUSE_DOWN,this.btnsHandler);
            }
            EventManager.removeEvent(bg.upBtn,MouseEvent.CLICK,this.upBtnHandler);
            EventManager.removeEvent(bg.downBtn,MouseEvent.CLICK,this.downBtnHandler);
         }
         super.disport();
      }
   }
}

