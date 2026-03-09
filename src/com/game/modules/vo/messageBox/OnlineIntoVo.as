package com.game.modules.vo.messageBox
{
   import com.game.util.TimeTransform;
   
   public class OnlineIntoVo
   {
      
      public var id:int;
      
      public var actid:int;
      
      public var actName:String;
      
      public var priority:String;
      
      public var type:int;
      
      public var sDate:int;
      
      public var eDate:int;
      
      public var timePlus:int = 0;
      
      public var actType:int = 1;
      
      public var content:String;
      
      public var showgo:int;
      
      public var delgo:int;
      
      public var showgoing:int;
      
      public var showdec:String;
      
      public var jump:int;
      
      public var bOver:Boolean = false;
      
      private var _timeList:Array;
      
      public function OnlineIntoVo()
      {
         super();
      }
      
      public function setGameTime($timeString:String) : void
      {
         if($timeString.length > 0)
         {
            this._timeList = $timeString.split(",");
         }
         else
         {
            this._timeList = [];
         }
      }
      
      public function get timeList() : Array
      {
         return this._timeList;
      }
      
      public function toTimePlusString(state:int = 0) : String
      {
         return TimeTransform.getInstance().transToTime(this.timePlus,1);
      }
      
      public function toSDateString() : String
      {
         return this.sDate + "";
      }
      
      public function toEDateString() : String
      {
         return this.eDate + "";
      }
   }
}

