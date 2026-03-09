package org.green.server.core
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.Socket;
   import flash.system.Security;
   import flash.utils.Endian;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import org.green.server.data.ByteArray;
   import org.green.server.data.CmdPacket;
   import org.green.server.data.MsgPacket;
   import org.green.server.data.MsgUtil;
   import org.green.server.data.PacketBuffer;
   import org.green.server.events.MsgEvent;
   import org.green.server.interfaces.IParser;
   import org.green.server.util.TimeoutEvent;
   
   public class GreenSocket extends EventDispatcher
   {
      
      public static var CONNECTTED:String = "connectted";
      
      public static var CONNECTION_ERROR:String = "connection_error";
      
      private var _socket:Socket;
      
      private var host:String;
      
      private var port:int;
      
      private var packetBuffer:PacketBuffer;
      
      public var stopmove:Boolean = false;
      
      private var lastSendTime:Number;
      
      private var tid:int;
      
      private var packets:Array = [];
      
      private var locked:Boolean = true;
      
      private var parserCache:Array = [];
      
      public function GreenSocket()
      {
         super();
         this.packetBuffer = new PacketBuffer();
      }
      
      public function get socket() : Socket
      {
         if(this._socket == null)
         {
            this._socket = new Socket();
            this._socket.endian = Endian.LITTLE_ENDIAN;
            this.addListeners();
         }
         return this._socket;
      }
      
      public function attachSocketListener(eventID:int, callBack:Function, pharse:Class = null) : void
      {
         this.addEventListener(eventID.toString(),callBack);
         this.parserCache[eventID.toString()] = pharse;
      }
      
      public function removeSocketListener(eventID:int, callBack:Function) : void
      {
         this.removeEventListener(eventID.toString(),callBack);
         delete this.parserCache[eventID.toString()];
      }
      
      public function connect(host:String, port:int) : Boolean
      {
         O.o("GreenSocket/connect()","host:" + host,"port:" + port);
         if(this.socket.connected == true)
         {
            return false;
         }
         this.host = host;
         this.port = port;
         Security.loadPolicyFile("xmlsocket://" + this.host + ":843");
         Security.allowDomain("*");
         Security.allowInsecureDomain("*");
         this.socket.connect(host,port);
         return true;
      }
      
      public function sendCmd(mOpcode:uint, mParams:int = 0, body:Array = null) : void
      {
         var packet:CmdPacket = CmdPacket.build(mOpcode,mParams,body);
         this.sendpacket(packet);
      }
      
      public function sendpacket(packet:CmdPacket) : void
      {
         if(this.isConnect() == false)
         {
            this.dispatchEvent(new Event(CONNECTION_ERROR));
            return;
         }
         O.tracePacket(packet);
         var buf:ByteArray = packet.encode();
         buf.position = 0;
         this._socket.writeBytes(buf);
         this._socket.flush();
      }
      
      public function reconnect() : void
      {
         if(this.socket.connected)
         {
            return;
         }
         this.socket.connect(this.host,this.port);
      }
      
      public function isConnect() : Boolean
      {
         return Boolean(this._socket) && this._socket.connected;
      }
      
      private function addListeners() : void
      {
         this._socket.addEventListener(IOErrorEvent.IO_ERROR,this.Net_Error);
         this._socket.addEventListener(Event.CLOSE,this.onClosed);
         this._socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.Net_Error);
         this._socket.addEventListener(Event.CONNECT,this.Net_Connect);
         this._socket.addEventListener(ProgressEvent.SOCKET_DATA,this.Net_Data);
      }
      
      private function removeListeners() : void
      {
         if(Boolean(this._socket))
         {
            if(this._socket.hasEventListener(IOErrorEvent.IO_ERROR))
            {
               this._socket.removeEventListener(IOErrorEvent.IO_ERROR,this.Net_Error);
            }
            if(this._socket.hasEventListener(Event.CLOSE))
            {
               this._socket.removeEventListener(Event.CLOSE,this.onClosed);
            }
            if(this._socket.hasEventListener(SecurityErrorEvent.SECURITY_ERROR))
            {
               this._socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.Net_Error);
            }
            if(this._socket.hasEventListener(Event.CONNECT))
            {
               this._socket.removeEventListener(Event.CONNECT,this.Net_Connect);
            }
            if(this._socket.hasEventListener(ProgressEvent.SOCKET_DATA))
            {
               this._socket.removeEventListener(ProgressEvent.SOCKET_DATA,this.Net_Data);
            }
         }
      }
      
      public function close() : void
      {
         if(Boolean(this._socket))
         {
            if(this._socket.connected)
            {
               this._socket.close();
            }
            this.removeListeners();
            this._socket = null;
         }
      }
      
      private function onClosed(evt:Event) : void
      {
         clearInterval(this.tid);
         this.dispatchEvent(new Event(CONNECTION_ERROR));
      }
      
      private function Net_Error(evt:Event) : void
      {
         this.socket.connect(this.host,this.port);
      }
      
      private function Net_Connect(evt:Event) : void
      {
         clearInterval(this.tid);
         this.tid = setInterval(this.loopSend,30000);
         this.packetBuffer.clear();
         this.dispatchEvent(new Event(CONNECTTED));
      }
      
      private function loopSend() : void
      {
         this.sendCmd(327686);
      }
      
      private function Net_Data(event:ProgressEvent) : void
      {
         var ba:ByteArray = MsgUtil.createByteArray();
         this._socket.readBytes(ba,0,event.bytesLoaded);
         this.packetBuffer.push(ba);
         if(this.locked)
         {
            this.dodispatch();
         }
      }
      
      private function dodispatch() : void
      {
         var curIndex:int = 0;
         var len:int = 0;
         if(this.locked)
         {
            this.locked = false;
            this.packets = this.packetBuffer.getPackets();
            len = int(this.packets.length);
            if(len == 0)
            {
               this.locked = true;
            }
            curIndex = 0;
            while(curIndex < len)
            {
               this.dispatch(this.packets.shift() as MsgPacket);
               if(curIndex + 1 == len)
               {
                  this.locked = true;
               }
               curIndex++;
            }
         }
      }
      
      private function onTimeout(e:TimeoutEvent) : void
      {
         var timeout:Function = e.context.timeoutfun;
         var argback:Object = e.context.argback;
         if(timeout != null)
         {
            timeout(argback);
         }
      }
      
      private function dispatch(packet:MsgPacket) : void
      {
         var cls:Class = null;
         var iparser:IParser = null;
         if(packet.body != null)
         {
            cls = this.parserCache[packet.mOpcode] as Class;
            if(cls != null)
            {
               iparser = new cls() as IParser;
               try
               {
                  iparser.parse(packet);
               }
               catch(e:*)
               {
               }
            }
         }
         this.dispatchEvent(new MsgEvent(packet.mOpcode,packet));
      }
   }
}

