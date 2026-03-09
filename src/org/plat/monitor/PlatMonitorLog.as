package org.plat.monitor
{
   import flash.external.ExternalInterface;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class PlatMonitorLog
   {
      
      private static var _instance:PlatMonitorLog;
      
      private var tid2:int;
      
      private var browserObj:Object;
      
      private var tid:int;
      
      private var url:String;
      
      private var regWebkit:RegExp = /(webkit)[ \/]([\w.]+)/i;
      
      public function PlatMonitorLog()
      {
         super();
         this.browserObj = this.BrowserMatch();
         this.url = "http://link.wanwan4399.com/kbxy/?m=";
      }
      
      public static function get instance() : PlatMonitorLog
      {
         if(_instance == null)
         {
            _instance = new PlatMonitorLog();
         }
         return _instance;
      }
      
      public function BrowserMatch() : Object
      {
         var ua:* = null;
         var ropera:* = null;
         var rmsie:* = null;
         var rmozilla:* = null;
         var match:* = null;
         if(ExternalInterface.available)
         {
            ua = this.getUA();
            ropera = /(opera)(?:.*version)?[ \/]([\w.]+)/i;
            rmsie = /(msie) ([\w.]+)/i;
            rmozilla = /(mozilla)(?:.*? rv:([\w.]+))?/i;
            match = this.regWebkit.exec(ua) || ropera.exec(ua) || rmsie.exec(ua) || ua.indexOf("compatible") < 0 && rmozilla.exec(ua) || [];
            return {
               "browser":match[1] || "",
               "version":match[2] || "0"
            };
         }
         return {
            "browser":"NULL",
            "version":"0"
         };
      }
      
      private function getUA() : String
      {
         if(ExternalInterface.available)
         {
            return ExternalInterface.call("function BrowserAgent(){return navigator.userAgent;}");
         }
         return "";
      }
      
      private function verifyDelay2() : void
      {
         clearTimeout(this.tid);
         this.writeNewLog(102);
      }
      
      public function writeNewLog(errorCode:int, extId:int = 0) : void
      {
      }
      
      private function verifyDelay15() : void
      {
         clearTimeout(this.tid2);
         this.writeNewLog(101);
      }
      
      private function getClientTime() : String
      {
         var time:String = "";
         var date:Date = new Date();
         return date.fullYear + "-" + (date.month + 1) + "-" + date.date + " " + date.hours + ":" + date.minutes + ":" + date.seconds;
      }
      
      public function stopMonitor() : void
      {
         clearTimeout(this.tid);
         clearTimeout(this.tid2);
      }
      
      public function connectPlat() : void
      {
         clearTimeout(this.tid);
         clearTimeout(this.tid2);
         this.tid = setTimeout(this.verifyDelay2,2000);
         this.tid2 = setTimeout(this.verifyDelay15,15000);
      }
   }
}

