package org.zip.wirelust.as3zlib
{
   import org.zip.util.Cast;
   
   public final class Tree
   {
      
      private static const MAX_BITS:int = 15;
      
      private static const BL_CODES:int = 19;
      
      private static const D_CODES:int = 30;
      
      private static const LITERALS:int = 256;
      
      private static const LENGTH_CODES:int = 29;
      
      private static const L_CODES:int = LITERALS + 1 + LENGTH_CODES;
      
      private static const HEAP_SIZE:int = 2 * L_CODES + 1;
      
      public static const MAX_BL_BITS:int = 7;
      
      public static const END_BLOCK:int = 256;
      
      public static const REP_3_6:int = 16;
      
      public static const REPZ_3_10:int = 17;
      
      public static const REPZ_11_138:int = 18;
      
      public static const extra_lbits:Array = new Array(0,0,0,0,0,0,0,0,1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5,0);
      
      public static const extra_dbits:Array = new Array(0,0,0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9,10,10,11,11,12,12,13,13);
      
      public static const extra_blbits:Array = new Array(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,3,7);
      
      public static const bl_order:Array = new Array(16,17,18,0,8,7,9,6,10,5,11,4,12,3,13,2,14,1,15);
      
      public static const Buf_size:int = 8 * 2;
      
      public static const DIST_CODE_LEN:int = 512;
      
      public static const _dist_code:Array = new Array(0,1,2,3,4,4,5,5,6,6,6,6,7,7,7,7,8,8,8,8,8,8,8,8,9,9,9,9,9,9,9,9,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0,0,16,17,18,18,19,19,20,20,20,20,21,21,21,21,22,22,22,22,22,22,22,22,23,23,23,23,23,23,23,23,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,26,26,26,26,26,26,26,26,26
      ,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29);
      
      public static const _length_code:Array = new Array(0,1,2,3,4,5,6,7,8,8,9,9,10,10,11,11,12,12,12,12,13,13,13,13,14,14,14,14,15,15,15,15,16,16,16,16,16,16,16,16,17,17,17,17,17,17,17,17,18,18,18,18,18,18,18,18,19,19,19,19,19,19,19,19,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,22,22,22,22,22,22,22,22,22,22,22,22,22,22,22,22,23,23,23,23,23,23,23,23,23,23,23,23,23,23,23,23,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,28);
      
      public static const base_length:Array = new Array(0,1,2,3,4,5,6,7,8,10,12,14,16,20,24,28,32,40,48,56,64,80,96,112,128,160,192,224,0);
      
      public static const base_dist:Array = new Array(0,1,2,3,4,6,8,12,16,24,32,48,64,96,128,192,256,384,512,768,1024,1536,2048,3072,4096,6144,8192,12288,16384,24576);
      
      public var dyn_tree:Array;
      
      public var max_code:int;
      
      public var stat_desc:StaticTree;
      
      public function Tree()
      {
         super();
      }
      
      public static function d_code(dist:int) : int
      {
         return dist < 256 ? int(_dist_code[dist]) : int(_dist_code[256 + (dist >>> 7)]);
      }
      
      public static function gen_codes(tree:Array, max_code:int, bl_count:Array) : void
      {
         var bits:int = 0;
         var n:int = 0;
         var len:int = 0;
         var next_code:Array = new Array();
         var code:Number = 0;
         for(bits = 1; bits <= MAX_BITS; bits++)
         {
            next_code[bits] = code = code + bl_count[bits - 1] << 1;
         }
         for(n = 0; n <= max_code; n++)
         {
            len = int(tree[n * 2 + 1]);
            if(len != 0)
            {
               tree[n * 2] = bi_reverse(int(next_code[len]++),len);
            }
         }
      }
      
      public static function bi_reverse(code:int, len:int) : int
      {
         var res:int = 0;
         do
         {
            res |= code & 1;
            code >>>= 1;
            res <<= 1;
         }
         while(--len > 0);
         
         return res >>> 1;
      }
      
      public function gen_bitlen(s:Deflate) : void
      {
         var h:int = 0;
         var n:int = 0;
         var m:int = 0;
         var bits:int = 0;
         var xbits:int = 0;
         var f:Number = NaN;
         var tree:Array = this.dyn_tree;
         var stree:Array = this.stat_desc.static_tree;
         var extra:Array = this.stat_desc.extra_bits;
         var base:int = int(this.stat_desc.extra_base);
         var max_length:int = int(this.stat_desc.max_length);
         var overflow:int = 0;
         bits = 0;
         while(bits <= MAX_BITS)
         {
            s.bl_count[bits] = 0;
            bits++;
         }
         tree[s.heap[s.heap_max] * 2 + 1] = 0;
         for(h = s.heap_max + 1; h < HEAP_SIZE; h++)
         {
            n = int(s.heap[h]);
            bits = tree[tree[n * 2 + 1] * 2 + 1] + 1;
            if(bits > max_length)
            {
               bits = max_length;
               overflow++;
            }
            tree[n * 2 + 1] = Cast.toShort(bits);
            if(n <= this.max_code)
            {
               ++s.bl_count[bits];
               xbits = 0;
               if(n >= base)
               {
                  xbits = int(extra[n - base]);
               }
               f = Number(tree[n * 2]);
               s.opt_len += f * (bits + xbits);
               if(stree != null)
               {
                  s.static_len += f * (stree[n * 2 + 1] + xbits);
               }
            }
         }
         if(overflow == 0)
         {
            return;
         }
         do
         {
            for(bits = max_length - 1; s.bl_count[bits] == 0; )
            {
               bits--;
            }
            --s.bl_count[bits];
            s.bl_count[bits + 1] += 2;
            --s.bl_count[max_length];
            overflow -= 2;
         }
         while(overflow > 0);
         
         for(bits = max_length; bits != 0; bits--)
         {
            n = int(s.bl_count[bits]);
            while(n != 0)
            {
               m = int(s.heap[--h]);
               if(m <= this.max_code)
               {
                  if(tree[m * 2 + 1] != bits)
                  {
                     s.opt_len += (bits - tree[m * 2 + 1]) * tree[m * 2];
                     tree[m * 2 + 1] = Cast.toShort(bits);
                  }
                  n--;
               }
            }
         }
      }
      
      public function build_tree(s:Deflate) : void
      {
         var n:int = 0;
         var m:int = 0;
         var node:int = 0;
         var tree:Array = this.dyn_tree;
         var stree:Array = this.stat_desc.static_tree;
         var elems:int = int(this.stat_desc.elems);
         var max_code:int = -1;
         s.heap_len = 0;
         s.heap_max = HEAP_SIZE;
         for(n = 0; n < elems; n++)
         {
            if(tree[n * 2] != 0)
            {
               s.heap[++s.heap_len] = max_code = n;
               s.depth[n] = 0;
            }
            else
            {
               tree[n * 2 + 1] = 0;
            }
         }
         while(s.heap_len < 2)
         {
            node = s.heap[++s.heap_len] = max_code < 2 ? ++max_code : 0;
            tree[node * 2] = 1;
            s.depth[node] = 0;
            --s.opt_len;
            if(stree != null)
            {
               s.static_len -= stree[node * 2 + 1];
            }
         }
         this.max_code = max_code;
         for(n = s.heap_len / 2; n >= 1; n--)
         {
            s.pqdownheap(tree,n);
         }
         node = elems;
         do
         {
            n = int(s.heap[1]);
            s.heap[1] = s.heap[s.heap_len--];
            s.pqdownheap(tree,1);
            m = int(s.heap[1]);
            s.heap[--s.heap_max] = n;
            s.heap[--s.heap_max] = m;
            tree[node * 2] = tree[n * 2] + tree[m * 2];
            s.depth[node] = Math.max(s.depth[n],s.depth[m]) + 1;
            tree[n * 2 + 1] = tree[m * 2 + 1] = node;
            s.heap[1] = node++;
            s.pqdownheap(tree,1);
         }
         while(s.heap_len >= 2);
         
         s.heap[--s.heap_max] = s.heap[1];
         this.gen_bitlen(s);
         gen_codes(tree,max_code,s.bl_count);
      }
   }
}

