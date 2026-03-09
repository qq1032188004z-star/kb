package
{
   import com.game.locators.GameData;
   import com.game.locators.MsgDoc;
   import flash.external.ExternalInterface;
   import org.green.server.core.GreenSocket;
   import org.green.server.data.ByteArray;
   import org.green.server.data.CmdPacket;
   import org.green.server.events.MsgEvent;
   import org.green.server.manager.SocketManager;
   
   public class O
   {
      
      private static var _isLog:Boolean;
      
      private static var _con:GreenSocket;
      
      public static var debug:Boolean = false;
      
      public static var isTrace:Boolean = true;
      
      private static const LOG_ARY:Array = [];
      
      public static var openTrace:Boolean = false;
      
      public function O()
      {
         super();
      }
      
      public static function initCombatLog() : void
      {
         _isLog = false;
      }
      
      public static function checkCombatLog(id:int) : void
      {
         if(!_isLog)
         {
            _isLog = LOG_ARY.indexOf(id) != -1;
         }
      }
      
      public static function o(value:String = null, ... _args) : void
      {
         var v:String = null;
         var i:int = 0;
         var l:int = 0;
         if(isTrace && debug)
         {
            v = "--------- " + value + " star ---------\n";
            if(_args && _args.length > 0)
            {
               l = int(_args.length);
               i = 0;
               while(i < l)
               {
                  v += "\t" + _args[i];
                  i++;
               }
            }
            v += "\n--------- " + value + " end ---------\n";
            trace(v);
            if(ExternalInterface.available)
            {
               ExternalInterface.call("console.log",v);
            }
         }
      }
      
      public static function getMsgHeadInfo(event:MsgEvent) : String
      {
         return "Code：" + event.msg.mOpcode.toString(16) + "\nParams：" + event.msg.mParams.toString() + "\n";
      }
      
      public static function tracePacket(packet:CmdPacket) : void
      {
         var str:String = null;
         var i:int = 0;
         var b:String = null;
         if(isTrace && (debug || _isLog && isSendByCode(packet.mOpcode)))
         {
            str = "";
            str += "C：" + packet.mOpcode.toString(16) + "\n";
            str += "P：" + packet.mParams + "\n";
            if(packet.bodyargs != null)
            {
               str += "\nB:";
               for(i = 0; i < packet.bodyargs.length; i++)
               {
                  b = packet.bodyargs[i];
                  str += "\n" + b;
               }
            }
            if(debug)
            {
               trace("\n----- CMD START ----- \n" + str + " \n----- CMD END -----\n");
               if(ExternalInterface.available)
               {
                  ExternalInterface.call("console.log","\n----- CMD START ----- \n" + str + "\n ----- CMD END -----\n");
               }
            }
            if(_isLog && isSendByCode(packet.mOpcode))
            {
               con().sendCmd(1185430,0,[GameData.instance.playerData.userId,1,str.replace(/\n/g,"#")]);
            }
         }
      }
      
      private static function isSendByCode(code:int) : Boolean
      {
         return [MsgDoc.OP_CLIENT_USER_OP.send,MsgDoc.OP_CLIENT_BATTLE_PLAY_OVER.send].indexOf(code) != -1;
      }
      
      public static function traceSocketBysend(event:MsgEvent) : void
      {
         var str:String = traceSocket(event,"",0,2);
         if(_isLog)
         {
            con().sendCmd(1185430,0,[GameData.instance.playerData.userId,1,str.replace(/\n/g,"#")]);
         }
      }
      
      public static function traceSocket(event:MsgEvent, opcode:String = "", params:int = 0, bodyType:int = 0, str:String = "si") : String
      {
         var code:String = null;
         var v:String = null;
         var byteArray:ByteArray = null;
         var i:int = 0;
         var curNum:int = 0;
         var bodyStr:String = null;
         var index:String = null;
         var char:String = null;
         if(isTrace && (debug || _isLog))
         {
            if(openTrace)
            {
               bodyType = bodyType != 0 ? bodyType : 2;
            }
            code = event.msg.mOpcode.toString(16);
            if(code == MsgDoc.OP_CLIENT_ACTIVITY_QINGYANG_NEW.back.toString(16) || code == MsgDoc.OP_CLIENT_ACTIVITY_QINGYANG.back.toString(16))
            {
               traceSocketByAct(event,opcode,params,bodyType);
               return "";
            }
            v = "";
            v += "C：" + (opcode == "" ? event.msg.mOpcode.toString(16) : opcode) + "\n";
            v += "P：" + (params == 0 ? event.msg.mParams.toString() : params.toString()) + "\n";
            v += "B：\n";
            byteArray = event.msg.body;
            byteArray.position = 0;
            i = 0;
            bodyStr = "";
            switch(bodyType)
            {
               case 0:
                  break;
               case 1:
                  v += byteArray.readInt() + "\n";
                  i++;
                  v += byteArray.readUTF() + "\n";
                  i++;
                  break;
               case 2:
                  while(byteArray.position < byteArray.length)
                  {
                     curNum = byteArray.readInt();
                     if(i >= 9999)
                     {
                        bodyStr = "数据无法使用默认解析";
                        break;
                     }
                     bodyStr += curNum + "\n";
                     i++;
                  }
                  break;
               case 3:
                  for(index in str)
                  {
                     if(byteArray.position >= byteArray.length)
                     {
                        continue;
                     }
                     char = str[parseInt(index)];
                     switch(char)
                     {
                        case "s":
                           v += byteArray.readUTF() + "\n";
                           i++;
                           break;
                        case "i":
                           v += byteArray.readInt() + "\n";
                           i++;
                     }
                  }
            }
            v += bodyStr + "";
            if(debug)
            {
               trace("\n----- MSG START ----- \n" + v + " \n----- MSG END -----\n");
               if(ExternalInterface.available)
               {
                  ExternalInterface.call("console.log","\n----- MSG START ----- \n" + v + "\n ----- MSG END -----\n");
               }
            }
            byteArray.position = 0;
            return v;
         }
         return "";
      }
      
      public static function traceSocketByAct(event:MsgEvent, opcode:String = "", params:int = 0, bodyType:int = 0) : String
      {
         var curNum:int = 0;
         var v:String = "";
         v += "C：" + (opcode == "" ? event.msg.mOpcode.toString(16) : opcode) + "\n";
         v += "P：" + (params == 0 ? event.msg.mParams.toString() : params.toString()) + "\n";
         v += "B：\n";
         var byteArray:ByteArray = event.msg.body;
         byteArray.position = 0;
         var i:int = 0;
         var bodyStr:String = "";
         if(event.msg.mParams >= 600)
         {
            v += byteArray.readUTF() + "\n";
            i++;
         }
         switch(bodyType)
         {
            case 0:
               break;
            case 1:
               v += byteArray.readInt() + "\n";
               i++;
               v += byteArray.readUTF() + "\n";
               i++;
               break;
            case 2:
               while(byteArray.position < byteArray.length)
               {
                  curNum = byteArray.readInt();
                  if(i >= 9999)
                  {
                     bodyStr = "数据无法使用默认解析";
                     break;
                  }
                  bodyStr += curNum + "\n";
                  i++;
               }
         }
         v += bodyStr + "";
         if(debug)
         {
            trace("\n----- MSG START ----- \n" + v + " \n----- MSG END -----\n");
            if(ExternalInterface.available)
            {
               ExternalInterface.call("console.log","\n----- MSG START ----- \n" + v + "\n ----- MSG END -----\n");
            }
         }
         byteArray.position = 0;
         return v;
      }
      
      public static function getTraceSocketStr(event:MsgEvent, opcode:String = "", params:int = 0, bodyType:int = 0) : String
      {
         var v:String = null;
         var byteArray:ByteArray = null;
         var i:int = 0;
         var curNum:int = 0;
         var bodyStr:String = null;
         if(isTrace && (debug || _isLog))
         {
            v = "";
            v += "C：" + (opcode == "" ? event.msg.mOpcode.toString(16) : opcode) + "\n";
            v += "P：" + (params == 0 ? event.msg.mParams.toString() : params.toString()) + "\n";
            v += "B：\n";
            byteArray = event.msg.body;
            byteArray.position = 0;
            i = 0;
            bodyStr = "";
            if(event.msg.mParams >= 600 && event.msg.mParams < 800)
            {
               v += byteArray.readUTF() + "\n";
               i++;
            }
            switch(bodyType)
            {
               case 0:
                  break;
               case 1:
                  v += byteArray.readInt() + "\n";
                  i++;
                  v += byteArray.readUTF() + "\n";
                  i++;
                  break;
               case 2:
                  while(byteArray.position < byteArray.length)
                  {
                     curNum = byteArray.readInt();
                     if(i >= 9999)
                     {
                        bodyStr = "数据无法使用默认解析";
                        break;
                     }
                     bodyStr += curNum + "\n";
                     i++;
                  }
            }
            v += bodyStr + "";
            byteArray.position = 0;
            return v;
         }
         return "";
      }
      
      public static function out(value:String = null) : void
      {
         if(isTrace && debug)
         {
            trace(value);
            if(ExternalInterface.available)
            {
               ExternalInterface.call("console.log",value);
            }
         }
      }
      
      private static function con() : GreenSocket
      {
         if(_con == null)
         {
            _con = SocketManager.getGreenSocket();
         }
         return _con;
      }
   }
}

