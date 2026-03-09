package com.game.modules.view.person
{
   import com.game.util.HLoaderSprite;
   import flash.events.MouseEvent;
   
   public class TitleList extends HLoaderSprite
   {
      
      private var data:Object;
      
      private var titlexml:XMLList;
      
      private var index:int;
      
      public function TitleList()
      {
         super();
         this.url = "assets/personinfo/showachieve.swf";
      }
      
      override public function setShow() : void
      {
         this.bg.cacheAsBitmap = true;
         this.initEvents();
      }
      
      public function setdata(data:Object, titlexml:XMLList) : void
      {
         this.data = data;
         this.titlexml = titlexml;
         this.filter();
         this.initList();
      }
      
      private function initEvents() : void
      {
         this.bg.upbtn.addEventListener(MouseEvent.CLICK,this.onup);
         this.bg.downbtn.addEventListener(MouseEvent.CLICK,this.ondown);
         for(var i:int = 1; i < 11; i++)
         {
            this.bg["txt" + i].addEventListener(MouseEvent.MOUSE_DOWN,this.ontxtdown);
         }
      }
      
      private function removeEvents() : void
      {
         this.bg.upbtn.removeEventListener(MouseEvent.CLICK,this.onup);
         this.bg.downbtn.removeEventListener(MouseEvent.CLICK,this.ondown);
         for(var i:int = 1; i < 11; i++)
         {
            this.bg["txt" + i].removeEventListener(MouseEvent.MOUSE_DOWN,this.ontxtdown);
         }
      }
      
      private function onup(evt:MouseEvent) : void
      {
         if(this.index <= 0)
         {
            return;
         }
         --this.index;
         this.initList();
      }
      
      private function ondown(evt:MouseEvent) : void
      {
         if(this.data == null)
         {
            return;
         }
         if(this.index + 10 >= this.data.titlearr.length)
         {
            return;
         }
         ++this.index;
         this.initList();
      }
      
      private function ontxtdown(evt:MouseEvent) : void
      {
         this.parent["settitle"](String(evt.currentTarget.text));
      }
      
      private function filter() : void
      {
         var i:int;
         var titlearr:Array = this.data.titlearr;
         var len:int = int(titlearr.length);
         for(i = len - 1; i >= 0; i--)
         {
            if(String(this.titlexml.(@id == int(titlearr[i])).txt) == "" || titlearr[i] == 0)
            {
               titlearr.splice(i,1);
            }
         }
      }
      
      private function initList() : void
      {
         var i:int;
         var j:int;
         var arr:Array = [];
         var titlearr:Array = this.data.titlearr;
         for(i = this.index; i < this.index + 10; i++)
         {
            if(titlearr[i] == null)
            {
               break;
            }
            arr.push(int(titlearr[i]));
         }
         for(j = 1; j < 11; j++)
         {
            if(arr[j - 1] == null)
            {
               break;
            }
            this.bg["txt" + j].text = String(this.titlexml.(@id == arr[j - 1]).txt);
         }
      }
      
      override public function disport() : void
      {
         this.removeEvents();
         this.data = null;
         this.titlexml = null;
         super.disport();
      }
   }
}

