package com.game.modules.control.task.util
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   
   public class TaskListItem extends MovieClip
   {
      
      private static var tf:TextFormat = new TextFormat("宋体",14,16776960,null,null,null,null,null,TextFormatAlign.CENTER,null,null,null,4);
      
      public var personSayTxt:TextField;
      
      public var bgmc:MovieClip;
      
      public var type:int;
      
      private var obj:Task;
      
      private var state:int;
      
      private var callback:Function;
      
      private var opCode:int;
      
      private var msgType:int;
      
      public function TaskListItem(cls:Class)
      {
         super();
         tf.letterSpacing = 1.5;
         this.bgmc = new cls() as MovieClip;
         this.bgmc.gotoAndStop(1);
         this.addChild(this.bgmc);
         this.bgmc.width = 200;
         this.bgmc.x = 0;
         this.bgmc.y = 0;
         this.personSayTxt = new TextField();
         this.addChild(this.personSayTxt);
         this.personSayTxt.width = this.bgmc.width - 15;
         this.personSayTxt.x = 7.5;
         this.personSayTxt.y = 2.2;
         this.personSayTxt.text = "";
         this.personSayTxt.defaultTextFormat = tf;
         this.personSayTxt.wordWrap = true;
         this.personSayTxt.multiline = true;
         this.mouseChildren = false;
         this.buttonMode = true;
         this.addEventListener(MouseEvent.CLICK,this.onClick);
         this.addEventListener(MouseEvent.ROLL_OVER,this.onMouseOver);
         this.addEventListener(MouseEvent.ROLL_OUT,this.onMouseOut);
      }
      
      private function onMouseOver(evt:MouseEvent) : void
      {
         this.bgmc.gotoAndStop(2);
      }
      
      private function onMouseOut(evt:MouseEvent) : void
      {
         this.bgmc.gotoAndStop(1);
      }
      
      public function addTask(type:int, ... rest) : void
      {
         var str:String = null;
         this.type = type;
         switch(type)
         {
            case 0:
               if(rest.length > 0)
               {
                  this.personSayTxt.text = rest[0];
                  this.callback = rest[1];
               }
               break;
            case 1:
               if(rest.length > 2)
               {
                  if(!(rest[0] is Task))
                  {
                     this.dispos();
                     return;
                  }
                  this.obj = rest[0];
                  this.callback = rest[1];
                  this.state = rest[2];
                  this.personSayTxt.text = this.obj.taskName;
               }
               break;
            case 2:
               if(rest.length > 2)
               {
                  str = "";
                  this.opCode = rest[0];
                  if(this.opCode == 1)
                  {
                     this.msgType = rest[2].id;
                     str = rest[2].name;
                  }
                  else
                  {
                     str = rest[2];
                  }
                  this.personSayTxt.text = str;
                  this.callback = rest[1];
               }
         }
         this.personSayTxt.height = 20 * this.personSayTxt.numLines;
         this.bgmc.height += 20 * (this.personSayTxt.numLines - 1);
      }
      
      public function onClick(evt:MouseEvent) : void
      {
         switch(this.type)
         {
            case 0:
               this.callback.apply(null,[]);
               break;
            case 1:
               this.callback.apply(null,[this.obj]);
               break;
            case 2:
               this.callback.apply(null,[this.opCode,this.msgType]);
         }
      }
      
      public function get info() : Task
      {
         return this.obj;
      }
      
      public function dispos() : void
      {
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
         this.removeEventListener(MouseEvent.CLICK,this.onClick);
         this.removeEventListener(MouseEvent.ROLL_OVER,this.onMouseOver);
         this.removeEventListener(MouseEvent.ROLL_OUT,this.onMouseOut);
         this.callback = null;
      }
   }
}

