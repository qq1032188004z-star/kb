package com.game.modules.action
{
   import com.game.modules.control.task.TaskList;
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.ui.ToolTip;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class MouseEnableView
   {
      
      public static var instance:MouseEnableView = new MouseEnableView();
      
      private var xCoord:Number;
      
      private var yCoord:Number;
      
      private var handler:Function;
      
      private var callback:Function;
      
      private var tip:String;
      
      private var loader:Loader;
      
      private var clip:MovieClip;
      
      private var parent:DisplayObjectContainer;
      
      private var tid:int;
      
      private var delay:int;
      
      private var params:Object;
      
      public function MouseEnableView()
      {
         super();
         this.loader = new Loader();
         this.loader.y -= 20;
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoaded);
         this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onIoErrorHandler);
      }
      
      public static function destory() : void
      {
         if(instance != null)
         {
            instance.unload();
         }
         instance = null;
      }
      
      private function onIoErrorHandler(e:IOErrorEvent) : void
      {
         O.o(" 加载的内容失败 ");
      }
      
      public function load(parent:DisplayObjectContainer, xCoord:Number, yCoord:Number, url:String, tip:String, mouseDonwHandler:Function = null, delay:int = 30000, callback:Function = null, data:Object = null) : void
      {
         if(this.clip != null)
         {
            ToolTip.LooseDO(this.clip);
            if(Boolean(this.clip.parent))
            {
               this.clip.parent.removeChild(this.clip);
            }
         }
         this.parent = parent;
         this.xCoord = xCoord;
         this.yCoord = yCoord;
         this.tip = tip;
         this.handler = mouseDonwHandler;
         this.callback = callback;
         this.delay = delay;
         this.params = data;
         this.loader.load(new URLRequest(URLUtil.getSvnVer(url)));
      }
      
      private function onLoaded(evt:Event) : void
      {
         clearTimeout(this.tid);
         if(this.delay != 0)
         {
            this.tid = setTimeout(this.show,this.delay);
         }
         if(this.params == null)
         {
            this.showMsgUi();
         }
         else
         {
            this.showGharryUi();
         }
      }
      
      private function showGharryUi() : void
      {
         TaskList.getInstance().setTaskBitStatus(2,true);
         if(!this.parent.contains(this.loader))
         {
            this.parent.addChild(this.loader);
         }
      }
      
      private function showMsgUi() : void
      {
         this.clip = this.loader.content["getChildAt"](0) as MovieClip;
         if(this.clip != null)
         {
            if(this.delay != 0)
            {
               this.clip.visible = false;
            }
            this.clip.x = this.xCoord;
            this.clip.y = this.yCoord;
            this.parent.addChildAt(this.clip,this.parent.numChildren);
            if(this.handler != null)
            {
               this.clip.addEventListener(MouseEvent.MOUSE_DOWN,this.onclickCancel);
            }
            if(this.tip != null)
            {
               ToolTip.BindDO(this.clip,this.tip);
            }
            if(this.clip is MovieClip)
            {
               if(this.callback != null)
               {
                  this.clip.addFrameScript(this.clip.totalFrames - 1,null);
                  this.clip.addFrameScript(this.clip.totalFrames - 1,this.runCallBack);
               }
               this.clip.gotoAndPlay(1);
            }
         }
         else
         {
            this.loader.unloadAndStop(false);
         }
      }
      
      private function show() : void
      {
         clearTimeout(this.tid);
         if(Boolean(this.clip))
         {
            this.clip.visible = true;
         }
      }
      
      private function onclickCancel(evt:MouseEvent) : void
      {
         clearTimeout(this.tid);
         if(this.handler != null)
         {
            this.handler();
            this.handler = null;
         }
      }
      
      public function unload() : void
      {
         clearTimeout(this.tid);
         if(Boolean(this.clip))
         {
            ToolTip.LooseDO(this.clip);
            this.clip.addFrameScript(this.clip.totalFrames - 1,null);
            this.clip.removeEventListener(MouseEvent.MOUSE_DOWN,this.onclickCancel);
            if(Boolean(this.clip.parent))
            {
               this.clip.parent.removeChild(this.clip);
            }
            this.loader.unloadAndStop(false);
            this.clip = null;
         }
         if(Boolean(this.parent) && this.parent.contains(this.loader))
         {
            if(Boolean(this.loader.content) && Boolean(this.loader.content.hasOwnProperty("disport")))
            {
               TaskList.getInstance().setTaskBitStatus(2,false);
               this.loader.content["disport"];
               this.loader.unloadAndStop();
            }
            this.parent.removeChild(this.loader);
         }
      }
      
      private function runCallBack() : void
      {
         if(Boolean(this.clip))
         {
            this.clip.addFrameScript(this.clip.totalFrames - 1,null);
         }
         if(this.callback != null)
         {
            this.callback();
         }
      }
   }
}

