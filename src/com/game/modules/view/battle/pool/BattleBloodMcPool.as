package com.game.modules.view.battle.pool
{
   import com.xygame.module.battle.util.NewBloodMc;
   import flash.display.MovieClip;
   
   public class BattleBloodMcPool
   {
      
      private static var _instance:BattleBloodMcPool;
      
      private var _pool:Vector.<NewBloodMc>;
      
      private var _maxSize:int;
      
      private var _createCount:int;
      
      private var _recycleCount:int;
      
      public function BattleBloodMcPool()
      {
         super();
         this._pool = new Vector.<NewBloodMc>();
         this._maxSize = 20;
         this._createCount = 0;
         this._recycleCount = 0;
      }
      
      public static function get instance() : BattleBloodMcPool
      {
         if(!_instance)
         {
            _instance = new BattleBloodMcPool();
         }
         return _instance;
      }
      
      public function get() : NewBloodMc
      {
         var blood:NewBloodMc = null;
         if(this._pool.length > 0)
         {
            blood = this._pool.pop();
            blood.reset();
            if(!this.validateReset(blood))
            {
               O.o("BattleBloodMcPool"," 重置验证失败，创建新实例");
               blood = this.createNew();
            }
         }
         else
         {
            blood = this.createNew();
         }
         return blood;
      }
      
      private function createNew() : NewBloodMc
      {
         ++this._createCount;
         O.o("BattleBloodMcPool"," 创建新实例，总数：" + this._createCount);
         return new NewBloodMc();
      }
      
      private function validateReset(blood:NewBloodMc) : Boolean
      {
         if(blood.numChildren > 0)
         {
            O.o("BattleBloodMcPool"," 警告：重置后仍有子对象，数量：" + blood.numChildren);
            return false;
         }
         if(blood.scaleX != 1 || blood.scaleY != 1)
         {
            O.o("BattleBloodMcPool"," 警告：缩放未重置");
            return false;
         }
         if(!blood.visible)
         {
            O.o("BattleBloodMcPool"," 警告：可见性未重置");
            return false;
         }
         return true;
      }
      
      public function recycle(blood:NewBloodMc) : void
      {
         if(!blood)
         {
            return;
         }
         if(Boolean(blood.parent))
         {
            blood.parent.removeChild(blood);
         }
         if(this._pool.length < this._maxSize)
         {
            ++this._recycleCount;
            this._pool.push(blood);
            if(this._recycleCount % 10 == 0)
            {
               O.o("BattleBloodMcPool"," 回收统计 - 池大小：" + this._pool.length + "，总创建：" + this._createCount + "，总回收：" + this._recycleCount);
            }
         }
         else
         {
            this.destroyBlood(blood);
         }
      }
      
      private function destroyBlood(blood:NewBloodMc) : void
      {
         var child:* = undefined;
         while(blood.numChildren > 0)
         {
            child = blood.getChildAt(0);
            if(child is MovieClip)
            {
               MovieClip(child).stop();
            }
            blood.removeChildAt(0);
         }
      }
      
      public function clear() : void
      {
         var blood:NewBloodMc = null;
         O.o("BattleBloodMcPool"," 清空对象池，当前数量：" + this._pool.length);
         while(this._pool.length > 0)
         {
            blood = this._pool.pop();
            this.destroyBlood(blood);
         }
         this._createCount = 0;
         this._recycleCount = 0;
      }
      
      public function prewarm(count:int = 5) : void
      {
         var blood:NewBloodMc = null;
         O.o("BattleBloodMcPool"," 预创建 " + count + " 个实例");
         for(var i:int = 0; i < count; i++)
         {
            blood = new NewBloodMc();
            blood.reset();
            this._pool.push(blood);
         }
         this._createCount += count;
      }
      
      public function set maxSize(value:int) : void
      {
         var blood:NewBloodMc = null;
         this._maxSize = value;
         while(this._pool.length > this._maxSize)
         {
            blood = this._pool.pop();
            this.destroyBlood(blood);
         }
      }
      
      public function getStats() : String
      {
         return "池大小：" + this._pool.length + "，最大：" + this._maxSize + "，总创建：" + this._createCount + "，总回收：" + this._recycleCount;
      }
   }
}

