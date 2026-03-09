package org.zip
{
   import flash.events.*;
   import flash.net.URLRequest;
   import flash.net.URLStream;
   import flash.utils.*;
   
   [Event(name="securityError",type="flash.events.SecurityErrorEvent")]
   [Event(name="progress",type="flash.events.ProgressEvent")]
   [Event(name="open",type="flash.events.Event")]
   [Event(name="ioError",type="flash.events.IOErrorEvent")]
   [Event(name="httpStatus",type="flash.events.HTTPStatusEvent")]
   [Event(name="complete",type="flash.events.Event")]
   [Event(name="parseError",type="deng.fzip.FZipErrorEvent")]
   [Event(name="fileLoaded",type="deng.fzip.FZipEvent")]
   public class FZip extends EventDispatcher
   {
      
      private var filesList:Array;
      
      private var filesDict:Dictionary;
      
      private var urlStream:URLStream;
      
      private var charEncoding:String;
      
      private var parseFunc:Function;
      
      private var currentFile:FZipFile;
      
      public function FZip(filenameEncoding:String = "utf-8")
      {
         super();
         this.charEncoding = filenameEncoding;
         this.parseFunc = this.parseIdle;
      }
      
      public function get active() : Boolean
      {
         return this.parseFunc !== this.parseIdle;
      }
      
      public function load(request:URLRequest) : void
      {
         if(!this.urlStream && this.parseFunc == this.parseIdle)
         {
            this.urlStream = new URLStream();
            this.urlStream.endian = Endian.LITTLE_ENDIAN;
            this.addEventHandlers();
            this.filesList = [];
            this.filesDict = new Dictionary();
            this.parseFunc = this.parseSignature;
            this.urlStream.load(request);
         }
      }
      
      public function loadBytes(bytes:ByteArray) : void
      {
         if(!this.urlStream && this.parseFunc == this.parseIdle)
         {
            this.filesList = [];
            this.filesDict = new Dictionary();
            bytes.position = 0;
            bytes.endian = Endian.LITTLE_ENDIAN;
            this.parseFunc = this.parseSignature;
            if(this.parse(bytes))
            {
               this.parseFunc = this.parseIdle;
               dispatchEvent(new Event(Event.COMPLETE));
            }
            else
            {
               dispatchEvent(new FZipErrorEvent(FZipErrorEvent.PARSE_ERROR,"EOF"));
            }
         }
      }
      
      public function close() : void
      {
         if(Boolean(this.urlStream))
         {
            this.parseFunc = this.parseIdle;
            this.removeEventHandlers();
            this.urlStream.close();
            this.urlStream = null;
         }
      }
      
      public function serialize(stream:IDataOutput, includeAdler32:Boolean = false) : void
      {
         var endian:String = null;
         var ba:ByteArray = null;
         var offset:uint = 0;
         var files:uint = 0;
         var i:int = 0;
         var file:FZipFile = null;
         if(stream != null && this.filesList.length > 0)
         {
            endian = stream.endian;
            ba = new ByteArray();
            stream.endian = ba.endian = Endian.LITTLE_ENDIAN;
            offset = 0;
            files = 0;
            for(i = 0; i < this.filesList.length; i++)
            {
               file = this.filesList[i] as FZipFile;
               if(file != null)
               {
                  file.serialize(ba,includeAdler32,true,offset);
                  offset += file.serialize(stream,includeAdler32);
                  files++;
               }
            }
            if(ba.length > 0)
            {
               stream.writeBytes(ba);
            }
            stream.writeUnsignedInt(101010256);
            stream.writeShort(0);
            stream.writeShort(0);
            stream.writeShort(files);
            stream.writeShort(files);
            stream.writeUnsignedInt(ba.length);
            stream.writeUnsignedInt(offset);
            stream.writeShort(0);
            stream.endian = endian;
         }
      }
      
      public function getFileCount() : uint
      {
         return Boolean(this.filesList) ? this.filesList.length : 0;
      }
      
      public function getFileAt(index:uint) : FZipFile
      {
         return Boolean(this.filesList) ? this.filesList[index] as FZipFile : null;
      }
      
      public function getFileByName(name:String) : FZipFile
      {
         return Boolean(this.filesDict[name]) ? this.filesDict[name] as FZipFile : null;
      }
      
      public function addFile(name:String, content:ByteArray = null) : FZipFile
      {
         return this.addFileAt(Boolean(this.filesList) ? this.filesList.length : 0,name,content);
      }
      
      public function addFileFromString(name:String, content:String, charset:String = "utf-8") : FZipFile
      {
         return this.addFileFromStringAt(Boolean(this.filesList) ? this.filesList.length : 0,name,content,charset);
      }
      
      public function addFileAt(index:uint, name:String, content:ByteArray = null) : FZipFile
      {
         if(this.filesList == null)
         {
            this.filesList = [];
         }
         if(this.filesDict == null)
         {
            this.filesDict = new Dictionary();
         }
         else if(Boolean(this.filesDict[name]))
         {
            throw new Error("File already exists: " + name + ". Please remove first.");
         }
         var file:FZipFile = new FZipFile();
         file.filename = name;
         file.content = content;
         if(index >= this.filesList.length)
         {
            this.filesList.push(file);
         }
         else
         {
            this.filesList.splice(index,0,file);
         }
         this.filesDict[name] = file;
         return file;
      }
      
      public function addFileFromStringAt(index:uint, name:String, content:String, charset:String = "utf-8") : FZipFile
      {
         if(this.filesList == null)
         {
            this.filesList = [];
         }
         if(this.filesDict == null)
         {
            this.filesDict = new Dictionary();
         }
         else if(Boolean(this.filesDict[name]))
         {
            throw new Error("File already exists: " + name + ". Please remove first.");
         }
         var file:FZipFile = new FZipFile();
         file.filename = name;
         file.setContentAsString(content,charset);
         if(index >= this.filesList.length)
         {
            this.filesList.push(file);
         }
         else
         {
            this.filesList.splice(index,0,file);
         }
         this.filesDict[name] = file;
         return file;
      }
      
      public function removeFileAt(index:uint) : FZipFile
      {
         var file:FZipFile = null;
         if(this.filesList != null && this.filesDict != null && index < this.filesList.length)
         {
            file = this.filesList[index] as FZipFile;
            if(file != null)
            {
               this.filesList.splice(index,1);
               delete this.filesDict[file.filename];
               return file;
            }
         }
         return null;
      }
      
      public function removeFileByName(name:String) : void
      {
         var i:int = 0;
         var file:FZipFile = null;
         if(this.filesList != null && this.filesDict != null)
         {
            for(i = 0; Boolean(i++); i < this.filesList.length)
            {
               file = this.filesList[i] as FZipFile;
               if(file.filename == name)
               {
                  this.removeFileAt(i);
                  break;
               }
            }
         }
      }
      
      protected function parse(stream:IDataInput) : Boolean
      {
         while(this.parseFunc(stream))
         {
         }
         return this.parseFunc === this.parseIdle;
      }
      
      private function parseIdle(stream:IDataInput) : Boolean
      {
         return false;
      }
      
      private function parseSignature(stream:IDataInput) : Boolean
      {
         var sig:uint = 0;
         if(stream.bytesAvailable >= 4)
         {
            sig = uint(stream.readUnsignedInt());
            switch(sig)
            {
               case 67324752:
                  this.parseFunc = this.parseLocalfile;
                  this.currentFile = new FZipFile(this.charEncoding);
                  break;
               case 33639248:
               case 101010256:
                  this.parseFunc = this.parseIdle;
                  break;
               default:
                  throw new Error("Unknown record signature.");
            }
            return true;
         }
         return false;
      }
      
      private function parseLocalfile(stream:IDataInput) : Boolean
      {
         if(this.currentFile.parse(stream))
         {
            this.filesList.push(this.currentFile);
            if(Boolean(this.currentFile.filename))
            {
               this.filesDict[this.currentFile.filename] = this.currentFile;
            }
            dispatchEvent(new FZipEvent(FZipEvent.FILE_LOADED,this.currentFile));
            this.currentFile = null;
            if(this.parseFunc != this.parseIdle)
            {
               this.parseFunc = this.parseSignature;
               return true;
            }
         }
         return false;
      }
      
      protected function progressHandler(evt:Event) : void
      {
         dispatchEvent(evt.clone());
         try
         {
            if(this.parse(this.urlStream))
            {
               this.close();
               dispatchEvent(new Event(Event.COMPLETE));
            }
         }
         catch(e:Error)
         {
            close();
            if(!hasEventListener(FZipErrorEvent.PARSE_ERROR))
            {
               throw e;
            }
            dispatchEvent(new FZipErrorEvent(FZipErrorEvent.PARSE_ERROR,e.message));
         }
      }
      
      protected function defaultHandler(evt:Event) : void
      {
         dispatchEvent(evt.clone());
      }
      
      protected function defaultErrorHandler(evt:Event) : void
      {
         this.close();
         dispatchEvent(evt.clone());
      }
      
      protected function addEventHandlers() : void
      {
         this.urlStream.addEventListener(Event.COMPLETE,this.defaultHandler);
         this.urlStream.addEventListener(Event.OPEN,this.defaultHandler);
         this.urlStream.addEventListener(HTTPStatusEvent.HTTP_STATUS,this.defaultHandler);
         this.urlStream.addEventListener(IOErrorEvent.IO_ERROR,this.defaultErrorHandler);
         this.urlStream.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.defaultErrorHandler);
         this.urlStream.addEventListener(ProgressEvent.PROGRESS,this.progressHandler);
      }
      
      protected function removeEventHandlers() : void
      {
         this.urlStream.removeEventListener(Event.COMPLETE,this.defaultHandler);
         this.urlStream.removeEventListener(Event.OPEN,this.defaultHandler);
         this.urlStream.removeEventListener(HTTPStatusEvent.HTTP_STATUS,this.defaultHandler);
         this.urlStream.removeEventListener(IOErrorEvent.IO_ERROR,this.defaultErrorHandler);
         this.urlStream.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.defaultErrorHandler);
         this.urlStream.removeEventListener(ProgressEvent.PROGRESS,this.progressHandler);
      }
   }
}

