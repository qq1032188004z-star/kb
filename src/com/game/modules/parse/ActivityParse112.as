package com.game.modules.parse
{
   import com.game.modules.parse.intf.IAParse;
   import com.game.modules.vo.ActivityVo;
   import flash.utils.ByteArray;
   
   public class ActivityParse112 implements IAParse
   {
      
      public function ActivityParse112()
      {
         super();
      }
      
      public function parse($vo:ActivityVo, $byte:ByteArray) : void
      {
         if($vo.protocolID == 1)
         {
            $vo.valueobject.mp = $byte.readInt();
            $vo.valueobject.selectedMonsterid = $byte.readInt();
         }
         else if($vo.protocolID == 2)
         {
            $vo.valueobject.result = $byte.readInt();
            $vo.valueobject.mp = $byte.readInt();
            $vo.valueobject.monsterid = $byte.readInt();
         }
         else if($vo.protocolID != 3)
         {
            if($vo.protocolID == 4)
            {
               $vo.valueobject.result = $byte.readInt();
               $vo.valueobject.mp = $byte.readInt();
               $vo.valueobject.kbcoin = $byte.readInt();
            }
            else if($vo.protocolID == 5)
            {
               $vo.valueobject.result = $byte.readInt();
            }
            else if($vo.protocolID == 6)
            {
               $vo.valueobject.result = $byte.readInt();
            }
            else if($vo.protocolID == 7)
            {
               $vo.valueobject.mp = $byte.readInt();
            }
         }
      }
   }
}

