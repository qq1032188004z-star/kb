package com.game.modules.control.trump
{
   import flash.events.Event;
   
   public class TrumpEvent extends Event
   {
      
      public static var reupdateimg:String = "reupdate";
      
      public static var recallTrump:String = "recalltrump";
      
      public static var doctorEvent:String = "doctorevent";
      
      public static var distributeExp:String = "distributeexp";
      
      public static var reqStoreExp:String = "reqstorexp";
      
      public static var closeWindow:String = "closewindowtrump";
      
      public static var openmonsterTrainWindow:String = "openmonstertrainWindow";
      
      public static var TRAININGGETMONSTERS:String = "traininggetmonsters";
      
      public static var TRAINSETCOURSEBACK:String = "traingetcourseback";
      
      public static var TRAINMONSTER:String = "trainmonster";
      
      public static var TRAINGETBACKMONSTER:String = "traingetbackmonster";
      
      public static var opentrumptoolview:String = "opentrumptoolview";
      
      public static var closetrumpinfoview:String = "closetrumpinfoview";
      
      public static var huoliequalszero:String = "huoliequalszero";
      
      public static var huolidayuzero:String = "huolidayuzero";
      
      public static var changeTrump:String = "change_trump";
      
      private var _data:Object;
      
      public function TrumpEvent(type:String, data:Object = null)
      {
         super(type);
         this._data = data;
      }
      
      public function get data() : Object
      {
         return this._data;
      }
      
      public function set data(value:Object) : void
      {
         this._data = value;
      }
   }
}

