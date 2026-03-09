package com.game.manager
{
   import com.game.comm.item.NoticeItem;
   import com.game.locators.GameData;
   import flash.events.TimerEvent;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   
   public class NoticeManager
   {
      
      private static var _instance:NoticeManager;
      
      private var noticeList:Dictionary;
      
      private var checkTimer:Timer;
      
      public function NoticeManager()
      {
         super();
         this.noticeList = new Dictionary();
         this.initTimers();
      }
      
      public static function get instance() : NoticeManager
      {
         if(_instance == null)
         {
            _instance = new NoticeManager();
         }
         return _instance;
      }
      
      public function onSetting(key:String, item:NoticeItem) : void
      {
         switch(key)
         {
            case "add":
            case "update":
               this.addNotice(item);
               break;
            case "del":
               this.delNotice(item.id);
         }
      }
      
      public function delNotice(id:int) : void
      {
         if(this.noticeList.hasOwnProperty(id.toString()))
         {
            delete this.noticeList[id];
         }
      }
      
      public function addNotice(notice:NoticeItem) : void
      {
         if(this.noticeList.hasOwnProperty(notice.id.toString()))
         {
            this.copyNotice(this.noticeList[notice.id],notice);
         }
         else
         {
            this.noticeList[notice.id] = notice;
         }
      }
      
      private function copyNotice(item:NoticeItem, copyItem:NoticeItem) : void
      {
         item.message = copyItem.message;
         item.type = copyItem.type;
         item.interval = copyItem.interval;
         item.start_t = copyItem.start_t;
         item.end_t = copyItem.end_t;
         item.lastDisplayTime = 0;
      }
      
      private function initTimers() : void
      {
         this.checkTimer = new Timer(5000);
         this.checkTimer.addEventListener(TimerEvent.TIMER,this.checkNotices);
         this.checkTimer.start();
      }
      
      private function checkNotices(e:TimerEvent) : void
      {
         var item:NoticeItem = null;
         var currentTime:int = GameData.instance.playerData.systemTimes;
         for each(item in this.noticeList)
         {
            if(currentTime >= item.start_t && currentTime <= item.end_t)
            {
               if(currentTime - item.lastDisplayTime >= item.interval)
               {
                  AlertManager.instance.addTipAlert({
                     "tip":item.message,
                     "type":9,
                     "speed":5000
                  });
                  item.lastDisplayTime = currentTime;
                  break;
               }
            }
         }
      }
   }
}

