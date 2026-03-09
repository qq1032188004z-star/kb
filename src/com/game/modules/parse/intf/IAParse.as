package com.game.modules.parse.intf
{
   import com.game.modules.vo.ActivityVo;
   import flash.utils.ByteArray;
   
   public interface IAParse
   {
      
      function parse(param1:ActivityVo, param2:ByteArray) : void;
   }
}

