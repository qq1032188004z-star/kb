package com.game.dohko.data
{
   public class ActiveCommonData
   {
      
      private static var _instance:ActiveCommonData;
      
      public var totalBadgeNum:int;
      
      public var badgeNumInGame:int;
      
      public var promptFlag:int = 0;
      
      public var restGameCount:int;
      
      public var cdTime:int;
      
      public var limitList:Array;
      
      public var catchList:Array;
      
      public function ActiveCommonData(c:PrivateClass)
      {
         super();
         if(c == null)
         {
            throw new Error("请通过.instance获取实例");
         }
      }
      
      public static function get instance() : ActiveCommonData
      {
         if(_instance == null)
         {
            _instance = new ActiveCommonData(new PrivateClass());
         }
         return _instance;
      }
      
      public static function destroyStatic() : void
      {
         if(Boolean(_instance))
         {
            _instance = null;
         }
      }
      
      public function initData() : void
      {
         this.badgeNumInGame = 0;
      }
   }
}

class PrivateClass
{
   
   public function PrivateClass()
   {
      super();
   }
}
