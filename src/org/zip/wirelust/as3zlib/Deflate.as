package org.zip.wirelust.as3zlib
{
   import flash.utils.ByteArray;
   import org.zip.util.Cast;
   
   public class Deflate
   {
      
      private static var MAX_MEM_LEVEL:int = 9;
      
      private static var Z_DEFAULT_COMPRESSION:int = -1;
      
      private static var MAX_WBITS:int = 15;
      
      private static var DEF_MEM_LEVEL:int = 8;
      
      private static var STORED:int = 0;
      
      private static var FAST:int = 1;
      
      private static var SLOW:int = 2;
      
      private static var config_table:Array = new Array(new DeflateConfig(0,0,0,0,STORED),new DeflateConfig(4,4,8,4,FAST),new DeflateConfig(4,5,16,8,FAST),new DeflateConfig(4,6,32,32,FAST),new DeflateConfig(4,4,16,16,SLOW),new DeflateConfig(8,16,32,32,SLOW),new DeflateConfig(8,16,128,128,SLOW),new DeflateConfig(8,32,128,256,SLOW),new DeflateConfig(32,128,258,1024,SLOW),new DeflateConfig(32,258,258,4096,SLOW));
      
      private static var NeedMore:int = 0;
      
      private static var BlockDone:int = 1;
      
      private static const FinishStarted:int = 2;
      
      private static const FinishDone:int = 3;
      
      private static const PRESET_DICT:int = 32;
      
      private static const Z_FILTERED:int = 1;
      
      private static const Z_HUFFMAN_ONLY:int = 2;
      
      private static const Z_DEFAULT_STRATEGY:int = 0;
      
      private static const Z_NO_FLUSH:int = 0;
      
      private static const Z_PARTIAL_FLUSH:int = 1;
      
      private static const Z_SYNC_FLUSH:int = 2;
      
      private static const Z_FULL_FLUSH:int = 3;
      
      private static const Z_FINISH:int = 4;
      
      private static const Z_OK:int = 0;
      
      private static const Z_STREAM_END:int = 1;
      
      private static const Z_NEED_DICT:int = 2;
      
      private static const Z_ERRNO:int = -1;
      
      private static const Z_STREAM_ERROR:int = -2;
      
      private static const Z_DATA_ERROR:int = -3;
      
      private static const Z_MEM_ERROR:int = -4;
      
      private static const Z_BUF_ERROR:int = -5;
      
      private static const Z_VERSION_ERROR:int = -6;
      
      private static const INIT_STATE:int = 42;
      
      private static const BUSY_STATE:int = 113;
      
      private static const FINISH_STATE:int = 666;
      
      private static var Z_DEFLATED:int = 8;
      
      private static const STORED_BLOCK:int = 0;
      
      private static const STATIC_TREES:int = 1;
      
      private static const DYN_TREES:int = 2;
      
      private static const Z_BINARY:int = 0;
      
      private static const Z_ASCII:int = 1;
      
      private static const Z_UNKNOWN:int = 2;
      
      private static const Buf_size:int = 8 * 2;
      
      private static const REP_3_6:int = 16;
      
      private static const REPZ_3_10:int = 17;
      
      private static const REPZ_11_138:int = 18;
      
      private static const MIN_MATCH:int = 3;
      
      private static const MAX_MATCH:int = 258;
      
      private static const MIN_LOOKAHEAD:int = MAX_MATCH + MIN_MATCH + 1;
      
      private static const MAX_BITS:int = 15;
      
      private static const D_CODES:int = 30;
      
      private static const BL_CODES:int = 19;
      
      private static const LENGTH_CODES:int = 29;
      
      private static const LITERALS:int = 256;
      
      private static const L_CODES:int = LITERALS + 1 + LENGTH_CODES;
      
      private static const HEAP_SIZE:int = 2 * L_CODES + 1;
      
      private static const END_BLOCK:int = 256;
      
      private var z_errmsg:Array = new Array("need dictionary","stream end","","file error","stream error","data error","insufficient memory","buffer error","incompatible version","");
      
      public var strm:ZStream;
      
      public var status:int;
      
      public var pending_buf:ByteArray;
      
      public var pending_buf_size:int;
      
      public var pending_out:int;
      
      public var pending:int;
      
      public var noheader:int;
      
      public var data_type:uint;
      
      public var method:uint;
      
      public var last_flush:int;
      
      public var w_size:int;
      
      public var w_bits:int;
      
      public var w_mask:int;
      
      public var window:ByteArray;
      
      public var window_size:int;
      
      public var prev:Array;
      
      public var head:Array;
      
      public var ins_h:int;
      
      public var hash_size:int;
      
      public var hash_bits:int;
      
      public var hash_mask:int;
      
      public var hash_shift:int;
      
      public var block_start:int;
      
      public var match_length:int;
      
      public var prev_match:int;
      
      public var match_available:int;
      
      public var strstart:int;
      
      public var match_start:int;
      
      public var lookahead:int;
      
      public var prev_length:int;
      
      public var max_chain_length:int;
      
      public var max_lazy_match:int;
      
      public var level:int;
      
      public var strategy:int;
      
      public var good_match:int;
      
      public var nice_match:int;
      
      internal var dyn_ltree:Array;
      
      internal var dyn_dtree:Array;
      
      internal var bl_tree:Array;
      
      internal var l_desc:Tree = new Tree();
      
      internal var d_desc:Tree = new Tree();
      
      internal var bl_desc:Tree = new Tree();
      
      internal var bl_count:Array = new Array();
      
      internal var heap:Array = new Array();
      
      internal var heap_len:int;
      
      internal var heap_max:int;
      
      internal var depth:Array = new Array();
      
      internal var l_buf:int;
      
      internal var lit_bufsize:int;
      
      internal var last_lit:int;
      
      internal var d_buf:int;
      
      internal var opt_len:int;
      
      internal var static_len:int;
      
      internal var matches:int;
      
      internal var last_eob_len:int;
      
      internal var bi_buf:Number;
      
      internal var bi_valid:int;
      
      public function Deflate()
      {
         super();
         this.dyn_ltree = new Array();
         this.dyn_dtree = new Array();
         this.bl_tree = new Array();
      }
      
      internal static function smaller(tree:Array, n:int, m:int, depth:Array) : Boolean
      {
         var tn2:Number = Number(tree[n * 2]);
         var tm2:Number = Number(tree[m * 2]);
         return tn2 < tm2 || tn2 == tm2 && depth[n] <= depth[m];
      }
      
      internal function lm_init() : void
      {
         this.window_size = 2 * this.w_size;
         this.head[this.hash_size - 1] = 0;
         for(var i:int = 0; i < this.hash_size - 1; i++)
         {
            this.head[i] = 0;
         }
         this.max_lazy_match = Deflate.config_table[this.level].max_lazy;
         this.good_match = Deflate.config_table[this.level].good_length;
         this.nice_match = Deflate.config_table[this.level].nice_length;
         this.max_chain_length = Deflate.config_table[this.level].max_chain;
         this.strstart = 0;
         this.block_start = 0;
         this.lookahead = 0;
         this.match_length = this.prev_length = MIN_MATCH - 1;
         this.match_available = 0;
         this.ins_h = 0;
      }
      
      internal function tr_init() : void
      {
         this.l_desc.dyn_tree = this.dyn_ltree;
         this.l_desc.stat_desc = StaticTree.static_l_desc;
         this.d_desc.dyn_tree = this.dyn_dtree;
         this.d_desc.stat_desc = StaticTree.static_d_desc;
         this.bl_desc.dyn_tree = this.bl_tree;
         this.bl_desc.stat_desc = StaticTree.static_bl_desc;
         this.bi_buf = 0;
         this.bi_valid = 0;
         this.last_eob_len = 8;
         this.init_block();
      }
      
      internal function init_block() : void
      {
         var i:int = 0;
         i = 0;
         while(i < L_CODES)
         {
            this.dyn_ltree[i * 2] = 0;
            i++;
         }
         i = 0;
         while(i < D_CODES)
         {
            this.dyn_dtree[i * 2] = 0;
            i++;
         }
         i = 0;
         while(i < BL_CODES)
         {
            this.bl_tree[i * 2] = 0;
            i++;
         }
         this.dyn_ltree[END_BLOCK * 2] = 1;
         this.opt_len = this.static_len = 0;
         this.last_lit = this.matches = 0;
      }
      
      internal function pqdownheap(tree:Array, k:int) : void
      {
         var v:int = int(this.heap[k]);
         var j:int = k << 1;
         while(j <= this.heap_len)
         {
            if(j < this.heap_len && smaller(tree,this.heap[j + 1],this.heap[j],this.depth))
            {
               j++;
            }
            if(smaller(tree,v,this.heap[j],this.depth))
            {
               break;
            }
            this.heap[k] = this.heap[j];
            k = j;
            j <<= 1;
         }
         this.heap[k] = v;
      }
      
      internal function scan_tree(tree:Array, max_code:int) : void
      {
         var n:int = 0;
         var curlen:int = 0;
         var prevlen:int = -1;
         var nextlen:int = int(tree[0 * 2 + 1]);
         var count:int = 0;
         var max_count:int = 7;
         var min_count:int = 4;
         if(nextlen == 0)
         {
            max_count = 138;
            min_count = 3;
         }
         tree[(max_code + 1) * 2 + 1] = 65535;
         for(n = 0; n <= max_code; n++)
         {
            curlen = nextlen;
            nextlen = int(tree[(n + 1) * 2 + 1]);
            if(!(++count < max_count && curlen == nextlen))
            {
               if(count < min_count)
               {
                  this.bl_tree[curlen * 2] += count;
               }
               else if(curlen != 0)
               {
                  if(curlen != prevlen)
                  {
                     ++this.bl_tree[curlen * 2];
                  }
                  ++this.bl_tree[REP_3_6 * 2];
               }
               else if(count <= 10)
               {
                  ++this.bl_tree[REPZ_3_10 * 2];
               }
               else
               {
                  ++this.bl_tree[REPZ_11_138 * 2];
               }
               count = 0;
               prevlen = curlen;
               if(nextlen == 0)
               {
                  max_count = 138;
                  min_count = 3;
               }
               else if(curlen == nextlen)
               {
                  max_count = 6;
                  min_count = 3;
               }
               else
               {
                  max_count = 7;
                  min_count = 4;
               }
            }
         }
      }
      
      public function build_bl_tree() : int
      {
         var max_blindex:int = 0;
         this.scan_tree(this.dyn_ltree,this.l_desc.max_code);
         this.scan_tree(this.dyn_dtree,this.d_desc.max_code);
         this.bl_desc.build_tree(this);
         for(max_blindex = BL_CODES - 1; max_blindex >= 3; max_blindex--)
         {
            if(this.bl_tree[Tree.bl_order[max_blindex] * 2 + 1] != 0)
            {
               break;
            }
         }
         this.opt_len += 3 * (max_blindex + 1) + 5 + 5 + 4;
         return max_blindex;
      }
      
      public function send_all_trees(lcodes:int, dcodes:int, blcodes:int) : void
      {
         var rank:int = 0;
         this.send_bits(lcodes - 257,5);
         this.send_bits(dcodes - 1,5);
         this.send_bits(blcodes - 4,4);
         for(rank = 0; rank < blcodes; rank++)
         {
            this.send_bits(this.bl_tree[Tree.bl_order[rank] * 2 + 1],3);
         }
         this.send_tree(this.dyn_ltree,lcodes - 1);
         this.send_tree(this.dyn_dtree,dcodes - 1);
      }
      
      public function send_tree(tree:Array, max_code:int) : void
      {
         var n:int = 0;
         var curlen:int = 0;
         var prevlen:int = -1;
         var nextlen:int = int(tree[0 * 2 + 1]);
         var count:int = 0;
         var max_count:int = 7;
         var min_count:int = 4;
         if(nextlen == 0)
         {
            max_count = 138;
            min_count = 3;
         }
         for(n = 0; n <= max_code; n++)
         {
            curlen = nextlen;
            nextlen = int(tree[(n + 1) * 2 + 1]);
            if(!(++count < max_count && curlen == nextlen))
            {
               if(count < min_count)
               {
                  do
                  {
                     this.send_code(curlen,this.bl_tree);
                  }
                  while(--count != 0);
                  
               }
               else if(curlen != 0)
               {
                  if(curlen != prevlen)
                  {
                     this.send_code(curlen,this.bl_tree);
                     count--;
                  }
                  this.send_code(REP_3_6,this.bl_tree);
                  this.send_bits(count - 3,2);
               }
               else if(count <= 10)
               {
                  this.send_code(REPZ_3_10,this.bl_tree);
                  this.send_bits(count - 3,3);
               }
               else
               {
                  this.send_code(REPZ_11_138,this.bl_tree);
                  this.send_bits(count - 11,7);
               }
               count = 0;
               prevlen = curlen;
               if(nextlen == 0)
               {
                  max_count = 138;
                  min_count = 3;
               }
               else if(curlen == nextlen)
               {
                  max_count = 6;
                  min_count = 3;
               }
               else
               {
                  max_count = 7;
                  min_count = 4;
               }
            }
         }
      }
      
      final public function put_byte(p:ByteArray, start:int, len:int) : void
      {
         System.byteArrayCopy(p,start,this.pending_buf,this.pending,len);
         this.pending += len;
      }
      
      public function put_byte_withInt(c:int) : void
      {
         this.pending_buf.writeByte(c);
         ++this.pending;
      }
      
      public function put_short(w:int) : void
      {
         this.put_byte_withInt(w);
         this.put_byte_withInt(w >>> 8);
      }
      
      final public function putShortMSB(b:int) : void
      {
         this.put_byte_withInt(b >> 8);
         this.put_byte_withInt(b & 0xFF);
      }
      
      final public function send_code(c:int, tree:Array) : void
      {
         var c2:int = c * 2;
         this.send_bits(tree[c2] & 0xFFFF,tree[c2 + 1] & 0xFFFF);
      }
      
      public function send_bits(value:int, length:int) : void
      {
         var val:int = 0;
         var len:int = length;
         if(this.bi_valid > int(Buf_size) - len)
         {
            val = value;
            this.bi_buf |= val << this.bi_valid & 0xFFFF;
            this.put_short(this.bi_buf);
            this.bi_buf = val >>> Buf_size - this.bi_valid;
            this.bi_buf = Cast.toShort(val >>> Buf_size - this.bi_valid);
            this.bi_valid += len - Buf_size;
         }
         else
         {
            this.bi_buf |= value << this.bi_valid & 0xFFFF;
            this.bi_valid += len;
         }
      }
      
      public function _tr_align() : void
      {
         this.send_bits(STATIC_TREES << 1,3);
         this.send_code(END_BLOCK,StaticTree.static_ltree);
         this.bi_flush();
         if(1 + this.last_eob_len + 10 - this.bi_valid < 9)
         {
            this.send_bits(STATIC_TREES << 1,3);
            this.send_code(END_BLOCK,StaticTree.static_ltree);
            this.bi_flush();
         }
         this.last_eob_len = 7;
      }
      
      public function _tr_tally(dist:int, lc:int) : Boolean
      {
         var out_length:int = 0;
         var in_length:int = 0;
         var dcode:int = 0;
         this.pending_buf[this.d_buf + this.last_lit * 2] = Cast.toByte(dist >>> 8);
         this.pending_buf[this.d_buf + this.last_lit * 2 + 1] = Cast.toByte(dist);
         this.pending_buf[this.l_buf + this.last_lit] = lc;
         ++this.last_lit;
         if(dist == 0)
         {
            ++this.dyn_ltree[lc * 2];
         }
         else
         {
            ++this.matches;
            dist--;
            ++this.dyn_ltree[(Tree._length_code[lc] + LITERALS + 1) * 2];
            ++this.dyn_dtree[Tree.d_code(dist) * 2];
         }
         if((this.last_lit & 1) == 0 && this.level > 2)
         {
            out_length = this.last_lit * 8;
            in_length = this.strstart - this.block_start;
            for(dcode = 0; dcode < D_CODES; dcode++)
            {
               out_length += int(this.dyn_dtree[dcode * 2]) * (5 + Tree.extra_dbits[dcode]);
            }
            out_length >>>= 3;
            if(this.matches < this.last_lit / 2 && out_length < in_length / 2)
            {
               return true;
            }
         }
         return this.last_lit == this.lit_bufsize - 1;
      }
      
      public function compress_block(ltree:Array, dtree:Array) : void
      {
         var dist:int = 0;
         var lc:int = 0;
         var code:int = 0;
         var extra:int = 0;
         var lx:int = 0;
         if(this.last_lit != 0)
         {
            do
            {
               dist = this.pending_buf[this.d_buf + lx * 2] << 8 & 0xFF00 | this.pending_buf[this.d_buf + lx * 2 + 1] & 0xFF;
               lc = this.pending_buf[this.l_buf + lx] & 0xFF;
               lx++;
               if(dist == 0)
               {
                  this.send_code(lc,ltree);
               }
               else
               {
                  code = int(Tree._length_code[lc]);
                  this.send_code(code + LITERALS + 1,ltree);
                  extra = int(Tree.extra_lbits[code]);
                  if(extra != 0)
                  {
                     lc -= Tree.base_length[code];
                     this.send_bits(lc,extra);
                  }
                  dist--;
                  code = Tree.d_code(dist);
                  this.send_code(code,dtree);
                  extra = int(Tree.extra_dbits[code]);
                  if(extra != 0)
                  {
                     dist -= Tree.base_dist[code];
                     this.send_bits(dist,extra);
                  }
               }
            }
            while(lx < this.last_lit);
            
         }
         this.send_code(END_BLOCK,ltree);
         this.last_eob_len = ltree[END_BLOCK * 2 + 1];
      }
      
      internal function set_data_type() : void
      {
         var n:int = 0;
         var ascii_freq:int = 0;
         var bin_freq:int = 0;
         while(n < 7)
         {
            bin_freq += this.dyn_ltree[n * 2];
            n++;
         }
         while(n < 128)
         {
            ascii_freq += this.dyn_ltree[n * 2];
            n++;
         }
         while(n < LITERALS)
         {
            bin_freq += this.dyn_ltree[n * 2];
            n++;
         }
         this.data_type = bin_freq > ascii_freq >>> 2 ? uint(Z_BINARY) : uint(Z_ASCII);
      }
      
      public function bi_flush() : void
      {
         if(this.bi_valid == 16)
         {
            this.put_short(this.bi_buf);
            this.bi_buf = 0;
            this.bi_valid = 0;
         }
         else if(this.bi_valid >= 8)
         {
            this.put_byte_withInt(this.bi_buf);
            this.bi_buf >>>= 8;
            this.bi_valid -= 8;
         }
      }
      
      public function bi_windup() : void
      {
         if(this.bi_valid > 8)
         {
            this.put_short(this.bi_buf);
         }
         else if(this.bi_valid > 0)
         {
            this.put_byte_withInt(this.bi_buf);
         }
         this.bi_buf = 0;
         this.bi_valid = 0;
      }
      
      internal function copy_block(buf:int, len:int, header:Boolean) : void
      {
         var index:int = 0;
         this.bi_windup();
         this.last_eob_len = 8;
         if(header)
         {
            this.put_short(len);
            this.put_short(~len & 0xFFFF);
         }
         this.put_byte(this.window,buf,len);
      }
      
      internal function flush_block_only(eof:Boolean) : void
      {
         this._tr_flush_block(this.block_start >= 0 ? this.block_start : -1,this.strstart - this.block_start,eof);
         this.block_start = this.strstart;
         this.strm.flush_pending();
      }
      
      public function deflate_stored(flush:int) : int
      {
         var max_start:int = 0;
         var max_block_size:int = 0;
         if(max_block_size > this.pending_buf_size - 5)
         {
            max_block_size = this.pending_buf_size - 5;
         }
         while(true)
         {
            if(this.lookahead <= 1)
            {
               this.fill_window();
               if(this.lookahead == 0 && flush == Z_NO_FLUSH)
               {
                  return NeedMore;
               }
               if(this.lookahead == 0)
               {
                  break;
               }
            }
            this.strstart += this.lookahead;
            this.lookahead = 0;
            max_start = this.block_start + max_block_size;
            if(this.strstart == 0 || this.strstart >= max_start)
            {
               this.lookahead = int(this.strstart - max_start);
               this.strstart = int(max_start);
               this.flush_block_only(false);
               if(this.strm.avail_out == 0)
               {
                  return NeedMore;
               }
            }
            if(this.strstart - this.block_start >= this.w_size - MIN_LOOKAHEAD)
            {
               this.flush_block_only(false);
               if(this.strm.avail_out == 0)
               {
                  return NeedMore;
               }
            }
         }
         this.flush_block_only(flush == Z_FINISH);
         if(this.strm.avail_out == 0)
         {
            return flush == Z_FINISH ? FinishStarted : NeedMore;
         }
         return flush == Z_FINISH ? FinishDone : BlockDone;
      }
      
      public function _tr_stored_block(buf:int, stored_len:int, eof:Boolean) : void
      {
         this.send_bits((STORED_BLOCK << 1) + (eof ? 1 : 0),3);
         this.copy_block(buf,stored_len,true);
      }
      
      internal function _tr_flush_block(buf:int, stored_len:int, eof:Boolean) : void
      {
         var opt_lenb:int = 0;
         var static_lenb:int = 0;
         var max_blindex:int = 0;
         if(this.level > 0)
         {
            if(this.data_type == Z_UNKNOWN)
            {
               this.set_data_type();
            }
            this.l_desc.build_tree(this);
            this.d_desc.build_tree(this);
            max_blindex = this.build_bl_tree();
            opt_lenb = this.opt_len + 3 + 7 >>> 3;
            static_lenb = this.static_len + 3 + 7 >>> 3;
            if(static_lenb <= opt_lenb)
            {
               opt_lenb = static_lenb;
            }
         }
         else
         {
            opt_lenb = static_lenb = stored_len + 5;
         }
         if(stored_len + 4 <= opt_lenb && buf != -1)
         {
            this._tr_stored_block(buf,stored_len,eof);
         }
         else if(static_lenb == opt_lenb)
         {
            this.send_bits((STATIC_TREES << 1) + (eof ? 1 : 0),3);
            this.compress_block(StaticTree.static_ltree,StaticTree.static_dtree);
         }
         else
         {
            this.send_bits((DYN_TREES << 1) + (eof ? 1 : 0),3);
            this.send_all_trees(this.l_desc.max_code + 1,this.d_desc.max_code + 1,max_blindex + 1);
            this.compress_block(this.dyn_ltree,this.dyn_dtree);
         }
         this.init_block();
         if(eof)
         {
            this.bi_windup();
         }
      }
      
      internal function fill_window() : void
      {
         var n:int = 0;
         var m:int = 0;
         var p:int = 0;
         var more:int = 0;
         while(true)
         {
            more = this.window_size - this.lookahead - this.strstart;
            if(more == 0 && this.strstart == 0 && this.lookahead == 0)
            {
               more = this.w_size;
            }
            else if(more == -1)
            {
               more--;
            }
            else if(this.strstart >= this.w_size + this.w_size - MIN_LOOKAHEAD)
            {
               System.byteArrayCopy(this.window,this.w_size,this.window,0,this.w_size);
               this.match_start -= this.w_size;
               this.strstart -= this.w_size;
               this.block_start -= this.w_size;
               n = this.hash_size;
               p = n;
               do
               {
                  m = this.head[--p] & 0xFFFF;
                  this.head[p] = m >= this.w_size ? Cast.toShort(m - this.w_size) : 0;
               }
               while(--n != 0);
               
               n = this.w_size;
               p = n;
               do
               {
                  m = this.prev[--p] & 0xFFFF;
                  this.prev[p] = m >= this.w_size ? Cast.toShort(m - this.w_size) : 0;
               }
               while(--n != 0);
               
               more += this.w_size;
            }
            if(this.strm.avail_in == 0)
            {
               break;
            }
            n = this.strm.read_buf(this.window,this.strstart + this.lookahead,more);
            this.lookahead += n;
            if(this.lookahead >= MIN_MATCH)
            {
               this.ins_h = this.window[this.strstart] & 0xFF;
               this.ins_h = (this.ins_h << this.hash_shift ^ this.window[this.strstart + 1] & 0xFF) & this.hash_mask;
            }
            if(!(this.lookahead < MIN_LOOKAHEAD && this.strm.avail_in != 0))
            {
               return;
            }
         }
      }
      
      public function deflate_fast(flush:int) : int
      {
         var bflush:Boolean = false;
         var hash_head:int = 0;
         while(true)
         {
            if(this.lookahead < MIN_LOOKAHEAD)
            {
               this.fill_window();
               if(this.lookahead < MIN_LOOKAHEAD && flush == Z_NO_FLUSH)
               {
                  return NeedMore;
               }
               if(this.lookahead == 0)
               {
                  break;
               }
            }
            if(this.lookahead >= MIN_MATCH)
            {
               this.ins_h = (this.ins_h << this.hash_shift ^ this.window[this.strstart + (MIN_MATCH - 1)] & 0xFF) & this.hash_mask;
               hash_head = int(this.head[this.ins_h]);
               this.prev[this.strstart & this.w_mask] = this.head[this.ins_h];
               this.head[this.ins_h] = Cast.toShort(this.strstart);
            }
            if(hash_head != 0 && this.strstart - hash_head <= this.w_size - MIN_LOOKAHEAD)
            {
               if(this.strategy != Z_HUFFMAN_ONLY)
               {
                  this.match_length = this.longest_match(hash_head);
               }
            }
            if(this.match_length >= MIN_MATCH)
            {
               bflush = this._tr_tally(this.strstart - this.match_start,this.match_length - MIN_MATCH);
               this.lookahead -= this.match_length;
               if(this.match_length <= this.max_lazy_match && this.lookahead >= MIN_MATCH)
               {
                  --this.match_length;
                  do
                  {
                     ++this.strstart;
                     this.ins_h = (this.ins_h << this.hash_shift ^ this.window[this.strstart + (MIN_MATCH - 1)] & 0xFF) & this.hash_mask;
                     hash_head = this.head[this.ins_h] & 0xFFFF;
                     this.prev[this.strstart & this.w_mask] = this.head[this.ins_h];
                     this.head[this.ins_h] = Cast.toShort(this.strstart);
                  }
                  while(--this.match_length != 0);
                  
                  ++this.strstart;
               }
               else
               {
                  this.strstart += this.match_length;
                  this.match_length = 0;
                  this.ins_h = this.window[this.strstart];
                  this.ins_h = (this.ins_h << this.hash_shift ^ this.window[this.strstart + 1] & 0xFF) & this.hash_mask;
               }
            }
            else
            {
               bflush = this._tr_tally(0,this.window[this.strstart] & 0xFF);
               --this.lookahead;
               ++this.strstart;
            }
            if(bflush)
            {
               this.flush_block_only(false);
               if(this.strm.avail_out == 0)
               {
                  return NeedMore;
               }
            }
         }
         this.flush_block_only(flush == Z_FINISH);
         if(this.strm.avail_out == 0)
         {
            if(flush == Z_FINISH)
            {
               return FinishStarted;
            }
            return NeedMore;
         }
         return flush == Z_FINISH ? FinishDone : BlockDone;
      }
      
      public function deflate_slow(flush:int) : int
      {
         var bflush:Boolean = false;
         var max_insert:int = 0;
         var hash_head:int = 0;
         while(true)
         {
            if(this.lookahead < MIN_LOOKAHEAD)
            {
               this.fill_window();
               if(this.lookahead < MIN_LOOKAHEAD && flush == Z_NO_FLUSH)
               {
                  return NeedMore;
               }
               if(this.lookahead == 0)
               {
                  break;
               }
            }
            if(this.lookahead >= MIN_MATCH)
            {
               this.ins_h = (this.ins_h << this.hash_shift ^ this.window[this.strstart + (MIN_MATCH - 1)] & 0xFF) & this.hash_mask;
               hash_head = this.head[this.ins_h] & 0xFFFF;
               this.prev[this.strstart & this.w_mask] = this.head[this.ins_h];
               this.head[this.ins_h] = Cast.toShort(this.strstart);
            }
            this.prev_length = this.match_length;
            this.prev_match = this.match_start;
            this.match_length = MIN_MATCH - 1;
            if(hash_head != 0 && this.prev_length < this.max_lazy_match && (this.strstart - hash_head & 0xFFFF) <= this.w_size - MIN_LOOKAHEAD)
            {
               if(this.strategy != Z_HUFFMAN_ONLY)
               {
                  this.match_length = this.longest_match(hash_head);
               }
               if(this.match_length <= 5 && (this.strategy == Z_FILTERED || this.match_length == MIN_MATCH && this.strstart - this.match_start > 4096))
               {
                  this.match_length = MIN_MATCH - 1;
               }
            }
            if(this.prev_length >= MIN_MATCH && this.match_length <= this.prev_length)
            {
               max_insert = this.strstart + this.lookahead - MIN_MATCH;
               bflush = this._tr_tally(this.strstart - 1 - this.prev_match,this.prev_length - MIN_MATCH);
               this.lookahead -= this.prev_length - 1;
               this.prev_length -= 2;
               do
               {
                  if(++this.strstart <= max_insert)
                  {
                     this.ins_h = (this.ins_h << this.hash_shift ^ this.window[this.strstart + (MIN_MATCH - 1)] & 0xFF) & this.hash_mask;
                     hash_head = this.head[this.ins_h] & 0xFFFF;
                     this.prev[this.strstart & this.w_mask] = this.head[this.ins_h];
                     this.head[this.ins_h] = Cast.toShort(this.strstart);
                  }
               }
               while(--this.prev_length != 0);
               
               this.match_available = 0;
               this.match_length = MIN_MATCH - 1;
               ++this.strstart;
               if(bflush)
               {
                  this.flush_block_only(false);
                  if(this.strm.avail_out == 0)
                  {
                     return NeedMore;
                  }
               }
            }
            else if(this.match_available != 0)
            {
               bflush = this._tr_tally(0,this.window[this.strstart - 1] & 0xFF);
               if(bflush)
               {
                  this.flush_block_only(false);
               }
               ++this.strstart;
               --this.lookahead;
               if(this.strm.avail_out == 0)
               {
                  return NeedMore;
               }
            }
            else
            {
               this.match_available = 1;
               ++this.strstart;
               --this.lookahead;
            }
         }
         if(this.match_available != 0)
         {
            bflush = this._tr_tally(0,this.window[this.strstart - 1] & 0xFF);
            this.match_available = 0;
         }
         this.flush_block_only(flush == Z_FINISH);
         if(this.strm.avail_out == 0)
         {
            if(flush == Z_FINISH)
            {
               return FinishStarted;
            }
            return NeedMore;
         }
         return flush == Z_FINISH ? FinishDone : BlockDone;
      }
      
      internal function longest_match(cur_match:int) : int
      {
         var match:int = 0;
         var len:int = 0;
         var chain_length:int = this.max_chain_length;
         var scan:int = this.strstart;
         var best_len:int = this.prev_length;
         var limit:int = this.strstart > this.w_size - MIN_LOOKAHEAD ? this.strstart - (this.w_size - MIN_LOOKAHEAD) : 0;
         var nice_match:int = this.nice_match;
         var wmask:int = this.w_mask;
         var strend:int = this.strstart + MAX_MATCH;
         var scan_end1:uint = uint(this.window[scan + best_len - 1]);
         var scan_end:uint = uint(this.window[scan + best_len]);
         if(this.prev_length >= this.good_match)
         {
            chain_length >>= 2;
         }
         if(nice_match > this.lookahead)
         {
            nice_match = this.lookahead;
         }
         do
         {
            match = cur_match;
            if(!(this.window[match + best_len] != scan_end || this.window[match + best_len - 1] != scan_end1 || this.window[match] != this.window[scan] || this.window[++match] != this.window[scan + 1]))
            {
               scan += 2;
               match++;
               while(this.window[++scan] == this.window[++match] && this.window[++scan] == this.window[++match] && this.window[++scan] == this.window[++match] && this.window[++scan] == this.window[++match] && this.window[++scan] == this.window[++match] && this.window[++scan] == this.window[++match] && this.window[++scan] == this.window[++match] && this.window[++scan] == this.window[++match] && scan < strend)
               {
               }
               len = MAX_MATCH - int(strend - scan);
               scan = strend - MAX_MATCH;
               if(len > best_len)
               {
                  this.match_start = cur_match;
                  best_len = len;
                  if(len >= nice_match)
                  {
                     break;
                  }
                  scan_end1 = uint(this.window[scan + best_len - 1]);
                  scan_end = uint(this.window[scan + best_len]);
               }
            }
         }
         while(cur_match = this.prev[cur_match & wmask] & 0xFFFF, cur_match > limit && --chain_length != 0);
         
         if(best_len <= this.lookahead)
         {
            return best_len;
         }
         return this.lookahead;
      }
      
      public function deflateInitWithBits(strm:ZStream, level:int, bits:int) : int
      {
         return this.deflateInit2(strm,level,Z_DEFLATED,bits,DEF_MEM_LEVEL,Z_DEFAULT_STRATEGY);
      }
      
      public function deflateInit(strm:ZStream, level:int) : int
      {
         return this.deflateInitWithBits(strm,level,MAX_WBITS);
      }
      
      public function deflateInit2(strm:ZStream, level:int, method:int, windowBits:int, memLevel:int, strategy:int) : int
      {
         var noheader:int = 0;
         strm.msg = null;
         if(level == Z_DEFAULT_COMPRESSION)
         {
            level = 6;
         }
         if(windowBits < 0)
         {
            noheader = 1;
            windowBits = -windowBits;
         }
         if(memLevel < 1 || memLevel > MAX_MEM_LEVEL || method != Z_DEFLATED || windowBits < 9 || windowBits > 15 || level < 0 || level > 9 || strategy < 0 || strategy > Z_HUFFMAN_ONLY)
         {
            return Z_STREAM_ERROR;
         }
         strm.dstate = Deflate(this);
         this.noheader = noheader;
         this.w_bits = windowBits;
         this.w_size = 1 << this.w_bits;
         this.w_mask = this.w_size - 1;
         this.hash_bits = memLevel + 7;
         this.hash_size = 1 << this.hash_bits;
         this.hash_mask = this.hash_size - 1;
         this.hash_shift = (this.hash_bits + MIN_MATCH - 1) / MIN_MATCH;
         this.window = new ByteArray();
         this.prev = new Array();
         this.head = new Array();
         this.lit_bufsize = 1 << memLevel + 6;
         this.pending_buf = new ByteArray();
         this.pending_buf_size = this.lit_bufsize * 4;
         this.d_buf = this.lit_bufsize / 2;
         this.l_buf = (1 + 2) * this.lit_bufsize;
         this.level = level;
         this.strategy = strategy;
         this.method = method;
         return this.deflateReset(strm);
      }
      
      internal function deflateReset(strm:ZStream) : int
      {
         strm.total_in = strm.total_out = 0;
         strm.msg = null;
         strm.data_type = Z_UNKNOWN;
         this.pending = 0;
         this.pending_out = 0;
         this.pending_buf = new ByteArray();
         if(this.noheader < 0)
         {
            this.noheader = 0;
         }
         this.status = this.noheader != 0 ? BUSY_STATE : INIT_STATE;
         strm.adler = strm._adler.adler32(0,null,0,0);
         this.last_flush = Z_NO_FLUSH;
         this.tr_init();
         this.lm_init();
         return Z_OK;
      }
      
      internal function deflateEnd() : int
      {
         if(this.status != INIT_STATE && this.status != BUSY_STATE && this.status != FINISH_STATE)
         {
            return Z_STREAM_ERROR;
         }
         this.pending_buf = null;
         this.head = null;
         this.prev = null;
         this.window = null;
         return this.status == BUSY_STATE ? Z_DATA_ERROR : Z_OK;
      }
      
      internal function deflateParams(strm:ZStream, _level:int, _strategy:int) : int
      {
         var err:int = Z_OK;
         if(_level == Z_DEFAULT_COMPRESSION)
         {
            _level = 6;
         }
         if(_level < 0 || _level > 9 || _strategy < 0 || _strategy > Z_HUFFMAN_ONLY)
         {
            return Z_STREAM_ERROR;
         }
         if(config_table[this.level].func != config_table[_level].func && strm.total_in != 0)
         {
            err = strm.deflate(Z_PARTIAL_FLUSH);
         }
         if(this.level != _level)
         {
            this.level = _level;
            this.max_lazy_match = config_table[this.level].max_lazy;
            this.good_match = config_table[this.level].good_length;
            this.nice_match = config_table[this.level].nice_length;
            this.max_chain_length = config_table[this.level].max_chain;
         }
         this.strategy = _strategy;
         return err;
      }
      
      internal function deflateSetDictionary(strm:ZStream, dictionary:ByteArray, dictLength:int) : int
      {
         var length:int = dictLength;
         var index:int = 0;
         if(dictionary == null || this.status != INIT_STATE)
         {
            return Z_STREAM_ERROR;
         }
         strm.adler = strm._adler.adler32(strm.adler,dictionary,0,dictLength);
         if(length < MIN_MATCH)
         {
            return Z_OK;
         }
         if(length > this.w_size - MIN_LOOKAHEAD)
         {
            length = this.w_size - MIN_LOOKAHEAD;
            index = dictLength - length;
         }
         System.byteArrayCopy(dictionary,index,this.window,0,length);
         this.strstart = length;
         this.block_start = length;
         this.ins_h = this.window[0] & 0xFF;
         this.ins_h = (this.ins_h << this.hash_shift ^ this.window[1] & 0xFF) & this.hash_mask;
         for(var n:int = 0; n <= length - MIN_MATCH; n++)
         {
            this.ins_h = (this.ins_h << this.hash_shift ^ this.window[n + (MIN_MATCH - 1)] & 0xFF) & this.hash_mask;
            this.prev[n & this.w_mask] = this.head[this.ins_h];
            this.head[this.ins_h] = Cast.toShort(n);
         }
         return Z_OK;
      }
      
      public function deflate(strm:ZStream, flush:int) : int
      {
         var old_flush:int = 0;
         var header:int = 0;
         var level_flags:int = 0;
         var bstate:int = 0;
         var i:int = 0;
         if(flush > Z_FINISH || flush < 0)
         {
            return Z_STREAM_ERROR;
         }
         if(strm.next_out == null || strm.next_in == null && strm.avail_in != 0 || this.status == FINISH_STATE && flush != Z_FINISH)
         {
            strm.msg = this.z_errmsg[Z_NEED_DICT - Z_STREAM_ERROR];
            return Z_STREAM_ERROR;
         }
         if(strm.avail_out == 0)
         {
            strm.msg = this.z_errmsg[Z_NEED_DICT - Z_BUF_ERROR];
            return Z_BUF_ERROR;
         }
         this.strm = strm;
         old_flush = this.last_flush;
         this.last_flush = flush;
         if(this.status == INIT_STATE)
         {
            header = Z_DEFLATED + (this.w_bits - 8 << 4) << 8;
            level_flags = (this.level - 1 & 0xFF) >> 1;
            if(level_flags > 3)
            {
               level_flags = 3;
            }
            header |= level_flags << 6;
            if(this.strstart != 0)
            {
               header |= PRESET_DICT;
            }
            header += 31 - header % 31;
            this.status = BUSY_STATE;
            this.putShortMSB(header);
            if(this.strstart != 0)
            {
               this.putShortMSB(int(strm.adler >>> 16));
               this.putShortMSB(int(strm.adler & 0xFFFF));
            }
            strm.adler = strm._adler.adler32(0,null,0,0);
         }
         if(this.pending != 0)
         {
            strm.flush_pending();
            if(strm.avail_out == 0)
            {
               this.last_flush = -1;
               return Z_OK;
            }
         }
         else if(strm.avail_in == 0 && flush <= old_flush && flush != Z_FINISH)
         {
            strm.msg = this.z_errmsg[Z_NEED_DICT - Z_BUF_ERROR];
            return Z_BUF_ERROR;
         }
         if(this.status == FINISH_STATE && strm.avail_in != 0)
         {
            strm.msg = this.z_errmsg[Z_NEED_DICT - Z_BUF_ERROR];
            return Z_BUF_ERROR;
         }
         if(strm.avail_in != 0 || this.lookahead != 0 || flush != Z_NO_FLUSH && this.status != FINISH_STATE)
         {
            bstate = -1;
            switch(config_table[this.level].func)
            {
               case STORED:
                  bstate = this.deflate_stored(flush);
                  break;
               case FAST:
                  bstate = this.deflate_fast(flush);
                  break;
               case SLOW:
                  bstate = this.deflate_slow(flush);
            }
            if(bstate == FinishStarted || bstate == FinishDone)
            {
               this.status = FINISH_STATE;
            }
            if(bstate == NeedMore || bstate == FinishStarted)
            {
               if(strm.avail_out == 0)
               {
                  this.last_flush = -1;
               }
               return Z_OK;
            }
            if(bstate == BlockDone)
            {
               if(flush == Z_PARTIAL_FLUSH)
               {
                  this._tr_align();
               }
               else
               {
                  this._tr_stored_block(0,0,false);
                  if(flush == Z_FULL_FLUSH)
                  {
                     for(i = 0; i < this.hash_size; )
                     {
                        this.head[i] = 0;
                        i++;
                     }
                  }
               }
               strm.flush_pending();
               if(strm.avail_out == 0)
               {
                  this.last_flush = -1;
                  return Z_OK;
               }
            }
         }
         if(flush != Z_FINISH)
         {
            return Z_OK;
         }
         if(this.noheader != 0)
         {
            return Z_STREAM_END;
         }
         this.putShortMSB(int(strm.adler >>> 16));
         this.putShortMSB(int(strm.adler & 0xFFFF));
         strm.flush_pending();
         this.noheader = -1;
         return this.pending != 0 ? Z_OK : Z_STREAM_END;
      }
   }
}

