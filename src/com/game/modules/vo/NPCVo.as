package com.game.modules.vo
{
   import com.game.locators.GameData;
   
   public class NPCVo
   {
      
      public var x:Number;
      
      public var y:Number;
      
      public var special:int;
      
      public var enname:String = "";
      
      private var _istask:int;
      
      public var mapid:int;
      
      public var url:String = "";
      
      public var sequenceID:int;
      
      public var name:String = "";
      
      public var type:int;
      
      public var watchURL:String = "null";
      
      public var dymaicY:Number = 0;
      
      public var targetx:Number = 0;
      
      public var targety:Number = 0;
      
      public var removeNPCList:Array;
      
      private var _sexual:int;
      
      public function NPCVo()
      {
         super();
      }
      
      public function set sexual(value:int) : void
      {
         if(value == 1)
         {
            if((GameData.instance.playerData.roleType & 1) == 1)
            {
               this.url += "_1";
            }
            else
            {
               this.url += "_2";
            }
         }
      }
      
      public function getValueOfSpecifiedBit(bit:int) : Boolean
      {
         if(bit > 16 || bit <= 0)
         {
            return false;
         }
         return (this._istask & Math.pow(2,bit - 1)) > 0 ? true : false;
      }
      
      public function get istask() : int
      {
         return this._istask;
      }
      
      public function set istask(value:int) : void
      {
         this._istask = value;
      }
   }
}

