package org.zip.wirelust.as3zlib
{
   import flash.utils.ByteArray;
   import org.zip.util.Cast;
   
   public final class InfBlocks
   {
      
      private static const MANY:int = 1440;
      
      private static const inflate_mask:Array = new Array(0,1,3,7,15,31,63,127,255,511,1023,2047,4095,8191,16383,32767,65535);
      
      public static const border:Array = new Array(16,17,18,0,8,7,9,6,10,5,11,4,12,3,13,2,14,1,15);
      
      private static const Z_OK:int = 0;
      
      private static const Z_STREAM_END:int = 1;
      
      private static const Z_NEED_DICT:int = 2;
      
      private static const Z_ERRNO:int = -1;
      
      private static const Z_STREAM_ERROR:int = -2;
      
      private static const Z_DATA_ERROR:int = -3;
      
      private static const Z_MEM_ERROR:int = -4;
      
      private static const Z_BUF_ERROR:int = -5;
      
      private static const Z_VERSION_ERROR:int = -6;
      
      private static const TYPE:int = 0;
      
      private static const LENS:int = 1;
      
      private static const STORED:int = 2;
      
      private static const TABLE:int = 3;
      
      private static const BTREE:int = 4;
      
      private static const DTREE:int = 5;
      
      private static const CODES:int = 6;
      
      private static const DRY:int = 7;
      
      private static const DONE:int = 8;
      
      private static const BAD:int = 9;
      
      public var mode:int;
      
      public var left:int;
      
      public var table:int;
      
      public var index:int;
      
      public var blens:Array;
      
      public var bb:Array = new Array();
      
      public var tb:Array = new Array();
      
      public var codes:InfCodes = new InfCodes();
      
      public var last:int;
      
      public var bitk:int;
      
      public var bitb:int;
      
      public var hufts:Array;
      
      public var window:ByteArray;
      
      public var end:int;
      
      public var read:int;
      
      public var write:int;
      
      public var checkfn:Object;
      
      public var check:Number;
      
      public var inftree:InfTree = new InfTree();
      
      public function InfBlocks(z:ZStream, checkfn:Object, w:int)
      {
         super();
         this.hufts = new Array();
         this.window = new ByteArray();
         this.end = w;
         this.checkfn = checkfn;
         this.mode = TYPE;
         this.reset(z,null);
      }
      
      public function reset(z:ZStream, c:Array) : void
      {
         if(c != null)
         {
            c[0] = this.check;
         }
         if(this.mode == BTREE || this.mode == DTREE)
         {
         }
         if(this.mode == CODES)
         {
            this.codes.free(z);
         }
         this.mode = TYPE;
         this.bitk = 0;
         this.bitb = 0;
         this.read = this.write = 0;
         if(this.checkfn != null)
         {
            z.adler = this.check = z._adler.adler32(0,null,0,0);
         }
      }
      
      public function proc(z:ZStream, r:int) : int
      {
         var t:int = 0;
         var b:int = 0;
         var k:int = 0;
         var p:int = 0;
         var n:int = 0;
         var q:int = 0;
         var m:int = 0;
         var bl:Array = null;
         var bd:Array = null;
         var tl:Array = null;
         var td:Array = null;
         var h:Array = null;
         var i:int = 0;
         var j:int = 0;
         var c:int = 0;
         var nextByte:int = 0;
         p = z.next_in_index;
         n = z.avail_in;
         b = this.bitb;
         k = this.bitk;
         q = this.write;
         m = int(q < this.read ? this.read - q - 1 : this.end - q);
         loop0:
         while(true)
         {
            if(false)
            {
               r = Z_STREAM_ERROR;
               this.bitb = b;
               this.bitk = k;
               z.avail_in = n;
               z.total_in += p - z.next_in_index;
               z.next_in_index = p;
               this.write = q;
               return this.inflate_flush(z,r);
            }
            switch(this.mode)
            {
               case TYPE:
                  while(k < 3)
                  {
                     if(n == 0)
                     {
                        this.bitb = b;
                        this.bitk = k;
                        z.avail_in = n;
                        z.total_in += p - z.next_in_index;
                        z.next_in_index = p;
                        this.write = q;
                        return this.inflate_flush(z,r);
                     }
                     r = Z_OK;
                     n--;
                     z.next_in.position = p++;
                     nextByte = Cast.toByte(z.next_in.readByte());
                     b |= (nextByte & 0xFF) << k;
                     k += 8;
                  }
                  t = int(b & 7);
                  this.last = t & 1;
                  switch(t >>> 1)
                  {
                     case 0:
                        b >>>= 3;
                        k -= 3;
                        t = k & 7;
                        b >>>= t;
                        k -= t;
                        this.mode = LENS;
                        break;
                     case 1:
                        bl = new Array(1);
                        bd = new Array(1);
                        tl = new Array();
                        tl[0] = new Array();
                        td = new Array();
                        td[0] = new Array();
                        InfTree.inflate_trees_fixed(bl,bd,tl,td,z);
                        this.codes.init(bl[0],bd[0],tl[0],0,td[0],0,z);
                        b >>>= 3;
                        k -= 3;
                        this.mode = CODES;
                        break;
                     case 2:
                        b >>>= 3;
                        k -= 3;
                        this.mode = TABLE;
                        break;
                     case 3:
                        b >>>= 3;
                        k -= 3;
                        this.mode = BAD;
                        z.msg = "invalid block type";
                        r = Z_DATA_ERROR;
                        this.bitb = b;
                        this.bitk = k;
                        z.avail_in = n;
                        z.total_in += p - z.next_in_index;
                        z.next_in_index = p;
                        this.write = q;
                        return this.inflate_flush(z,r);
                  }
                  break;
               case LENS:
                  while(k < 32)
                  {
                     if(n == 0)
                     {
                        this.bitb = b;
                        this.bitk = k;
                        z.avail_in = n;
                        z.total_in += p - z.next_in_index;
                        z.next_in_index = p;
                        this.write = q;
                        return this.inflate_flush(z,r);
                     }
                     r = Z_OK;
                     n--;
                     b |= (z.next_in[p++] & 0xFF) << k;
                     k += 8;
                  }
                  if((~b >>> 16 & 0xFFFF) != (b & 0xFFFF))
                  {
                     this.mode = BAD;
                     z.msg = "invalid stored block lengths";
                     r = Z_DATA_ERROR;
                     this.bitb = b;
                     this.bitk = k;
                     z.avail_in = n;
                     z.total_in += p - z.next_in_index;
                     z.next_in_index = p;
                     this.write = q;
                     return this.inflate_flush(z,r);
                  }
                  this.left = b & 0xFFFF;
                  b = k = 0;
                  this.mode = this.left != 0 ? STORED : (this.last != 0 ? DRY : TYPE);
                  break;
               case STORED:
                  if(n == 0)
                  {
                     this.bitb = b;
                     this.bitk = k;
                     z.avail_in = n;
                     z.total_in += p - z.next_in_index;
                     z.next_in_index = p;
                     this.write = q;
                     return this.inflate_flush(z,r);
                  }
                  if(m == 0)
                  {
                     if(q == this.end && this.read != 0)
                     {
                        q = 0;
                        m = int(q < this.read ? this.read - q - 1 : this.end - q);
                     }
                     if(m == 0)
                     {
                        this.write = q;
                        r = this.inflate_flush(z,r);
                        q = this.write;
                        m = int(q < this.read ? this.read - q - 1 : this.end - q);
                        if(q == this.end && this.read != 0)
                        {
                           q = 0;
                           m = int(q < this.read ? this.read - q - 1 : this.end - q);
                        }
                        if(m == 0)
                        {
                           this.bitb = b;
                           this.bitk = k;
                           z.avail_in = n;
                           z.total_in += p - z.next_in_index;
                           z.next_in_index = p;
                           this.write = q;
                           return this.inflate_flush(z,r);
                        }
                     }
                  }
                  r = Z_OK;
                  t = this.left;
                  if(t > n)
                  {
                     t = n;
                  }
                  if(t > m)
                  {
                     t = m;
                  }
                  System.byteArrayCopy(z.next_in,p,this.window,q,t);
                  p += t;
                  n -= t;
                  q += t;
                  m -= t;
                  if((this.left = this.left - t) == 0)
                  {
                     this.mode = this.last != 0 ? DRY : TYPE;
                  }
                  break;
               case TABLE:
                  while(k < 14)
                  {
                     if(n == 0)
                     {
                        this.bitb = b;
                        this.bitk = k;
                        z.avail_in = n;
                        z.total_in += p - z.next_in_index;
                        z.next_in_index = p;
                        this.write = q;
                        return this.inflate_flush(z,r);
                     }
                     r = Z_OK;
                     n--;
                     b |= (z.next_in[p++] & 0xFF) << k;
                     k += 8;
                  }
                  this.table = t = b & 0x3FFF;
                  if((t & 0x1F) > 29 || (t >> 5 & 0x1F) > 29)
                  {
                     this.mode = BAD;
                     z.msg = "too many length or distance symbols";
                     r = Z_DATA_ERROR;
                     this.bitb = b;
                     this.bitk = k;
                     z.avail_in = n;
                     z.total_in += p - z.next_in_index;
                     z.next_in_index = p;
                     this.write = q;
                     return this.inflate_flush(z,r);
                  }
                  t = 258 + (t & 0x1F) + (t >> 5 & 0x1F);
                  if(this.blens == null || this.blens.length < t)
                  {
                     this.blens = new Array();
                  }
                  else
                  {
                     for(i = 0; i < t; i++)
                     {
                        this.blens[i] = 0;
                     }
                  }
                  b >>>= 14;
                  k -= 14;
                  this.index = 0;
                  this.mode = BTREE;
               case BTREE:
                  while(this.index < 4 + (this.table >>> 10))
                  {
                     while(k < 3)
                     {
                        if(n == 0)
                        {
                           this.bitb = b;
                           this.bitk = k;
                           z.avail_in = n;
                           z.total_in += p - z.next_in_index;
                           z.next_in_index = p;
                           this.write = q;
                           return this.inflate_flush(z,r);
                        }
                        r = Z_OK;
                        n--;
                        b |= (z.next_in[p++] & 0xFF) << k;
                        k += 8;
                     }
                     this.blens[border[this.index++]] = b & 7;
                     b >>>= 3;
                     k -= 3;
                  }
                  while(this.index < 19)
                  {
                     this.blens[border[this.index++]] = 0;
                  }
                  this.bb[0] = 7;
                  t = this.inftree.inflate_trees_bits(this.blens,this.bb,this.tb,this.hufts,z);
                  if(t != Z_OK)
                  {
                     r = t;
                     if(r == Z_DATA_ERROR)
                     {
                        this.blens = null;
                        this.mode = BAD;
                     }
                     this.bitb = b;
                     this.bitk = k;
                     z.avail_in = n;
                     z.total_in += p - z.next_in_index;
                     z.next_in_index = p;
                     this.write = q;
                     return this.inflate_flush(z,r);
                  }
                  this.index = 0;
                  this.mode = DTREE;
               case DTREE:
                  while(true)
                  {
                     t = this.table;
                     if(this.index >= 258 + (t & 0x1F) + (t >> 5 & 0x1F))
                     {
                        break;
                     }
                     t = int(this.bb[0]);
                     while(k < t)
                     {
                        if(n == 0)
                        {
                           this.bitb = b;
                           this.bitk = k;
                           z.avail_in = n;
                           z.total_in += p - z.next_in_index;
                           z.next_in_index = p;
                           this.write = q;
                           return this.inflate_flush(z,r);
                        }
                        r = Z_OK;
                        n--;
                        b |= (z.next_in[p++] & 0xFF) << k;
                        k += 8;
                     }
                     if(this.tb[0] == -1)
                     {
                     }
                     t = int(this.hufts[(this.tb[0] + (b & inflate_mask[t])) * 3 + 1]);
                     c = int(this.hufts[(this.tb[0] + (b & inflate_mask[t])) * 3 + 2]);
                     if(c < 16)
                     {
                        b >>>= t;
                        k -= t;
                        this.blens[this.index++] = c;
                     }
                     else
                     {
                        i = c == 18 ? 7 : c - 14;
                        j = c == 18 ? 11 : 3;
                        while(k < t + i)
                        {
                           if(n == 0)
                           {
                              this.bitb = b;
                              this.bitk = k;
                              z.avail_in = n;
                              z.total_in += p - z.next_in_index;
                              z.next_in_index = p;
                              this.write = q;
                              return this.inflate_flush(z,r);
                           }
                           r = Z_OK;
                           n--;
                           b |= (z.next_in[p++] & 0xFF) << k;
                           k += 8;
                        }
                        b >>>= t;
                        k -= t;
                        j += b & inflate_mask[i];
                        b >>>= i;
                        k -= i;
                        i = this.index;
                        t = this.table;
                        if(i + j > 258 + (t & 0x1F) + (t >> 5 & 0x1F) || c == 16 && i < 1)
                        {
                           this.blens = null;
                           this.mode = BAD;
                           z.msg = "invalid bit length repeat";
                           r = Z_DATA_ERROR;
                           this.bitb = b;
                           this.bitk = k;
                           z.avail_in = n;
                           z.total_in += p - z.next_in_index;
                           z.next_in_index = p;
                           this.write = q;
                           return this.inflate_flush(z,r);
                        }
                        c = c == 16 ? int(this.blens[i - 1]) : 0;
                        do
                        {
                           this.blens[i++] = c;
                        }
                        while(--j != 0);
                        
                        this.index = i;
                     }
                  }
                  this.tb[0] = -1;
                  bl = new Array();
                  bd = new Array();
                  tl = new Array();
                  td = new Array();
                  bl[0] = 9;
                  bd[0] = 6;
                  t = this.table;
                  t = this.inftree.inflate_trees_dynamic(257 + (t & 0x1F),1 + (t >> 5 & 0x1F),this.blens,bl,bd,tl,td,this.hufts,z);
                  if(t != Z_OK)
                  {
                     break loop0;
                  }
                  this.codes.init(bl[0],bd[0],this.hufts,tl[0],this.hufts,td[0],z);
                  this.mode = CODES;
               case CODES:
                  this.bitb = b;
                  this.bitk = k;
                  z.avail_in = n;
                  z.total_in += p - z.next_in_index;
                  z.next_in_index = p;
                  this.write = q;
                  r = this.codes.proc(this,z,r);
                  if(r != Z_STREAM_END)
                  {
                     return this.inflate_flush(z,r);
                  }
                  r = Z_OK;
                  this.codes.free(z);
                  p = z.next_in_index;
                  n = z.avail_in;
                  b = this.bitb;
                  k = this.bitk;
                  q = this.write;
                  m = int(q < this.read ? this.read - q - 1 : this.end - q);
                  if(this.last == 0)
                  {
                     this.mode = TYPE;
                     continue;
                  }
                  this.mode = DRY;
               case DRY:
                  this.write = q;
                  r = this.inflate_flush(z,r);
                  q = this.write;
                  m = int(q < this.read ? this.read - q - 1 : this.end - q);
                  if(this.read != this.write)
                  {
                     this.bitb = b;
                     this.bitk = k;
                     z.avail_in = n;
                     z.total_in += p - z.next_in_index;
                     z.next_in_index = p;
                     this.write = q;
                     return this.inflate_flush(z,r);
                  }
                  this.mode = DONE;
               case DONE:
                  r = Z_STREAM_END;
                  this.bitb = b;
                  this.bitk = k;
                  z.avail_in = n;
                  break;
               case BAD:
                  r = Z_DATA_ERROR;
                  this.bitb = b;
                  this.bitk = k;
                  z.avail_in = n;
                  z.total_in += p - z.next_in_index;
                  z.next_in_index = p;
                  this.write = q;
                  return this.inflate_flush(z,r);
               default:
                  r = Z_STREAM_ERROR;
                  this.bitb = b;
                  this.bitk = k;
                  z.avail_in = n;
                  z.total_in += p - z.next_in_index;
                  z.next_in_index = p;
                  this.write = q;
                  return this.inflate_flush(z,r);
            }
            z.total_in += p - z.next_in_index;
            z.next_in_index = p;
            this.write = q;
            return this.inflate_flush(z,r);
         }
         if(t == Z_DATA_ERROR)
         {
            this.blens = null;
            this.mode = BAD;
         }
         r = t;
         this.bitb = b;
         this.bitk = k;
         z.avail_in = n;
         z.total_in += p - z.next_in_index;
         z.next_in_index = p;
         this.write = q;
         return this.inflate_flush(z,r);
      }
      
      public function free(z:ZStream) : void
      {
         this.reset(z,null);
         this.window = null;
         this.hufts = null;
      }
      
      public function set_dictionary(d:ByteArray, start:int, n:int) : void
      {
         System.byteArrayCopy(d,start,this.window,0,n);
         this.read = this.write = n;
      }
      
      public function sync_point() : int
      {
         return this.mode == LENS ? 1 : 0;
      }
      
      public function inflate_flush(z:ZStream, r:int) : int
      {
         var n:int = 0;
         var p:int = 0;
         var q:int = 0;
         p = z.next_out_index;
         q = this.read;
         n = int((q <= this.write ? this.write : this.end) - q);
         if(n > z.avail_out)
         {
            n = z.avail_out;
         }
         if(n != 0 && r == Z_BUF_ERROR)
         {
            r = Z_OK;
         }
         z.avail_out -= n;
         z.total_out += n;
         if(this.checkfn != null)
         {
            z.adler = this.check = z._adler.adler32(this.check,this.window,q,n);
         }
         System.byteArrayCopy(this.window,q,z.next_out,p,n);
         p += n;
         q += n;
         if(q == this.end)
         {
            q = 0;
            if(this.write == this.end)
            {
               this.write = 0;
            }
            n = this.write - q;
            if(n > z.avail_out)
            {
               n = z.avail_out;
            }
            if(n != 0 && r == Z_BUF_ERROR)
            {
               r = Z_OK;
            }
            z.avail_out -= n;
            z.total_out += n;
            if(this.checkfn != null)
            {
               z.adler = this.check = z._adler.adler32(this.check,this.window,q,n);
            }
            System.byteArrayCopy(this.window,q,z.next_out,p,n);
            p += n;
            q += n;
         }
         z.next_out_index = p;
         this.read = q;
         return r;
      }
   }
}

