package org.zip.wirelust.as3zlib
{
   import flash.utils.ByteArray;
   
   public final class ZStream
   {
      
      private static var MAX_WBITS:int = 15;
      
      private static var DEF_WBITS:int = MAX_WBITS;
      
      private static var Z_NO_FLUSH:int = 0;
      
      private static var Z_PARTIAL_FLUSH:int = 1;
      
      private static var Z_SYNC_FLUSH:int = 2;
      
      private static var Z_FULL_FLUSH:int = 3;
      
      private static var Z_FINISH:int = 4;
      
      private static var MAX_MEM_LEVEL:int = 9;
      
      private static var Z_OK:int = 0;
      
      private static var Z_STREAM_END:int = 1;
      
      private static var Z_NEED_DICT:int = 2;
      
      private static var Z_ERRNO:int = -1;
      
      private static var Z_STREAM_ERROR:int = -2;
      
      private static var Z_DATA_ERROR:int = -3;
      
      private static var Z_MEM_ERROR:int = -4;
      
      private static var Z_BUF_ERROR:int = -5;
      
      private static var Z_VERSION_ERROR:int = -6;
      
      public var next_in:ByteArray;
      
      public var next_in_index:int;
      
      public var avail_in:int;
      
      public var total_in:Number;
      
      public var next_out:ByteArray;
      
      public var next_out_index:int;
      
      public var avail_out:int;
      
      public var total_out:Number;
      
      public var msg:String;
      
      public var dstate:Deflate;
      
      public var istate:Inflate;
      
      public var data_type:int;
      
      public var adler:Number;
      
      public var _adler:Adler32 = new Adler32();
      
      public function ZStream()
      {
         super();
      }
      
      public function inflateInit() : int
      {
         return this.inflateInitWithWbits(DEF_WBITS);
      }
      
      public function inflateInitWithNoWrap(nowrap:Boolean) : int
      {
         return this.inflateInitWithWbitsNoWrap(DEF_WBITS,nowrap);
      }
      
      public function inflateInitWithWbits(w:int) : int
      {
         return this.inflateInitWithWbitsNoWrap(w,false);
      }
      
      public function inflateInitWithWbitsNoWrap(w:int, nowrap:Boolean) : int
      {
         this.istate = new Inflate();
         return this.istate.inflateInit(this,nowrap ? int(-w) : w);
      }
      
      public function inflate(f:int) : int
      {
         if(this.istate == null)
         {
            return Z_STREAM_ERROR;
         }
         return this.istate.inflate(this,f);
      }
      
      public function inflateEnd() : int
      {
         if(this.istate == null)
         {
            return Z_STREAM_ERROR;
         }
         var ret:int = this.istate.inflateEnd(this);
         this.istate = null;
         return ret;
      }
      
      public function inflateSync() : int
      {
         if(this.istate == null)
         {
            return Z_STREAM_ERROR;
         }
         return this.istate.inflateSync(this);
      }
      
      public function inflateSetDictionary(dictionary:ByteArray, dictLength:int) : int
      {
         if(this.istate == null)
         {
            return Z_STREAM_ERROR;
         }
         return this.istate.inflateSetDictionary(this,dictionary,dictLength);
      }
      
      public function deflateInit(level:int) : int
      {
         return this.deflateInitWithIntInt(level,MAX_WBITS);
      }
      
      public function deflateInitWithBoolean(level:int, nowrap:Boolean) : int
      {
         return this.deflateInitWithIntIntBoolean(level,MAX_WBITS,nowrap);
      }
      
      public function deflateInitWithIntInt(level:int, bits:int) : int
      {
         return this.deflateInitWithIntIntBoolean(level,bits,false);
      }
      
      public function deflateInitWithIntIntBoolean(level:int, bits:int, nowrap:Boolean) : int
      {
         this.dstate = new Deflate();
         return this.dstate.deflateInitWithBits(this,level,nowrap ? int(-bits) : bits);
      }
      
      public function deflate(flush:int) : int
      {
         if(this.dstate == null)
         {
            return Z_STREAM_ERROR;
         }
         return this.dstate.deflate(this,flush);
      }
      
      public function deflateEnd() : int
      {
         if(this.dstate == null)
         {
            return Z_STREAM_ERROR;
         }
         var ret:int = this.dstate.deflateEnd();
         this.dstate = null;
         return ret;
      }
      
      public function deflateParams(level:int, strategy:int) : int
      {
         if(this.dstate == null)
         {
            return Z_STREAM_ERROR;
         }
         return this.dstate.deflateParams(this,level,strategy);
      }
      
      public function deflateSetDictionary(dictionary:ByteArray, dictLength:int) : int
      {
         if(this.dstate == null)
         {
            return Z_STREAM_ERROR;
         }
         return this.dstate.deflateSetDictionary(this,dictionary,dictLength);
      }
      
      public function flush_pending() : void
      {
         var len:int = this.dstate.pending;
         if(len > this.avail_out)
         {
            len = this.avail_out;
         }
         if(len == 0)
         {
            return;
         }
         if(this.dstate.pending_buf.length <= this.dstate.pending_out || this.next_out.length <= this.next_out_index || this.dstate.pending_buf.length < this.dstate.pending_out + len || this.next_out.length < this.next_out_index + len)
         {
         }
         System.byteArrayCopy(this.dstate.pending_buf,this.dstate.pending_out,this.next_out,this.next_out_index,len);
         this.next_out_index += len;
         this.dstate.pending_out += len;
         this.total_out += len;
         this.avail_out -= len;
         this.dstate.pending -= len;
         if(this.dstate.pending == 0)
         {
            this.dstate.pending_out = 0;
            this.dstate.pending_buf = new ByteArray();
         }
      }
      
      public function read_buf(buf:ByteArray, start:int, size:int) : int
      {
         var len:int = this.avail_in;
         if(len > size)
         {
            len = size;
         }
         if(len == 0)
         {
            return 0;
         }
         this.avail_in -= len;
         if(this.dstate.noheader == 0)
         {
            this.adler = this._adler.adler32(this.adler,this.next_in,this.next_in_index,len);
         }
         System.byteArrayCopy(this.next_in,this.next_in_index,buf,start,len);
         this.next_in_index += len;
         this.total_in += len;
         return len;
      }
      
      public function free() : void
      {
         this.next_in = null;
         this.next_out = null;
         this.msg = null;
         this._adler = null;
      }
   }
}

