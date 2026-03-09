package com.game.modules.view.family
{
   import com.publiccomponent.URLUtil;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLRequest;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class FamilyBadge extends Sprite
   {
      
      public var mid_mc:MovieClip;
      
      private var sma_mc:*;
      
      public var circle_mc:MovieClip;
      
      public var name_txt:TextField;
      
      private var _name:String = "";
      
      private var loader1:Loader;
      
      private var loader2:Loader;
      
      private var url:String;
      
      private var badgeObject:Object = {};
      
      private var midcolor:int;
      
      private var circolor:int;
      
      private var scale:Number = 1;
      
      private var midid:Number = 1;
      
      public function FamilyBadge()
      {
         super();
         this.loader1 = new Loader();
         this.loader1.contentLoaderInfo.addEventListener(Event.COMPLETE,this.on_Complete_1);
         this.loader1.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.on_IOError_1);
         this.loader2 = new Loader();
         this.loader2.contentLoaderInfo.addEventListener(Event.COMPLETE,this.on_Complete_2);
         this.loader2.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.on_IOError_2);
         this.buttonMode = true;
         this.mouseChildren = false;
      }
      
      private function on_Complete_1(evt:Event) : void
      {
         this.mid_mc = (this.loader1.content as MovieClip).getChildAt(0) as MovieClip;
         this.mid_mc.gotoAndStop(this.midcolor);
         this.addChildAt(this.mid_mc,0);
         this.loader1.unloadAndStop(false);
      }
      
      private function on_IOError_1(evt:IOErrorEvent) : void
      {
         this.loader1.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.on_Complete_1);
         this.loader1.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.on_IOError_1);
      }
      
      private function on_Complete_2(evt:Event) : void
      {
         this.sma_mc = (this.loader2.content as MovieClip).getChildAt(0);
         this.circle_mc = (this.loader2.content as MovieClip).getChildAt(1) as MovieClip;
         this.name_txt = (this.loader2.content as MovieClip).getChildAt(2) as TextField;
         this.addChild(this.sma_mc);
         this.addChild(this.circle_mc);
         this.addChild(this.name_txt);
         this.loader2.unloadAndStop(false);
         this.setScale();
      }
      
      private function on_IOError_2(evt:IOErrorEvent) : void
      {
         this.loader2.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.on_Complete_2);
         this.loader2.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.on_IOError_2);
      }
      
      public function setBadge(midid:int, smallid:int, name:String, midcolor:int, circolor:int, scale:Number = 1) : void
      {
         this.scale = scale;
         this.midid = midid;
         this.midcolor = midcolor;
         this.circolor = circolor;
         this.changeByMidId(midid);
         this.changeBySmallId(smallid);
         this.changeName(name);
      }
      
      public function getBadgeObject() : Object
      {
         this.badgeObject.midcolor = this.mid_mc.currentFrame;
         this.badgeObject.circolor = this.circle_mc.currentFrame;
         return this.badgeObject;
      }
      
      public function changeByMidId(midid:int) : void
      {
         midid = midid > 0 ? midid : 1;
         this.badgeObject.midid = midid;
         if(Boolean(this.mid_mc) && this.contains(this.mid_mc))
         {
            this.removeChild(this.mid_mc);
         }
         this.url = URLUtil.getSvnVer("assets/family/mid_to_big" + midid + ".swf");
         this.loader1.unload();
         this.loader1.load(new URLRequest(this.url));
      }
      
      public function changeBySmallId(smallid:int) : void
      {
         smallid = smallid > 0 ? smallid : 1;
         this.badgeObject.smallid = smallid;
         if(this.sma_mc && this.contains(this.sma_mc))
         {
            this.removeChild(this.sma_mc);
         }
         if(Boolean(this.circle_mc) && this.contains(this.circle_mc))
         {
            this.removeChild(this.circle_mc);
         }
         if(Boolean(this.name_txt) && this.contains(this.name_txt))
         {
            this.removeChild(this.name_txt);
         }
         this.url = URLUtil.getSvnVer("assets/family/small_to_big_" + smallid + ".swf");
         this.loader2.unload();
         this.loader2.load(new URLRequest(this.url));
      }
      
      public function changeName(str:String) : void
      {
         str = str == null ? "" : str;
         str = str.length > 1 ? "" : str;
         this._name = str;
         this.badgeObject._name = str;
         if(this.circle_mc == null)
         {
            return;
         }
         if(this.circle_mc.currentFrame == 8)
         {
            this.name_txt.htmlText = "<font color=\'#FFFFFF\'>" + str + "</font>";
         }
         else
         {
            this.name_txt.htmlText = "<font color=\'#000000\'>" + str + "</font>";
         }
      }
      
      private function setScale() : void
      {
         this.scaleX = this.scale;
         this.scaleY = this.scale;
         this.name_txt.scaleX = 1 / this.scale;
         this.name_txt.scaleY = 1 / this.scale;
         if(this.scale < 1)
         {
            this.name_txt.x -= 1 / this.scale;
            this.name_txt.y -= 1 / this.scale;
            if(this.scale <= 0.5)
            {
               this.name_txt.x -= 6;
               this.name_txt.y -= 6;
            }
         }
         this.circle_mc.gotoAndStop(this.circolor);
         if(this.midid > 10)
         {
            this.name_txt.x += 1 / this.scale;
            this.name_txt.y += 1 / this.scale;
            this.name_txt.defaultTextFormat = new TextFormat("宋体",12,10027008);
            if(this.scale == 1)
            {
               this.name_txt.scaleX = 2;
               this.name_txt.scaleY = 2;
            }
         }
         else
         {
            this.name_txt.defaultTextFormat = new TextFormat("黑体");
         }
         if(this.circle_mc.currentFrame == 8)
         {
            this.name_txt.htmlText = "<font color=\'#FFFFFF\'>" + this._name + "</font>";
         }
         else
         {
            this.name_txt.htmlText = "<font color=\'#000000\'>" + this._name + "</font>";
         }
      }
      
      public function dispos() : void
      {
         if(Boolean(this.loader1.contentLoaderInfo) && this.loader1.contentLoaderInfo.hasEventListener(Event.COMPLETE))
         {
            this.loader1.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.on_Complete_1);
            this.loader1.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.on_IOError_1);
         }
         this.loader1.unload();
         this.loader1 = null;
         if(Boolean(this.loader2.contentLoaderInfo) && this.loader2.contentLoaderInfo.hasEventListener(Event.COMPLETE))
         {
            this.loader2.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.on_Complete_2);
            this.loader2.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.on_IOError_2);
         }
         this.loader2.unload();
         this.loader2 = null;
         if(Boolean(this.mid_mc) && this.contains(this.mid_mc))
         {
            this.removeChild(this.mid_mc);
         }
         if(this.sma_mc && this.contains(this.sma_mc))
         {
            this.removeChild(this.sma_mc);
         }
         if(Boolean(this.circle_mc) && this.contains(this.circle_mc))
         {
            this.removeChild(this.circle_mc);
         }
         if(Boolean(this.name_txt) && this.contains(this.name_txt))
         {
            this.removeChild(this.name_txt);
         }
         this.mid_mc = null;
         this.sma_mc = null;
         this.circle_mc = null;
         this.name_txt = null;
         if(Boolean(this.parent) && this.parent.contains(this))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

