package org.zip.wirelust.as3zlib
{
   public final class InfCodes
   {
      
      private static const inflate_mask:Array = new Array(0,1,3,7,15,31,63,127,255,511,1023,2047,4095,8191,16383,32767,65535);
      
      private static const Z_OK:int = 0;
      
      private static const Z_STREAM_END:int = 1;
      
      private static const Z_NEED_DICT:int = 2;
      
      private static const Z_ERRNO:int = -1;
      
      private static const Z_STREAM_ERROR:int = -2;
      
      private static const Z_DATA_ERROR:int = -3;
      
      private static const Z_MEM_ERROR:int = -4;
      
      private static const Z_BUF_ERROR:int = -5;
      
      private static const Z_VERSION_ERROR:int = -6;
      
      private static const START:int = 0;
      
      private static const LEN:int = 1;
      
      private static const LENEXT:int = 2;
      
      private static const DIST:int = 3;
      
      private static const DISTEXT:int = 4;
      
      private static const COPY:int = 5;
      
      private static const LIT:int = 6;
      
      private static const WASH:int = 7;
      
      private static const END:int = 8;
      
      private static const BADCODE:int = 9;
      
      public var mode:int;
      
      public var len:int;
      
      public var tree:Array;
      
      public var tree_index:int = 0;
      
      public var need:int;
      
      public var lit:int;
      
      public var getBits:int;
      
      public var dist:int;
      
      public var lbits:uint;
      
      public var dbits:uint;
      
      public var ltree:Array;
      
      public var ltree_index:int;
      
      public var dtree:Array;
      
      public var dtree_index:int;
      
      public function InfCodes()
      {
         super();
      }
      
      public function init(bl:int, bd:int, tl:Array, tl_index:int, td:Array, td_index:int, z:ZStream) : void
      {
         this.mode = START;
         this.lbits = bl;
         this.dbits = bd;
         this.ltree = tl;
         this.ltree_index = tl_index;
         this.dtree = td;
         this.dtree_index = td_index;
         this.tree = null;
      }
      
      public function proc(s:InfBlocks, z:ZStream, r:int) : int
      {
         var j:int = 0;
         var t:Array = null;
         var tindex:int = 0;
         var e:int = 0;
         var p:int = 0;
         var n:int = 0;
         var q:int = 0;
         var m:int = 0;
         var f:int = 0;
         var b:int = 0;
         var k:int = 0;
         p = 0;
         p = z.next_in_index;
         n = z.avail_in;
         b = s.bitb;
         k = s.bitk;
         q = s.write;
         m = q < s.read ? s.read - q - 1 : s.end - q;
         while(true)
         {
            switch(this.mode)
            {
               case START:
                  if(m >= 258 && n >= 10)
                  {
                     s.bitb = b;
                     s.bitk = k;
                     z.avail_in = n;
                     z.total_in += p - z.next_in_index;
                     z.next_in_index = p;
                     s.write = q;
                     r = this.inflate_fast(this.lbits,this.dbits,this.ltree,this.ltree_index,this.dtree,this.dtree_index,s,z);
                     p = z.next_in_index;
                     n = z.avail_in;
                     b = s.bitb;
                     k = s.bitk;
                     q = s.write;
                     m = q < s.read ? s.read - q - 1 : s.end - q;
                     if(r != Z_OK)
                     {
                        this.mode = r == Z_STREAM_END ? WASH : BADCODE;
                        continue;
                     }
                  }
                  this.need = this.lbits;
                  this.tree = this.ltree;
                  this.tree_index = this.ltree_index;
                  this.mode = LEN;
               case LEN:
                  j = this.need;
                  while(k < j)
                  {
                     if(n == 0)
                     {
                        s.bitb = b;
                        s.bitk = k;
                        z.avail_in = n;
                        z.total_in += p - z.next_in_index;
                        z.next_in_index = p;
                        s.write = q;
                        return s.inflate_flush(z,r);
                     }
                     r = Z_OK;
                     n--;
                     b |= (z.next_in[p++] & 0xFF) << k;
                     k += 8;
                  }
                  tindex = (this.tree_index + (b & inflate_mask[j])) * 3;
                  b >>>= this.tree[tindex + 1];
                  k -= this.tree[tindex + 1];
                  e = int(this.tree[tindex]);
                  if(e == 0)
                  {
                     this.lit = this.tree[tindex + 2];
                     this.mode = LIT;
                  }
                  else if((e & 0x10) != 0)
                  {
                     this.getBits = e & 0x0F;
                     this.len = this.tree[tindex + 2];
                     this.mode = LENEXT;
                  }
                  else if((e & 0x40) == 0)
                  {
                     this.need = e;
                     this.tree_index = tindex / 3 + this.tree[tindex + 2];
                  }
                  else
                  {
                     if((e & 0x20) == 0)
                     {
                        this.mode = BADCODE;
                        z.msg = "invalid literal/length code";
                        r = Z_DATA_ERROR;
                        s.bitb = b;
                        s.bitk = k;
                        z.avail_in = n;
                        z.total_in += p - z.next_in_index;
                        z.next_in_index = p;
                        s.write = q;
                        return s.inflate_flush(z,r);
                     }
                     this.mode = WASH;
                  }
                  break;
               case LENEXT:
                  j = this.getBits;
                  while(k < j)
                  {
                     if(n == 0)
                     {
                        s.bitb = b;
                        s.bitk = k;
                        z.avail_in = n;
                        z.total_in += p - z.next_in_index;
                        z.next_in_index = p;
                        s.write = q;
                        return s.inflate_flush(z,r);
                     }
                     r = Z_OK;
                     n--;
                     b |= (z.next_in[p++] & 0xFF) << k;
                     k += 8;
                  }
                  this.len += b & inflate_mask[j];
                  b >>= j;
                  k -= j;
                  this.need = this.dbits;
                  this.tree = this.dtree;
                  this.tree_index = this.dtree_index;
                  this.mode = DIST;
               case DIST:
                  j = this.need;
                  while(k < j)
                  {
                     if(n == 0)
                     {
                        s.bitb = b;
                        s.bitk = k;
                        z.avail_in = n;
                        z.total_in += p - z.next_in_index;
                        z.next_in_index = p;
                        s.write = q;
                        return s.inflate_flush(z,r);
                     }
                     r = Z_OK;
                     n--;
                     b |= (z.next_in[p++] & 0xFF) << k;
                     k += 8;
                  }
                  tindex = (this.tree_index + (b & inflate_mask[j])) * 3;
                  b >>= this.tree[tindex + 1];
                  break;
               case DISTEXT:
                  j = this.getBits;
                  while(k < j)
                  {
                     if(n == 0)
                     {
                        s.bitb = b;
                        s.bitk = k;
                        z.avail_in = n;
                        z.total_in += p - z.next_in_index;
                        z.next_in_index = p;
                        s.write = q;
                        return s.inflate_flush(z,r);
                     }
                     r = Z_OK;
                     n--;
                     b |= (z.next_in[p++] & 0xFF) << k;
                     k += 8;
                  }
                  this.dist += b & inflate_mask[j];
                  b >>= j;
                  k -= j;
                  this.mode = COPY;
               case COPY:
                  f = q - this.dist;
                  while(f < 0)
                  {
                     f += s.end;
                  }
                  while(this.len != 0)
                  {
                     if(m == 0)
                     {
                        if(q == s.end && s.read != 0)
                        {
                           q = 0;
                           m = q < s.read ? s.read - q - 1 : s.end - q;
                        }
                        if(m == 0)
                        {
                           s.write = q;
                           r = s.inflate_flush(z,r);
                           q = s.write;
                           m = q < s.read ? s.read - q - 1 : s.end - q;
                           if(q == s.end && s.read != 0)
                           {
                              q = 0;
                              m = q < s.read ? s.read - q - 1 : s.end - q;
                           }
                           if(m == 0)
                           {
                              s.bitb = b;
                              s.bitk = k;
                              z.avail_in = n;
                              z.total_in += p - z.next_in_index;
                              z.next_in_index = p;
                              s.write = q;
                              return s.inflate_flush(z,r);
                           }
                        }
                     }
                     s.window[q++] = s.window[f++];
                     m--;
                     if(f == s.end)
                     {
                        f = 0;
                     }
                     --this.len;
                  }
                  this.mode = START;
                  break;
               case LIT:
                  if(m == 0)
                  {
                     if(q == s.end && s.read != 0)
                     {
                        q = 0;
                        m = q < s.read ? s.read - q - 1 : s.end - q;
                     }
                     if(m == 0)
                     {
                        s.write = q;
                        r = s.inflate_flush(z,r);
                        q = s.write;
                        m = q < s.read ? s.read - q - 1 : s.end - q;
                        if(q == s.end && s.read != 0)
                        {
                           q = 0;
                           m = q < s.read ? s.read - q - 1 : s.end - q;
                        }
                        if(m == 0)
                        {
                           s.bitb = b;
                           s.bitk = k;
                           z.avail_in = n;
                           z.total_in += p - z.next_in_index;
                           z.next_in_index = p;
                           s.write = q;
                           return s.inflate_flush(z,r);
                        }
                     }
                  }
                  r = Z_OK;
                  s.window[q++] = this.lit;
                  m--;
                  this.mode = START;
                  break;
               case WASH:
                  if(k > 7)
                  {
                     k -= 8;
                     n++;
                     p--;
                  }
                  s.write = q;
                  r = s.inflate_flush(z,r);
                  q = s.write;
                  m = q < s.read ? s.read - q - 1 : s.end - q;
                  if(s.read != s.write)
                  {
                     s.bitb = b;
                     s.bitk = k;
                     z.avail_in = n;
                     z.total_in += p - z.next_in_index;
                     z.next_in_index = p;
                     s.write = q;
                     return s.inflate_flush(z,r);
                  }
                  this.mode = END;
               case END:
                  r = Z_STREAM_END;
                  s.bitb = b;
                  s.bitk = k;
                  z.avail_in = n;
                  z.total_in += p - z.next_in_index;
                  z.next_in_index = p;
                  s.write = q;
                  return s.inflate_flush(z,r);
               case BADCODE:
                  r = Z_DATA_ERROR;
                  s.bitb = b;
                  s.bitk = k;
                  z.avail_in = n;
                  z.total_in += p - z.next_in_index;
                  z.next_in_index = p;
                  s.write = q;
                  return s.inflate_flush(z,r);
               default:
                  r = Z_STREAM_ERROR;
                  s.bitb = b;
                  s.bitk = k;
                  z.avail_in = n;
                  z.total_in += p - z.next_in_index;
                  z.next_in_index = p;
                  s.write = q;
                  return s.inflate_flush(z,r);
            }
            k -= this.tree[tindex + 1];
            e = int(this.tree[tindex]);
            if((e & 0x10) != 0)
            {
               this.getBits = e & 0x0F;
               this.dist = this.tree[tindex + 2];
               this.mode = DISTEXT;
            }
            else
            {
               if((e & 0x40) != 0)
               {
                  this.mode = BADCODE;
                  z.msg = "invalid distance code";
                  r = Z_DATA_ERROR;
                  s.bitb = b;
                  s.bitk = k;
                  z.avail_in = n;
                  z.total_in += p - z.next_in_index;
                  z.next_in_index = p;
                  s.write = q;
                  return s.inflate_flush(z,r);
               }
               this.need = e;
               this.tree_index = tindex / 3 + this.tree[tindex + 2];
            }
         }
         r = Z_STREAM_ERROR;
         s.bitb = b;
         s.bitk = k;
         z.avail_in = n;
         z.total_in += p - z.next_in_index;
         z.next_in_index = p;
         s.write = q;
         return s.inflate_flush(z,r);
      }
      
      public function free(z:ZStream) : void
      {
      }
      
      public function inflate_fast(bl:uint, bd:uint, tl:Array, tl_index:uint, td:Array, td_index:uint, s:InfBlocks, z:ZStream) : int
      {
         var t:int = 0;
         var tp:Array = null;
         var tp_index:int = 0;
         var e:int = 0;
         var b:int = 0;
         var k:int = 0;
         var p:int = 0;
         var n:int = 0;
         var q:int = 0;
         var m:int = 0;
         var ml:int = 0;
         var md:int = 0;
         var c:int = 0;
         var d:int = 0;
         var r:int = 0;
         var tp_index_t_3:int = 0;
         p = z.next_in_index;
         n = z.avail_in;
         b = s.bitb;
         k = s.bitk;
         q = s.write;
         m = q < s.read ? s.read - q - 1 : s.end - q;
         ml = int(inflate_mask[bl]);
         md = int(inflate_mask[bd]);
         loop0:
         while(true)
         {
            while(k < 20)
            {
               n--;
               b |= (z.next_in[p++] & 0xFF) << k;
               k += 8;
            }
            t = b & ml;
            tp = tl;
            tp_index = int(tl_index);
            tp_index_t_3 = (tp_index + t) * 3;
            e = int(tp[tp_index_t_3]);
            if(e == 0)
            {
               b >>= tp[tp_index_t_3 + 1];
               k -= tp[tp_index_t_3 + 1];
               s.window[q++] = tp[tp_index_t_3 + 2];
               m--;
            }
            else
            {
               do
               {
                  b >>= tp[tp_index_t_3 + 1];
                  k -= tp[tp_index_t_3 + 1];
                  if((e & 0x10) != 0)
                  {
                     e &= 15;
                     c = tp[tp_index_t_3 + 2] + (int(b) & inflate_mask[e]);
                     b >>= e;
                     k -= e;
                     while(k < 15)
                     {
                        n--;
                        b |= (z.next_in[p++] & 0xFF) << k;
                        k += 8;
                     }
                     t = b & md;
                     tp = td;
                     tp_index = int(td_index);
                     tp_index_t_3 = (tp_index + t) * 3;
                     e = int(tp[tp_index_t_3]);
                     do
                     {
                        b >>= tp[tp_index_t_3 + 1];
                        k -= tp[tp_index_t_3 + 1];
                        if((e & 0x10) != 0)
                        {
                           e &= 15;
                           while(k < e)
                           {
                              n--;
                              b |= (z.next_in[p++] & 0xFF) << k;
                              k += 8;
                           }
                           d = tp[tp_index_t_3 + 2] + (b & inflate_mask[e]);
                           b >>= e;
                           k -= e;
                           m -= c;
                           if(q >= d)
                           {
                              r = q - d;
                              if(q - r > 0 && 2 > q - r)
                              {
                                 s.window[q++] = s.window[r++];
                                 s.window[q++] = s.window[r++];
                                 c -= 2;
                              }
                              else
                              {
                                 System.byteArrayCopy(s.window,r,s.window,q,2);
                                 q += 2;
                                 r += 2;
                                 c -= 2;
                              }
                           }
                           else
                           {
                              r = q - d;
                              do
                              {
                                 r += s.end;
                              }
                              while(r < 0);
                              
                              e = s.end - r;
                              if(c > e)
                              {
                                 c -= e;
                                 if(q - r > 0 && e > q - r)
                                 {
                                    do
                                    {
                                       s.window[q++] = s.window[r++];
                                    }
                                    while(--e != 0);
                                    
                                 }
                                 else
                                 {
                                    System.byteArrayCopy(s.window,r,s.window,q,e);
                                    q += e;
                                    r += e;
                                    e = 0;
                                 }
                                 r = 0;
                              }
                           }
                           if(q - r > 0 && c > q - r)
                           {
                              do
                              {
                                 s.window[q++] = s.window[r++];
                              }
                              while(--c != 0);
                              
                           }
                           else
                           {
                              System.byteArrayCopy(s.window,r,s.window,q,c);
                              q += c;
                              r += c;
                              c = 0;
                           }
                           break;
                        }
                        if((e & 0x40) != 0)
                        {
                           z.msg = "invalid distance code";
                           c = z.avail_in - n;
                           c = k >> 3 < c ? k >> 3 : c;
                           n += c;
                           p -= c;
                           k -= c << 3;
                           s.bitb = b;
                           s.bitk = k;
                           z.avail_in = n;
                           z.total_in += p - z.next_in_index;
                           z.next_in_index = p;
                           s.write = q;
                           return Z_DATA_ERROR;
                        }
                        t += tp[tp_index_t_3 + 2];
                        t += b & inflate_mask[e];
                        tp_index_t_3 = (tp_index + t) * 3;
                        e = int(tp[tp_index_t_3]);
                     }
                     while(true);
                     
                     break;
                  }
                  if((e & 0x40) != 0)
                  {
                     break loop0;
                  }
                  t += tp[tp_index_t_3 + 2];
                  t += b & inflate_mask[e];
                  tp_index_t_3 = (tp_index + t) * 3;
                  e = int(tp[tp_index_t_3]);
                  if(e == 0)
                  {
                     b >>= tp[tp_index_t_3 + 1];
                     k -= tp[tp_index_t_3 + 1];
                     s.window[q++] = tp[tp_index_t_3 + 2];
                     m--;
                     break;
                  }
               }
               while(true);
               
            }
            if(!(m >= 258 && n >= 10))
            {
               c = z.avail_in - n;
               c = k >> 3 < c ? k >> 3 : c;
               n += c;
               p -= c;
               k -= c << 3;
               s.bitb = b;
               s.bitk = k;
               z.avail_in = n;
               z.total_in += p - z.next_in_index;
               z.next_in_index = p;
               s.write = q;
               return Z_OK;
            }
         }
         if((e & 0x20) != 0)
         {
            c = z.avail_in - n;
            c = k >> 3 < c ? k >> 3 : c;
            n += c;
            p -= c;
            k -= c << 3;
            s.bitb = b;
            s.bitk = k;
            z.avail_in = n;
            z.total_in += p - z.next_in_index;
            z.next_in_index = p;
            s.write = q;
            return Z_STREAM_END;
         }
         z.msg = "invalid literal/length code";
         c = z.avail_in - n;
         c = k >> 3 < c ? k >> 3 : c;
         n += c;
         p -= c;
         k -= c << 3;
         s.bitb = b;
         s.bitk = k;
         z.avail_in = n;
         z.total_in += p - z.next_in_index;
         z.next_in_index = p;
         s.write = q;
         return Z_DATA_ERROR;
      }
   }
}

