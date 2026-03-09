package com.game.modules.view.achieve
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.util.HLoaderSprite;
   import com.publiccomponent.loading.HurlLoader;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.net.URLLoaderDataFormat;
   import flash.utils.ByteArray;
   import flash.utils.getQualifiedClassName;
   
   public class GetAchieve extends HLoaderSprite
   {
      
      private var urlloader:HurlLoader;
      
      private var tempid:int;
      
      private var achievexml:XML;
      
      public function GetAchieve()
      {
         super();
         this.showloading = false;
      }
      
      override public function initParams(params:Object = null) : void
      {
         this.tempid = params.id;
         this.url = "assets/achieve/getachieve.swf";
      }
      
      private function onxmlcomplete(evt:Event) : void
      {
         var bytearray:ByteArray = null;
         var str:String = null;
         var l:int = 0;
         var i:int = 0;
         var xml:XML = null;
         var index:int = 0;
         this.urlloader.removeEventListener(Event.COMPLETE,this.onxmlcomplete);
         evt.stopImmediatePropagation();
         try
         {
            bytearray = this.urlloader.data as ByteArray;
            bytearray.uncompress();
            bytearray.position = 0;
            str = "";
            str = bytearray.readUTFBytes(bytearray.length);
            bytearray.clear();
            this.achievexml = new XML(str);
            if(this.urlloader == null)
            {
               return;
            }
            this.urlloader.removeEventListener(Event.COMPLETE,this.onxmlcomplete);
            this.urlloader = null;
            if(bg == null)
            {
               return;
            }
            this.bg.showmc.stop();
            l = int(this.achievexml.children().children()["achieve"].length());
            i = 0;
            for(i = 0; i < l; i++)
            {
               if(this.achievexml.children().children()["achieve"][i]["achid"] == this.tempid)
               {
                  xml = this.achievexml.children().children()["achieve"][i];
                  break;
               }
            }
            if(xml == null)
            {
               this.disport();
            }
            this.bg.titletxt.text = xml.@name;
            this.bg.contenttxt.text = xml.txt;
            this.bg.numtxt.text = xml.score;
            index = int(xml.classindex);
            this.bg.starmc.gotoAndStop(index);
            this.bg.showmc.addFrameScript(17,this.showall);
            this.bg.showmc.addFrameScript(this.bg.showmc.totalFrames - 1,this.onclose);
            this.bg.showmc.visible = true;
            this.bg.showmc.gotoAndPlay(1);
            this.bg.buttonMode = true;
            this.bg.addEventListener(MouseEvent.MOUSE_DOWN,this.ondown);
         }
         catch(e:*)
         {
         }
      }
      
      override public function setShow() : void
      {
         this.noshow();
         this.urlloader = new HurlLoader("config/Achieve",null,URLLoaderDataFormat.BINARY);
         this.urlloader.addEventListener(Event.COMPLETE,this.onxmlcomplete);
         this.urlloader.addEventListener(IOErrorEvent.IO_ERROR,this.onAchieveError);
      }
      
      private function onAchieveError(evt:IOErrorEvent) : void
      {
         this.urlloader.removeEventListener(IOErrorEvent.IO_ERROR,this.onAchieveError);
         trace("获得成就配置有错啦");
         this.disport();
      }
      
      private function noshow() : void
      {
         this.bg.titletxt.visible = false;
         this.bg.contenttxt.visible = false;
         this.bg.numtxt.visible = false;
         this.bg.starmc.visible = false;
         this.bg.titletxt.mouseEnabled = false;
         this.bg.contenttxt.mouseEnabled = false;
         this.bg.numtxt.mouseEnabled = false;
         this.bg.starmc.mouseEnabled = false;
         this.bg.showmc.visible = false;
      }
      
      private function showall() : void
      {
         this.bg.showmc.addFrameScript(17,null);
         this.bg.titletxt.visible = true;
         this.bg.contenttxt.visible = true;
         this.bg.numtxt.visible = true;
         this.bg.starmc.visible = true;
      }
      
      private function onclose() : void
      {
         this.bg.showmc.addFrameScript(this.bg.showmc.totalFrames - 1,null);
         this.disport();
      }
      
      private function ondown(evt:MouseEvent) : void
      {
         ApplicationFacade.getInstance().dispatch(EventConst.OPEN_CACHE_VIEW,{
            "showX":0,
            "showY":0
         },null,getQualifiedClassName(AchieveView));
      }
      
      private function removeEvents() : void
      {
         if(bg)
         {
            this.bg.removeEventListener(MouseEvent.MOUSE_DOWN,this.ondown);
            this.bg.showmc.addFrameScript(17,null);
            this.bg.showmc.addFrameScript(this.bg.showmc.totalFrames - 1,null);
         }
         if(Boolean(this.urlloader))
         {
            this.urlloader.removeEventListener(Event.COMPLETE,this.onxmlcomplete);
            this.urlloader.removeEventListener(IOErrorEvent.IO_ERROR,this.onAchieveError);
            this.urlloader = null;
         }
      }
      
      override public function disport() : void
      {
         this.removeEvents();
         this.achievexml = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
         super.disport();
      }
   }
}

