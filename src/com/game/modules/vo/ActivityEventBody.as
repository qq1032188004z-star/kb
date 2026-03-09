package com.game.modules.vo
{
   import flash.utils.Dictionary;
   
   public class ActivityEventBody
   {
      
      public var head:int;
      
      public var list:Dictionary;
      
      public function ActivityEventBody()
      {
         super();
         this.list = new Dictionary(true);
      }
      
      public function checkHead(value:int) : Boolean
      {
         return this.head == value;
      }
      
      public function getValueByKey(key:int) : int
      {
         var result:int = -1;
         if(this.list != null && this.list[key] != null)
         {
            result = int(this.list[key]);
         }
         return result;
      }
      
      public function setValueByKey(key:int, value:int) : void
      {
         if(this.list == null)
         {
            this.list = new Dictionary(true);
         }
         this.list[key] = value;
      }
      
      public function getValues() : Array
      {
         var key:String = null;
         var result:Array = [];
         if(this.list != null)
         {
            for(key in this.list)
            {
               result.push(this.list[key]);
            }
         }
         return result;
      }
      
      public function destroy() : void
      {
         var key:String = null;
         if(this.list != null)
         {
            for each(key in this.list)
            {
               this.list[key] = null;
               delete this.list[key];
            }
            this.list = null;
         }
         this.head = 0;
      }
   }
}

