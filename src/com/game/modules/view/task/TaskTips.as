package com.game.modules.view.task
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.util.GameDynamicUI;
   import com.game.util.PropertyPool;
   import com.publiccomponent.URLUtil;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.events.ProgressEvent;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   
   public class TaskTips extends Sprite
   {
      
      private var loader:Loader;
      
      private var flag:Boolean;
      
      private var title:String;
      
      private var content:String;
      
      private var url:String;
      
      private var callback:Function;
      
      private var shape:Sprite;
      
      private var targetScene:int;
      
      private var tasknameXML:XML;
      
      private var imgLoader:Loader;
      
      private var tipsList:Array;
      
      private var tipIndex:int;
      
      public function TaskTips()
      {
         super();
         this.shape = new Sprite();
         this.shape.graphics.beginFill(16777215,0);
         this.shape.graphics.drawRect(0,0,970,570);
         this.shape.graphics.endFill();
         this.addChild(this.shape);
         this.shape.x = 0;
         this.shape.y = 0;
         this.shape.mouseChildren = false;
         this.shape.mouseEnabled = false;
         PropertyPool.instance.getXML("config/","tasknameprop",this.onLoadPropertyBack);
      }
      
      private function onLoadPropertyBack(xml:XML, ... rest) : void
      {
         this.tasknameXML = xml;
         this.loader = new Loader();
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoadComplete);
         this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
         this.loader.load(new URLRequest(URLUtil.getSvnVer("assets/material/taskalert.swf")));
      }
      
      private function onLoadComplete(evt:Event) : void
      {
         var domain:ApplicationDomain = null;
         var cls:Class = null;
         var mc:MovieClip = null;
         var smallmc:MovieClip = null;
         try
         {
            domain = evt.currentTarget.applicationDomain as ApplicationDomain;
            cls = domain.getDefinition("tips") as Class;
            mc = new cls() as MovieClip;
            mc.imgBG.visible = false;
            this.addChild(mc);
            mc.x = 240;
            mc.y = 70;
            cls = domain.getDefinition("stips") as Class;
            smallmc = new cls() as MovieClip;
            this.addChild(smallmc);
            smallmc.x = 305;
            smallmc.y = 188;
            smallmc.visible = false;
            this.cacheAsBitmap = true;
            mc.cacheAsBitmap = true;
            smallmc.cacheAsBitmap = true;
            this.tipsList = new Array(2);
            this.tipsList[0] = mc;
            this.tipsList[1] = smallmc;
            this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoadComplete);
            this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
            this.loader.unloadAndStop(true);
            this.loader = null;
            if(this.content != null && this.content.length > 0 || this.url.length > 0)
            {
               this.show();
            }
         }
         catch(e:*)
         {
            this.onLoadError(null);
         }
      }
      
      private function onLoadError(evt:IOErrorEvent) : void
      {
         if(Boolean(evt))
         {
            O.o("加载出错了：TaskAlert....." + evt);
         }
         this.dispos();
      }
      
      private function dispos() : void
      {
         GameDynamicUI.removeUI("loading");
         if(Boolean(this.loader))
         {
            this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoadImgError);
            this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoadImgComplete);
            this.loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,this.onLoadImgProgress);
            this.loader.unloadAndStop(true);
            if(Boolean(this.tipsList[this.tipIndex].imgBG) && Boolean(this.tipsList[this.tipIndex].imgBG["contains"](this.loader)))
            {
               this.tipsList[this.tipIndex].imgBG.removeChild(this.loader);
            }
            this.loader = null;
         }
         if(Boolean(this.imgLoader))
         {
            this.imgLoader.unloadAndStop();
            this.imgLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoadNameComplete);
            this.imgLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoadNameError);
            this.imgLoader = null;
         }
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
         if(this.callback != null)
         {
            this.callback.apply(null,[]);
         }
      }
      
      private function onMouseDown(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         this.tipsList[this.tipIndex].close.removeEventListener(MouseEvent.CLICK,this.onMouseDown);
         this.dispos();
      }
      
      private function onGo(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         this.tipsList[this.tipIndex].btnGo.removeEventListener(MouseEvent.CLICK,this.onGo);
         ApplicationFacade.getInstance().dispatch(EventConst.SENDUSERTOOTHERSCENE,this.targetScene);
         this.dispos();
      }
      
      public function showTips(title:String, content:String, url:String, callback:Function = null, sceneId:int = 0) : void
      {
         GameDynamicUI.addUI(this.stage,200,200,"loading");
         this.visible = false;
         this.title = title;
         this.content = content;
         this.url = url;
         this.callback = callback;
         this.targetScene = sceneId;
         this.tipIndex = 0;
         if(this.tipsList != null && this.tipsList.length == 2)
         {
            this.show();
         }
      }
      
      private function show() : void
      {
         if(this.url.length > 0 && this.url != "null")
         {
            this.tipIndex = 0;
            this.tipsList[0].visible = true;
            this.tipsList[1].visible = false;
            this.loader = new Loader();
            this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onLoadImgError);
            this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoadImgComplete);
            this.loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.onLoadImgProgress);
            this.loader.load(new URLRequest(URLUtil.getSvnVer(this.url)));
         }
         else
         {
            this.tipIndex = 1;
            this.tipsList[0].visible = false;
            this.tipsList[1].visible = true;
            GameDynamicUI.removeUI("loading");
            this.visible = true;
         }
         if(Boolean(this.tipsList[this.tipIndex].hasOwnProperty("btnGo")))
         {
            this.tipsList[this.tipIndex].btnGo.visible = this.targetScene > 0;
            this.tipsList[this.tipIndex].btnGo.addEventListener(MouseEvent.CLICK,this.onGo);
         }
         this.getTaskNameImg(this.title);
         this.tipsList[this.tipIndex].tipsTF.htmlText = "";
         this.tipsList[this.tipIndex].tipsTF.htmlText = this.content;
         this.tipsList[this.tipIndex].close.addEventListener(MouseEvent.CLICK,this.onMouseDown);
      }
      
      private function onLoadImgComplete(evt:Event) : void
      {
         evt.stopImmediatePropagation();
         if(this.tipIndex != 0)
         {
            return;
         }
         this.tipsList[this.tipIndex].imgBG.addChildAt(this.loader,1);
         this.loader.mask = (this.tipsList[this.tipIndex].imgBG as MovieClip).getChildAt(2);
         this.tipsList[this.tipIndex].imgBG.visible = true;
         this.loader.x = 0;
         this.loader.y = 0;
         GameDynamicUI.removeUI("loading");
         this.visible = true;
      }
      
      private function onLoadImgProgress(evt:ProgressEvent) : void
      {
      }
      
      private function onLoadImgError(evt:IOErrorEvent) : void
      {
         this.loader.load(new URLRequest(URLUtil.getSvnVer("assets/dialogimg/feifeinvshi.swf")));
         O.o("【TaskTips加载失败：】 赶紧叫美工出图啊.....木有图...叫我没用啊...." + this.url);
      }
      
      private function getTaskNameImg(str:String) : void
      {
         var subxml:XML = null;
         var tmp:int = 0;
         var targetID:String = null;
         if(this.tasknameXML == null)
         {
            return;
         }
         subxml = this.tasknameXML.children().(@name == str)[0] as XML;
         if(subxml == null)
         {
            return;
         }
         tmp = int(subxml.@id);
         targetID = "pic";
         if(tmp < 10)
         {
            targetID += "000" + tmp;
         }
         else if(tmp < 100)
         {
            targetID += "00" + tmp;
         }
         else if(tmp < 1000)
         {
            targetID += "0" + tmp;
         }
         else
         {
            targetID += "" + tmp;
         }
         this.imgLoader = new Loader();
         this.imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoadNameComplete);
         this.imgLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onLoadNameError);
         this.imgLoader.load(new URLRequest("assets/tasknameimg/" + targetID + ".png"));
      }
      
      private function onLoadNameComplete(evt:Event) : void
      {
         evt.stopImmediatePropagation();
         this.imgLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoadNameComplete);
         this.imgLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoadNameError);
         this.tipsList[this.tipIndex].addChild(this.imgLoader);
         if(this.tipIndex == 0)
         {
            this.imgLoader.x = 106;
            this.imgLoader.y = 10;
         }
         else
         {
            this.imgLoader.x = 34;
            this.imgLoader.y = 0;
         }
      }
      
      private function onLoadNameError(evt:IOErrorEvent) : void
      {
         evt.stopImmediatePropagation();
         this.imgLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoadNameComplete);
         this.imgLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoadNameError);
      }
      
      private function onLoadNameProgress(evt:ProgressEvent) : void
      {
         evt.stopImmediatePropagation();
      }
   }
}

