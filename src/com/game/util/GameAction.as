package com.game.util
{
   import com.game.locators.GameData;
   import com.game.modules.tweener.Tweener;
   import com.game.modules.view.MapView;
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.loading.GreenLoading;
   import com.publiccomponent.loading.MaterialLib;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.net.URLRequest;
   import org.plat.monitor.PlatMonitorLog;
   
   public class GameAction
   {
      
      public static var instance:GameAction = new GameAction();
      
      private var uiList:Array = [];
      
      private var mouseList:Array = [];
      
      private var effectList:Array = [];
      
      private var swfList:Array = [];
      
      private var _loader:Loader;
      
      private var parent:DisplayObjectContainer;
      
      private var x:Number;
      
      private var y:Number;
      
      private var handler:Function;
      
      private var bg:Sprite;
      
      private var loader:Loader;
      
      private var playObj:Object = {};
      
      private var jumpBtn:SimpleButton;
      
      private var actionName1:String;
      
      public function GameAction()
      {
         super();
      }
      
      public function play(parent:DisplayObjectContainer, sourceX:Number, sourceY:Number, destX:Number, destY:Number, actionId:int, userId:int, callBack:Function = null, data:Object = null) : void
      {
         if(actionId == 0)
         {
            actionId = 1;
         }
         var actionName:String = "action" + actionId;
         O.o("【GameAction....】",actionName);
         this.load(actionName);
         this.playObj.parent = parent;
         this.playObj.sourceX = sourceX;
         this.playObj.sourceY = sourceY;
         this.playObj.destX = destX;
         this.playObj.destY = destY;
         this.playObj.actionId = actionId;
         this.playObj.userId = userId;
         this.playObj.callBack = callBack;
         this.playObj.data = data;
      }
      
      private function load(name:String) : void
      {
         if(this.loader == null)
         {
            this.loader = new Loader();
         }
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoadComplete);
         this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onIoErrorHandler);
         this.loader.load(new URLRequest(URLUtil.getSvnVer("assets/gameAction/" + name + ".swf")));
         this.actionName1 = name;
      }
      
      private function onIoErrorHandler(e:IOErrorEvent) : void
      {
         O.o("没有GameAction,回调 ");
         if(this.playObj.callBack != null)
         {
            this.playObj.callBack(this.playObj.data);
            return;
         }
      }
      
      private function onLoadComplete(evt:Event) : void
      {
         var ui:MovieClip = this.loader.content as MovieClip;
         if(ui == null)
         {
            if(this.playObj.callBack != null)
            {
               this.playObj.callBack(this.playObj.data);
            }
            return;
         }
         var uiWidth:Number = ui.width;
         ui.x = this.playObj.sourceX;
         ui.y = this.playObj.sourceY;
         ui.mouseEnabled = false;
         var q:Number = Math.atan2(this.playObj.destY - this.playObj.sourceY,this.playObj.destX - this.playObj.sourceX);
         if(q < 0)
         {
            q += 2 * Math.PI;
         }
         var distance:Number = Math.sqrt((this.playObj.destY - this.playObj.sourceY) * (this.playObj.destY - this.playObj.sourceY) + (this.playObj.destX - this.playObj.sourceX) * (this.playObj.destX - this.playObj.sourceX));
         ui.rotation = q * 180 / Math.PI;
         this.playObj.destX -= uiWidth * Math.cos(q);
         this.playObj.destY -= uiWidth * Math.sin(q);
         var gloPoint:Point = this.playObj.parent.localToGlobal(new Point(this.playObj.destX,this.playObj.destY));
         var gloDestX:Number = gloPoint.x;
         var gloDestY:Number = gloPoint.y;
         if(gloDestX < -100 || gloDestX > 1070)
         {
            return;
         }
         if(gloDestY < -100 || gloDestY > 670)
         {
            return;
         }
         this.playObj.parent.addChild(ui);
         new Tweener().addTween(ui,int(this.playObj.destX),int(this.playObj.destY),15,this.playObj.userId,this.playObj.callBack,this.playObj.data);
         if(Boolean(this.loader))
         {
            this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onIoErrorHandler);
            this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoadComplete);
            this.loader.unload();
            this.loader = null;
         }
      }
      
      public function playMouseEffect(parent:DisplayObjectContainer, xCoord:Number, yCoord:Number) : void
      {
         var mouseUI:MovieClip = MaterialLib.getInstance().getMaterial("shubiao2") as MovieClip;
         mouseUI.x = xCoord;
         mouseUI.y = yCoord;
         mouseUI.mouseEnabled = false;
         mouseUI.mouseChildren = false;
         parent.addChild(mouseUI);
         this.mouseList.push(mouseUI);
         mouseUI.addFrameScript(mouseUI.totalFrames - 1,null);
         mouseUI.addFrameScript(mouseUI.totalFrames - 1,this.remove);
      }
      
      public function playEffect(parent:DisplayObjectContainer, xCoord:Number, yCoord:Number, effectURL:String, callback:Function = null) : void
      {
         this.handler = callback;
         var effectUI:MovieClip = MaterialLib.getInstance().getMaterial(effectURL) as MovieClip;
         effectUI.x = xCoord;
         effectUI.y = yCoord;
         parent.addChild(effectUI);
         this.effectList.push(effectUI);
         effectUI.addFrameScript(effectUI.totalFrames - 1,null);
         effectUI.addFrameScript(effectUI.totalFrames - 1,this.removeEffect);
      }
      
      public function playSwf(parent:DisplayObjectContainer, xCoord:Number, yCoord:Number, url:String, onComplete:Function = null, type:int = 0, bJump:Boolean = false) : void
      {
         var color:uint = 0;
         var visible:Number = NaN;
         GameData.instance.playerData.playswfStatus = true;
         this.parent = parent;
         this.x = xCoord;
         this.y = yCoord;
         this.handler = onComplete;
         GreenLoading.loading.loadModule("请稍候...",url,this.swfReady,this.removeSwf);
         MapView.instance.masterPerson.stop();
         switch(type)
         {
            case 0:
               color = 16777215;
               visible = 0;
               break;
            case 1:
               color = 0;
               visible = 0.95;
               break;
            case 2:
               color = 0;
               visible = 0.1;
         }
         this.bg = new Sprite();
         this.bg.graphics.beginFill(color,visible);
         this.bg.graphics.drawRect(0,0,970,570);
         this.bg.graphics.endFill();
         this.parent.stage.addChild(this.bg);
         this.parent.stage.swapChildren(this.bg,this.parent.stage.getChildAt(this.parent.stage.numChildren - 1));
         this.bg.x = 0;
         this.bg.y = 0;
         this.parent.mouseEnabled = false;
         this.bg.visible = false;
         if(bJump)
         {
            this.jumpBtn = MaterialLib.getInstance().getMaterial("jumpBtn") as SimpleButton;
            this.jumpBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.onGoBtnHandler);
            if(this.x == 0 && this.y == 0)
            {
               this.jumpBtn.x = 850;
               this.jumpBtn.y = 10;
            }
            else
            {
               this.jumpBtn.x = 660;
               this.jumpBtn.y = 100;
            }
            this.parent.stage.addChild(this.jumpBtn);
         }
      }
      
      private function swfReady(disPlay:Loader) : void
      {
         if(disPlay == null)
         {
            this.removeSwf();
            return;
         }
         if(disPlay.contentLoaderInfo.bytesLoaded < disPlay.contentLoaderInfo.bytesTotal)
         {
            PlatMonitorLog.instance.writeNewLog(501);
            GreenLoading.loading.loadModule("请稍候...",disPlay.loaderInfo.url + new Date().getTime(),this.swfReady);
            return;
         }
         GreenLoading.loading.visible = false;
         this.bg.visible = true;
         this._loader = disPlay;
         var swfClip:MovieClip = disPlay.content as MovieClip;
         if(swfClip == null)
         {
            this.removeSwf();
            return;
         }
         swfClip.x = this.x;
         swfClip.y = this.y;
         if(swfClip.hasOwnProperty("btnNext"))
         {
            swfClip.gotoAndStop(1);
         }
         else
         {
            swfClip.gotoAndPlay(1);
         }
         swfClip.addFrameScript(swfClip.totalFrames - 1,this.removeSwf);
         this.swfList.push(swfClip);
         this.bg.addChild(swfClip);
         if(Boolean(swfClip) && Boolean(swfClip.hasOwnProperty("goBtn")))
         {
            swfClip.goBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.onGoBtnHandler);
         }
      }
      
      private function onGoBtnHandler(evt:MouseEvent) : void
      {
         this.removeSwf();
      }
      
      private function removeSwf() : void
      {
         var clip:MovieClip = null;
         if(this.swfList.length != 0)
         {
            clip = this.swfList.shift() as MovieClip;
            if(Boolean(clip.hasOwnProperty("goBtn")) && clip.goBtn != null)
            {
               clip.goBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.onGoBtnHandler);
            }
            clip.addFrameScript(clip.totalFrames - 1,null);
            clip.stop();
            this._loader.unloadAndStop();
            if(clip.parent != null)
            {
               if(clip.parent.contains(clip))
               {
                  clip.parent.removeChild(clip);
               }
            }
            this._loader = null;
            clip = null;
         }
         if(this.bg != null && this.bg.parent != null)
         {
            this.bg.graphics.clear();
            this.bg.parent.removeChild(this.bg);
            this.bg = null;
            this.parent.mouseEnabled = true;
         }
         if(this.handler != null)
         {
            this.handler.apply(null,[null]);
         }
         GameData.instance.playerData.playswfStatus = false;
         if(Boolean(this.jumpBtn))
         {
            this.jumpBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.onGoBtnHandler);
            if(this.jumpBtn.parent != null)
            {
               if(this.jumpBtn.parent.contains(this.jumpBtn))
               {
                  this.jumpBtn.parent.removeChild(this.jumpBtn);
               }
            }
         }
      }
      
      public function playEffectByMovieClip(parent:DisplayObjectContainer, xCoord:Number, yCoord:Number, effectUI:MovieClip) : void
      {
         effectUI.x = xCoord;
         effectUI.y = yCoord;
         parent.addChild(effectUI);
         this.effectList.push(effectUI);
         effectUI.addFrameScript(effectUI.totalFrames - 1,null);
         effectUI.addFrameScript(effectUI.totalFrames - 1,this.removeEffect);
      }
      
      private function removeEffect() : void
      {
         var clip:MovieClip = null;
         if(this.effectList.length != 0)
         {
            clip = this.effectList.shift() as MovieClip;
            clip.addFrameScript(clip.totalFrames - 1,null);
            clip.stop();
            if(clip.parent != null)
            {
               if(clip.parent.contains(clip))
               {
                  clip.parent.removeChild(clip);
               }
            }
            clip = null;
         }
         if(this.handler != null)
         {
            this.handler.apply(null,[null]);
         }
      }
      
      private function remove() : void
      {
         var clip:MovieClip = null;
         if(this.mouseList.length != 0)
         {
            clip = this.mouseList.shift() as MovieClip;
            clip.stop();
            clip.addFrameScript(clip.totalFrames - 1,null);
            if(clip.parent != null)
            {
               if(clip.parent.contains(clip))
               {
                  clip.parent.removeChild(clip);
               }
            }
            clip = null;
         }
      }
      
      public function playExistMovieClip(clip:MovieClip, frameFunction:Function) : void
      {
         clip.gotoAndPlay(2);
         clip.addFrameScript(clip.totalFrames - 1,null);
         clip.addFrameScript(clip.totalFrames - 1,frameFunction);
      }
      
      public function shirenhuaPlay(clip:MovieClip, frameFunction1:Function, frameFunction2:Function) : void
      {
         MapView.instance.masterPerson.stop();
         ScreenSprite.instance.show(true);
         (MapView.instance.scene.bg["getChildAt"](0)["getChildAt"](1) as MovieClip).gotoAndPlay(2);
         (MapView.instance.scene.bg["getChildAt"](0)["getChildAt"](1) as MovieClip).addFrameScript(23,frameFunction1);
         (MapView.instance.scene.bg["getChildAt"](0)["getChildAt"](1) as MovieClip).addFrameScript(57,frameFunction2);
      }
   }
}

