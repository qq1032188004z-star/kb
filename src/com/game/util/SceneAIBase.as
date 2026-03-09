package com.game.util
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.manager.MouseManager;
   import com.game.modules.control.task.TaskEvent;
   import com.game.modules.control.task.util.TaskUtils;
   import com.publiccomponent.URLUtil;
   import flash.display.DisplayObject;
   import flash.display.FrameLabel;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   import org.engine.core.GameSprite;
   
   public class SceneAIBase extends GameSprite
   {
      
      public var sceneAIClip:MovieClip;
      
      public var loader:Loader;
      
      private var loadCompleteCallback:Function;
      
      private var playEffectCallback:Function;
      
      private var mapid:int;
      
      private var _url:String;
      
      private var _watchURL:String = "";
      
      private var display:DisplayObject;
      
      private var watchFlag:Boolean;
      
      public function SceneAIBase(param:Object)
      {
         try
         {
            this.sequenceID = param.sequenceID;
            this.x = param.x;
            this.y = param.y;
            this._watchURL = param.watchURL;
            this.mapid = param.mapid;
            this._url = param.url + ".swf";
            super();
            ui = new Sprite();
            Sprite(ui).cacheAsBitmap = true;
            this.loader = new Loader();
         }
         catch(e:*)
         {
            O.o("ai实例化");
         }
      }
      
      public function load(... rest) : void
      {
         this.loadCompleteCallback = rest[0];
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.loadFinished);
         this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
         this.loader.load(new URLRequest(URLUtil.getSvnVer(this._url)));
         if(this._watchURL != "" && this._watchURL.length > 0 && this._watchURL != "null")
         {
            this.ui.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDownSceneAIBase);
         }
      }
      
      private function loadFinished(evt:Event) : void
      {
         if(this.loadCompleteCallback != null)
         {
            this.loadCompleteCallback.apply(null,[evt]);
         }
         if(this.loader != null)
         {
            this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.loadFinished);
            this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
            this.loader.unloadAndStop();
         }
      }
      
      public function update(param:Object) : void
      {
         try
         {
            if(param.hasOwnProperty("x"))
            {
               this.x = param.x;
            }
            if(param.hasOwnProperty("y"))
            {
               this.y = param.y;
            }
         }
         catch(e:*)
         {
            O.o("ai -- > update");
         }
      }
      
      private function onLoadError(evt:IOErrorEvent) : void
      {
         O.o("++++____++++ 场景中的AI和特殊区域加载出错：   ",evt);
         evt.stopImmediatePropagation();
         if(this.loader == null)
         {
            return;
         }
         this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.loadFinished);
         this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
         this.loader.unloadAndStop();
         this.dispos();
      }
      
      override public function zoom() : void
      {
         var scale:Number = 1 - (570 - y) / 570 + 0.45;
         if(scale > 1)
         {
            scale = 1;
         }
         if(ui != null)
         {
            ui.scaleX = scale;
            ui.scaleY = scale;
         }
      }
      
      public function addChild(display:DisplayObject) : void
      {
         try
         {
            display.name = this.spriteName;
         }
         catch(e:*)
         {
            O.o(display + "    没能把spriteName赋值给这个场景AI  ");
         }
         Sprite(ui).addChild(display);
         if(display is MovieClip && (display as MovieClip).totalFrames > 1)
         {
            (display as MovieClip).play();
         }
      }
      
      public function removeChild(display:DisplayObject, needPlay:Boolean = true) : void
      {
         this.display = display;
         if(display is MovieClip && needPlay && (display as MovieClip).currentFrame < (display as MovieClip).totalFrames)
         {
            (display as MovieClip).addFrameScript((display as MovieClip).totalFrames,this.destroyMe);
            (display as MovieClip).play();
         }
         else
         {
            this.destroyMe();
         }
      }
      
      private function destroyMe() : void
      {
         if(this.display.hasOwnProperty("disport"))
         {
            this.display["disport"]();
         }
         else if(this.display is MovieClip)
         {
            (this.display as MovieClip).stop();
         }
         else if(this.display is Loader)
         {
            (this.display as Loader).unloadAndStop();
         }
         if(Sprite(ui).contains(this.display))
         {
            Sprite(ui).removeChild(this.display);
         }
         this.display = null;
      }
      
      override public function dispos() : void
      {
         if(this.loader != null)
         {
            if(this.loader.contentLoaderInfo.hasEventListener(Event.COMPLETE))
            {
               this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.loadCompleteCallback);
               this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
            }
            this.loader.unloadAndStop(true);
            this.loader = null;
         }
         this.loadCompleteCallback = null;
         if(this.sceneAIClip != null)
         {
            this.releaseEffect();
            this.sceneAIClip.stop();
            this.removeEvent();
         }
         super.dispos();
      }
      
      public function removeEvent() : void
      {
      }
      
      public function playEffect(callback:Function = null) : void
      {
         if(this.sceneAIClip.currentFrame < this.sceneAIClip.totalFrames)
         {
            this.sceneAIClip.nextFrame();
            this.sceneAIClip.play();
         }
         if(callback != null)
         {
            this.playEffectCallback = callback;
         }
      }
      
      public function initEffect() : void
      {
         var tempArr:Array = null;
         var i:int = 0;
         var len:int = 0;
         var frameLabel:FrameLabel = null;
         if(this.sceneAIClip.totalFrames > 1)
         {
            tempArr = this.sceneAIClip.currentLabels;
            i = 0;
            len = int(tempArr.length);
            for(i = 0; i < len; i++)
            {
               frameLabel = tempArr[i];
               if(frameLabel.name == "first" || frameLabel.name == "second" || frameLabel.name == "third")
               {
                  if(frameLabel.frame > 1)
                  {
                     this.sceneAIClip.addFrameScript(frameLabel.frame - 1,this.onPlayEffectTo);
                  }
               }
            }
         }
      }
      
      public function releaseEffect() : void
      {
         var frameLabel:FrameLabel = null;
         var temp:Array = this.sceneAIClip.currentLabels;
         for each(frameLabel in temp)
         {
            this.sceneAIClip.addFrameScript(frameLabel.frame - 1,null);
         }
      }
      
      private function onPlayEffectTo() : void
      {
         this.sceneAIClip.stop();
         if(this.playEffectCallback != null)
         {
            this.playEffectCallback.apply(null,[this.spriteName]);
         }
      }
      
      override public function get sortY() : Number
      {
         var sortHeight:Number = NaN;
         var rect:Rectangle = null;
         if(this.sceneAIClip != null)
         {
            rect = this.sceneAIClip.getRect(this.sceneAIClip);
            sortHeight = this.y + rect.y + rect.bottom;
         }
         return sortHeight;
      }
      
      private function onMouseDownSceneAIBase(evt:MouseEvent) : void
      {
         if(MouseManager.getInstance().cursorName == "CursorTool2003")
         {
            if(!TaskUtils.getInstance().hasEventListener(TaskEvent.OP_MOUSE_ACTION_AI))
            {
               this.watchFlag = true;
               TaskUtils.getInstance().addEventListener(TaskEvent.OP_MOUSE_ACTION_AI,this.onUseWatch);
            }
         }
      }
      
      private function onUseWatch(evt:TaskEvent) : void
      {
         if(this.watchFlag)
         {
            TaskUtils.getInstance().removeEventListener(TaskEvent.OP_MOUSE_ACTION_AI,this.onUseWatch);
            this.watchFlag = false;
            ApplicationFacade.getInstance().dispatch(EventConst.STARTTOPLAYANIMATION,{
               "npcid":0,
               "x":0,
               "y":0,
               "effectName":"",
               "url":this._watchURL + ".swf",
               "targetFunction":null,
               "type":0
            });
         }
      }
   }
}

