package org.zip.wirelust.as3zlib
{
   import flash.utils.ByteArray;
   
   public final class Inflate
   {
      
      private static const MAX_WBITS:int = 15;
      
      private static const PRESET_DICT:int = 32;
      
      public static const Z_NO_FLUSH:int = 0;
      
      public static const Z_PARTIAL_FLUSH:int = 1;
      
      public static const Z_SYNC_FLUSH:int = 2;
      
      public static const Z_FULL_FLUSH:int = 3;
      
      public static const Z_FINISH:int = 4;
      
      private static const Z_DEFLATED:int = 8;
      
      private static const Z_OK:int = 0;
      
      private static const Z_STREAM_END:int = 1;
      
      private static const Z_NEED_DICT:int = 2;
      
      private static const Z_ERRNO:int = -1;
      
      private static const Z_STREAM_ERROR:int = -2;
      
      private static const Z_DATA_ERROR:int = -3;
      
      private static const Z_MEM_ERROR:int = -4;
      
      private static const Z_BUF_ERROR:int = -5;
      
      private static const Z_VERSION_ERROR:int = -6;
      
      public static const METHOD:int = 0;
      
      public static const FLAG:int = 1;
      
      public static const DICT4:int = 2;
      
      public static const DICT3:int = 3;
      
      public static const DICT2:int = 4;
      
      public static const DICT1:int = 5;
      
      public static const DICT0:int = 6;
      
      public static const BLOCKS:int = 7;
      
      public static const CHECK4:int = 8;
      
      public static const CHECK3:int = 9;
      
      public static const CHECK2:int = 10;
      
      public static const CHECK1:int = 11;
      
      public static const DONE:int = 12;
      
      public static const BAD:int = 13;
      
      private static var mark:Array = new Array(0,0,255,255);
      
      public var mode:int;
      
      public var method:int;
      
      public var was:Array = new Array();
      
      public var need:Number;
      
      public var marker:int;
      
      public var nowrap:int;
      
      public var wbits:int;
      
      public var blocks:InfBlocks;
      
      public function Inflate()
      {
         super();
      }
      
      public function inflateReset(z:ZStream) : int
      {
         if(z == null || z.istate == null)
         {
            return Z_STREAM_ERROR;
         }
         z.total_in = z.total_out = 0;
         z.msg = null;
         z.istate.mode = z.istate.nowrap != 0 ? BLOCKS : METHOD;
         z.istate.blocks.reset(z,null);
         return Z_OK;
      }
      
      public function inflateEnd(z:ZStream) : int
      {
         if(this.blocks != null)
         {
            this.blocks.free(z);
         }
         this.blocks = null;
         return Z_OK;
      }
      
      public function inflateInit(z:ZStream, w:int) : int
      {
         z.msg = null;
         this.blocks = null;
         this.nowrap = 0;
         if(w < 0)
         {
            w = -w;
            this.nowrap = 1;
         }
         if(w < 8 || w > 15)
         {
            this.inflateEnd(z);
            return Z_STREAM_ERROR;
         }
         this.wbits = w;
         z.istate.blocks = new InfBlocks(z,z.istate.nowrap != 0 ? null : this,1 << w);
         this.inflateReset(z);
         return Z_OK;
      }
      
      public function inflate(z:ZStream, f:int) : int
      {
         var r:int = 0;
         var b:int = 0;
         var checksum:int = 0;
         if(z == null || z.istate == null || z.next_in == null)
         {
            return Z_STREAM_ERROR;
         }
         f = f == Z_FINISH ? Z_BUF_ERROR : Z_OK;
         r = Z_BUF_ERROR;
         while(true)
         {
            switch(z.istate.mode)
            {
               case METHOD:
                  if(z.avail_in == 0)
                  {
                     return r;
                  }
                  r = f;
                  --z.avail_in;
                  ++z.total_in;
                  if(((z.istate.method = z.next_in[z.next_in_index++]) & 0x0F) != Z_DEFLATED)
                  {
                     z.istate.mode = BAD;
                     z.msg = "unknown compression method";
                     z.istate.marker = 5;
                     continue;
                  }
                  if((z.istate.method >> 4) + 8 > z.istate.wbits)
                  {
                     z.istate.mode = BAD;
                     z.msg = "invalid window size";
                     z.istate.marker = 5;
                     continue;
                  }
                  z.istate.mode = FLAG;
               case FLAG:
                  if(z.avail_in == 0)
                  {
                     return r;
                  }
                  r = f;
                  --z.avail_in;
                  ++z.total_in;
                  b = z.next_in[z.next_in_index++] & 0xFF;
                  checksum = ((z.istate.method << 8) + b) % 31;
                  if(checksum != 0)
                  {
                     z.istate.mode = BAD;
                     z.msg = "incorrect header check";
                     z.istate.marker = 5;
                     continue;
                  }
                  if((b & PRESET_DICT) == 0)
                  {
                     z.istate.mode = BLOCKS;
                     continue;
                  }
                  z.istate.mode = DICT4;
               case DICT4:
                  if(z.avail_in == 0)
                  {
                     return r;
                  }
                  r = f;
                  --z.avail_in;
                  ++z.total_in;
                  z.istate.need = (z.next_in[z.next_in_index++] & 0xFF) << 24 & 0xFF000000;
                  z.istate.mode = DICT3;
               case DICT3:
                  if(z.avail_in == 0)
                  {
                     return r;
                  }
                  r = f;
                  --z.avail_in;
                  ++z.total_in;
                  z.istate.need += (z.next_in[z.next_in_index++] & 0xFF) << 16 & 0xFF0000;
                  z.istate.mode = DICT2;
               case DICT2:
                  if(z.avail_in == 0)
                  {
                     return r;
                  }
                  r = f;
                  --z.avail_in;
                  ++z.total_in;
                  z.istate.need += (z.next_in[z.next_in_index++] & 0xFF) << 8 & 0xFF00;
                  z.istate.mode = DICT1;
               case DICT1:
                  break;
               case DICT0:
                  z.istate.mode = BAD;
                  z.msg = "need dictionary";
                  z.istate.marker = 0;
                  return Z_STREAM_ERROR;
               case BLOCKS:
                  r = z.istate.blocks.proc(z,r);
                  if(r == Z_DATA_ERROR)
                  {
                     z.istate.mode = BAD;
                     z.istate.marker = 0;
                     continue;
                  }
                  if(r == Z_OK)
                  {
                     r = f;
                  }
                  if(r != Z_STREAM_END)
                  {
                     return r;
                  }
                  r = f;
                  z.istate.blocks.reset(z,z.istate.was);
                  if(z.istate.nowrap != 0)
                  {
                     z.istate.mode = DONE;
                     continue;
                  }
                  z.istate.mode = CHECK4;
               case CHECK4:
                  if(z.avail_in == 0)
                  {
                     return r;
                  }
                  r = f;
                  --z.avail_in;
                  ++z.total_in;
                  z.istate.need = (z.next_in[z.next_in_index++] & 0xFF) << 24 & 0xFF000000;
                  z.istate.mode = CHECK3;
               case CHECK3:
                  if(z.avail_in == 0)
                  {
                     return r;
                  }
                  r = f;
                  --z.avail_in;
                  ++z.total_in;
                  z.istate.need += (z.next_in[z.next_in_index++] & 0xFF) << 16 & 0xFF0000;
                  z.istate.mode = CHECK2;
               case CHECK2:
                  if(z.avail_in == 0)
                  {
                     return r;
                  }
                  r = f;
                  --z.avail_in;
                  ++z.total_in;
                  z.istate.need += (z.next_in[z.next_in_index++] & 0xFF) << 8 & 0xFF00;
                  z.istate.mode = CHECK1;
               case CHECK1:
                  if(z.avail_in == 0)
                  {
                     return r;
                  }
                  r = f;
                  --z.avail_in;
                  ++z.total_in;
                  z.istate.need += z.next_in[z.next_in_index++] & 0xFF;
                  if(int(z.istate.was[0]) != int(z.istate.need))
                  {
                     z.istate.mode = BAD;
                     z.msg = "incorrect data check";
                     z.istate.marker = 5;
                     continue;
                  }
                  z.istate.mode = DONE;
               case DONE:
                  return Z_STREAM_END;
               case BAD:
                  return Z_DATA_ERROR;
               default:
                  return Z_STREAM_ERROR;
            }
            if(z.avail_in == 0)
            {
               return r;
            }
            r = f;
            --z.avail_in;
            ++z.total_in;
            z.istate.need += z.next_in[z.next_in_index++] & 0xFF;
            z.adler = z.istate.need;
            z.istate.mode = DICT0;
            return Z_NEED_DICT;
         }
         return Z_STREAM_ERROR;
      }
      
      public function inflateSetDictionary(z:ZStream, dictionary:ByteArray, dictLength:int) : int
      {
         var index:int = 0;
         var length:int = dictLength;
         if(z == null || z.istate == null || z.istate.mode != DICT0)
         {
            return Z_STREAM_ERROR;
         }
         if(z._adler.adler32(1,dictionary,0,dictLength) != z.adler)
         {
            return Z_DATA_ERROR;
         }
         z.adler = z._adler.adler32(0,null,0,0);
         if(length >= 1 << z.istate.wbits)
         {
            length = (1 << z.istate.wbits) - 1;
            index = dictLength - length;
         }
         z.istate.blocks.set_dictionary(dictionary,index,length);
         z.istate.mode = BLOCKS;
         return Z_OK;
      }
      
      public function inflateSync(z:ZStream) : int
      {
         var n:int = 0;
         var p:int = 0;
         var m:int = 0;
         var r:Number = NaN;
         var w:Number = NaN;
         if(z == null || z.istate == null)
         {
            return Z_STREAM_ERROR;
         }
         if(z.istate.mode != BAD)
         {
            z.istate.mode = BAD;
            z.istate.marker = 0;
         }
         n = z.avail_in;
         if(n == 0)
         {
            return Z_BUF_ERROR;
         }
         p = z.next_in_index;
         m = z.istate.marker;
         while(n != 0 && m < 4)
         {
            if(z.next_in[p] == mark[m])
            {
               m++;
            }
            else if(z.next_in[p] != 0)
            {
               m = 0;
            }
            else
            {
               m = 4 - m;
            }
            p++;
            n--;
         }
         z.total_in += p - z.next_in_index;
         z.next_in_index = p;
         z.avail_in = n;
         z.istate.marker = m;
         if(m != 4)
         {
            return Z_DATA_ERROR;
         }
         r = z.total_in;
         w = z.total_out;
         this.inflateReset(z);
         z.total_in = r;
         z.total_out = w;
         z.istate.mode = BLOCKS;
         return Z_OK;
      }
      
      public function inflateSyncPoint(z:ZStream) : int
      {
         if(z == null || z.istate == null || z.istate.blocks == null)
         {
            return Z_STREAM_ERROR;
         }
         return z.istate.blocks.sync_point();
      }
   }
}

