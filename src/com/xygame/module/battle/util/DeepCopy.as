package com.xygame.module.battle.util
{
   import flash.utils.ByteArray;
   
   public class DeepCopy
   {
      
      public function DeepCopy()
      {
         super();
      }
      
      public static function copy(obj:*) : *
      {
         var temp:* = undefined;
         var copier:ByteArray = new ByteArray();
         copier.writeObject(obj);
         copier.position = 0;
         return copier.readObject();
      }
   }
}

