package phpcon
{
   import com.game.global.GlobalConfig;
   import com.game.locators.GameData;
   import com.game.util.MD5;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLVariables;
   import flash.utils.getTimer;
   import org.json.JSON;
   
   public class PhpConnection extends EventDispatcher
   {
      
      private static var _instance:PhpConnection;
      
      public var messageList:Array = [];
      
      public function PhpConnection()
      {
         super();
      }
      
      public static function instance() : PhpConnection
      {
         if(_instance == null)
         {
            _instance = new PhpConnection();
         }
         return _instance;
      }
      
      public function getdata(value:String, uv:URLVariables = null, url:String = null, tv:String = null) : void
      {
         var req:URLRequest;
         var loader:URLLoader;
         var onIOError:Function = null;
         var onSecuError:Function = null;
         var onLoaderCompHandler:Function = null;
         onIOError = function(event:Event):void
         {
            O.o("PhpConnection - onIOError");
         };
         onSecuError = function(event:SecurityErrorEvent):void
         {
            O.o("PhpConnection - onSecuError");
         };
         onLoaderCompHandler = function(event:Event):void
         {
            var result:Object = null;
            if(event.currentTarget.data == "" || event.currentTarget.data == null)
            {
               return;
            }
            try
            {
               result = JSON.decode(event.currentTarget.data);
               if(result == null)
               {
                  result = event.currentTarget.data;
               }
            }
            catch(e:*)
            {
               trace("\n\nPHP啊，乱码了啊，杯具！！！" + e);
            }
            if(!result || !result.name)
            {
               trace("请求返回出错了！");
            }
            else
            {
               dispatchEvent(new PhpEvent(result.name,result));
            }
         };
         if(url == null)
         {
            url = GlobalConfig.phpserver;
         }
         if(value.indexOf("?") == -1)
         {
            if(tv == null)
            {
               value = value + "?v=" + getTimer();
            }
         }
         req = new URLRequest(url + value);
         req.method = "POST";
         req.data = uv;
         loader = new URLLoader();
         loader.load(req);
         loader.addEventListener(Event.COMPLETE,onLoaderCompHandler);
         loader.addEventListener(IOErrorEvent.IO_ERROR,onIOError);
         loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onSecuError);
      }
      
      public function insertMAAMessage(uname:String, action:int, p1:int = 0) : void
      {
         var urlvar:URLVariables = new URLVariables();
         urlvar.uid = GameData.instance.playerData.userId;
         urlvar.uname = uname;
         urlvar.action = action;
         urlvar.p1 = p1;
         this.getdata("shitu/insert_message.php",urlvar);
      }
      
      public function checkMallPassWord(callback:Function) : void
      {
         addEventListener(PhpEventConst.CHECK_USER,callback);
         var urlvar:URLVariables = new URLVariables();
         urlvar.uid = uint(GameData.instance.playerData.userId);
         this.getdata("mall/checkUser.php",urlvar);
      }
      
      public function loginScore(value:String) : void
      {
         var urlVal:URLVariables = new URLVariables();
         urlVal.desc = value;
         urlVal.gameId = 100208;
         urlVal.time = GameData.instance.playerData.systemTimes;
         urlVal.uid = GameData.instance.playerData.userId;
         urlVal.syn = MD5.hash(urlVal.desc + "|" + urlVal.gameId + "|" + urlVal.time + "|" + urlVal.uid + "|" + "/services/game-4399api|2d2dfa46e848c848b2357359d9548ce6");
         this.getdata("services/game-4399api",urlVal,"http://my.4399.com/",urlVal.time);
      }
   }
}

