package com.publiccomponent.quickmsg.item
{
   import flash.display.*;
   import flash.system.ApplicationDomain;
   
   public class QuickBackGround extends Sprite
   {
      
      private var index:int;
      
      private var xmllist:XMLList;
      
      private var xml:XML;
      
      public var bgmc:MovieClip;
      
      private var _application:ApplicationDomain;
      
      public function QuickBackGround(ad:ApplicationDomain, len:int, xmllist:XMLList = null, xml:XML = null)
      {
         super();
         this._application = ad;
         this.bgmc = this.getInstanceByClass("QuickBackGround")["bgmc"];
         this.bgmc.cacheAsBitmap = true;
         addChild(this.bgmc);
         if(Boolean(xmllist))
         {
            this.xmllist = xmllist;
         }
         if(Boolean(xml))
         {
            this.xml = xml;
         }
         this.setHeight(len);
      }
      
      public function getInstanceByClass(className:String) : Object
      {
         return new (this._application.getDefinition(className) as Class)();
      }
      
      public function setData2(len:int) : void
      {
         var item:QuickItem2 = null;
         var i:int = 0;
         this.index = this.y - 30;
         while(i < len)
         {
            item = new QuickItem2(this.getInstanceByClass("QuickItem2") as MovieClip,this.index,this.xml,i);
            this.addChild(item);
            this.index -= 30;
            i++;
         }
      }
      
      private function setHeight(len:int) : void
      {
         this.bgmc.height = len * 32;
      }
      
      public function setData(len:int) : void
      {
         var item:QuickItem = null;
         this.index = this.y - 35;
         var i:int = 0;
         while(i < len)
         {
            item = new QuickItem(this.getInstanceByClass("QuickItem") as MovieClip,this.index,this.xmllist[i],i);
            this.addChild(item);
            this.index -= 30;
            i++;
         }
      }
      
      public function dispos() : void
      {
         var display:* = null;
         this.bgmc = null;
         this.xmllist = null;
         this.xml = null;
         var i:* = 0;
         while(i < this.numChildren - 1)
         {
            try
            {
               display = this.getChildAt(i) as DisplayObject;
               display["dispos"]();
               display = null;
            }
            catch(e:Error)
            {
            }
            i += 1;
         }
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
      
      public function setindex(yindex:int) : void
      {
         this.x = 225;
         this.y = 500 - yindex;
      }
   }
}

