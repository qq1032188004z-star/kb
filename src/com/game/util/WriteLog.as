package com.game.util
{
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.external.ExternalInterface;
   import flash.net.Socket;
   import flash.net.URLRequest;
   import flash.net.sendToURL;
   import flash.utils.Endian;
   import org.green.server.core.GreenSocket;
   import org.green.server.data.ByteArray;
   import org.green.server.manager.SocketManager;
   
   public class WriteLog
   {
      
      private static var _instance:WriteLog;
      
      private var gs:GreenSocket;
      
      private var regWebkit:RegExp = /(webkit)[ \/]([\w.]+)/i;
      
      public function WriteLog()
      {
         super();
      }
      
      public static function get instance() : WriteLog
      {
         if(_instance == null)
         {
            _instance = new WriteLog();
         }
         return _instance;
      }
      
      public function write(... res) : void
      {
         var onSocketConnectHandler:Function;
         var onIoErrorHandler:Function;
         var onSecurityErrorHandle:Function;
         var tempsocket:Socket = null;
         var buf:ByteArray = null;
         var i:int = 0;
         try
         {
            onSocketConnectHandler = function(event:Event):void
            {
               tempsocket.writeBytes(buf);
               tempsocket.flush();
               tempsocket.close();
               buf.clear();
               tempsocket = null;
            };
            onIoErrorHandler = function(event:IOErrorEvent):void
            {
               tempsocket.close();
               buf.clear();
               tempsocket = null;
            };
            onSecurityErrorHandle = function(event:Event):void
            {
               tempsocket.close();
               buf.clear();
               tempsocket = null;
            };
            if(res.length != 7)
            {
               return;
            }
            tempsocket = new Socket();
            tempsocket.connect("121.14.36.238",1687);
            tempsocket.addEventListener(Event.CONNECT,onSocketConnectHandler);
            tempsocket.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onSecurityErrorHandle);
            tempsocket.addEventListener(IOErrorEvent.IO_ERROR,onIoErrorHandler);
            buf = new ByteArray();
            buf.endian = Endian.LITTLE_ENDIAN;
            buf.position = 0;
            for(i = 0; i < 6; i++)
            {
               buf.writeInt(res[i]);
            }
            buf.writeMultiByte(res[6],"us-ascii");
         }
         catch(e:*)
         {
            O.o("WriteLog 错误",e);
         }
      }
      
      public function write238(... res) : void
      {
         var buf:ByteArray = null;
         var ts:String = null;
         var code:int = 0;
         var i:int = 0;
         try
         {
            if(res.length != 7)
            {
               return;
            }
            this.gs = SocketManager.getGreenSocket();
            buf = new ByteArray();
            buf.endian = Endian.LITTLE_ENDIAN;
            buf.position = 0;
            ts = String(res[6]);
            code = int(ts.charCodeAt(0)) << 24 | int(ts.charCodeAt(1)) << 16 | int(ts.charCodeAt(ts.length - 2)) << 8 | int(ts.charCodeAt(ts.length - 1));
            for(i = 1; i < 6; i++)
            {
               buf.writeInt(res[i]);
            }
            this.gs.sendCmd(1187376,int(res[0]),[code,res[1],res[2],res[3],res[4],res[5]]);
         }
         catch(e:*)
         {
            O.o("WriteLog 错误",e);
         }
      }
      
      public function writeNewLog(errorCode:int, mapId:int = 0) : void
      {
      }
      
      private function getClientTime() : String
      {
         var time:String = "";
         var date:Date = new Date();
         return date.fullYear + "-" + (date.month + 1) + "-" + date.date + " " + date.hours + ":" + date.minutes + ":" + date.seconds;
      }
      
      public function write1(... res) : void
      {
         var url:String = "http://192.168.3.192:9000/log.php?pid=" + res[0] + "&value1=" + res[1] + "&value2=" + res[2] + "&value3=" + res[3] + "&value4=" + res[4] + "&value5=" + res[5];
         var request:URLRequest = new URLRequest(url);
         try
         {
            sendToURL(request);
         }
         catch(e:Error)
         {
         }
         request = null;
      }
      
      public function BrowserMatch() : Object
      {
         var ua:String = ExternalInterface.call("function BrowserAgent(){return navigator.userAgent;}");
         var ropera:RegExp = /(opera)(?:.*version)?[ \/]([\w.]+)/i;
         var rmsie:RegExp = /(msie) ([\w.]+)/i;
         var rmozilla:RegExp = /(mozilla)(?:.*? rv:([\w.]+))?/i;
         var match:Object = this.regWebkit.exec(ua) || ropera.exec(ua) || rmsie.exec(ua) || ua.indexOf("compatible") < 0 && rmozilla.exec(ua) || [];
         return {
            "browser":match[1] || "",
            "version":match[2] || "0"
         };
      }
   }
}

