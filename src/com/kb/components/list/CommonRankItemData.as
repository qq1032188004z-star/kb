package com.kb.components.list
{
   public class CommonRankItemData
   {
      
      public var rank:int;
      
      public var socre:int;
      
      private var _other:String;
      
      private var _otherObj:Object;
      
      public function CommonRankItemData()
      {
         super();
      }
      
      public function get otherObj() : Object
      {
         return this._otherObj;
      }
      
      public function set other(value:String) : void
      {
         this._other = value;
         if(!value || value == "")
         {
            this._otherObj = {};
         }
         else
         {
            this._otherObj = JSON.parse(this._other);
         }
      }
   }
}

