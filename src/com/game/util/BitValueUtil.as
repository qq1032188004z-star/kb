package com.game.util
{
   import com.publiccomponent.loading.XMLLocator;
   
   public class BitValueUtil
   {
      
      public function BitValueUtil()
      {
         super();
      }
      
      public static function getBitValue(src:int, bit:int) : Boolean
      {
         var flag:Boolean = false;
         if(bit > 0 && bit < 32)
         {
            flag = (src & 1 << bit - 1) > 0 ? true : false;
         }
         return flag;
      }
      
      public static function setBitValue(src:int, bit:int, status:Boolean) : int
      {
         var tmp:int = 0;
         var flag:Boolean = false;
         if(bit > 0 && bit < 32)
         {
            tmp = 1 << bit - 1;
            if(status)
            {
               src |= tmp;
            }
            else
            {
               src &= ~tmp;
            }
            flag = true;
         }
         return src;
      }
      
      public static function getToolBitValue(toolid:int, bit:int) : Boolean
      {
         var src:int = int(XMLLocator.getInstance().tooldic[toolid].useState);
         var flag:Boolean = false;
         if(bit > 0 && bit < 32)
         {
            flag = (src & 1 << bit - 1) > 0 ? true : false;
         }
         return flag;
      }
   }
}

