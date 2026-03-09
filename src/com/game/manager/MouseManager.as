package com.game.manager
{
   import com.game.manager.cursor.ViewControl;
   import com.kb.util.CommonDefine;
   import flash.events.MouseEvent;
   
   public class MouseManager
   {
      
      private static var _instance:MouseManager;
      
      private var _preCursorName:String;
      
      public var count:int;
      
      public var cursorName:String;
      
      public var isCanClick:Boolean;
      
      private var _mouseEvent:MouseEvent;
      
      public function MouseManager()
      {
         super();
         if(_instance != null)
         {
            throw new Error(CommonDefine.CONSTRUCTERROR);
         }
      }
      
      public static function getInstance() : MouseManager
      {
         if(_instance == null)
         {
            _instance = new MouseManager();
         }
         return _instance;
      }
      
      public function setCursor(name:String, count:int = 0) : void
      {
         if(name == this._preCursorName)
         {
            this.hideCursor();
            this._preCursorName = "";
            this.cursorName = "";
            ViewControl.getInstance().send("setcurrentcursor",this._preCursorName);
         }
         else
         {
            this.count = count;
            this.cursorName = name;
            this._preCursorName = name;
            ViewControl.getInstance().send("setcurrentcursor",name);
         }
      }
      
      public function showCursor() : void
      {
         ViewControl.getInstance().send("showcursor");
      }
      
      public function hideCursor() : void
      {
         ViewControl.getInstance().send("hidecursor");
      }
      
      public function set mouseEvent(value:MouseEvent) : void
      {
         this._mouseEvent = value;
      }
      
      public function get mouseEvent() : MouseEvent
      {
         return this._mouseEvent;
      }
   }
}

