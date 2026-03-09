package com.game.modules.control.task.util
{
   import com.game.event.EventConst;
   import com.game.global.GlobalConfig;
   import com.game.modules.control.task.TaskList;
   
   public class TasklistItemVo
   {
      
      public var index:int;
      
      public var type:int;
      
      public var npcid:int;
      
      public var name:String = "";
      
      public var url:String = "";
      
      public var xCoord:Number = 0;
      
      public var yCoord:Number = 0;
      
      public var event:String = "";
      
      public var time:String = "";
      
      public var head:int = 0;
      
      public var beUsed:Boolean = false;
      
      public var code:int;
      
      public var unAcceptTaskID:int = 0;
      
      public var acceptTaskID:int = 0;
      
      public var completeTaskID:int = 0;
      
      public var bitValue:int = -1;
      
      private var _isOpen:Boolean = true;
      
      private var _channel:String = "";
      
      private var _php:String = "";
      
      private var _msgCode:uint = 0;
      
      private var _body:Array = null;
      
      public function TasklistItemVo()
      {
         super();
      }
      
      public function set isOnline(value:int) : void
      {
         if(value >= 1)
         {
            this._isOpen = true;
         }
         else
         {
            this._isOpen = false;
         }
      }
      
      public function get isOpen() : Boolean
      {
         return this._isOpen;
      }
      
      public function set php(value:String) : void
      {
         if(value == "0")
         {
            this._php = "";
         }
         else
         {
            this._php = GlobalConfig.phpserver + value;
         }
      }
      
      public function get php() : String
      {
         return this._php;
      }
      
      public function set channel(value:String) : void
      {
         if(value == "0")
         {
            this._channel = "";
         }
         else
         {
            this._channel = value;
         }
      }
      
      public function get channel() : String
      {
         return this._channel;
      }
      
      public function set msgBody(value:String) : void
      {
         var arr:Array = null;
         if(value == null || value.length == 0)
         {
            return;
         }
         if(value.indexOf(",") == -1)
         {
            arr = [int(value)];
            this._body = arr;
            return;
         }
         arr = value.split(",");
         if(arr == null)
         {
            return;
         }
         var i:int = 0;
         var len:int = int(arr.length);
         for(i = 0; i < len; i++)
         {
            arr[i] = int(arr[i]);
         }
         this._body = arr;
      }
      
      public function get body() : Array
      {
         return this._body;
      }
      
      public function set msg(value:String) : void
      {
         this._msgCode = uint(value);
      }
      
      public function get msgCode() : uint
      {
         return this._msgCode;
      }
      
      public function canShow() : Boolean
      {
         if(!this._isOpen)
         {
            return false;
         }
         if(this.unAcceptTaskID > 0)
         {
            if(TaskList.getInstance().getStateOfSpecifiedSubtask(this.unAcceptTaskID) != 0)
            {
               return false;
            }
         }
         if(this.acceptTaskID > 0)
         {
            if(TaskList.getInstance().getStateOfSpecifiedSubtask(this.acceptTaskID) != 1)
            {
               return false;
            }
         }
         if(this.completeTaskID > 0)
         {
            if(TaskList.getInstance().getStateOfSpecifiedSubtask(this.completeTaskID) != 2)
            {
               return false;
            }
         }
         if(this.bitValue > 0)
         {
            if(!TaskList.getInstance().getTaskBitStatus(this.bitValue))
            {
               return false;
            }
         }
         return true;
      }
      
      public function getMsgEventBody() : Array
      {
         var str:String = "";
         switch(this.type)
         {
            case 1:
               str = EventConst.OPEN_MODULE;
               break;
            case 2:
               str = EventConst.OPENSWFWINDOWS;
               break;
            case 3:
               str = EventConst.BOBSTATECLICK;
               break;
            case 4:
               str = this.event;
         }
         var arr:Array = [this.type,str];
         if(this.type == 4)
         {
            arr.push(this.channel);
         }
         else if(this.url == "assets/module/BlowLineModule.swf")
         {
            arr.push({
               "url":this.url,
               "xCoord":this.xCoord,
               "yCoord":this.yCoord,
               "mouseright":true
            });
         }
         else
         {
            arr.push({
               "url":this.url,
               "xCoord":this.xCoord,
               "yCoord":this.yCoord
            });
         }
         return arr;
      }
   }
}

