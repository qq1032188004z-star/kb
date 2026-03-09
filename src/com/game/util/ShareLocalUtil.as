package com.game.util
{
   public class ShareLocalUtil
   {
      
      public static var instance:ShareLocalUtil = new ShareLocalUtil();
      
      public var isCanSave:Boolean;
      
      public var locallogin3:Object;
      
      public var greengame:Object;
      
      private var weeklyUpdate:int = 20121220;
      
      public function ShareLocalUtil()
      {
         super();
         this.locallogin3 = {};
      }
      
      public function getLocalLoginData() : Array
      {
         return [];
      }
      
      public function isDirectOpen() : Boolean
      {
         return false;
      }
      
      public function setAttribute(userName:String, attribute:String, attributeValue:*) : void
      {
      }
      
      public function check(value:String) : Object
      {
         return {"userName":null};
      }
      
      private function checkIsFull(list:Array) : void
      {
      }
      
      public function setLoginData(userName:String = null, userPass:String = null) : void
      {
      }
      
      public function flush() : void
      {
      }
      
      private function recoverOld() : void
      {
      }
      
      public function getLatestInviteId() : int
      {
         return 0;
      }
      
      public function saveSelfDate(userName:String, obj:Object) : void
      {
      }
      
      public function selfLoginData(value:Object) : void
      {
      }
      
      public function getWeeklyActivityFlag() : int
      {
         return 1;
      }
      
      public function setWeeklyActivityFlag() : void
      {
      }
   }
}

