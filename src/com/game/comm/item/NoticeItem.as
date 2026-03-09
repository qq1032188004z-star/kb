package com.game.comm.item
{
   public class NoticeItem
   {
      
      public var id:int;
      
      public var type:int;
      
      public var interval:int;
      
      public var message:String;
      
      public var start_t:int;
      
      public var end_t:int;
      
      public var lastDisplayTime:int;
      
      public function NoticeItem(obj:Object = null)
      {
         super();
         if(obj != null)
         {
            this.id = int(obj.id) || 0;
            this.type = int(obj.type) || 0;
            this.interval = int(obj.interval) || 0;
            this.message = obj.m_message || "";
            this.start_t = int(obj.start_t) || 0;
            this.end_t = int(obj.end_t) || 0;
         }
         this.lastDisplayTime = 0;
      }
   }
}

