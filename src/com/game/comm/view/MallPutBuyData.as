package com.game.comm.view
{
   public class MallPutBuyData
   {
      
      public var goodId:int;
      
      public var amount:int;
      
      public var isTool:Boolean;
      
      public var mark:int;
      
      public var payType:int;
      
      public var price:int;
      
      public var vipPrice:int;
      
      public var limitNum:int;
      
      public var showLimit:Boolean = true;
      
      public var limitType:int;
      
      public var type:int;
      
      public var subType:int;
      
      public var mallCount:int;
      
      public var commonPrice:int;
      
      public var payId:int;
      
      public var name:String;
      
      public var desc:String;
      
      public var info:Object;
      
      public function MallPutBuyData(obj:Object = null)
      {
         super();
         if(obj != null)
         {
            this.parse(obj);
         }
      }
      
      public function getMaxCount() : int
      {
         return this.limitNum > 0 ? this.limitNum : 999;
      }
      
      public function parse(dataS:Object) : void
      {
         var keyS:String = null;
         for(keyS in dataS)
         {
            if(this.hasOwnProperty(keyS))
            {
               this[keyS] = dataS[keyS];
            }
         }
      }
   }
}

