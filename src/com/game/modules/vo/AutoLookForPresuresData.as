package com.game.modules.vo
{
   public class AutoLookForPresuresData extends ShowData
   {
      
      private var _isAutoNum:int = 0;
      
      private var _useAutoNum:int = 0;
      
      private var _isGoNpc:Boolean = false;
      
      private var _keepAuto:Boolean = false;
      
      private var _rewardList:Array = [];
      
      public function AutoLookForPresuresData()
      {
         super();
      }
      
      public function get isAutoNum() : int
      {
         return this._isAutoNum;
      }
      
      public function set isAutoNum(value:int) : void
      {
         this._isAutoNum = value;
      }
      
      public function get useAutoNum() : int
      {
         return this._useAutoNum;
      }
      
      public function set useAutoNum(value:int) : void
      {
         this._useAutoNum = value;
      }
      
      public function get isGoNpc() : Boolean
      {
         return this._isGoNpc;
      }
      
      public function set isGoNpc(value:Boolean) : void
      {
         this._isGoNpc = value;
      }
      
      public function get keepAuto() : Boolean
      {
         return this._keepAuto;
      }
      
      public function set keepAuto(value:Boolean) : void
      {
         this._keepAuto = value;
      }
      
      public function get rewardList() : Array
      {
         return this._rewardList;
      }
      
      public function set rewardList(value:Array) : void
      {
         this._rewardList = value;
      }
   }
}

