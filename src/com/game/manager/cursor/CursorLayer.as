package com.game.manager.cursor
{
   import com.game.manager.MouseManager;
   import com.publiccomponent.URLUtil;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.ui.Mouse;
   import flash.ui.MouseCursor;
   
   public class CursorLayer extends Sprite
   {
      
      private var currentCursor:MovieClip;
      
      private var loader:Loader;
      
      public function CursorLayer()
      {
         super();
         this.addEventListener(Event.ADDED_TO_STAGE,this.onAddToStage,false,0,true);
      }
      
      private function onAddToStage(evt:Event) : void
      {
         mouseEnabled = false;
         mouseChildren = false;
         this.removeEventListener(Event.ADDED_TO_STAGE,this.onAddToStage);
         stage.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown,false,0,true);
         stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove,false,0,true);
         ViewControl.getInstance().registerListener("setcurrentcursor",this.setCursor);
         ViewControl.getInstance().registerListener("hidecursor",this.hideCursor);
         ViewControl.getInstance().registerListener("showcursor",this.showCursor);
      }
      
      private function onMouseDown(evt:MouseEvent) : void
      {
         if(this.currentCursor == null)
         {
            return;
         }
         if(this.currentCursor.visible == true && MouseManager.getInstance().isCanClick == true)
         {
            this.currentCursor.play();
         }
      }
      
      private function onMouseMove(evt:MouseEvent) : void
      {
         if(this.currentCursor == null)
         {
            return;
         }
         if(this.currentCursor.visible == false)
         {
            return;
         }
         this.currentCursor.x = evt.stageX;
         this.currentCursor.y = evt.stageY;
         evt.updateAfterEvent();
      }
      
      private function setCursor(evt:ViewEvent) : void
      {
         this.removeCursor();
         var cursorName:String = String(evt.getData());
         if(cursorName.length != 0)
         {
            Mouse.hide();
            this.load(cursorName);
         }
         else
         {
            if(this.currentCursor != null)
            {
               this.currentCursor.visible = false;
            }
            Mouse.cursor = MouseCursor.AUTO;
            Mouse.show();
         }
      }
      
      private function hideCursor(evt:ViewEvent) : void
      {
         if(this.currentCursor == null)
         {
            return;
         }
         this.currentCursor.visible = false;
         Mouse.show();
      }
      
      private function showCursor(evt:ViewEvent) : void
      {
         if(this.currentCursor == null)
         {
            return;
         }
         this.currentCursor.visible = true;
         Mouse.hide();
      }
      
      private function load(name:String) : void
      {
         if(this.loader == null)
         {
            this.loader = new Loader();
         }
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoadComplete);
         this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onIoErrorHandler);
         this.loader.load(new URLRequest(URLUtil.getSvnVer("assets/cursorTool/" + name + ".swf")));
      }
      
      private function onIoErrorHandler(e:IOErrorEvent) : void
      {
         O.o("加载鼠标样式失败 ");
      }
      
      private function onLoadComplete(evt:Event) : void
      {
         this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onIoErrorHandler);
         this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoadComplete);
         this.currentCursor = this.loader.content as MovieClip;
         if(this.currentCursor != null)
         {
            this.currentCursor.visible = true;
            this.currentCursor.x = mouseX;
            this.currentCursor.y = mouseY;
            addChild(this.currentCursor);
         }
      }
      
      private function removeCursor() : void
      {
         try
         {
            this.currentCursor.stop();
            this.removeChild(this.currentCursor);
            this.currentCursor = null;
         }
         catch(e:*)
         {
         }
         if(Boolean(this.loader))
         {
            this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onIoErrorHandler);
            this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoadComplete);
            this.loader.unload();
            this.loader = null;
         }
      }
   }
}

