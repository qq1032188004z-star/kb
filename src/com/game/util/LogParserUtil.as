package com.game.util
{
   import com.core.observer.MessageEvent;
   import com.game.locators.EventDefine;
   import com.game.locators.GameData;
   import com.xygame.module.battle.data.BattleLookList;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import org.green.server.data.ByteArray;
   import org.green.server.data.MsgUtil;
   
   public class LogParserUtil
   {
      
      private static var instance:LogParserUtil;
      
      private var logObjects:Array = [];
      
      private var _loader:URLLoader;
      
      public function LogParserUtil()
      {
         super();
         this.loadLogFile();
      }
      
      public static function getInstance() : LogParserUtil
      {
         if(instance == null)
         {
            instance = new LogParserUtil();
         }
         return instance;
      }
      
      private function loadLogFile() : void
      {
         this._loader = new URLLoader();
         this._loader.addEventListener(Event.COMPLETE,this.onLoadComplete);
         this._loader.addEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
         this._loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
      }
      
      public function load(str:String) : void
      {
         var request:URLRequest = null;
         try
         {
            this.logObjects.length = 0;
            request = new URLRequest(str);
            this._loader.load(request);
         }
         catch(error:Error)
         {
            O.o("加载请求出错: " + error.message);
         }
      }
      
      private function onLoadComplete(event:Event) : void
      {
         var loader:URLLoader = event.target as URLLoader;
         var content:String = loader.data as String;
         this.parseLogContent(content);
      }
      
      private function onLoadError(event:IOErrorEvent) : void
      {
         O.o("加载错误: " + event.text);
      }
      
      private function onSecurityError(event:SecurityErrorEvent) : void
      {
         O.o("安全错误: " + event.text);
      }
      
      private function parseLogContent(content:String) : void
      {
         var line:String = null;
         var logObject:Object = null;
         var lines:Array = content.split("round:");
         for each(line in lines)
         {
            if(line.indexOf("data:") !== -1 && line.indexOf("size:") !== -1)
            {
               logObject = this.parseLogLine(line);
               if(Boolean(logObject))
               {
                  this.logObjects.push(logObject);
               }
            }
         }
         O.o("成功解析 " + this.logObjects.length + " 个日志对象");
         this.displayParsedObjects();
      }
      
      private function parseLogLine(line:String) : Object
      {
         var sizeIndex:int = 0;
         var dataIndex:int = 0;
         var roundNum:int = 0;
         var sizeNum:int = 0;
         var dataStr:String = null;
         var byteArray:ByteArray = null;
         try
         {
            sizeIndex = int(line.indexOf("size:"));
            dataIndex = int(line.indexOf("data:"));
            roundNum = int(line.substring(0,sizeIndex));
            sizeNum = int(line.substring(sizeIndex + 5,dataIndex));
            dataStr = line.substring(dataIndex + 5);
            byteArray = Base64.decodeToByteArray(dataStr);
            return {
               "round":roundNum,
               "data":byteArray,
               "rawLine":line,
               "size":sizeNum,
               "dataLength":byteArray.length
            };
         }
         catch(error:Error)
         {
            O.o("解析行出错: " + error.message);
         }
         return null;
      }
      
      private function displayParsedObjects() : void
      {
         var obj:Object = null;
         var size:int = 0;
         var extractedData:ByteArray = null;
         BattleLookList.ins.initData(2);
         for(var i:int = 0; i < this.logObjects.length; i++)
         {
            obj = this.logObjects[i];
            this.displayByteArrayContent(obj.data,i);
            size = int(obj.dataLength);
            extractedData = MsgUtil.createByteArray();
            obj["data"].readBytes(extractedData,0,size);
            BattleLookList.ins.addLookData(extractedData);
         }
         GameData.instance.dispatchEvent(new MessageEvent(EventDefine.LOOK_BATTLE));
      }
      
      private function displayByteArrayContent(byteArray:ByteArray, index:int) : void
      {
         var byte:uint = 0;
         var hex:String = null;
         var originalPosition:uint = byteArray.position;
         byteArray.position = 0;
         var maxDisplay:uint = Math.min(20,byteArray.bytesAvailable);
         for(var i:uint = 0; i < maxDisplay; i++)
         {
            if(byteArray.bytesAvailable > 0)
            {
               byte = byteArray.readUnsignedByte();
               hex = byte.toString(16).toUpperCase();
               if(hex.length == 1)
               {
                  hex = "0" + hex;
               }
            }
         }
         byteArray.position = originalPosition;
      }
      
      public function getLogObjects() : Array
      {
         return this.logObjects;
      }
      
      public function getObjectsByRound(roundNum:int) : Array
      {
         return this.logObjects.filter(function(obj:Object, index:int, arr:Array):Boolean
         {
            return obj.round === roundNum;
         });
      }
      
      public function getDataByRound(roundNum:int) : Array
      {
         var obj:Object = null;
         var result:Array = [];
         var objects:Array = this.getObjectsByRound(roundNum);
         for each(obj in objects)
         {
            result.push(obj.data);
         }
         return result;
      }
   }
}

