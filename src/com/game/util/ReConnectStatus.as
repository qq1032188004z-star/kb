package com.game.util
{
   public class ReConnectStatus
   {
      
      public static var instance:ReConnectStatus = new ReConnectStatus();
      
      public var HAS_CONNECT_SERVER:Boolean;
      
      public var HAS_CHECK_ACCOUNT:Boolean;
      
      public var HAS_REQUEST_WORLD_NUM:Boolean;
      
      public var HAS_REQUEST_WORLD_LIST:Boolean;
      
      public var HAS_REQUEST_ENTER_WORLD:Boolean;
      
      public var IS_IN_CHANGLINE_STATE:Boolean;
      
      public var REC_CONNECT_COUNT:int;
      
      public var SRV_FAILD:Boolean = false;
      
      public var SUCCESS_E_SCENE:Boolean = false;
      
      public var CLOSS_SERVER:Boolean = false;
      
      public var CREATE_ROLE:Boolean = false;
      
      public function ReConnectStatus()
      {
         super();
      }
      
      public function isDisConnectInGame() : Boolean
      {
         if(this.HAS_CONNECT_SERVER && this.HAS_CHECK_ACCOUNT && this.HAS_REQUEST_WORLD_NUM && this.HAS_REQUEST_WORLD_LIST && !this.IS_IN_CHANGLINE_STATE && !this.CLOSS_SERVER && this.HAS_REQUEST_ENTER_WORLD)
         {
            return true;
         }
         return false;
      }
      
      public function isToMax() : Boolean
      {
         if(this.REC_CONNECT_COUNT >= 5)
         {
            return true;
         }
         return false;
      }
   }
}

